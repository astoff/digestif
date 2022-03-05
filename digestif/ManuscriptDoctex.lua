local ManuscriptLatex = require "digestif.ManuscriptLaTeX"
local Parser = require "digestif.Parser"
local lpeg = require "lpeg"
local util = require "digestif.util"

local ManuscriptDoctex = util.class(ManuscriptLatex)

-- Consider both code (no prefix) and documentation (starting with a
-- single %) as not being comments.
local comment = (- lpeg.B("\n")) * lpeg.P("%") -- TODO: certainly can be refined...

ManuscriptDoctex.format = "doctex"
ManuscriptDoctex.parser = Parser{comment = comment}

return ManuscriptDoctex
