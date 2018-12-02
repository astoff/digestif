local util = require"digestif.util"
local path_join, path_split = util.path_join, util.path_split

local HOME = os.getenv("HOME")

local data_dir = {
   "./digestif-data",
   path_join(HOME, ".local/share/digestif-data"),
   "/usr/local/share/digestif-data",
   "/usr/share/digestif-data"
}

return {
   data_dir = data_dir,
   eol = "\n"
}
