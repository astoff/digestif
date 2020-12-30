local lpeg = require "lpeg"
local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local Parser = require "digestif.Parser"

local path_join, path_split = util.path_join, util.path_split
local nested_get, nested_put = util.nested_get, util.nested_put
local map, update, merge = util.map, util.update, util.merge
local format_filename_template = util.format_filename_template

local ManuscriptPlain = util.class(Manuscript)

ManuscriptPlain.parser = Parser()
ManuscriptPlain.format = "plain"
ManuscriptPlain.packages = {}
ManuscriptPlain.commands = {}
ManuscriptPlain.environments = {}
ManuscriptPlain.init_callbacks = {}
ManuscriptPlain.scan_references_callbacks = {}
ManuscriptPlain:add_package("plain")

return ManuscriptPlain
