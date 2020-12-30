local lpeg = require "lpeg"
local util = require "digestif.util"
local ManuscriptLatex = require "digestif.ManuscriptLaTeX"
local Parser = require "digestif.Parser"

local path_join, path_split = util.path_join, util.path_split
local nested_get, nested_put = util.nested_get, util.nested_put
local map, update, merge = util.map, util.update, util.merge
local format_filename_template = util.format_filename_template

local parser_atletter = Parser{
  letter = lpeg.R("az", "AZ") + lpeg.P("@")
}

local parser_expl = Parser{
  letter = lpeg.R("az", "AZ") + lpeg.S("_:@"),
}

local ManuscriptLatexProg = util.class(ManuscriptLatex)

ManuscriptLatexProg.parser = parser_atletter 
ManuscriptLatexProg.format = "latex-prog"

--* Helper functions

local function first_mand(args)
   for i, v in ipairs(args) do
      if not v.optional then return i end
   end
end

local function first_opt(args)
   for i, v in ipairs(args) do
      if v.optional  then return i end
   end
end

--* Global scanning

local to_args = {}
for i = 1, 9 do
  local t = merge(to_args[i-1] or {})
  t[i] = {meta = "#" .. i}
  to_args[i] = t
end

local function newcommand_args(number, default)
  local args = to_args[number]
  if default and args then
    args = merge(args) -- make a copy
    args[1] = {
      meta = "#1",
      optional = true,
      delimiters = {"[", "]"},
      details = "Default: “" .. default .. "”."
    }
  end
  return args
end

function ManuscriptLatexProg.init_callbacks.newcommand(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local csname, nargs, optdefault
  for r in self:argument_items("command", pos, cs) do
    csname = self:substring_stripped(r):sub(2)
  end
  for r in self:argument_items("number", pos, cs) do
    nargs = tonumber(self:substring_stripped(r))
  end
  for r in self:argument_items("default", pos, cs) do
    optdefault = self:substring_stripped(r)
  end
  if csname then
    local idx = self:get_index "newcommand"
    idx[#idx+1] = {
      name = csname,
      pos = pos,
      cont = cont,
      manuscript = self,
      arguments = newcommand_args(nargs, optdefault)
    }
  end
  return cont
end

function ManuscriptLatexProg.init_callbacks.newenvironment(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local csname, nargs, optdefault
  for r in self:argument_items("environment", pos, cs) do
    csname = self:substring_stripped(r)
  end
  for r in self:argument_items("number", pos, cs) do
    nargs = tonumber(self:substring_stripped(r))
  end
  for r in self:argument_items("default", pos, cs) do
    optdefault = self:substring_stripped(r)
  end
  if csname then
    local idx = self:get_index("newenvironment")
    idx[#idx+1] = {
      name = csname,
      pos = pos,
      cont = cont,
      manuscript = self,
      arguments = newcommand_args(nargs, optdefault)
    }
  end
  return cont
end

local P, C, Cc, Cg, Ct = lpeg.P, lpeg.C, lpeg.Cc, lpeg.Cg, lpeg.Ct
local Pgroup = util.between_balanced("{", "}")
local Pdefault = Cg(Pgroup / "Default: “%1”", "details")

local xparse_args = util.matcher(
  Ct(util.many(Ct(util.sequence(
    P" "^0,
    (P"+" * Cg(Cc(true), "long"))^-1,
    P"!"^-1,
    util.choice(
      "m",
      "r" * Cg(Ct(C(1) * C(1)), "delimiters"),
      "R" * Cg(Ct(C(1) * C(1)), "delimiters") * Pdefault,
      "v" * Cg(Cc"verbatim", "type"),
      "o" * Cg(Cc{"[", "]"}, "delimiters") * Cg(Cc(true), "optional"),
      "O" * Cg(Cc{"[", "]"}, "delimiters") * Cg(Cc(true), "optional") * Pdefault,
      "d" * Cg(Ct(C(1) * C(1)), "delimiters") * Cg(Cc(true), "optional"),
      "D" * Cg(Ct(C(1) * C(1)), "delimiters") * Cg(Cc(true), "optional") * Pdefault,
      "s" * Cg(Cc"*", "literal") * Cg(Cc"literal", "type") * Cg(Cc(true), "optional"),
      "t" * Cg(C(1), "literal") * Cg(Cc"literal", "type") * Cg(Cc(true), "optional"),
      "e" * Pgroup,
      "E" * Pgroup * Pdefault))))))

function ManuscriptLatexProg.init_callbacks.NewDocumentCommand(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local csname, arg_spec
  for r in self:argument_items("command", pos, cs) do
    csname = self:substring_stripped(r):sub(2)
  end
  for r in self:argument_items("arg spec", pos, cs) do
    arg_spec = self:substring_stripped(r)
  end
  if csname then
    local idx = self:get_index "newcommand"
    idx[#idx+1] = {
      name = csname,
      pos = pos,
      cont = cont,
      manuscript = self,
      arguments = xparse_args(arg_spec)
    }
  end
  return cont
end

function ManuscriptLatexProg.init_callbacks.NewDocumentEnvironment(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local csname, arg_spec
  for r in self:argument_items("environment", pos, cs) do
    csname = self:substring_stripped(r)
  end
  for r in self:argument_items("arg spec", pos, cs) do
    arg_spec = self:substring_stripped(r)
  end
  if csname then
    local idx = self:get_index "newenvironment"
    idx[#idx+1] = {
      name = csname,
      pos = pos,
      cont = cont,
      manuscript = self,
      arguments = xparse_args(arg_spec)
    }
  end
  return cont
end

return ManuscriptLatexProg
