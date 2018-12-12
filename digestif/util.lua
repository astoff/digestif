--- Assorted useful functions
--@module digestif.util
local lpeg = require "lpeg"

local P, V, R = lpeg.P, lpeg.V, lpeg.R
local C, Cp, Cs, Cmt, Cf = lpeg.C, lpeg.Cp, lpeg.Cs, lpeg.Cmt, lpeg.Cf
local match, locale_table = lpeg.match, lpeg.locale()
local lpeg_mul = getmetatable(P(true)).__mul

local to_upper = string.upper

local util = {}

-- Cool combinators and friendly functions for LPeg
-- ================================================

-- general purpose

local default_token = P(1) -- in most cases, this works with utf8 too
local utf8_token = R("\0\127") + R("\194\244") * R("\128\191")^-3

local function search(patt, token)
  token = token and P(token) or default_token
  return P{P(patt) + token * V(1)}
end
util.search = search

local function search_all(patt, token)
  return search(patt, token)^1
end
util.search_all = search_all

-- like search, but captures the preceding text
local function before(patt, token)
  patt = P(patt)
  token = token and P(token) or default_token
  return C((token - patt)^0) * patt
end
util.before = before

local function search_gap(patt, token)
  patt = P(patt)/0
  token = token and P(token) or default_token
  return search(C((token - patt)^1), patt)
end
util.search_gap = search_gap

function util.search_gaps(patt, token)
  return search_gap(patt, token)^0
end

function util.between(l, r, token)
  l, r = P(l), P(r)
  return l * before(r, token) * r
end

function util.between_balanced(l, r, token)
  l, r = P(l), P(r)
  token = token and P(token) or default_token
  return P{l * C(((token - l - r) + V(1)/0)^0) * r}
end

-- depends on string.upper which doesn't work for non-ASCII
-- characters...
local function case_fold(c)
  local u = to_upper(c)
  if c == u then
    return P(c)
  else
    return P(c) + P(u)
  end
end
util.case_fold = case_fold

-- make a function from a pattern

function util.matcher(patt)
  return function(...) return match(patt, ...) end
end

local function replace(patt, repl, token)
  token = token and P(token) or default_token
  patt = Cs((P(patt) / repl + token)^0)
  return function(...) return match(patt, ...) end
end
util.replace = replace

util.lpeg_escape = replace("%", "%%%%")

--- Returns a function that fuzzy-matches against the given string.
-- p0 is an extra penalty parameter.  Higher values reduce the
-- relative penalty for long gaps.  This is a made-up scoring
-- algorith, there might be better ones.
--
-- This function assumes all strings are is UTF-8.
function util.fuzzy_matcher(str, token, p0)
  token = token and P(token) or utf8_token
  p0 = p0 or 2
  local aux_patt = C(token) / function(c) return search(Cp() * case_fold(c)) end
  local build_patt = Cf(search_all(aux_patt, token), lpeg_mul)
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

function util.trim(space, token)
  space = space and P(space) or locale_table.space
  token = token and P(token) or default_token
  local patt = space^0 * C((space^0 * (token - space)^1)^0)
  return function(...) return match(patt, ...) end
end

function util.clean(space, token)
  space = space and P(space) or locale_table.space
  token = token and P(token) or default_token
  local patt = space^0 * Cs(((space^1 / " " + true) * (token - space)^1)^0)
  return function(...) return match(patt, ...) end
end

-- iterators

local function matches_of(patt, token)
  patt = search(patt, token)
  return function(s, i)
    i = i or 1
    local f = function (_, j, ...)
      i = j
      return true, ...
    end
    local p = Cmt(patt, f)
    return function()
      return match(p, s, i)
    end
  end
end
util.matches_of = matches_of

function util.gaps_of(patt, token)
  patt = P(patt)/0
  token = token and P(token) or default_token
  return matches_of(C((token - patt)^1), patt)
end

-- Classes
-- =======

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

-- Table manipulation
-- ==================

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
      if select('#', ...) == 0 then
         return t[k or nil_marker]
      else
         return nested_get(t[k or nil_marker], ...)
      end
   end
end
util.nested_get = nested_get

local function nested_put(val, t, k, ...)
   k = k or nil_marker
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

-- Memoization
-- ===========

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

-- Reading data and config files
-- =============================

--- Evaluate string in a restricted environment.
--@tparam string str code to evaluate
--@tparam table mt a metatable for the restricted environment
--@return the return value of the chunk, if truthy; otherwise a table
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

-- Path and file manipulation
-- ==========================

local path_sep = "/"
local path_sep_patt = P(path_sep)
local path_is_abs_patt = path_sep_patt + P"~/"
local path_trim_patt = C((path_sep_patt^0 * (1 - path_sep_patt)^1)^0)
local path_last_sep_patt = P{Cp() * (1 - path_sep_patt)^0 * -1 + (1 * V(1))}

--- Concatenate any number of path names.
-- If one of the paths is absolute, all the previous ones are ignored.
--@function path_join
--@tparam string ... path names
--@treturn string a path name
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
--@tparam string p a path name
--@treturn string the directory
--@treturn string the file name
function util.path_split(p)
   p = path_trim_patt:match(p)
   local i = path_last_sep_patt:match(p) or 1
   return p:sub(1, i-1), p:sub(i, -1)
end

--- Try to read a file in several locations.
--@function try_read_file
--@tparam[opt] string|{string,...} path base path or list of paths
--@tparam string name the file name
--@treturn ?string contents of the file, if found
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

-- String manipulation
-- ===================

-- should just use instead: Ct(Cp() * search_all("\n" * Cp()))

function util.lines(str, pos, sep)
   pos = pos or 1
   sep = sep or "\n"
   local l, find = 0, string.find
   return function()
      if not pos then return nil end
      local i = pos
      local j, k = find(str, sep, pos, true)
      pos, l = k and k + 1, l + 1
      return l, i, j and j - 1
   end
end

local ts_magic_comment = "^%s*%%+%s*![Tt][Ee][Xx]%s+(%g+)%s*=%s*(%g*)"

function util.find_root(str)
   for l, i in util.lines(str) do
      if l > 10 then break end
      local k, v = str:match(ts_magic_comment, i)
      if k == "root" then return v end
   end
end

-- &c.
-- ===

function util.log(...)
   local msg = util.map(tostring, {...})
   io.stderr:write(table.concat(msg, " ") .. "\n")
   io.stderr:flush()
end

return util
