local Cache = require "digestif.Cache"
local Manuscript = require "digestif.Manuscript"
local config = require "digestif.config"
local json = require "dkjson"
local util = require "digestif.util"

local log = util.log
local nested_get, nested_put = util.nested_get, util.nested_put
local path_join, path_split = util.path_join, util.path_split

local cache = Cache()
local null = json.null
local root_dir, client_capabilities

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

-- ¶ Convert LSP API objects to/from internal representations

local function from_Range(filename, range)
  local src = cache:get(filename) or error("File " .. filename .. " not found")
  local lines = cache:line_indices(filename)
  local l1, c1 = range.start.line + 1, range.start.character + 1
  local l2, c2 = range["end"].line + 1, range["end"].character + 1
  local pos = utf8.offset(src, c1, lines[l1]) -- inclusive
  local cont = utf8.offset(src, c2, lines[l2]) -- exclusive
  if not (pos and cont) then error("Position out of bounds") end
  return pos, cont
end

--- Convert from a TextDocumentPositionParams object
--@param arg a TextDocumentPositionParam object
--@return a position in bytes, filename, root's filename
local function from_TextDocumentPositionParams(arg)
  local filename = unescape_uri(arg.textDocument.uri)
  local format = cache:get_property(filename, "tex_format")
  local script = cache:manuscript(filename, format)
  local l, c = arg.position.line + 1, arg.position.character + 1
  return script, script:position_at(l, c)
end

local function to_Range(item)
  local script = item.manuscript
  local l1, c1 = script:line_column_at(item.pos)
  local l2, c2 = script:line_column_at(item.cont)
  return {
    start = {line = l1 - 1, character = c1 - 1},
    ["end"] = {line = l2 - 1, character = c2 - 1},
  }
end

local function to_Location(item)
  return {
    uri = escape_uri(item.manuscript.filename),
    range = to_Range(item)
  }
end

local function to_MarkupContent(str)
  return {kind = "markdown", value = str}
end

local function to_TextEdit(script, pos, old, new)
  local l, c_start = script:line_column_at(pos)
  local c_end = c_start + utf8.len(old)
  return {
    range = {
      start = {line = l - 1, character = c_start - 1},
      ["end"] = {line = l - 1, character = c_end - 1},
    },
    newText = new
  }
end

local languageId_table = {
  bibtex = "bibtex",
  context = "context",
  latex = "latex",
  plain = "plain",
  plaintex = "plain",
  ["plain-tex"] = "plain",
  tex = "latex", -- this is for vim; maybe "tex" should mean "tex file, undecided format"
  texinfo = "texinfo"
}

-- ¶ LSP methods

local methods = {}

methods["initialize"] = function(params)
  if params.trace == "verbose" then config.verbose = true end
  root_dir = unescape_uri(params.rootUri)
  client_capabilities = params.capabilities
  return {
    capabilities = {
      textDocumentSync = {
        openClose = true,
        change = 2
      },
      completionProvider = {
        triggerCharacters = {"\\", "{", "[", ",", "="},
      },
      signatureHelpProvider = {
        triggerCharacters = {"{", "[", "="},
      },
      hoverProvider = true,
      definitionProvider = true,
      referencesProvider = true
    }
  }
end

methods["initialized"] = function() end
methods["shutdown"] = function() return null end
methods["exit"] = function() os.exit() end
methods["workspace/didChangeConfiguration"] = function() end
methods["textDocument/willSave"] = function() end
methods["textDocument/didSave"] = function() end

methods["textDocument/didOpen"] = function(params)
  local filename = unescape_uri(params.textDocument.uri)
  local version = params.textDocument.version
  local tex_format = languageId_table[params.textDocument.languageId]
  if not tex_format then error("Invalid languageId") end
  cache:put(filename, params.textDocument.text)
  cache:put_property(filename, "tex_format", tex_format)
  cache:put_property(filename, "version", version)
end

methods["textDocument/didChange"] = function(params)
  local filename = unescape_uri(params.textDocument.uri)
  local tex_format = cache:get_property(filename, "tex_format")
  for _, change in ipairs(params.contentChanges) do
    if change.range then
      local src = cache:get(filename)
      local pos, cont = from_Range(filename, change.range)
      if change.rangeLength ~= utf8.len(src, pos, cont - 1) then
        error("Range length mismatch in textdocument/didChange operation")
      end
      src = src:sub(1, pos - 1) .. change.text .. src:sub(cont)
      cache:put(filename, src)
    else
      cache:put(filename, change.text)
    end
  end
  cache:put_property(filename, "tex_format", tex_format)
  cache:put_property(filename, "version", params.textDocument.version)
end

methods["textDocument/didClose"] = function(params)
  local filename = unescape_uri(params.textDocument.uri)
  local rootname = cache:rootname(filename)
  if rootname then cache:forget(rootname) end
  -- FIX: If root name changed during the life of a document, the old
  -- cached root manuscript will be kept forever.
  cache:forget(filename)
end

methods["textDocument/signatureHelp"] = function(params)
  local script, pos = from_TextDocumentPositionParams(params)
  local help = script:get_help(pos)
  if not nested_get(help, "data", "arguments") then return null end
  local parameters = {}
  for i, arg in ipairs(help.data.arguments) do
    parameters[i] = {
      label = arg.meta,
      documentation = arg.summary
    }
  end
  return {
    signatures = {
      [1] = {
        label = help.label,
        documentation = help.summary,
        parameters = parameters
      }
    },
    activeSignature = 0,
    activeParameter = help.arg and help.arg - 1
  }
end

methods["textDocument/hover"] = function(params)
  local script, pos = from_TextDocumentPositionParams(params)
  local help = script:get_help(pos)
  if (not help) or help.arg then return null end
  local contents = help.details or help.summary or "???"
  return {contents = to_MarkupContent(contents)}
end

methods["textDocument/completion"] = function(params)
  local script, pos = from_TextDocumentPositionParams(params)
  local candidates = script:complete(pos)
  if not candidates then return null end
  local with_snippets = nested_get(client_capabilities,
                                   "textDocument",
                                   "completion",
                                   "completionItem",
                                   "snippetSupport")
  local result = {}
  for i, cand in ipairs(candidates) do
    local snippet = with_snippets and cand.snippet
    result[i] = {
      label = cand.text,
      filterText = candidates.prefix, -- Workaround to allow “flex matching”
      sortText=("%05x"):format(i), -- Workaround to avoid client re-sorting
      documentation = cand.summary,
      detail = cand.detail,
      insertTextFormat = snippet and 2 or 1,
      textEdit = to_TextEdit(script,
                             candidates.pos,
                             candidates.prefix,
                             snippet or cand.text)
    }
  end
  return result
end

methods["textDocument/definition"] = function(params)
  local script, pos = from_TextDocumentPositionParams(params)
  local definition = script:find_definition(pos)
  return definition and to_Location(definition) or null
end

methods["textDocument/references"] = function(params)
  local script, pos = from_TextDocumentPositionParams(params)
  local result = {}
  if params.context and params.context.includeDeclaration then
    local definition = script:find_definition(pos)
    if definition then
      result[#result + 1] = to_Location(definition)
    end
  end
  local references = script:find_references(pos)
  if references then
    for _, ref in ipairs(references) do
      result[#result + 1] = to_Location(ref)
    end
  end
  if #result > 0 then
    return result
  else
    return null
  end
end

-- ¶ RPC functions and the main loop

local function log_error(err)
  if config.verbose then
    log("Error:", err)
    log(debug.traceback())
  end
  return err
end

local function write_msg(msg)
  io.write("Content-Length: ", #msg, "\r\n\r\n", msg)
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
  local success, request = xpcall(json.decode, log_error, msg)
  if not success then
    rpc_send(json.null, request, -32700)
    return
  end
  return request.id, request.method, request.params
end

local is_optional = util.matcher("$/")

local function process_request()
  local clock = config.verbose and os.clock()
  local id, method_name, params = rpc_receive()
  local method = methods[method_name]
  if method then
    local success, result = xpcall(method, log_error, params)
    if success then
      if id then rpc_send(id, result) end
    else
      rpc_send(id, result, 1)
    end
  elseif not is_optional(method_name) then
    rpc_send(id, "Unknown method " .. method_name, -32601)
  end
  if config.verbose then
    log(string.format("Request: %4s %-40s %6.2f ms",
                      id or "*", method_name, (os.clock() - clock) * 1000))
  end
end

local function main(...)
  if ... == "-v" then config.verbose = true end
  local DIGESTIFDATA = os.getenv("DIGESTIFDATA")
  if DIGESTIFDATA then
    config.data_dirs = util.split";"(DIGESTIFDATA)
  end
  if not require("digestif.data").require("primitives") then
    error("Could not find data files at the following locations:\n- "
            .. table.concat(config.data_dirs, "\n- ")
            .. "\nSet the environment variable DIGESTIFDATA to fix this.")
  end
  if config.verbose then
    log("\n━━━━━━ digestif started! ━━━━━━━━━━━━━━", os.date())
  end
  while true do process_request() end
end

return {
  main = main,
  methods = methods
}

