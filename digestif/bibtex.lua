local lpeg = require "lpeg"
local util = require "digestif.util"

local B, P, R, S, V
   = lpeg.B, lpeg.P, lpeg.R, lpeg.S, lpeg.V
local C, Cc, Cp, Ct, Cmt, Cg
   = lpeg.C, lpeg.Cc, lpeg.Cp, lpeg.Ct, lpeg.Cmt, lpeg.Cg
local concat = table.concat
local merge = util.merge

local function ipairs_from(t, i)
  return ipairs(t), t, i - 1
end

local bibtex = {}

-- case insensitive literal
local function Pi(s)
  local patt = P(true)
  for c in s:gmatch(".") do
    local l, u = c:lower(), c:upper()
    if l == u then
      patt = patt * P(c)
    else
      patt = patt * S(l .. u)
    end
  end
  return patt
end

local function Fail(msg)
  local raise_error = function(s,p)
    error("bibtex parse error at position " .. p .. ": " .. msg)
    return true
  end
  return Cmt(P(1), raise_error)
end

function t(patt)
  return lpeg.Cmt(patt, function(s,p) print(p) return p end)
end

local at = P"@"
local newline = P"\n"
local space = S" \r\n\t"
local whitespace = space^0
local comment = P"%" * (1 - newline)^0 * newline
local junk = (comment + 1 - at)^0
local number = whitespace * C(R"09"^1)
local name = whitespace * C((R"az" + R"AZ" + R"09" + S"!$&*+-./:;<>?[]^_`|")^1)
local lbrace = whitespace * P"{"
local rbrace = whitespace * P"}"
local lparen = whitespace * P"("
local rparen = whitespace * P")"
local equals = whitespace * P"="
local hash = whitespace * P"#"
local comma = whitespace * P","
local quote = whitespace * P'"'
local lit_string = whitespace * C(Pi"string")
local lit_comment = whitespace * C(Pi"comment")
local lit_preamble = whitespace * C(Pi"preamble")

local l = Cg(Cp(), "start")
local r = Cg(Cp(), "stop")

local function braced(patt)
  return lbrace * patt * rbrace + lparen * patt * rparen
end

local curly_braced_string = P{"{" * C(((1 - S"{}") + V(1)/0)^0) * "}"}
local round_braced_string = P{"(" * C(((1 - S"()") + V(1)/0)^0) * ")"}
local braced_string = whitespace * (curly_braced_string + round_braced_string)
local quoted_string = quote * C((1 - P'"')^0) * P'"'
local simple_value = quoted_string + braced_string + number + Ct(name)
local value = simple_value * (hash * simple_value)^0
local field = Ct(name * equals * value) + whitespace
local fields = field * (comma * field)^0
local token = curly_braced_string/0 + P(1)
local nonspace = token - space

local comment_entry = at * lit_comment * braced_string
local preamble_entry = at * lit_preamble * braced(value)
local regular_entry = at * name * braced(name * comma * fields)
local string_entry = at * lit_string * braced(fields)
local entry = string_entry + comment_entry + preamble_entry + regular_entry

local all_entries = Ct((junk * Ct(l * entry * r))^0)

local function process_value(val, strings, i)
  i = i or 2
  t = {}
  for _, v in ipairs_from(val, i) do
    if type(v) == "table" then
      t[#t+1] = strings[v[1]] or ""
    else
      t[#t+1] = v
    end
  end
  return concat(t)
end

local default_options = {
  with_authors = true,
  with_title = true
}

local BibItem = {}
local mt = {__index = BibItem}
setmetatable(
  BibItem, {
    __call = function(_,t) return setmetatable(t, mt) end
})

--- Parse a bibtex file
function bibtex.parse(src, options)
  options = merge(default_options, options)
  local entries = all_entries:match(src)
  local strings = merge(options.strings)
  local preambles = {}
  local ids = {}
  local items = {
    strings = strings,
    preambles = preambles,
    ids = ids
  }
  for _, t in ipairs(entries) do
    local entry_type = t[1]:lower()
    if entry_type == "comment" then
      -- pass
    elseif entry_type == "preamble" then
      preambles[#preambles + 1] = t[2]
    elseif entry_type == "string" then
      for _, u in ipairs_from(t, 2) do
        local key = u[1]:lower()
        local val = process_value(u, strings)
        strings[key] = val
      end
    else
      local id = t[2]
      local fields = {}
      for _, u in ipairs_from(t, 3) do
        local key = u[1]:lower()
        local val = process_value(u, strings)
        fields[key] = val
      end
      local item = BibItem {
        id = id,
        type = entry_type,
        fields = fields,
        pos = t.start,
        len = t.stop - t.start
      }
      ids[id] = item
      items[#items + 1] = item
    end
  end
  return items
end

local function search_patt(patt)
  return P{patt + 1 * V(1)}
end

local function make_split_patt(sep)
  return Ct((C((token - P(sep))^1) + P(sep))^1)
end

local split_authors = make_split_patt(space * "and" * space)
local split_name = make_split_patt("," * whitespace)
local split_last = search_patt(Cp() * C(nonspace^1) * whitespace * P(-1))

function BibItem:authors()
  local t = {}
  local author = self.fields.author
  if not author then return {} end
  for i, name in ipairs(split_authors:match(author)) do
    local u = {}
    local parts = split_name:match(name)
    if #parts == 3 then
      u.first = parts[3]
      u.last = parts[1]
      u.suffix = parts[2]
    elseif #parts == 2 then
      u.first = parts[2]
      u.last = parts[1]
    else
      local p, l = split_last:match(name)
      if p then
        u.first = name:sub(1, p - 1)
        u.last = l
      else
        u.last = name
      end
    end
    t[i] = u
  end
  return t
end

function BibItem:pretty_print()
  local t, a = {}, {}
  for _, name in ipairs(self:authors()) do
    a[#a + 1] = name.last
  end
  t[#t + 1] = concat(a, ", ")
  t[#t + 1] = self.fields.year or self.fields.date
  t[#t + 1] = self.fields.title
  return concat(t, " ")
end

return bibtex
