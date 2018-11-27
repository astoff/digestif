local json = require(pcall(require, "cjson") and "cjson" or "dkjson")
local util = require "digestif.util"

--[[-- globals for debugging
see = require'serpent'.block
log = util.log
pcall = function(fn, ...)
   return xpcall(
      fn,
      function(err)
         log("=== Stack trace ================================================================")
         log(tostring(err))
         log("================================================================================")
      end,
      ...)
end
--]]--

util.log("\n\n\n\n\n\n=== Started!! ===", os.date(), "=============")

-- JSONRPC functions

local function write_msg(msg)
   io.write("Content-Length: " .. #msg .. "\r\n\r\n" .. msg)
   io.flush()
end

local function read_msg()
   local headers, msg = {}, nil
   for h in io.lines() do
      if h == "" or h == "\r" then break end
      local k, v = string.match(h, "^([%a%-]+): (.*)")
      if k then headers[k] = v end
   end
   local len = tonumber(headers["Content-Length"])
   if len then msg = io.read(len) end
   return msg, headers
end

local function rpc_send(id, result, error_code)
   write_msg(
      json.encode({
            jsonrpc = "2.0",
            id = id,
            result = not error_code and result,
            error = error_code and {code = error_code, message = result}
   }))
end

local function rpc_receive()
   local msg = read_msg()
   local success, request = pcall(json.decode, msg)
   if not success then
      util.log("Error: " .. request .. "\n")
      rpc_send(null, request, -32700)
      return
   end
   return request.id, request.method, request.params
end

local Document = require "digestif.Document"
local FileCache = require "digestif.FileCache"
local Manuscript = require "digestif.Manuscript"
local util = require "digestif.util"

local cache = FileCache()
local null = json.null
local trace, root_dir, client_capabilities

local function hex_to_char(hex)
   return string.format('%c', tonumber(hex, 16))
end

local function unescape_uri(s)
   s = s:match("^file://(.*)") or error("Invalid URI: " .. s)
   return s:gsub('%%(%x%x)', hex_to_char), nil
end

local function escape_uri(s)
   return "file://" .. s
end

local function get_document(filename)
   return Document{
      root = Manuscript{
         filename = filename,
         cache = cache
      },
      filename = filename,
      cache = cache
   }
end
get_document = cache:memoize(get_document)

local function get_root(filename)
   local root = util.find_root(cache:get(filename))
   return root and util.split_filename(filename) .. root or filename
end
get_root = cache:memoize(get_root)

local function get_lines(filename)
   local src, lines = cache:get(filename), {}
   for i, j in util.lines(src) do
      lines[i] = j
   end
   return lines
end
get_lines = cache:memoize(get_lines)

local function get_line_col(filename, pos)
   local src = cache:get(filename) or error("File " .. filename .. " not found")
   local lines = get_lines(filename)
   local j, l = 1, #lines -- top and bottom bounds for line search
   while pos < lines[l] do
      local k = (j + l + 1) // 2
      if pos < lines[k] then
         l = k - 1
      else
         j = k
      end
   end -- now l = correct line, 1-based indexing
   local c = utf8.len(src, lines[l], pos) or error("Invalid UTF-8")
   return l, c
end

--- Convert LSP API objects to/from internal representations

--@param arg a TextDocumentPositionParam object
--@return a position in bytes, filename, root's filename
local function from_TextDocumentPositionParams(arg)
   local filename = unescape_uri(arg.textDocument.uri)
   local src = cache:get(filename) or error("File " .. filename .. " not found")
   local pos = 1
   for i = 1, arg.position.line do
      pos = src:match("\r?\n()", pos) or error("Position out of bounds")
   end
   pos = utf8.offset(src, arg.position.character + 1, pos)
   return pos or error("Position out of bounds"), filename, get_root(filename)
end

-- local function to_TextDocumentPositionParams(pos, filename)
--    assert(pos > 0, "Position out of bounds")
--    local src = cache:get(filename) or error("File " .. filename .. " not found")
--    local lines = get_lines(filename)
--    local j, l = 1, #lines -- top and bottom bounds for line search
--    while pos < lines[l] do
--       local k = (j + l + 1) // 2
--       if pos < lines[k] then
--          l = k - 1
--       else
--          j = k
--       end
--    end -- now l = correct line, 1-based indexing
--    local c = utf8.len(src, lines[l], pos) or error("Invalid UTF-8")
--    return {
--       textDocument = {uri = escape_uri(filename)},
--       position = {
--          line = l - 1,
--          column = c - 1
--       }
--    }
-- end

local function to_MarkupContent(str)
   return {kind = "plaintext", value = str}
end

local function to_TextEdit(filename, pos, old, new)
   local l, c_start = get_line_col(filename, pos)
   local c_end = c_start + utf8.len(old)
   return {
      range = {
         start = {line = l - 1, character = c_start - 1},
         ["end"] = {line = l - 1, character = c_end - 1},
      },
      newText = new
   }
end

--- LSP methods

local methods = {}

methods['initialize'] = function(params)
   trace = (params.trace == null) and 0 or params.trace
   root_dir = unescape_uri(params.rootUri)
   client_capabilities = params.capabilities
   return {
      capabilities = {
         textDocumentSync = 1, --[[{
            openClose = true,
            change = 1
         },--]]
         completionProvider = {
            triggerCharacters = {"\\", "{", "["},
         },
         signatureHelpProvider = {
            triggerCharacters = {"\\", "="},
         },
         hoverProvider = true,
         -- documentSymbolProvider = true,
         --definitionProvider = true,
      }
   }
end

methods['initialized'] = function() return end

methods['shutdown'] = function() return null end

methods['exit'] = function() os.exit() end

methods['textDocument/didOpen'] = function(params)
   local filename = unescape_uri(params.textDocument.uri)
   local src = params.textDocument.text
   cache:put(filename, src)
end

methods['textDocument/didChange'] = function(params)
   local filename = unescape_uri(params.textDocument.uri)
   for _, change in ipairs(params.contentChanges) do
      cache:put(filename, change.text) --make checks, implement incremental
   end
   get_document(filename):refresh()
end

methods["textDocument/didClose"] = function(params)
   local filename = unescape_uri(params.textDocument.uri)
   cache:forget(filename)
end

methods["textDocument/signatureHelp"] = function(params)
   local pos, filename, rootname = from_TextDocumentPositionParams(params)
   local doc = get_document(rootname)
   local help = doc:get_help(pos, filename)
   return not help and null or {
      signatures = {
         [1] = {
            label = help.text,
            documentation = help.data and help.data.doc,
            parameters = util.map(
               function (arg)
                  return {
                     label = arg.meta,
                     documentation = arg.doc
                  }
               end,
               help.data and help.data.args or {}),
         }
      },
      activeSignature = 0,
      activeParameter = help.arg and help.arg - 1
   }
end

methods["textDocument/hover"] = function(params)
   local pos, filename, rootname = from_TextDocumentPositionParams(params)
   local doc = get_document(rootname)
   local help = doc:get_help(pos, filename)
   return help and {contents = to_MarkupContent(help.text)} or null
end

methods["textDocument/completion"] = function(params)
   local pos, filename, rootname = from_TextDocumentPositionParams(params)
   local doc = get_document(rootname)
   doc:refresh()
   --doc:resolve()
   local candidates = doc:complete(pos, filename)
   if not candidates then return null end
   local with_snippets = util.safe_get(client_capabilities,
                                       "textDocument",
                                       "completion",
                                       "completionItem",
                                       "snippetSupport")
   local result = {}
   for i, cand in ipairs(candidates) do
      local snippet = with_snippets and cand.snippet
      result[i] = {
         label = cand.text,
         documentation = cand.summary,
         detail = cand.signature,
         insertTextFormat = snippet and 2 or 1,
         textEdit = to_TextEdit(filename,
                                candidates.pos,
                                candidates.prefix,
                                snippet or cand.text)
      }
   end
   return result
end

-- Main loop

local function process_request()
   local clock = os.clock()
   local id, method_name, params = rpc_receive()
   local method = methods[method_name]
   if not method then
      if not method_name:match("^%$/") then
         util.log("Error: method " .. method_name .. " does not exist\n")
         rpc_send(id, "method " .. method_name .. " does not exist", -32601)
      end
      return
   end
   local success, result = pcall(method, params)
   if not success then
      rpc_send(id, result, 1)
      return
   end
   if id then
      rpc_send(id, result)
   end
   util.log("Request:", method_name, id or '',
          "time: " .. (os.clock() - clock) * 1000 .. "ms")
end

while true do process_request() end
