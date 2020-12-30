local ManuscriptLatex = require "digestif.ManuscriptLaTeX"
local Parser = require "digestif.Parser"
local lpeg = require "lpeg"
local util = require "digestif.util"

local ManuscriptLatexProg = util.class(ManuscriptLatex)

ManuscriptLatexProg.format = "latex-prog"
ManuscriptLatexProg.parser = Parser{
  letter = lpeg.R("az", "AZ") + lpeg.P("@")
}

return ManuscriptLatexProg
