local lpeg = require "lpeg"
local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local bibtex = require "digestif.bibtex"

local path_join, path_split = util.path_join, util.path_split
local nested_get, nested_put = util.nested_get, util.nested_put
local map, update, merge = util.map, util.update, util.merge

local ManuscriptBibTeX = util.class(Manuscript)

ManuscriptBibTeX.format = "bibtex"

function ManuscriptBibTeX:__init(args)
  Manuscript.__init(self, args)
  local bibitems = bibtex.parse(self.src)
  local idx = {}
  self.bib_index = idx
  for i, item in ipairs(bibitems) do
    idx[i] = {
      name = item.id,
      pos = item.pos,
      cont = item.cont,
      manuscript = self,
      text = item:pretty_print(),
      bibitem = item,
    }
  end
end

function ManuscriptBibTeX:scan()
  return nil
end

function Manuscript:find_par(pos)
  local start = 1
  for i, item in ipairs(self.bib_index) do
    if item.pos <= pos and pos <= item.cont then
      start = item.pos
      break
    end
  end
  return start
end

return ManuscriptBibTeX
