#!/usr/bin/env lua
local lfs = require"lfs"
local out = io.tmpfile()

-- Keep initial segment unchanged
for line in io.open("LICENSE"):lines() do
  if line == "---" then
    out:write("---\n\n")
    break
  else
    out:write(line, "\n")
  end
end

-- Collect comment preamble of tags files
local fnames = {}
for fname in lfs.dir("data") do
  if fname:find"%.tags$" then
    fnames[#fnames+1] = fname
  end
end
table.sort(fnames)

for _, fname in ipairs(fnames) do
  local f = io.open("data/"..fname)
  if f:read(2) == "--" then
    out:write(fname, ":\n\n")
    f:seek("set")
    for line in f:lines() do
      line = line:match"^%-%- ?(.*)"
      if not line then
        break
      elseif line:match"^ *$" then
        out:write"\n"
      else
        out:write("    ", line, "\n")
      end
    end
    out:write"\n"
  end
end

-- Write back to LICENSE
out:seek("set")
local f = io.open("LICENSE", "w")
for line in out:lines() do
  f:write(line, "\n")
end
