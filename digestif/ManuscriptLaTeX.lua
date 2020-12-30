local lpeg = require "lpeg"
local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local Parser = require "digestif.Parser"

local path_join, path_split = util.path_join, util.path_split
local nested_get, nested_put = util.nested_get, util.nested_put
local map, update, merge = util.map, util.update, util.merge
local format_filename_template = util.format_filename_template

local ManuscriptLatex = util.class(Manuscript)

ManuscriptLatex.parser = Parser()
ManuscriptLatex.format = "latex"
ManuscriptLatex.packages = {}
ManuscriptLatex.commands = {}
ManuscriptLatex.environments = {}
ManuscriptLatex.init_callbacks = {}
ManuscriptLatex.scan_references_callbacks = {}
ManuscriptLatex:add_package("latex")

--* Snippets

-- Make a snippet for an environment.
--
-- Arguments:
--   cs: The command name
--   args: An argument list
--   
-- Returns:
--   A snippet string
--
function ManuscriptLatex:snippet_env(cs, args)
  local argsnippet = args and self:snippet_args(args) or ""
  return "begin{" .. cs .. "}" .. argsnippet .. "\n\t$0\n\\end{" .. cs .. "}"
end

-- Pretty-print an environment signature.
function ManuscriptLatex:signature_env(cs, args)
  return self:signature_args(args, "\\begin{" .. cs .. "}")
end

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

--* Global scan callbacks

function ManuscriptLatex.init_callbacks.label (m, pos, cs)
   local idx = m.label_index
   local args = m.commands[cs].arguments
   local r = m:parse_command(pos, cs)
   local i = first_mand(args)
   if r[i] then
      local l = m:substring_stripped(r[i])
      idx[#idx + 1] = {
         name = l,
         pos = r[i].pos,
         cont = r[i].cont,
         outer_pos = r.pos,
         outer_cont = r.cont,
         manuscript = m
      }
   end
   return r.cont
end

function ManuscriptLatex.init_callbacks.section(self, pos, cs)
  local idx = self.section_index
  for r in self:argument_items(first_mand, pos, cs) do
    idx[#idx + 1] = {
      name = self:substring_stripped(r),
      level = self.commands[cs].section_level,
      pos = r.pos,
      cont = r.cont,
      outer_pos = pos,
      manuscript = self
    }
  end
  return pos + #cs + 1
end

function ManuscriptLatex.init_callbacks.bibitem (m, pos, cs)
  local idx = m.bib_index
  local args = m.commands[cs].arguments
  local r = m:parse_command(pos, cs)
  local i = first_mand(args)
  if r[i] then
    idx[#idx + 1] = {
      name = m:substring_stripped(r[i]),
      pos = r[i].pos,
      cont = r[i].cont,
      outer_pos = r.pos,
      outer_cont = r.cont,
      manuscript = m
    }
  end
  return r.cont
end

function ManuscriptLatex.init_callbacks.amsrefs_bib(self, pos, cs)
  local idx = self.bib_index
  local r = self:parse_command(pos, cs)
  if r.incomplete then return r.cont end
  local keys = self:read_keys(r[3])
  local authors, title, date = {}, "", "(n.d.)"
  for i = 1, #keys do
    local k, v = keys[i].key, keys[i].value
    if k == "author" then
      authors[#authors+1] = self.parser.clean(v:match("[^,]+", 2))
    elseif k == "title" then
      title = self.parser.clean(v:sub(2, -2))
    elseif k == "date" then
      date = self.parser.clean(v:match("(%d+)"))
    end
  end
  idx[#idx + 1] = {
    name = self:substring_stripped(r[1]),
    text = string.format(
      "%s %s; %s",
      table.concat(authors, ", "),
      date,
      title),
    pos = r[1].pos,
    cont = r[1].cont,
    outer_pos = r.pos,
    outer_cont = r.cont,
    manuscript = self
  }
  return r.cont
end

function ManuscriptLatex.init_callbacks.input(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local idx = self.child_index
  local template = self.commands[cs].filename or "?"
  for r in self:argument_items(first_mand, pos, cs) do
    local f = format_filename_template(template, self:substring_stripped(r))
    self:add_package(f)
    if not self.packages[f] then
      f = path_join(path_split(self.filename), f)
      idx[#idx + 1] = {
        name = f,
        pos = r.pos,
        cont = r.cont,
        manuscript = self
      }
    end
  end
  return cont
end

--* Scan references callbacks

function ManuscriptLatex.scan_references_callbacks.ref(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local idx = self.ref_index
  for r in self:argument_items(first_mand, pos, cs) do
    idx[#idx + 1] = {
      name = self:substring_stripped(r),
      pos = r.pos,
      cont = r.cont,
      outer_pos = pos,
      outer_cont = cont,
      manuscript = self
    }
  end
  return cont
end

function ManuscriptLatex.scan_references_callbacks.cite(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local idx = self.cite_index
  for r in self:argument_items(first_mand, pos, cs) do
    idx[#idx + 1] = {
      name = self:substring_stripped(r),
      pos = r.pos,
      cont = r.cont,
      outer_pos = pos,
      outer_cont = cont,
      manuscript = self
    }
  end
  return cont
end

return ManuscriptLatex
