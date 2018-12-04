local util = require"digestif.util"
local path_join, path_split = util.path_join, util.path_split

local HOME = os.getenv("HOME")

local data_dirs = {
   "./digestif-data",
   path_join(HOME, ".local/share/digestif-data")
}

return {
   data_dirs = data_dirs,
   eol = "\n"
}
