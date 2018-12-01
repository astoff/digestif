local util = require "digestif.util"

local FileCache = util.class()

function FileCache:__init()
   self.contents = {}
   self.properties = {}
end

local weak_keys = {__mode = "k"}

function FileCache:put(filename, src)
   self.contents[filename] = src
   self.properties[filename] = setmetatable({}, weak_keys)
end

function FileCache:get(filename)
   local src = self.contents[filename]
   if not src then
      local file = io.open(filename)
      if not file then return end
      src = file:read("*all")
      file:close()
      self:put(filename, src)
   end
   return src
end

function FileCache:forget(filename)
   self.contents[filename] = nil
   self.properties[filename] = nil
end

-- memoize a "function" f(filename) whose result depends on the
-- content of that file
function FileCache:memoize(f)
   return function(filename)
      local props = self.properties[filename]
      if not props[f] then
         props[f] = f(filename)
      end
      return props[f]
   end
end

return FileCache
