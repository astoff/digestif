util = require "digestif.util"
block = require "serpent".block
trim = util.trim()

if not arg[1] and arg[2] then
  error [[
Usage: extract-stix-tbl.lua unimath-symbols.ltx unicode-math-table.tex

These files can be downloaded from https://github.com/wspr/unicode-math/
]]
end

symbolsfile = io.open(arg[1]):read("all")
tablefile = io.open(arg[2]):read("all")

plainlist = string.match(symbolsfile, "\\def\\PLAIN(%b{})")
ltxlist = string.match(symbolsfile, "\\def\\LTXSYM(%b{})")
amslist = string.match(symbolsfile, "\\def\\AMSSYMB(%b{})")

where = {}

for cs in plainlist:gmatch("\\(%a*)") do
  where[cs] = "plain"
end
for cs in ltxlist:gmatch("\\(%a*)") do
  where[cs] = "latex"
end
for cs in amslist:gmatch("\\(%a*)") do
  where[cs] = "ams"
end

collections = {plain = {}, latex = {}, ams = {}, um = {}}

for uni, cs, class, descr in tablefile:gmatch("\\UnicodeMathSymbol{\"(.-)}{\\(.-)}{\\(.-)}{(.-)}") do
  cs = trim(cs)
  class = trim(class)
  descr = trim(descr)
  local item = {
    doc = descr,
    symbol = (class == "mathaccent" and "◌" or "") .. utf8.char(tonumber(uni,16))
  }
  collections[where[cs] or "um"][cs] = item
  local alias = cs:match("^mup(.*)")
  if where[alias] then collections[where[alias]][alias] = item end
end

header = [[
source = {
  url = "https://github.com/wspr/unicode-math/",
  license = "LPPL 1.3c"
}

]]

function serialize(tbl, name)
  local s = require"serpent".block(tbl, {name = name, comment = false})
  s = s:gsub("^do local ", "")
  s = s:gsub("return [^\n]*\nend$", "")
  return s
end

f = io.open("plain-symbols.lua", "w")
f:write(header)
f:write(serialize(collections.plain, "commands"))
f = io.open("amssymb.sty.lua", "w")
f:write(header)
f:write(serialize(collections.ams, "commands"))
f = io.open("unicode-math.sty.lua", "w")
f:write(header)
f:write(serialize(collections.um, "commands"))
