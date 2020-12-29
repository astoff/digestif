local config = require "digestif.config"
local util = require "digestif.util"

local imap, nested_get, lines = util.imap, util.nested_get, util.lines
local parse_uri, make_uri = util.parse_uri, util.make_uri
local log = util.log

-- Use cjson if available, otherwise fall back to `digestif.util`
-- implementation.
local null, json_decode, json_encode
if pcall(require, "cjson") then
  local cjson = require "cjson"
  cjson.encode_empty_table_as_object(false)
  null = cjson.null
  json_decode, json_encode = cjson.decode, cjson.encode
else
  null = util.json_null
  json_decode, json_encode = util.json_decode, util.json_encode
end

--* Convert LSP API objects to/from internal representations

-- This will be a digestif.Cache object.  Its initialization is
-- deferred to `initialized` method.
local cache = setmetatable({}, {
    __index = function () error "Server not initialized!" end
})

-- a place to store the tex_format/languageId of open files
local tex_format_table = setmetatable({}, {
  __index = function(_, k)
    error(("Trying to access unopened file %s"):format(k))
  end
})

-- TODO: deal with weird path separators
local function from_DocumentUri(str)
  local scheme, auth, path, query, fragment = parse_uri(str)
  if scheme ~= "file" or (auth and auth ~= "") or query or fragment then
    error("Invalid or unsupported URI: " .. str)
  end
  return path
end

local function to_DocumentUri(str)
  return make_uri("file", "", str)
end

-- p0 is the position of a line l0, provided as a hint for the search.
-- Return a position in bytes, and a new hint p0, l0.
local function from_Position(str, position, p0, l0)
  local l, c = position.line + 1, position.character + 1
  if l0 and l0 > l then p0, l0 = nil, nil end
  for n, i in lines(str, p0, l0) do
    if n == l then
      return utf8.offset(str, c, i), i, l
    end
  end
end

local function from_Range(str, range, p0, l0)
  local pos, p1, l1 = from_Position(str, range.start, p0, l0) -- inclusive
  local cont = from_Position(str, range['end'], p1, l1) -- exclusive
  if not (pos and cont) then error("Position out of bounds") end
  return pos, cont, p1, l1
end

local function from_TextDocumentIdentifier(arg)
  local filename = from_DocumentUri(arg.uri)
  local format = tex_format_table[filename]
  local script = cache:manuscript(filename, format)
  return script
end

local function from_TextDocumentPositionParams(arg)
  local filename = from_DocumentUri(arg.textDocument.uri)
  local format = tex_format_table[filename]
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
    uri = to_DocumentUri(item.manuscript.filename),
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

local to_SymbolKind = {
  section = 5 -- Class in LSP
}

local function to_DocumentSymbol(outline)
  return {
    name = outline.name,
    kind = to_SymbolKind[outline.kind],
    range = to_Range(outline),
    selectionRange = to_Range(outline),
    children = outline[1] and imap(to_DocumentSymbol, outline)
  }
end

local languageId_translation_table = {
  bibtex = "bibtex",
  context = "context",
  latex = "latex",
  plain = "plain",
  plaintex = "plain",
  ["plain-tex"] = "plain",
  tex = "latex", -- this is for vim; maybe "tex" should mean "tex file, undecided format"
  texinfo = "texinfo"
}

--* LSP methods

local methods = {}

methods["initialize"] = function(params)
  if params.trace == "verbose" then config.verbose = true end
  config.provide_snippets = nested_get(params.capabilities,
    "textDocument", "completion", "completionItem", "snippetSupport")
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
      referencesProvider = true,
      documentSymbolProvider = true,
    }
  }
end

methods["initialized"] = function()
  cache = require "digestif.Cache"()
end

methods["shutdown"] = function() return null end
methods["exit"] = function() os.exit() end
methods["workspace/didChangeConfiguration"] = function() end
methods["textDocument/willSave"] = function() end
methods["textDocument/didSave"] = function() end

methods["textDocument/didOpen"] = function(params)
  local filename = from_DocumentUri(params.textDocument.uri)
  local format = languageId_translation_table[params.textDocument.languageId]
  if not format then
    error(("Invalid languageId %q"):format(params.textDocument.languageId))
  end
  tex_format_table[filename] = format
  cache:put(filename, params.textDocument.text)
end

methods["textDocument/didChange"] = function(params)
  local filename = from_DocumentUri(params.textDocument.uri)
  local p0, l0, src = 1, 1, cache(filename)
  for _, change in ipairs(params.contentChanges) do
    if change.range then
      local pos, cont
      pos, cont, p0, l0 = from_Range(src, change.range, p0, l0)
      if change.rangeLength ~= utf8.len(src, pos, cont - 1) then
        error("Range length mismatch in textdocument/didChange operation")
      end
      src = src:sub(1, pos - 1) .. change.text .. src:sub(cont)
    else
      src = change.text
    end
  end
  cache:put(filename, src)
end

methods["textDocument/didClose"] = function(params)
  local filename = from_DocumentUri(params.textDocument.uri)
  cache:forget(filename)
end

methods["textDocument/signatureHelp"] = function(params)
  local script, pos = from_TextDocumentPositionParams(params)
  local help = script:describe(pos)
  if not help or not help.arg then return null end
  local parameters, label_positions = {}, help.label_positions or {}
  for i, arg in ipairs(nested_get(help, "data", "arguments") or {}) do
    parameters[i] = {
      label = {label_positions[2*i-1] - 1, label_positions[2*i] - 1},
      documentation = arg.summary
    }
  end
  return {
    signatures = {
      [1] = {
        label = help.label,
        documentation = help.summary,
        parameters = parameters,
        activeParameter = help.arg - 1
      }
    },
    activeSignature = 0,
    activeParameter = help.arg - 1
  }
end

methods["textDocument/hover"] = function(params)
  local script, pos = from_TextDocumentPositionParams(params)
  local help = script:describe(pos)
  if (not help) or help.arg then return null end
  local contents = help.details or help.summary or "???"
  return {contents = to_MarkupContent(contents)}
end

methods["textDocument/completion"] = function(params)
  local script, pos = from_TextDocumentPositionParams(params)
  local candidates = script:complete(pos)
  if not candidates then return null end
  local result = {}
  for i, cand in ipairs(candidates) do
    local snippet = config.provide_snippets and cand.snippet
    result[i] = {
      label = cand.text,
      filterText = candidates.prefix, -- Workaround to allow “flex matching”
      sortText=("%05x"):format(i), -- Workaround to avoid client re-sorting
      documentation = cand.summary,
      detail = cand.annotation,
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

methods["textDocument/documentSymbol"] = function(params)
  local script = from_TextDocumentIdentifier(params.textDocument)
  local outline = script:outline(true) -- local only
  return imap(to_DocumentSymbol, outline)
end

--* RPC functions

local function log_error(err)
  if config.verbose then
    log("Error: %s", err)
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
    json_encode({
        jsonrpc = "2.0",
        id = id,
        result = not error_code and result,
        error = error_code and {code = error_code, message = result}
  }))
end

local function rpc_receive()
  local msg = read_msg()
  local success, request = xpcall(json_decode, log_error, msg)
  if not success then
    rpc_send(null, request, -32700)
    return
  end
  return request.id, request.method, request.params
end

--* The main loop

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
  if clock then
    log("Request: %4s %-40s %6.2f ms",
        id or "*", method_name, 1000 * (os.clock() - clock))
  end
end

local function generate(path)
  if not util.find_file(path) then
    print("Error: file \"" .. path .. "\" not found.")
    os.exit(false)
  end
  local tags_from_manuscript = require "digestif.data".tags_from_manuscript
  local cache = require "digestif.Cache"()
  local manuscript = cache:manuscript(path, "latex-prog")
  local tags = tags_from_manuscript(manuscript)
  local _, basename = util.path_split(path)
  local file = io.open(basename .. ".tags", "w")
  for _, item in ipairs(
    {"generated", "dependencies", "commands", "environments"})
  do
    if tags[item] then
      file:write(item, " = ", util.inspect(tags[item]), "\n")
    end
  end
  local i, j = 0, 0
  for _ in pairs(tags.commands) do i = i + 1 end
  for _ in pairs(tags.environments) do j = j + 1 end
  print(string.format(
          "Generated %s.tags \twith %3i commands and %3i environments.",
          basename, i, j))
end

local usage = [[
Usage: digestif [-h] [-v] [-g FILES]
]]

local help = [[
Digestif is a language server for TeX

Optional arguments:
  -v, --verbose          Enable log output to stderr
  -g, --generate FILES   Generate data file stubs for FILES
  -h, --help             Display this message and quit

Environment variables:
  DIGESTIF_DATA          Paths to look for data files
  DIGESTIF_TEXMF         Paths to look for TeX files
  DIGESTIF_TLPDB         Path to the TeXLive package database file

  If your TeX distribution or Digestif are installed in a non-standard
  location, you may need to set some of the above variables.
]]

local function main(arg)
  -- Set up data path and check if it worked
  local script_path = util.path_split(arg[0])
  if util.find_file(script_path, "../data/primitives.tags") then
    table.insert(config.data_dirs, util.path_join(script_path, '../data'))
  end
  if not util.find_file(config.data_dirs, "primitives.tags") then
    print("Error: could not find data files at the following locations\n  - "
            .. table.concat(config.data_dirs, "\n  - ")
            .. "\nSet the DIGESTIF_DATA environment variable to fix this.")
    os.exit(false)
  end

  while arg[1] do
    local switch = table.remove(arg, 1)
    if switch == "-v" or switch == "--verbose" then
      config.verbose = true
    elseif switch == "-g" or switch == "--generate" then
      for i = 1, #arg do generate(arg[i]) end
      os.exit()
    elseif switch == "-h" or switch == "--help" then
      print(usage)
      print(help)
      os.exit()
    else
      print(usage)
      print("Invalid option: " .. switch)
      os.exit(false)
    end
  end

  if config.verbose then
    log("Digestif started!")
  end

  while true do process_request() end
end

return {
  main = main,
  methods = methods
}

