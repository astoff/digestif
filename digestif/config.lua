local util = require "digestif.util"
local path_join, path_split = util.path_join, util.path_split
local format = string.format

local config = {}

local function has_command(name)
  local ok = os.execute(format("command -v %q > /dev/null", name))
  return ok and name or nil
end

local DIGESTIF_DATA = os.getenv("DIGESTIF_DATA") or os.getenv("DIGESTIFDATA")

if DIGESTIF_DATA then
  config.data_dirs = util.path_list_split(DIGESTIF_DATA)
else
  config.data_dirs = {} -- TODO: What should be the default?
end

local DIGESTIF_TEXMF = os.getenv("DIGESTIF_TEXMF")

if DIGESTIF_TEXMF then
  config.texmf_dirs = util.path_list_split(DIGESTIF_TEXMF)
elseif has_command "kpsewhich" then
  local pipe = io.popen("kpsewhich -var-brace-value=TEXMF")
  local str = pipe:read("l"):gsub("!!", "")
  local ok, exitt, exitc = pipe:close()
  if ok and exitt == "exit" and exitc == 0 then
    config.texmf_dirs = util.path_list_split(str)
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

local DIGESTIF_TLPDB = os.getenv("DIGESTIF_TLPDB")

if DIGESTIF_TLPDB then
  config.tlpdb_path = util.path_list_split(DIGESTIF_TLPDB)
end

config.provide_snippets = false
config.extra_snippets = {
  begin = "begin{${1:environment}}$0\n\\end{$1}",
  figure = "begin{figure}${1:[placement]}\n\t$0\n\\caption{${2:caption text}}\n\\end{figure}"
}

config.fuzzy_cite = true
config.fuzzy_ref = true
config.info_command = has_command("info")

return config
