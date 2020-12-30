local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local Parser = require "digestif.Parser"

local co_wrap, co_yield = coroutine.wrap, coroutine.yield
local merge = util.merge
local path_join, path_split = util.path_join, util.path_split
local format_filename_template = util.format_filename_template
local table_move, table_insert = table.move, table.insert

--* Parsing ConTeXt interface files

--** XML parser by Roberto Ierusalimschy
--
-- Cf. http://lua-users.org/wiki/LuaXml

local function parseargs(s)
  local arg = {}
  string.gsub(s, "([%w:_-]+)=([\"'])(.-)%2", function (w, _, a)
    arg[w] = a
  end)
  return arg
end

local function collect(s)
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=parseargs(xarg)}
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[#stack].label)
  end
  return stack[1]
end

local function child_with_label(node, label)
  for _, n in ipairs(node) do
    if n.label == label then return n end
  end
end

local function children_with_label(node, label)
  local function iter(n, l)
    if n.label == l then
      co_yield(n)
    else
      for _, m in ipairs(n) do
        iter(m, l)
      end
    end
  end
  return co_wrap(function() return iter(node, label) end)
end

--** Parse ConTeXt interface (XML) files

local braces = {"{", "}"}
local brackets = {"[", "]"}
local parenthesis = {"(", ")"}

local function gen_tags(data)

  local inheritances = {}
  local inherit_type = {}
  local inherit_order = {}

  local function compute_meta(node)
    local fromtag = node.label:gsub('^cd:', '')
    local tbl = {}
    local other = 0
    for _, child in ipairs(node) do
      local attribs = child.xarg
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
      return fromtag
    end
  end

  local function compute_values(node)
    local tbl = {}
    for _, child in ipairs(node) do
      if child.label == "cd:constant" then
        local val = child.xarg.type
        if not val:match"^cd:" then tbl[#tbl+1] = val end
      elseif child.label == "cd:inherit" then
        local val = child.xarg.name
        if not inheritances[tbl] then inheritances[tbl] = {} end
        local inh = inheritances[tbl]
        inherit_type[tbl] = "values"
        inherit_order[#inherit_order+1] = tbl
        inh[#inh+1] = val
      end
    end
    return #tbl > 0 and tbl or nil
  end

  local function compute_keys(node)
    local tbl = {}
    for _, child in ipairs(node) do
      if child.label == "cd:parameter" then
        local val = child.xarg.name
        tbl[val] = {
          values = compute_values(child),
          meta = compute_meta(child)
        }
      elseif child.label == "cd:inherit" then
        local val = child.xarg.name
        if not inheritances[tbl] then inheritances[tbl] = {} end
        local inh = inheritances[tbl]
        inherit_type[tbl] = "keys"
        inherit_order[#inherit_order+1] = tbl
        inh[#inh+1] = val
      end
    end
    return tbl
  end

  local function compute_argument(node)
    local ret = {delimiters=brackets}
    local attrs = node.xarg
    if attrs.optional == 'yes' then ret.optional = true end
    if attrs.list == 'yes' then ret.list = true end
    if node.label == "cd:keywords" then
      ret.meta=compute_meta(node)
      ret.values = compute_values(node)
    elseif node.label == "cd:assignments" then
      ret.meta="assignments"
      ret.keys = compute_keys(node)
    elseif node.label == "cd:constant" then
      ret.meta = node.xarg.type:gsub('^cd:', '')
    elseif node.label == "cd:content" then
      ret.meta="content"
      ret.delimiters = braces
    elseif node.label == "cd:csname" then
      ret.meta="command"
      ret.type="cs"
      ret.delimiters = nil
    elseif node.label == "cd:dimension" then
      ret.meta = "dimension"
      ret.type="dimen"
    end
    if attrs.delimiters == 'braces' then ret.delimiters = braces end
    if attrs.delimiters == 'parenthesis' then ret.delimiters = parenthesis end
    if attrs.delimiters == 'none' then ret.delimiters = false end
    return ret
  end

  local function compute_arguments(node)
    local tbl = {}
    for _, child in ipairs(node) do
      tbl[#tbl+1] = compute_argument(child)
    end
    return tbl
  end

  local function compute_instances(name, node)
    local tbl = {}
    if node == nil then return tbl end
    for _, instance in ipairs(node) do
      local inst_name = instance.xarg.value
      if name ~= inst_name then
        tbl[#tbl+1] = inst_name
      end
    end
    return tbl
  end

  local command_list = {}
  for node in children_with_label(data, "cd:command") do
    local attribs = node.xarg
    local arguments = child_with_label(node, "cd:arguments")
    arguments = arguments and compute_arguments(arguments)
    local cmd = {
      cs = attribs.name,
      environment = (attribs.type == "environment"),
      --source = attribs.file,
      --category = attribs.category,
      arguments = arguments,
    }
    command_list[#command_list+1] = cmd

    local instances = compute_instances(
      attribs.name, child_with_label(node, "cd:instances"))
    for _, name in ipairs(instances) do
      command_list[#command_list+1] = merge(cmd, {cs = name})
    end
  end

  -- FIXME: need to distinguish when doing
  local cmds_and_envs = {}
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

  local tags = {
    generated = true,
    commands = {},
    environments = {}

  }

  -- Don't literally set cmd.package = tags below so that tags remains
  -- serializable.
  local link_to_root = {__index = {package = tags}}

  for _, cmd in ipairs(command_list) do
    local cs = cmd.cs
    local list = cmd.environment and tags.environments or tags.commands
    local wikiname = cmd.environment and "start" .. cs or cs
    cmd.documentation = {
      [1] = {
        summary = "“" .. wikiname .. "” on ConTeXt Garden",
        uri = "https://wiki.contextgarden.net/Command/" .. wikiname
      }
    }
    cmd.environment, cmd.cs = nil, nil
    setmetatable(cmd, link_to_root)
    if not list[cs] then
      list[cs] = cmd
    else
      local variants = list[cs].variants
      if not variants then
        variants = {}
        list[cs].variants = variants
      end
      variants[#variants+1] = cmd
    end
  end

  return tags
end

-- Generate tags from a ConTeXt interface (XML) file.
--
-- Arguments:
--   file: The file name.
--   pkg: An optional package description table.
--
-- Returns:
--   The tags, or nil if file does not exist.
--
local function tags_from_xml(file, pkg)
  local ok, str = util.find_file(file, nil, true)
  if not ok then return end
  local ok, data = pcall(collect, str)
  if not ok then return end
  return setmetatable(gen_tags(data), {__index = pkg})
end

-- Monkey-patch to isolate XML dependency in this file.
(require "digestif.data").tags_from_xml = tags_from_xml

--** Core ConTeXt tags

local ctx_tags = (require "digestif.data".require_tags)("context-en.xml")

if ctx_tags then

  ctx_tags.ctan_package = "context"

  ctx_tags.documentation = {
    [1] = {
      summary = "ConTeXt Mark IV: an excursion",
      uri = "texdoc:context/documents/general/manuals/ma-cb-en.pdf"
    },
    [2] = {
      summary = "ConTeXt documentation library",
      uri = "https://wiki.contextgarden.net/Documentation"
    }
  }

  local commands = ctx_tags.commands
  local environments = ctx_tags.environments

  -- Add details to sectioning commands
  for _, tbl in ipairs{commands, environments} do
    for i, cs in ipairs{
      "part", "chapter", "section", "subsection", "subsubsection",
      "subsubsubsection", "subsubsubsubsection"
    } do
      tbl[cs].section_level = i
      tbl[cs].action = "section"
    end
    for i, cs in ipairs{
      "title", "subject", "subsubject", "subsubsubject",
      "subsubsubsubject", "subsubsubsubsubject"
    } do
      tbl[cs].section_level = i + 1
      tbl[cs].action = "section"
    end
  end

  -- Add details to file-inputting commands.
  for cs, filename in pairs {
    environment = "?.tex",
    project = "?.tex",
    component = "?.tex",
    usemodule = "t-?.xml"
  } do
    if commands[cs] then
      commands[cs].action = "input"
      commands[cs].filename = filename
    end
  end

  -- Add details to assorted commands.
  for cs, action in pairs {
    usebtxdataset = "input",
    cite = "cite",
    nocite = "cite",
    define = "define",
    definestartstop = "definestartstop",
    defineitemgroup = "definestartstop",
    definelist = "definestartstop",
    citation = "cite",
    nocitation = "cite",
    pagereference = "label",
    textreference = "label",
    ["in"] = "ref",
    at = "ref",
    about = "ref"
  } do
    if commands[cs] then
      commands[cs].action = action
    end
  end

end

--* ManuscriptConTeXt class

local ManuscriptConTeXt = util.class(Manuscript)

ManuscriptConTeXt.parser = Parser()
ManuscriptConTeXt.format = "context"
ManuscriptConTeXt.packages = {}
ManuscriptConTeXt.commands = {}
ManuscriptConTeXt.environments = {}
ManuscriptConTeXt.init_callbacks = {}
ManuscriptConTeXt.scan_references_callbacks = {}
ManuscriptConTeXt:add_package("context-en.xml")

-- Make a snippet for an environment.
function ManuscriptConTeXt:snippet_env(cs, args)
  local argsnippet = args and self:snippet_args(args) or ""
  return "start" .. cs .. argsnippet .. "\n\t$0\n\\stop" .. cs
end

-- ConTeXt optional arguments can't always be distinguished by their
-- delimiters, for instance \citation[optional][mandatory].  Here we
-- patch Parser.parse_args to deal with this case, but just in the
-- simplest case where the optional arguments are in the beginning of
-- the argument list.
local original_parse_args = ManuscriptConTeXt.parser.parse_args

local function new_parse_args(arglist, str, pos)
  local val = original_parse_args(arglist, str, pos)
  if val.incomplete and arglist[1].optional then
    arglist = table_move(arglist, 2, #arglist, 1, {})
    val = new_parse_args(arglist, str, pos)
    table_insert(val, 1, {omitted = true})
  end
  return val
end

ManuscriptConTeXt.parser.parse_args = new_parse_args

--* Init scanning

local to_args = {}
for i = 1, 9 do
  local t = merge(to_args[i-1] or {})
  t[i] = {meta = "#" .. i}
  to_args[i] = t
end

function ManuscriptConTeXt.init_callbacks.define(self, pos, cs)
  -- ugly! this function (and others below) parses the command twice
  local cont = self:parse_command(pos, cs).cont
  local csname, n_args
  for r in self:argument_items("command", pos, cs) do
    csname = self:substring_stripped(r):sub(2)
  end
  for r in self:argument_items("number", pos, cs) do
    n_args = tonumber(self:substring_stripped(r))
  end
  if csname then
    local idx = self:get_index "newcommand"
    idx[#idx+1] = {
      name = csname,
      pos = pos,
      cont = cont,
      manuscript = self,
      arguments = to_args[n_args]
    }
    if not self.commands[csname] then
      self.commands[csname] = idx[#idx]
    end
  end
  return cont
end

function ManuscriptConTeXt.init_callbacks.definestartstop(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local name
  for r in self:argument_items("name", pos, cs) do
    name = self:substring_stripped(r)
  end
  if name then
    local idx = self:get_index "newenvironment"
    idx[#idx+1] = {
      name = name,
      pos = pos,
      cont = cont,
      manuscript = self,
    }
    if not self.environments[name] then
      self.environments[name] = idx[#idx]
    end
  end
  return cont
end

function ManuscriptConTeXt.init_callbacks.label(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local idx = self.label_index
  for r in self:argument_items("reference", pos, cs) do
    idx[#idx + 1] = {
      name = self:substring_stripped(r),
      pos = r.pos,
      cont = r.cont,
      outer_pos = pos,
      outer_cont = cont,
      manuscript = self
    }
  end
  return cont
end

function ManuscriptConTeXt.init_callbacks.section(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  for r in self:argument_items("reference", pos, cs) do
    local idx = self.label_index
    idx[#idx + 1] = {
      name = self:substring_stripped(r),
      pos = r.pos,
      cont = r.cont,
      outer_pos = pos,
      outer_cont = cont,
      manuscript = self
    }
  end
  for r in self:argument_items("text", pos, cs) do
    local idx = self.section_index
    idx[#idx + 1] = {
      name = self:substring_stripped(r),
      level = self.commands[cs].section_level,
      pos = r.pos,
      cont = r.cont,
      outer_pos = pos,
      outer_cont = cont,
      manuscript = self
    }
  end
  return cont
end

function ManuscriptConTeXt.init_callbacks.input(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local idx = self.child_index
  local template = self.commands[cs].filename or "?"
  for r in self:argument_items("file", pos, cs) do
    local f = format_filename_template(template, self:substring_stripped(r))
    self:add_package(f)
    if not self.packages[f] then
      f = path_join(path_split(self.filename), f)
      idx[#idx + 1] = {
        name = f,
        pos = r.pos,
        cont = r.cont,
        manuscript = self
      }
    end
  end
  return cont
end

--* Reference scanning

function ManuscriptConTeXt.scan_references_callbacks.ref(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local idx = self.ref_index
  for s in self:argument_items("reference", pos, cs) do
    idx[#idx + 1] = {
      name = self:substring_stripped(s),
      pos = s.pos,
      cont = s.cont,
      outer_pos = pos,
      outer_cont = cont,
      manuscript = self
    }
  end
  return cont
end

function ManuscriptConTeXt.scan_references_callbacks.cite(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local idx = self.cite_index
  for s in self:argument_items("reference", pos, cs) do
    idx[#idx + 1] = {
      name = self:substring_stripped(s),
      pos = s.pos,
      cont = s.cont,
      outer_pos = pos,
      outer_cont = cont,
      manuscript = self
    }
  end
  return cont
end

return ManuscriptConTeXt
