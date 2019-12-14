--- Assorted useful functions
-- @module digestif.util
local lpeg = require "lpeg"

local co_yield, co_wrap = coroutine.yield, coroutine.wrap
local to_upper, gsub, substring = string.upper, string.gsub, string.sub
local P, V, R = lpeg.P, lpeg.V, lpeg.R
local C, Cp, Cs, Cmt, Cf, Ct = lpeg.C, lpeg.Cp, lpeg.Cs, lpeg.Cmt, lpeg.Cf, lpeg.Ct
local match, locale_table = lpeg.match, lpeg.locale()
local lpeg_add = getmetatable(P(true)).__add
local lpeg_mul = getmetatable(P(true)).__mul
local lpeg_pow = getmetatable(P(true)).__pow

local util = {}

-- ¶ Cool combinators and friendly functions for LPeg

-- simple things for better legibility of complicated constructions

local function choice(p, q, ...)
  if q == nil then
    return P(p)
  else
    return choice(lpeg_add(p, q), ...)
  end
end
util.choice = choice

local function sequence(p, q, ...)
  if q == nil then
    return P(p)
  else
    return sequence(lpeg_mul(p, q), ...)
  end
end
util.sequence = sequence

function util.many(p)
  return lpeg_pow(p,0)
end

-- general purpose

local char = P(1) -- in most cases, this works with utf8 too
local uchar = R("\0\127") + R("\194\244") * R("\128\191")^-3
local eol = P("\n")

local function search(patt, token)
  token = token and P(token) or char
  return P{P(patt) + token * V(1)}
end
util.search = search

local function gobble_until(patt, token)
  token = token and P(token) or char
  return (token - P(patt))^0
end
util.gobble_until = gobble_until

function util.between_balanced(l, r, token) --nicer name?
  l, r = P(l), P(r)
  token = token and P(token) or char
  return P{l * C(((token - l - r) + V(1)/0)^0) * r}
end

-- string.upper doesn't handle well non-ASCII characters...
local function case_fold_char(c)
  local u = to_upper(c)
  if c == u then
    return P(c)
  else
    return P(c) + P(u)
  end
end

local case_fold_patt = Cf((C(char) / case_fold_char)^1, lpeg_mul)
function util.case_fold(str)
  return match(case_fold_patt, str)
end

-- make a function from a pattern

function util.matcher(patt)
  patt = P(patt)
  return function(s, i) return match(patt, s, i) end
end

-- like string.gsub, but partially evaluated
function util.replace(patt, repl, token)
  token = token and P(token) or char
  patt = Cs((P(patt) / repl + token)^0)
  return function(s, i) return match(patt, s, i) end
end

util.lpeg_escape = util.replace("%", "%%%%")

--- Returns a function that fuzzy-matches against a string.
-- Higher values of the "penalty parameter" p0 reduce the relative
-- penalty for long gaps.  This is a made-up scoring algorithm, there
-- must be better ones.
-- @param str the string to match against
-- @param token a basic unit of text, by default an UTF-8 codepoint
-- @param p0 penalty parameter, default is 2
function util.fuzzy_matcher(str, token, p0)
  token = token and P(token) or uchar
  p0 = p0 or 2
  local aux_patt = C(token) / function(c) return search(Cp() * case_fold_char(c)) end
  local build_patt = Cf(aux_patt^1, lpeg_mul)
  local search_patt = match(build_patt, str)
  return function(s, i)
    local score, old_pos = 0, 0
    for _, pos in ipairs{match(search_patt, s, i)} do
      score = score + 1 / (p0 + pos - old_pos)
      old_pos = pos
    end
    return score ~= 0 and score
  end
end

function util.split(sep, token, nulls)
  sep = sep and P(sep) or locale_table.space
  token = token and P(token) or char
  local patt
  if nulls then
    local item = C((token - sep)^0)
    patt = Ct(item * (sep * item)^0)
  else
    patt = Ct((sep^0 * C((token - sep)^1))^0)
  end
  return function (s, i) return match(patt, s, i) end
end

function util.trim(space, token)
  space = space and P(space) or locale_table.space
  token = token and P(token) or char
  local patt = space^0 * C((space^0 * (token - space)^1)^0)
  return function(s, i) return match(patt, s, i) end
end

function util.clean(space, token)
  space = space and P(space) or locale_table.space
  token = token and P(token) or char
  local patt = space^0 * Cs(((space^1 / " " + true) * (token - space)^1)^0)
  return function(s, i) return match(patt, s, i) end
end

util.line_indices = util.matcher(Ct(Cp() * search(eol * Cp())^0))

local utf8_sync_patt = R("\128\191")^-3 * Cp() + Cp()

-- Like string.gsub, but don't break up UTF-8 codepoints
function util.substring8(s, i, j)
  i = match(utf8_sync_patt, s, i)
  j = j and match(utf8_sync_patt, s, j + 1) - 1
  return substring(s, i, j)
end

-- iterators

local line_patt = Cp() * (search(Cp() * eol) * Cp() + P(true))
function util.lines(s, i, n)
  return co_wrap(function()
    local n, i, j, k =  n or 1, match(line_patt, s, i)
    while k do
      co_yield(n, i, j - 1)
      n, i, j, k = n + 1, match(line_patt, s, k)
    end
    co_yield(n, i or 1, #s)
  end)
end

-- ¶ Classes

local function create_object (c, ...)
   local obj = setmetatable({}, c)
   c.__init(obj, ...)
   return obj
end

function util.class(parent)
   local c = {}
   local mt = {
      __call = create_object,
      __index = parent
   }
   c.__index = c
   return setmetatable(c, mt)
end

-- ¶ Table manipulation

function util.map(f, t)
   local r = {}
   for i, v in pairs(t) do
      r[i] = f(v)
   end
   return r
end

local function update(t, u, ...)
  if u then
    for i, v in pairs(u) do
      t[i] = v
    end
    return update(t, ...)
  else
    return t
  end
end
util.update = update

function util.merge(...)
   return update({}, ...)
end

local nil_marker = {}

local function nested_get(t, k, ...)
  if t then
    if k == nil then k = nil_marker end
    if select('#', ...) == 0 then
      return t[k]
    else
      return nested_get(t[k], ...)
    end
  end
end
util.nested_get = nested_get

local function nested_put(val, t, k, ...)
  if k == nil then k = nil_marker end
  if select('#', ...) == 0 then
    t[k] = val
    return val
  else
    local q = t[k]
    if not q then
      q = {}
      t[k] = q
    end
    return nested_put(val, q, ...)
  end
end
util.nested_put = nested_put

-- ¶ Memoization

local memoize = util.class()
util.memoize = memoize

local weak_keys = {__mode = "k"}

function memoize:__init(f)
   self.fun = f
   self.values = setmetatable({}, weak_keys)
end

function memoize:__call(...)
   local values = self.values
   local val = nested_get(values, ...)
   if not val then
      val = self.fun(...)
      nested_put(val, values, ...)
   end
   return val
end

function memoize:forget(...)
   nested_put(nil, self.values, ...)
end

-- ¶ Reading data and config files

--- Evaluate string in a restricted environment.
-- @tparam string str code to evaluate
-- @tparam table mt a metatable for the restricted environment
-- @return the return value of the chunk, if truthy; otherwise a table
-- with all global assignments
function util.eval_with_env(str, mt)
   local globals, ok = {}, nil
   setmetatable(globals, mt)
   local chunk, result = load(str, nil, "t", globals)
   if chunk then
      ok, result = pcall(chunk)
   end
   if not ok then return nil, result end
   return result or setmetatable(globals, nil)
end

function util.update_config(str)
   local config = require"digestif.config"
   local mt = {
      __index = config,
      __newindex = function (_, k)
         error("Invalid option '" .. k .. "' in config file.")
      end
   }
   local new_config = util.eval_with_env(str, mt)
   update(config, new_config)
end

-- ¶ Path and file manipulation

local path_sep = "/"
local path_sep_patt = P(path_sep)
local path_is_abs_patt = path_sep_patt + P"~/"
local path_trim_patt = C((path_sep_patt^0 * (1 - path_sep_patt)^1)^0)
local path_last_sep_patt = P{Cp() * (1 - path_sep_patt)^0 * -1 + (1 * V(1))}

--- Concatenate any number of path names.
-- If one of the paths is absolute, all the previous ones are ignored.
-- @function path_join
-- @tparam string ... path names
-- @treturn string a path name
local function path_join(p, q, ...)
   if not q then return p end
   if path_is_abs_patt:match(q) or p == "" then
      return path_join(q, ...)
   end
   p = path_trim_patt:match(p) .. path_sep
   return path_join(p .. q, ...)
end
util.path_join = path_join

--- Split a path into directory and file parts.
-- @tparam string p a path name
-- @treturn string the directory
-- @treturn string the file name
function util.path_split(p)
  p = path_trim_patt:match(p)
  local i = path_last_sep_patt:match(p) or 1
  return p:sub(1, i-1), p:sub(i)
end

function util.format_filename_template(template, name)
  name = gsub(name, "%%", "%%%%")
  return gsub(template, "?", name)
end

--- Try to read a file in several locations.
-- @function try_read_file
-- @tparam[opt] string|{string,...} path base path or list of paths
-- @tparam string name the file name
-- @treturn ?string contents of the file, if found
local function try_read_file(path, name)
   if type(path) == "table" then
      for i = 1, #path do
         local s = try_read_file(path[i], name)
         if s then return s end
      end
   else
      local f = io.open(path_join(path, name))
      if f then
         local s = f:read("*all")
         f:close()
         return s
      end
   end
end
util.try_read_file = try_read_file

-- ¶ &c.

function util.log(msg, ...)
  if select("#", ...) > 0 then msg = msg:format(...) end
  io.stderr:write(msg, "\n")
  io.stderr:flush()
end

function util.log_objects(msg, ...)
  return util.log(msg, unpack(util.map(require "serpent".block, {...})))
end

return util
