module = "latex-latexrefman"

source = {
  name = "LaTeX2e Unofficial Reference Manual",
  url = "https://latexref.xyz/",
  license = "https://gnu.org/licenses/fdl.html"
}

commands = {
   ["-"] = {
      summary = "Insert explicit hyphenation."
   },
   ["/"] = {
      summary = "Insert italic correction."
   },
   ["@ifstar"] = {
      summary = "Define your own commands with *-variants."
   },
   ["@startsection"] = {
      arguments = {
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
      summary = "Redefine layout of start of sections, subsections, etc."
   },
   Alph = {
      arguments = {
         {
            meta = "counter"
         }
      },
      summary = "Print value of a counter."
   },
   AtBeginDocument = {
      arguments = {
         {
            meta = "code"
         }
      },
      summary = "Hook for commands at the start of the document."
   },
   AtEndDocument = {
      arguments = {
         {
            meta = "code"
         }
      },
      summary = "Hook for commands at the end of the document."
   },
   AtEndOfClass = {
      arguments = {
         {
            meta = "code"
         }
      }
   },
   AtEndOfPackage = {
      arguments = {
         {
            meta = "code"
         }
      }
   },
   CheckCommand = {
      arguments = {
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
      arguments = {
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
      arguments = {
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
      arguments = {
         {
            meta = "class name"
         },
         {
            meta = "info text"
         }
      }
   },
   ClassInfoNoLine = {
      arguments = {
         {
            meta = "class name"
         },
         {
            meta = "info text"
         }
      }
   },
   ClassWarning = {
      arguments = {
         {
            meta = "class name"
         },
         {
            meta = "warning text"
         }
      }
   },
   ClassWarningNoLine = {
      arguments = {
         {
            meta = "class name"
         },
         {
            meta = "warning text"
         }
      }
   },
   DeclareOption = {
      arguments = {
         {
            meta = "option"
         },
         {
            meta = "code"
         }
      }
   },
   ["DeclareOption*"] = {
      arguments = {
         {
            meta = "code"
         }
      }
   },
   DeclareRobustCommand = {
      arguments = {
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
      arguments = {
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
      arguments = {
         {
            meta = "options-list"
         }
      }
   },
   IfFileExists = {
      arguments = {
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
      arguments = {
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
      arguments = {
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
      arguments = {
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
      arguments = {
         {
            meta = "text"
         }
      }
   },
   MakeUppercase = {
      arguments = {
         {
            meta = "text"
         }
      }
   },
   NeedsTeXFormat = {
      arguments = {
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
      arguments = {
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
      arguments = {
         {
            meta = "package name"
         },
         {
            meta = "info text"
         }
      }
   },
   PackageInfoNoLine = {
      arguments = {
         {
            meta = "package name"
         },
         {
            meta = "info text"
         }
      }
   },
   PackageWarning = {
      arguments = {
         {
            meta = "package name"
         },
         {
            meta = "warning text"
         }
      }
   },
   PackageWarningNoLine = {
      arguments = {
         {
            meta = "package name"
         },
         {
            meta = "warning text"
         }
      }
   },
   PassOptionsToClass = {
      arguments = {
         {
            meta = "option list"
         },
         {
            meta = "class name"
         }
      }
   },
   PassOptionsToPackage = {
      arguments = {
         {
            meta = "option list"
         },
         {
            meta = "package name"
         }
      }
   },
   ProvidesClass = {
      arguments = {
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
      arguments = {
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
      arguments = {
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
      arguments = {
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
      arguments = {
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
      arguments = {
         {
            meta = "counter"
         }
      },
      summary = "Print value of a counter."
   },
   ["\\"] = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "morespace",
            optional = true
         }
      },
      summary = "Start a new line."
   },
   ["\\*"] = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "morespace",
            optional = true
         }
      }
   },
   addcontentsline = {
      arguments = {
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
      summary = "Add an entry to table of contents, etc."
   },
   address = {
      summary = "Sender's return address."
   },
   addtocontents = {
      summary = "Add text directly to table of contents file, etc."
   },
   addtocounter = {
      arguments = {
         {
            meta = "counter"
         },
         {
            meta = "value"
         }
      },
      summary = "Add a quantity to a counter."
   },
   addtolength = {
      arguments = {
         {
            meta = "\\len"
         },
         {
            meta = "amount"
         }
      },
      summary = "Add a quantity to a length."
   },
   addvspace = {
      summary = "Add arbitrary vertical space if needed."
   },
   alph = {
      arguments = {
         {
            meta = "counter"
         }
      },
      summary = "Print value of a counter."
   },
   arabic = {
      arguments = {
         {
            meta = "counter"
         }
      },
      summary = "Print value of a counter."
   },
   author = {
      arguments = {
         {
            meta = "names"
         }
      }
   },
   bibitem = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "label",
            optional = true
         },
         {
            meta = "cite_key"
         }
      },
      summary = "Specify a bibliography item."
   },
   bibliography = {
      arguments = {
         {
            meta = "bibfiles"
         }
      }
   },
   bibliographystyle = {
      arguments = {
         {
            meta = "bibstyle"
         }
      }
   },
   bigskip = {
      summary = "Big vertical space."
   },
   caption = {
      arguments = {
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
      summary = "Declaration form of the {center} environment."
   },
   chapter = {
      arguments = {
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
      arguments = {
         {
            meta = "diameter"
         }
      },
      summary = "Draw a circle."
   },
   cite = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "subcite",
            optional = true
         },
         {
            meta = "keys"
         }
      },
      summary = "Refer to a bibliography item."
   },
   cleardoublepage = {
      summary = "Start a new right-hand page."
   },
   clearpage = {
      summary = "Start a new page."
   },
   cline = {
      arguments = {
         {
            meta = "i-j"
         }
      },
      summary = "Draw a horizontal line spanning some columns."
   },
   closing = {
      summary = "Saying goodbye."
   },
   dashbox = {
      arguments = {
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
      summary = "Draw a dashed box."
   },
   date = {
      arguments = {
         {
            meta = "text"
         }
      }
   },
   day = {
      summary = "Today's day"
   },
   discretionary = {
      arguments = {
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
      summary = "Insert explicit hyphenation with control of hyphen character."
   },
   documentclass = {
      arguments = {
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
      summary = "Stretchable horizontal dots."
   },
   encl = {
      summary = "List of enclosed material."
   },
   enlargethispage = {
      summary = "Enlarge the current page a bit."
   },
   ensuremath = {
      arguments = {
         {
            meta = "formula"
         }
      },
      summary = "Ensure that math mode is active"
   },
   fbox = {
      arguments = {
         {
            meta = "text"
         }
      },
      summary = "Put a frame around a box."
   },
   flushbottom = {
      summary = "Make all text pages the same height."
   },
   fnsymbol = {
      arguments = {
         {
            meta = "counter"
         }
      },
      summary = "Print value of a counter."
   },
   fontencoding = {
      arguments = {
         {
            meta = "encoding"
         }
      }
   },
   fontfamily = {
      arguments = {
         {
            meta = "family"
         }
      }
   },
   fontseries = {
      arguments = {
         {
            meta = "series"
         }
      }
   },
   fontshape = {
      arguments = {
         {
            meta = "shape"
         }
      }
   },
   fontsize = {
      arguments = {
         {
            meta = "size"
         },
         {
            meta = "skip"
         }
      }
   },
   footnote = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "number",
            optional = true
         },
         {
            meta = "text"
         }
      },
      summary = "Insert a footnote."
   },
   footnotemark = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "number",
            optional = true
         }
      },
      summary = "Insert footnote mark only."
   },
   footnotetext = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "number",
            optional = true
         },
         {
            meta = "text"
         }
      },
      summary = "Insert footnote text only."
   },
   frac = {
      arguments = {
         {
            meta = "num"
         },
         {
            meta = "den"
         }
      }
   },
   frame = {
      arguments = {
         {
            meta = "text"
         }
      },
      summary = "Draw a frame around an object."
   },
   framebox = {
      arguments = {
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
      summary = "Draw a box with a frame around it."
   },
   frenchspacing = {
      summary = "Equal interword and inter-sentence space."
   },
   fussy = {
      summary = "Be fussy about line breaking."
   },
   hfill = {
      summary = "Stretchable horizontal space.  "
   },
   hline = {
      summary = "Draw a horizontal line spanning all columns."
   },
   hrulefill = {
      summary = "Stretchable horizontal rule."
   },
   hspace = {
      arguments = {
         {
            meta = "length"
         }
      },
      summary = "Fixed horizontal space.  "
   },
   ["hspace*"] = {
      arguments = {
         {
            meta = "length"
         }
      }
   },
   hyphenation = {
      arguments = {
         {
            meta = "words"
         }
      },
      summary = "Tell LaTeX how to hyphenate a word."
   },
   include = {
      arguments = {
         {
            meta = "file"
         }
      },
      summary = "Conditionally include a file."
   },
   includeonly = {
      arguments = {
         {
            meta = "files"
         }
      },
      summary = "Determine which files are included."
   },
   indent = {
      summary = "Indent this paragraph."
   },
   input = {
      arguments = {
         {
            meta = "file"
         }
      },
      summary = "Unconditionally include a file."
   },
   item = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "optional label",
            optional = true
         }
      },
      summary = "An entry in a list."
   },
   label = {
      arguments = {
         {
            meta = "key"
         }
      },
      summary = "Assign a symbolic name to a piece of text."
   },
   line = {
      arguments = {
         {
            delims = {"(", ")"},
            meta = "xslope, yslope"
         },
         {
            meta = "length"
         }
      },
      summary = "Draw a straight line."
   },
   linebreak = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "priority",
            optional = true
         }
      },
      summary = "Force line break."
   },
   linespread = {
      arguments = {
         {
            meta = "factor"
         }
      }
   },
   linethickness = {
      summary = "Set the line thickness."
   },
   location = {
      summary = "Sender's organizational location."
   },
   lowercase = {
      arguments = {
         {
            meta = "text"
         }
      }
   },
   makeatletter = {
      summary = "Change the status of the at-sign character."
   },
   makeatother = {
      summary = "Change the status of the at-sign character."
   },
   makebox = {
      arguments = {
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
      summary = "Box, adjustable position."
   },
   makelabels = {
      summary = "Make address labels."
   },
   maketitle = {
      summary = "Generate a title page."
   },
   marginpar = {
      arguments = {
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
      arguments = {
         {
            meta = "left"
         },
         {
            meta = "right"
         }
      }
   },
   markright = {
      arguments = {
         {
            meta = "right"
         }
      }
   },
   mbox = {
      arguments = {
         {
            meta = "text"
         }
      },
      summary = "Horizontal boxes."
   },
   medskip = {
      summary = "Medium vertical space."
   },
   month = {
      summary = "Today's month"
   },
   multicolumn = {
      arguments = {
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
      summary = "Make an item spanning several columns."
   },
   multiput = {
      arguments = {
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
      summary = "Draw multiple instances of an object."
   },
   name = {
      summary = "Sender's name, for the return address."
   },
   newcommand = {
      summary = "Define a new command"
   },
   newcounter = {
      arguments = {
         {
            meta = "countername"
         },
         {
            delims = {"[", "]"},
            meta = "supercounter",
            optional = true
         }
      },
      summary = "Define a new counter."
   },
   newenvironment = {
      summary = "Define a new environment."
   },
   newfont = {
      arguments = {
         {
            meta = "\\cmd"
         },
         {
            meta = "font description"
         }
      },
      summary = "Define a new font name."
   },
   newlength = {
      arguments = {
         {
            meta = "\\arg"
         }
      },
      summary = "Define a new length."
   },
   newline = {
      summary = "Break the line"
   },
   newpage = {
      summary = "Start a new page."
   },
   newsavebox = {
      arguments = {
         {
            meta = "\\cmd"
         }
      },
      summary = "Define a new box."
   },
   newtheorem = {
      arguments = {
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
      summary = "Define a new theorem-like environment."
   },
   nocite = {
      summary = "Include an item in the bibliography."
   },
   noindent = {
      summary = "Do not indent this paragraph."
   },
   nolinebreak = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "priority",
            optional = true
         }
      },
      summary = "Avoid line break."
   },
   nopagebreak = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "priority",
            optional = true
         }
      },
      summary = "Avoid page break."
   },
   obeycr = {
      summary = "Make each input line start a new output line."
   },
   onecolumn = {
      summary = "Use one-column layout."
   },
   opening = {
      summary = "Saying hello."
   },
   oval = {
      arguments = {
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
      summary = "Draw an ellipse."
   },
   overbrace = {
      arguments = {
         {
            meta = "math"
         }
      }
   },
   overline = {
      arguments = {
         {
            meta = "text"
         }
      }
   },
   pagebreak = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "priority",
            optional = true
         }
      },
      summary = "Force page break"
   },
   pagenumbering = {
      arguments = {
         {
            meta = "style"
         }
      },
      summary = "Set the style used for page numbers."
   },
   pageref = {
      arguments = {
         {
            meta = "key"
         }
      },
      summary = "Refer to a page number."
   },
   pagestyle = {
      arguments = {
         {
            meta = "style"
         }
      },
      summary = "Change the headings/footings style."
   },
   parbox = {
      arguments = {
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
      summary = "Box with text in paragraph mode."
   },
   parskip = {
      summary = "Space added before paragraphs."
   },
   protect = {
      summary = "Using tricky commands."
   },
   providecommand = {
      arguments = {
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
      summary = "Define a new command, if name not used."
   },
   ["providecommand*"] = {
      arguments = {
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
      summary = "Adding a postscript."
   },
   put = {
      arguments = {
         {
            delims = {"(", ")"},
            meta = "xcoord, ycoord"
         }
      },
      summary = "Place an object at a specified place."
   },
   raggedbottom = {
      summary = "Allow text pages of differing height."
   },
   raggedleft = {
      summary = "Declaration form of the {flushright} environment."
   },
   raggedright = {
      summary = "Declaration form of the {flushleft} environment."
   },
   raisebox = {
      arguments = {
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
      summary = "Raise or lower text."
   },
   ref = {
      arguments = {
         {
            meta = "key"
         }
      },
      summary = "Refer to a section, figure or similar."
   },
   refstepcounter = {
      arguments = {
         {
            meta = "counter"
         }
      },
      summary = "Add to a counter."
   },
   renewcommand = {
      arguments = {
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
      summary = "Redefine a command."
   },
   ["renewcommand*"] = {
      arguments = {
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
      summary = "Refine an environment."
   },
   ["renewenvironment*"] = {
      arguments = {
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
      summary = "Make each input line start a new output line."
   },
   roman = {
      arguments = {
         {
            meta = "counter"
         }
      },
      summary = "Print value of a counter."
   },
   rule = {
      arguments = {
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
      summary = "Inserting lines and rectangles."
   },
   savebox = {
      arguments = {
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
      summary = "Like \\makebox, but save the text for later use."
   },
   sbox = {
      arguments = {
         {
            meta = "\\boxcmd"
         },
         {
            meta = "text"
         }
      },
      summary = "Like \\mbox, but save the text for later use."
   },
   setcounter = {
      arguments = {
         {
            meta = "counter"
         },
         {
            meta = "value"
         }
      },
      summary = "Set the value of a counter."
   },
   setlength = {
      arguments = {
         {
            meta = "\\len"
         },
         {
            meta = "amount"
         }
      },
      summary = "Set the value of a length."
   },
   settodepth = {
      arguments = {
         {
            meta = "\\len"
         },
         {
            meta = "text"
         }
      },
      summary = "Set a length to the depth of something."
   },
   settoheight = {
      arguments = {
         {
            meta = "\\len"
         }
      },
      summary = "Set a length to the height of something."
   },
   settowidth = {
      arguments = {
         {
            meta = "\\len"
         },
         {
            meta = "text"
         }
      },
      summary = "Set a length to the width of something."
   },
   shortstack = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "position",
            optional = true
         }
      },
      summary = "Make a pile of objects."
   },
   signature = {
      summary = "Sender's signature."
   },
   sloppy = {
      summary = "Be sloppy about line breaking."
   },
   smallskip = {
      summary = "Small vertical space."
   },
   sqrt = {
      arguments = {
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
      arguments = {
         {
            meta = "text"
         },
         {
            meta = "relation"
         }
      }
   },
   stepcounter = {
      arguments = {
         {
            meta = "counter"
         }
      },
      summary = "Add to a counter, resetting subsidiary counters."
   },
   telephone = {
      summary = "Sender's phone number."
   },
   textcircled = {
      arguments = {
         {
            meta = "letter"
         }
      }
   },
   thanks = {
      arguments = {
         {
            meta = "text"
         }
      }
   },
   thicklines = {
      summary = "A heavier line thickness."
   },
   thinlines = {
      summary = "The default line thickness."
   },
   thinspace = {
      summary = "One-sixth of an em.  "
   },
   thispagestyle = {
      arguments = {
         {
            meta = "style"
         }
      },
      summary = "Change the headings/footings style for this page."
   },
   title = {
      arguments = {
         {
            meta = "text"
         }
      }
   },
   today = {
      summary = "Inserting today's date."
   },
   twocolumn = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "prelim one column text",
            optional = true
         }
      },
      summary = "Use two-column layout."
   },
   typein = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "\\cmd",
            optional = true
         },
         {
            meta = "msg"
         }
      },
      summary = "Read text from the terminal."
   },
   typeout = {
      arguments = {
         {
            meta = "msg"
         }
      },
      summary = "Write text to the terminal."
   },
   underbrace = {
      arguments = {
         {
            meta = "math"
         }
      }
   },
   underline = {
      arguments = {
         {
            meta = "text"
         }
      }
   },
   uppercase = {
      arguments = {
         {
            meta = "text"
         }
      }
   },
   usebox = {
      arguments = {
         {
            meta = "\\boxcmd"
         }
      },
      summary = "Print saved text."
   },
   usecounter = {
      arguments = {
         {
            meta = "counter"
         }
      },
      summary = "Use a specified counter in a list environment."
   },
   usefont = {
      arguments = {
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
      arguments = {
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
      arguments = {
         {
            meta = "counter"
         }
      },
      summary = "Use the value of a counter in an expression.  "
   },
   vector = {
      arguments = {
         {
            delims = {"(", ")"},
            meta = "xslope, yslope"
         },
         {
            meta = "length"
         }
      },
      summary = "Draw a line with an arrow."
   },
   verb = {
      summary = "The macro form of the {verbatim} environment."
   },
   vfill = {
      summary = "Infinitely stretchable vertical space."
   },
   vline = {
      summary = "Draw a vertical line."
   },
   vspace = {
      arguments = {
         {
            meta = "length"
         }
      },
      summary = "Add arbitrary vertical space."
   },
   ["vspace*"] = {
      arguments = {
         {
            meta = "length"
         }
      }
   },
   year = {
      summary = "Today's year"
   }
}

environments = {
   abstract = {
      summary = "Produce an abstract."
   },
   array = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "pos",
            optional = true
         },
         {
            meta = "cols"
         }
      },
      summary = "Math arrays."
   },
   center = {
      summary = "Centered lines."
   },
   description = {
      summary = "Labelled lists."
   },
   displaymath = {
      summary = "Formulas that appear on their own line."
   },
   document = {
      summary = "Enclose the whole document."
   },
   enumerate = {
      summary = "Numbered lists."
   },
   eqnarray = {
      summary = "Sequences of aligned equations."
   },
   equation = {
      summary = "Displayed equation."
   },
   figure = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "placement",
            optional = true
         }
      },
      summary = "Floating figures."
   },
   ["figure*"] = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "placement",
            optional = true
         }
      }
   },
   filecontents = {
      arguments = {
         {
            meta = "filename"
         }
      },
      summary = "Writing multiple files from the source."
   },
   ["filecontents*"] = {
      arguments = {
         {
            meta = "filename"
         }
      }
   },
   flushleft = {
      summary = "Flushed left lines."
   },
   flushright = {
      summary = "Flushed right lines."
   },
   itemize = {
      summary = "Bulleted lists."
   },
   letter = {
      summary = "Letters."
   },
   list = {
      arguments = {
         {
            meta = "labeling"
         },
         {
            meta = "spacing"
         }
      },
      summary = "Generic list environment."
   },
   lrbox = {
      arguments = {
         {
            meta = "\\cmd"
         }
      },
      summary = "An environment like \\sbox."
   },
   math = {
      summary = "In-line math."
   },
   minipage = {
      arguments = {
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
      summary = "Miniature page."
   },
   picture = {
      arguments = {
         {
            delims = {"(", ")"},
            meta = "width, height"
         },
         {
            delims = {"(", ")"},
            meta = "xoffset, yoffset"
         }
      },
      summary = "Picture with text, arrows, lines and circles."
   },
   quotation = {
      summary = "Include a quotation."
   },
   quote = {
      summary = "Include a quotation."
   },
   tabbing = {
      summary = "Align text arbitrarily."
   },
   table = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "placement",
            optional = true
         }
      },
      summary = "Floating tables."
   },
   tabular = {
      arguments = {
         {
            delims = {"[", "]"},
            meta = "pos",
            optional = true
         },
         {
            meta = "cols"
         }
      },
      summary = "Align text in columns."
   },
   ["tabular*"] = {
      arguments = {
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
      arguments = {
         {
            meta = "widest-label"
         }
      },
      summary = "Bibliography or reference list."
   },
   theorem = {
      summary = "Theorems, lemmas, etc."
   },
   titlepage = {
      summary = "For hand crafted title pages."
   },
   verbatim = {
      summary = "Simulating typed input."
   },
   verse = {
      summary = "For poetry and other things."
   }
}
