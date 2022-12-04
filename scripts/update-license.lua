#!/usr/bin/env lua
local lfs = require"lfs"
local out = io.tmpfile()

local notices = {
  ["GFDL-old-style"] = [[
    Permission is granted to make and distribute verbatim copies of this manual
    provided the copyright notice and this permission notice are preserved on
    all copies.

    Permission is granted to copy and distribute modified versions of this
    manual under the conditions for verbatim copying, provided that the entire
    resulting derived work is distributed under the terms of a permission
    notice identical to this one.

    Permission is granted to copy and distribute translations of this manual
    into another language, under the above conditions for modified versions.
]],
  ["LPPL-1.3c"] = [[
    Permission is granted to copy, distribute and/or modify this software under
    the terms of the LaTeX Project Public License (LPPL), version 1.3.
]],
  ["LPPL-1.3c+"] = [[
    This file may be distributed and/or modified under the conditions of the
    LaTeX Project Public License, either version 1.3 of this license or (at
    your option) any later version.  The latest version of this license is in
      http://www.latex-project.org/lppl.txt
    and version 1.3 or later is part of all distributions of LaTeX version
    2005/12/01 or later.
]],
["GFDL-1.3-or-later"]= [[
    Permission is granted to copy, distribute and/or modify this document under
    the terms of the GNU Free Documentation License, Version 1.3 or any later
    version published by the Free Software Foundation; with no Invariant
    Sections, no Front-Cover Texts, and no Back-Cover Texts.  A copy of the
    license is included in the section entitled "GNU Free Documentation
    License".
]]
}
notices["GFDL-1.2-or-later"] = notices["GFDL-1.3-or-later"]:gsub("1%.3", "1.2")
notices["GFDL-1.2-or-later or LPPL-1.3c+"] =
  notices["GFDL-1.2-or-later"].."\n"..notices["LPPL-1.3c+"]

-- Keep initial segment unchanged
for line in io.open("LICENSE.md"):lines() do
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
      if not line then break end
      local spdx_id = line:match"^SPDX%-License%-Identifier: (.*)"
      if spdx_id then
        local notice = notices[spdx_id]
          or error("Invalid SPDX license identifier: "..spdx_id)
        out:write("\n", notice)
      elseif line:match"^ *$" then
        out:write"\n"
      else
        out:write("    ", line, "\n")
      end
    end
    out:write"\n"
  end
end

-- Write back to LICENSE.md
out:seek("set")
local f = io.open("LICENSE.md", "w")
for line in out:lines() do
  f:write(line, "\n")
end
