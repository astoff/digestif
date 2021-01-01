local lpeg = require "lpeg"
local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local Parser = require "digestif.Parser"
local bibtex = require "digestif.bibtex"

local path_join, path_split = util.path_join, util.path_split
local nested_get, nested_put = util.nested_get, util.nested_put
local map, update, merge = util.map, util.update, util.merge

local ManuscriptBibtex = util.class(Manuscript)

ManuscriptBibtex.parser = Parser()
ManuscriptBibtex.format = "bibtex"
ManuscriptBibtex.packages = {}
ManuscriptBibtex.commands = {}
ManuscriptBibtex.environments = {}
ManuscriptBibtex.init_callbacks = false -- Skip the normal init scan
ManuscriptBibtex:add_package("plain") -- For basic command completion

function ManuscriptBibtex:__init(args)
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

return ManuscriptBibtex
