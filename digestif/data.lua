local lpeg = require "lpeg"
local util = require "digestif.util"
local config = require "digestif.config"

local format = string.format
local concat = table.concat
local P, R, S, V, I = lpeg.P, lpeg.R, lpeg.S, lpeg.V, lpeg.Cp()
local C, Cc, Cb, Cg, Ct = lpeg.C, lpeg.Cc, lpeg.Cb, lpeg.Cg, lpeg.Ct
local match = lpeg.match
local choice, many, sequence = util.choice, util.many, util.sequence
local gobble, search = util.gobble, util.search
local nested_get, update, extend = util.nested_get, util.update, util.extend
local find_file = util.find_file
local eval_with_env = util.eval_with_env
local parse_uri, make_uri = util.parse_uri, util.make_uri
local log = util.log
local path_split, path_join = util.path_split, util.path_join

local loaded_tags = {}

--* CTAN data

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

local kpsewhich

if kpse then -- we're on luatex

  local kpse_obj = kpse.new("luatex")

  function kpsewhich(name)
    return kpse_obj:find_file(name, "tex")
  end

else -- on plain lua, we look for ls-R files

  -- local ls_R = {}
  -- local texmf_dirs = config.texmf_dirs
  -- for i = 1, #texmf_dirs do
  --   local ok, str = find_file(texmf_dirs[i], "ls-R", true)
  --   if ok then ls_R[i] = str end
  -- end
  -- local function search_patt(name)
  --   return search(
  --     P"\n" * P(name) * P"\n" * Cb(1),
  --     P"\n./" * Cg(C(gobble(":\n")), 1) + P(1)
  --   )
  -- end
  -- function kpsewhich(name)
  --   local patt = search_patt(name)
  --   for i = 1, #texmf_dirs do
  --     local path = ls_R[i] and match(patt, ls_R[i])
  --     if path then
  --       path = path_join(texmf_dirs[i], path)
  --       return path_join(path, name)
  --     end
  --   end
  --   return false -- so we memoize the non-existence of a file
  -- end
  -- kpsewhich = memoize1(kpsewhich)

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
    }
  end
  for _, it in script:index_pairs("newenvironment") do
    environments[it.name] = {
      arguments = it.arguments,
    }
  end
  return tags
end

local function generate_tags(name)
  local path = kpsewhich(name)
  path = path and find_file(config.texmf_dirs, path)
  if not path then return end
  local texformat = infer_format(path)
  if not texformat then return end
  loaded_tags[name] = {} -- TODO: this is to avoid loops, find a better way
  local cache = require "digestif.Cache"()
  local script = cache:manuscript(path, texformat)
  local pkg = ctan_package_of(name)
  local tags = tags_from_manuscript(script, pkg)
  return tags
end

--* Load tags

local require_tags -- to be defined
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

local unreasonable_name = util.matcher(util.search(".."))

local function load_tags(name)
  if unreasonable_name(name) then return end
  local _, src = find_file(config.data_dirs, name .. ".tags", true)
  if not src then return nil end
  local tags, err = eval_with_env(src)
  if not tags and config.verbose then
    log("Error loading %s.tags: %s", name, err)
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
      for _, kind in ipairs{"commands", "environments"} do
        for _, cmd in pairs(tags[kind] or {}) do
          if not cmd.package then cmd.package = tags end
        end
      end
    end
  end
  return tags
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
  elseif scheme == "texmf" then
    local path = find_file(config.texmf_dirs, location)
    if path then
      return make_uri("file", path, fragment)
    else
      return make_uri(
        "https",
        "//texdoc.net/texmf-dist/" .. location,
        fragment
      )
    end
  elseif scheme == "texdoc" then -- TODO: make obsolete
    return resolve_uri(make_uri("texmf", "doc/" .. location, fragment))
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
  require_tags = require_tags,
  load_all = load_all_tags,
  tags_from_manuscript = tags_from_manuscript,
  generate_docstring = generate_docstring
}
