local lpeg = require "lpeg"
local util = require "digestif.util"
local config = require "digestif.config"

local P = lpeg.P
local C, Cc = lpeg.C, lpeg.Cc

local data_dirs = config.data_dirs

local data = {loaded = {}}

local token = P(1)
local xparse_patt = (P" "^0 * P"+"^-1 *
   (  "m" * Cc{optional = false}
    + "r" * C(token) * C(token)
          / function (tok1, tok2) return {delims = {tok1, tok2}} end
    + "u{"* C((token - "}")^0) * "}"
          / function (toks) return {delims = {"", toks}} end
    + "v" * Cc{type = "verbatim"}
    + "o" * Cc{optional = true, delims = {"[", "]"}}
    + "d" * C(token) * C(token)
          / function (tok1, tok2) return {optonal = true, delims = {tok1, tok2}} end
    + "s" * Cc{type = "literal", literal = "*", optional = true, delims = false}
    + "t" * C(token)
          / function (tok) return {type = "literal", literal = tok, optional = true} end
    + "g" * Cc{optional = true, delims = {"{", "}"}}))^0

function data.signature(sig, ...)
   local args = {...}
   for i, arg in ipairs({xparse_patt:match(sig)}) do
      if type(args[i]) ~= "table" then
         args[i] = {meta = args[i] or "#" .. i}
      end
      util.update(args[i], arg)
   end
   return args
end

function data.require(name)
   return data.loaded[name] or data.load(name)
end

local load_data_mt = {
   __index = {
      merge = util.merge,
      data = data.require,
      signature = data.signature
   }
}

local function rename_fields(t)
  if t.doc then
    t.summary = t.doc
    t.doc = nil
  end
  if t.args then
    t.arguments = t.args
    t.args = nil
  end
  for _, v in pairs(t) do
    if type(v) == "table" then rename_fields(v) end
  end
end

function data.load(name)
   if name:find('..', 1, true) then return end -- unreasonable file name
   local src = util.try_read_file(data_dirs, name .. ".lua")
   if not src then return end
   local result, err = util.eval_with_env(src, load_data_mt)
   if not result then util.log(err) end
   rename_fields(result)
   data.loaded[name] = result
   return result
end

return data
