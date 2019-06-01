Digestif
========

Digestif is a code analyzer of sorts, and a [language server][lsp],
for LaTeX et caterva.  It can provide context-sensitive documentation
and completion (macro names, labels, key-value arguments, etc.) to any
text editor that speaks the LSP protocol.

What it does
------------

- Complete commands, environments, and key-value options (for
  instance, TikZ options).

- Popup help messages, with command signature and a short
  explanation. Make sure you have the [LaTeX reference
  manual][latexref] installed as an info node for this.

- Complete labels defined in the document.  Multiple-file documents
  are supported via TeXShop-style magic comments.
  
- Parse BibTeX files and provide completion for citations. Digestif
  tries exact matches against the BibTeX identifiers and a fuzzy match
  against author and title.

- Jump to definition and find references to labels and bibliographic
  items.

The animated gif below shows some of these features. The following
things happen: user types `\ci`; selects `\cite` in the drop-down
list; snippet expands; user deletes first (optional) argument, jumping
to second one; user types `groalhom`; several matches are shown; user
selects **Gro**thendieck's “Sur quelques points d'**al**gébre
**hom**ologique”; the BibTeX indentifier `Tohoku` is inserted; user
triggers “find definition” command; BibTeX entry is shown; user
returns and exits the snippet.

![Mandatory GIF](https://user-images.githubusercontent.com/6500902/58749048-35d04500-8481-11e9-8e6e-84232308a751.gif)

The implemented LSP methods are:

- `initialize`
- `initialized`
- `shutdown`
- `exit`
- `textDocument/didOpen`
- `textDocument/didChange`
- `textDocument/didClose`
- `textDocument/signatureHelp`
- `textDocument/hover`
- `textDocument/completion`
- `textDocument/definition`
- `textDocument/references`

Installation and set-up
-----------------------

Lua 5.3 is required.  The easiest way to install the library and
language server is using LuaRocks (on most Linux distros, this is
package `luarocks`).  Just type

``` shell
luarocks install --server=http://luarocks.org/dev digestif
```

(Either as root, or with the `--local` option, in which case the
executable script will land in `~/.luarocks/bin/digestif` and you need
to adapt your text editor configuration accordingly.)

Next, you need to enable Digestif as a language server in your
favorite text editor.

### Emacs with the [Eglot] package

First, make sure the Eglot ELPA package is installed (`M-x
package-install RET eglot RET`) and add the following to your init
file.

``` emacs-lisp
(require 'eglot)
(add-to-list 'eglot-server-programs
             '((plain-tex-mode latex-mode) . ("digestif")))
```

Finally, open some LaTeX document and enable eglot (`M-x eglot`).
Voilà!  To get popup suggestions, make sure `company-mode` is on.  To
insert snippets upon completion, activate `yas-minor-mode` before
starting up `eglot`.

### Emacs with the [lsp-mode] package

Install `lsp-mode` and add the following to your init file.

``` emacs-lisp
(require 'lsp-mode)
(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection "digestif")
                  :major-modes '(latex-mode plain-tex-mode)
                  :server-id 'digestif))
(add-to-list 'lsp-language-id-configuration '(latex-mode . "latex"))
(add-to-list 'lsp-language-id-configuration '(plain-tex-mode . "plaintex"))
```

If you want fuzzy-matching of citations, make sure you have the
`company-lsp` package installed and add the following to your init
file.

``` emacs-lisp
(require 'company-lsp)
(add-to-list 'company-lsp-filter-candidates '(digestif . nil))
```

### Vim with the [Coc] plugin

See instructions
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
- [ ] For ConTeXt: whatever the source of [this pdf](http://www.pragma-ade.nl/general/qrcs/setup-en.pdf) is.
- [ ] For Texinfo: from the [command list](https://www.gnu.org/software/texinfo/manual/texinfo-html/Command-List.html).

Further things to do and some open questions:

- [x] Bibliography support: parse bibtex files, etc.
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
