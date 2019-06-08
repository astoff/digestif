local FileCache = require "digestif.FileCache"
local Manuscript = require "digestif.Manuscript"
local util = require "digestif.util"

local path_join, path_split = util.path_join, util.path_split
local nested_get, nested_put = util.nested_get, util.nested_put

local cache = FileCache()
local null = util.null
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

local function get_manuscript(filename, tex_format)
  return Manuscript{
    filename = filename,
    cache = cache,
    format = tex_format
  }
end
get_manuscript = util.memoize(get_manuscript)

local function get_manuscript2(filename)
  local tex_format = cache:get_property(filename, "tex_format")
  local rootname = cache:get_rootname(filename) or filename
  local root = cache:get_property(rootname, tex_format)
  if not root then
    root = Manuscript{
      filename = rootname,
      cache = cache,
      format = tex_format
    }
    cache:put_property(rootname, tex_format, root)
  end
  root:refresh()
  return root:find_manuscript(filename)
end

-- ¶ Convert LSP API objects to/from internal representations

local function from_Range(filename, range)
  local l1, c1 = range.start.line + 1, range.start.character + 1
  local l2, c2 = range["end"].line + 1, range["end"].character + 1
  local pos1 = cache:get_position(filename, l1, c1) -- inclusive
  local pos2 = cache:get_position(filename, l2, c2) -- exclusive
  return pos1, pos2 - pos1
end

--- Convert from a TextDocumentPositionParams object
--@param arg a TextDocumentPositionParam object
--@return a position in bytes, filename, root's filename
local function from_TextDocumentPositionParams(arg)
  local filename = unescape_uri(arg.textDocument.uri)
  local l, c = arg.position.line + 1, arg.position.character + 1
  return filename, cache:get_position(filename, l, c)
end

local function to_Range(item)
  local filename = item.manuscript.filename
  local l1, c1 = cache:get_line_col(filename, item.pos)
  local l2, c2 = cache:get_line_col(filename, item.cont)
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

local function to_TextEdit(filename, pos, old, new)
  local l, c_start = cache:get_line_col(filename, pos)
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
  tex = "latex", -- this is for vim; maybe "tex" should mean "tex file, undecided format"
  latex = "latex",
  plain = "plain",
  plaintex = "plain",
  ["plain-tex"] = "plain",
  context = "context",
  bibtex = "bibtex",
}

-- ¶ LSP methods

local methods = {}

methods["initialize"] = function(params)
  trace = (params.trace == null) and 0 or params.trace
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

methods["initialized"] = function() return end

methods["shutdown"] = function() return null end

methods["exit"] = function() os.exit() end

methods["workspace/didChangeConfiguration"] = function() return end

methods["textDocument/didOpen"] = function(params)
  local filename = unescape_uri(params.textDocument.uri)
  local version = params.textDocument.version
  local tex_format = languageId_table[params.textDocument.languageId] or "tex"
  cache:put(filename, params.textDocument.text)
  cache:put_property(filename, "tex_format", tex_format)
  cache:put_property(filename, "version", version)
end

methods["textDocument/didChange"] = function(params)
  local filename = unescape_uri(params.textDocument.uri)
  local version = params.textDocument.version
  local tex_format = cache:get_property(filename, "tex_format")
  for _, change in ipairs(params.contentChanges) do
    if change.range then
      local src = cache:get(filename)
      local pos, len = from_Range(filename, change.range)
      if len ~= change.rangeLength then
        error("Range length mismatch in textdocument/didChange operation")
      end
      src = src:sub(1, pos - 1) .. change.text .. src:sub(pos + len)
      cache:put(filename, src)
    else
      cache:put(filename, change.text)
    end
  end
  cache:put_property(filename, "tex_format", tex_format)
  cache:put_property(filename, "version", version)
  get_manuscript:forget(filename)
end

methods["textDocument/didClose"] = function(params)
  local filename = unescape_uri(params.textDocument.uri)
  local rootname = cache:get_rootname(filename)
  if rootname then cache:forget(rootname) end
  cache:forget(filename)
end

methods["textDocument/signatureHelp"] = function(params)
  local filename, pos = from_TextDocumentPositionParams(params)
  local script = get_manuscript2(filename)
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
  local filename, pos = from_TextDocumentPositionParams(params)
  local script = get_manuscript2(filename)
  local help = script:get_help(pos)
  if (not help) or help.arg then return null end
  local contents = help.details or help.summary or "???"
  return {contents = to_MarkupContent(contents)}
end

methods["textDocument/completion"] = function(params)
   local filename, pos = from_TextDocumentPositionParams(params)
   local script = get_manuscript2(filename)
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
         filterText = cand.filter_text,
	 sortText=("%09d"):format(i), -- Workaround to avoid client re-sorting
         documentation = cand.summary,
         detail = cand.detail,
         insertTextFormat = snippet and 2 or 1,
         textEdit = to_TextEdit(filename,
                                candidates.pos,
                                candidates.prefix,
                                snippet or cand.text)
      }
   end
   return result
end

methods["textDocument/definition"] = function(params)
  local filename, pos = from_TextDocumentPositionParams(params)
  local script = get_manuscript2(filename)
  local definition = script:find_definition(pos)
  return definition and to_Location(definition) or null
end

methods["textDocument/references"] = function(params)
  local filename, pos = from_TextDocumentPositionParams(params)
  local script = get_manuscript2(filename)
  local result = {}
  if params.context and params.context.includeDeclaration then
    local definition = script:find_definition(pos)
    if definition then
      result[#result + 1] = to_Location(definition)
    end
  end
  local references = script:find_references(pos)
  if references then
    for i, ref in ipairs(references) do
      result[#result + 1] = to_Location(ref)
    end
  end
  if #result > 0 then
    return result
  else
    return null
  end
end

return methods
