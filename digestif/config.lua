local util = require "digestif.util"
local path_join, path_split = util.path_join, util.path_split
local format = string.format

local config = {}

-- TODO: Make OS-independent

local HOME = os.getenv("HOME")
local DIGESTIFDATA = os.getenv("DIGESTIFDATA")

local function has_command(name)
  local ok = os.execute(format("command -v %q > /dev/null", name))
  return ok and name or nil
end

if DIGESTIFDATA then
  config.data_dirs = util.split";"(DIGESTIFDATA)
else
  config.data_dirs = {} -- TODO: What should be the default?
end


config.provide_snippets = false
config.extra_snippets = {
  begin = "begin{${1:environment}}$0\n\\end{$1}",
  figure = "begin{figure}${1:[placement]}\n\t$0\n\\caption{${2:caption text}}\n\\end{figure}"
}

config.fuzzy_cite = true
config.fuzzy_ref = true
config.info_command = has_command("info")
config.texmf_dirs = "/usr/share/texlive/texmf-dist"
config.tlpdb_path = {
  "/usr/share/texlive/tlpkg/texlive.tlpdb",
  "/usr/share/texlive/texlive.tlpdb"
}
config.eol = "\n"

return config
