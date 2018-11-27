local lpeg = require "lpeg"
local util = require "digestif.util"

local DATA_DIR = util.config.data_dir

local data = {loaded = {}}

local token = lpeg.P(1)
local xparse_patt = (lpeg.P" "^0 * lpeg.P"+"^-1 *
   (  "m" * lpeg.Cc{optional = false}
    + "r" * lpeg.C(token) * lpeg.C(token)
          / function (tok1, tok2) return {delims = {tok1, tok2}} end
    + "u{"* lpeg.C((token - "}")^0) * "}"
          / function (toks) return {delims = {"", toks}} end
    + "v" * lpeg.Cc{type = "verbatim"}
    + "o" * lpeg.Cc{optional = true, delims = {"[", "]"}}
    + "d" * lpeg.C(token) * lpeg.C(token)
          / function (tok1, tok2) return {optonal = true, delims = {tok1, tok2}} end
    + "s" * lpeg.Cc{type = "literal", literal = "*", optional = true, delims = false}
    + "t" * lpeg.C(token)
          / function (tok) return {type = "literal", literal = tok, optional = true} end
    + "g" * lpeg.Cc{optional = true, delims = {"{", "}"}}))^0

-- get rid of this
local function process(tbl)
   if type(tbl.signature) == "string" then
      if not tbl.args then tbl.args = {} end
      for i, arg in ipairs({xparse_patt:match(tbl.signature)}) do
         if not tbl.args[i] then
            cmd.args[i] = {meta = "#" .. i}
         end
         util.update(tbl.args[i], arg)
      end
   end
   for _, item in pairs(tbl) do
      if type(item) == "table" then
         process(item)
      end
   end
end

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

local load_env = {merge = util.merge, data = data, signature = data.signature}

function data.load_data(name)
   if type(name) ~= "string" then return nil end
   -- need to check this forms a reasonable file name
   local f = io.open(DATA_DIR .. name .. ".lua")
   --local f = datafile.open("data/" .. name .. ".lua", "r")
   local result
   if f ~= nil then
      result, err = util.eval_with_env(f:read("*all"), load_env)
      f:close()
      if not result then util.log(err); return end
      process(result or {})
   end
   data.loaded[name] = result
   return result
end

--local lfs = require "lfs"
-- function data.load_all()
--    for filename in lfs.dir(DATA_DIR) do
--       if filename:sub(-4) == ".lua" then
--          data.load_data(filename:sub(1, -5))
--       end
--    end
-- end

setmetatable(data, {__call = function(_,s) return data.loaded[s] or data.load_data(s) end})

return data
