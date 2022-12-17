local lfs = require "lfs"
local lpeg = require "lpeg"
local util = require "digestif.util"
local config = require "digestif.config"

local format, strfind = string.format, string.find
local concat, unpack = table.concat, table.unpack
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
  and find_file(config.tlpdb_path)
  or find_file(config.texmf_dirs, "../tlpkg/texlive.tlpdb")

if tlpdb_path then

  local _, tlpdb_text = find_file(tlpdb_path, nil, true)

  if config.verbose then
    log("Reading TLPDB from '%s'", tlpdb_path)
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
                        sequence( -- collect URI, but only if details field exist
                          Peol * " RELOC/",
                          Cg(gobble(" ", 1 - Peol) / "texmf:%0", "uri"),
                          Cg(P" details=\"" * C(gobble"\""), "summary"))),
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
  if config.verbose then log("TLPDB not found") end

end

--* Indexing of TeX input files

-- Table mapping TeX input file names to the directory where it is
-- located.
local texmf_index = {}
do
  local dir_patt = C(P"."^-2 * P"/" * gobble(":" * P(-1)))
  for _, texmf_dir in ipairs(config.texmf_dirs) do
    local clock = config.verbose and os.clock()
    local ls_file = io.open(path_join(texmf_dir, "ls-R"))
    if ls_file then
      local current_dir
      for name in ls_file:lines() do
        if name ~= "" then
          local subdir = match(dir_patt, name)
          if subdir then
            current_dir = path_join(texmf_dir, subdir)
          elseif current_dir and not texmf_index[name] then
            texmf_index[name] = current_dir
          end
        end
      end
      ls_file:close()
    else
      local function recur(current_dir, max_depth)
        local ok, iter, dir_obj = pcall(lfs.dir, current_dir)
        if not ok then return end
        for name in iter, dir_obj do
          if name ~= "." and name ~= ".." then
            local path = path_join(current_dir, name)
            local mode = lfs.attributes(path, "mode")
            if mode == "directory" then
              if max_depth > 0 then
                recur(path, max_depth - 1)
              end
            elseif mode == "file" then
              if not texmf_index[name] then
                texmf_index[name] = current_dir
              end
            end
          end
        end
      end
      recur(texmf_dir, 10)
    end
    if clock then
      log(
        "Scanned %s%s in %0.3f ms",
        texmf_dir, ls_file and "/ls-R" or "",
        1000*(os.clock() - clock)
      )
    end
  end
end

--* Generate tags from the user's TeX installation

local function infer_format(path)
  local ext = path:sub(-4)
  if ext == ".bib" then
    return "bibtex"
  elseif ext == ".sty" or ext == ".cls" or ext == ".ltx" then
    return "latex-prog"
  elseif ext == ".xml" and path:match("%Acontext%A") then
    return "context-xml"
  elseif ext == ".tex" then
    return "latex-prog"
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
  for pkg in pairs(script.packages) do
    dependencies[#dependencies+1] = pkg
  end
  table.sort(dependencies)
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
-- if applicable).  The argument is TeX input file name.
--
local function generate_tags(name)
  local dir = texmf_index[name]
  local path = dir and path_join(dir, name)
  local f = path and io.open(path)
  if f then f:close() else return end
  local texformat = infer_format(path)
  if not texformat then return end
  if config.verbose then log("Generating tags: %s", path) end
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

local function resolve_refs(tbl, seen)
  seen = seen or {}
  for k, v in pairs(tbl) do
    if type(v) == "string" then
      local loc, path = parse_ref(v)
      if loc then
        tbl[k] = nested_get(require_tags(loc), unpack(path))
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
  local path, str = find_file(config.data_dirs, name .. ".tags", true)
  if not path then return end
  if config.verbose then log("Loading tags: %s", path) end
  local tags = {}
  local ok, message = load(str, path, "t", tags)
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
      return format(
        config.external_texmf, make_uri(nil, nil, location, nil, fragment)
      )
    end
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
