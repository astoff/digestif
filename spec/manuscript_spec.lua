local Cache = require "digestif.Cache"
local Manuscript = require"digestif.Manuscript"
require "digestif.config".data_dirs = {"./data"}

describe("Multi-manuscript traversal", function()
  local cache = Cache{
    ["one.tex"] = [[
\label{1}
\include{two}
\label{5}
\include{three}
\label{6}
]],
    ["two.tex"] = [[
\label{2}
\include{three}
\label{4}
]],
    ["three.tex"] = [[
\label{3}
]]
  }

  it("traverses children in order", function()
    local t = {}
    local script = Manuscript{filename="one.tex", format="latex", files=cache}
    for it in script:traverse "child_index" do
      t[#t+1] = it.name
    end
    assert.same({"two.tex", "three.tex", "three.tex"}, t)
  end)

  it("traverses index items in order", function()
    local t = {}
    local script = Manuscript{filename="one.tex", format="latex", files=cache}
    for it in script:traverse "label_index" do
      t[#t+1] = it.name
    end
    assert.same({"1", "2", "3", "4", "5", "3", "6"}, t)
  end)
end)
