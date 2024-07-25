local util = require "digestif.util"
local format = string.format

local config = {}

config.version = "0.5.1"
local pre_version = os.getenv("DIGESTIF_PRERELEASE")
if pre_version then
  config.version = config.version .. "-" .. pre_version
end

if util.is_command("kpsewhich") then
  local pipe = io.popen("kpsewhich -var-brace-value=TEXMF")
  local output = pipe:read("l")
  local ok, exitt, exitc = pipe:close()
  if ok and exitt == "exit" and exitc == 0 then
    config.texmf_dirs = util.imap(
      function (s) return s:gsub("^!!", "") end,
      util.path_list_split(output)
    )
  elseif config.verbose then
    util.log("Error running kpsewhich (%s %d)", exitt, exitc)
  end
elseif util.is_command("mtxrun") then
-- this is a standalone ConTeXt installation
-- make sure to run 'mtxrun --generate'
-- we run 
--    mtxrun --expand-path TEXMF
-- it returns stuff like this 
-- home:texmf:!!selfautoparent:texmf-project:!!selfautoparent:texmf-fonts:!!selfautoparent:texmf-local:!!selfautoparent:texmf-modules:!!selfautoparent:texmf-context:!!selfautoparent:texmf-osx-64:!!selfautoparent:texmf
-- we need to split it on !! and then replace vars 'home' and 'selfautoparent' with the actual values
-- to get this values we run 
-- mtxrun --expand-path home 
-- mtxrun --expand-path selfautoparent
-- we need to run this commands in the same directory where mtxrun is located
  local pipe = io.popen("mtxrun --expand-path TEXMF")
  local output = pipe:read("l")
  local ok, exitt, exitc = pipe:close()
  if ok and exitt == "exit" and exitc == 0 then
    util.log("TEXMF dirs: %s", output)
    local texmf_dirs = util.split("!!")(output)
    util.log("TEXMF dirs: %s", util.inspect(texmf_dirs))
    config.texmf_dirs = {}
    for _, dir in ipairs(texmf_dirs) do
      if dir == "home" then
        pipe = io.popen("mtxrun --expand-path home")
        output = pipe:read("l")
        ok, exitt, exitc = pipe:close()
        if ok and exitt == "exit" and exitc == 0 then
          table.insert(config.texmf_dirs, output)
        end
      elseif dir == "selfautoparent" then
        pipe = io.popen("mtxrun --expand-path selfautoparent")
        output = pipe:read("l")
        ok, exitt, exitc = pipe:close()
        if ok and exitt == "exit" and exitc == 0 then
          table.insert(config.texmf_dirs, output)
        end
      else
        table.insert(config.texmf_dirs, dir)
      end
    end

    util.log("TEXMF dirs: %s", util.inspect(config.texmf_dirs))

  elseif config.verbose then
    util.log("Error running mtxrun (%s %d)", exitt, exitc)
  end


else -- TODO: What should be the default?
  config.texmf_dirs = {
    "/usr/local/share/texmf",
    "/usr/share/texmf",
    "/usr/share/texlive/texmf-local",
    "/usr/share/texlive/texmf-dist",
  }
end

config.data_dirs = {} -- TODO: What should be the default?

-- Location of a complete texmf distribution, used for instance to
-- find documentation not installed locally.  Passed to format with
-- one argument, the percent-encoded name of a file.
config.external_texmf = "https://www.tug.org/texlive/Contents/live/texmf-dist/%s"

config.provide_snippets = false

-- Table mapping command names to the snippet to be used, overriding
-- the default.
config.extra_snippets = {}

-- This allows the user to assign custom actions to generated command
-- tags.
config.extra_actions = {
  eqref = "ref"
}

config.fuzzy_cite = true
config.fuzzy_ref = true
config.info_command = util.is_command("info")

-- For candidates of these kinds, include the annotation in the
-- candidate label.  The values of this table are a string which is
-- formatted with two arguments, the candidate text and annotation.
config.lsp_long_candidates = {
  label = "%-12s    %s",
  bibitem = "%-12s    %s",
}

--* Loading user settings

local function is_table(key_type, val_type)
  return function(obj)
    if type(obj) ~= "table" then return false end
    for key, val in pairs(obj) do
      if type(key) ~= key_type then return false end
      if type(val) ~= val_type then return false end
    end
    return true
  end
end

local validators =   {
  data_dirs = is_table("number", "string"),
  extra_actions = is_table("string", "string"),
  extra_snippets = is_table("string", "string"),
  fuzzy_cite = "boolean",
  fuzzy_ref = "boolean",
  info_command = "string",
  lsp_long_candidates = is_table("string", "string"),
  provide_snippets = "boolean",
  texmf_dirs = is_table("number", "string"),
  tlpdb_path = "string",
  verbose = "boolean",
}

-- Set config entries found in `tbl`.
function config.load_from_table(tbl)
  -- Set verbose option before all others
  local verbose = tbl.verbose or config.verbose
  for key, val in pairs(tbl) do
    local validator, ok = validators[key]
    if type(validator) == "string" then
      ok = type(val) == validator
    elseif type(validator) == "function" then
      ok = validator(val)
    end
    if ok then
      config[key] = val
      if verbose then
        local msg = "Setting configuration option %s = %s"
        util.log(msg, key, util.inspect(val))
      end
    else
      local msg = "Invalid configuration option: %s = %s"
      error(format(msg, key, util.inspect(val)))
    end
  end
end

function config.load_from_file(file)
  local tbl = {}
  local ok, err = loadfile(file, "t", tbl)
  if ok then ok, err = pcall(ok) end
  if not ok then
    local msg = "Error loading configuration from %s: %s"
    error(msg, file, err)
  end
  config.load_from_table(tbl)
end

function config.load_from_env()
  local DIGESTIF_DATA = os.getenv("DIGESTIF_DATA")
  if DIGESTIF_DATA then
    config.data_dirs = util.path_list_split(DIGESTIF_DATA)
  end

  local DIGESTIF_TEXMF = os.getenv("DIGESTIF_TEXMF")
  if DIGESTIF_TEXMF then
    config.texmf_dirs = util.path_list_split(DIGESTIF_TEXMF)
  end

  local DIGESTIF_TLPDB = os.getenv("DIGESTIF_TLPDB")
  if DIGESTIF_TLPDB then
    config.tlpdb_path = util.path_list_split(DIGESTIF_TLPDB)
  end
end

function config.check_data(dir)
  if not dir then
    for _, data_dir in ipairs(config.data_dirs) do
      if config.check_data(data_dir) then return true end
    end
  end
  local f = io.open(util.path_join(dir, "primitives.tags"))
  if f then
    f:close()
    return true
  end
end

return config
