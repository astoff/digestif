-- Assorted utility functions

local lpeg = require "lpeg"

local io, os = io, os
local co_yield, co_wrap = coroutine.yield, coroutine.wrap
local strupper, strfind, strsub, strrep = string.upper, string.find, string.sub, string.rep
local strchar, strbyte, utf8_char = string.char, string.byte, utf8.char
local format, gsub = string.format, string.gsub
local pack, unpack, concat = table.pack, table.unpack, table.concat
local move, sort = table.move, table.sort
local pairs, getmetatable, setmetatable = pairs, getmetatable, setmetatable
local P, V, R, S, I, B = lpeg.P, lpeg.V, lpeg.R, lpeg.S, lpeg.Cp(), lpeg.B
local C, Cs, Cf, Ct, Cc, Cg = lpeg.C, lpeg.Cs, lpeg.Cf, lpeg.Ct, lpeg.Cc, lpeg.Cg
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
local hex = R("09", "AF", "af")
local alnum = R("09", "AZ", "az")
local alpha = R("AZ", "az")
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

-- function case_fold(str)
--
-- Return a pattern that matches the given string, ignoring case.
-- Uppercase characters in the input still match only uppercase.
-- Indexing case_fold as a table does the same, but for individual
-- characters only.
local case_fold = {}
for i = strbyte"a", strbyte"z" do
  local c = strchar(i)
  case_fold[c] = S(c .. strupper(c))
end
local cf_patt = Cf((C(char) / case_fold)^1, lpeg_mul)
setmetatable(case_fold, {
  __index = function(_, c) return P(c) end,
  __call = function(_, s) return match(cf_patt, s) end
})
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
util.line_indices = matcher(Ct(I * search(eol * I)^0))

local utf8_sync_patt = R("\128\191")^-3 * I + I

-- Like string.sub, but don't break up UTF-8 codepoints.  May return
-- a string slightly longer or shorter than j - i + 1 bytes.
local function strsub8(s, i, j)
  i = match(utf8_sync_patt, s, i)
  j = j and match(utf8_sync_patt, s, j + 1) - 1
  return strsub(s, i, j)
end
util.strsub8 = strsub8

--** Fuzzy matching

local fuzzy_aux_patt
  = C(uchar) / function(c) return search(I * case_fold[c]) end

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

local line_patt = I * (search(I * eol) * I + P(true))

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

-- Memoize a function of one argument with one return value.  Nil as
-- an argument is equivalent to false, and nil as return value is not
-- memoized.
local function memoize1(fun)
  local values = setmetatable({}, weak_keys)
  return function(arg)
    arg = arg or false
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

--* Path and file manipulation

local dir_sep = package.config:sub(1, 1)
local dir_sep_patt, path_is_abs_patt

if dir_sep == "/" then
  dir_sep_patt = P"/"
  path_is_abs_patt = dir_sep_patt
elseif dir_sep == "\\" then -- TODO: test this case
  dir_sep_patt = S"\\/"
  path_is_abs_patt = (alpha * P":")^-1 * dir_sep_patt
else
  error "Invalid directory separator found in package.config"
end

-- Concatenate two paths.  If the second is absolute, the first one is
-- ignored.
local function path_join(p, q)
  if match(path_is_abs_patt, q) or p == "" then
    return q
  else
    local sep = match(dir_sep_patt, p, #p) and "" or dir_sep
    return p .. sep .. q
  end
end
util.path_join = path_join

-- Split a path into directory and file parts.
local path_split_patt = sequence(
    C(sequence(
        many(dir_sep_patt),
        gobble(
          sequence(
            dir_sep_patt^0,
            many(1 - dir_sep_patt),
            P(-1))))),
    dir_sep_patt^0,
    C(many(char))
)

local function path_split(p)
  return match(path_split_patt, p)
end
util.path_split = path_split

local path_norm_double_sep = Cs(search((dir_sep_patt ^ 2) / dir_sep) * P(1)^0)
local path_norm_dot_patt = Cs(
  search(((B(dir_sep_patt) + B(-1)) * P"." * dir_sep_patt) / "") * P(1)^0)
local path_norm_dotdot_patt = Cs(
  search(((1 - dir_sep_patt)^1 * dir_sep_patt * P".." * dir_sep_patt) / "") * P(1)^0)

-- Normalize a path name, removing repeated separators and "./" and "../"
local function path_normalize(p)
  local q = match(path_norm_double_sep, p)
    or match(path_norm_dot_patt, p)
    or match(path_norm_dotdot_patt, p)
  if q then
    return path_normalize(q)
  else
    return p
  end
end
util.path_normalize = path_normalize

if dir_sep == "\\" then
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

local percent_decode = replace(
  P"%" * C(hex * hex),
  function(s) return strchar(tonumber(s, 16)) end
)

local percent_encode = replace(
  char - (alnum + S"-._~/="),
  function(s) return format("%%%X", strbyte(s)) end
)

local uri_patt = sequence(
    C(alpha^1) * P":",
    (P"//" * C(gobble("/"))) + Cc(nil),
    C(gobble(S"?#")) / percent_decode,
    (P"?" * C(gobble("#")) / percent_decode) + Cc(nil),
    (P"#" * C(char^0) / percent_decode) + Cc(nil)
)
util.parse_uri = matcher(uri_patt)

local function make_uri(scheme, authority, path, query, fragment)
  local uri = scheme .. ":"
  if authority then uri = uri .. "//" .. authority end
  uri = uri .. percent_encode(path)
  if query then uri = uri .. "?" .. percent_encode(query) end
  if fragment then uri = uri .. "#" .. percent_encode(fragment) end
  return uri
end
util.make_uri = make_uri

--* JSON

util.json_null = setmetatable({}, {__json = "null"})

--** Decoding

do
  local ws = S" \n\t\r"^0
  local quote = P"\""

  local function decode_number(s)
    return tonumber(s) or error("Error parsing “" .. s .. "” as a number")
  end

  local char_or_escape = choice(
    P(1) - P"\\",
    P"\\n"  / "\n",
    P"\\\"" / "\"",
    P"\\\\" / "\\",
    P"\\/"  / "/",
    P"\\r" / "\r",
    P"\\t" / "\t",
    P"\\b" / "\b",
    P"\\f" / "\f",
    P"\\u" * C(S"Dd" * S"89ABab" * hex * hex)
      * P"\\u" * C(S"Dd" * R("CF","cf") * hex * hex)
      / function(high, low)
          high = tonumber(high, 16)
          low = tonumber(low, 16)
          return utf8_char(
            (high - 0xD800) * 2^10 + low - 0xDC00 + 0x10000)
        end,
    P"\\u" * C(hex * hex * hex * hex)
      / function(s) return utf8_char(tonumber(s, 16)) end
  )

  local json_patt = P{
    [1]       = ws * V"element" * P(-1),
    ["true"]  = P"true" * Cc(true) * ws,
    ["false"] = P"false" * Cc(false) * ws,
    null      = P"null" * Cc(util.json_null) * ws,
    number    = (R"09" + S"-+.") * (1 - S",]}")^0 / decode_number,
    string    = quote * Cs(gobble(quote, char_or_escape)) * quote * ws,
    element   = V"string" + V"number" + V"true" + V"false" + V"null" + V"array" + V"object",
    elements  = V"element" * (P"," * ws * V"element")^0,
    array     = P"[" * ws * Ct(V"elements"^-1) * P"]" * ws,
    member    = Cg(V"string" * P":" * ws * V"element"),
    members   = V"member" * (P"," * ws * V"member")^0,
    object    = P"{" * ws * Cf(Ct(true) * V"members"^-1, rawset) * P"}" * ws
  }

  function util.json_decode(str)
    return match(json_patt, str) or error "Error decoding json"
  end
end

--** Encoding

do
  local control_chars = {}
  for i = 0, 31 do
    control_chars[strchar(i)] = format("\\u%04x", i)
  end

  local encode_string = matcher(
    Cs(many(choice(
      P(1) - R"\0\31" - S"\"\\",
      P"\n" / "\\n",
      P"\"" / "\\\"",
      P"\\" / "\\\\",
      P"\r" / "\\r",
      P"\t" / "\\t",
      P"\b" / "\\b",
      P"\f" / "\\f",
      R"\0\31" / control_chars
  ))))

  local fix_decimal
  local decimal_sep = tostring(5.5):gsub("5", "")
  if decimal_sep == "." then
    fix_decimal = function(x) return x end
  else
    fix_decimal = replace(decimal_sep, ".")
  end

  local inf = math.huge

  local function encode_number(v)
    if -inf < v and v < inf then
      return fix_decimal(tostring(v))
    else
      return "null"
    end
  end

  local function do_encode(obj, t, n)
    local obj_type = type(obj)
    if obj_type == "string" then
      t[n] = "\""
      t[n + 1] = encode_string(obj)
      t[n + 2] = "\""
      return n + 3
    elseif obj_type == "number" then
      t[n] = encode_number(obj)
      return n + 1
    elseif obj_type == "table" then
      local v = obj[1]
      if v ~= nil then
        t[n] = "["
        n = do_encode(v, t, n + 1)
        for i = 2, #obj do
          t[n] = ","
          n = do_encode(obj[i], t, n + 1)
        end
        t[n] = "]"
        return n + 1
      end
      local k, v = next(obj)
      if k ~= nil then
        t[n] = "{\""
        t[n + 1] = encode_string(k)
        t[n + 2] = "\":"
        n = do_encode(v, t, n + 3)
        for k, v in next, obj, k do
          t[n] = ",\""
          t[n + 1] = encode_string(k)
          t[n + 2] = "\":"
          n = do_encode(v, t, n + 3)
        end
        t[n] = "}"
        return n + 1
      else
        local mt = getmetatable(obj)
        t[n] = mt and mt.__json or "[]"
        return n + 1
      end
    elseif obj_type == "boolean" then
      t[n] = obj and "true" or "false"
      return n + 1
    else
      error("Error encoding json, found object of type " .. type)
    end
  end

  function util.json_encode(obj)
    local t = {}
    do_encode(obj, t, 1)
    return concat(t)
  end
end

--* Inspect and serialize Lua values

-- function inspect(obj, depth)
--
-- Return a string representation of `obj`, with at most `depth`
-- layers of nested tables.  If `obj` consists solely of scalars,
-- strings and tables and does not exceed the maximum nesting, the
-- return value is valid Lua code.
--
local inspect

local is_lua_identifier = util.matcher(
  C(R("AZ", "az", "__") * R("09", "AZ", "az", "__")^0) * P(-1)
  / function(s) return load("local " .. s) and s end
)

local function lua_encode_key(obj)
  if type(obj) == "string" then
    if is_lua_identifier(obj) then
      return obj
    else
      return "[" .. format("%q", obj) .. "]"
    end
  else
    return "[" .. tostring(obj) .. "]"
  end
end

local function lua_encode_string(obj)
  if strfind(obj, "\n", 1, true) then
    local delim = ""
    while strfind(obj, "]" .. delim .. "]", 1, true) do
      delim = delim .. "="
    end
    return "[" .. delim .. "[\n" .. obj .. "]" .. delim .. "]"
  else
    return format("%q", obj)
  end
end

local function lua_encode_table(obj, depth, d)
  local t = {}
  local array_keys, hash_keys = {}, {}
  for i = 1, #obj do
    array_keys[i] = true
    t[#t+1] = inspect(obj[i], depth, d+1)
  end
  for k in pairs(obj) do
    if not array_keys[k] then
      hash_keys[#hash_keys+1] = k
    end
  end
  sort(
    hash_keys,
    function(v, w) return tostring(v) < tostring(w) end
  )
  for i = 1, #hash_keys do
    local k = hash_keys[i]
    local v = obj[k]
    t[#t+1] = lua_encode_key(k) .. " = " .. inspect(v, depth, d+1)
  end
  local short = concat(t, ", ")
  if 2*d + #short > 70 or strfind(short, "\n", 1, true) then
    local sep = strrep("  ", d)
    return "{\n  " .. sep .. concat(t, ",\n  " .. sep) .. "\n" .. sep .. "}"
  else
    return "{" .. short .. "}"
  end
end

inspect = function(obj, depth, d)
  depth, d = depth or 10, d or 0
  if type(obj) == "table" and d < depth then
    return lua_encode_table(obj, depth, d)
  elseif type(obj) == "string" then
    if d < depth or #obj < 20 then
      return lua_encode_string(obj)
    else
      return format("string: \"%s...\"", strsub(obj, 1, 9))
    end
  else
    return tostring(obj)
  end
end
util.inspect = inspect

--* Logging

local function log(msg, ...)
  if select("#", ...) > 0 then msg = format(msg, ...) end
  io.stderr:write(os.date("%H:%M:%S "), msg, "\n")
  io.stderr:flush()
end
util.log = log

local function log_objects(...)
  return log(concat(map(inspect, {...}), "\n"))
end
util.log_objects = log_objects

return util
