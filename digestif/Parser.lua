-- Parser class

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
local Pend = P(-1)
local is_incomplete = Cg(Cc(true), "incomplete")
local is_omitted = Cg(Cc(true), "omitted")

local choice = util.choice
local gobble_until = util.gobble_until
local many = util.many
local matcher = util.matcher
local search = util.search
local sequence = util.sequence
local trim = util.trim

local default_catcodes = {
  escape = P("\\"),
  bgroup = P("{"),
  egroup = P("}"),
  mathshift = P("$"),
  eol = P("\n"),
  letter = R("az", "@Z"),
  comment = P("%"),
  char = P(1), -- are we utf-8 agnostic?
  space = S(" \t"),
  listsep = P(","),
  valsep = P("=")
}

local Parser = util.class()

function Parser:__init(catcodes)
  catcodes = catcodes or default_catcodes

--* Single characters
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

--* Basic elements
  local blank = space + eol
  local cs = escape * (letter^1 + char)
  local csname = escape * C(letter^1 + char)
  local token = cs + char
  local blank_line = eol * space^0 * eol
  local single_eol = eol * space^0 * -eol
  local comment_line = comment * gobble_until(eol, char)
  local skip = (space + single_eol + comment_line)^0 -- simulates TeX state S
  local skip_long = (space + eol + comment_line)^0
  local par = blank_line * (space + eol + comment_line)^0
  local next_par = search(blank_line, comment + char)
    * (eol + space + comment_line)^0 * I * char -- need this char at the end?

  -- These patterns match text delimited by braces.  They succeed on a
  -- incomplete subject string (with the additional incomplete = true
  -- named capture).  The second variant does not cross paragraph
  -- boundaries.
  local group_long = sequence(
    Iouter_pos,
    P{sequence(bgroup,
               Ipos,
               many(choice(comment_line,
                           V(1)/0,
                           token - egroup)),
               Icont,
               egroup + is_incomplete)},
    Iouter_cont)
  local group = sequence(
    Iouter_pos,
    P{sequence(bgroup,
               Ipos,
               many(choice(comment_line,
                           V(1)/0,
                           token - egroup)
                      - blank_line),
               Icont,
               egroup + is_incomplete)},
    Iouter_cont)

--* Trimming, cleaning, and cropping
  local trimmer = blank^0 * C((blank^0 * (char - blank)^1)^0)
  local cleaner = blank^0 * Cs(((blank^1 / " " + true) * (char - blank)^1)^0)
  local comment_block = ((eol * space^0)^-1 * comment_line)^1 -- use the one below?
  -- local comment_block = (comment_line * (Pend + eol * space^0))^0
  local comment_stripper = Cs((comment_block / "" + char)^0)

--* Parsing lists
  local skim_long = comment_line + group_long/0 + token
  local listsep_skip = listsep * skip_long

  local list_item = Ct(Ipos * (skim_long - listsep)^1 * Icont)
  local list_parser = skip_long * Ct((listsep_skip^0 * list_item)^0)

  local list_reader = skip_long * Ct(
    (listsep_skip^0 * C((skim_long - listsep)^1)
       / trim(space + eol + comment_line, char))^0)

  local key = Ct(Ipos * (skim_long - listsep - valsep)^1 * Icont)
  local value = Ct(valsep * skip_long * Ipos * (skim_long - listsep)^0 * Icont)
  local kvlist_item = Ct(Ipos * Cg(key, "key") * Cg(value, "value")^-1 * Icont)
  local kvlist_parser = skip_long * Ct((listsep_skip^0 * kvlist_item)^0)

--* Parsing command arguments
  local patt_from_arg = function(arg)
    local ret = skip
    if arg.delimiters then
      local l, r = arg.delimiters[1], arg.delimiters[2]
      ret = sequence(
        ret, Iouter_pos, l, Ipos,
        many(
          choice(comment_line,
                 group/0,
                 token)
            - blank_line - r),
        Icont,
        r + is_incomplete,
        Iouter_cont)
    elseif arg.literal then
      ret = ret * Ipos * P(arg.literal) * Icont
    else -- plain argument
      ret = ret * (group + Ipos * token * Icont)
    end
    if arg.optional then
      ret = ret + is_omitted
    end
    return Ct(ret)
  end

  local patt_from_args = function(args)
    local ret = Icont
    for i = #args, 1, -1 do
      ret = (patt_from_arg(args[i]) + is_incomplete) * ret
    end
    return Ct(Ipos * ret)
  end
  patt_from_args = util.memoize1(patt_from_args)

  local parse_args = function(args, str, pos)
    return match(patt_from_args(args), str, pos)
  end

--* Public patterns
  self.group = group
  self.group_long = group_long
  self.next_par = next_par
  self.comment_line = comment_line
  self.cs = cs
  self.csname = csname
  self.blank_line = blank_line

--* Public functions
  self.parse_args = parse_args
  self.is_blank_line = matcher(space^0 * eol)
  self.next_nonblank = matcher(skip * I)
  self.trim = matcher(trimmer) -- replace def of trimmer directly in here?
  self.clean = matcher(cleaner)
  self.strip_comments = matcher(comment_stripper)
  self.skip_to_bracketed = matcher( -- for tikz paths
    search(
      patt_from_arg{delimiters = {"[", "]"}},
      skim_long - blank_line)) -- also exclude ";"?

  -- Parse a list, return a sequence of ranges
  self.parse_list = matcher(list_parser)
  -- Parse a list, return the item contents as strings
  self.read_list = matcher(list_reader)
  -- Parse a key-value list, return their contents as strings
  self.parse_kvlist = matcher(kvlist_parser)

  -- Match a normal control sequence name starting with prefix
  function self.cs_matcher(prefix)
    local patt = P(prefix) * letter^0 * Pend
    return matcher(patt)
  end

  -- Build a pattern for Manuscript.scan, which looks ahead for one of
  -- the elements of the set `things`.  A match produces 4 captures: a
  -- position before the item, the kind of item ("cs", "mathshift" or
  -- "par"), a detail (e.g., the control sequence if kind is "cs"),
  -- and a position after the item.
  --
  self.scan_patt = function(things)
    local patt = Kcs * csname
    if things.mathshift then
      patt = patt + mathshift * Kmathshift * (mathshift * Cc"$$" + Cc"$")
    end
    if things.par then patt = patt + par * Kpar * Knil end
    return search(I * patt * I, comment_line + char)
  end

end

return Parser
