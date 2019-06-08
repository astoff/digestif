local lpeg = require "lpeg"
local util = require "digestif.util"

local S, C, Cp, Ct = lpeg.S, lpeg. C, lpeg.Cp, lpeg.Ct
local match = lpeg.match
local search, gobble_until = util.search, util.gobble_until
local path_split, path_join = util.path_split, util.path_join
local weak_keys = {__mode = "k"}

local FileCache = util.class()

function FileCache:__init()
  self.store = {}
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
FileCache.get = memoize(get_contents)

function FileCache:put(filename, src)
  local new = {[get_contents] = src}
  self.store[filename] = setmetatable(new, weak_keys)
end

function FileCache:put_property(filename, propname, value)
  self.store[filename][propname] = value
end

function FileCache:get_property(filename, propname)
  return self.store[filename] and self.store[filename][propname]
end

function FileCache:forget(filename)
  self.store[filename] = nil
end

local lines_patt = Ct(Cp() * search("\n" * Cp())^0)
local function get_lines(self, filename)
  local src = self:get(filename)
  return match(lines_patt, src)
end
FileCache.get_lines = memoize(get_lines)

local space = S" \t\r"
local ts_magic_comment = space^0
  * "%" * space^0 * "!" * S"Tt" * S"Ee" * S"Xx" * space^1
  * C((1 - space - "=")^1) * space^0
  * "=" * space^0 * C(gobble_until(space^0 * "\n"))

local function get_rootname(self, filename)
  local src = self:get(filename)
  local l = self:get_lines(filename)
  for i = 1, 15 do
    local key, val = match(ts_magic_comment, src, l[i])
    if key == "root" then
      return path_join(path_split(filename), val)
    end
  end
end
FileCache.get_rootname = memoize(get_rootname)

function FileCache:get_line_number(filename, pos)
  local src = self:get(filename) or error("File " .. filename .. " not found")
  local lines = self:get_lines(filename)
  local j, l = 1, #lines -- top and bottom bounds for line search
  while pos < lines[l] do
    local k = (j + l + 1) // 2
    if pos < lines[k] then
      l = k - 1
    else
      j = k
    end
  end -- now l = correct line, 1-based indexing
  return l, lines[l]
end

function FileCache:get_line_col(filename, pos)
  local src = self:get(filename) or error("File " .. filename .. " not found")
  local lines = self:get_lines(filename)
  local j, l = 1, #lines -- top and bottom bounds for line search
  while pos < lines[l] do
    local k = (j + l + 1) // 2
    if pos < lines[k] then
      l = k - 1
    else
      j = k
    end
  end -- now l = correct line, 1-based indexing
  local c = utf8.len(src, lines[l], pos) or error("Invalid UTF-8")
  return l, c
end

function FileCache:get_position(filename, line, col)
  local src = self:get(filename) or error("File " .. filename .. " not found")
  local lines = self:get_lines(filename)
  local pos = lines[line] or error("Position out of bounds")
  return utf8.offset(src, col, pos) or error("Position out of bounds")
end

return FileCache
