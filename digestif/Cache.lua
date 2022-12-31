-- A class to store transient file contents and manage the creation of
-- Manuscript objects.

local Manuscript = require "digestif.Manuscript"
local lpeg = require "lpeg"
local util = require "digestif.util"

local S, C = lpeg.S, lpeg.C
local sequence, gobble_until = util.sequence, util.gobble_until
local path_split, path_join = util.path_split, util.path_join
local path_normalize = util.path_normalize
local weak_values = {__mode = "v"}
local io_open = io.open

local Cache = util.class()

function Cache:__init(tbl)
  self.store = setmetatable({}, weak_values)
  self.persist = {} -- a place to keep an extra reference to things
                    -- that shouldn't vanish
  if tbl then
    for name, src in pairs(tbl) do
      self:put(name, src)
    end
  end
end

-- Set the contents of a file in the cache.
function Cache:put(filename, str)
  local props = self.store[filename]
  if not props then
    props = {}
    self.store[filename] = props
  else
    props.rootname = nil
  end
  props.contents = str
  self.persist[filename] = props
end

-- Return the contents of a file, as stored with the put method, or
-- attempt to read the file from disk.  If neither succeeds, return
-- nil.  The second return value is a cookie.  Values read from disk
-- will be garbage collected when no reference to the cookie exists.
-- Values stored by the put method are not subject to garbage
-- collection until an explicit call to Cache.forget.
--
function Cache:__call(filename)
  local props = self.store[filename]
  if not props then
    local file, str = io_open(filename), nil
    if file then
      str = file:read("*all")
      file:close()
    end
    props = {contents = str}
    self.store[filename] = props
  end
  return props.contents, props
end

-- Remove a file from the cache.
function Cache:forget(filename)
  self.store[filename] = nil
  self.persist[filename] = nil
end

local space = S" \t\r"
local magic_comment_patt = sequence(
  (space^0 * "%")^1,
  space^0 * "!" * util.case_fold("tex"),
  space^1 * "root",
  space^0 * "=",
  space^0 * C(gobble_until(space^0 * "\n")))
local search_magic_comment_patt = util.choice(
  magic_comment_patt,
  util.search("\n" * magic_comment_patt))

-- Determine the root path of a document from magic comments.
function Cache:rootname(filename)
  local _, cookie = self(filename) -- luacheck: ignore cookie (warm up the cache)
  local props = assert(self.store[filename])
  local rootname = props.rootname
  if rootname == nil then
    local src = self(filename)
    local val = search_magic_comment_patt:match(src:sub(1, 1000))
    if val then
      rootname = path_normalize(path_join(path_split(filename), val))
    else
      rootname = false
    end
    props.rootname = rootname
  end
  return rootname
end

-- Produce a Manuscript object.  This method ensures that the result
-- belongs to a tree of Manuscript objects representing a multi-file
-- TeX document.  If the rootname argument is omitted, try to infer it
-- using magic comments.
--
-- This method reuses as much information as possible from the cache.
--
-- Arguments:
--   filename (string): the path of the manuscript
--   format (string): the TeX format
--   rootname (string, optional): the root path of the TeX document
--
-- Returns:
--   a Manuscript object
--
function Cache:manuscript(filename, format, rootname)
  rootname = rootname or self:rootname(filename) or filename
  local root = self.store[rootname] and self.store[rootname][format]
  if not root or not root:is_current() then
    root = Manuscript{
      filename = rootname,
      format = format,
      files = self
    }
    self.store[rootname][format] = root
  end
  local script = root:find_manuscript(filename)
    or self:manuscript(filename, format, filename) -- root does not refer back
  self.store[filename][format] = script
  return script
end

return Cache
