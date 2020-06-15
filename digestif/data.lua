local lpeg = require "lpeg"
local util = require "digestif.util"
local config = require "digestif.config"
local format = string.format
local concat = table.concat

local P = lpeg.P
local C, R, S, Cc = lpeg.C, lpeg.R, lpeg.S, lpeg.Cc

local path_join, path_split = util.path_join, util.path_split

local data = {
  loaded = {},
  ctan_files = {},
  ctan_packages = {},
  ctan_paths = {}
}

local tlmgr_command = config.tlmgr_command

--* CTAN data

if tlmgr_command then
  local pipe = io.popen(tlmgr_command .. " dump-tlpdb --local")
  local ctan_files = data.ctan_files
  local ctan_packages = data.ctan_packages
  local ctan_paths = data.ctan_paths
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
                local _, basename = util.path_split(path)
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
function data.generate(name)
  local path = data.ctan_paths[name]
  path = path and util.find_file(config.texmf_dirs, path)
  if not path then return end
  data.loaded[name] = {} -- TODO: this is to avoid loops, find a better way
  local Manuscript = require "digestif.Manuscript"
  local cache = require "digestif.Cache"()
  local script = Manuscript{
    filename = path,
    format = "latex-prog",
    files = cache
  }
  local ctan_data = data.ctan_files[name]
  local commands, environments, dependencies = {}, {}, {}
  local pkg_tags = setmetatable(
    {
      name = name,
      ctan_package = ctan_data.ctan_package,
      generated = true,
      dependencies = dependencies,
      commands = commands,
      environments = environments
    },
    {__index = ctan_data}
  )
  for _, it in script:index_pairs("child") do
    local _, basename = path_split(it.name)
    dependencies[#dependencies+1] = basename
  end
  for _, it in script:index_pairs("newcommand") do
    commands[it.name] = {
      arguments = it.arguments,
      package = pkg_tags
    }
  end
  for _, it in script:index_pairs("newenvironment") do
    environments[it.name] = {
      arguments = it.arguments,
      package = pkg_tags
    }
  end
  data.loaded[name] = pkg_tags
  return pkg_tags
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

function data.signature(sig, ...)
   local args = {...}
   for i, arg in ipairs({xparse_patt:match(sig)}) do
      if type(args[i]) ~= "table" then
         args[i] = {meta = args[i] or "#" .. i}
      end
      util.update(args[i], arg)
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
        tbl[k] = util.nested_get(data.require(t[1]), table.unpack(t, 2))
      end
    elseif type(v) == "table" and not seen[v] then
      seen[v] = true
      resolve_refs(v, seen)
    end
  end
end

local load_data_mt = {
   __index = {
      merge = util.merge,
      data = data.require,
      signature = data.signature
   }
}

function data.load(name)
  if name:find('..', 1, true) then return nil end -- unreasonable file name
  local src = util.try_read_file(config.data_dirs, name .. ".tags")
  if not src then return nil end
  local result, err = util.eval_with_env(src, load_data_mt)
  if not result and config.verbose then
    util.log("Error loading %s.tags: %s", name, err)
    return -- TODO: should throw an error?
  end
  for _, kind in ipairs{"commands", "environments"} do
    for _, cmd in pairs(result[kind] or {}) do
      if type(cmd) == "table" then cmd.package = result end
    end
  end
  local ctan_package =  data.ctan_packages[result.ctan_package] or data.ctan_files[name]
  setmetatable(result, {__index = ctan_package})
  data.loaded[name] = result
  resolve_refs(result)
  return result
end

function data.require(name)
  return data.loaded[name] or data.load(name) or data.generate(name)
end

---
-- Load all data files, and return them in a table.  This is intended
-- for debugging and testing only, and depends on luafilesystem.
function data.load_all()
  local ok, lfs = pcall(require, "lfs")
  assert(ok, "Function data.load_all() need the luafilesystem library.")
  for _, data_dir in ipairs(config.data_dirs) do
    for path in lfs.dir(data_dir) do
      local pkg = path:match("(.*)%.tags")
      if pkg then
        assert(data.require(pkg), "Couldn't load data file " .. path)
      end
    end
  end
  return data.loaded
end

return data
