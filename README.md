Digestif
========

Digestif is a code analyzer of sorts, and a [language server][lsp],
for LaTeX et caterva.  It can provide context-sensitive documentation and
completion (macro names, labels, key-value arguments, etc.) to any text
editor that speaks the protocol.

The typical TeX literate documentation is ostensibly not machine
readable, so lists of commands with a short explanation and a
description of the arguments must be compiled manually or
semi-manually for each package.  These files are in the
`digestif-data/` folder, and their format should be more or less self
explanatory.

What it does (for now)
----------------------

* Complete command names and key-value options.  For instance, with
  TikZ:
  ![completion](https://user-images.githubusercontent.com/6500902/49062925-01e83e80-f216-11e8-9342-e27e820c211a.png)
  
* Complete labels defined in the document.  Multiple-file documents
  are supported via TeXShop-style magic comments:
  ![crossref](https://user-images.githubusercontent.com/6500902/49062985-2ba16580-f216-11e8-99de-5be9a74ecaa6.png)
  
* Popup help messages, with command signature and a short explanation:
  ![eldoc](https://user-images.githubusercontent.com/6500902/49062989-2fcd8300-f216-11e8-9076-587eca2321d1.png)

The implemented LSP methods are

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

Installation and set-up
-----------------------

Lua 5.3 is required.  The easiest way to install the library and
language server is using LuaRocks (on most Linux distros, this is
package `luarocks`).  Just type

``` shell
luarocks install https://github.com/astoff/digestif/raw/master/rockspec/digestif-scm-1.rockspec
```

(Either as root, or with the `--local` option, in which case the
executable script will land in `~/.luarocks/bin/digestif`)

Next, you will need to enable Digestif as a language server in your
favorite text editor.  I have tested it on Emacs with [Eglot][eglot].
First, make sure the eglot ELPA package is installed (`M-x
package-install RET eglot RET`).  Then evaluate the following in your
scratch buffer (or add it to your init file).

``` emacs-lisp
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(latex-mode . ("digestif"))))
```

Finally, open some LaTeX document and enable eglot (`M-x eglot`).
Voilà!  To get popup suggestions, make sure `company-mode` is on.  To
insert snippets upon completion, activate `yas-minor-mode` before
starting up `eglot`.

To do
-----

Contributions are welcome!  Some relatively simple things to do at
this point include:

- Support incremental document changes
- Goto definition
- Find references
- Rename labels (cross-references and bibitems)

This program can't be useful without a larger collection of data
files.  These can be made by hand and/or extracted from suitable
sources:

- For plain TeX from [TeX for the impatient](https://www.gnu.org/software/teximpatient/) 
- For ConTeXt from whatever the source of [this
  pdf](http://www.pragma-ade.nl/general/qrcs/setup-en.pdf) is

Further things to do and some open questions:

- Bibliography support: parse bibtex files, etc.
- Test on more editors (VS Code plugin?)
- On Emacs, an ivy-based interface, more on the lines of RefTeX, might
  be nice
- Provide diagnostics?
- Extract data files from LaTeX literate code?  For packages using
  xparse, it is possible to at least obtain the signature of commands
  systematically
- How to integrate with texdoc?
- Provide a Lua API, for use in editors capable of loading Lua
  modules

License
-------

The software itself (everything outside `digestif-data/`) is under the
MIT license.

Some of the files in the `digestif-data/` folder are extracted or
adapted from other sources, such as package manuals or books, and
therefore may inherit specific license details.  At a minimum, they
should be free to use, redistribute and modify.

[lsp]: https://microsoft.github.io/language-server-protocol/
[eglot]: https://github.com/joaotavora/eglot
