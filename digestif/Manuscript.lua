--- Manuscript class
-- @classmod digestif.Manuscript

local FileCache = require "digestif.FileCache"
local config = require "digestif.config"
local require_data = require "digestif.data".require
local util = require "digestif.util"

local concat, sort, unpack = table.concat, table.sort, table.unpack
local path_join, path_split = util.path_join, util.path_split
local nested_get, nested_put = util.nested_get, util.nested_put
local map, update, merge = util.map, util.update, util.merge
local min, max = math.min, math.max

local matcher = util.matcher
local fuzzy_matcher = util.fuzzy_matcher

local Manuscript = util.class()

-- Only descendants of this class (representing various TeX formats)
-- are ever instantiated.  So we replace the constructor by a function
-- defering to the subclass indicated by the format field of the
-- argument.

local formats = {
  latex = "digestif.ManuscriptLaTeX",
  bibtex = "digestif.ManuscriptBibTeX"
}

local function ManuscriptFactory(_, args)
   local fmt = args.format
      or args.parent and args.parent.format
      or "latex"
   return require(formats[fmt])(args)
end
getmetatable(Manuscript).__call = ManuscriptFactory

local function guess_format(filename)
  if filename:match("%.bib$") then
    return "bibtex"
  end
end

--- Create a new manuscript object.
--
-- The argument is a table with the following keys:
-- - parent: a parent manuscript object (optional)
-- - filename: the manuscript source file (optional, not used if src is given)
-- - src: the contents of the file (optional)
-- - cache: a FileCache object (optional, typically retrived from parent)
--
-- Note also that args.format is used by ManuscriptFactory
--
function Manuscript:__init(args)
  local parent, filename, src
    = args.parent, args.filename, args.src
  self.filename = filename
  self.parent = parent
  self.root = parent and parent.root or self
  self.cache = args.cache or parent and parent.cache or FileCache()
  self.src = src or self.cache:get(filename) or ""
  self.depth = 1 + (parent and parent.depth or 0)
  self.modules = {}
  self.commands = {}
  self.environments = {}
  self.children = {}
  self.bib_index = {}
  self.child_index = {}
  self.heading_index = {}
  self.label_index = {}
  if parent then
    setmetatable(self.modules,      {__index = parent.modules}     )
    setmetatable(self.commands,     {__index = parent.commands}    )
    setmetatable(self.environments, {__index = parent.environments})
  end
  self:add_module(self.format)
  self:scan(self.init_callbacks)
  for _, item in ipairs(self.child_index) do
    self.children[item.name] = Manuscript{
      filename = item.name,
      parent = self,
      format = guess_format(item.name)
    }
  end
end

Manuscript.init_callbacks = {}

--- Get a substring of the manuscript.
--
-- The argument can be a pair of integers or a table with fields pos
-- and cont.
--
-- @param i The intial position, or a range table
-- @param j The final position (ignored if i is a table)
-- @return A string
--
function Manuscript:substring(i, j)
  if not i then return nil end
  if type(i) == "table" then
    j = i.cont - 1
    i = i.pos
  end
  return self.src:sub(i, j)
end

--- Get a substring of the manuscript, trimmed
--
-- @param i The intial position, or a range table
-- @param j The final position (ignored if i is a table)
-- @return A string
--
function Manuscript:substring_trimmed(i, j)
  return self.parser.trim(self:substring(i,j))
end

--- Get a substring of the manuscript, trimmed and without comments.
--
-- @param i The intial position, or a range table
-- @param j The final position (ignored if i is a table)
-- @return A string
--
function Manuscript:substring_stripped(i, j)
  local parser = self.parser
  return parser.trim(parser.strip_comments(self:substring(i,j)))
end

--- Get a substring of the manuscript, without commments and reduced
-- to one line.
--
-- @param i The intial position, or a range table
-- @param j The final position (ignored if i is a table)
-- @return A string
--
function Manuscript:substring_clean(i, j)
  local parser = self.parser
  return parser.clean(parser.strip_comments(self:substring(i,j)))
end

--- Parse a key-value list in a given range.
--
-- Returns a list of ranges, with additional fields "key" and "value"
-- (if present).  These are range tables as well.
--
-- @param range The range to scan
-- @return a list of annotated ranges
--
function Manuscript:parse_kvlist(range)
  local s = self:substring(1, range.cont - 1)
  return self.parser.parse_kvlist(s, range.pos)
end

--- Read the contents of a key-value list in the manuscript.
--
-- Returns a nested list of tables with fields "key" and "value" (if
-- present), containing the corresponding text in the source.
--
function Manuscript:read_keys(range)
   local tbl = self:parse_keys(range)
   local r = {}
   for i, v in ipairs(tbl) do
      r[i] = {
         key = self:substring_trimmed(v.key),
         value = v.value and self:substring_trimmed(v.value)
      }
   end
   return r
end

--- Read the contents of a list in the manuscript.
--
-- Returns a list of strings.
--
function Manuscript:read_list(i, j)
  local parser = self.parser
  local s = self:substring(i, j)
  return parser.read_list(s)
end

--- Parse the arguments of a command.
--
-- @param pos A position in the source
-- @param cs The command name (optional)
-- @return A list of ranges
--
function Manuscript:parse_command(pos, cs)
  local parser = self.parser
  if not cs then
    cs = parser.csname:match(self.src, pos) or ""
  end
  local cmd = self.commands[cs]
  local args = cmd and cmd.arguments
  local cont = 1 + pos + #cs
  if args then
    local val = parser.parse_args(args, self.src, cont)
    val.pos = pos
    return val
  else
    return {pos = pos, cont = cont}
  end
end

--- Find the line number (and its location) of a given position.
--
-- @param pos A position in the source
-- @return The line number
-- @return The line's starting position
--
function Manuscript:line_number_at(pos)
  local src_len = #self.src
  if pos < 1 then pos = src_len + pos + 1 end
  return self.cache:get_line_number(self.filename, min(pos, src_len))
end

--- Find paragraph before a position.
--
-- @param pos A position in the source
-- @return The paragraph's starting position
--
function Manuscript:find_par(pos)
  local src = self.src
  if pos < 1 then pos = #src + pos + 1 end
  local lines = self.cache:get_lines(self.filename, min(pos, #src))
  local l = self:line_number_at(pos)
  for k = l, 1, -1 do
    if self.parser.is_blank_line(src, lines[k]) then
      return lines[k]
    end
  end
  return 1
end
--    local i, j = 1, 1
--    local patt, src = self.parser.next_par, self.src
--    while i == j do
--       j = patt:match(src, i)
--       if j and j <= pos then i = j end
--    end
--    return i
-- end

local preceding_command_callbacks = {}

--- Find the preceding command, if any.
--
-- If there is a command whose arguments end right before the given
-- position, returns the position, command name, and parse data of
-- the preceding command.
--
function Manuscript:find_preceding_command(pos)
  local par_pos = self:find_par(pos)
  return self:scan(preceding_command_callbacks, par_pos, pos)
end

function preceding_command_callbacks.cs(self, pos, cs, end_pos)
  if pos > end_pos then return nil end
  local r = self:parse_command(pos, cs)
  if r.cont <= end_pos then
    local next_pos = self.parser.next_nonblank(self.src, r.cont)
    if next_pos == end_pos then
      return nil, pos, cs, r
    end
  end
  return r.cont, end_pos
end

--- Iterator to transverse a given index documentwise.
--
-- This recursevely iterates over entries of "self.name" and
-- "child.name" for each child of the manuscript, depth first.  "name"
-- refers to an index, that is, a list of tables containing an entry
-- "pos".
--
-- @param name The name of an index (a string)
--
function Manuscript:each_of(name)
   local stack = {}
   local script = self
   local items, inputs = script[name], script.child_index
   local i, j = 1, 1
   local function f()
      local item, input = items[i], inputs[j]
      if item and not (input and item.pos > input.pos) then
         i = i + 1
         return item
      elseif input then
         stack[#stack+1] = {i, j + 1, script, items, inputs}
         script = script.children[input.name]
         items = script and script[name] or {}
         inputs = script and script.inputs or {}
         i, j = 1, 1
         return f()
      elseif #stack > 0 then
         i, j, script, items, inputs = unpack(stack[#stack])
         stack[#stack] = nil
         return f()
      else
         return nil
      end
   end
   return f
end

function Manuscript:is_current()
  return (self.cache:get(self.filename) == self.src)
end

--- Reconstruct children if their cached source changed.
function Manuscript:refresh()
  for name, script in pairs(self.children) do
    if script:is_current() then
      script:refresh()
    else
      script.src = nil
      self.children[name] = Manuscript(script)
    end
  end
end

--- Scan the Manuscript, executing callbacks for each document element.
--
-- Each callback is a function taking at least two arguments (a
-- Manuscript object and a source position) and returns at least one
-- value, a position to continue scanning or nil to interrupt the
-- process.  When this happens, scan function returns the remaining
-- return values of the callback.  The remaining arguments and return
-- values of a callback can be used to keep track of an internal
-- state.
--
-- Indices of the callback table can be either the "action" field of a
-- command, or a "type" field of a thing ("cs", "mathshift" or "par").
--
-- @param callbacks A table of callback functions
-- @param pos Starting position of the scan
--
function Manuscript:scan(callbacks, pos, ...)
  local patt = self.parser.next_thing
  local match = patt.match
  local commands = self.commands
  local src = self.src
  local function scan(pos0, ...)
    if not pos0 then return ... end
    local pos1, kind, detail, pos2 = match(patt, src, pos0)
    local cmd = (kind == "cs") and commands[detail]
    local cb = cmd and callbacks[cmd.action] or callbacks[kind]
    if cb then
      return scan(cb(self, pos1, detail, ...))
    else
      return scan(pos2, ...)
    end
  end
  return scan(pos or 1, ...)
end

function Manuscript:add_module(name)
  if self.modules[name] then return end
  local mod = require_data(name)
  if not mod then return end
  self.modules[name] = mod
  if mod.dependencies then
    for _, n in ipairs(mod.dependencies) do
      self:add_module(n)
    end
  end
  if mod.commands then
    update(self.commands, mod.commands)
  end
  if mod.environments then
    update(self.environments, mod.environments)
  end
end

function Manuscript:add_children(filename)
   if self.depth > 15 then return end
   filename = path_join(path_split(self.filename), filename)
   self.children[filename] = true
end

function Manuscript:find_manuscript(filename)
   if self.filename == filename then return self end
   for _, m in pairs(self.children) do
      local c = m:find_manuscript(filename)
      if c then return c end
   end
   return nil
end

function Manuscript:add_outline(e, tree)
   tree = tree or self.outline
   local last = tree[#tree]
   if last == nil or last.level >= e.level then
      tree[#tree + 1] = e
   else
      self:add_outline(e, last.children)
   end
end

-- ¶ Local scanning (get local context)

--- Scan the current paragraph, returning the context.
--
-- This is a list of nested annotated ranges, starting from the
-- innermost.
--
-- @param pos A position in the source
-- @return A nested list of annotated ranges
--
function Manuscript:get_context(pos)
   return self:scan(self.context_callbacks, self:find_par(pos), nil, pos)
end

local function local_scan_parse_keys(m, context, pos)
  local items = m:parse_kvlist(context)
  for _, it in ipairs(items) do -- are we inside a key/list item?
    if it.pos and it.pos <= pos and pos <= it.cont then
      local key = m:substring_trimmed(it.key)
      context = {
        key = key,
        data = util.nested_get(context.data.keys, key), -- or fetch context-dependent keys, say on a usepackage
        pos = it.pos,
        cont = it.cont,
        parent = context
      }
      local v = it.value
      if v and v.pos and v.pos <= pos and pos <= v.cont then -- are we inside the value of a key?
        local value = m:substring_trimmed(v)
        context = {
          value = value,
          data = util.nested_get(context.data.values, value), -- what if "value" is command-like?
          pos = v.pos,
          cont = v.cont,
          parent = context
        }
      end
      break
    end
  end
  return context
end

Manuscript.context_callbacks = {}

function Manuscript.context_callbacks.cs(self, pos, cs, context, end_pos)
  if pos > end_pos then return nil, context end -- stop parse
  local r = self:parse_command(pos, cs)
  if end_pos <= r.cont then
    context = {
      cs = cs,
      data = self.commands[cs],
      pos = pos,
      cont = r.cont,
      parent = context
    }
  elseif cs == "begin" then
    local env_name = self:substring(r[1])
    local env = self.environments[env_name]
    local args = env and env.arguments
    if not args then return r.cont, context, end_pos end
    local q = self.parser.parse_args(args, self.src, r.cont)
    if q.cont < end_pos then
      return q.cont, context, end_pos -- end_pos is after current thing
    end
    context = {
      env = env_name,
      data = self.environments[env_name],
      pos = pos,
      cont = q.cont,
      parent = context
    }
    r = q
  else -- pos is after current thing
    return r.cont, context, end_pos
  end

  for i, arg in ipairs(r) do -- are we inside an argument?
    if arg.pos and arg.pos <= end_pos and end_pos <= arg.cont then
      context = {
        arg = i,
        data = nested_get(context.data, "arguments", i),
        pos = arg.pos,
        cont = arg.cont,
        parent = context
      }
      if context.data and context.data.keys then
        context = local_scan_parse_keys(self, context, end_pos)
      end
      return context.pos, context, end_pos
    end
  end
  return nil, context -- stop parse
end

function Manuscript.context_callbacks.tikzpath(m, pos, cs, context, end_pos)
  if pos > end_pos then return nil, context end -- stop parse
  local r = m:parse_command(pos, cs)
  if end_pos <= r.cont then
    context = {
      cs = cs,
      data = m.commands[cs],
      pos = pos,
      cont = r.cont,
      parent = context
    }
    local p = r[1].pos
    while p <= end_pos do
      local q = m.parser.skip_to_bracketed(m.src, p)
      if q and q.pos <= end_pos and end_pos <= q.cont then
        context = {
          arg = true,
          data = {keys = require_data"tikz-extracted".keys},
          pos = q.pos,
          cont = q.cont,
          parent = context
        }
        context = local_scan_parse_keys(m, context, end_pos)
      end
      p = q and q.cont or math.huge
    end
  end
  return r.cont, context, end_pos
end

function Manuscript.context_callbacks.par (_, _, _, context)
   return nil, context
end

-- ¶ Completion

local function gather(script, field, tbl)
  update(tbl, script[field])
  for _, child in pairs(script.children) do
    gather(child, field, tbl)
  end
  return tbl
end

function Manuscript:all_commands()
  return gather(self.root, 'commands', {})
end

function Manuscript:all_environments()
  return gather(self.root, 'environments', {})
end

--- Pretty-print an argument list
--
-- @param args An argument list
-- @return A string
--
local function format_args(args)
  if not args then return nil end
  local t = {}
  for i, arg in ipairs(args) do
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
  return concat(t)
end

--- Make a snippet string from args.
--
-- @param before A string added at the beginning, typically the command
-- name
-- @param after A string added at the end; default value is "$0"
-- @return The snippet string

local function make_snippet(before, args, after)
   local t, i = {before}, 0
   for _, arg in ipairs(args) do
      if arg.literal then
         if arg.optional then
            i = i + 1
            t[#t+1] = "${" .. i .. ":" .. arg.literal .. "}"
         else
            t[#t+1] = arg.literal
         end
      else
         i = i + 1
         if arg.optional then -- include delimiter in selection, to allow deletion
           local l = arg.delims and arg.delims[1] or "{"
           local r = arg.delims and arg.delims[2] or "\\}"
           t[#t+1] = "${" .. i .. ":" .. l .. (arg.meta or "") .. r .. "}"
         else
           local l = arg.delims and arg.delims[1] or "{"
           local r = arg.delims and arg.delims[2] or "}"
           t[#t+1] = l .. "${" .. i .. (arg.meta and ":" .. arg.meta or "") .. "}" .. r
         end
      end
   end
   t[#t+1] = after or "$0"
   return concat(t)
end

--- Calculate completions for the manuscript at the given point.
--
-- @param pos A position in the source
-- @return A list of completions
--
function Manuscript:complete(pos)
  local ctx = self:get_context(pos - 1)
   if ctx == nil then return nil end
   if ctx.cs and pos == 1 + ctx.pos + #ctx.cs then -- the 1 accounts for escape char
      return self.completion_handlers.cs(self, ctx)
   elseif ctx.arg then
      local action = ctx.parent and ctx.parent.data and ctx.parent.data.action
      if self.completion_handlers[action] then
         return self.completion_handlers[action](self, ctx, pos)
      end
   elseif ctx.key then --and pos == ctx.pos + #ctx.key then
      return self.completion_handlers.key(self, ctx, pos)
   elseif ctx.value and pos == ctx.pos + #ctx.value then
      return self.completion_handlers.value(self, ctx, pos)
   end
end

Manuscript.completion_handlers = {}

function Manuscript.completion_handlers.cs(self, ctx)
  local extra_snippets = config.extra_snippets
  local prefix = ctx.cs
  local len = #prefix
  local r = {
    pos = ctx.pos + 1,
    prefix = prefix,
    kind = "command"
  }
  local s = string.sub
  for cs, cmd in pairs(self:all_commands()) do
    if prefix == cs:sub(1, len) then
      local args = cmd.arguments
      local user_snippet = extra_snippets[cs]
      r[#r+1] = {
        text = cs,
        summary = cmd.summary,
        detail = args and format_args(args) or cmd.symbol,
        snippet = user_snippet or args and make_snippet(cs, args)
      }
    end
  end
  for cs, cmd in pairs(self:all_environments()) do
    if prefix == cs:sub(1, len) then
      local args = cmd.arguments or {}
      local user_snippet = extra_snippets[cs]
      local snippet_begin = "begin{" .. cs .. "}"
      local snippet_end = "\n\t$0\n\\end{" .. cs .. "}"
      local detail = args and format_args(args)
      r[#r+1] = {
        text = cs,
        filter_text = cs,
        summary = cmd.summary,
        detail = (detail or "") .. (detail and " " or "") .. "(environment)",
        snippet = user_snippet or make_snippet(snippet_begin, args, snippet_end)
      }
    end
  end
  return r
end

function Manuscript.completion_handlers.key(self, ctx, pos)
   local prefix = self:substring(ctx.pos, pos - 1)
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
            summary = key.summary
         }
      end
   end
   return r
end

function Manuscript.completion_handlers.value(self, ctx, pos)
   local prefix = self:substring(ctx.pos, pos - 1)
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
            summary = value.summary
         }
      end
   end
   return r
end

function Manuscript.completion_handlers.begin(self, ctx, pos)
   local prefix = self:substring(ctx.pos, pos - 1)
   local len = #prefix
   local r = {
      pos = ctx.pos,
      prefix = prefix,
      kind = "environment"
   }
   for text, env in pairs(self.root:all_environments()) do
      if prefix == text:sub(1, len) then
         r[#r+1] = {
            text = text,
            summary = env.summary,
            detail = format_args(env.arguments),
         }
      end
   end
   return r
end

-- move to ManuscriptLaTeX?
function Manuscript:label_context_short(item)
  local pos, cs, r = self:find_preceding_command(item.outer_pos)
  local cmd = self.commands[cs]
  if not cmd then
    pos = self.parser.next_nonblank(self.src, item.outer_pos)
  end
  return self:substring_clean(pos, pos + 100)
end

function Manuscript.completion_handlers.ref(self, ctx, pos)
   local prefix = self:substring(ctx.pos, pos - 1)
   local len = #prefix
   local r = {
      pos = ctx.pos,
      prefix = prefix,
      kind = "label"
   }
   for label in self.root:each_of "label_index" do
      if prefix == label.name:sub(1, len) then
         r[#r+1] = {
            text = label.name,
            detail = label.manuscript:label_context_short(label),
            summary = label.manuscript:label_context_long(label),
         }
      end
   end
   return r
end

function Manuscript.completion_handlers.cite(self, ctx, pos)
  if ctx.data.optional then return end
  local prefix = self:substring(ctx.pos, pos - 1)
  local r = {
    pos = ctx.pos,
    prefix = prefix,
    kind = "bibitem"
  }
  local scores = {}
  local exact_match = matcher(prefix)
  local fuzzy_match = fuzzy_matcher(prefix)
  for item in self.root:each_of "bib_index" do
    local score = exact_match(item.name) and math.huge
      or fuzzy_match(item.text)
    if score then
      scores[item.name] = score
      r[#r+1] = {
        text = item.name,
        summary = item.text, --rename this field to detail
        detail = item.text
      }
    end
  end
  local cmp = function(a, b)
    local na, nb = a.text, b.text
    local sa, sb = scores[na], scores[nb]
    if sa == sb then
      return (na < nb)
    else
      return (sa > sb)
    end
  end
  sort(r, cmp)
  return r
end

-- ¶ Context help

--- Get information about the thing at the given position.
--
-- @param pos A position in the source
--
function Manuscript:get_help(pos)
  local ctx = self:get_context(pos)
  if not ctx then return nil end
  local action = nested_get(ctx, "parent", "data", "action")
  local handlers = self.help_handlers
  if handlers[action] then
    return handlers[action](self, ctx)
  elseif ctx.cs then
    return handlers.cs(self, ctx)
  elseif ctx.arg then
    return handlers.arg(self, ctx)
  elseif ctx.key then
    return handlers.key(self, ctx)
  else
    return nil
  end
end

Manuscript.help_handlers = {}

function Manuscript.help_handlers.cite(self, ctx)
  local name = self:substring(ctx)
  for item in self.root:each_of "bib_index" do
    if name == item.name then
      return {
        pos = ctx.pos,
        cont = ctx.cont,
        kind = "bibitem",
        text = item.name,
        detail = item.text
      }
    end
  end
end

function Manuscript:label_context_long(item)
  local pos, cs, r = self:find_preceding_command(item.outer_pos)
  if not pos then pos = item.outer_pos end
  local l = self:line_number_at(pos)
  local lines = self.cache:get_lines(self.filename)
  local end_pos = lines[l + 5]
  if end_pos then
    return self:substring_trimmed(pos, end_pos - 1)
  else
    return self:substring_trimmed(pos, -1)
  end
end

function Manuscript.help_handlers.ref(self, ctx)
  local name = self:substring(ctx)
  for item in self.root:each_of "label_index" do
    if name == item.name then
      local script = item.manuscript
      return {
        pos = ctx.pos,
        cont = ctx.cont,
        kind = "label",
        text = name,
        detail = script:label_context_long(item)
      }
    end
  end
  return {
    pos = ctx.pos,
    cont = ctx.cont,
    kind = "label",
    text = name,
    detail = "Unknown label"
  }
end

function Manuscript.help_handlers.begin(self, ctx)
  local env_name = self:substring(ctx)
  local data = self.environments[env_name]
  if not data then return nil end
  local args = data.arguments
  return {
    pos = ctx.pos,
    cont = ctx.cont,
    kind = "environment",
    text = "\\begin{" .. env_name .. "}" .. (args and format_args(args) or ""),
    detail = data.summary,
    data = data
  }
end

Manuscript.help_handlers['end'] = function(self, ctx)
  local env_name = self:substring(ctx)
  local data = self.environments[env_name]
  if not data then return nil end
  return {
    pos = ctx.pos,
    cont = ctx.cont,
    kind = "environment",
    text = "\\end{" .. env_name .. "}",
    detail = data.summary,
    data = data
  }
end

function Manuscript.help_handlers.cs(self, ctx)
  local data = ctx.data
  if not data then return nil end
  local args = data and data.arguments
  local doc = data.summary
  local symbol = data.symbol
  return {
    pos = ctx.pos,
    cont = ctx.cont,
    kind = "command",
    text = "\\" .. ctx.cs .. (args and format_args(args) or ""),
    detail = (doc or "") .. (symbol and " (" .. symbol .. ")" or ""),
    data = data
  }
end

function Manuscript.help_handlers.arg(self, ctx)
  if ctx.parent.cs then
    return update(
      self.help_handlers.cs(self, ctx.parent),
      {pos = ctx.pos, cont = ctx.cont, arg = ctx.arg})
  end
end

function Manuscript.help_handlers.key(self, ctx)
  local key = ctx.key
  local data = nested_get(ctx.parent, "data", "keys", key)
  if not data then return nil end
  return {
    pos = ctx.pos,
    cont = ctx.cont,
    kind = "key",
    text = key,
    detail = data.summary,
    data = data
  }
end


-- ¶ Find definition

--- Find the location where the thing at the given position is
--- defined.
--
-- @param pos A position in the source
-- @return An annotated range table
--
function Manuscript:find_definition(pos)
  local ctx = self:get_context(pos)
  if not ctx then return nil end
  local action = nested_get(ctx, "parent", "data", "action")
  local handlers = self.find_definition_handlers
  if handlers[action] then
    return handlers[action](self, ctx)
  -- elseif ctx.cs then -- TODO
  --   return handlers.cs(self, ctx)
  else
    return nil
  end
end

Manuscript.find_definition_handlers = {}

function Manuscript.find_definition_handlers.ref(self, ctx)
  local name = self:substring(ctx)
  for item in self.root:each_of "label_index" do
    if name == item.name then
      return {
        pos = item.pos,
        cont = item.cont,
        manuscript = item.manuscript,
        kind = "label"
      }
    end
  end
end

function Manuscript.find_definition_handlers.cite(self, ctx)
  local name = self:substring(ctx)
  for item in self.root:each_of "bib_index" do
    if name == item.name then
      return {
        pos = item.pos,
        cont = item.cont,
        manuscript = item.manuscript,
        kind = "bibitem"
      }
    end
  end
end

-- ¶ Find references

function Manuscript:scan_references()
  if not self.ref_index then
    self.ref_index = {}
    self.cite_index = {}
    self:scan(self.scan_references_callbacks)
  end
  for _, script in pairs(self.children) do
    script:scan_references()
  end
end

Manuscript.scan_references_callbacks = {}

function Manuscript:scan_control_sequences()
  if not self.cs_index then
    self.cs_index = {}
    self:scan(self.scan_cs_callbacks)
  end
  for _, script in pairs(self.children) do
    script:scan_control_sequences()
  end
end

Manuscript.scan_cs_callbacks = {}

function Manuscript.scan_cs_callbacks.cs(self, pos, cs)
  local idx = self.cs_index
  local cont = pos + 1 + #cs
  idx[#idx + 1] = {
    name = cs,
    pos = pos,
    cont = cont,
    manuscript = self,
  }
  return cont
end

--- List all references to the thing at the given position
--
-- @param pos A position in the source
-- @return A list of annotated ranges
--
function Manuscript:find_references(pos)
  local ctx = self:get_context(pos)
  if not ctx then return nil end
  local action = nested_get(ctx, "parent", "data", "action")
  local handlers = self.find_references_handlers
  if handlers[action] then
    self.root:scan_references()
    return handlers[action](self, ctx)
  elseif ctx.cs then
    self.root:scan_control_sequences()
    return handlers.cs(self, ctx)
  else
    return nil
  end
end

Manuscript.find_references_handlers = {}

function Manuscript.find_references_handlers.cs(self, ctx)
  local name = ctx.cs
  local r = {}
  for item in self.root:each_of "cs_index" do
    if name == item.name then
      r[#r + 1] = {
        pos = item.pos,
        cont = item.cont,
        manuscript = item.manuscript,
        kind = "cs"
      }
    end
  end
  return r
end

function Manuscript.find_references_handlers.ref(self, ctx)
  local name = self:substring(ctx)
  local r = {}
  for item in self.root:each_of "ref_index" do
    if name == item.name then
      r[#r + 1] = {
        pos = item.pos,
        cont = item.cont,
        manuscript = item.manuscript,
        kind = "label"
      }
    end
  end
  return r
end

Manuscript.find_references_handlers.label =
  Manuscript.find_references_handlers.ref

function Manuscript.find_references_handlers.cite(self, ctx)
  local name = self:substring(ctx)
  local r = {}
  for item in self.root:each_of "cite_index" do
    if name == item.name then
      r[#r + 1] = {
        pos = item.pos,
        cont = item.cont,
        manuscript = item.manuscript,
        kind = "bibitem"
      }
    end
  end
  return r
end

return Manuscript
