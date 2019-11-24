local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local Parser = require "digestif.Parser"

local ManuscriptTexinfo = util.class(Manuscript)

ManuscriptTexinfo.parser = Parser({
  escape = "@"
})

ManuscriptTexinfo.format = "texinfo"

ManuscriptTexinfo.init_callbacks =
   setmetatable({}, {__index = Manuscript.init_callbacks})
Manuscript.scan_references_callbacks = {}

return ManuscriptTexinfo
