local data = require "digestif.data"
local util = require "digestif.util"
local FileCache = require "digestif.FileCache"
local Manuscript = require "digestif.Manuscript"

local Document = util.class()

--- Create a new Document object. The argument is a table with the
--- following keys:
---
---  * master: A master manuscript object.
---  * format: A TeX format; if not provided, assumend to be same as
---   the master's, or "latex"
---  * filename
---  * src: The contents of the file
---  * timestamp
---
--- At least for now, there is no reason for this to be a separate
--- class from Manuscript.  The Document methods are more high level,
--- but could be moved to Manuscript.

function Document:_init(args)
   self.modules, self.commands, self.environments = {}, {}, {}
   self.filename = filename
   -- self.cache = args.cache or FileCache()
   -- self.root = args.root or Manuscript(args)
   self.root = Manuscript(args)
   --self.script = filename and self.master:find_children(filename) or self.master
end

function Document:find_manuscript(filename)
   return self.root:find_manuscript(filename)
end

--- Resolution

local function get_resolution(m)
   local resol = {}
   local child_resol = util.map(get_resolution, m.children)
   for _, v in pairs(util.map(get_resolution, m.children)) do
      child_resol[#child_resol+1] = v
   end
   for _, field in ipairs{"labels", "commands", "environments", "bibitems"} do
      local f = function(r) return r[field] end
      for _, v in pairs(m[field]) do v.script = m end --this should be somewhere else
      resol[field] = util.update({}, m[field], table.unpack(util.map(f, child_resol)))
   end
   return resol
end

local function gather(script, field, tbl)
   util.update(tbl, script[field])
   for _, child in pairs(script.children) do
      gather(child, field, tbl)
   end
   return tbl
end

function Document:all_commands()
   return gather(self.root, 'commands', {})
end

function Document:all_environments()
   return gather(self.root, 'environments', {})
end

--- Update the Document, resolving all dependencies
-- function Document:resolve()
--    util.update(self, get_resolution(self.root))
-- end

function Document:refresh()
   self.root:refresh()
end

--- Completion

local function compl_compare(a, b)
   return (a.sort_text or a.text) < (b.sort_text or b.text)
end

local function list_completions(prefix, t, f)
   local len = string.len(prefix)
   local r = {}
   for k, v in pairs(t) do
      if prefix == string.sub(k, 1, len) then
         r[#r + 1] = f(k, v)
      end
   end
   table.sort(r, compl_compare)
      --return completion_handlers.key(self, ctx, pos, script)
   return r
end

local function format_args(args)
   local t = {}
   for i, arg in ipairs(args or {}) do
      local l, r
      if arg.literal then
         l, r = "", ""
      elseif arg.delims == false then
         l, r = "〈", "〉"
      elseif arg.delims then
         l, r = arg.delims[1] or "{", arg.delims[2] or "}"
      else
         l, r = "{", "}"
      end
      if l == "" or r == "" then
         l, r = l .."〈", "〉" .. r
      end
      t[#t+1] = l .. (arg.literal or arg.meta or "#" .. i) .. r
   end
   return table.concat(t)
end

local function snippet_from_args(args)
   if not args then return "" end
   local t, i = {}, 0
   for _, arg in ipairs(args) do
      if arg.literal then
         if arg.optional then
            i = i + 1
            t[#t+1] = "${" .. i .. ":|," .. arg.literal .. "|}"
         else
            t[#t+1] = arg.literal
         end
      else
         i = i + 1
         local l = arg.delims and arg.delims[1] or "\\{"
         local r = arg.delims and arg.delims[2] or "\\}"
         t[#t+1] = l .. "${" .. i ..
            (arg.meta and ":" .. arg.meta) .. "}" .. r
      end
   end
   return table.concat(t)
end

local completion_handlers = {}

function completion_handlers.cs(self, ctx)
   local prefix = ctx.cs
   local len = #prefix
   local r = {
      pos = ctx.pos + 1,
      prefix = prefix,
      kind = "command"
   }
   for cs, cmd in pairs(self:all_commands()) do
      if prefix == cs:sub(1, len) then
         r[#r+1] = {
            text = cs,
            summary = cmd.doc,
            signature = format_args(cmd.args),
            snippet = cs .. snippet_from_args(cmd.args) .. "$0"
         }
      end
   end
   return r
end

function completion_handlers.key(self, ctx, pos, script)
   local prefix = script:substring(ctx.pos, pos - 1)
   local len = #prefix
   local r = {
      pos = ctx.pos,
      prefix = prefix,
      kind = "key"
   }
   local keys = ctx.parent and ctx.parent.data and ctx.parent.data.keys
   for text, key in pairs(keys or {}) do
      if prefix == text:sub(1, len) then
         r[#r+1] = {
            text = text,
            summary = key.doc
         }
      end
   end
   return r
end

function completion_handlers.value(self, ctx, pos, script)
   local prefix = script:substring(ctx.pos, pos - 1)
   local len = #prefix
   local r = {
      pos = ctx.pos,
      prefix = prefix,
      kind = "value"
   }
   local values = ctx.parent and ctx.parent.data and ctx.parent.data.values
   for text, value in pairs(values or {}) do
      if prefix == text:sub(1, len) then
         r[#r+1] = {
            text = text,
            summary = value.doc
         }
      end
   end
   return r
end

function completion_handlers.begin(self, ctx, pos, script)
   local prefix = script:substring(ctx.pos, pos - 1)
   local len = #prefix
   local r = {
      pos = ctx.pos,
      prefix = prefix,
      kind = "environment"
   }
   for text, env in pairs(self:all_environments()) do
      if prefix == text:sub(1, len) then
         r[#r+1] = {
            text = text,
            summary = env.doc,
            signature = format_args(env.args),
         }
      end
   end
   return r
end

function completion_handlers.ref(self, ctx, pos, script)
   local prefix = script:substring(ctx.pos, pos - 1)
   local len = #prefix
   local r = {
      pos = ctx.pos,
      prefix = prefix,
      kind = "label"
   }
   for label in self.root:each_of "label_index" do
      if prefix == label.name:sub(1, len) then
         r[#r+1] = {
            text = label.name
         }
      end
   end
   return r
end

-- should this take into account the Manuscript of filename, or
-- directly on the current content of filename?
function Document:complete(pos, filename)
   local script = self:find_manuscript(filename)
   local ctx = script:local_scan(pos - 1)
   if ctx == nil then return nil end
   if ctx.cs and pos == 1 + ctx.pos + #ctx.cs then -- the 1 accounts for escape char
      return completion_handlers.cs(self, ctx)
   elseif ctx.arg then
      local action = ctx.parent and ctx.parent.data and ctx.parent.data.action
      if completion_handlers[action] then
         return completion_handlers[action](self, ctx, pos, script)
      end
   elseif ctx.key and pos == ctx.pos + #ctx.key then
      return completion_handlers.key(self, ctx, pos, script)
   elseif ctx.value and pos == ctx.pos + #ctx.value then
      return completion_handlers.value(self, ctx, pos, script)
   end
end

--- Context help

function Document:get_help(pos, filename)
   local script = self:find_manuscript(filename)
   local ctx = script:local_scan(pos)
   return ctx and self:find_doc(ctx, script)
end

function Document:find_doc(ctx, script)
   local parent = ctx.parent
   local parent_action = parent and parent.data and parent.data.action
   if parent_action == "ref" then
      return {
         pos = ctx.pos, len = ctx.len,
         type = "label",
         text = "Label: " .. script:substring(ctx)
      }
   elseif parent_action == "begin" then
      return {
         pos = ctx.pos, len = ctx.len,
         type = "environment",
         text = "\\begin{" .. script:substring(ctx) .. "}",
         data = ctx.data
      }
   elseif ctx.cs then
      return ctx.data and {
         pos = ctx.pos, len = ctx.len,
         type = "command",
         text = "\\" .. ctx.cs .. format_args(ctx.data and ctx.data.args),
         data = ctx.data
      }
   elseif ctx.arg then
      return util.update(
         self:find_doc(parent) or {},
         {pos = ctx.pos, len = ctx.len, arg = ctx.arg}
      )
   elseif parent then
      return self:find_doc(parent)
   else
      return nil
   end
end

return Document
