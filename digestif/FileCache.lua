local util = require "digestif.util"

local FileCache = util.class()

function FileCache:_init()
   self.src = {}
   self.props = {}
end

function FileCache:put(filename, src, props)
   self.src[filename] = src
   self.props[filename] = props or {}
end

function FileCache:forget(filename)
   self.src[filename] = nil
   self.props[filename] = nil
end

function FileCache:get(filename)
   if not self.src[filename] then
      local file = io.open(filename)
      if not file then return end
      self:put(filename, file:read("*all"))
      file:close()
   end
   return self.src[filename]
end

-- remove?
function FileCache:properties(filename)
   return self.props[filename]
end

-- memoize a "function" f(filename) whose result depends on the
-- content of that file
function FileCache:memoize(f)
   return function(filename)
      local props = self.props[filename]
      if not props[f] then
         props[f] = f(filename)
      end
      return props[f]
   end
end
     
return FileCache
