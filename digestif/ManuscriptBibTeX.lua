local lpeg = require "lpeg"
local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local bibtex = require "digestif.bibtex"

local path_join, path_split = util.path_join, util.path_split
local nested_get, nested_put = util.nested_get, util.nested_put
local map, update, merge = util.map, util.update, util.merge

local ManuscriptBibTeX = util.class(Manuscript)

ManuscriptBibTeX.format = "bibtex"

function ManuscriptBibTeX:global_scan()
  local bibitems = bibtex.parse(self.src)
  local idx = {}
  self.bib_index = idx
  for i, item in ipairs(bibitems) do
    idx[i] = {
      name = item.id,
      filename = self.filename,
      pos = item.pos,
      len = item.len,
      bibitem = item,
    }
  end
end

return ManuscriptBibTeX
