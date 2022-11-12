local util = require "digestif.util"
local format = string.format

local config = {}

config.version = "0.4"
local pre_version = os.getenv("DIGESTIF_PRERELEASE")
if pre_version then
  config.version = config.version .. "-" .. pre_version
end

if util.has_command("kpsewhich") then
  local pipe = io.popen("kpsewhich -var-brace-value=TEXMF")
  local output = pipe:read("l")
  local ok, exitt, exitc = pipe:close()
  if ok and exitt == "exit" and exitc == 0 then
    config.texmf_dirs = util.path_list_split(output:gsub("!!", ""))
  elseif config.verbose then
    util.log("Error running kpsewhich (%s %d)", exitt, exitc)
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

config.provide_snippets = false
config.extra_snippets = {
  begin = "begin{${1:environment}}$0\n\\end{$1}",
  figure = "begin{figure}${1:[placement]}\n\t$0\n\\caption{${2:caption text}}\n\\end{figure}"
}

-- This allows the user to assign custom actions to generated command
-- tags.
config.extra_actions = {
  eqref = "ref"
}

config.fuzzy_cite = true
config.fuzzy_ref = true
config.info_command = util.has_command("info")

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
  data_dirs = "string",
  texmf_dirs = "string",
  tlpdb_path = "string",
  extra_actions = is_table("string", "string"),
  extra_snippets = is_table("string", "string"),
  fuzzy_cite = "boolean",
  fuzzy_ref = "boolean",
  info_command = "string",
  provide_snippets = "boolean",
  verbose = "boolean"
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

return config
