local Parser = require "digestif.Parser"
local lpeg = require "lpeg"
local util = require "digestif.util"

local B, P, R, S, V, C, Cf, Cp, Ct
   = lpeg.B, lpeg.P, lpeg.R, lpeg.S, lpeg.V, lpeg.C, lpeg.Cf, lpeg.Cp, lpeg.Ct

local parser = Parser()
local patt = parser.patt
local cat = parser.cat

local group_patt = cat.bgroup * C(patt.token_or_braced^0) * cat.egroup

local detex_patt = group_patt / function (s) return {group = s} end
   + patt.cs * patt.skipped / function (s) return {cs = s} end
   + C(cat.char)

local detex_fold_patt = Cf(detex_patt^0, function (a, b) return a .. b end)

local symbols = {ss = "ß"}
local accents = {
   ["'"] = "́",
   ["c"] = "̧"}

return function (s, i)
   local t = Ct(detex_patt^0):match(s,i)
   local r = ""
   for i,u in ipairs(t) do
      if type(u) == 'string' then
         -- pass
      elseif u.group then
         t[i] = detexify(u.group)
      elseif u.cs then
         if symbols[u.cs] then t[i] = symbols[u.cs]
         elseif accents[u.cs] then t[i] = {accent = accents[u.cs]}
         else t[i] = "\\" .. u.cs .. " "
         end
      end
   end
   for i = #t, 1, -1 do
      local u = t[i] 
      if type(u) == 'string' then
         -- pass
      else
         t[i] = t[i+1]
         t[i+1] = u.accent
      end
   end
   return table.concat(t)
end

