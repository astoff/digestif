Digestif
========

<p align="center">
<a href="https://app.travis-ci.com/astoff/digestif"><img src="https://app.travis-ci.com/astoff/digestif.svg?branch=main" alt="Build Status"></a>
<a href="https://ctan.org/pkg/digestif"><img alt="CTAN" src="https://img.shields.io/ctan/v/digestif?color=blue"></a>
<a href="https://luarocks.org/modules/astoff/digestif"><img alt="LuaRocks" src="https://img.shields.io/luarocks/v/astoff/digestif?color=blue"></a>
</p>

Digestif is a code analyzer, and a [language server][lsp], for LaTeX,
ConTeXt et caterva.  It provides context-sensitive completion,
documentation, code navigation, and related functionality to any text
editor that speaks the LSP protocol.

<p align="center"><img src="https://raw.githubusercontent.com/astoff/digestif/images/screenshot.gif" alt="Madatory GIF"></p>

Features
--------

- Completion for commands, environments, key-value options (for
  instance, TikZ options), cross-references and citations.

- Popup help messages, including command signature and documentation.
  For the best results, make sure you have the [LaTeX reference
  manual][latexref] installed as an [info node][info-issues].

- Find definition and references to labels and citations.

- Document outline.

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

- Support for LaTeX, ConTeXt, plain TeX, DocTeX (`.dtx` files) and
  Texinfo.

- Bibliography support via BibTeX, BibLaTeX and amsrefs.

- Lua API, independent of the language server protocol, for use in
  editors capable of loading Lua modules.  See [API on the wiki][api]
  for details.

Installation
------------

Digestif has minimal dependencies and can run on LuaTeX or on a
standalone Lua interpreter.  Correspondingly, there are two ways to
install it.

### LuaTeX with the self-installing script ![easy]

The only dependencies for this are git and a recent TeX installation.

1. Download the [digestif][self-install-sh] wrapper script (or, on
   Windows, [digestif.cmd][self-install-cmd]).
2. Place it in your `$PATH` (say, `~/.local/bin`).
3. Make it executable (`chmod +x ~/.local/bin/digestif`).

In the first run, the script will automatically download the
package, by default to `~/.digestif`.  To update or uninstall,
simply delete that folder.

### Standalone Lua via LuaRocks

Run `luarocks install digestif`.  This should be done either as root
or with the `--local` option, in which case the executable script will
land in `~/.luarocks/bin/digestif`; make sure this is in your `$PATH`
or adapt your text editor configuration accordingly.

Editor setup
------------

Next, you need to enable Digestif as a language server in your
favorite text editor.

### Emacs with the [Eglot] package

Digestif works out-of-the-box with Eglot.  Just install the package
(`M-x package-install RET eglot RET`), open some TeX document and
enable Eglot (`M-x eglot`).  Voilà!  Some hints:

- If you want automatic snippet insertion upon choosing a completion
  candidate, make sure to activate `yas-minor-mode` *before*
  starting up Eglot.

- Try the [consult-eglot] package to access the index of a multifile
  project (this is exposed via the the `workspace/symbols` LSP
  method.)

### Emacs with the [lsp-mode] package

To ensure that Digestif is used, add the following to your init file:

  ``` emacs-lisp
  (setq lsp-tex-server 'digestif)
  ```

### Vim with the [Coc] plugin

See instructions [here](https://github.com/neoclide/coc.nvim/wiki/Language-servers#latex).

### Other editors

It shouldn't be hard to set up other editors to use Digestif.  Please
open an issue if you want to include additional instructions here.

Supported TeX packages
----------------------

Digestif tries to learn about the commands provided by a package by
looking at its source code, but this has limitations, since the
typical TeX literate documentation is ostensibly not machine readable.

For full support, a detailed “tags” file should be created for each
package.  Among other things, this file lists all defined macros
together with their signatures and docstrings.  To generate a stub
tags file from a `.sty`, `.cls` or `.dtx` file, use the command

```
digestif --generate FILES
```

After filling in the missing details, the resulting tags file can be
added to this repository (pull requests are welcome!).  The format of
the tags files should be more or less self explanatory.  See the
[data](./data) folder for examples.

License
-------

Digestif is available under the [GNU General Public License][GPL],
version 3 or later.  For some files in the [data](./data) directory, a
different (free) license applies.  See [LICENSE.md](./LICENSE.md) for
details.

[info-issues]: https://github.com/astoff/digestif/wiki/Common-installation-issues#info-nodes
[installation-issues]: https://github.com/astoff/digestif/wiki/Common-installation-issues
[coc]: https://github.com/neoclide/coc.nvim
[eglot]: https://github.com/joaotavora/eglot
[latexref]: https://latexref.xyz/
[lsp-mode]: https://github.com/emacs-lsp/lsp-mode
[lsp]: https://microsoft.github.io/language-server-protocol/
[api]: https://github.com/astoff/digestif/wiki/API
[self-install-sh]: https://raw.githubusercontent.com/astoff/digestif/master/scripts/digestif
[self-install-cmd]: https://raw.githubusercontent.com/astoff/digestif/master/scripts/digestif.cmd
[easy]: https://raw.githubusercontent.com/astoff/digestif/images/easy.png
[GPL]: https://www.gnu.org/licenses/gpl-3.0.txt
[consult-eglot]: https://github.com/mohkale/consult-eglot/
[Company mode]: https://company-mode.github.io/
