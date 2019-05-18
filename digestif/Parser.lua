--- Parser class
-- @classmod digestif.Parser

local lpeg = require "lpeg"
local util = require "digestif.util"

local C = lpeg.C
local Cc = lpeg.Cc
local Cg = lpeg.Cg
local Cs = lpeg.Cs
local Ct = lpeg.Ct
local P = lpeg.P
local R = lpeg.R
local S = lpeg.S
local V = lpeg.V
local match = lpeg.match

local I = lpeg.Cp()
local Ipos = Cg(I, "pos")
local Icont = Cg(I, "cont")
local Iouter_pos = Cg(I, "outer_pos")
local Iouter_cont = Cg(I, "outer_cont")
local Kcs = Cc("cs")
local Kmathshift = Cc("mathshift")
local Knil = Cc(nil)
local Kpar = Cc("par")
local Ktrue = Cc(true)
local Pend = P(-1)

local gobble_until = util.gobble_until
local matcher = util.matcher
local search = util.search
local trim = util.trim

local weak_keys = {__mode = "k"}

local default_catcodes = {
  escape = P("\\"),
  bgroup = P("{"),
  egroup = P("}"),
  mathshift = P("$"),
  eol = P("\n"),
  letter = R("az", "AZ"),
  comment = P("%"),
  char = P(1), -- are we utf-8 agnostic?
  space = S(" \t"),
  listsep = P(","),
  valsep = P("=")
}

local Parser = util.class()

function Parser:__init(catcodes)
  catcodes = catcodes or default_catcodes

  -- single characters
  local escape    = P(catcodes.escape    or default_catcodes.escape)
  local bgroup    = P(catcodes.bgroup    or default_catcodes.bgroup)
  local egroup    = P(catcodes.egroup    or default_catcodes.egroup)
  local mathshift = P(catcodes.mathshift or default_catcodes.mathshift)
  local eol       = P(catcodes.eol       or default_catcodes.eol)
  local letter    = P(catcodes.letter    or default_catcodes.letter)
  local comment   = P(catcodes.comment   or default_catcodes.comment)
  local char      = P(catcodes.char      or default_catcodes.char)
  local space     = P(catcodes.space     or default_catcodes.space)
  local listsep   = P(catcodes.listsep   or default_catcodes.listsep)
  local valsep    = P(catcodes.valsep    or default_catcodes.valsep)

  -- basic elements
  local eol_or_end = eol + Pend
  local blank = space + eol
  local nonbrace = char - (bgroup + egroup)
  local cs = escape * (letter^1 + char)
  local csname = escape * C(letter^1 + char)
  local blank_line = eol * space^0 * eol
  local single_eol = eol * space^0 * -eol
  local comment_line = comment * gobble_until(eol, char)
  local par = blank_line * (space + eol + comment_line)^0
  local skipped = (space + single_eol + comment_line)^0

  -- larger units of text
  local token_or_braced = P{ -- fails at end of paragraph
      [1] = I * (cs + nonbrace) * I + V(2) - blank_line,
      [2] = bgroup * I * (comment_line + V(1)/0)^0 * I * egroup
   }
  local token_or_braced_partial = P{ -- similar, but successfully stops at end of paragraph or string
      [1] = Ipos * (cs + nonbrace) * Icont + V(2) - blank_line,
      [2] = Iouter_pos * bgroup * Ipos
        * (comment_line + V(1)/0)^0
        * Icont * (egroup + Pend + #blank_line) * Iouter_cont
  }
  local token_or_braced_long = P{ -- crosses paragraph boundaries
      [1] = I * (cs + nonbrace) * I + V(2),
      [2] = bgroup * I * (comment_line + V(1)/0)^0 * I * egroup
   }
  -- patterns that search ahead
  local next_thing = search(
    I * (Kcs * csname + mathshift * Kmathshift * Knil + par * Kpar * Knil) * I,
    comment_line + char
  )
  local next_par = search(blank_line, comment + char)
    * (eol + space + comment_line)^0 * I * char

  -- trimming, cleaning, and cropping
  local trimmer = blank^0 * C((blank^0 * (char - blank)^1)^0)
  local cleaner = blank^0 * Cs(((blank^1 / " " + true) * (char - blank)^1)^0)
  local comment_block = ((eol * space^0)^-1 * comment_line)^1
  local comment_stripper = Cs((comment_block / "" + char)^0)

  -- parsing lists
  local skim_unit = comment_line + token_or_braced_long/0
  local skipped_long = (space + eol + comment_line)^0
  local listsep_skip = listsep * skipped_long

  local list_item = Ct(Ipos * (skim_unit - listsep)^1 * Icont)
  local list_parser = skipped_long * Ct((listsep_skip^0 * list_item)^0)

  local list_reader = skipped_long * Ct(
    (listsep_skip^0 * C((skim_unit - listsep)^1)
       / trim(space + eol + comment_line, char))^0)

  local key = Ct(Ipos * (skim_unit - listsep - valsep)^1 * Icont)
  local value = Ct(valsep * skipped_long * Ipos * (skim_unit - listsep)^0 * Icont)
  local kvlist_item = Ct(Ipos * Cg(key, "key") * Cg(value, "value")^-1 * Icont)
  local kvlist_parser = skipped_long * Ct((listsep_skip^0 * kvlist_item)^0)

  local patt_from_arg = function(arg)
    local val = skipped
    if arg.delims == nil then -- plain mandatory argument
      val = val * Ct(token_or_braced_partial)
    elseif arg.delims == false then
      if arg.type == "literal" then
        val = val * Ct(Ipos * P(arg.literal) * Icont)
      elseif arg.type == "cs" then
        val = val * Ct(Ipos * cs * Icont)
      end
    else -- assume delims is a tuple
      local l, r = arg.delims[1], arg.delims[2]
      local patt = Iouter_pos * l * Ipos
        * (comment_line + token_or_braced_partial/0 - r)^0
        * Icont * (r + Pend + #blank_line) * Iouter_cont
      val = val * Ct(patt)
    end
    if arg.optional then
      val = val + Ct(Cg(Ktrue, "ommited"))
    end
    return val
  end

  local patt_from_arglist = function(args)
    local patt = Ipos
    for i = 1, #args do
      patt = patt * (patt_from_arg(args[i]) + Cg(Ktrue, "incomplete"))
    end
    return Ct(patt * Icont)
  end

  local patt_store = setmetatable({}, weak_keys)

  self.parse_args = function(arglist, str, pos)
    local patt = patt_store[arglist]
    if not patt then
      patt = patt_from_arglist(arglist)
      patt_store[arglist] = patt
    end
    return match(patt, str, pos)
  end

  -- public patterns
  self.next_par = next_par
  self.comment_line = comment_line
  self.cs = cs
  self.csname = csname
  self.token_or_braced_partial = token_or_braced_partial
  self.skipped = skipped
  self.blank_line = blank_line
  self.next_thing = next_thing

  -- public functions from patterns
  self.is_blank_line = matcher(space^0 * eol)
  self.next_nonblank = matcher(skipped * I)
  self.trim = matcher(trimmer)
  self.clean = matcher(cleaner)
  self.strip_comments = matcher(comment_stripper)
  self.skip_to_bracketed = matcher( -- for tikz paths
    search(
      patt_from_arg{delims = {"[", "]"}},
      skim_unit - blank_line))

  --- Parse a list.
  -- @function Parser.parse_list
  self.parse_list = matcher(list_parser)
  self.read_list = matcher(list_reader)
  self.parse_kvlist = matcher(kvlist_parser)

end

return Parser
