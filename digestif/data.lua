local lpeg = require "lpeg"
local util = require "digestif.util"
local config = require "digestif.config"

local P = lpeg.P
local C, Cc = lpeg.C, lpeg.Cc

local data = {loaded = {}}

local token = P(1)
local xparse_patt = (P" "^0 * P"+"^-1 *
   (  "m" * Cc{optional = false}
    + "r" * C(token) * C(token)
          / function (tok1, tok2) return {delimiters = {tok1, tok2}} end
    + "u{"* C((token - "}")^0) * "}"
          / function (toks) return {delimiters = {"", toks}} end
    + "v" * Cc{type = "verbatim"}
    + "o" * Cc{optional = true, delimiters = {"[", "]"}}
    + "d" * C(token) * C(token)
          / function (tok1, tok2) return {optonal = true, delimiters = {tok1, tok2}} end
    + "s" * Cc{type = "literal", literal = "*", optional = true, delimiters = false}
    + "t" * C(token)
          / function (tok) return {type = "literal", literal = tok, optional = true} end
    + "g" * Cc{optional = true, delimiters = {"{", "}"}}))^0

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

local ref_patt = P"$DIGESTIFDATA/" * C(P(1)^0)
local ref_split = util.split("/")

local function resolve_refs(tbl)
  for k, v in pairs(tbl) do
    if type(v) == "string" then
      local path = ref_patt:match(v)
      if path then
        local t = ref_split(path)
        tbl[k] = util.nested_get(data.require(t[1]), table.unpack(t, 2))
      end
    elseif type(v) == "table" then
      resolve_refs(v) -- TODO: prevent infinite loops
    end
  end
end

function data.load(name)
  if name:find('..', 1, true) then return end -- unreasonable file name
  local src = util.try_read_file(config.data_dirs, name .. ".tags")
  if not src then return end
  local result, err = util.eval_with_env(src, load_data_mt)
  if not result then util.log(err) end
  data.loaded[name] = result
  resolve_refs(result)
  return result
end

return data
