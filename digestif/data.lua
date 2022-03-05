local lpeg = require "lpeg"
local util = require "digestif.util"
local config = require "digestif.config"

local format, strfind = string.format, string.find
local concat = table.concat
local popen = io.popen
local P, C, Cg, Ct = lpeg.P, lpeg.C, lpeg.Cg, lpeg.Ct
local match = lpeg.match
local many, sequence = util.many, util.sequence
local gobble, search = util.gobble, util.search
local nested_get, extend = util.nested_get, util.extend
local find_file = util.find_file
local parse_uri, make_uri = util.parse_uri, util.make_uri
local log = util.log
local path_split, path_join = util.path_split, util.path_join

local data = {}
local loaded_tags = {}

--* CTAN data

-- function ctan_package(name)
--
-- Return a little tags table with the package's details on CTAN
-- (package description, ctan link, documentation).  No command
-- information.
--
-- function ctan_package_of(file)
--
-- The name of the CTAN package to which file belongs.
--
local ctan_package, ctan_package_of -- to be defined

local tlpdb_path = config.tlpdb_path
  and find_file(config.tldb_path)
  or find_file(config.texmf_dirs, "../tlpkg/texlive.tlpdb")

if tlpdb_path then

  local _, tlpdb_text = find_file(tlpdb_path, nil, true)

  if config.verbose then
    log("Reading TLPDB from " .. tlpdb_path)
  end

  local Peol = P"\n"
  local concat_lines = function(...) return concat({...}, "\n") end

  local within_item = 1 - Peol * Peol
  local within_files = (1 - Peol) + Peol * P" "
  local gobble_to_eol = gobble("\n")

  -- Pattern to turn an entry in the TLPDB file into a table with
  -- entries name, summary, details, documentation, runfiles.
  local tlpdb_item_patt = Ct(
    sequence(
      Cg( -- collect the name
        P"name " * C(gobble_to_eol),
        "ctan_package"),
      Cg( -- find a shortdesc or give up
        search(
          Peol * "shortdesc " * C(gobble_to_eol),
          within_item),
        "summary"),
      Cg( -- find a longdesc or give up
        search(
          (Peol * "longdesc " * C(gobble_to_eol))^1 / concat_lines,
          within_item),
        "details"),
      Cg( -- find docfiles section
        many(-1, -- or continue
             sequence(
               search(Peol * "docfiles " * gobble_to_eol, within_item),
               Ct(many( -- collect several docfile entries in a list
                    search( -- looking for the interesting ones only
                      Ct( -- parse one docfile entry
                        sequence(
                          Peol * " RELOC/",                                      -- discard the file line marker
                          Cg(gobble(" ", 1 - Peol) / "texmf:%0", "uri"),   -- collect the uri,
                          Cg(P" details=\"" * C(gobble"\""), "summary"))), -- but only if details exist
                      within_files))))),
        "documentation"),
      Cg( -- find runfiles section or give up
        sequence(
          search(Peol * "runfiles " * gobble_to_eol, within_item),
          Ct(many( -- collect the runfile entries is a list
               sequence( -- parse one runfile entry
                 Peol * " ",                   -- discard the file line marker
                 many(search("/", 1 - Peol)),  -- discard folder part
                 C(gobble_to_eol))))),         -- collect base name
        "runfiles")))

  local tlpdb_items = Ct(many(search(Peol * tlpdb_item_patt))):match(tlpdb_text)

  function ctan_package(name)
    for i = 1, #tlpdb_items do
      local item = tlpdb_items[i]
      if item.name == name then
        return item
      end
    end
  end
  ctan_package = util.memoize1(ctan_package)

  function ctan_package_of(file)
    for i = 1, #tlpdb_items do
      local item = tlpdb_items[i]
      local runfiles = item.runfiles
      for j = 1, #runfiles do
        if runfiles[j] == file then
          return item
        end
      end
    end
  end
  ctan_package_of = util.memoize1(ctan_package_of)

else

  ctan_package = function() end
  ctan_package_of = function() end
  if config.verbose then log("TLPDB not found ") end

end

--* kpathsea emulation

-- function kpsewhich(name)
--
-- Like the kpsewhich command, return the full path of tex input file
-- name.  We use luatex's kpse bindings if available, and parse the
-- system's ls-R files otherwise.
--
local kpsewhich

if kpse then -- we're on luatex

  local kpse_obj = kpse.new("luatex")

  function kpsewhich(name)
    return kpse_obj:find_file(name, "tex")
  end

else -- on plain lua, we look for ls-R files

  local texmf_files = {}
  local texmf_dirs = config.texmf_dirs
  local dir_patt = P"./" * C(gobble(":" * P(-1)))
  for i = 1, #texmf_dirs do
    local texmf_dir = texmf_dirs[i]
    local listing_path = find_file(texmf_dir, "ls-R")
    if listing_path then
      local current_dir
      for line in io.lines(listing_path) do
        local subdir = match(dir_patt, line)
        if subdir then
          current_dir = path_join(texmf_dir, subdir)
        elseif current_dir and not texmf_files[line] then
          texmf_files[line] = path_join(current_dir, line)
        end
      end
    end
  end

  function kpsewhich(name)
    return texmf_files[name]
  end

end

--* Generate tags from the user's TeX installation

local function infer_format(path)
  local ext = path:sub(-4)
  if ext == ".bib" then
    return "bibtex"
  elseif ext == ".sty" or ext == ".cls" then
    return "latex"
  elseif ext == ".xml" and path:match("%Acontext%A") then
    return "context-xml"
  elseif ext == ".tex" then
    return "latex" -- TODO: should this be plain?
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
    }
  end
  for _, it in script:index_pairs("newenvironment") do
    environments[it.name] = {
      arguments = it.arguments,
    }
  end
  return tags
end

-- Generate tags from TeX source code (or ConTeXt interface XML file,
-- if applicable).  The argument is a file name found by kpsewhich.
--
local function generate_tags(name)
  local path = kpsewhich(name)
  path = path and find_file(config.texmf_dirs, path)
  if not path then return end
  local texformat = infer_format(path)
  if not texformat then return end
  if config.verbose then
    log("Generating tags from ‘%s’", path)
  end
  local pkg = ctan_package_of(name)
  if texformat == "context-xml" then
    -- The function below is defined and monkey-patched in
    -- ManuscriptConTeXt, to keep the XML dependency separated.
    if not data.tags_from_xml then require "digestif.ManuscriptConTeXt" end
    return data.tags_from_xml(path, pkg)
  else
    loaded_tags[name] = {} -- TODO: this is to avoid loops, find a better way
    local cache = require "digestif.Cache"()
    local script = cache:manuscript(path, texformat)
    return tags_from_manuscript(script, pkg)
  end
end
data.generate_tags = generate_tags

--* Load tags

-- function require_tags(name)
--
-- Return tags table for input file name.  Either loads from a tags
-- file in the data directory, or generate from source on the fly.
--
local require_tags

local parse_ref = util.matcher(
  sequence(
    P"$ref:",
    C(gobble"#") * P"#",
    Ct(many(P"/" * C(gobble"/")))))
p=parse_ref
local function resolve_refs(tbl, seen)
  seen = seen or {}
  for k, v in pairs(tbl) do
    if type(v) == "string" then
      local loc, path = parse_ref(v)
      if loc then
        tbl[k] = nested_get(require_tags(loc), table.unpack(path))
      end
    elseif type(v) == "table" and not seen[v] then
      seen[v] = true
      resolve_refs(v, seen)
    end
  end
end

-- Load a tags file from the data directory.
local function load_tags(name)
  if strfind(name, "..", 1, true) then return end -- bad file name
  local path = find_file(config.data_dirs, name .. ".tags")
  if not path then return end
  local tags = {}
  local ok, message = loadfile(path, "t", tags)
  if ok then ok, message = pcall(ok) end
  if not ok and config.verbose then
    log("Error loading %s.tags: %s", name, message)
    return -- TODO: should throw an error?
  end
  local pkg =  ctan_package(tags.ctan_package) or ctan_package_of(name)
  setmetatable(tags, {__index = pkg})
  return tags
end

require_tags = function(name)
  local tags = loaded_tags[name]
  if not tags then
    tags = load_tags(name) or generate_tags(name)
    if tags then
      loaded_tags[name] = tags
      resolve_refs(tags)
      local extra_actions = config.extra_actions or {}
      for _, kind in ipairs{"commands", "environments"} do
        for cs, cmd in pairs(tags[kind] or {}) do
          if not cmd.package then cmd.package = tags end
          if extra_actions[cs] then cmd.action = extra_actions[cs] end
        end
      end
    end
  end
  return tags
end
data.require = require_tags
data.require_tags = require_tags

-- Load all data files, and return them in a table.  This is intended
-- for debugging and testing only, and depends on luafilesystem.
local function load_all_tags()
  local t = {}
  local ok, lfs = pcall(require, "lfs")
  assert(ok, "Function data.load_all() need the luafilesystem library.")
  for _, data_dir in ipairs(config.data_dirs) do
    for path in lfs.dir(data_dir) do
      local pkg = path:match("(.*)%.tags")
      if pkg then
        assert(load_tags(pkg), "Error loading data file " .. path)
        t[pkg] = require_tags(pkg) or error("Error processing data file " .. path)
      end
    end
  end
  return t
end
data.load_all = load_all_tags

--* User-readable documentation

local function resolve_uri(uri)
  local scheme, _, location, _, fragment = parse_uri(uri)
  if scheme == "info" then
    return uri
  elseif scheme == "texmf" then
    local path = find_file(config.texmf_dirs, location)
    if path then
      return make_uri("file", "", path, nil, fragment)
    else
      return make_uri(
        "https", "www.tug.org", "/texlive/Contents/live/texmf-dist/" .. location, nil, fragment)
    end
  elseif scheme == "texdoc" then -- TODO: make obsolete
    return resolve_uri(make_uri("texmf", nil, "doc/" .. location, nil, fragment))
  else
    return uri
  end
end

-- Given a list of documentation items, return a markdown-formatted
-- string of links to these documents.
local function resolve_doc_items(items)
  if type(items) == "string" then items = {items} end
  local t = {}
  for _, item in ipairs(items) do
    if type(item) == "string" then
      t[#t+1] = format("- <%s>", resolve_uri(item))
    else
      t[#t+1] = format("- [%s](%s)", item.summary, resolve_uri(item.uri))
    end
  end
  return t
end
data.resolve_doc_items = resolve_doc_items

-- Call info, return the relevant part of the info node.
local function get_info(uri)
  if config.info_command then
    local scheme, _, path, _, fragment = parse_uri(uri)
    if scheme ~= "info" then return end
    local cmd = format("%s '(%s)%s'", config.info_command, path, fragment)
    local pipe = popen(cmd)
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
data.get_info=util.memoize(get_info)

return data
