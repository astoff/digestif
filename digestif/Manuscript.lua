-- Manuscript class

local config = require "digestif.config"
local util = require "digestif.util"

local require_data = require "digestif.data".require
local get_info = require "digestif.data".get_info
local resolve_doc_items = require "digestif.data".resolve_doc_items
local path_join, path_split = util.path_join, util.path_split
local path_normalize = util.path_normalize
local find_file = util.find_file
local format_filename_template = util.format_filename_template

local format = string.format
local co_wrap, co_yield = coroutine.wrap, coroutine.yield
local concat, sort = table.concat, table.sort
local infty, min = math.huge, math.min
local utf8_len, utf8_offset = utf8.len, utf8.offset
local nested_get = util.nested_get
local map_keys, update, extend = util.map_keys, util.update, util.extend
local line_indices = util.line_indices
local matcher, fuzzy_matcher = util.matcher, util.fuzzy_matcher

local Manuscript = util.class()

--* Constructor

-- Only descendants of this class (representing various TeX formats)
-- are ever instantiated.  So we replace the constructor by a function
-- defering to the subclass indicated by the format field of the
-- argument.

local formats = {
  ["bibtex"]     = "digestif.ManuscriptBibTeX",
  ["context"]    = "digestif.ManuscriptConTeXt",
  ["latex"]      = "digestif.ManuscriptLaTeX",
  ["latex-prog"] = "digestif.ManuscriptLatexProg",
  ["doctex"]     = "digestif.ManuscriptDoctex",
  ["plain"]      = "digestif.ManuscriptPlainTeX",
  ["texinfo"]    = "digestif.ManuscriptTexinfo"
}

local function ManuscriptFactory(_, args)
  local fmt = args.format
    or args.parent and args.parent.format
    or error "TeX format not specified"
  return require(formats[fmt])(args)
end
getmetatable(Manuscript).__call = ManuscriptFactory

local function infer_format(path)
  local ext = path:sub(-4)
  if ext == ".bib" then
    return "bibtex"
  elseif ext == ".sty" or ext == ".cls" then
    return "latex-prog"
  end
end

-- Create a new manuscript object.  The argument is a table with the
-- following keys:
--
-- filename: the manuscript's file name
-- files: a function that returns file contents
-- parent: a parent manuscript object (optional)
-- format: the TeX format ("latex", "plain", etc.).  This is
--   actually only used by ManuscriptFactory
--
function Manuscript:__init(args)
  local filename, parent, files = args.filename, args.parent, args.files
  self.filename = filename
  self.parent = parent
  self.files = files
  self.root = parent and parent.root or self
  local src, cache_cookie = files(filename)
  self.src, self.cache_cookie = src or "", cache_cookie
  self.lines = line_indices(self.src)
  local super = parent or self.__index
  self.packages = setmetatable({}, {__index = super.packages})
  self.commands = setmetatable({}, {__index = super.commands})
  self.environments = setmetatable({}, {__index = super.environments})
  -- We eagerly initialize most indexes here because the overhead of
  -- going through the document is substantial.  Only the indices used
  -- by Manuscript:find_references are computed on demand.
  self._children = {}
  self.bib_index = {}
  self.child_index = {}
  self.section_index = {}
  self.label_index = {}
  if self.init_callbacks then
    self:scan(self.init_callbacks)
  end
end

function Manuscript:is_current()
  local current_src, cookie = self.files(self.filename)
  return (self.src == (current_src or "")) and (cookie or true)
end

-- Return a child manuscript, provided its name appear in the
-- child_index.  It inherits this manuscript's `files` function.
-- Memoization is used to make this efficient.
function Manuscript:child(name)
  local child = self._children[name]
  local is_current = child and child:is_current()
  if not is_current then
    if not child then
      local ancestor = self
      while ancestor do
        if ancestor.filename == name then return end
        ancestor = ancestor.parent
      end
    end
    child = Manuscript{
      filename = name,
      parent = self,
      format = infer_format(name),
      files = self.files
    }
    self._children[name] = child
  end
  return child
end

--* Substrings

-- Get a substring of the manuscript. The argument can be a pair of
-- integers (inclusive indices, as in the Lua convention) or a table
-- with fields pos (inclusive) and cont (exclusive).
function Manuscript:substring(i, j)
  if not i then return nil end
  if type(i) == "table" then
    j = i.cont - 1
    i = i.pos
  end
  return self.src:sub(i, j)
end

-- Get a substring of the manuscript, trimmed.  The argument follows
-- the same convention as Manuscript:substring.
function Manuscript:substring_trimmed(i, j)
  return self.parser.trim(self:substring(i,j))
end

-- Get a substring of the manuscript, trimmed and without comments.
-- The argument follows the same convention as Manuscript:substring.
function Manuscript:substring_stripped(i, j)
  local parser = self.parser
  return parser.trim(parser.strip_comments(self:substring(i,j)))
end

-- Get a substring of the manuscript, without commments and reduced to
-- one line.  The argument follows the same convention as
-- Manuscript:substring.
function Manuscript:substring_clean(i, j)
  local parser = self.parser
  return parser.clean(parser.strip_comments(self:substring(i,j)))
end

--* Parsing commands, lists, and key-value lists.

-- Parse a key-value list in a given manuscript range.  The argument
-- is a table with fields pos and cont.  Returns a list of ranges,
-- with additional fields "key" and "value" (if present).  These are
-- range tables as well.
function Manuscript:parse_kvlist(range)
  local s = self:substring(1, range.cont - 1) -- TODO: avoid creating a new string
  return self.parser.parse_kvlist(s, range.pos)
end

-- Read the contents of a key-value list in the manuscript.  The
-- argument is a table with fields pos and cont.  Returns a nested
-- list of tables with fields "key" and "value" (if present),
-- containing the corresponding text in the source.
--
-- TODO: add substring method as parameter
function Manuscript:read_keys(range)
   local tbl = self:parse_kvlist(range)
   local r = {}
   for i, v in ipairs(tbl) do
      r[i] = {
         key = self:substring_trimmed(v.key),
         value = v.value and self:substring_trimmed(v.value)
      }
   end
   return r
end

-- Read the contents of a list in the manuscript.  Returns a list of
-- strings.
function Manuscript:read_list(i, j)
  local parser = self.parser
  local s = self:substring(i, j)
  return parser.read_list(s)
end

-- Parse the arguments of a command.
--
-- Arguments:
--   pos (number): A position in the source.
--   cs (string, optional): The command name.  If omitted, it is read
--     from the manuscript.
--
-- Returns:
--   A list of ranges.
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

--* Find line numbers, paragraphs, etc.

-- Find the line number (and its location) of a given position.
-- Returns the line number (1-based) and that line's starting
-- position.
function Manuscript:line_number_at(pos)
  local len = #self.src
  local lines = self.lines
  local j, l = 1, #lines -- top and bottom bounds for line search
  if pos < 1 then pos = len + pos + 1 end
  while pos < lines[l] do
    local k = (j + l + 1) // 2
    if pos < lines[k] then
      l = k - 1
    else
      j = k
    end
  end -- now l = correct line, 1-based indexing
  return l, lines[l]
end

-- Compute the line and column number (both 1-based) at the given
-- position.
--
-- TODO: make len function a parameter
function Manuscript:line_column_at(pos)
  -- Out ranges are excluside on the right, Lua is inclusive, so we
  -- may have pos == 1 + #self.src.
  pos = min(pos, #self.src)
  local l, line_pos = self:line_number_at(pos)
  local c = utf8_len(self.src, line_pos, pos) or error("Invalid UTF-8")
  return l, c
end

-- Compute the source position at the given line an column.
--
-- TODO: make offset function a parameter
function Manuscript:position_at(line, col)
  local line_pos = self.lines[line] or error("Position out of bounds")
  return utf8_offset(self.src, col, line_pos) or error("Position out of bounds")
end


-- Find beginning of the paragraph containing the given position.
function Manuscript:find_par(pos)
  local src = self.src
  local lines = self.lines
  local l = self:line_number_at(pos)
  for k = l, 1, -1 do
    if self.parser.is_blank_line(src, lines[k]) then
      return lines[k]
    end
  end
  return 1
end

local preceding_command_callbacks = {}

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

-- Find the preceding command, if any.  If there is a command whose
-- arguments end right before the given position, returns the
-- position, command name, and parse data of the preceding command.
function Manuscript:find_preceding_command(pos)
  local par_pos = self:find_par(pos)
  return self:scan(preceding_command_callbacks, par_pos, pos)
end

--* Indexes and document traversal

function Manuscript:get_index(name)
  name = name .. "_index"
  local idx = self[name]
  if not idx then
    idx = {}
    self[name] = idx
  end
  return idx
end

function Manuscript:index_pairs(name)
  return ipairs(self:get_index(name))
end

local function compare_pos(x, y)
  return x.pos < y.pos
end

local function traverse_indexes(script, indexes, max_depth)
  local items = {}
  for i = 1, #indexes do
    local idx_name = indexes[i]
    local idx = script[idx_name]
    for j = 1, (idx and #idx or 0) do
      items[#items+1] = idx[j]
      items[idx[j]] = idx_name
    end
  end
  if max_depth > 0 then
    local child_index = script.child_index
    for i = 1, #child_index do
      local item = child_index[i]
      local child = script:child(item.name)
      if child then
        items[#items+1] = {
          pos = item.pos,
          manuscript = child
        }
      end
    end
  end
  sort(items, compare_pos)
  for i = 1, #items do
    local item = items[i]
    local kind = items[item]
    if kind then
      co_yield(item, kind)
    else
      traverse_indexes(item.manuscript, indexes, max_depth - 1)
    end
  end
end

-- Iterator to transverse an index documentwise.  This recursevely
-- iterates over entries of the given indexes on self and its
-- children, depth first.  An index is a Manuscript field consisting a
-- list of tables containing an entry "pos".  At each iteration,
-- yields one index entry and the name of the index to which it
-- belongs.
--
-- Arguments:
--   indexes: is the name of an index, as a string, or a list of
--     such.
--   max_depth: optional, leave at the default for the recursive
--     behavior or set to 0 to disable it.
--
function Manuscript:traverse(indexes, max_depth)
  if type(indexes) == "string" then indexes = {indexes} end
  return co_wrap(function ()
    return traverse_indexes(self, indexes, max_depth or 15)
  end)
end


local function argument_items(script, sel, pos, cs)
  local args = script.commands[cs].arguments
  if not args then return end
  local i
  if type(sel) == "number" then
    i = sel
  elseif type(sel) == "string" then
    for j = 1, #args do
      if args[j].meta == sel then i = j; break end
    end
  else
    i = sel(args)
  end
  if not i then return end
  local ranges = script:parse_command(pos, cs)
  local range = ranges[i]
  if not range or range.omitted then return end
  local arg = args[i]
  if arg.list then
    local items = script:parse_kvlist(range)
    for j = 1, #items do
      co_yield(items[j])
    end
  else
    co_yield(range)
  end
end

-- Iterator to look at arguments of a command.  Yields the range of
-- the relevant argument (if present), or succesive ranges
-- corresponding to the argument's subitems, if the argument's `list`
-- property is true.
--
-- Arguments:
--   sel: determines which argument to look for; it it's a string, the
--     first argument with that meta property is used; otherwise, sel
--     should be a function that takes an `arguments` table and return
--     the relevant index.
--   pos: the position of the command to analyze
--   cs: optional, the name of the command
--
function Manuscript:argument_items(sel, pos, cs)
  return co_wrap(function() return argument_items(self, sel, pos, cs) end)
end


--* Manuscript scanning

-- Scan the Manuscript, executing callbacks for each document element.
--
-- Each callback is a function taking at least two arguments (a
-- Manuscript object and a source position) and returns at least one
-- value, a position to continue scanning or nil to interrupt the
-- process.  When this happens, scan function returns the remaining
-- return values of the callback.  The remaining arguments and return
-- values of a callback can be used to keep track of an internal
-- state.
--
-- The callbacks argument is a table.  Its keys correspond to either
-- the "action" field of a command, or the "type" field of an item
-- found by the parser ("cs", "mathshift" or "par").
--
function Manuscript:scan(callbacks, pos, ...)
  local patt = self.parser.scan_patt(callbacks)
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

-- Copy entries from t to s, but only if not already present.
local function copy_new(s, t)
  for k, v in pairs(t) do
    if not s[k] then s[k] = v end
  end
end

-- Adds a package to the manuscript.  This entails copying the command
-- and environment definitions from the package tags to the
-- manuscript.  Returns true if package is (or already was) present,
-- nil if the package tags weren't not found.
function Manuscript:add_package(name)
  if self.packages[name] then return true end
  local pkg = require_data(name)
  if not pkg then return end
  self.packages[name] = pkg
  local deps =  pkg.dependencies or pkg.package and pkg.package.dependencies -- TODO: use only the former case
  if deps then
    for _, n in ipairs(deps) do
      self:add_package(n)
    end
  end
   -- Don't overwrite stuff from generated data files
  local update_fn = pkg.generated and copy_new or update
  if pkg.commands then
    update_fn(self.commands, pkg.commands)
  end
  if pkg.environments then
    update_fn(self.environments, pkg.environments)
  end
  return true
end

function Manuscript:find_manuscript(filename)
  if self.filename == filename then return self end
  local idx = self.child_index
  for i = 1, #idx do
    local script = self:child(idx[i].name)
    local found = script and script:find_manuscript(filename)
    if found then return found end
  end
  return nil
end

--* Getting the local context

-- The context at a given manuscript postion is described by a linked
-- list list of ranges, starting from the innermost, with additional
-- annotations.  More specifically, the following fields are possible
-- in a context description table:
--
-- pos: the starting position
-- cont: the ending postiion (exclusive)
-- parent: a similar table, with range including the current range
-- cs: if present, indicates that this range correspond to a command
--   and its arguments.  The value of this field is the command name.
-- env: if present, indicates that this range correspond to an
--   environment beginning and its arguments.  The value of this field
--   is the environment name.
-- arg: if present, indicates that this range is a command argument.
--   The value corresponds to the argument number.  The parent is of
--   "cs" or "env" type.
-- key: if present, indicates this range is one item in a plain list
--   or key-value list.  The value of this field is the key text.
-- value: if present, indicates this range is the value of a key in a
--   key-value list.  the parent is of "key" type.
-- data: in each case above, data contains the corresponding data
--   object, for instance the command description.
--

-- Scan the current paragraph, returning the context around the given
-- position.
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
        data = nested_get(context.data, "keys", key), -- or fetch context-dependent keys, say on a usepackage
        pos = it.pos,
        cont = it.cont,
        parent = context
      }
      local v = it.value
      if v and v.pos and v.pos <= pos and pos <= v.cont then -- are we inside the value of a key?
        local value = m:substring_trimmed(v)
        context = {
          value = value,
          data = nested_get(context.data, "values", value), -- what if "value" is command-like?
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

local function local_scan_parse_list(m, context, pos)
  local items = m:parse_kvlist(context)
  for i = 1, #items do -- are we inside a key/list item?
    local it = items[i]
    if it.pos and it.pos <= pos and pos <= it.cont then
      context = {
        item = i,
        pos = it.pos,
        cont = it.cont,
        parent = context
      }
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
      local data = nested_get(context.data, "arguments", i)
      context = {
        arg = i,
        data = data,
        pos = arg.pos,
        cont = arg.cont,
        parent = context
      }
      if data and data.keys then
        context = local_scan_parse_keys(self, context, end_pos)
      elseif data and data.list then
        context = local_scan_parse_list(self, context, end_pos)
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
          data = {keys = require_data"tikz".keys.tikz},
          pos = q.pos,
          cont = q.cont,
          parent = context
        }
        context = local_scan_parse_keys(m, context, end_pos)
      end
      p = q and q.cont or infty
    end
  end
  return r.cont, context, end_pos
end

function Manuscript.context_callbacks.par (_, _, _, context)
   return nil, context
end

--* Snippets and pretty-printing commands

-- Pretty-print an argument list.
--
-- Arguments:
--   args: A list of argument descriptors
--   before: A piece of text inserted at the beginning of the
--     formatted argument list.
-- Returns:
--   The formatted argument list (as a string) and a list of numbers
--   (of length twice that of args) indicating the positions of each
--   argument within that string.
--
function Manuscript:signature_args(args, before)
  if not args then return before or "", {} end
  local t, p, pos = {before}, {}, 1 + (before and #before or 0)
  for i = 1, #args do
    local arg, l, r = args[i]
    if arg.literal then
      l, r = "", ""
    elseif arg.delimiters == false then
      l, r = "‹", "›"
    elseif arg.delimiters then
      l, r = arg.delimiters[1], arg.delimiters[2]
      if r == "\n" then r = "⤶" end
      if l == "" then l, r = "‹", "›" .. r end
    else
      l, r = "{", "}"
    end
    local text = arg.literal or arg.meta or "#" .. i
    t[#t+1] = l; pos = pos + #l; p[#p+1] = pos
    t[#t+1] = text; pos = pos + #text; p[#p+1] = pos
    t[#t+1] = r; pos = pos + #r
  end
  return concat(t), p
end

-- Pretty-print a command signature.
--
-- Arguments:
--   cs: The command name.
--   args: An argument list, or nil.
--
function Manuscript:signature_cmd(cs, args)
  return self:signature_args(args, "\\" .. cs)
end

-- This is for plain TeX.  Other formats should override this
-- definition.
Manuscript.signature_env = Manuscript.signature_cmd

-- Make a snippet fragment from an argument list.
--
-- Arguments:
--   args: An argument list
--   i (optional, default 1): The number of the first placeholder in
--     the snippet.
--
-- Returns:
--   The formatted snippet, as a string, without the $0 placeholder.
--
function Manuscript:snippet_args(args, i)
  if not args then return "" end
  i = i or 1
  local t = {}
  for _, arg in ipairs(args) do
    if arg.optional then
      t[#t+1] = "${" .. i .. ":"
      i = i + 1
    end
    if arg.literal then
      t[#t+1] = arg.literal
    else
      local delims, l, r = arg.delimiters
      local meta = arg.meta
      if delims then
        l, r = delims[1], delims[2]
        if l == "" then meta = "‹" .. meta .. "›" end
      elseif delims == false then
        l, r = "", ""
        meta = "‹" .. meta .. "›"
      else -- delims == nil
        l, r = "{", "}"
      end
      t[#t+1] = l .. "${" .. i .. (meta and ":" .. meta or "") .. "}" .. r
      i = i + 1
    end
    if arg.optional then t[#t+1] = "}" end
  end
  return concat(t)
end

-- Make a snippet for a command.
function Manuscript:snippet_cmd(cs, args)
  local argsnippet = args and self:snippet_args(args) or ""
  return cs .. argsnippet .. "$0"
end

-- Make a snippet for an environment.
--
-- This is the plain TeX version.  It's intended to be overwritten by
-- other classes.
--
function Manuscript:snippet_env(cs, args)
  local argsnippet = args and self:snippet_args(args) or ""
  return cs .. argsnippet .. "\n\t$0\n\\end" .. cs
end


--* Completion

-- Calculate completions for the manuscript at the given position.
-- Returns a a table containing a list of completion items (at
-- numerical indices) and some addition information in the following
-- fields.
--
-- pos: position where the matched text starts
-- prefix: the matched text
-- kind: whether the completions are for a command, a key, etc.
--
function Manuscript:complete(pos)
  local ctx = self:get_context(pos - 1)
  if ctx == nil then
    return
  elseif ctx.cs and pos == ctx.cont then
    return self.completion_handlers.cs(self, ctx)
  elseif ctx.arg then
    local action = nested_get(ctx, "parent", "data", "action")
    local handler = self.completion_handlers[action]
    return handler and handler(self, ctx, pos)
  elseif ctx.item then
    local action = nested_get(ctx, "parent", "parent", "data", "action")
    local handler = self.completion_handlers[action]
    return handler and handler(self, ctx, pos)
  elseif ctx.key then --and pos == ctx.pos + #ctx.key then
    return self.completion_handlers.key(self, ctx, pos)
  elseif ctx.value and pos == ctx.pos + #ctx.value then
    return self.completion_handlers.value(self, ctx, pos)
  end
end

Manuscript.completion_handlers = {}

--** Command and environment name completion
function Manuscript.completion_handlers.cs(self, ctx)
  local commands, environments = self.commands, self.environments
  local extra_snippets = config.extra_snippets
  local prefix = ctx.cs
  local ret = {
    pos = ctx.pos + 1,
    prefix = prefix,
    kind = "command"
  }
  for cs in pairs(map_keys(self.parser.cs_matcher(prefix), commands)) do
    local cmd = commands[cs]
    local args = cmd.arguments
    local snippet = extra_snippets[cs] or cmd.snippet
    ret[#ret+1] = {
      text = cs,
      summary = cmd.summary,
      annotation = args and self:signature_args(args) or cmd.symbol,
      snippet = snippet or args and self:snippet_cmd(cs, args)
    }
  end
  for env in pairs(map_keys(matcher(prefix), environments)) do
    local cmd = environments[env]
    local args = cmd.arguments
    local snippet = extra_snippets[env] or cmd.snippet
    local annotation = args and self:signature_args(args)
    ret[#ret+1] = {
      text = env,
      summary = cmd.summary,
      annotation = (annotation and annotation .. " " or "") .. "(environment)",
      snippet = snippet or self:snippet_env(env, args)
    }
  end
  table.sort(ret, function(x,y) return x.text < y.text end)
  return ret
end

function Manuscript.completion_handlers.begin(self, ctx, pos)
  local environments = self.environments
  local prefix = self:substring(ctx.pos, pos - 1)
  local has_prefix = matcher(prefix)
  local r = {
    pos = ctx.pos,
    prefix = prefix,
    kind = "environment"
  }
  for env in pairs(map_keys(has_prefix, environments)) do
    local cmd = environments[env]
    r[#r+1] = {
      text = env,
      summary = cmd.summary,
    }
  end
  return r
end

Manuscript.completion_handlers["end"] = Manuscript.completion_handlers.begin

--** Key/value completion
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
            summary = key.summary,
            annotation = key.meta and ("=" .. key.meta)
         }
      end
   end
   table.sort(r, function(x,y) return x.text < y.text end)
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

--** Cross-reference and citation completion

-- Get a short piece of text around a label.  If there is a recognized
-- command ending right before the label, the context starts there.
--
-- TODO: For now, the context is 60 bytes, but it should be smart and
-- choose a lenght close to 100 characters but ending at a line end.
-- It should also be Unicode-safe.
--
function Manuscript:label_context_short(item)
  local pos, cs, _ = self:find_preceding_command(item.outer_pos)
  local cmd = self.commands[cs]
  if not cmd then
    pos = self.parser.next_nonblank(self.src, item.outer_pos)
  end
  return self:substring_clean(pos, pos + 60)
end

function Manuscript.completion_handlers.ref(self, ctx, pos)
  local prefix = self:substring(ctx.pos, pos - 1)
  local has_prefix = matcher(prefix)
  local fuzzy_match = config.fuzzy_ref and fuzzy_matcher(prefix)
  local scores = {}
  local r = {
    pos = ctx.pos,
    prefix = prefix,
    kind = "label"
  }
  for label in self.root:traverse "label_index" do
    local short_ctx = label.manuscript:label_context_short(label)
    local score = has_prefix(label.name) and infty
      or fuzzy_match and fuzzy_match(short_ctx)
    if score then
      r[#r+1] = {
        text = label.name,
        annotation = short_ctx,
        summary = label.manuscript:label_context_long(label),
        fuzzy_score = score < infty and score or nil
      }
      scores[r[#r]] = score
    end
  end
  -- sort exact matches by order in the document, fuzzy ones by score
  sort(r, function(a, b) return scores[a] > scores[b] end)
  return r
end

function Manuscript.completion_handlers.cite(self, ctx, pos)
  if nested_get(ctx, "data", "optional") then return end
  local prefix = self:substring(ctx.pos, pos - 1)
  local r = {
    pos = ctx.pos,
    prefix = prefix,
    kind = "bibitem"
  }
  local scores = {}
  local has_prefix = matcher(prefix)
  local fuzzy_match = config.fuzzy_cite and fuzzy_matcher(prefix)
  for item in self.root:traverse "bib_index" do
    local score = has_prefix(item.name) and infty
      or fuzzy_match and item.text and fuzzy_match(item.text)
    if score then
      scores[item.name] = score
      r[#r+1] = {
        text = item.name,
        annotation = item.text,
        fuzzy_score = score < infty and score or nil
      }
    end
  end
  -- sort exact matches by label, fuzzy matches by score
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

--* Context help

-- Get information about the thing at the given position.
function Manuscript:describe(pos)
  local ctx = self:get_context(pos)
  if not ctx then return nil end
  local action = ctx.arg and nested_get(ctx, "parent", "data", "action")
    or ctx.item and nested_get(ctx, "parent", "parent", "data", "action")
  local handlers = self.help_handlers
  if handlers[action] then
    return handlers[action](self, ctx)
  elseif ctx.cs then
    return handlers.cs(self, ctx)
  elseif ctx.arg then
    return handlers.arg(self, ctx)
  -- elseif ctx.list then
  elseif ctx.key then
    return handlers.key(self, ctx)
  else
    return nil
  end
end

Manuscript.help_handlers = {}

function Manuscript.help_handlers.cite(self, ctx)
  local name = self:substring(ctx)
  for item in self.root:traverse "bib_index" do
    if name == item.name then
      local script, details = item.manuscript
      if script.format == "bibtex" then
        details = format(
          [[
`%s`: %s

# Bibtex definition

```bibtex
%s
```
]],
          item.name,
          item.text,
          script:substring(item)
        )
      end
      return {
        pos = ctx.pos,
        cont = ctx.cont,
        kind = "bibitem",
        summary = item.name .. " " .. item.text,
        details = details
      }
    end
  end
end

function Manuscript:label_context_long(item)
  local pos = self:find_preceding_command(item.outer_pos)
  if not pos then pos = item.outer_pos end
  local l = self:line_number_at(pos)
  local lines = self.lines
  local end_pos = lines[l + 10]
  if end_pos then
    return self:substring_trimmed(pos, end_pos - 1)
  else
    return self:substring_trimmed(pos, -1)
  end
end

function Manuscript.help_handlers.ref(self, ctx)
  local name = self:substring(ctx)
  for item in self.root:traverse "label_index" do
    if name == item.name then
      local script = item.manuscript
      local short_context = script:label_context_short(item)
      local long_context = script:label_context_long(item)
      local details = format(
        [[
`%s`: Refers to “%s...”

# Label context

```%s
%s
[...]
```
]],
        item.name,
        short_context,
        script.format,
        long_context
      )
      return {
        pos = ctx.pos,
        cont = ctx.cont,
        kind = "label",
        label = name,
        summary = short_context,
        details = details
      }
    end
  end
  return {
    pos = ctx.pos,
    cont = ctx.cont,
    kind = "label",
    label = name,
    summary = "Unknown label"
  }
end

function Manuscript.help_handlers.begin(self, ctx)
  local env_name = self:substring(ctx)
  local data = self.environments[env_name]
  if not data then return nil end
  local args = data.arguments
  local sig_text, sig_pos = self:signature_env(env_name, args)
  return {
    pos = ctx.pos,
    cont = ctx.cont,
    kind = "environment",
    label = sig_text,
    label_positions = sig_pos,
    summary = data.summary,
    details = self:make_docstring("env", env_name, data),
    data = data
  }
end

Manuscript.help_handlers['end'] = function(self, ctx)
  local env_name = self:substring(ctx)
  local data = self.environments[env_name]
  if not data then return nil end
  local args = data.arguments
  local sig_text, sig_pos = self:signature_env(env_name, args)
  return {
    pos = ctx.pos,
    cont = ctx.cont,
    kind = "environment",
    label = sig_text,
    label_positions = sig_pos,
    summary = data.summary,
    details = self:make_docstring("env", env_name, data),
    data = data
  }
end

function Manuscript.help_handlers.cs(self, ctx)
  local data = ctx.data
  if not data then return nil end
  local args = data.arguments
  local sig_text, sig_pos = self:signature_cmd(ctx.cs, args)
  return {
    pos = ctx.pos,
    cont = ctx.cont,
    kind = "command",
    label = sig_text,
    label_positions = sig_pos,
    summary = data.summary,
    details = self:make_docstring("cs", ctx.cs, data),
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
    label = key,
    summary = data.summary,
    details = self:make_docstring("key", key, data),
    data = data
  }
end

function Manuscript:make_docstring_header(kind, name, data)
  local ret = name
  if kind == "cs" then
    ret = self:signature_cmd(name, data.arguments)
  elseif kind == "env" then
    ret = self:signature_env(name, data.arguments)
  elseif kind == "key" and data.meta then
    ret = ret .. " = " .. data.meta
  end
  if data.summary then
    ret = "`" .. ret .. "`: " .. data.summary
  else
    ret = "`" .. ret .. "`"
  end
  if data.symbol then
    ret = ret .. " (" .. data.symbol .. ")"
  end
  return ret
end

local function make_docstring_args(data)
  local t = {"# Arguments\n"}
  local args = data.arguments
  if args then
    for i = 1, #args do
      local arg = args[i]
      if arg.summary then
        t[#t+1] = "- " .. (arg.meta or "#" .. i)
          .. (arg.optional and " (optional): " or ": ")
          .. arg.summary
      end
    end
    t[#t+1] = ""
  end
  if #t > 2 then return concat(t, "\n") end
end

function Manuscript:make_docstring_variants(kind, name, data)
  local variants = data.variants
  if not variants then return end
  local t = {"# Alternative forms\n"}
  local fun = (kind == "env") and self.signature_env or self.signature_cmd
  for i = 1, #variants do
    t[#t+1] = "- `" .. fun(self, name, variants[i].arguments) .. "`"
  end
  t[#t+1] = ""
  return concat(t, "\n")
end

local function make_docstring_details(data)
  local details = data.details
  local doc_field = data.documentation
  if details then
    return "# Details\n\n" .. details
  elseif type(doc_field) == "string" and doc_field:match"^info:" then
    local str, node, subnode = get_info(doc_field)
    if str then
      return format("# Info: (%s)%s\n\n```Info\n%s```", node, subnode, str)
    end
  else
    return
  end
end

function Manuscript:make_docstring_docs(kind, name, data)
  local item_doc = data.documentation
  local pkg = data.package
  local pkg_doc = pkg and pkg.documentation
  local t = {"# Documentation\n"}
  if pkg and pkg.ctan_package then
    if kind == "env" then
      name = "{" .. name .. "}"
    elseif kind == "cs" then
      name = self:signature_cmd(name)
    end
    t[#t+1] = format(
      "`%s` is defined in the [%s](https://www.ctan.org/pkg/%s) package.\n",
      name, pkg.ctan_package, pkg.ctan_package
    )
  end
  if item_doc then
    extend(t, resolve_doc_items(item_doc))
  end
  if pkg_doc then
    extend(t, resolve_doc_items(pkg_doc))
  end
  if #t > 1 then return concat(t, "\n") else return end
end

function Manuscript:make_docstring(kind, name, data)
  local t = {self:make_docstring_header(kind, name, data), ""}
  t[#t+1] = make_docstring_args(data)
  t[#t+1] = self:make_docstring_variants(kind, name, data)
  t[#t+1] = make_docstring_details(data)
  t[#t+1] = self:make_docstring_docs(kind, name, data)
  return concat(t, "\n")
end

--* Find definition

-- Find the location where the thing at the given position is defined.
function Manuscript:find_definition(pos)
  local ctx = self:get_context(pos)
  if not ctx then return nil end
  local action = ctx.arg and nested_get(ctx, "parent", "data", "action")
    or ctx.item and nested_get(ctx, "parent", "parent", "data", "action")
  local handlers = self.find_definition_handlers
  if handlers[action] then
    return handlers[action](self, ctx)
  elseif ctx.cs then
    return handlers.cs(self, ctx)
  else
    return nil
  end
end

Manuscript.find_definition_handlers = {}

function Manuscript.find_definition_handlers.ref(self, ctx)
  local name = self:substring(ctx)
  for item in self.root:traverse "label_index" do
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
  for item in self.root:traverse "bib_index" do
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

function Manuscript.find_definition_handlers.cs(self, ctx)
  local name = ctx.cs
  for item in self.root:traverse "newcommand_index" do
    if name == item.name then
      return {
        pos = item.pos,
        cont = item.cont,
        manuscript = item.manuscript,
        kind = "cs"
      }
    end
  end
end

function Manuscript.find_definition_handlers.begin(self, ctx)
  local name = self:substring(ctx)
  for item in self.root:traverse "newenvironment_index" do
    if name == item.name then
      return {
        pos = item.pos,
        cont = item.cont,
        manuscript = item.manuscript,
        kind = "env"
      }
    end
  end
end

Manuscript.find_definition_handlers["end"]
  = Manuscript.find_definition_handlers.begin

function Manuscript.find_definition_handlers.input(self, ctx)
  local template
  if ctx.arg then
    template = nested_get(ctx, "parent", "data", "filename") or "?"
  elseif ctx.item then
    template = nested_get(ctx, "parent", "parent", "data", "filename") or "?"
  else
    return
  end
  local basename = format_filename_template(template, self:substring(ctx))
  local filename = find_file(path_split(self.filename), basename)
  if not filename then return end
  local child = self:find_manuscript(path_normalize(filename))
  if child then
    return {
      pos = 1,
      cont = 1,
      manuscript = child,
      kind = "manuscript"
    }
  end
end

--* Find references

function Manuscript:scan_references()
  if not self.ref_index then
    self.ref_index = {}
    self.cite_index = {}
    self:scan(self.scan_references_callbacks)
  end
  local idx = self.child_index
  for i = 1, #idx do
    local script = self:child(idx[i].name)
    if script then script:scan_references() end
  end
end

Manuscript.scan_references_callbacks = {}

function Manuscript:scan_control_sequences()
  if not self.cs_index then
    self.cs_index = {}
    self:scan(self.scan_cs_callbacks)
  end
  local idx = self.child_index
  for i = 1, #idx do
    local script = self:child(idx[i].name)
    if script then script:scan_control_sequences() end
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

-- List all references to the thing at the given position.
--
-- Returns:
--   A list of annotated ranges.
--
function Manuscript:find_references(pos)
  local ctx = self:get_context(pos)
  if not ctx then return nil end
  local action = ctx.arg and nested_get(ctx, "parent", "data", "action")
    or ctx.item and nested_get(ctx, "parent", "parent", "data", "action")
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
  for item in self.root:traverse "cs_index" do
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
  for item in self.root:traverse "ref_index" do
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
  for item in self.root:traverse "cite_index" do
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

--* Outline

-- Compute a table of contents for the document.  If loc is false or
-- omitted, include children of the manuscript; otherwise, restrict to
-- the current manuscript.
--
function Manuscript:outline(loc)
  local val = {}
  for it in self:traverse("section_index", loc and 0) do
    local lv = it.level or infty
    local t = val
    while t[#t] and (t[#t].level or -infty) < lv do t = t[#t] end
    t[#t + 1] = {
      name = it.name,
      pos = it.pos,
      cont = it.cont,
      level = lv,
      manuscript = it.manuscript,
      kind = "section"
    }
  end
  return val
end

return Manuscript
