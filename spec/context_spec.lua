local Cache = require "digestif.Cache"
local Manuscript = require"digestif.Manuscript"
require "digestif.config".data_dirs = {"./data"}

describe("ConTeXt init scanning", function()
  local cache = Cache{
    ["one.tex"] = [[
\title[label1, label2]{Title}
\pagereference[label3]
\textreference[label4]{text}

\usemodule[tikz]
\component[two]
\usebtxdataset[default][biblio.bib]

\cite[][somepaper]
\in[label5]
]],
    ["two.tex"] = [[
\def\xyz{}
]],
    ["biblio.bib"] = [[
@Article{somepaper,
  author = 	 {A.U. Thor},
  title = 	 {Some great paper},
  journal = 	 {Journal of great papers},
  year = 	 1999}
]]
  }

  it("finds labels", function()
     local script = Manuscript{filename="one.tex", format="context", files=cache}
     local t, u, v = script.label_index, {}, {}
     for i = 1, #t do u[i] = t[i].name; v[i] = t[i].pos end
     assert.same({"label1", "label2", "label3", "label4"}, u)
     assert.same({8, 16, 46, 69}, v)
  end)

  it("finds children", function()
     local script = Manuscript{filename="one.tex", format="context", files=cache}
     local t, u, v = script.child_index, {}, {}
     for i = 1, #t do u[i] = t[i].name; v[i] = t[i].pos end
     assert.same({"two.tex", "biblio.bib"}, u)
     assert.same({112, 141}, v)
     assert.not_nil(script.modules["t-tikz.tex"])
  end)

  it("finds references", function()
     local script = Manuscript{filename="one.tex", format="context", files=cache}
     script:scan_references()
     local t, u, v = script.ref_index, {}, {}
     for i = 1, #t do u[i] = t[i].name; v[i] = t[i].pos end
     assert.same({"label5"}, u)
     local t, u, v = script.cite_index, {}, {}
     for i = 1, #t do u[i] = t[i].name; v[i] = t[i].pos end
     assert.same({"somepaper"}, u)
  end)

end)
