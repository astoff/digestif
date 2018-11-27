local lpeg = require "lpeg"
local util = require "digestif.util"

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

local global_callbacks = {}

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

function global_callbacks.label (m, pos, cs)
   local label_index = m.label_index
   local args = m.commands[cs].args
   local r = m:parse_cs_args(pos, cs)
   local i = first_mand(args)
   if r[i] then
      local l = m:substring_stripped(r[i])
      --m.labels[l] = {pos = r[i].pos, filename = m.filename}
      label_index[#label_index + 1] = {
         name = l,
         pos = r[i].pos,
         filename = m.filename
      }
   end
   return r.pos + r.len
end

function global_callbacks.heading (m, pos, cs)
   local section_index = m.section_index
   local args = m.commands[cs].args
   local r = m:parse_cs_args(pos, cs)
   local i = first_mand(args)
   if r[i] then
      section_index[#section_index + 1] = {
         title = m:substring_stripped(r[i]),
         pos = r[i].pos,
         level = m.commands[cs].heading_level,
         filename = m.filename
      }
   end
   return r.pos + r.len
end

-- function global_callbacks.begin(m, pos, cs)
--    local r = m:parse_cs_args(pos, cs)
--    if r[1] then
--       m:add_outline({
--             env = m:substring_stripped(r[1]),
--             pos = r[1].pos,
--             level = math.huge})
--    end
--    return r.pos + r.len
-- end

function global_callbacks.input(m, pos, cs)
   local input_index = m.input_index -- should this include the known modules, or just the filenames not know in /data?
   local args = m.commands[cs].args
   local filename = m.commands[cs].filename
   local r = m:parse_cs_args(pos, cs)
   local i = first_mand(args)
   if r[i] then
      for _, k in ipairs(m:read_keys(r[i])) do
         local f = string.format(filename, k.key)
         m:add_module(f)
         if not m.modules[f] then
            if not util.filename_is_abs(f) then
               f = util.dirname(m.filename) .. f
            end
            --m:add_children(f)  
            input_index[#input_index + 1] = {
               name = f,
               pos = r[i].pos,
               filename = m.filename
            }
         end
      end
   end
   return r.pos + r.len
end

return {
   cat_table = cat_table,
   global_callbacks = global_callbacks
}
