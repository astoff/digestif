local lpeg = require "lpeg"
local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local Parser = require "digestif.Parser"

local path_join, path_split = util.path_join, util.path_split
local nested_get, nested_put = util.nested_get, util.nested_put
local map, update, merge = util.map, util.update, util.merge
local format_filename_template = util.format_filename_template

local ManuscriptConTeXt = util.class(Manuscript)

ManuscriptConTeXt.parser = Parser()
ManuscriptConTeXt.format = "context"

ManuscriptConTeXt.init_callbacks =
   setmetatable({}, {__index = Manuscript.init_callbacks})
ManuscriptConTeXt.scan_references_callbacks = {}

--- Make a snippet for an environment.
--
-- @param cs The command name
-- @param args An argument list
-- @return The snippet string
function ManuscriptConTeXt:snippet_env(cs, args)
  local argsnippet = args and self:snippet_args(args) or ""
  return "start" .. cs .. argsnippet .. "\n\t$0\n\\stop" .. cs
end

return ManuscriptConTeXt
