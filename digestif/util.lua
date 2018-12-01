local lpeg = require "lpeg"
local P, V = lpeg.P, lpeg.V
local C, Cp = lpeg.C, lpeg.Cp

local util = {}

--- Classes

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

--- Table manipulation

function util.map(f, t)
   local r = {}
   for i, v in pairs(t) do
      r[i] = f(v)
   end
   return r
end

local function update(t, u, ...)
   for i, v in pairs(u) do
      t[i] = v
   end
   if ... then
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

--- Memoization

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

--- Reading data and config files

util.config = {}
util.config.data_dir = "digestif-data/"
util.config.eol = "\n"

function util.eval_with_env(str, env)
   local globals, ok = {}, nil
   setmetatable(globals, {__index = env})
   local chunk, result = load(str, nil, "t", globals)
   if chunk then
      ok, result = pcall(chunk)
   end
   if not ok then return nil, result end
   return result or setmetatable(globals, nil)
end

function util.update_config(str)
   local config = require"digestif.config"
   local new_config = util.eval_with_env(str)
   update(config, new_config)
end

--- Path and file manipulation

local path_sep = "/"
local path_sep_patt = P(path_sep)
local path_is_abs_patt = path_sep_patt + P"~/"
local path_trim_patt = C((path_sep_patt^0 * (1 - path_sep_patt)^1)^0)
local path_last_sep_patt = P{Cp() * (1 - path_sep_patt)^0 * -1 + (1 * V(1))}

local function path_join(p, q, ...)
   if not q then return p end
   if path_is_abs_patt:match(q) or p == "" then
      return path_join(q, ...)
   end
   p = path_trim_patt:match(p) .. path_sep
   return path_join(p .. q, ...)
end
util.path_join = path_join

function util.path_split(p)
   p = path_trim_patt:match(p)
   local i = path_last_sep_patt:match(p) or 1
   return p:sub(1, i-1), p:sub(i, -1)
end

function util.io_open_template(template, name, mode)
   for str in template:gmatch("[^;]+") do
      local filename = str:gsub("?", name)
      local f = io.open(filename, mode)
      if f then return f end
   end
end

--- String manipulation

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

--- &c.

function util.log(...)
   local msg = util.map(tostring, {...})
   io.stderr:write(table.concat(msg, " ") .. "\n")
   io.stderr:flush()
end

return util
