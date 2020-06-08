local Cache = require "digestif.Cache"
local Manuscript = require"digestif.Manuscript"
require "digestif.config".data_dirs = {"./data"}

describe("Multi-manuscript traversal", function()
  local cache = Cache{
    ["one.tex"] = [[
\label{1}
\ref{A}
\include{two}
\label{5}
\include{three}
\label{6}
\include{nonexistent}
]],
    ["two.tex"] = [[
\label{2}
\ref{B}
\include{three}
\label{4}
]],
    ["three.tex"] = [[
\label{3}
\ref{C}
]],
    ["loop.tex"] = [[
\include{loop}
\label{1}
]]
  }

  it("traverses children in order", function()
    local t = {}
    local script = Manuscript{filename="one.tex", format="latex", files=cache}
    for it in script:traverse "child_index" do
      t[#t+1] = it.name
    end
    assert.same({"two.tex", "three.tex", "three.tex", "nonexistent.tex"}, t)
  end)

  it("traverses index items in order", function()
    local t = {}
    local script = Manuscript{filename="one.tex", format="latex", files=cache}
    for it in script:traverse "label_index" do
      t[#t+1] = it.name
    end
    assert.same({"1", "2", "3", "4", "5", "3", "6"}, t)
  end)

  it("traverses multiple indexes", function()
    local t = {}
    local script = Manuscript{filename="one.tex", format="latex", files=cache}
    script:scan_references()
    for it, kind in script:traverse({"label_index", "ref_index"}) do
      t[#t+1] = it.name
      assert(kind == "label_index" or kind == "ref_index")
    end
    assert.same({"1", "A", "2", "B", "3", "C", "4", "5", "3", "C", "6"}, t)
  end)

  it("resists loops", function()
    local t = {}
    local script = Manuscript{filename="loop.tex", format="latex", files=cache}
    for it, kind in script:traverse("label_index") do
      t[#t+1] = it.name
    end
    assert(#t < 100)
  end)
end)
