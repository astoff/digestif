local util = require "digestif.util"
local Manuscript = require "digestif.Manuscript"
local Parser = require "digestif.Parser"

local path_join, path_split = util.path_join, util.path_split
local format_filename_template = util.format_filename_template

local ManuscriptConTeXt = util.class(Manuscript)

ManuscriptConTeXt.parser = Parser()
ManuscriptConTeXt.format = "context"

ManuscriptConTeXt.init_callbacks = {}
ManuscriptConTeXt.scan_references_callbacks = {}

--- Make a snippet for an environment.
--
-- @param cs The command name
-- @param args An argument list
-- @return The snippet string
function ManuscriptConTeXt:snippet_env(cs, args)
  local argsnippet = args and self:snippet_args(args) or ""
  return "start" .. cs .. argsnippet .. "\n\t$0\n\\stop" .. cs
end


--* Init scanning

function ManuscriptConTeXt.init_callbacks.label(self, pos, cs)
  -- ugly! this function (and others below) parses the command twice
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

function ManuscriptConTeXt.init_callbacks.input(self, pos, cs)
  local cont = self:parse_command(pos, cs).cont
  local idx = self.child_index -- should this include the known modules, or just the filenames not know in /data?
  local template = self.commands[cs].filename or "?"
  for r in self:argument_items("file", pos, cs) do
    local f = format_filename_template(template, self:substring_stripped(r))
    self:add_module(f)
    if not self.modules[f] then
      f = path_join(path_split(self.filename), f)
      idx[#idx + 1] = {
        name = f,
        pos = r.pos,
        cont = r.cont,
        filename = self.filename
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
