if not arg[1] then
   print("Usage: " .. arg[0] .. [[ PATH [--dump]

PATH should point to the root of the pgf source tree
With --dump, writes data to data/pgf-extracted.lua
]])
   return
end

require "luarocks.loader"
see = require "serpent".block

M = require "Manuscript"
dump = require "serpent".dump
latex = require "formats.latex"
rex = require "rex_pcre"
util = require "util"

callbacks, handlers = {}, {}
keys, commands, environments = {}, {}, {}
shapes, tikzlibs, pgflibs, decorations, pathops = {}, {}, {}, {}, {}

bad_command_names = {
-- from pgf
   anchor = {},
   state = {},
   value = {},
   arrow = {},
   jobname = {},
   rule = {},
   spy = {},
   symbol = {},
   method = {},
   attribute = {},
-- from tikz
    clip = {} --[[max]],
    coordinate = {} --[[max]],
    draw = {} --[[max]],
    fill = {} --[[max]],
    filldraw = {} --[[max]],
    graph = {} --[[max]],
    matrix = {} --[[max]],
    n = {} --[[max]],
    node = {} --[[max]],
    nodepart = {} --[[max]],
    p = {} --[[max]],
    path = {} --[[max]],
    pattern = {} --[[max]],
    pic = {} --[[max]],
    scoped = {} --[[max]],
    shade = {} --[[max]],
    shadedraw = {} --[[max]],
    x = {} --[[max]],
    y = {} --[[max]],
    scope = {} --[[max]],
    tikzfadingfrompicture = {} --[[max]],
    tikzpicture = {} --[[max]]
}

tikzcommands = {
    coordinate = {} --[[max]],
    graph = {} --[[max]],
    matrix = {} --[[max]],
    node = {} --[[max]],
    nodepart = {} --[[max]],
    pic = {} --[[max]],
    scoped = {} --[[max]],
}

tikzpathcommands = {
   path = {},
   clip = {} --[[max]],
   draw = {} --[[max]],
   fill = {} --[[max]],
   filldraw = {} --[[max]],
   path = {} --[[max]],
   pattern = {} --[[max]],
   shade = {} --[[max]],
   shadedraw = {} --[[max]],
   useasboundingbox = {},
}

tikzenvironments={
   scope = {} --[[max]],
   tikzfadingfrompicture = {} --[[max]],
   tikzpicture = {} --[[max]]
}

function M:man_section()
   return rex.match(self.filename, "pgfmanual-en-([a-z]*)")
end

arg_m = {{optional = false}}
arg_omm = {{delims = {"[", "]"}, optional=true},{optional = false},{optional = false}}

function next_sentence(m,r)
   local i = rex.find(m.src, [==[\v\s*[A-Z]]==], r.pos + r.len)
   local j = rex.find(m.src, [==[[.:]]==], i)
   local str = ""
   if i and j and i < j then
      str = rex.gsub(m:substring_stripped(i, j), [[[\v\s]+]], [[ ]])
   end
   return str
end

function latex.global_scan_callbacks.begin(m, thing)
   local args = m.commands[thing.cs].args
   local r = m:parse_cs_args(thing)
   local env = m:substring_stripped(r[1])
   if handlers[env] then handlers[env](m, r.pos + r.len) end
   return r.pos + r.len
end

function handlers.key(m, pos)
   local r = m.parser:parse_args(m.src, pos, arg_m)
   local text = m:substring_stripped(r[1])
   text = rex.gsub(text, [[[\v\s]+]], [[ ]])
   local path, name, _, args, detail = rex.match(text, [[^(.*)/(.*?)(=(.*?))?\s*(\(.*\))?$]])
   keydata = {doc = next_sentence(m,r), args = parse_args(m, args or "", {})}
   keys[path .. "/" .. name] = keydata
end

handlers.stylekey = handlers.key

function handlers.command(m, pos)
   local r = m.parser:parse_args(m.src, pos, arg_m)
   local text = m:substring_stripped(r[1])
   text = rex.gsub(text, [[[\v\s]+]], [[ ]])
   local name, args = rex.match(text, [[\\([A-Za-z@]*)(.*)]])
   --if not commands[m:man_section()] then commands[m:man_section()] = {} end
   --commands[m:man_section()][name] = {doc = next_sentence, args = parse_args(m, args or "", {})}
   commands[name] = {doc = next_sentence(m,r), args = parse_args(m, args or "", {})}
end

function handlers.environment(m, pos)
   local r = m.parser:parse_args(m.src, pos, arg_m)
   local text = m:substring_stripped(r[1])
   text = rex.gsub(text, [[[\v\s]+]], [[ ]])
   local name, args = rex.match(text, [[\{([A-Za-z@]*)\}(.*)]])
   environments[name] = {doc = next_sentence(m,r), args = parse_args(m, args or "", {})}
end

function handlers.shape(m,pos)
   local r = m.parser:parse_args(m.src, pos, arg_m)
   local text = m:substring_stripped(r[1])
   shapes[text] = {}
end

function handlers.tikzlibrary(m,pos)
   local r = m.parser:parse_args(m.src, pos, arg_m)
   local text = m:substring_stripped(r[1])
   tikzlibs[text] = {doc=next_sentence(m,r)}
end

function handlers.tabular(m,pos)
end

function handlers.pgflibrary(m,pos)
   local r = m.parser:parse_args(m.src, pos, arg_m)
   local text = m:substring_stripped(r[1])
   pgflibs[text] = {doc=next_sentence(m,r)}
end
function handlers.pathoperation(m,pos)
   local r = m.parser:parse_args(m.src, pos, arg_omm)
   local text = m:substring_stripped(r[2])
   pathops[text] = {doc=next_sentence(m,r),
                    args = parse_args(m, m:substring(r[3]) or "", {})}
end
function handlers.decoration(m,pos)
   local r = m.parser:parse_args(m.src, pos, arg_m)
   local text = m:substring_stripped(r[1])
   decorations[text] = {}
end

function parse_args(m, str, r)
   local original_str = str
   if str == "" or not str then return r end
   local arg --= {}
   -- str = rex.gsub(str, [==[\{\\char`\\\\]==], "\\")
   -- str = rex.gsub(str, [==[\{\\ttfamily\\char`\\\{\}]==], "")--"|{|")
   -- str = rex.gsub(str, [==[{\\ttfamily\\char`\\}}]==], "")--"|}|")
   local ll, rest = rex.match(str, [==[^\|(.*?)\|(.*)]==])
   if ll then str = rest end
   cmd_patt = m.parser.patt.skipped * m.parser.patt.cs * m.parser.patt.token_or_braced
   local cs, b, e = cmd_patt:match(str)
   local text = b and e and str:sub(b,e-1)
   if cs == "meta" then
      arg = {meta = text}
   elseif cs == "opt" then
      local l = parse_args(m, text, {})
      for _,a in pairs(l) do
         a.optional = true
         r[#r+1] = a
      end
   elseif cs == "oarg" then
      arg = {meta = text,
             optional = true,
             delims = {"[", "]"}}
   elseif cs == "marg" then
      arg = {meta = text,
             optional = false}
   elseif cs == "mchoice" then -- do this!
      arg = {meta = text,
             optional = false}
   elseif cs == "texttt" then
      arg = {literal = text,
             type = "literal"}
   else
      e = 1
   end

   str = str:sub(e + 1)
   
   local lr, cont = rex.match(str, [==[^\|(.*?)\|.*]==])
   if arg and ll and lr and lr ~= "(" and lr ~= "[" then
      arg.delims = {ll, lr}
      str = cont
   elseif ll and ll ~= " " then
      r[#r+1] = {type = "literal", literal = ll}
   end

   if arg then r[#r+1] = arg end

   return parse_args(m, str, r)
end
   
function printcmd(cs, cmd)
   local s = "\\" .. cs
   for i, arg in ipairs(cmd.args or {}) do
      s = s .. (arg.literal or
                   (util.safe_get(arg, "delims", 1) or "«")
                   .. (arg.literal or arg.meta or "#" .. i)
                   .. (util.safe_get(arg, "delims", 2) or "»"))
   end
   print(s)
end

function printcmds(t)
   for cs,cmd in pairs(t) do printcmd(cs,cmd)end
end

m = M{filename= arg[1] .. "doc/text-en/pgfmanual-en-main-body.tex"}

tikzkeys = util.update({}, keys)
for k, v in pairs(keys) do
   local name = rex.match(k, [[^/tikz/(.*)$]])
   if name then tikzkeys[name] = v end
end

pgfkeys = util.update({}, keys)
for k, v in pairs(keys) do
   local name = rex.match(k, [[^/pgf/(.*)$]])
   if name then pgfkeys[name] = v end
end

for c,_ in pairs(tikzcommands) do
   tikzcommands[c] = commands[c]
end
for c,_ in pairs(tikzenvironments) do
   tikzenvironments[c] = environments[c]
   environments[c] = nil
end
for c,_ in pairs(tikzpathcommands) do
   tikzcommands[c] = commands[c]
   tikzcommands[c].args = {{meta="specification", delims={"", ";"}, optional = false}}
   tikzcommands[c].action = "tikzpath"
end
for c,cmd in pairs(commands) do
   if c:find("tikz") then
      tikzcommands[c] = cmd
   end
   if tikzcommands[c] then commands[c] = nil end
end
for c, _ in pairs(bad_command_names) do
   commands[c] = nil
   environments[c] = nil
end

for _, c in pairs(util.update({}, commands, environments)) do
   for _, a in ipairs(c.args or {}) do
      if a.meta == "options" then
         a.keys = pgfkeys
      end
   end
end

for _, c in pairs(util.update({}, tikzcommands, tikzenvironments)) do
   for _, a in ipairs(c.args or {}) do
      if a.meta == "options" then
         a.keys = tikzkeys
      end
   end
end

commands.usepgflibrary.args[1].keys = pgflibs
tikzcommands.usetikzlibrary.args[1].keys = util.update(tikzlibs, pgflibs)

pgfoutput = {
   name = "pgf",
   commands = commands,
   environments = environments,
   keys = pgfkeys,
}

tikzoutput = {
   name = "tikz",
   commands = tikzcommands,
   environments = tikzenvironments,
   keys = tikzkeys,
}

function dump()
   f = io.open("data/pgf-extracted.lua", "w")
   print(f)
   f:write(dump(pgfoutput))
   f:close()
   f = io.open("data/tikz-extracted.lua", "w")
   f:write(dump(tikzoutput))
   f:close()
end

if arg[2] == "--dump" then dump() end

---- rg --no-filename --no-line-number ^.*\\begin\{([^\}]*).* -r $1
---- listing of most common environments in the pgfmanual
-- 2556 codeexample
-- 1192 key
-- 1063 tikzpicture
--  661 command
--  271 stylekey
--  181 enumerate
--  168 itemize
--   90 scope
--   71 math-function
--   67 pgfpicture
--   56 handler
--   52 quote
--   51 shape
--   37 tikzlibrary
--   37 tabular
--   37 pgflibrary
--   30 pathoperation
--   29 decoration
--   25 arrowexamples
--   21 document
--   17 math-operator
--   15 pictype
--   14 textoken
--   14 plainenvironment
--   14 environment
--   14 arrowtip
--   13 filedescription
--   13 contextenvironment
--   12 verbatim
--   12 math-keyword
--   11 coordinatesystem
--   10 pgfonlayer
--   10 description
--   10 arrowtipsimple
--    9 stylesheet
--    9 predefinednode
--    9 minipage
--    8 shading
--    8 pgflayout
--    8 package
--    8 graph
--    7 pgfmodule
--    7 internallist
--    7 colormixin
--    6 datavisualizationoperation
--    5 math-operators
--    5 keylist
--    5 arrowcapexamples
--    4 pgfdecoration
--    4 method
--    4 lstlisting
--    4 dataformat
--    4 arrowcap
--    3 smallmatrix
--    3 pgfscope
--    3 packageoption
--    2 tikzfadingfrompicture
--    2 quotation
--    2 predefinedmethod
--    2 pgflowlevelscope
--    2 ooclass
--    2 frame
--    2 align*
--    1 purepgflibrary
--    1 pgfmanualentry
--    1 pgfinterruptpicture
--    1 luanamespace
--    1 LPPLicense
--    1 gdalgorithm
--    1 figure

