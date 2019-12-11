local Manuscript = require "digestif.Manuscript"
local lpeg = require "lpeg"
local util = require "digestif.util"

local S, C, Cp, Ct = lpeg.S, lpeg. C, lpeg.Cp, lpeg.Ct
local sequence, gobble_until = util.sequence, util.gobble_until
local path_split, path_join = util.path_split, util.path_join
local weak_keys = {__mode = "k"}

local Cache = util.class()

function Cache:__init(tbl)
  self.store = {}
  if tbl then
    for name, src in pairs(tbl) do
      self:put(name, src)
    end
  end
end

-- memoize methods f(self, filename) whose result depends only on the
-- content of that file, so that they are recalculated each time the
-- cached file contents change.
local function memoize(f)
  return function(self, filename)
    local store = self.store
    local props = store[filename]
    if not props then
      props = setmetatable({}, weak_keys)
      store[filename] = props
    end
    local val = props[f]
    if val == nil then
      val = f(self, filename)
      props[f] = val
    end
    return val
  end
end

local function get_contents(_, filename)
  local file = io.open(filename)
  if not file then return nil end
  local src = file:read("*all")
  file:close()
  return src
end
Cache.get = memoize(get_contents)
Cache.__call = Cache.get

function Cache:put(filename, src)
  local new = {[get_contents] = src}
  self.store[filename] = setmetatable(new, weak_keys)
end

function Cache:get_property(filename, propname)
  local props = self.store[filename]
  return props and props[propname]
end

function Cache:put_property(filename, propname, value)
  self.store[filename][propname] = value
end

function Cache:forget(filename)
  self.store[filename] = nil
end

local function line_indices(self, filename)
  local src = self:get(filename)
  return util.line_indices(src)
end
Cache.line_indices = memoize(line_indices) -- get rid of this here?

local space = S" \t\r"
local magic_comment_patt = sequence(
  space^0,
  "%" * space^0 * "!" * S"Tt" * S"Ee" * S"Xx" * space^1,
  C((1 - space - "=")^1) * space^0,
  "=" * space^0 * C(gobble_until(space^0 * "\n")))

local function rootname(self, filename)
  local src = self:get(filename)
  local lines = self:line_indices(filename)
  for i = 1, 15 do
    local key, val = magic_comment_patt:match(src, lines[i])
    if key == "root" then
      return path_join(path_split(filename), val)
    end
  end
end
Cache.rootname = memoize(rootname)

--- Check if a Manuscript object has up-to-date content.
-- @param script a Manuscript object
function Cache:is_current(script)
  return self:get(script.filename) == script.src
end

--- Mutate a Manuscript object so that its children are up to date.
-- @param script a Manuscript object
-- @return the Manuscript
function Cache:refresh_manuscript(script)
  local children = script.children
  for name, child in pairs(children) do
    if self:is_current(child) then
      self:refresh_manuscript(child)
    else
      children[name] = Manuscript{
        filename = name,
        parent = script,
        format = child.format,
        files = self
      }
    end
  end
  return script
end

function Cache:manuscript(filename, format)
  local rootname = self:rootname(filename) or filename
  local root = self:get_property(rootname, format)
  if root then
    root = self:refresh_manuscript(root)
  else
    root = Manuscript{
      filename = rootname,
      format = format,
      files = self
    }
    self:put_property(rootname, format, root)
  end
  local script = root:find_manuscript(filename)
  if not script then -- root does not refer back to filename
    script = self:get_property(filename, format)
    if not script then
      script = Manuscript{
        filename = filename,
        files = self,
        format = format
      }
      self:put_property(filename, format, script)
    end
  end
  return script
end

return Cache
