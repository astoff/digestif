if not arg[1] then
   print("Usage: " .. arg[0] .. [[ PATH [--dump]

PATH should point to the base of the pgf distribution (so that PATH/text-en exists)
]])
   return
end

lpeg = require "lpeg"
lpeg.locale(lpeg)
P, V, R, S, B = lpeg.P, lpeg.V, lpeg.R, lpeg.S, lpeg.B
C, Cp, Cs, Cmt, Cf, Ct = lpeg.C, lpeg.Cp, lpeg.Cs, lpeg.Cmt, lpeg.Cf, lpeg.Ct
Cc, Cg = lpeg.Cc, lpeg.Cg

save_from_table = require"luarocks.persist".save_from_table
load_into_table = require"luarocks.persist".load_into_table

util = require "digestif.util"
lfs = require "lfs"
ser = require "serpent".block
dump = require "serpent".dump
see = require "see"
concat = table.concat
merge = util.merge
search, gobble_until, case_fold = util.search, util.gobble_until, util.case_fold
split, replace = util.split, util.replace
choice, sequence = util.choice, util.sequence
trim = util.trim()
blank = S" \t\n"
clean = util.clean(blank)

tmpout = os.tmpname()
tmperr = os.tmpname()

pandoc_cmd = "pandoc --reference-links --verbose -f latex -t plain+tex_math_dollars-raw_html+simple_tables+smart -o" .. tmpout .. " 2> " .. tmperr
preamble =[[
\def\meta#1{⟨#1⟩}
\def\cs#1{\\texttt{\\textbackslash #1}}
\def\marg#1{\texttt{\{#1\}}}
\def\oarg#1{\texttt{[#1]}}
\def\declare#1{#1}
\def\pageref#1{??}
\def\opt#1{#1}
\def\text#1{#1}
\def\mvar#1{#1}
\def\declareandlabel#1{\verb|#1|}
\def\example{}
\def\pgfname{PGF}
\def\pdf{PDF}
\def\makeatletter{}
\def\tikzname{TikZ}
\def\noindent{}
\def\medskip{}
\def\keyalias#1{}
\def\ref#1{??}

]]

function pandockify(s)
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

function deverbify(s)
  s = replace("\\", "\\textbackslash ")(s)
  s = replace("&", "\\& ")(s)
  s = replace("_", "\\_ ")(s)
  s = replace("#", "\\# ")(s)
  s = replace("{", "\\{")(s)
  s = replace("}", "\\}")(s)
  return "\\texttt{" .. s .. "}"
end

function pipe(val, funs)
  for i = 1, #funs do
    val = funs[i](val)
  end
  return val
end

function cs(s)
  return P("\\") * s * -Pletter * S(" \t")^0 * P"\n"^-1 * P(" ")^0 
end
function surrounded(l, r)
  if not r then r = l end
  return P(l) * C((1 - P(r))^0) * P(r)
end
Pletter = R'AZ' + R'az'
Pgroup = util.between_balanced("{", "}", "\\" * S"{}" + P(1))

-- read main parts of the book

interesting_envs = {"key", "command", "stylekey", "shape"}
Pinteresting_envs = choice(table.unpack(interesting_envs))
Pitem = Cp()*P"\\begin{" * C(Pinteresting_envs) * P"}" * Pgroup
Pitems = Ct(search(Ct(Pitem))^0)
skipping_examples = surrounded("\\begin{codeexample}", "\\end{codeexample}") + 1

Penv = util.between_balanced("\\begin{"*Pinteresting_envs*"}"*Pgroup/0, "\\end{"*Pinteresting_envs*"}")
Penvs = Ct(search(Ct(Penv))^0)

items = {}


for f in lfs.dir(arg[1] .. "text-en") do
  if f:match("%.tex$") then
    local s = io.open(arg[1] .. "/text-en/" .. f):read"all"
    for _, v in ipairs(Pitems:match(s)) do
      local pos, kind, signature = v[1], v[2], v[3]
      local text = Penv:match(s, pos)

      signature = pipe(signature, {
                         replace("%" * search"\n", ""),
                         replace("(" * (P"initially" + "default")
                                   * search(")" * blank^0 * P(-1)), ""),
                         clean})
      if not items[kind] then items[kind] = {} end

      text = replace(surrounded("|","|"), deverbify, skipping_examples)(text)
      text = replace(C(cs"tikz" * Pgroup), "[PICTURE]", skipping_examples)(text)
      text = replace(surrounded("\\tikz" * (1-Pletter), ";"), "[PICTURE]", skipping_examples)(text)
      text = replace("\\begin{codeexample}" * surrounded("[","]"), "\\begin{verbatim}")(text)
      text = replace("\\end{codeexample}", "\\end{verbatim}")(text)
      text = replace("\\" * C(P"begin" + "end") * "{" * Pinteresting_envs * "}", "\\%1{comment}")(text)
      -- local ntext, err = pandockify(text)
      -- --if not ntext then print(err) end
      -- if ntext and err then ntext = ntext .. "\n" .. err end
      items[kind][signature] = text
    end
  end
end

-- treat commands

commands = {}

Poarg = Cg(Cc(true), "optional") * Cg(Cc({"[","]"}),"delimiters")
Pparg = Cg(Cc({"(",")"}),"delimiters")

sigpatt = "\\"*C((R"AZ" + R"az" + '@')^1)*Ct(Ct(P" "^0 * choice(
  Cg(surrounded("\\opt{\\oarg{", "}}"), "meta") *Poarg,
  Cg(surrounded("{\\marg{", "}}"), "meta"),
  Cg(cs"oarg"*Pgroup, "meta") *Poarg,
  Cg("|(|"*cs"meta"*Pgroup*"|)|", "meta")*Pparg,
  Cg(surrounded("|", "|"), "literal"),
  Cg(C'=', "literal"),
  Cg(cs"marg"*Pgroup, "meta"),
  Cg(cs"meta"*Pgroup, "meta")))^0) 

for sig, text in pairs(items.command) do
  sig = pipe(sig, {replace("{\\ttfamily\\char`\\\\}", "|\\|"),
                   replace("{\\ttfamily\\char`\\}}", "|}|"),
                   replace("{\\ttfamily\\char`\\{}", "|{|"),
                   replace(cs"opt"*Pgroup, "%1"),
                   replace("\\\\",""),
                   replace("{}","")
  })
  local csname, args = sigpatt:match(sig)
  commands[csname] = {}
  if args and #args>0 then commands[csname].arguments = args end
  commands[csname].documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf." .. csname
  commands[csname].details = pandockify(text)
end

-- treat keys

items.key = merge(items.stylekey, items.key)

keypatt = (C(gobble_until(P"=" + P' '^1 * "("))
             * ('=' * C(P(1)^0))^-1 + Cc(nil))

keys = {}

for sig, text in pairs(items.key) do
  sig = pipe(sig, {replace(cs'space', ' '),
                   replace(cs'\\', ' '),
                   replace(cs'textbackslash', '\\'),
                   replace(cs'tikzname\\', 'tikz'),
                   replace("\\char`\\}", "|}|"),
                   replace("\\char`\\{", "|{|"),
                   replace(cs"opt"*Pgroup, "%1"), replace(cs"opt"*Pgroup, "%1"),
                   replace(cs"texttt"*Pgroup, "%1"),
                   replace(cs"ttfamily", ""),
                   replace(cs"marg"*Pgroup, "{%1}"),
                   replace(cs"meta"*Pgroup, "⟨%1⟩"),
                   replace(cs"mchoice"*Pgroup, "⟨%1⟩"),
                   replace(surrounded("|", "|"), "%1"),
                   replace("{}", ""),
                   clean, trim})
  local key, val = keypatt:match(sig)
  local res = {}
  if val then res.meta = val end
  res.documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf." .. key:gsub(" ", ":")
  res.details = pandockify(text)
  keys[key] = res
end

comments = [[
Extracted from the PGF manual version 3.1.9a
URL: https://github.com/pgf-tikz/pgf/
Original license: GNU FDL v1.2+ or LPPL 1.3+
]]

tikz = {comments = comments,
        package = {
          name = "tikz",
          documentation = "texdoc:generic/pgf/pgfmanual.pdf"
        },
        commands = {},
        keys = {tikz ={}, ['data visualization'] ={}, ['graphs'] = {}}
}
pgf = {comments = comments,
       package = {
         name = "pgf",
         documentation = "generic/pgf/pgfmanual.pdf"
       },
       commands = {},
       keys = {pgf ={}}
}

for k,v in pairs(keys) do
  if k:match'^/tikz/data visualization' then
    tikz.keys['data visualization'][k:gsub('^/tikz/data visualization/', '')] = v
    keys[k]=nil
  elseif k:match'^/tikz/graphs' then
    tikz.keys['graphs'][k:gsub('^/tikz/graphs/','')] = v
    keys[k]=nil
  elseif k:match'^/tikz' then
    tikz.keys['tikz'][k:gsub('/tikz/','')] = v
    keys[k]=nil
  elseif k:match'^/pgf' then
    pgf.keys.pgf[k:gsub('/pgf/','')] = v
    keys[k] = nil
  else
    -- print(k)
  end
end

tikzpathcommands = {
  "coordinate",
  "graph",
  "matrix",
  "node",
  "nodepart",
  "pic",
  "path",
  "clip",
  "draw",
  "graph",
  "datavisualization",
  "fill",
  "filldraw",
  "path",
  "pattern",
  "shade",
  "shadedraw",
  "useasboundingbox",
}

commands.path.arguments = {
  {meta="specification", delimiters = {"",";"}}
}
for _, k in ipairs(tikzpathcommands) do
  commands[k].arguments = merge(commands.path.arguments)
  commands[k].action = 'tikzpath'
end

for cs, v in pairs(commands) do
  if cs:match'pgf' then
    pgf.commands[cs] = v
    for _, v in ipairs(v.arguments or {}) do
      if v.meta == "options" then v.keys = "$ref:pgf#/keys/pgf" end
    end
  else
    tikz.commands[cs] = v
    for _, v in ipairs(v.arguments or {}) do
      if v.meta == "options" then v.keys = "$ref:tikz#/keys/tikz" end
    end
  end
end

save_from_table('tikz.lua', tikz, {"comments", "package"})
save_from_table('pgf.lua', pgf, {"comments", "package"})
