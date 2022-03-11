-- This script extracts tags files from package manuals using the
-- lxtdockit class, namely biblatex, etoolbox and csquotes.
if not arg[1] then
   print("Usage: " .. arg[0] .. [[ FILE

FILE should be {biblatex,etoolbox,csquotes}.tex

Output is to a corresponding .sty.tags file.
]])
   return
end

local package = arg[1]:sub(1,-5)..".sty"

local lpeg = require "lpeg"
lpeg.locale(lpeg)
local P, V, R, S, B = lpeg.P, lpeg.V, lpeg.R, lpeg.S, lpeg.B
local C, Cp, Cs, Cmt, Cf, Ct = lpeg.C, lpeg.Cp, lpeg.Cs, lpeg.Cmt, lpeg.Cf, lpeg.Ct
local Cc, Cg = lpeg.Cc, lpeg.Cg

local util = require "digestif.util"
local lfs = require "lfs"
local concat = table.concat
local merge = util.merge
local search, gobble, case_fold = util.search, util.gobble, util.case_fold
local split, replace = util.split, util.replace
local choice, sequence = util.choice, util.sequence
local trim = util.trim()
local blank = S" \t\n"
local clean = util.clean(blank)
local inspect = util.inspect
local format = string.format
local tmpout = os.tmpname()
local tmperr = os.tmpname()

local pandoc_cmd = "pandoc --reference-links --verbose -f latex -t markdown_strict+tex_math_dollars-raw_html+simple_tables+smart -o " .. tmpout .. " 2> " .. tmperr
local preamble =[[
\def\secref#1{??}
\def\tabref#1{??}
\def\pageref#1{??}
\def\ie{i.e. }
\def\eg{e.g. }
\def\cmd#1{\texttt{\textbackslash #1}}
\def\cs#1{\texttt{\textbackslash #1}}
\def\keyval{\texttt{key=value}}
\def\kvopt#1#2{\texttt{#1=#2}}
\let\env\texttt
\let\opt\texttt
\let\prm\texttt
\let\refsection\texttt
\let\bibfield\texttt
\let\file\texttt
\let\path\texttt
\let\sty\texttt
\let\bibtype\texttt
\let\len\texttt
\let\cnt\texttt
\def\acr#1{#1}
\def\latex{LaTeX }
\def\LaTeXe{LaTeX2ɛ }
\def\tex{TeX }
\def\xetex{XeTeX }
\def\etex{e-TeX }
\def\pdf{PDF }
\def\utf{UTF-8 }
\def\bibtex{BibTeX }
\def\biblatex{\texttt{biblatex}}
\def\biber{\texttt{biber}}
\def\fnurl#1{\url{#1}}

\newenvironment{optionlist}[1][]{\begin{description}}{\end{description}}
\newenvironment{valuelist}{\begin{description}}{\end{description}}
\newenvironment{argumentlist}[1]{\begin{description}}{\end{description}}
\newenvironment{ltxsyntax}{}{}

\newcommand{\valitem}[3][]{\item[\texttt{#2=<#3>}]}
\newcommand{\choitem}[3][]{\item[\texttt{#2=\{#3\}}]}
\newcommand{\boolitem}[2][]{\item[\texttt{#2}]}
\newcommand{\intitem}[2][]{\item[\texttt{#2}]}
]]

local function pandockify(s)
  s = replace("\\" * C(P"begin" + "end") * "{ltxexample}", "\\%1{verbatim}")(s)
  s = replace("\\" * C(P"begin" + "end") * "{ltxcode}", "\\%1{verbatim}")(s)
  s = replace("\\" * C(P"begin" + "end") * "{optionlist*}", "\\%1{optionlist}")(s)
  s = replace("\"=", "-")(s)
  s = replace(" |" * C(gobble("|", 1 - S" \n")), " \\verb|%1")(s)
  s = replace("|#1|", "\\texttt{\\#1}")(s)
  local pd = io.popen(pandoc_cmd, "w")
  pd:write(preamble)
  pd:write(s)
  local exit = pd:close()
  local ef = io.open(tmperr)
  local err = ef:read"all"
--  if err ~= "" then print(err) end
  ef:close()
  return exit and io.open(tmpout):read"all", (err ~= "") and err
end
 
local function deverbify(s)
  s = replace("\\", "\\textbackslash ")(s)
  s = replace("&", "\\& ")(s)
  s = replace("_", "\\_ ")(s)
  s = replace("#", "\\# ")(s)
  s = replace("{", "\\{")(s)
  s = replace("}", "\\}")(s)
  return "\\texttt{" .. s .. "}"
end

local function pipe(val, funs)
  for i = 1, #funs do
    val = funs[i](val)
  end
  return val
end

local Pletter = R'AZ' + R'az'
local function cs(s)
  return P("\\") * s * -Pletter * S(" \t")^0 * P"\n"^-1 * P(" ")^0
end
local function surrounded(l, r)
  if not r then r = l end
  return P(l) * C((1 - P(r))^0) * P(r)
end
local Pgroup = util.between_balanced("{", "}", "\\" * S"{}" + P(1))
local Pbol = choice(B"\n", -B(1))

-- read main parts of the book

local function clean_args(s)
  s = replace("\\DeprecatedMark", "")(s)
  s = replace("\\CSdelimMark", "")(s)
  s = replace("\\dots", "... ")(s)
  s = replace("\\ensuremath", "")(s)
  s = replace("\\" * S"lr" * "angle" * P" "^0, "")(s)
  s = replace("$", "")(s)
  s = replace("|\\{*\\}|", "{*}")(s)
  s = replace("|{\\ltxsyntaxlabelfont\\cmd{bibcloseparen}}|", "\\bibcloseparen")(s)
  return s
end


local interesting_cmds = {
  "cmditem", --[["valitem", "optitem", "boolitem", "intitem", "reqitem", "typeitem",
    "listitem", "fielditem", ]] "lenitem", "cntitem", "csitem", "envitem"
}
local Pinteresting_cmds = choice(table.unpack(interesting_cmds))
local Pitem = sequence(
  Ct(sequence(
       P"\n\\",
       Cg(C(Pinteresting_cmds), "type") * #(1 - Pletter) * P"*"^-1,
       Cg(Pgroup, "cmd"),
       Cg(C(gobble"\n"), "args")
  ))^1,
  Cg(
    C(gobble(B"\n" * "\\" * ("end{ltxsyntax}" + Pinteresting_cmds))),
    "text"
  )
)
-- Pbegin = P"\n\\begin{ltxsyntax}"
-- Pend = P"\n\\begin{ltxsyntax}"
-- Pcmd = Ct(
--   sequence(
--     P"\n\\",
--     C(Pinteresting_cmds) * #(1 - Pletter) * P"*"^-1,
--     Pgroup,
--     C(gobble"\n")
-- ))
-- Pitem = C(Pbegin * (search(Pcmd, 1 - Pend)^1) * search(Pend))

local Pitems = Ct(search(Ct(Pitem))^0)

local Pargs = Ct(
  choice(
    P"*" * Cc{literal = "*", optional=true},
    Ct(Cg(Pgroup, "meta")),
    Ct(Cg("[" * C(gobble"]") *"]", "meta")
       * Cg(Cc(true), "optional")
       * Cg(Cc({"[","]"}), "delimiters"))
  )^1
)

local cmditems = {}
local envitems = {}

local s = io.open(arg[1]):read"all"
for _, v in ipairs(Pitems:match(s)) do
  local t
  if v[1].type == "envitem" then
    t = envitems
  else
    t = cmditems
  end
  local details = {"```latex"}
  for i = 1, #v do
    local cmd, args = v[i].cmd, v[i].args
    local deprecated = args:match("\\DeprecatedMark")
    args = clean_args(args)
    if cmd:sub(-1) == "*" then
      cmd = cmd:sub(1,-2)
      v[i].cmd = cmd
      args = "*" .. args
    end
    local arguments = Pargs:match(args)
    if not t[cmd] then
      t[cmd] = {
        deprecated = deprecated and true or nil,
        arguments = arguments
      }
    elseif not t[cmd].arguments or #t[cmd].arguments < #arguments then
      t[cmd].arguments = arguments
    end
    if t == cmditems then
      details[#details+1] = "\\" .. cmd .. args
    else
      details[#details+1] = format("\\begin{%s}%s ... \\end{%s}", cmd, args, cmd)
    end
  end
  details[#details+1] = "```\n"
  local doc, err = pandockify(v.text)
  details[#details+1] = doc
  details = table.concat(details, "\n")
  for i = 1, #v do
    if t[v[i].cmd].details == nil then
      t[v[i].cmd].details = details
    elseif t[v[i].cmd].details ~= details then
      t[v[i].cmd].details = t[v[i].cmd].details .. "\n" .. details
    end
  end
  if err then
    print("\n-----------------\n")
    -- print(details)
    print(v[1].cmd)
    print(err)
  end
end

-- Discard weird stuff
for cmd in pairs(cmditems) do
  if cmd:match("%$") then
    print("discaring command " .. cmd)
    cmditems[cmd] = nil
  end
end

-- Create details refs for duplicated text
local cmd_list = {}
for cmd in pairs(cmditems) do cmd_list[#cmd_list+1] = cmd end
table.sort(cmd_list)
local detail_refs = {}
for _, cmd in ipairs(cmd_list) do
  local item = cmditems[cmd]
  if not item.details then
    print("no details: " .. cmd)
  elseif detail_refs[item.details] then
    item.details = detail_refs[item.details]
    print("using details ref: " .. cmd .. " -> " .. item.details)
  else
    local ref = format("$ref:%s#/commands/%s/details", package, cmd)
    detail_refs[item.details] = ref
  end
end

for cmd, action in pairs{
  addbibresource= "input",
  addglobalbib="input",
  addsectionbib="input",
  bibliography="input",
  Autocite = "cite",
  Autocites = "cite",
  Avolcite = "cite",
  Avolcites = "cite",
  Cite = "cite",
  Citeauthor = "cite",
  Cites = "cite",
  Fvolcites = "cite",
  Notecite = "cite",
  Parencite = "cite",
  Parencites = "cite",
  Pnotecite = "cite",
  Pvolcite = "cite",
  Pvolcites = "cite",
  Smartcite = "cite",
  Smartcites = "cite",
  Svolcite = "cite",
  Svolcites = "cite",
  Textcite = "cite",
  Textcites = "cite",
  Tvolcite = "cite",
  Tvolcites = "cite",
  Volcite = "cite",
  Volcites = "cite",
  autocite = "cite",
  cite = "cite",
  citeauthor = "cite",
  citecount = "cite",
  citecounter = "cite",
  citedate = "cite",
  citefield = "cite",
  citename = "cite",
  cites = "cites",
  citetitle = "cite",
  citeyear = "cite",
  footcitetext = "cite",
  footcitetexts = "cite",
  footfullcite = "cite",
  ftvolcite = "cite",
  nocite = "cite",
  parencite = "cite",
  textcite = "cite"
} do
  if cmditems[cmd] then
    cmditems[cmd].action = action
  else
    print("missing command: " .. cmd)
  end
end

for _, item in pairs(cmditems) do
  if item.action == "input" then
    item.filename = "?"
  end
end

local ctan_package = package:sub(1,-5)
local comments = format(
  [[
Extracted from %s.tex
URL: https://ctan.org/tex-archive/macros/latex/contrib/%s
Original license: LPPL v1.3 or later
]],
ctan_package,
ctan_package
)

local comments = format(
  [[
Extracted from the documentation source (%s.tex)
URL: https://ctan.org/tex-archive/macros/latex/contrib/%s
Original license: LPPL v1.3 or later
]],
package:sub(1,-5),
package:sub(1,-5)
)

documentation = {
  etoolbox = {
    {
      summary = "Package documentation",
      uri = "texmf:doc/latex/etoolbox/etoolbox.pdf"
    }
  },
  csquotes = {
    {
      summary = "Tutorial on use of the package",
      uri = "texmf:doc/latex/csquotes/csquotes.pdf"
    }
  },
  biblatex = {
    {
      summary = "Package documentation (English)",
      uri = "texmf:doc/latex/biblatex/biblatex.pdf"
    }
  }
}

local f = io.open(package .. ".tags", "w")
f:write("comments = ", inspect(comments), "\n")
f:write("ctan_package = ", inspect(ctan_package), "\n")
f:write("documentation = ", inspect(documentation[ctan_package]), "\n")
if options and next(options) then
  f:write("options = ", inspect(options), "\n")
end
f:write("commands = ", inspect(cmditems), "\n")
if envitems and next(envitems) then
  f:write("environments = ", inspect(envitems), "\n")
end
