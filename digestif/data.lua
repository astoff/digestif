local lpeg = require "lpeg"
local util = require "digestif.util"
local config = require "digestif.config"

local format = string.format
local concat = table.concat
local P, R, S = lpeg.P, lpeg.R, lpeg.S
local C, Cc = lpeg.C, lpeg.Cc
local tlmgr_command = config.tlmgr_command
local nested_get, update, extend = util.nested_get, util.update, util.extend
local path_split = util.path_split
local find_file = util.find_file
local eval_with_env = util.eval_with_env
local parse_uri, make_uri = util.parse_uri, util.make_uri
local log = util.log

local ctan_files = {}
local ctan_packages = {}
local ctan_paths = {}
local loaded_tags = {}
local require_tags -- to be defined

--* CTAN data

if tlmgr_command then
  if config.verbose then
    log("Reading tlmgr dump")
  end
  local pipe = io.popen(tlmgr_command .. " dump-tlpdb --local")
  local nonblank = R"!z"
  local parse_line = util.matcher(
    util.choice(
      util.sequence(
        C(nonblank^1),
        S" \t",
        C((P(1))^1)),
      util.sequence(
        Cc"FILE",
        P" ",
        C(P(1)^1)),
      util.sequence(
        Cc"END",
        S" \t"^0 * P(-1))))
  local parse_docitem = util.matcher(
    util.sequence(
      "RELOC/doc/",
      C(nonblank^1),
      " details=\"" * C(util.gobble_until"\"") * "\"" + Cc(nil),
      " language=\"" * C(util.gobble_until"\"") * "\"" + Cc(nil)))
  local parse_reloc_file = util.matcher(
    util.sequence("RELOC/", C(nonblank^1)))
  local function iter()
    local line = pipe:read("l")
    if line then return parse_line(line) end
  end
  for k, name in iter do
    if k == "name" then
      local pkg, files, details = {}, {}, {}
      local current_files
      for k, v in iter do
        if k == "category" then
          if v ~= "Package" then break end
        elseif k == "shortdesc" then
          pkg.summary = v
        elseif k == "longdesc" then
          details[#details+1] = v
        elseif k:sub(-5) == "files" then
          current_files = {}
          files[k] = current_files
        elseif k == "FILE" then
          current_files[#current_files+1] = v
        elseif k == "END" then
          pkg.ctan_package = name
          if #details > 0 then
            details[#details+1] = ""
            pkg.details = table.concat(details, "\n")
          end
          if files.docfiles then
            local docs = {}
            for _, v in ipairs(files.docfiles) do
              local path, desc, lang = parse_docitem(v)
              if desc then
                docs[#docs+1] = {
                  uri = "texdoc:" .. path,
                  summary = desc,
                  language = lang
                }
              end
              if #docs > 0 then pkg.documentation = docs end
            end
          end
          if files.runfiles then
            for _, v in ipairs(files.runfiles) do
              local path = parse_reloc_file(v)
              if path then
                local _, basename = path_split(path)
                ctan_files[basename] = pkg
                ctan_paths[basename] = path
              end
            end
          end
          ctan_packages[name] = pkg
          break
        end
      end
    end
  end
end

-- Generate tags from the user's TeX installation

local function infer_format(path)
  local ext = path:sub(-4)
  if ext == ".bib" then
    return "bibtex"
  elseif ext == ".sty" or ext == ".cls" then
    return "latex-prog"
  elseif ext == ".tex" and path:match("%Acontext%A") then
    return --"context-prog" -- TODO: add this format
  elseif ext == ".tex" then
    return "latex-prog" -- TODO: should be plain-prog
  end
end

local function tags_from_manuscript(script, ctan_data)
  local commands, environments, dependencies = {}, {}, {}
  local tags = {
      generated = true,
      dependencies = dependencies,
      commands = commands,
      environments = environments
  }
  if ctan_data then
    setmetatable(tags, {__index = ctan_data})
  end
  for _, it in script:index_pairs("child") do
    local _, basename = path_split(it.name)
    dependencies[#dependencies+1] = basename
  end
  for _, it in script:index_pairs("newcommand") do
    commands[it.name] = {
      arguments = it.arguments,
      package = tags
    }
  end
  for _, it in script:index_pairs("newenvironment") do
    environments[it.name] = {
      arguments = it.arguments,
      package = tags
    }
  end
  return tags
end

local function generate_tags(name)
  local path = ctan_paths[name]
  path = path and find_file(config.texmf_dirs, path)
  if not path then return end
  local texformat = infer_format(path)
  if not texformat then return end
  loaded_tags[name] = {} -- TODO: this is to avoid loops, find a better way
  local Manuscript = require "digestif.Manuscript"
  local cache = require "digestif.Cache"()
  local script = Manuscript{
    filename = path,
    format = texformat,
    files = cache
  }
  local ctan_data = ctan_files[name]
  local tags = tags_from_manuscript(script, ctan_data)
  loaded_tags[name] = tags
  return tags
end

--* Digestif data

local token = P(1)
local xparse_patt = (P" "^0 * P"+"^-1 *
   (  "m" * Cc{optional = false}
    + "r" * C(token) * C(token)
          / function (tok1, tok2) return {delimiters = {tok1, tok2}} end
    + "u{"* C((token - "}")^0) * "}"
          / function (toks) return {delimiters = {"", toks}} end
    + "v" * Cc{type = "verbatim"}
    + "o" * Cc{optional = true, delimiters = {"[", "]"}}
    + "d" * C(token) * C(token)
          / function (tok1, tok2) return {optonal = true, delimiters = {tok1, tok2}} end
    + "s" * Cc{type = "literal", literal = "*", optional = true, delimiters = false}
    + "t" * C(token)
          / function (tok) return {type = "literal", literal = tok, optional = true} end
    + "g" * Cc{optional = true, delimiters = {"{", "}"}}))^0

local function xparse_to_args(sig, ...)
   local args = {...}
   for i, arg in ipairs({xparse_patt:match(sig)}) do
      if type(args[i]) ~= "table" then
         args[i] = {meta = args[i] or "#" .. i}
      end
      update(args[i], arg)
   end
   return args
end

local ref_patt = P"$DIGESTIFDATA/" * C(P(1)^0)
local ref_split = util.split("/")

local function resolve_refs(tbl, seen)
  seen = seen or {}
  for k, v in pairs(tbl) do
    if type(v) == "string" then
      local path = ref_patt:match(v)
      if path then
        local t = ref_split(path)
        tbl[k] = nested_get(require_tags(t[1]), table.unpack(t, 2))
      end
    elseif type(v) == "table" and not seen[v] then
      seen[v] = true
      resolve_refs(v, seen)
    end
  end
end

local function load_tags(name)
  if name:find('..', 1, true) then return nil end -- unreasonable file name
  local _, src = find_file(config.data_dirs, name .. ".tags", true)
  if not src then return nil end
  local result, err = eval_with_env(src)
  if not result and config.verbose then
    log("Error loading %s.tags: %s", name, err)
    return -- TODO: should throw an error?
  end
  for _, kind in ipairs{"commands", "environments"} do
    for _, cmd in pairs(result[kind] or {}) do
      if type(cmd) == "table" then cmd.package = result end
    end
  end
  local ctan_package =  ctan_packages[result.ctan_package] or ctan_files[name]
  setmetatable(result, {__index = ctan_package})
  loaded_tags[name] = result
  resolve_refs(result)
  return result
end

require_tags = function(name)
  return loaded_tags[name] or load_tags(name) or generate_tags(name)
end

-- Load all data files, and return them in a table.  This is intended
-- for debugging and testing only, and depends on luafilesystem.
local function load_all_tags()
  local ok, lfs = pcall(require, "lfs")
  assert(ok, "Function data.load_all() need the luafilesystem library.")
  for _, data_dir in ipairs(config.data_dirs) do
    for path in lfs.dir(data_dir) do
      local pkg = path:match("(.*)%.tags")
      if pkg then
        assert(require_tags(pkg), "Couldn't load data file " .. path)
      end
    end
  end
  return loaded_tags
end

--* User-readable documentation

local function resolve_uri(uri)
  local scheme, location, fragment = parse_uri(uri)
  if scheme == "info" then
    return uri
  elseif scheme == "texdoc" then
    local path = find_file(config.texmf_dirs, "doc/" .. location)
    if path then
      return make_uri("file", path, fragment)
    else
      return make_uri(
        "https",
        "//texdoc.net/texmf-dist/doc/" .. location,
        fragment
      )
    end
  else
    return uri
  end
end

local function make_doc(items)
  if type(items) == "string" then items = {items} end
  local t = {}
  for _, item in ipairs(items) do
    if type(item) == "string" then
      t[#t+1] = format("- <%s>", resolve_uri(item))
    else
      t[#t+1] = format("- [%s](%s)", item.summary, resolve_uri(item.uri))
    end
  end
  t[#t+1] = ""
  return t
end

local function get_info(uri)
  if config.info_command then
    local scheme, path, fragment = parse_uri(uri)
    if scheme ~= "info" then return end
    local cmd = format("%s '(%s)%s'", config.info_command, path, fragment)
    local pipe = io.popen(cmd)
    local str = pipe:read("a")
    local ok, exitt, exitc = pipe:close()
    if ok and exitt == "exit" and exitc == 0 then
      str = str:gsub(".-\n", "", 2) -- discard header line
      str = str:gsub("\nFile: " .. path .. ".info.*", "\n") -- discard child nodes
      return str, path, fragment
    elseif config.verbose then
      log("Error running info (%s %d)", exitt, exitc)
    end
  end
end

local function generate_docstring(item, name)
  local t = {}
  local pkg = item.package
  local details = item.details
  local item_doc = item.documentation
  local pkg_doc = pkg and pkg.documentation
  if pkg and pkg.ctan_package then
    t[#t+1] = format(
      "`%s` is defined in the [%s](https://www.ctan.org/pkg/%s) package.\n",
      name, pkg.ctan_package, pkg.ctan_package
    )
  end
  if details then
    t[#t+1] = "# Details\n"
    t[#t+1] = details
  elseif type(item_doc) == "string" and item_doc:match"^info:" then
    local str, node, subnode = get_info(item_doc)
    if str then
      t[#t+1] = format("# Info: (%s)%s\n\n```Info\n%s```", node, subnode, str)
    end
  end
  if item_doc then
    t[#t+1] = "# Documentation\n"
    extend(t, make_doc(item_doc))
  end
  if pkg_doc then
    t[#t+1] = "# Package documentation\n"
    extend(t, make_doc(pkg_doc))
  end
  return concat(t, "\n")
end

return {
  require = require_tags,
  load_all = load_all_tags,
  tags_from_manuscript = tags_from_manuscript,
  generate_docstring = generate_docstring
}
