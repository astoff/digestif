-- Assorted utility functions

local lpeg = require "lpeg"

local co_yield, co_wrap = coroutine.yield, coroutine.wrap
local to_upper, gsub, substring = string.upper, string.gsub, string.sub
local to_char, to_byte = string.char, string.byte
local format = string.format
local pack, unpack, move = table.pack, table.unpack, table.move
local pairs, getmetatable, setmetatable = pairs, getmetatable, setmetatable
local P, V, R, S = lpeg.P, lpeg.V, lpeg.R, lpeg.S
local C, Cp, Cs, Cf, Ct = lpeg.C, lpeg.Cp, lpeg.Cs, lpeg.Cf, lpeg.Ct
local match, locale_table = lpeg.match, lpeg.locale()

local util = {}

--* Table manipulation

local function map(f, t)
  local r = {}
  for k, v in pairs(t) do
    r[k] = f(v)
  end
  return r
end
util.map = map

local function imap(f, t)
  local r = {}
  for i = 1, #t do
    r[i] = f(t[i])
  end
  return r
end
util.imap = imap

-- Return a table with entries (k, f(k)), where v ranges over the keys
-- of t and all its __index parents.
local function map_keys(f, t)
  local mt = getmetatable(t)
  local p = mt and mt.__index
  local r = p and map_keys(f, p) or {}
  for k in pairs(t) do
    r[k] = f(k)
  end
  return r
end
util.map_keys = map_keys

local function foldl1(f, t)
  local v = t[1]
  for i = 2, t.n or #t do
    v = f(v, t[i])
  end
  return v
end
util.foldl1 = foldl1

local function nested_get(t, ...)
  local arg = pack(...)
  for i = 1, #arg do
    if t then t = t[arg[i]] else return nil end
  end
  return t
end
util.nested_get = nested_get

local function nested_put(v, t, ...)
  local arg = pack(...)
  local k = arg[1]
  for i = 2, arg.n do
    local u = t[k]
    if u == nil then u = {}; t[k] = u end
    t, k = u, arg[i]
  end
  t[k] = v
  return v
end
util.nested_put = nested_put

-- Copy all entries of s onto t
local function update(t, s)
  if s then
    for k, v in pairs(s) do
      t[k] = v
    end
  end
  return t
end
util.update = update

-- Return a new table containing all entries of the given tables,
-- priority given to the latter ones.
local function merge(...)
  return foldl1(update, pack({}, ...))
end
util.merge = merge

-- Copy entries of the second list to the end of the first.
local function extend(s, t)
  return move(t, 1, #t, #s+1, s)
end
util.extend = extend

-- Iterate over a table of tables.
local function triples(t)
  return co_wrap(
    function()
      for i, u in pairs(t) do
        for j, v in pairs(u) do
          co_yield(i, j, v)
        end
      end
    end
  )
end
util.triples = triples

--* Cool combinators and friendly functions for LPeg

--** Simple things for better legibility of complicated constructions

local lpeg_add = getmetatable(P(true)).__add
local lpeg_mul = getmetatable(P(true)).__mul
local lpeg_pow = getmetatable(P(true)).__pow

local char = P(1) -- in most cases, this works with utf8 too
local uchar = R("\0\127") + R("\194\244") * R("\128\191")^-3
local eol = P("\n")

local function choice(...)
  return foldl1(lpeg_add, pack(...))
end
util.choice = choice

local function sequence(...)
  return foldl1(lpeg_mul, pack(...))
end
util.sequence = sequence

local function many(times, patt)
  if patt then
    return lpeg_pow(patt, times)
  else
    return lpeg_pow(times, 0)
  end
end
util.many = many

-- Return a function to match against a pattern
local function matcher(patt)
  patt = P(patt)
  return function(s, i) return match(patt, s, i) end
end
util.matcher = matcher

-- Return a function to perfom replacement.  Like string.gsub, but
-- partially evaluated
local function replace(patt, repl, token)
  token = token and P(token) or char
  patt = Cs((P(patt) / repl + token)^0)
  return function(s, i) return match(patt, s, i) end
end
util.replace = replace

util.lpeg_escape = replace("%", "%%%%")

--** General purpose combinators

local function search(patt, token)
  token = token and P(token) or char
  return P{P(patt) + token * V(1)}
end
util.search = search

local function gobble(patt, token)
  token = token and P(token) or char
  return (token - P(patt))^0
end
util.gobble = gobble
util.gobble_until = gobble

local function between_balanced(l, r, token) --nicer name?
  l, r = P(l), P(r)
  token = token and P(token) or char
  return P{l * C(((token - l - r) + V(1)/0)^0) * r}
end
util.between_balanced = between_balanced

local function case_fold_char(c)
  local u = to_upper(c) -- FIX: doesn't handle well non-ASCII characters
  if c == u then
    return P(c)
  else
    return P(c) + P(u)
  end
end

-- Return a pattern that matches the given string, ignoring case.
-- Uppercase characters in the input still match only uppercase.
local case_fold = matcher(Cf((C(char) / case_fold_char)^1, lpeg_mul))
util.case_fold = case_fold

--** String functions, with a tendency towards currying

-- Split a string at the given separators.  `nulls` determines wheter
-- empty sequences are returned.
local function split(sep, token, nulls)
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
util.split = split

-- Remove spaces from the ends of subject.
local function trim(space, token)
  space = space and P(space) or locale_table.space
  token = token and P(token) or char
  local patt = space^0 * C((space^0 * (token - space)^1)^0)
  return function(s, i) return match(patt, s, i) end
end
util.trim = trim

-- Trim and remove repeated spaces inside subject.
local function clean(space, token)
  space = space and P(space) or locale_table.space
  token = token and P(token) or char
  local patt = space^0 * Cs(((space^1 / " " + true) * (token - space)^1)^0)
  return function(s, i) return match(patt, s, i) end
end
util.clean = clean

-- Return a list of new lines in the subject string.
util.line_indices = matcher(Ct(Cp() * search(eol * Cp())^0))

local utf8_sync_patt = R("\128\191")^-3 * Cp() + Cp()

-- Like string.sub, but don't break up UTF-8 codepoints.  May return
-- a string slightly longer or shorter than j - i + 1 bytes.
local function substring8(s, i, j)
  i = match(utf8_sync_patt, s, i)
  j = j and match(utf8_sync_patt, s, j + 1) - 1
  return substring(s, i, j)
end
util.substring8 = substring8

--** Fuzzy matching

local fuzzy_aux_patt
  = C(uchar) / function(c) return search(Cp() * case_fold_char(c)) end

local fuzzy_build_patt = Cf(fuzzy_aux_patt^1, lpeg_mul)

-- Return a function that fuzzy-matches against a string.
-- Higher values of the "penalty parameter" p0 reduce the relative
-- penalty for long gaps.  This is a made-up scoring algorithm, there
-- must be better ones.
--
-- Arguments:
--
-- - str: the string to match against
-- - p0: penalty parameter for computing scores, default is 2
--
local function fuzzy_matcher(str, p0)
  p0 = p0 or 2
  local search_patt = Ct(match(fuzzy_build_patt, str))
  return function(s, i)
    local score, old_pos, matches = 0, 0, match(search_patt, s, i)
    if not matches then return end
    for j = 1, #matches do
      local pos = matches[j]
      score = score + 1 / (p0 + pos - old_pos)
      old_pos = pos
    end
    return score
  end
end
util.fuzzy_matcher = fuzzy_matcher

--** Iterators

local line_patt = Cp() * (search(Cp() * eol) * Cp() + P(true))

local function lines(s, i, n)
  return co_wrap(function()
    local n, i, j, k = n or 1, match(line_patt, s, i)
    while k do
      co_yield(n, i, j - 1)
      n, i, j, k = n + 1, match(line_patt, s, k)
    end
    co_yield(n, i or 1, #s)
  end)
end
util.lines = lines

--* Classes

local function create_object (c, ...)
   local obj = setmetatable({}, c)
   c.__init(obj, ...)
   return obj
end

local function class(parent)
   local c = {}
   local mt = {
      __call = create_object,
      __index = parent
   }
   c.__index = c
   return setmetatable(c, mt)
end
util.class = class

--* Memoization

local weak_keys, nil_marker, value_marker = {__mode = "k"}, {}, {}

-- Memoize a function of one argument with one return value.  Nil is
-- not allowed as argument or return value.
local function memoize1(fun)
  local values = setmetatable({}, weak_keys)
  return function(arg)
    local val = values[arg]
    if val == nil then
      val = fun(arg)
      values[arg] = val
    end
    return val
  end
end
util.memoize1 = memoize1

-- Return a memoizing version of a function.
local function memoize(fun)
  local values = setmetatable({}, weak_keys)
  return function(...)
    local arg, val = pack(...), values
    for i = 1, arg.n do
      local a = arg[i]
      if a == nil then a = nil_marker end
      local v = val[a]
      if v == nil then
        v = setmetatable({}, weak_keys)
        val[a] = v
      end
      val = v
    end
    local v = val[value_marker]
    if v == nil then
      v = pack(fun(...))
      val[value_marker] = v
    end
    return unpack(v, 1, v.n)
  end
end
util.memoize = memoize

--* Reading data and config files

--- Evaluate string in a restricted environment.
-- @tparam string str code to evaluate
-- @tparam table mt a metatable for the restricted environment
-- @return the return value of the chunk, if truthy; otherwise a table
-- with all global assignments
local function eval_with_env(str, mt)
   local globals, ok = {}, nil
   setmetatable(globals, mt)
   local chunk, result = load(str, nil, "t", globals)
   if chunk then
      ok, result = pcall(chunk)
   end
   if not ok then return nil, result end
   return result or setmetatable(globals, nil)
end
util.eval_with_env = eval_with_env

local function update_config(str)
   local config = require"digestif.config"
   local mt = {
      __index = config,
      __newindex = function (_, k)
         error("Invalid option '" .. k .. "' in config file.")
      end
   }
   local new_config = eval_with_env(str, mt)
   update(config, new_config)
end
util.update_config = update_config

--* Path and file manipulation

local path_sep = package.config:sub(1, 1)
local path_sep_patt, path_is_abs_patt

if path_sep == "/" then
  path_sep_patt = P"/"
  path_is_abs_patt = path_sep_patt
elseif path_sep == "\\" then -- TODO: test this case
  path_sep_patt = S"\\/"
  path_is_abs_patt = (R("AZ", "az") * P":")^-1 * path_sep_patt
else
  error "Invalid path separator found in package.config"
end

local path_trim_patt = C(gobble(path_sep_patt^0 * -1))
local path_split_patt = C(search(path_sep_patt)^0) * C(P(1)^0)

-- Concatenate two paths.  If the second is absolute, the first one is
-- ignored.
local function path_join(p, q)
  if match(path_is_abs_patt, q) or p == "" then
    return q
  else
    return match(path_trim_patt, p) .. path_sep .. q
  end
end
util.path_join = path_join

-- Split a path into directory and file parts.
local function path_split(p)
  return match(path_split_patt, match(path_trim_patt, p))
end
util.path_split = path_split

if path_separator == "\\" then
  util.path_list_split = split";"
else
  util.path_list_split = split":"
end

local function format_filename_template(template, name)
  name = gsub(name, "%%", "%%%%")
  return gsub(template, "?", name)
end
util.format_filename_template = format_filename_template

-- Look for a file in several locations.  `path` is a string or a list
-- of strings.  The optional `name` is joined to each element.
-- Returns the first file name that exists on disk.  If `read` is
-- true, give the file contents as second return value.
local function find_file(path, name, read)
  if type(path) == "table" then
    for i = 1, #path do
      local p, s = find_file(path[i], name, read)
      if p then return p, s end
    end
  else
    if name then path = path_join(path, name) end
    local f = io.open(path)
    if f then
      local str = read and f:read("a")
      f:close()
      return path, str
    end
  end
end
util.find_file = find_file

--* URI manipulation

local Phex = R("09", "AF", "af")

local percent_decode = replace(
  P"%" * C(Phex * Phex),
  function(s) return to_char(tonumber(s, 16)) end
)

local percent_encode = replace(
  char - (R("09", "AZ", "az") + S"-._~/="),
  function(s) return format("%%%X", to_byte(s)) end
)

local uri_patt = sequence(
  C(R("AZ", "az")^1),
  P":",
  C(gobble("#")),
  (P"#" * C(char^0))^-1
)

local function parse_uri(uri)
  local scheme, path, fragment = match(uri_patt, uri)
  path = path and percent_decode(path)
  fragment = fragment and percent_decode(fragment)
  return scheme, path, fragment
end
util.parse_uri = parse_uri

local function make_uri(scheme, path, fragment)
  local uri = scheme .. ":" .. percent_encode(path)
  if fragment then uri = uri .. "#" .. percent_encode(fragment) end
  return uri
end
util.make_uri = make_uri

--* &c.

local function log(msg, ...)
  if select("#", ...) > 0 then msg = format(msg, ...) end
  io.stderr:write(os.date("%H:%M:%S "), msg, "\n")
  io.stderr:flush()
end
util.log = log

local function log_objects(msg, ...)
  return log(msg, unpack(map(require "serpent".block, {...})))
end
util.log_objects = log_objects

return util
