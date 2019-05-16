local lpeg = require "lpeg"
local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local Parser = require "digestif.Parser"

local path_join, path_split = util.path_join, util.path_split
local nested_get, nested_put = util.nested_get, util.nested_put
local map, update, merge = util.map, util.update, util.merge

local cat_table = {
   escape = lpeg.P("\\"),
   bgroup = lpeg.P("{"),
   egroup = lpeg.P("}"),
   mathshift = lpeg.P("$"),
   eol = lpeg.P("\n"),
   letter = lpeg.R("az", "AZ"),
   comment = lpeg.P("%"),
   char = lpeg.P(1), -- are we utf-8 agnostic?
   space = lpeg.S(" \t"),
}

local ManuscriptLaTeX = util.class(Manuscript)

ManuscriptLaTeX.parser = Parser(cat_table)
ManuscriptLaTeX.format = "latex"

ManuscriptLaTeX.global_callbacks =
   setmetatable({}, {__index = Manuscript.global_callbacks})
Manuscript.scan_references_callbacks = {}

-- ¶ Helper functions

--@param meta the desired meta string
--@param args a list of arg tables
local function find_by_meta(meta, args)
   for i, v in ipairs(args) do
      if meta == v.meta then return i end
   end
end

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

-- ¶ Global scan callbacks

function ManuscriptLaTeX.global_callbacks.label (m, pos, cs)
   local idx = m.label_index
   local args = m.commands[cs].args
   local r = m:parse_cs_args(pos, cs)
   local i = first_mand(args)
   if r[i] then
      local l = m:substring_stripped(r[i])
      idx[#idx + 1] = {
         name = l,
         pos = r[i].pos,
         filename = m.filename,
         cmd_pos = pos,
         manuscript = m,
         after_cmd = r.pos + r.len
      }
   end
   return r.pos + r.len
end

function ManuscriptLaTeX.global_callbacks.heading (m, pos, cs)
   local idx = m.heading_index
   local args = m.commands[cs].args
   local r = m:parse_cs_args(pos, cs)
   local i = first_mand(args)
   if r[i] then
      idx[#idx + 1] = {
         title = m:substring_stripped(r[i]),
         pos = r[i].pos,
         level = m.commands[cs].heading_level,
         filename = m.filename
      }
   end
   return r.pos + r.len
end

function ManuscriptLaTeX.global_callbacks.bibitem (m, pos, cs)
  local idx = m.bib_index
  local args = m.commands[cs].args
  local r = m:parse_cs_args(pos, cs)
  local i = first_mand(args)
  if r[i] then
    idx[#idx + 1] = {
      name = m:substring_stripped(r[i]),
      pos = r[i].pos,
      filename = m.filename
    }
  end
  return r.pos + r.len
end

-- function ManuscriptLaTeX.global_callbacks.begin(m, pos, cs)
--    local r = m:parse_cs_args(pos, cs)
--    if r[1] then
--       m:add_outline({
--             env = m:substring_stripped(r[1]),
--             pos = r[1].pos,
--             level = math.huge})
--    end
--    return r.pos + r.len
-- end

function ManuscriptLaTeX.global_callbacks.input(m, pos, cs)
   local idx = m.child_index -- should this include the known modules, or just the filenames not know in /data?
   local args = m.commands[cs].args
   local filename = m.commands[cs].filename
   local r = m:parse_cs_args(pos, cs)
   local i = first_mand(args)
   if r[i] then
      for _, k in ipairs(m:read_keys(r[i])) do
         local f = string.format(filename, k.key)
         m:add_module(f)
         if not m.modules[f] then
            f = path_join(path_split(m.filename), f)
            idx[#idx + 1] = {
               name = f,
               pos = r[i].pos,
               filename = m.filename
            }
         end
      end
   end
   return r.pos + r.len
end

-- ¶ Scan reference callbacks

function ManuscriptLaTeX.scan_references_callbacks.ref(self, pos, cs)
  local idx = self.ref_index
  local args = self.commands[cs].args
  local r = self:parse_cs_args(pos, cs)
  local i = first_mand(args)
  if r[i] then
    local l = self:substring_stripped(r[i])
    idx[#idx + 1] = {
      name = l,
      pos = r[i].pos,
      filename = self.filename,
      cmd_pos = pos,
      manuscript = self,
      after_cmd = r.pos + r.len
    }
  end
  return r.pos + r.len
end

function ManuscriptLaTeX.scan_references_callbacks.cite(self, pos, cs)
  local idx = self.cite_index
  local args = self.commands[cs].args
  local r = self:parse_cs_args(pos, cs)
  local i = first_mand(args)
  if r[i] then
    local l = self:substring_stripped(r[i])
    idx[#idx + 1] = {
      name = l,
      pos = r[i].pos,
      filename = self.filename,
      cmd_pos = pos,
      manuscript = self,
      after_cmd = r.pos + r.len
    }
  end
  return r.pos + r.len
end

return ManuscriptLaTeX
