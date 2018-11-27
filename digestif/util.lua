local util = {}

function util.class()
   local c, mt = {}, {}
   c.__index = c
   function mt.__call(c, ...)
      local obj = setmetatable({}, c)
      c._init(obj, ...)
      return obj
   end
   return setmetatable(c, mt)
end

local nil_marker = {}

local function safe_get(t, k, ...)
   if t then
      if select('#', ...) == 0 then
         return t[k or nil_marker]
      else
         return safe_get(t[k or nil_marker], ...)
      end
   end
end
util.safe_get = safe_get

local function safe_put(val, t, k, ...)
   local k = k or nil_marker
   if select('#', ...) == 0 then
      t[k] = val
      return val
   else
      local q = t[k]
      if not q then
         q = {}
         t[k] = q
      end
      return safe_put(val, q, ...)
   end
end
util.safe_put = safe_put

local memoize = util.class()
util.memoize = memoize

function memoize:_init(f)
   self.fun = f
   self.values = setmetatable({}, {__mode = "k"})
end

function memoize:__call(...)
   local values = self.values
   local val = safe_get(values, ...)
   if not val then
      val = self.fun(...)
      safe_put(val, values, ...)
   end
   return val
end

function memoize:forget(...)
   safe_put(nil, self.values, ...)
end

function util.log(...)
   local msg = util.map(tostring, {...})
   io.stderr:write(table.concat(msg, " ") .. "\n")
   io.stderr:flush()
end

function util.mapkv(f, t)
   local r = {}
   for k, v in pairs(t) do
      local l, w = f(k, v)
      r[l or #r + 1] = w
   end
   return r
end

function util.map(f, t)
   local r = {}
   for i, v in pairs(t) do
      r[i] = f(v)
   end
   return r
end

function util.update(t, u, ...)
   for i, v in pairs(u) do
      t[i] = v
   end
   if ... then
      return util.update(t, ...)
   else
      return t
   end
end

function util.merge(...)
   return util.update({}, ...)
end

util.config = {}
util.config.data_dir = require("digestif-data")
util.config.dots = {...}
util.config.eol = "\n"

function util.eval_with_env(str, env)
   local globals, ok = {}, nil
   setmetatable(globals, {__index = env})
   local chunk, result = load(str, nil, "t", globals)
   if chunk then
      ok, result = pcall(chunk)
   end
   setmetatable(globals, nil)
   if not ok then return nil, result end
   return result or globals
end

local lpeg = require "lpeg"
local P, C = lpeg.P, lpeg.C

local dirname_patt = ((P(1) - P"/")^0 * P"/")^0
local is_abs_patt = P"/"

function util.dirname(filename)
   return C(dirname_patt):match(filename)
end

function util.basename(filename)
   return (dirname_patt * C(P(1)^0)):match(filename)
end

function util.filename_is_abs(filename)
   return is_abs_patt:match(filename) and true or false
end

-- is this better?
function util.split_filename(filename)
   local dir, base = filename:match("(.*/)(.*)")
   return dir or "", base or filename
end

--- Iterate over lines of a string
function util.lines(str, pos)
   pos = pos or 1
   local l, find, eol = 0, string.find, util.config.eol
   return function()
      if not pos then return nil end
      local i = pos
      local j, k = find(str, eol, pos, true)
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

return util
