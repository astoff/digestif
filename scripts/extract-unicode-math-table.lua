util = require "digestif.util"
save_from_table = require"luarocks.persist".save_from_table
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
  where[cs] = "plain"
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
    symbol = (class:match"accent" and "◌" or "") .. utf8.char(tonumber(uni,16))
  }
  if where[cs] then collections[where[cs]][cs] = item end
  collections["um"][cs] = item
  local alias = cs:match("^mup(.*)")
  if where[alias] then collections[where[alias]][alias] = item end
  if alias then collections["um"][alias] = item end
end

header = [[
Extracted from the unicode-math package source
URL: https://github.com/wspr/unicode-math/
License: LPPL 1.3c
]]

save_from_table("plain-symbols.lua", {comments=header, commands=collections.plain}, {"comments", "package"})
save_from_table("amssymb.sty.lua", {comments=header, commands=collections.ams}, {"comments", "package"})
save_from_table("unicode-math.sty.lua", {
                  comments=header,
                  package = {
                    name = "unicode-math.sty",
                    documentation = "texmf:doc/latex/unicode-math/unicode-math.pdf"
                  },
                  commands=collections.um},
                {"comments", "package"})
