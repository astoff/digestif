local lpeg = require "lpeg"
local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local Parser = require "digestif.Parser"
local ManuscriptPlain = util.class(Manuscript)

local P, R = lpeg.P, lpeg.R
local C, Ct, Cc, Cg = lpeg.C, lpeg.Ct, lpeg.Cc, lpeg.Cg

-- In plain TeX, we can't distinguish between code and document files,
-- so we pretend @ is always a letter.
ManuscriptPlain.parser = Parser{letter = lpeg.R("az", "@Z")}
ManuscriptPlain.format = "plain"
ManuscriptPlain.packages = {}
ManuscriptPlain.commands = {}
ManuscriptPlain.environments = {}
ManuscriptPlain.init_callbacks = {}
ManuscriptPlain.scan_references_callbacks = {}
ManuscriptPlain:add_package("plain")

-- Convert a TeX parameter text to an arguments table.
local param = P("#") * R("19")
local before_params = Ct(Cg(C((1 - param)^1), "literal"))
local one_param = Ct(
  Cg(C(param), "meta") * Cg(Ct(Cc("") * C((1 - param)^1)), "delimiters")^-1
)
local parse_params = util.matcher(
  Ct(before_params^-1 * one_param^0)
)

function ManuscriptPlain.init_callbacks.def(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local csname, params
  for r in self:argument_items(1, pos, cs) do
    csname = self:substring_stripped(r):sub(2)
  end
  for r in self:argument_items(2, pos, cs) do
    params = self:substring_stripped(r)
  end
  if csname then
    local idx = self:get_index "newcommand"
    idx[#idx+1] = {
      name = csname,
      pos = pos,
      cont = cont,
      manuscript = self,
      arguments = parse_params(params)
    }
    if not self.commands[csname] then
      self.commands[csname] = idx[#idx]
    end
  end
  return cont
end

return ManuscriptPlain
