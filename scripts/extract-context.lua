require "luarocks.loader"
xml = require "pl.xml"
ser = require"serpent".block
util = require"digestif.util"

if not arg[1] then
   print("Usage: " .. arg[0] .. [[ PATH

PATH should point to file context-en.xml of the ConTeXt distribution
]])
   return
end

BRACES = "$DIGESTIFDATA/context/data/braces"
BRACKETS = "$DIGESTIFDATA/context/data/brackets"
PARENTHESIS = "$DIGESTIFDATA/context/data/parenthesis"
delim_table = {
  braces = {"{","}"},
  brackets = {"[","]"},
  parenthesis = {"(",")"}
}

-- BRACES = {"{","}"}
-- BRACKETS = {"[","]"}
-- PARENTHESIS = {"(",")"}


data = xml.parse(arg[1], true)

function collect_tag_attributes(tag)
  attribs = {}
  for _, dt in ipairs(data:get_elements_with_name(tag)) do
    local attrs = dt:get_attribs()
    for _, a in ipairs(attrs) do
      if not attribs[a] then attribs[a] = {} end
      attribs[a][attrs[a]] = true
    end
  end
  return attribs
end
--print(ser(tag_attributes("cd:keywords")))

categories = {}
levels = {}
types = {}
inheritances = {}
inherit_type = {}
inherit_order = {}

function compute_meta(node)
  local fromtag = node.tag:gsub('^cd:', '')
  local tbl = {}
  local other = 0
  for node in node:childtags() do
    local attribs = node:get_attribs()
    local val = attribs.type
    if val and val:match"^cd:" then
      tbl[#tbl+1]=val:sub(4)
    else
      other = other + 1
    end
  end
  if other == 0 and #tbl == 1 then
    return tbl[1]
  else
--    print(ser(tbl), fromtag)
    return fromtag
  end
end

function compute_values(node)
  local tbl = {}
  for node in node:childtags() do
    if node.tag == "cd:constant" then
      local val = node:get_attribs().type
      if not val:match"^cd:" then tbl[#tbl+1] = val end
    elseif node.tag == "cd:inherit" then
      local val = node:get_attribs().name
      if not inheritances[tbl] then inheritances[tbl] = {} end
      local inh = inheritances[tbl]
      inherit_type[tbl]="values"
      inherit_order[#inherit_order+1] = tbl
      inh[#inh+1] = val
    end
  end
  return #tbl > 0 and tbl or nil
end

function compute_keys(node)
  local tbl = {}
  for node in node:childtags() do
    if node.tag == "cd:parameter" then
      local val = node:get_attribs().name
      tbl[val] = {
        values = compute_values(node),
        meta = compute_meta(node)
      }
    elseif node.tag == "cd:inherit" then
      local val = node:get_attribs().name
      if not inheritances[tbl] then inheritances[tbl] = {} end
      local inh = inheritances[tbl]
      inherit_type[tbl] = "keys"
      inherit_order[#inherit_order+1] = tbl
      inh[#inh+1] = val
    end
  end
  return tbl
end

function compute_argument(node)
  local ret = {delimiters=BRACKETS}
  local attrs = node:get_attribs()
  if attrs.delimiters == 'braces' then ret.delimiters = BRACES end
  if attrs.delimiters == 'parenthesis' then ret.delimiters = PARENTHESIS end
  if attrs.delimiters == 'none' then ret.delimiters = false end
  if attrs.optional == 'yes' then ret.optional = true end
  if attrs.list == 'yes' then ret.list = true end
  if node.tag == "cd:keywords" then
    ret.meta=compute_meta(node)
    ret.values = compute_values(node)
  elseif node.tag == "cd:assignments" then
    ret.meta="assignments"
    ret.keys = compute_keys(node)
  elseif node.tag == "cd:constant" then
    ret.meta = data:get_attribs().type:gsub('^cd:', '')
  elseif node.tag == "cd:content" then
    ret.meta="content"
  elseif node.tag == "cd:csname" then
    ret.meta="command"
    ret.type="cs"
  elseif node.tag == "cd:dimension" then
    ret.meta = "dimension"
    ret.type="dimen"
  end
  return ret
end

function compute_arguments(node)
  tbl = {}
  for node in node:childtags() do
    tbl[#tbl+1] = compute_argument(node)
  end
  return tbl
end

function compute_instances(name, node)
  tbl = {}
  if node == nil then return tbl end
  for instance in node:childtags() do
    inst_name = instance:get_attribs().value
    if name ~= inst_name then
      tbl[#tbl+1] = inst_name
    end
  end
  return tbl
end

command_list = {}
for _, node in ipairs(data:get_elements_with_name("cd:command")) do
  local attribs = node:get_attribs()
  local arguments = node:child_with_name("cd:arguments")
  arguments = arguments and compute_arguments(arguments)
  local cmd = {
    cs = attribs.name,
    environment = (attribs.type == "environment"),
    --source = attribs.file,
    --category = attribs.category,
    arguments = arguments,
  }
  if cmd.cs == "section" then
    cmd.section_level = 3
  end
  command_list[#command_list+1] = cmd

  local instances = compute_instances(attribs.name, node:child_with_name("cd:instances"))
  local level = nil -- make sure it’s reset first
  for _, name in ipairs(instances) do
    if cmd.cs ~= "section" then
      -- link possible due to no section_level
      local what = cmd.environment and "environments" or "commands"
      command_list[#command_list+1] = {
        cs = name,
        link = "$DIGESTIFDATA/context/" .. what .. "/" .. cmd.cs,
      }
    else
      -- instances of section are listed first by
      -- unnumbered/numbered, then section order
      -- the numbered “part” has no unnumbered equivalent
      -- section is the base cmd, so skipped in `instances`
      if name == "part" then level = 1 end
      if name == "title" then level = 2 end
      if name == "subsection" then level = 4 end
      local inst = { action = "section" }
      for k, v in pairs(cmd) do inst[k] = v end
      inst.cs = name
      inst.section_level = level
      --print(name, level)
      level = level + 1
      command_list[#command_list+1] = inst
    end
  end
end

-- FIXME: need to distinguish when doing
cmds_and_envs = {}
for _, cmd in ipairs(command_list) do
  local cs = cmd.cs
  if cmd.link or not cmds_and_envs[cs] then
    cmds_and_envs[cs] = cmd
  end
end

for _, tbl in ipairs(inherit_order) do
  local inh = inheritances[tbl]
  --print("\n\nbefore", ser(tbl))
  for _, cs in ipairs(inh) do
    for _, arg in ipairs((cmds_and_envs[cs] or {}).arguments or {}) do
      util.update(tbl, arg[inherit_type[tbl]] or {})
    end
  end
  --print("\nafter", ser(tbl))
end

commands = {}
environments = {}

for _, cmd in ipairs(command_list) do
  local cs = cmd.cs
  local list = cmd.environment and environments or commands
  cmd.environment = nil
  cmd.cs = nil
  if not list[cs] then
    list[cs] = cmd.link and cmd.link or cmd
    if cmd.section_level then
      --print(cs, cmd.section_level)
    end
  end
end

for cs, action in pairs {
  usebtxdataset = "input",
  cite = "cite",
  nocite = "cite",
  citation = "cite",
  nocitation = "cite",
  pagereference = "label",
  textreference = "label",
  ["in"] = "ref",
  at = "ref",
  about = "ref"
} do
  commands[cs].action = action
end

save_from_table = require"luarocks.persist".save_from_table

save_from_table(
  'context.tags',
  {
    comments = [[
Extracted from ConTeXt source code (context-en.xml)
URL: https://www.contextgarden.net/
Original license: GNU GPLv2
]],
   package = {
     name = "context",
     documentation = "texdoc:context/sources/general/manuals/start/en/ma-cb-en.pdf"
   },
   commands = commands,
   environments = environments,
   data = delim_table
  },
  {"comments", "package", "data"})
