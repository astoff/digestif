local util = require "digestif.util"
local path_join, path_split = util.path_join, util.path_split

local HOME = os.getenv("HOME")

local data_dirs = {
  "./digestif-data",
  path_join(HOME, ".local/share/digestif-data")
}

local extra_snippets = {
  begin = "begin{${1:environment}}$0\n\\end{$1}",
  figure = "begin{figure}${1:[placement]}\n\t$0\n\\caption{${2:caption text}}\n\\end{figure}"
}

return {
  data_dirs = data_dirs,
  extra_snippets = extra_snippets,
  eol = "\n"
}
