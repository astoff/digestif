-- Script to generate primitives.tags, plain.tags and
-- teximpatient.tags from the book “TeX for the Impatient”.

if not arg[1] then
   print("Usage: " .. arg[0] .. [[ PATH [--dump]

PATH should point to the root of the teximpatient repository
]])
   return
end

lpeg = require "lpeg"
P, V, R, S, B = lpeg.P, lpeg.V, lpeg.R, lpeg.S, lpeg.B
C, Cp, Cs, Cmt, Cf, Ct = lpeg.C, lpeg.Cp, lpeg.Cs, lpeg.Cmt, lpeg.Cf, lpeg.Ct
Cc, Cg = lpeg.Cc, lpeg.Cg

util = require "digestif.util"
lfs = require "lfs"
ser = require "serpent".block
dump = require "serpent".dump
concat = table.concat
merge = util.merge
search, gobble_until, case_fold = util.search, util.gobble_until, util.case_fold
split, replace = util.split, util.replace
inspect = util.inspect

tmpout = os.tmpname()
tmperr = os.tmpname()
pandoccmd = "pandoc --verbose -f latex -t markdown_strict+tex_math_dollars -o" .. tmpout .. " 2> " .. tmperr
preamble =[[
\def\anatomy{anatomy of \TeX}
\def\ascii{{ASCII}}
\def\asciichar#1{⟨#1⟩}
\def\bblfile{{\tt .bbl} file}
\def\bibfile{{\tt .bib} file}
\def\bstfile{{\tt .bst} file}
\def\didotpt{did\^ot point}
\def\dvifile{{\tt .dvi} file}
\def\em{\thinspace {\rm em}}
\def\emph#1{{\it #1}\itcorr}  % Emphasize.
\def\ftp{{\tt ftp}}
\def\gffile{{\tt .gf} file}
\def\hand{{\handfont A}}
\def\ifatest{{\tt \\if} test}
\def\knuth#1{#1 of \texbook}
\let\Metafont = \MF
\def\Mperiod{$M$}
\def\Mprimecomma{$M'$}
\def\Mprimeperiod{$M'$}
\def\mud{\thinspace {\rm mu}} % can't use \mu; it'a a Greek letter!
\def\newTeX{new \TeX}
\def\p{p.\thinspace}
\def\pkfile{{\tt .pk} file}
\def\plainTeX{plain \TeX}
\def\PlainTeX{Plain \TeX}
\def\pp{p\p}
\def\pt{\thinspace {\rm pt}}
\def\pxlfile{{\tt .pxl} file}
\def\tequiv{≡} % equivalence in text
\def\texbook{{\sl The \TeX book}\itcorr}
\def\TeXMeX{\TeX\ M\kern-.11em\lower .5ex\hbox{E}\kern-.125em X\null}%
\def\tfmfile{{\tt .tfm} file}
\def\thisbook{{\sl \TeX\ for the Impatient\/}}
\let\ths = \thinspace
\def\tminus{ - } % minus in text
\def\tplus{ + } % plus in text
\def\TUG{\TeX{} Users Group}
\def\Vcomma{$V$}
\def\visiblespace{{\tentt \char'040}}
\def\Vperiod{$V$}
\let\vs=\visiblespace

%\def\vfootnote{\footnote}
\def\display#1{}
\def\inches{ in}
\def\itcorr{}
\def\null{}
\def\minref#1{#1}
\def\minrefs#1{}
\def\bix#1{}
\def\eix#1{}
\def\ulist{\begin{itemize}}
\def\endulist{\end{itemize}}
\def\olist{\begin{enumerate}}
\def\endolist{\end{enumerate}}
\def\compact{}
\def\li{\item}
\def\-{}
\def\.{}
\def\thinspace{}
\def\noindent{}
\def\indent{}
\def\hbox#1{#1}
\def\xrefn#1{“TeX for the Impatient”}
\def\xrefpg#1{in “TeX for the Impatient”}
\def\headcit#1{“TeX for the Impatient”, #1,}
\def\conceptcit#1{“TeX for the Impatient”}
\def\margin#1{}
\def\tt{}
\def\param#1{(#1 parameter)}
\def\rqbraces#1{\lbrace #1\rbrace}
]]

function convert(s)
  local pd = io.popen(pandoccmd, "w")
  pd:write(preamble)
  pd:write(s)
  local exit = pd:close()
  local ef = io.open(tmperr)
  local err = ef:read"all"
  ef:close()
  return exit and io.open(tmpout):read"all", (err ~= "") and err
end
convert = util.memoize(convert)--function convert(s) return s end

function cs(s)
  return P("\\") * s * -Pletter * S(" \t")^0 * P"\n"^-1 * P(" ")^0 
end
function surrounded(l, r)
  if not r then r = l end
  return P(l) * C((1 - P(r))^0) * P(r)
end
Pletter = R'AZ' + R'az'
Pgroup = util.between_balanced("{", "}", "\\" * S"{}" + P(1))

--* Read main parts of the book

Pitem = P"\\begindesc\n"
  * C(util.gobble_until(P"\\explain")) * P"\\explain"
  * C(util.gobble_until(P"\\example" + "\\enddesc"))
Pitems = Ct(util.search(Ct(Pitem))^0)

items = {}

for f in lfs.dir(arg[1] .. "/teximpatient") do
  if f:match("%.tex$") then
    local s = io.open(arg[1] .. "/teximpatient/" .. f):read"all"
    for _, v in ipairs(Pitems:match(s)) do items[#items+1] = v end
  end
end

-- Filter to apply to tex files
filters = {
  replace(P" ", " "),
  replace(P"\\tol\\-er\\-ance ", "\\tolerance "),
  replace(P"\n{\\codefuzz = 1in\n" * P(-1), ""),
  replace(P"\n{\\hyphenchar\\tentt=-1 % needed to avoid weirdnesses\n" * P(-1), ""),
  replace(P"\n\\xrdef{\\not}\n" * search"\\egroup", ""),
  replace(P"|\\!||", "\\texttt{\\textbackslash\\bar}"),
  replace(P"|!||", "\\texttt{\\bar}"),  
  replace(P"!frii" - #Pletter, "⟨formula2⟩"),  
  replace(P"!fri" - #Pletter, "⟨formula1⟩"),  
  replace(surrounded("\\csdisplay\n", "\n|"), "\\begin{verbatim}\n%1\n\\end{verbatim}\n"),
  replace(cs"indexchar" * P(1), ""),  
  replace(cs"tminus", " - "),  
  replace(cs"tplus", " + "),  
  replace(P"^^" * (Pgroup + surrounded"|"), ""),
  replace(P"^" * Pgroup, "%1"),
  replace(P"^|" * C(gobble_until"|") * "|", "\\verb|%1|"),
  replace(P" "^0 * "(" * cs"xref" * (Pgroup + cs(R'Az'^1)) * ")", ""),
  replace(P" "^0 * "(see" * search(cs"xref", 1 - P")") * gobble_until")", ""),
  replace(cs"bix" + cs"eix", ""),
  replace(cs"char36", "$"),
  replace(P"\\" * surrounded("<", ">"), "\\texttt{%1}"), --"⟨%1⟩"),
  replace(surrounded"|" - B(Pletter + R'09'), "\\verb|%1|"),
  replace(B(Pletter) * "!-" * #Pletter, ""),
  --replace(P"\\cts" * Pletter^0 * surrounded" ", "\\item\\texttt{\\textbackslash %1}"),
}

-- Filter to apply after pandoc conversion
pandoc_filters = {
  replace(P" ", " "),
  replace(P"$" * C(R"09"^1) * "$", "%1"),
}

function apply_all(t, v)
  for _, f in ipairs(t) do
    v = f(v)
  end
  return v
end

commands, summaries, details = {}, {}, {}

ctspatt = Ct(
  (P"\\ctsx" * surrounded" ") 
  + (P"\\cts" * Pletter^0) * surrounded" " * Pgroup)

sigpatt = Cg(surrounded("\\rqbraces{\\<", ">}"), "meta")
  + Cg(cs"rqbraces" * Pgroup, "meta") * Cg(Cc(true), "req")
  + Cg(cs"param" * Pgroup, "param")
  + Cg(cs"tblentry" * Pgroup, "meta")
  + Cg(surrounded("\\<", ">"), "meta")
  + Cg(P"{\\bt" * P" "^0 * C(gobble_until"}") * "}", "literal")
  + Cg(C"=", "literal")
  + Cg(P"{\\tt.}" * lpeg.Cc".", "literal")
  + cs"vs" + cs"thinspace" + " " + "\n"

fix_meta ={
  replace("$_" * C(1) * "$", "%1"),
  replace("\\\\", "\\"),
  replace("word>" * P(1)^0, "words"),
}

--* Initilialize the commands table with signature info

for _, v in ipairs(items) do
  local v1 = apply_all(fix_meta, v[1])
  local cmds = Ct(search(ctspatt)^0):match(v1)
  for _, k in ipairs(cmds) do
    local cs = k[1]
    local sig = k[2]
    local cmd = {}
    commands[cs] = cmd
    if sig then
      local args = {}
      --          cmd.arguments = args
      local matches, en = (Ct(Ct(sigpatt)^0) * Cp()):match(sig)
      for _, arg in ipairs(matches) do
        if arg.meta then
          args[#args+1] = {meta=arg.meta}
        elseif arg.literal == "=" then
          args[#args+1] = {literal="=", optional =true}
        elseif arg.literal and args[#args] then
          if args[#args].delim then error"fix this"
          else args[#args].delimiters = {"", arg.literal} end
        elseif arg.literal then
        elseif arg.param then
          cmd.type = arg.param
        end
        if arg.req then
          args[#args].delimiters = {"{","}"}
        elseif arg.meta and not ((search"text" - P"parameter"
                                    + search"list" + search"material"
                                    + search"argument"):match(arg.meta))
        then
          args[#args].delimiters = false
        end
      end
      if #args > 0 then
        cmd.arguments = args
      end
    end
  end
end

commands.hbox = {
  arguments = {
    {meta="dimen", delimiters = {"to", ""}, optional=true},
    {meta="dimen", delimiters = {"spread", ""}, optional=true},
    {meta="horizontal mode material", delimiters = {"{","}"}}  
}}
commands.vbox = {
  arguments = {
    {meta="dimen", delimiters = {"to", ""}, optional=true},
    {meta="dimen", delimiters = {"spread", ""}, optional=true},
    {meta="vertical mode material", delimiters = {"{","}"}}  
}}
commands.vtop = {
  arguments = {
    {meta="dimen", delimiters = {"to", ""}, optional=true},
    {meta="dimen", delimiters = {"spread", ""}, optional=true},
    {meta="vertical mode material", delimiters = {"{","}"}}  
}}
commands.vrule = {
  arguments = {
    {meta="dimen", delimiters = {"width", ""}, optional=true},
    {meta="dimen", delimiters = {"height", ""}, optional=true},
    {meta="dimen", delimiters = {"depth", ""}, optional=true},
}}
commands.hrule = {
  arguments = {
    {meta="dimen", delimiters = {"width", ""}, optional=true},
    {meta="dimen", delimiters = {"height", ""}, optional=true},
    {meta="dimen", delimiters = {"depth", ""}, optional=true},
}}
commands.halign = {
  arguments = {
    {meta="dimen", delimiters = {"to", ""}, optional=true},
    {meta="dimen", delimiters = {"spread", ""}, optional=true},
    {meta="rows", delimiters = {"{","}"}}  
}}
commands.valign = {
  arguments = {
    {meta="dimen", delimiters = {"to", ""}, optional=true},
    {meta="dimen", delimiters = {"spread", ""}, optional=true},
    {meta="columns", delimiters = {"{","}"}}  
}}
commands.newif = {
  arguments = {meta="control sequence"}  
}
commands["+"] = {
  arguments = {meta = "rows", delimiters = {"", "\\cr"}}
}
commands.tabalign = {
  arguments = {meta = "rows", delimiters = {"", "\\cr"}}
}

for _, cs in ipairs{"def", "edef", "gdef", "xdef"} do
  commands[cs].action = "def"
  commands[cs].arguments[2].delimiters = {"", "{"}
  commands[cs].arguments[3].delimiters = {"", "}"}
end

--* Add "summary" entries

s = io.open(arg[1] .. "/teximpatient/capsule.tex"):read"all"
cappatt = Ct((P"\\capcs" * P"two"^-1) * surrounded" " * Pgroup * (Pgroup + C(1)))
capsule = Ct(search(cappatt)^0):match(s)
pandoccmd = "pandoc --verbose --wrap=none -f latex -t plain -o" .. tmpout .. " 2> " .. tmperr

for _, v in ipairs(capsule) do
  if not commands[v[1]] then
    --    print (v[1])
    commands[v[1]]={}
  end
  local w, err = convert(apply_all(filters, replace("\\\\", "\\")(v[2])))
  w = apply_all(pandoc_filters, w)
  w = w:sub(1,1):upper() .. w:sub(2,-2) .. "."
  local sym = search((P"letter " +P": ") * C(R("\194\244") * R("\128\191")^-3 - P"“" - P"”")):match(w)
  if sym then commands[v[1]].symbol = sym end
  commands[v[1]].summary = w
  if v[3] ~= "" then commands[v[1]].primitive = true end
end

commands.imath.symbol="𝚤"
commands.jmath.symbol="𝚥"
commands.i.symbol="ı"
commands.j.symbol="ȷ"

--* Add "details" entries and create excerpts from the book

excerpts = {}

pandoccmd = "pandoc --verbose -f latex -t markdown_strict+tex_math_dollars -o" .. tmpout .. " 2> " .. tmperr

local function format_args(args)
  if not args then return "" end
  local t = {}
  for i, arg in ipairs(args) do
    local l, r
    if arg.literal then
      if arg.literal:match"^%a" then l, r = " ", ""
      else l, r = "", "" end
    elseif arg.delimiters == false then
      l, r = "⟨", "⟩"
    elseif arg.delimiters then
      l, r = arg.delimiters[1] or "{", arg.delimiters[2] or "}"
      if l:match"^%a" then l=l.." " end
       if r:match"%a$" then r=" "..r end
    else
      l, r = "{⟨", "⟩}"
    end
    if (not arg.literal) and (l == "" or r == "") then
      l, r = l .."⟨", "⟩" .. r
    end
    t[#t+1] = (l or "") .. (arg.literal or arg.meta or "#" .. i) .. (r or "")
  end
  return " "..concat(t," ")
end

for _, v in ipairs(items) do
  local v2 = apply_all(filters, v[2])
  local v1 = apply_all(fix_meta, v[1])
  local cmds = Ct(search(ctspatt)^0):match(v1)
  local s,t = {}, {}
  for _, k in ipairs(cmds) do s[k[1]] = true end
  for k, _ in pairs(s) do t[#t+1] = "\\texttt{\\textbackslash "..k .. "}" .. (commands[k].symbol and " (".. commands[k].symbol..")" or "") end
  table.sort(t)
  if #t>1 then v2 = table.concat(t, ", ") .. "\n\n" .. v2 end
  local details, err = convert(v2)
  details = apply_all(pandoc_filters, details)
  if err then print(err) end
  local firstcmd = cmds[1] and cmds[1][1]
  if firstcmd then excerpts[firstcmd] = details end
--  print(details);print'---------------'
  for _, k in ipairs(cmds) do
    commands[k[1]].details = "$ref:teximpatient#/data/" .. firstcmd  end
end

--* Parse the book index

index = {}
for l in io.lines(arg[1] .. "/teximpatient/book.idx") do
  local k,v = l:match("(.-)::C::(%d+)P")
  if k then
    index[k] = v
  end
end

for cs, pg in pairs(index) do
  if commands[cs] then
    commands[cs].documentation = ("texmf:doc/plain/impatient/book.pdf#page=%d"):format(pg+18)
  end
end

--* Write data to files

-- Split primitives off of the commands table.
primitives = {}
for cs, cmd in pairs(commands) do
  --cmd.details = nil
  if cmd.primitive then
    primitives[cs] = cmd
    cmd.primitive = nil
    commands[cs] = nil
  end
end

comments = [[
Extracted from “TeX for the Impatient” by Paul W. Abrahams, Kathryn
A. Hargreaves, Karl Berry, and Daniel H. James

URL: https://www.gnu.org/software/teximpatient/
Original license: GNU FDL
]]
documentation = {
  {
    summary = "The TeXbook",
    uri = "https://www.ctan.org/pkg/texbook"
  },
  {
    summary = "TeX for the Impatient",
    uri = "texmf:doc/plain/impatient/book.pdf"
  }
}
  
f = io.open("plain.tags", "w")
f:write("comments = ", inspect(comments), "\n")
f:write("ctan_package = \"plain\"\n")
f:write("dependencies = {\"primitives\"}\n")
f:write("documentation = ", inspect(documentation), "\n")
f:write("commands = ", inspect(commands), "\n")

f = io.open("primitives.tags", "w")
f:write("comments = ", inspect(comments), "\n")
f:write("ctan_package = \"tex\"\n")
f:write("documentation = ", inspect(documentation), "\n")
f:write("commands = ", inspect(primitives), "\n")

f = io.open("teximpatient.tags", "w")
f:write("comments = ", inspect(comments), "\n")
f:write("data = ", inspect(excerpts), "\n")

os.remove(tmpout)
os.remove(tmperr)
