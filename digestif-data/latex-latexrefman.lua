module = "latex-latexrefman"

source = {
  name = "LaTeX2e Unofficial Reference Manual",
  url = "https://latexref.xyz/",
  license = "https://gnu.org/licenses/fdl.html"
}

commands = {
   ["-"] = {
      doc = "Insert explicit hyphenation."
   },
   ["/"] = {
      doc = "Insert italic correction."
   },
   ["@ifstar"] = {
      doc = "Define your own commands with *-variants."
   },
   ["@startsection"] = {
      args = {
         {
            meta = "name"
         },
         {
            meta = "level"
         },
         {
            meta = "indent"
         },
         {
            meta = "beforeskip"
         },
         {
            meta = "afterskip"
         },
         {
            meta = "style"
         }
      },
      doc = "Redefine layout of start of sections, subsections, etc."
   },
   Alph = {
      args = {
         {
            meta = "counter"
         }
      },
      doc = "Print value of a counter."
   },
   AtBeginDocument = {
      args = {
         {
            meta = "code"
         }
      },
      doc = "Hook for commands at the start of the document."
   },
   AtEndDocument = {
      args = {
         {
            meta = "code"
         }
      },
      doc = "Hook for commands at the end of the document."
   },
   AtEndOfClass = {
      args = {
         {
            meta = "code"
         }
      }
   },
   AtEndOfPackage = {
      args = {
         {
            meta = "code"
         }
      }
   },
   CheckCommand = {
      args = {
         {
            meta = "cmd"
         },
         {
            delims = {"[", "]"},
            meta = "num",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "default",
            optional = true
         },
         {
            meta = "definition"
         }
      }
   },
   ["CheckCommand*"] = {
      args = {
         {
            meta = "cmd"
         },
         {
            delims = {"[", "]"},
            meta = "num",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "default",
            optional = true
         },
         {
            meta = "definition"
         }
      }
   },
   ClassError = {
      args = {
         {
            meta = "class name"
         },
         {
            meta = "error text"
         },
         {
            meta = "help text"
         }
      }
   },
   ClassInfo = {
      args = {
         {
            meta = "class name"
         },
         {
            meta = "info text"
         }
      }
   },
   ClassInfoNoLine = {
      args = {
         {
            meta = "class name"
         },
         {
            meta = "info text"
         }
      }
   },
   ClassWarning = {
      args = {
         {
            meta = "class name"
         },
         {
            meta = "warning text"
         }
      }
   },
   ClassWarningNoLine = {
      args = {
         {
            meta = "class name"
         },
         {
            meta = "warning text"
         }
      }
   },
   DeclareOption = {
      args = {
         {
            meta = "option"
         },
         {
            meta = "code"
         }
      }
   },
   ["DeclareOption*"] = {
      args = {
         {
            meta = "code"
         }
      }
   },
   DeclareRobustCommand = {
      args = {
         {
            meta = "cmd"
         },
         {
            delims = {"[", "]"},
            meta = "num",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "default",
            optional = true
         },
         {
            meta = "definition"
         }
      }
   },
   ["DeclareRobustCommand*"] = {
      args = {
         {
            meta = "cmd"
         },
         {
            delims = {"[", "]"},
            meta = "num",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "default",
            optional = true
         },
         {
            meta = "definition"
         }
      }
   },
   ExecuteOptions = {
      args = {
         {
            meta = "options-list"
         }
      }
   },
   IfFileExists = {
      args = {
         {
            meta = "file name"
         },
         {
            meta = "true code"
         },
         {
            meta = "false code"
         }
      }
   },
   InputIfFileExists = {
      args = {
         {
            meta = "file name"
         },
         {
            meta = "true code"
         },
         {
            meta = "false code"
         }
      }
   },
   LoadClass = {
      args = {
         {
            delims = {"[", "]"},
            meta = "options list",
            optional = true
         },
         {
            meta = "class name"
         },
         {
            delims = {"[", "]"},
            meta = "release date",
            optional = true
         }
      }
   },
   LoadClassWithOptions = {
      args = {
         {
            meta = "class name"
         },
         {
            delims = {"[", "]"},
            meta = "release date",
            optional = true
         }
      }
   },
   MakeLowercase = {
      args = {
         {
            meta = "text"
         }
      }
   },
   MakeUppercase = {
      args = {
         {
            meta = "text"
         }
      }
   },
   NeedsTeXFormat = {
      args = {
         {
            meta = "format"
         },
         {
            delims = {"[", "]"},
            meta = "format date",
            optional = true
         }
      }
   },
   PackageError = {
      args = {
         {
            meta = "package name"
         },
         {
            meta = "error text"
         },
         {
            meta = "help text"
         }
      }
   },
   PackageInfo = {
      args = {
         {
            meta = "package name"
         },
         {
            meta = "info text"
         }
      }
   },
   PackageInfoNoLine = {
      args = {
         {
            meta = "package name"
         },
         {
            meta = "info text"
         }
      }
   },
   PackageWarning = {
      args = {
         {
            meta = "package name"
         },
         {
            meta = "warning text"
         }
      }
   },
   PackageWarningNoLine = {
      args = {
         {
            meta = "package name"
         },
         {
            meta = "warning text"
         }
      }
   },
   PassOptionsToClass = {
      args = {
         {
            meta = "option list"
         },
         {
            meta = "class name"
         }
      }
   },
   PassOptionsToPackage = {
      args = {
         {
            meta = "option list"
         },
         {
            meta = "package name"
         }
      }
   },
   ProvidesClass = {
      args = {
         {
            meta = "class name"
         },
         {
            delims = {"[", "]"},
            meta = "release date",
            optional = true
         }
      }
   },
   ProvidesFile = {
      args = {
         {
            meta = "file name"
         },
         {
            delims = {"[", "]"},
            meta = "additional information",
            optional = true
         }
      }
   },
   ProvidesPackage = {
      args = {
         {
            meta = "package name"
         },
         {
            delims = {"[", "]"},
            meta = "release date",
            optional = true
         }
      }
   },
   RequirePackage = {
      args = {
         {
            delims = {"[", "]"},
            meta = "option list",
            optional = true
         },
         {
            meta = "package name"
         },
         {
            delims = {"[", "]"},
            meta = "release date",
            optional = true
         }
      }
   },
   RequirePackageWithOptions = {
      args = {
         {
            meta = "package name"
         },
         {
            delims = {"[", "]"},
            meta = "release date",
            optional = true
         }
      }
   },
   Roman = {
      args = {
         {
            meta = "counter"
         }
      },
      doc = "Print value of a counter."
   },
   ["\\"] = {
      args = {
         {
            delims = {"[", "]"},
            meta = "morespace",
            optional = true
         }
      },
      doc = "Start a new line."
   },
   ["\\*"] = {
      args = {
         {
            delims = {"[", "]"},
            meta = "morespace",
            optional = true
         }
      }
   },
   addcontentsline = {
      args = {
         {
            meta = "ext"
         },
         {
            meta = "unit"
         },
         {
            meta = "text"
         }
      },
      doc = "Add an entry to table of contents, etc."
   },
   address = {
      doc = "Sender's return address."
   },
   addtocontents = {
      doc = "Add text directly to table of contents file, etc."
   },
   addtocounter = {
      args = {
         {
            meta = "counter"
         },
         {
            meta = "value"
         }
      },
      doc = "Add a quantity to a counter."
   },
   addtolength = {
      args = {
         {
            meta = "\\len"
         },
         {
            meta = "amount"
         }
      },
      doc = "Add a quantity to a length."
   },
   addvspace = {
      doc = "Add arbitrary vertical space if needed."
   },
   alph = {
      args = {
         {
            meta = "counter"
         }
      },
      doc = "Print value of a counter."
   },
   arabic = {
      args = {
         {
            meta = "counter"
         }
      },
      doc = "Print value of a counter."
   },
   author = {
      args = {
         {
            meta = "names"
         }
      }
   },
   bibitem = {
      args = {
         {
            delims = {"[", "]"},
            meta = "label",
            optional = true
         },
         {
            meta = "cite_key"
         }
      },
      doc = "Specify a bibliography item."
   },
   bibliography = {
      args = {
         {
            meta = "bibfiles"
         }
      }
   },
   bibliographystyle = {
      args = {
         {
            meta = "bibstyle"
         }
      }
   },
   bigskip = {
      doc = "Big vertical space."
   },
   caption = {
      args = {
         {
            delims = {"[", "]"},
            meta = "loftitle",
            optional = true
         },
         {
            meta = "title"
         }
      }
   },
   centering = {
      doc = "Declaration form of the {center} environment."
   },
   chapter = {
      args = {
         {
            delims = {"[", "]"},
            meta = "toctitle",
            optional = true
         },
         {
            meta = "title"
         }
      }
   },
   circle = {
      args = {
         {
            meta = "diameter"
         }
      },
      doc = "Draw a circle."
   },
   cite = {
      args = {
         {
            delims = {"[", "]"},
            meta = "subcite",
            optional = true
         },
         {
            meta = "keys"
         }
      },
      doc = "Refer to a bibliography item."
   },
   cleardoublepage = {
      doc = "Start a new right-hand page."
   },
   clearpage = {
      doc = "Start a new page."
   },
   cline = {
      args = {
         {
            meta = "i-j"
         }
      },
      doc = "Draw a horizontal line spanning some columns."
   },
   closing = {
      doc = "Saying goodbye."
   },
   dashbox = {
      args = {
         {
            meta = "dlen"
         },
         {
            delims = {"(", ")"},
            meta = "rwidth, rheight"
         },
         {
            delims = {"[", "]"},
            meta = "pos",
            optional = true
         },
         {
            meta = "text"
         }
      },
      doc = "Draw a dashed box."
   },
   date = {
      args = {
         {
            meta = "text"
         }
      }
   },
   day = {
      doc = "Today's day"
   },
   discretionary = {
      args = {
         {
            meta = "pre-break-text"
         },
         {
            meta = "post-break-text"
         },
         {
            meta = "no-break-text"
         }
      },
      doc = "Insert explicit hyphenation with control of hyphen character."
   },
   documentclass = {
      args = {
         {
            delims = {"[", "]"},
            meta = "options",
            optional = true
         },
         {
            meta = "class"
         }
      }
   },
   dotfill = {
      doc = "Stretchable horizontal dots."
   },
   encl = {
      doc = "List of enclosed material."
   },
   enlargethispage = {
      doc = "Enlarge the current page a bit."
   },
   ensuremath = {
      args = {
         {
            meta = "formula"
         }
      },
      doc = "Ensure that math mode is active"
   },
   fbox = {
      args = {
         {
            meta = "text"
         }
      },
      doc = "Put a frame around a box."
   },
   flushbottom = {
      doc = "Make all text pages the same height."
   },
   fnsymbol = {
      args = {
         {
            meta = "counter"
         }
      },
      doc = "Print value of a counter."
   },
   fontencoding = {
      args = {
         {
            meta = "encoding"
         }
      }
   },
   fontfamily = {
      args = {
         {
            meta = "family"
         }
      }
   },
   fontseries = {
      args = {
         {
            meta = "series"
         }
      }
   },
   fontshape = {
      args = {
         {
            meta = "shape"
         }
      }
   },
   fontsize = {
      args = {
         {
            meta = "size"
         },
         {
            meta = "skip"
         }
      }
   },
   footnote = {
      args = {
         {
            delims = {"[", "]"},
            meta = "number",
            optional = true
         },
         {
            meta = "text"
         }
      },
      doc = "Insert a footnote."
   },
   footnotemark = {
      args = {
         {
            delims = {"[", "]"},
            meta = "number",
            optional = true
         }
      },
      doc = "Insert footnote mark only."
   },
   footnotetext = {
      args = {
         {
            delims = {"[", "]"},
            meta = "number",
            optional = true
         },
         {
            meta = "text"
         }
      },
      doc = "Insert footnote text only."
   },
   frac = {
      args = {
         {
            meta = "num"
         },
         {
            meta = "den"
         }
      }
   },
   frame = {
      args = {
         {
            meta = "text"
         }
      },
      doc = "Draw a frame around an object."
   },
   framebox = {
      args = {
         {
            delims = {"[", "]"},
            meta = "width",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "position",
            optional = true
         },
         {
            meta = "text"
         }
      },
      doc = "Draw a box with a frame around it."
   },
   frenchspacing = {
      doc = "Equal interword and inter-sentence space."
   },
   fussy = {
      doc = "Be fussy about line breaking."
   },
   hfill = {
      doc = "Stretchable horizontal space.  "
   },
   hline = {
      doc = "Draw a horizontal line spanning all columns."
   },
   hrulefill = {
      doc = "Stretchable horizontal rule."
   },
   hspace = {
      args = {
         {
            meta = "length"
         }
      },
      doc = "Fixed horizontal space.  "
   },
   ["hspace*"] = {
      args = {
         {
            meta = "length"
         }
      }
   },
   hyphenation = {
      args = {
         {
            meta = "words"
         }
      },
      doc = "Tell LaTeX how to hyphenate a word."
   },
   include = {
      args = {
         {
            meta = "file"
         }
      },
      doc = "Conditionally include a file."
   },
   includeonly = {
      args = {
         {
            meta = "files"
         }
      },
      doc = "Determine which files are included."
   },
   indent = {
      doc = "Indent this paragraph."
   },
   input = {
      args = {
         {
            meta = "file"
         }
      },
      doc = "Unconditionally include a file."
   },
   item = {
      args = {
         {
            delims = {"[", "]"},
            meta = "optional label",
            optional = true
         }
      },
      doc = "An entry in a list."
   },
   label = {
      args = {
         {
            meta = "key"
         }
      },
      doc = "Assign a symbolic name to a piece of text."
   },
   line = {
      args = {
         {
            delims = {"(", ")"},
            meta = "xslope, yslope"
         },
         {
            meta = "length"
         }
      },
      doc = "Draw a straight line."
   },
   linebreak = {
      args = {
         {
            delims = {"[", "]"},
            meta = "priority",
            optional = true
         }
      },
      doc = "Force line break."
   },
   linespread = {
      args = {
         {
            meta = "factor"
         }
      }
   },
   linethickness = {
      doc = "Set the line thickness."
   },
   location = {
      doc = "Sender's organizational location."
   },
   lowercase = {
      args = {
         {
            meta = "text"
         }
      }
   },
   makeatletter = {
      doc = "Change the status of the at-sign character."
   },
   makeatother = {
      doc = "Change the status of the at-sign character."
   },
   makebox = {
      args = {
         {
            delims = {"[", "]"},
            meta = "width",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "position",
            optional = true
         },
         {
            meta = "text"
         }
      },
      doc = "Box, adjustable position."
   },
   makelabels = {
      doc = "Make address labels."
   },
   maketitle = {
      doc = "Generate a title page."
   },
   marginpar = {
      args = {
         {
            delims = {"[", "]"},
            meta = "left",
            optional = true
         },
         {
            meta = "right"
         }
      }
   },
   markboth = {
      args = {
         {
            meta = "left"
         },
         {
            meta = "right"
         }
      }
   },
   markright = {
      args = {
         {
            meta = "right"
         }
      }
   },
   mbox = {
      args = {
         {
            meta = "text"
         }
      },
      doc = "Horizontal boxes."
   },
   medskip = {
      doc = "Medium vertical space."
   },
   month = {
      doc = "Today's month"
   },
   multicolumn = {
      args = {
         {
            meta = "numcols"
         },
         {
            meta = "cols"
         },
         {
            meta = "text"
         }
      },
      doc = "Make an item spanning several columns."
   },
   multiput = {
      args = {
         {
            delims = {"(", ")"},
            meta = "x, y"
         },
         {
            delims = {"(", ")"},
            meta = "delta_x, delta_y"
         },
         {
            meta = "n"
         },
         {
            meta = "obj"
         }
      },
      doc = "Draw multiple instances of an object."
   },
   name = {
      doc = "Sender's name, for the return address."
   },
   newcommand = {
      doc = "Define a new command"
   },
   newcounter = {
      args = {
         {
            meta = "countername"
         },
         {
            delims = {"[", "]"},
            meta = "supercounter",
            optional = true
         }
      },
      doc = "Define a new counter."
   },
   newenvironment = {
      doc = "Define a new environment."
   },
   newfont = {
      args = {
         {
            meta = "\\cmd"
         },
         {
            meta = "font description"
         }
      },
      doc = "Define a new font name."
   },
   newlength = {
      args = {
         {
            meta = "\\arg"
         }
      },
      doc = "Define a new length."
   },
   newline = {
      doc = "Break the line"
   },
   newpage = {
      doc = "Start a new page."
   },
   newsavebox = {
      args = {
         {
            meta = "\\cmd"
         }
      },
      doc = "Define a new box."
   },
   newtheorem = {
      args = {
         {
            meta = "name"
         },
         {
            delims = {"[", "]"},
            meta = "numbered_like",
            optional = true
         },
         {
            meta = "title"
         }
      },
      doc = "Define a new theorem-like environment."
   },
   nocite = {
      doc = "Include an item in the bibliography."
   },
   noindent = {
      doc = "Do not indent this paragraph."
   },
   nolinebreak = {
      args = {
         {
            delims = {"[", "]"},
            meta = "priority",
            optional = true
         }
      },
      doc = "Avoid line break."
   },
   nopagebreak = {
      args = {
         {
            delims = {"[", "]"},
            meta = "priority",
            optional = true
         }
      },
      doc = "Avoid page break."
   },
   obeycr = {
      doc = "Make each input line start a new output line."
   },
   onecolumn = {
      doc = "Use one-column layout."
   },
   opening = {
      doc = "Saying hello."
   },
   oval = {
      args = {
         {
            delims = {"(", ")"},
            meta = "width, height"
         },
         {
            delims = {"[", "]"},
            meta = "portion",
            optional = true
         }
      },
      doc = "Draw an ellipse."
   },
   overbrace = {
      args = {
         {
            meta = "math"
         }
      }
   },
   overline = {
      args = {
         {
            meta = "text"
         }
      }
   },
   pagebreak = {
      args = {
         {
            delims = {"[", "]"},
            meta = "priority",
            optional = true
         }
      },
      doc = "Force page break"
   },
   pagenumbering = {
      args = {
         {
            meta = "style"
         }
      },
      doc = "Set the style used for page numbers."
   },
   pageref = {
      args = {
         {
            meta = "key"
         }
      },
      doc = "Refer to a page number."
   },
   pagestyle = {
      args = {
         {
            meta = "style"
         }
      },
      doc = "Change the headings/footings style."
   },
   parbox = {
      args = {
         {
            delims = {"[", "]"},
            meta = "position",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "height",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "inner-pos",
            optional = true
         },
         {
            meta = "width"
         },
         {
            meta = "text"
         }
      },
      doc = "Box with text in paragraph mode."
   },
   parskip = {
      doc = "Space added before paragraphs."
   },
   protect = {
      doc = "Using tricky commands."
   },
   providecommand = {
      args = {
         {
            meta = "cmd"
         },
         {
            delims = {"[", "]"},
            meta = "nargs",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "optargdefault",
            optional = true
         },
         {
            meta = "defn"
         }
      },
      doc = "Define a new command, if name not used."
   },
   ["providecommand*"] = {
      args = {
         {
            meta = "cmd"
         },
         {
            delims = {"[", "]"},
            meta = "nargs",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "optargdefault",
            optional = true
         },
         {
            meta = "defn"
         }
      }
   },
   ps = {
      doc = "Adding a postscript."
   },
   put = {
      args = {
         {
            delims = {"(", ")"},
            meta = "xcoord, ycoord"
         }
      },
      doc = "Place an object at a specified place."
   },
   raggedbottom = {
      doc = "Allow text pages of differing height."
   },
   raggedleft = {
      doc = "Declaration form of the {flushright} environment."
   },
   raggedright = {
      doc = "Declaration form of the {flushleft} environment."
   },
   raisebox = {
      args = {
         {
            meta = "distance"
         },
         {
            delims = {"[", "]"},
            meta = "height",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "depth",
            optional = true
         },
         {
            meta = "text"
         }
      },
      doc = "Raise or lower text."
   },
   ref = {
      args = {
         {
            meta = "key"
         }
      },
      doc = "Refer to a section, figure or similar."
   },
   refstepcounter = {
      args = {
         {
            meta = "counter"
         }
      },
      doc = "Add to a counter."
   },
   renewcommand = {
      args = {
         {
            meta = "\\cmd"
         },
         {
            delims = {"[", "]"},
            meta = "nargs",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "optargdefault",
            optional = true
         },
         {
            meta = "defn"
         }
      },
      doc = "Redefine a command."
   },
   ["renewcommand*"] = {
      args = {
         {
            meta = "\\cmd"
         },
         {
            delims = {"[", "]"},
            meta = "nargs",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "optargdefault",
            optional = true
         },
         {
            meta = "defn"
         }
      }
   },
   renewenvironment = {
      doc = "Refine an environment."
   },
   ["renewenvironment*"] = {
      args = {
         {
            meta = "env"
         },
         {
            delims = {"[", "]"},
            meta = "nargs",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "optargdefault",
            optional = true
         },
         {
            meta = "begdefn"
         },
         {
            meta = "enddefn"
         }
      }
   },
   restorecr = {
      doc = "Make each input line start a new output line."
   },
   roman = {
      args = {
         {
            meta = "counter"
         }
      },
      doc = "Print value of a counter."
   },
   rule = {
      args = {
         {
            delims = {"[", "]"},
            meta = "raise",
            optional = true
         },
         {
            meta = "width"
         },
         {
            meta = "thickness"
         }
      },
      doc = "Inserting lines and rectangles."
   },
   savebox = {
      args = {
         {
            meta = "\\boxcmd"
         },
         {
            delims = {"[", "]"},
            meta = "width",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "pos",
            optional = true
         },
         {
            meta = "text"
         }
      },
      doc = "Like \\makebox, but save the text for later use."
   },
   sbox = {
      args = {
         {
            meta = "\\boxcmd"
         },
         {
            meta = "text"
         }
      },
      doc = "Like \\mbox, but save the text for later use."
   },
   setcounter = {
      args = {
         {
            meta = "counter"
         },
         {
            meta = "value"
         }
      },
      doc = "Set the value of a counter."
   },
   setlength = {
      args = {
         {
            meta = "\\len"
         },
         {
            meta = "amount"
         }
      },
      doc = "Set the value of a length."
   },
   settodepth = {
      args = {
         {
            meta = "\\len"
         },
         {
            meta = "text"
         }
      },
      doc = "Set a length to the depth of something."
   },
   settoheight = {
      args = {
         {
            meta = "\\len"
         }
      },
      doc = "Set a length to the height of something."
   },
   settowidth = {
      args = {
         {
            meta = "\\len"
         },
         {
            meta = "text"
         }
      },
      doc = "Set a length to the width of something."
   },
   shortstack = {
      args = {
         {
            delims = {"[", "]"},
            meta = "position",
            optional = true
         }
      },
      doc = "Make a pile of objects."
   },
   signature = {
      doc = "Sender's signature."
   },
   sloppy = {
      doc = "Be sloppy about line breaking."
   },
   smallskip = {
      doc = "Small vertical space."
   },
   sqrt = {
      args = {
         {
            delims = {"[", "]"},
            meta = "root",
            optional = true
         },
         {
            meta = "arg"
         }
      }
   },
   stackrel = {
      args = {
         {
            meta = "text"
         },
         {
            meta = "relation"
         }
      }
   },
   stepcounter = {
      args = {
         {
            meta = "counter"
         }
      },
      doc = "Add to a counter, resetting subsidiary counters."
   },
   telephone = {
      doc = "Sender's phone number."
   },
   textcircled = {
      args = {
         {
            meta = "letter"
         }
      }
   },
   thanks = {
      args = {
         {
            meta = "text"
         }
      }
   },
   thicklines = {
      doc = "A heavier line thickness."
   },
   thinlines = {
      doc = "The default line thickness."
   },
   thinspace = {
      doc = "One-sixth of an em.  "
   },
   thispagestyle = {
      args = {
         {
            meta = "style"
         }
      },
      doc = "Change the headings/footings style for this page."
   },
   title = {
      args = {
         {
            meta = "text"
         }
      }
   },
   today = {
      doc = "Inserting today's date."
   },
   twocolumn = {
      args = {
         {
            delims = {"[", "]"},
            meta = "prelim one column text",
            optional = true
         }
      },
      doc = "Use two-column layout."
   },
   typein = {
      args = {
         {
            delims = {"[", "]"},
            meta = "\\cmd",
            optional = true
         },
         {
            meta = "msg"
         }
      },
      doc = "Read text from the terminal."
   },
   typeout = {
      args = {
         {
            meta = "msg"
         }
      },
      doc = "Write text to the terminal."
   },
   underbrace = {
      args = {
         {
            meta = "math"
         }
      }
   },
   underline = {
      args = {
         {
            meta = "text"
         }
      }
   },
   uppercase = {
      args = {
         {
            meta = "text"
         }
      }
   },
   usebox = {
      args = {
         {
            meta = "\\boxcmd"
         }
      },
      doc = "Print saved text."
   },
   usecounter = {
      args = {
         {
            meta = "counter"
         }
      },
      doc = "Use a specified counter in a list environment."
   },
   usefont = {
      args = {
         {
            meta = "enc"
         },
         {
            meta = "family"
         },
         {
            meta = "series"
         },
         {
            meta = "shape"
         }
      }
   },
   usepackage = {
      args = {
         {
            delims = {"[", "]"},
            meta = "options",
            optional = true
         },
         {
            meta = "pkg"
         }
      }
   },
   value = {
      args = {
         {
            meta = "counter"
         }
      },
      doc = "Use the value of a counter in an expression.  "
   },
   vector = {
      args = {
         {
            delims = {"(", ")"},
            meta = "xslope, yslope"
         },
         {
            meta = "length"
         }
      },
      doc = "Draw a line with an arrow."
   },
   verb = {
      doc = "The macro form of the {verbatim} environment."
   },
   vfill = {
      doc = "Infinitely stretchable vertical space."
   },
   vline = {
      doc = "Draw a vertical line."
   },
   vspace = {
      args = {
         {
            meta = "length"
         }
      },
      doc = "Add arbitrary vertical space."
   },
   ["vspace*"] = {
      args = {
         {
            meta = "length"
         }
      }
   },
   year = {
      doc = "Today's year"
   }
}

environments = {
   abstract = {
      doc = "Produce an abstract."
   },
   array = {
      args = {
         {
            delims = {"[", "]"},
            meta = "pos",
            optional = true
         },
         {
            meta = "cols"
         }
      },
      doc = "Math arrays."
   },
   center = {
      doc = "Centered lines."
   },
   description = {
      doc = "Labelled lists."
   },
   displaymath = {
      doc = "Formulas that appear on their own line."
   },
   document = {
      doc = "Enclose the whole document."
   },
   enumerate = {
      doc = "Numbered lists."
   },
   eqnarray = {
      doc = "Sequences of aligned equations."
   },
   equation = {
      doc = "Displayed equation."
   },
   figure = {
      args = {
         {
            delims = {"[", "]"},
            meta = "placement",
            optional = true
         }
      },
      doc = "Floating figures."
   },
   ["figure*"] = {
      args = {
         {
            delims = {"[", "]"},
            meta = "placement",
            optional = true
         }
      }
   },
   filecontents = {
      args = {
         {
            meta = "filename"
         }
      },
      doc = "Writing multiple files from the source."
   },
   ["filecontents*"] = {
      args = {
         {
            meta = "filename"
         }
      }
   },
   flushleft = {
      doc = "Flushed left lines."
   },
   flushright = {
      doc = "Flushed right lines."
   },
   itemize = {
      doc = "Bulleted lists."
   },
   letter = {
      doc = "Letters."
   },
   list = {
      args = {
         {
            meta = "labeling"
         },
         {
            meta = "spacing"
         }
      },
      doc = "Generic list environment."
   },
   lrbox = {
      args = {
         {
            meta = "\\cmd"
         }
      },
      doc = "An environment like \\sbox."
   },
   math = {
      doc = "In-line math."
   },
   minipage = {
      args = {
         {
            delims = {"[", "]"},
            meta = "position",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "height",
            optional = true
         },
         {
            delims = {"[", "]"},
            meta = "inner-pos",
            optional = true
         },
         {
            meta = "width"
         }
      },
      doc = "Miniature page."
   },
   picture = {
      args = {
         {
            delims = {"(", ")"},
            meta = "width, height"
         },
         {
            delims = {"(", ")"},
            meta = "xoffset, yoffset"
         }
      },
      doc = "Picture with text, arrows, lines and circles."
   },
   quotation = {
      doc = "Include a quotation."
   },
   quote = {
      doc = "Include a quotation."
   },
   tabbing = {
      doc = "Align text arbitrarily."
   },
   table = {
      args = {
         {
            delims = {"[", "]"},
            meta = "placement",
            optional = true
         }
      },
      doc = "Floating tables."
   },
   tabular = {
      args = {
         {
            delims = {"[", "]"},
            meta = "pos",
            optional = true
         },
         {
            meta = "cols"
         }
      },
      doc = "Align text in columns."
   },
   ["tabular*"] = {
      args = {
         {
            meta = "width"
         },
         {
            delims = {"[", "]"},
            meta = "pos",
            optional = true
         },
         {
            meta = "cols"
         }
      }
   },
   thebibliography = {
      args = {
         {
            meta = "widest-label"
         }
      },
      doc = "Bibliography or reference list."
   },
   theorem = {
      doc = "Theorems, lemmas, etc."
   },
   titlepage = {
      doc = "For hand crafted title pages."
   },
   verbatim = {
      doc = "Simulating typed input."
   },
   verse = {
      doc = "For poetry and other things."
   }
}
