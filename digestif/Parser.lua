local lpeg = require "lpeg"
local util = require "digestif.util"

local B, P, R, S, V, C, Cc, Cp, Ct
   = lpeg.B, lpeg.P, lpeg.R, lpeg.S, lpeg.V, lpeg.C, lpeg.Cc, lpeg.Cp, lpeg.Ct

local Parser = util.class()

local basic_cat = {
   escape = P("\\"),
   bgroup = P("{"),
   egroup = P("}"),
   mathshift = P("$"),
   eol = P("\n"),
   letter = R("az", "AZ"),
   comment = P("%"),
   char = P(1), -- are we utf-8 agnostic?
   space = S(" \t"),
}

local function wrap_patt(patt)
   return function(_, ...) return patt:match(...) end
end

function Parser:__init(cat)
   local patt, cat = {}, cat or basic_cat
   self.cat, self.patt = cat, patt

   patt.eol_or_end = cat.eol + P(-1)
   patt.blank = cat.space + cat.eol + P(-1)
   patt.nonbrace = cat.char - (cat.bgroup + cat.egroup)
   patt.cs = cat.escape * C(cat.letter^1 + cat.char)
   --patt.before_blank_line = cat.eol * cat.space^0 * cat.eol -- probably can replace this by blank_line anywhere needed
   patt.blank_line = B(cat.eol) * cat.space^0 * cat.eol -- how about blank first line in string?
   patt.comment = cat.comment * (cat.char - cat.eol)^0 * patt.eol_or_end --one comment
   -- patt.par = (cat.space + cat.eol + patt.comment - patt.blank_line)^0
   --    * patt.blank_line * (cat.space + cat.eol + patt.comment)^0
   patt.par = patt.blank_line * (cat.space + cat.eol + patt.comment)^0
      -- both patts end at the beginning of the new par; which do we want?
   patt.skipped = (cat.space + cat.eol + patt.comment - patt.blank_line)^0
   patt.token_or_braced = P{ -- fails at end of paragraph
      [1] = Cp() * (patt.cs/0 + patt.nonbrace) * Cp() + V(2) - patt.blank_line,
      [2] = cat.bgroup * Cp() * (patt.comment + V(1)/0)^0 * Cp() * cat.egroup
   }
   patt.token_or_braced_partial = P{ -- similar, but successfully stops at end of paragraph or string
      [1] = Cp() * (patt.cs/0 + patt.nonbrace) * Cp() + V(2) - patt.blank_line,
      [2] = cat.bgroup * Cp() * (patt.comment + V(1)/0)^0
         * Cp() * (cat.egroup + P(-1) + #patt.blank_line)
   }
   patt.token_or_braced_long = P{ -- crosses paragraph boundaries
      [1] = Cp() * (patt.cs/0 + patt.nonbrace) * Cp() + V(2),
      [2] = cat.bgroup * Cp() * (patt.comment + V(1)/0)^0 * Cp() * cat.egroup
   }
   patt.next_thing = P{
      [1] = V"uninteresting"^0 * (V"cs" + V"mathshift" + V"par") * Cp(),
      uninteresting = patt.comment + cat.char - (cat.escape + cat.mathshift + patt.blank_line),
      cs = Cp() * patt.cs / function (pos, cs) return {pos = pos, type = "cs", cs = cs} end,
      par = Cp() * patt.par / function (pos) return {pos = pos, type = "par"} end,
      mathshift = Cp() * cat.mathshift / function (pos) return {pos = pos, type = "mathshift"} end,
   }
   patt.next_thing3 = P{
      Cp()
      * ( Cc"cs" * patt.cs
          + cat.mathshift * Cc("mathshift", nil)
          + patt.par * Cc("par", nil)
      )
      * Cp()
      + (patt.comment + cat.char) * V(1)
   }
   patt.next_thing2 = P{ -- this is faster, doesn't need to create tables as above
      [1] = Cp() * (V"cs" + V"mathshift" + V"par") * Cp() + V"skip" * V(1),
      skip = patt.comment + cat.char,
      cs = Cc"cs" * patt.cs,
      par = patt.par * Cc("par", nil),
      mathshift = cat.mathshift * Cc("mathshift", nil),
   }
   patt.next_par =
      (patt.comment + cat.char - patt.blank_line)^0
      * (cat.eol + cat.space + patt.comment)^0 * Cp() * cat.char
   patt.strip_comments =
      Ct((patt.comment * cat.space^0 + C((cat.char - cat.comment)^1))^0) / table.concat -- or use Cs()
   patt.trim =
      patt.skipped * C((cat.char - (patt.skipped * P(-1)))^0) * patt.skipped
   patt.parse_keys =
      patt.skipped * Cp() * (patt.token_or_braced_long/0 - S",=")^1 * Cp()
      * (P"=" * patt.skipped * Cp() * (patt.token_or_braced_long/0 - P",")^0)^-1
      * Cp() * (P"," + P(-1))

   self.blank = wrap_patt(patt.blank)
   self.next_par = wrap_patt(patt.next_par)
   self.next_thing = wrap_patt(patt.next_thing2)
   self.trim = wrap_patt(patt.trim)
   self.strip_comments = wrap_patt(patt.strip_comments)
end

function Parser:arg_delims(l, r)
   local patt = self.patt
   return l * Cp() * (patt.comment + patt.token_or_braced_partial/0 - r)^0
      * Cp() * (r + P(-1) + #patt.blank_line) * Cp()
end
--Parser:_memoize("arg_delims")

--- Parse a macro's arguments
-- @param src a string
-- @param pos a position in src (after the control sequence)
-- @param args a list of `arg` tables
function Parser:parse_args(src, pos, args)
   local patt = self.patt
   local result = {}
   -- result.pos = (patt.skipped * Cp()):match(src, pos)
   result.pos = pos
   for i, arg in ipairs(args) do
      pos = (patt.skipped * Cp()):match(src, pos)
      if patt.blank_line:match(src, pos) then
         result.len = pos - result.pos
         return result -- stop at end of paragraph
      else
         result[i], pos = self:parse_one_arg(src, pos, arg)
         if not result[i] then
            result.len = pos - result.pos
            return result
         end
      end
   end
   result.len = pos - result.pos
   result.complete = true
   return result
end

function Parser:parse_one_arg(src, pos, arg)
   local patt = self.patt
   local s, e, cont
   if arg.delims == nil then -- plain mandatory argument
      s, e, cont = (patt.token_or_braced_partial * Cp()):match(src, pos)
      if cont then return {pos = s, len = e - s}, cont end
   elseif arg.delims == false then
      if arg.type == "literal" then
         cont = (P(arg.literal) * Cp()):match(src, pos)
         if cont then return {pos = pos, len = cont - pos}, cont end
      elseif arg.type == "cs" then
         cont = (patt.cs/0 * Cp()):match(src, pos)
         if cont then return {pos = pos, len = cont - pos}, cont end
      end
   else -- assume delims is a tuple
      s, e, cont = self:arg_delims(arg.delims[1], arg.delims[2]):match(src, pos)
      if cont then return {pos = s, len = e - s}, cont end
   end
   if arg.optional then
      return {omitted = true}, pos
   else
      return nil, pos
   end
end

function Parser:parse_keys(src, pos, len)
   pos = pos or 1
   local format_match = function(p1, p2, p3, p4)
      return {
         pos = pos + p1 - 1,
         len = (p4 or p2) - p1,
         key = {pos = pos + p1 - 1, len = p2 - p1},
         value = p4 and {pos = pos + p3 - 1, len = p4 - p3}}
   end
   return Ct((self.patt.parse_keys / format_match)^1):match(
      string.sub(src, pos, len and pos + len - 1)) or {}
end

--- Strip comments from a string
-- function Parser:strip_comments(src)
--    return self.patt.strip_comments:match(src)
-- end

-- function Parser:trim(src)
--    return self.patt.trim:match(src)
-- end

return Parser
