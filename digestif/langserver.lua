local config = require "digestif.config"
local util = require "digestif.util"

local floor = math.floor
local format = string.format
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
local length_fun, offset_fun = utf8.len, utf8.offset

-- This will be a digestif.Cache object.  Its initialization is
-- deferred to `initialized` method.
local cache = setmetatable({}, {
    __index = function () error "Server not initialized!" end
})

-- A place to store the file name and texformat of open documents.
local open_documents = setmetatable({}, {
  __index = function(_, k)
    error(format("Trying to access unopened document %s", k))
  end
})

local function from_DocumentUri(str)
  local scheme, auth, path, query, fragment = parse_uri(str)
  if scheme ~= "file" or (auth and auth ~= "") or query or fragment then
    error("Invalid or unsupported URI: " .. str)
  end
  if util.os_type == "windows" and path:find("^/%a:") then
    path = path:sub(2)
  end
  return path
end

local function to_DocumentUri(str)
  if util.os_type == "windows" then
    str = str:gsub("[/\\]", "/")
    if str:find("^%a:") then str = "/" .. str end
  end
  return make_uri("file", "", str)
end

-- p0 is the position of a line l0, provided as a hint for the search.
-- Return a position in bytes, and a new hint p0, l0.
local function from_Position(str, position, p0, l0)
  local l, c = position.line + 1, position.character + 1
  if l0 and l0 > l then p0, l0 = nil, nil end
  for n, i in lines(str, p0, l0) do
    if n == l then
      return offset_fun(str, c, i), i, l
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
  local texformat = open_documents[filename]
  local script = cache:manuscript(filename, texformat)
  return script
end

local function from_TextDocumentPositionParams(arg)
  local filename = from_DocumentUri(arg.textDocument.uri)
  local texformat = open_documents[filename]
  local script = cache:manuscript(filename, texformat)
  local l, c = arg.position.line + 1, arg.position.character + 1
  return script, script:position_at(l, c, offset_fun)
end

local function to_Range(item)
  local script = item.manuscript
  local l1, c1 = script:line_column_at(item.pos, length_fun)
  local l2, c2 = script:line_column_at(item.cont, length_fun)
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
  local l, c_start = script:line_column_at(pos, length_fun)
  local c_end = c_start + length_fun(old)
  return {
    range = {
      start = {line = l - 1, character = c_start - 1},
      ["end"] = {line = l - 1, character = c_end - 1},
    },
    newText = new
  }
end

-- An essentially random assignment of symbol kinds, since LSP doesn't
-- support custom kinds.
local to_SymbolKind = {
  section = 5,
  section_index = 5,
  label_index = 7,
  bib_index = 20,
  newcommand_index = 12,
  newenvironment_index = 12
}

local function to_SymbolInformation(item, index_name)
  return {
    name = item.name,
    kind = to_SymbolKind[index_name],
    location = to_Location(item)
  }
end

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
  doctex = "doctex",
  latex = "latex",
  plain = "plain",
  plaintex = "plain",
  ["plain-tex"] = "plain",
  tex = "latex", -- this is for vim; maybe "tex" should mean "tex file, undecided format"
  texinfo = "texinfo"
}

local function languageId_translate(id, filename)
  local ext = filename:sub(-4)
  local texformat = languageId_translation_table[id]
  if not texformat then
    error(("Invalid LSP language id %q"):format(id))
  end
  if texformat == "latex" and (ext == ".sty" or ext == ".cls") then
    return "latex-prog"
  end
  -- TODO: Handle .code.tex files from PGF, .mkiv files from ConTeXt, etc.
  return texformat
end

--* LSP methods

local methods = {}

methods["initialize"] = function(params)
  config.provide_snippets = nested_get(params.capabilities,
    "textDocument", "completion", "completionItem", "snippetSupport")
  if params.initializationOptions then
    config.load_from_table(params.initializationOptions)
  end
  local enc, encodings = nil, nested_get(params.capabilities, "general", "positionEncodings")
  for _, e in ipairs(encodings or {}) do
    if e == "utf-32" then
      enc = e
      break
    elseif e == "utf-8" then
      enc = e
      length_fun = function(s, i, j)
        if i then
          j = j or #s
          if i < 1 or j < i then error("Invalid offset") end
          return j - i + 1
        else
          return #s
        end
      end
      offset_fun = function(s, n, i)
        i = i or n < 0 and #s + 1 or 1
        local v = n + (i or 1) - 1
        if v < 1 or v > #s + 1 then error("Invalid offset") end
        return v
        end
      break
    end
  end
  if not enc and config.verbose then
    log("Digestif and you editor couldn't agree on a fully supported position encoding")
  end
  return {
    capabilities = {
      positionEncoding = enc,
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
      workspaceSymbolProvider = true
    },
    serverInfo = {
      name = "Digestif",
      version = config.version
    }
  }
end

methods["initialized"] = function()
  cache = require "digestif.Cache"()
end

methods["shutdown"] = function() return null end
methods["exit"] = function() os.exit() end
methods["textDocument/willSave"] = function() end
methods["textDocument/didSave"] = function() end

methods["workspace/didChangeConfiguration"] = function(params)
  local settings = params.settings.digestif
  if type(settings) ~= "table" then return end
  config.load_from_table(settings)
end

methods["textDocument/didOpen"] = function(params)
  local filename = from_DocumentUri(params.textDocument.uri)
  local texformat = languageId_translate(params.textDocument.languageId, filename)
  open_documents[filename] = texformat
  cache:put(filename, params.textDocument.text)
end

methods["textDocument/didChange"] = function(params)
  local filename = from_DocumentUri(params.textDocument.uri)
  local p0, l0, src = 1, 1, cache(filename)
  for _, change in ipairs(params.contentChanges) do
    if change.range then
      local pos, cont
      pos, cont, p0, l0 = from_Range(src, change.range, p0, l0)
      src = src:sub(1, pos - 1) .. change.text .. src:sub(cont)
    else
      src = change.text
    end
  end
  cache:put(filename, src)
end

methods["textDocument/didClose"] = function(params)
  local filename = from_DocumentUri(params.textDocument.uri)
  open_documents[filename] = nil
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
  local long_format = config.lsp_long_candidates
    and config.lsp_long_candidates[candidates.kind]
  local items = {}
  for i, cand in ipairs(candidates) do
    local snippet = config.provide_snippets and cand.snippet
    local fuzzy_score = cand.fuzzy_score or nil
    local annotation = cand.annotation
    local long_label = long_format and annotation
      and format(long_format, cand.text, annotation)
    items[i] = {
      label = long_label or cand.text,
      sortText = fuzzy_score and format("~%03d", floor(1000 * (1 - fuzzy_score))),
      documentation = cand.summary,
      detail = not long_label and cand.annotation or nil,
      insertTextFormat = snippet and 2 or 1,
      textEdit = to_TextEdit(
        script,
        candidates.pos,
        candidates.prefix,
        snippet or cand.text
      )
    }
  end
  return items
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

methods["workspace/symbol"] = function(params)
  local query, t = params.query, {}

  -- Find all root documents and sort them
  local root_documents, sorted = {}, {}
  for filename, texformat in pairs(open_documents) do
    local script = cache:manuscript(filename, texformat)
    root_documents[script.root.filename] = script.root
  end

  for filename in pairs(root_documents) do
    sorted[#sorted+1] = filename
  end
  table.sort(sorted)

  -- Gather all entries in all indexes
  for _, filename in ipairs(sorted) do
    local script = root_documents[filename]
    for item, index_name in script:traverse {
      "section_index",
      "label_index",
      "bib_index",
      "newcommand_index",
      "newenvironment_index"
    } do
      if item.name:find(query, 1, true) then
        t[#t+1] = to_SymbolInformation(item, index_name)
      end
    end
  end
  return t
end

--* RPC functions

local function log_error(err)
  if config.verbose then
    log("Error: %s", err)
    log(debug.traceback())
  end
  return err
end

local crlf = util.os_type == "windows" and "\n" or "\r\n"

local function write_msg(msg)
  io.write("Content-Length: ", #msg, crlf, crlf, msg)
  io.flush()
end

local function read_msg()
  local headers = {}
  for line in io.lines() do
    if line == "" or line == "\r" then break end
    local k, v = string.match(line, "^([%a%-]+): (.*)")
    if k then headers[k] = v end
  end
  local len = tonumber(headers["Content-Length"]) or 0
  return io.read(len), headers
end

local function rpc_send(id, result, error_code)
  write_msg(
    json_encode({
        jsonrpc = "2.0",
        id = id,
        result = not error_code and result or nil,
        error = error_code and {code = error_code, message = result}
  }))
end

local function rpc_receive()
  local msg = read_msg()
  local ok, request = xpcall(json_decode, log_error, msg)
  if not ok then
    rpc_send(null, request, -32700)
    os.exit(false)
  end
  if type(request) ~= "table" or type(request.method) ~= "string" then
    rpc_send(null, "Invalid request", -32600)
    os.exit(false)
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
    local ok, result = xpcall(method, log_error, params)
    if ok then
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
  local generate_tags = require "digestif.data".generate_tags
  local tags = generate_tags(path)
  if not tags then
    io.stderr:write(
      format("Error: can't find '%s' or can't generate tags from it.\n", path)
    )
    os.exit(false)
  end
  local _, basename = util.path_split(path)
  local file = io.open(basename .. ".tags", "w")
  for _, item in ipairs(
    {"generated", "dependencies", "documentation", "commands", "environments"})
  do
    if tags[item] then
      file:write(item, " = ", util.inspect(tags[item]), "\n")
    end
  end
  local i, j = 0, 0
  for _ in pairs(tags.commands) do i = i + 1 end
  for _ in pairs(tags.environments) do j = j + 1 end
  io.stderr:write(
    format("Generated %15s.tags with %3i commands and %3i environments.\n",
           basename, i, j)
  )
end

local usage = [[
Usage: digestif [--version] [-h] [-v] [-g FILES]
]]

local help = [[
Digestif is a language server for TeX

Optional arguments:
  -g, --generate FILES   Generate data file stubs for FILES
  -h, --help             Display this message and exit
  -v, --verbose          Enable log output to stderr
  --version              Show version information

Environment variables:
  DIGESTIF_DATA          Paths to look for data files
  DIGESTIF_TEXMF         Paths to look for TeX files
  DIGESTIF_TLPDB         Path to the TeXLive package database file

  If your TeX distribution or Digestif are installed in a non-standard
  location, you may need to set some of the above variables.
]]

local function main(arg)
  -- Set up default config.data_dirs, if needed
  config.load_from_env()
  if #config.data_dirs == 0 then
    for _, dir in ipairs{
      util.path_split(debug.getinfo(1).source:match("^@(.*)")),
      util.path_split(arg[0]),
      nil
    } do
      local f = io.open(util.path_join(dir, "../data/primitives.tags"))
      if f then
        f:close()
        config.data_dirs = {util.path_join(dir, "../data")}
        break
      end
    end
  end

  -- Read CLI args
  while arg[1] do
    local switch = table.remove(arg, 1)
    if switch == "-v" or switch == "--verbose" then
      config.verbose = true
    elseif switch == "-g" or switch == "--generate" then
      for i = 1, #arg do generate(arg[i]) end
      os.exit()
    elseif switch == "-h" or switch == "--help" then
      io.write(usage)
      io.write(help)
      os.exit()
    elseif switch == "--version" then
      io.write(format("Digestif %s\n", config.version))
      os.exit()
    else
      io.stderr:write(usage)
      io.stderr:write(format("Invalid option: %s\n", switch))
      os.exit(false)
    end
  end

  -- Check if config.data_dirs was set up correctly
  if not util.find_file(config.data_dirs, "primitives.tags") then
    io.stderr:write(
      "Error: could not find data files at the following locations:\n\t"
      .. table.concat(config.data_dirs, "\n\t")
      .. "\nSet the DIGESTIF_DATA environment variable to fix this.\n"
    )
    os.exit(false)
  end

  -- Main language server loop
  if config.verbose then log("Digestif started!") end
  while true do process_request() end
end

return {
  main = main,
  methods = methods
}

