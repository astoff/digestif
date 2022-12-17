package = "digestif"    
version = "dev-1"
source = {
  url = "git://github.com/astoff/digestif",
  branch = "main"
}
description = {
  summary = "A code analyzer for TeX",
  detailed = [[
    A code analyzer for TeX documents, including LaTeX and BibTeX.  It
    comes with a Language Server Protocol implementation, so it can
    run as a plug-in to many different text editors.
  ]],
  homepage = "https://github.com/astoff/digestif/",
  license = "GPLv3+ and other free licenses"
}
dependencies = {
  "lua >= 5.3",
  "lpeg >= 1.0",
  "luafilesystem >= 1.8",
}
build = {
  type = "builtin",
  modules = {
    ["digestif.Cache"] = "digestif/Cache.lua",
    ["digestif.Manuscript"] = "digestif/Manuscript.lua",
    ["digestif.ManuscriptBibTeX"] = "digestif/ManuscriptBibTeX.lua",
    ["digestif.ManuscriptConTeXt"] = "digestif/ManuscriptConTeXt.lua",
    ["digestif.ManuscriptDoctex"] = "digestif/ManuscriptDoctex.lua",
    ["digestif.ManuscriptLaTeX"] = "digestif/ManuscriptLaTeX.lua",
    ["digestif.ManuscriptLatexProg"] = "digestif/ManuscriptLatexProg.lua",
    ["digestif.ManuscriptPlainTeX"] = "digestif/ManuscriptPlainTeX.lua",
    ["digestif.ManuscriptTexinfo"] = "digestif/ManuscriptTexinfo.lua",
    ["digestif.Parser"] = "digestif/Parser.lua",
    ["digestif.Schema"] = "digestif/Schema.lua",
    ["digestif.bibtex"] = "digestif/bibtex.lua",
    ["digestif.config"] = "digestif/config.lua",
    ["digestif.data"] = "digestif/data.lua",
    ["digestif.langserver"] = "digestif/langserver.lua",
    ["digestif.util"] = "digestif/util.lua",
  },
  copy_directories = {
    "data"
  },
  install = {
    bin = {
      ["digestif"] = "bin/digestif"
    }
  }
}
