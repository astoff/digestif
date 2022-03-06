local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local Parser = require "digestif.Parser"

local ManuscriptTexinfo = util.class(Manuscript)

ManuscriptTexinfo.parser = Parser({escape = "@"})
ManuscriptTexinfo.format = "texinfo"
ManuscriptTexinfo.packages = {}
ManuscriptTexinfo.commands = {}
ManuscriptTexinfo.environments = {}
ManuscriptTexinfo.init_callbacks = {}
ManuscriptTexinfo.scan_references_callbacks = {}
ManuscriptTexinfo:add_package("texinfo")

function ManuscriptTexinfo:snippet_env(cs, args)
  local argsnippet = args and self:snippet_args(args) or ""
  return cs .. argsnippet .. "\n\t$0\n@end " .. cs
end

function Manuscript:signature_cmd(cs, args)
  return self:signature_args(args, "@" .. cs)
end

return ManuscriptTexinfo
