Digestif
========

[![LuaRocks](https://img.shields.io/luarocks/v/astoff/digestif.svg)](https://luarocks.org/modules/astoff/digestif)
[![Build Status](https://travis-ci.com/astoff/digestif.svg?branch=master)](https://travis-ci.com/astoff/digestif)

Digestif is a code analyzer of sorts, and a [language server][lsp],
for LaTeX et caterva.  It can provide context-sensitive documentation
and completion (macro names, labels, key-value arguments, etc.) to any
text editor that speaks the LSP protocol.

![Mandatory GIF](https://user-images.githubusercontent.com/6500902/59445824-96a43980-8e00-11e9-9149-3dfa4d13ea6c.gif)

What it does
------------

- Complete commands, environments, and key-value options (for
  instance, TikZ options).

- Popup help messages, with command signature and a short explanation.
  For this to work, make sure you have the [LaTeX reference
  manual][latexref] installed as an info node<sup id="infofn">[info](#info)</sup>.

- Complete labels defined in the document.  Multiple-file documents
  are supported via TeXShop-style magic comments.  Just add a comment
  like this near the top of each child document:

  ```
  % !TeX root = somefile.tex
  ```

- Parse BibTeX files and provide completion for citations.  Digestif
  tries exact matches against the BibTeX identifiers and a fuzzy match
  against author and title.  In the GIF above, the user types
  `groalhom`, which matches **Gro**thendieck's “Sur quelques points
  d'**al**gébre **hom**ologique”; selecting this inserts the BibTeX
  identifier `Tohoku`.

- Jump to definition and find references to labels and bibliographic
  items.

- Preliminary support for plain TeX, ConTeXt, Texinfo and BibTeX
  formats.

Installation and set-up
-----------------------

Lua 5.3 is required.  The easiest way to install the library and
language server is using LuaRocks (on most Linux distros, this is
package `luarocks`).  Just type

``` shell
luarocks install digestif
```

(Either as root, or with the `--local` option, in which case the
executable script will land in `~/.luarocks/bin/digestif` and you need
to adapt your text editor configuration accordingly.)

Next, you need to enable Digestif as a language server in your
favorite text editor.

- **Emacs with the [Eglot] package:** First, make sure the Eglot ELPA
  package is installed (`M-x package-install RET eglot RET`) and add
  the following to your init file.

  ``` emacs-lisp
  (require 'eglot)
  (add-to-list 'eglot-server-programs '((tex-mode context-mode
                                         texinfo-mode bibtex-mode)
                                        . ("digestif")))
  ```

  Finally, open some LaTeX document and enable eglot (`M-x eglot`).
  Voilà!  To get popup suggestions, make sure `company-mode` is on.
  To insert snippets upon completion, activate `yas-minor-mode` before
  starting up `eglot`.

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

To do
-----

Contributions are welcome!  Some relatively simple things to do at
this point include:

- [x] Support incremental document changes
- [x] Goto definition
- [x] Find references
- [ ] Rename labels (cross-references and bibitems)

This program can't be useful without a larger collection of data
files.  The typical TeX literate documentation is ostensibly not
machine readable, so in most cases lists of commands with a short
explanation and a description of the arguments must be compiled
manually.  These files are in the `digestif-data` folder, and their
format should be more or less self explanatory.  Some sources that
seem suitable for automatic extraction include:

- [x] For plain TeX: [TeX for the impatient](https://www.gnu.org/software/teximpatient/).
- [x] For ConTeXt: whatever the source of [this pdf](http://www.pragma-ade.nl/general/qrcs/setup-en.pdf) is.
- [x] For Texinfo: from the [command list](https://www.gnu.org/software/texinfo/manual/texinfo-html/Command-List.html).

Further things to do and some open questions:

- [x] Bibliography support: parse bibtex files, etc.
- [ ] Add cross-reference and code snippet support for plain TeX,
  ConTeXt and Texinfo.
- [ ] Test on more editors (VS Code plugin?)
- [ ] On Emacs, an ivy-based interface, more on the lines of RefTeX,
      might be nice
- [ ] Provide diagnostics?
- [ ] Extract data files from LaTeX literate code?  For packages using
      xparse, it is possible to at least obtain the signature of
      commands systematically
- [ ] How to integrate with texdoc? For now, we provide links to
      <http://texdoc.net/>
- [ ] Provide a Lua API, for use in editors capable of loading Lua
      modules

License
-------

The software itself (everything outside the `digestif-data` folder) is
under the MIT license.

Some of the files in the `digestif-data` folder are extracted or
adapted from other sources, such as package manuals or books, and
therefore may inherit specific license details.  At a minimum, they
should be free to use, redistribute and modify.

[coc]: https://github.com/neoclide/coc.nvim
[eglot]: https://github.com/joaotavora/eglot
[latexref]: https://latexref.xyz/
[lsp-mode]: https://github.com/emacs-lsp/lsp-mode
[lsp]: https://microsoft.github.io/language-server-protocol/

Notes
-----

<b id="info">info nodes:</b> info files are searched for in a list of
directories. Check the environemnt variable "INFOPATH" or the emacs
variable `Info-directory-list`.

If you install [texlive](https://tug.org/texlive/), latex2e info file
is in `/usr/local/texlive/2019/texmf-dist/doc/info`. You can make it
visible to emacs, for instance, with:

    (add-to-list 'Info-directory-list "/usr/local/texlive/2019/texmf-dist/doc/info")

[↩](#infofn)
