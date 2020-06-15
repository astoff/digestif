Digestif
========

[![LuaRocks](https://img.shields.io/luarocks/v/astoff/digestif.svg)](https://luarocks.org/modules/astoff/digestif)
[![Build Status](https://travis-ci.com/astoff/digestif.svg?branch=master)](https://travis-ci.com/astoff/digestif)

Digestif is a code analyzer, and a [language server][lsp], for LaTeX
et caterva.  It provides context-sensitive completion, documentation
and related functionality to any text editor that speaks the LSP
protocol.

![Mandatory GIF][gif]

Features
--------

- Completion for commands, environments, key-value options (for
  instance, TikZ options), cross-references and citations.

- Popup help messages, including command signature and documentation.
  For the best results, make sure you have the [LaTeX reference
  manual][latexref] installed as an [info node][info-issues], as well
  as the [tlmgr] utility.

- Multi-file documents are supported via TeXShop-style magic comments.
  Just add a comment like this near the top of each child document:

  ```
  % !TeX root = somefile.tex
  ```

- Digestif is fuzzy!  For citations, it tries an exact match against
  the BibTeX identifier and a fuzzy match against author and title.
  In the GIF above, the user types `groalhom`, which matches
  **Gro**thendieck's “Sur quelques points d'**al**gébre
  **hom**ologique”; selecting this inserts the BibTeX identifier
  `Tohoku`.  Similarly, for cross-references, Digestif tries an exact
  match against the label and a fuzzy match against the text around
  the label.

- Jump to definition and find references to labels and citations.

- Works with LaTeX and ConTeXt.  There is also preliminary support for
  plain TeX and Texinfo.

- Bibliography support via BibTeX and amsrefs.

Installation and set-up
-----------------------

Lua 5.3 is required.  The easiest way to install the library and
language server is using LuaRocks (on most Linux distros, this is
package `luarocks`).  Just type

``` shell
luarocks install digestif
```

This should be done either as root or with the `--local` option, in
which case the executable script will land in
`~/.luarocks/bin/digestif` and you need to adapt your text editor
configuration accordingly.

Next, you need to enable Digestif as a language server in your
favorite text editor.

- **Emacs with the [Eglot] package:** Digestif works out-of-the-box
  with Eglot.  Just install the package (`M-x package-install RET
  eglot RET`), open some TeX document and enable Eglot (`M-x eglot`).
  Voilà!  Make sure to activate `company-mode` and `yas-minor-mode`
  before starting up Eglot, if you want any of these features.

- **Emacs with the [lsp-mode] package:** Recent versions have built-in
  support for Digestif.  If you want fuzzy-matching of citations (as
  in the GIF above), make sure you have the `company-lsp` package
  installed and add the following to your init file.

  ``` emacs-lisp
  (require 'company-lsp)
  (add-to-list 'company-lsp-filter-candidates '(digestif . nil))
  ```

- **Vim with the [Coc] plugin:** See instructions
  [here](https://github.com/neoclide/coc.nvim/wiki/Language-servers#latex).

Development
-----------

Contributions are welcome!  A haphazard roadmap is as follows:

- [x] Support incremental document changes
- [x] Goto definition
- [x] Find references
- [X] Document outline
- [ ] Rename labels (cross-references and bibitems)
- [x] Bibliography support: parse bibtex files, etc.
- [ ] Add cross-reference and code snippet support for plain TeX and
  Texinfo
- [ ] Test on more editors (VS Code plugin?)
- [ ] Linting/diagnostics
- [ ] Extract data files from LaTeX literate code?  For packages using
      xparse, it is possible to at least obtain the signature of
      commands systematically
- [X] Integrate with texdoc.  We provide links to
      <http://texdoc.net/>, or to the locally-installed documentation,
      if present.  This latter functionality requires `tlmgr`.  We
      should eventually support MiKTeX as well.
- [ ] Digestif probably runs on macOS, but needs testing.  Some work
      and testing is need for Windows support.
- [X] Provide a Lua API, for use in editors capable of loading Lua
      modules (see [API on the wiki][api])

The main shortcoming of this program at this point is the lack of a
more extensive collection of “tags” files.  The typical TeX literate
documentation is ostensibly not machine readable, so in most cases
those files (listing all commands and their arguments, preferably with
docstrings) must be compiled manually.  The tags files are in the
`data` folder, and their format should be more or less self
explanatory.

[gif]: https://user-images.githubusercontent.com/6500902/70077785-c5f27100-1601-11ea-9cfb-6e7ebd3c61ae.gif
[info-issues]: https://github.com/astoff/digestif/wiki/Common-installation-issues#info-nodes
[installation-issues]: https://github.com/astoff/digestif/wiki/Common-installation-issues
[coc]: https://github.com/neoclide/coc.nvim
[eglot]: https://github.com/joaotavora/eglot
[latexref]: https://latexref.xyz/
[lsp-mode]: https://github.com/emacs-lsp/lsp-mode
[lsp]: https://microsoft.github.io/language-server-protocol/
[api]: https://github.com/astoff/digestif/wiki/API
[tlmgr]: https://www.tug.org/texlive/tlmgr.html
