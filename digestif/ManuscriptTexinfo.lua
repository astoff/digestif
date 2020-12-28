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

--- Make a snippet for an environment.
--
-- @param cs The command name
-- @param args An argument list
-- @return The snippet string
function ManuscriptTexinfo:snippet_env(cs, args)
  local argsnippet = args and self:snippet_args(args) or ""
  return cs .. argsnippet .. "\n\t$0\n@end " .. cs
end

--- Pretty-print a command signature
--
-- @param cs The command name
-- @param args An argument list, or nil
-- @return A string
--
function Manuscript:signature_cmd(cs, args)
  return self:signature_arg(args, "@" .. cs)
end

return ManuscriptTexinfo
