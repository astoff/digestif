local Cache = require "digestif.Cache"
local Manuscript = require"digestif.Manuscript"
require "digestif.config".data_dirs = {"./data"}

describe("Cross-references", function()
  local cache = Cache{
    ["one.tex"] = [[
\ref{foo}
\label{foobar}
\label{foobaz}
]]
  }

  it("finds labels", function()
     local script = Manuscript{filename="one.tex", format="latex", files=cache}
     local val = script:complete(8)
     assert.equal("foobar", val[1].text)
     assert.equal("foobaz", val[2].text)
  end)

end)

describe("Cross-references and bibliography", function()
  local cache = Cache{
    ["two.tex"] = [[
\cite[foo]{foo}
\cite{bah, foo, buh}
\bibitem{foobar}
\bibitem{foobaz}
]],
  }

  it("finds bibitems", function()
     local script = Manuscript{filename="two.tex", format="latex", files=cache}
     local val = script:complete(15)
     assert.equal("foobar", val[1].text)
     assert.equal("foobaz", val[2].text)
  end)

  it("does't look at optional arguments", function()
     local script = Manuscript{filename="two.tex", format="latex", files=cache}
     assert.is_nil(script:complete(10))
  end)
  
  it("supports lists of citations", function()
     local script = Manuscript{filename="two.tex", format="latex", files=cache}
     local val = script:complete(31)
     assert.equal("foobar", val[1] and val[1].text)
  end)
  
end)

describe("Packages", function()
  local cache = Cache{
    ["one.tex"] = [[
\usepackage{amsrefs, tikz}
]],
  }

  it("finds packages", function()
     local script = Manuscript{filename="one.tex", format="latex", files=cache}
     assert.not_nil(script.packages["latex"])
     assert.not_nil(script.packages["tikz.sty"])
     assert.not_nil(script.packages["amsrefs.sty"])
     assert.not_nil(script.commands["tikz"])
  end)
  
end)

describe("Outline", function()
  local cache = Cache{
    ["one.tex"] = [[
\section{A}
\chapter{B}
\section{C}
\subsection{D}
\section{E}
\chapter{F}
]],
  }

  it("finds the structure", function()
     local script = Manuscript{filename="one.tex", format="latex", files=cache}
     local outl = script:outline(15)
     assert.equal("A", outl[1].name)
     assert.equal("B", outl[2].name)
     assert.equal("C", outl[2][1].name)
     assert.equal("D", outl[2][1][1].name)
     assert.equal("E", outl[2][2].name)
     assert.equal("F", outl[3].name)
  end)

  
end)

