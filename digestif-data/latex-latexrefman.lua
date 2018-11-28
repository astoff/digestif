module = {
   name = "latex"
}
commands = {
   ["-"] = {
      doc = "Insert explicit hyphenation."
   },
   ["/"] = {
      doc = "Insert italic correction."
   },
   ["@startsection"] = {
      doc = "Redefine layout of start of sections, subsections, etc.",
      signature = "mmmmmm",
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
      }
   },
   ["@ifstar"] = {
      doc = "Define your own commands with *-variants."
   },
   Alph = {
      doc = "Print value of a counter.",
      signature = "m",
      args = {
         {
            meta = "counter"
         }
      }
   },
   AtBeginDocument = {
      doc = "Hook for commands at the start of the document.",
      signature = "m",
      args = {
         {
            meta = "code"
         }
      }
   },
   AtEndDocument = {
      doc = "Hook for commands at the end of the document.",
      signature = "m",
      args = {
         {
            meta = "code"
         }
      }
   },
   AtEndOfClass = {
      signature = "m",
      args = {
         {
            meta = "code"
         }
      }
   },
   AtEndOfPackage = {
      signature = "m",
      args = {
         {
            meta = "code"
         }
      }
   },
   CheckCommand = {
      signature = "moom",
      args = {
         {
            meta = "cmd"
         },
         {
            meta = "num"
         },
         {
            meta = "default"
         },
         {
            meta = "definition"
         }
      }
   },
   ["CheckCommand*"] = {
      signature = "moom",
      args = {
         {
            meta = "cmd"
         },
         {
            meta = "num"
         },
         {
            meta = "default"
         },
         {
            meta = "definition"
         }
      }
   },
   ClassError = {
      signature = "mmm",
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
      signature = "mm",
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
      signature = "mm",
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
      signature = "mm",
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
      signature = "mm",
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
      signature = "mm",
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
      signature = "m",
      args = {
         {
            meta = "code"
         }
      }
   },
   DeclareRobustCommand = {
      signature = "moom",
      args = {
         {
            meta = "cmd"
         },
         {
            meta = "num"
         },
         {
            meta = "default"
         },
         {
            meta = "definition"
         }
      }
   },
   ["DeclareRobustCommand*"] = {
      signature = "moom",
      args = {
         {
            meta = "cmd"
         },
         {
            meta = "num"
         },
         {
            meta = "default"
         },
         {
            meta = "definition"
         }
      }
   },
   ExecuteOptions = {
      signature = "m",
      args = {
         {
            meta = "options-list"
         }
      }
   },
   IfFileExists = {
      signature = "mmm",
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
      signature = "mmm",
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
      signature = "omo",
      args = {
         {
            meta = "options list"
         },
         {
            meta = "class name"
         },
         {
            meta = "release date"
         }
      }
   },
   LoadClassWithOptions = {
      signature = "mo",
      args = {
         {
            meta = "class name"
         },
         {
            meta = "release date"
         }
      }
   },
   MakeLowercase = {
      signature = "m",
      args = {
         {
            meta = "text"
         }
      }
   },
   MakeUppercase = {
      signature = "m",
      args = {
         {
            meta = "text"
         }
      }
   },
   NeedsTeXFormat = {
      signature = "mo",
      args = {
         {
            meta = "format"
         },
         {
            meta = "format date"
         }
      }
   },
   PackageError = {
      signature = "mmm",
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
      signature = "mm",
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
      signature = "mm",
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
      signature = "mm",
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
      signature = "mm",
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
      signature = "mm",
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
      signature = "mm",
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
      signature = "mo",
      args = {
         {
            meta = "class name"
         },
         {
            meta = "release date"
         }
      }
   },
   ProvidesFile = {
      signature = "mo",
      args = {
         {
            meta = "file name"
         },
         {
            meta = "additional information"
         }
      }
   },
   ProvidesPackage = {
      signature = "mo",
      args = {
         {
            meta = "package name"
         },
         {
            meta = "release date"
         }
      }
   },
   RequirePackage = {
      signature = "omo",
      args = {
         {
            meta = "option list"
         },
         {
            meta = "package name"
         },
         {
            meta = "release date"
         }
      }
   },
   RequirePackageWithOptions = {
      signature = "mo",
      args = {
         {
            meta = "package name"
         },
         {
            meta = "release date"
         }
      }
   },
   Roman = {
      doc = "Print value of a counter.",
      signature = "m",
      args = {
         {
            meta = "counter"
         }
      }
   },
   ["\\"] = {
      doc = "Start a new line.",
      signature = "o",
      args = {
         {
            meta = "morespace"
         }
      }
   },
   ["\\*"] = {
      signature = "o",
      args = {
         {
            meta = "morespace"
         }
      }
   },
   addcontentsline = {
      doc = "Add an entry to table of contents, etc.",
      signature = "mmm",
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
      }
   },
   address = {
      doc = "Sender's return address."
   },
   addtocontents = {
      doc = "Add text directly to table of contents file, etc."
   },
   addtocounter = {
      doc = "Add a quantity to a counter.",
      signature = "mm",
      args = {
         {
            meta = "counter"
         },
         {
            meta = "value"
         }
      }
   },
   addtolength = {
      doc = "Add a quantity to a length.",
      signature = "mm",
      args = {
         {
            meta = "\\len"
         },
         {
            meta = "amount"
         }
      }
   },
   addvspace = {
      doc = "Add arbitrary vertical space if needed."
   },
   alph = {
      doc = "Print value of a counter.",
      signature = "m",
      args = {
         {
            meta = "counter"
         }
      }
   },
   arabic = {
      doc = "Print value of a counter.",
      signature = "m",
      args = {
         {
            meta = "counter"
         }
      }
   },
   author = {
      signature = "m",
      args = {
         {
            meta = "names"
         }
      }
   },
   bibitem = {
      doc = "Specify a bibliography item.",
      signature = "om",
      args = {
         {
            meta = "label"
         },
         {
            meta = "cite_key"
         }
      }
   },
   bibliography = {
      signature = "m",
      args = {
         {
            meta = "bibfiles"
         }
      }
   },
   bibliographystyle = {
      signature = "m",
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
      signature = "om",
      args = {
         {
            meta = "loftitle"
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
      signature = "om",
      args = {
         {
            meta = "toctitle"
         },
         {
            meta = "title"
         }
      }
   },
   circle = {
      doc = "Draw a circle.",
      signature = "m",
      args = {
         {
            meta = "diameter"
         }
      }
   },
   cite = {
      doc = "Refer to a bibliography item.",
      signature = "om",
      args = {
         {
            meta = "subcite"
         },
         {
            meta = "keys"
         }
      }
   },
   cleardoublepage = {
      doc = "Start a new right-hand page."
   },
   clearpage = {
      doc = "Start a new page."
   },
   cline = {
      doc = "Draw a horizontal line spanning some columns.",
      signature = "m",
      args = {
         {
            meta = "i-j"
         }
      }
   },
   closing = {
      doc = "Saying goodbye."
   },
   dashbox = {
      doc = "Draw a dashed box.",
      signature = "mr()om",
      args = {
         {
            meta = "dlen"
         },
         {
            meta = "rwidth, rheight"
         },
         {
            meta = "pos"
         },
         {
            meta = "text"
         }
      }
   },
   date = {
      signature = "m",
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
      doc = "Insert explicit hyphenation with control of hyphen character.",
      signature = "mmm",
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
      }
   },
   documentclass = {
      signature = "om",
      args = {
         {
            meta = "options"
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
      doc = "Ensure that math mode is active",
      signature = "m",
      args = {
         {
            meta = "formula"
         }
      }
   },
   fbox = {
      doc = "Put a frame around a box.",
      signature = "m",
      args = {
         {
            meta = "text"
         }
      }
   },
   flushbottom = {
      doc = "Make all text pages the same height."
   },
   fnsymbol = {
      doc = "Print value of a counter.",
      signature = "m",
      args = {
         {
            meta = "counter"
         }
      }
   },
   fontencoding = {
      signature = "m",
      args = {
         {
            meta = "encoding"
         }
      }
   },
   fontfamily = {
      signature = "m",
      args = {
         {
            meta = "family"
         }
      }
   },
   fontseries = {
      signature = "m",
      args = {
         {
            meta = "series"
         }
      }
   },
   fontshape = {
      signature = "m",
      args = {
         {
            meta = "shape"
         }
      }
   },
   fontsize = {
      signature = "mm",
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
      doc = "Insert a footnote.",
      signature = "om",
      args = {
         {
            meta = "number"
         },
         {
            meta = "text"
         }
      }
   },
   footnotemark = {
      doc = "Insert footnote mark only.",
      signature = "o",
      args = {
         {
            meta = "number"
         }
      }
   },
   footnotetext = {
      doc = "Insert footnote text only.",
      signature = "om",
      args = {
         {
            meta = "number"
         },
         {
            meta = "text"
         }
      }
   },
   frac = {
      signature = "mm",
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
      doc = "Draw a frame around an object.",
      signature = "m",
      args = {
         {
            meta = "text"
         }
      }
   },
   framebox = {
      doc = "Draw a box with a frame around it.",
      signature = "oom",
      args = {
         {
            meta = "width"
         },
         {
            meta = "position"
         },
         {
            meta = "text"
         }
      }
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
      doc = "Fixed horizontal space.  ",
      signature = "m",
      args = {
         {
            meta = "length"
         }
      }
   },
   ["hspace*"] = {
      signature = "m",
      args = {
         {
            meta = "length"
         }
      }
   },
   hyphenation = {
      doc = "Tell LaTeX how to hyphenate a word.",
      signature = "m",
      args = {
         {
            meta = "words"
         }
      }
   },
   include = {
      doc = "Conditionally include a file.",
      signature = "m",
      args = {
         {
            meta = "file"
         }
      }
   },
   includeonly = {
      doc = "Determine which files are included.",
      signature = "m",
      args = {
         {
            meta = "files"
         }
      }
   },
   indent = {
      doc = "Indent this paragraph."
   },
   input = {
      doc = "Unconditionally include a file.",
      signature = "m",
      args = {
         {
            meta = "file"
         }
      }
   },
   item = {
      doc = "An entry in a list.",
      signature = "o",
      args = {
         {
            meta = "optional label"
         }
      }
   },
   label = {
      doc = "Assign a symbolic name to a piece of text.",
      signature = "m",
      args = {
         {
            meta = "key"
         }
      }
   },
   line = {
      doc = "Draw a straight line.",
      signature = "r()m",
      args = {
         {
            meta = "xslope, yslope"
         },
         {
            meta = "length"
         }
      }
   },
   linebreak = {
      doc = "Force line break.",
      signature = "o",
      args = {
         {
            meta = "priority"
         }
      }
   },
   linespread = {
      signature = "m",
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
      signature = "m",
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
      doc = "Box, adjustable position.",
      signature = "oom",
      args = {
         {
            meta = "width"
         },
         {
            meta = "position"
         },
         {
            meta = "text"
         }
      }
   },
   makelabels = {
      doc = "Make address labels."
   },
   maketitle = {
      doc = "Generate a title page."
   },
   marginpar = {
      signature = "om",
      args = {
         {
            meta = "left"
         },
         {
            meta = "right"
         }
      }
   },
   markboth = {
      signature = "mm",
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
      signature = "m",
      args = {
         {
            meta = "right"
         }
      }
   },
   mbox = {
      doc = "Horizontal boxes.",
      signature = "m",
      args = {
         {
            meta = "text"
         }
      }
   },
   medskip = {
      doc = "Medium vertical space."
   },
   month = {
      doc = "Today's month"
   },
   multicolumn = {
      doc = "Make an item spanning several columns.",
      signature = "mmm",
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
      }
   },
   multiput = {
      doc = "Draw multiple instances of an object.",
      signature = "r()r()mm",
      args = {
         {
            meta = "x, y"
         },
         {
            meta = "delta_x, delta_y"
         },
         {
            meta = "n"
         },
         {
            meta = "obj"
         }
      }
   },
   name = {
      doc = "Sender's name, for the return address."
   },
   newcommand = {
      doc = "Define a new command"
   },
   newcounter = {
      doc = "Define a new counter.",
      signature = "mo",
      args = {
         {
            meta = "countername"
         },
         {
            meta = "supercounter"
         }
      }
   },
   newenvironment = {
      doc = "Define a new environment."
   },
   newfont = {
      doc = "Define a new font name.",
      signature = "mm",
      args = {
         {
            meta = "\\cmd"
         },
         {
            meta = "font description"
         }
      }
   },
   newlength = {
      doc = "Define a new length.",
      signature = "m",
      args = {
         {
            meta = "\\arg"
         }
      }
   },
   newline = {
      doc = "Break the line"
   },
   newpage = {
      doc = "Start a new page."
   },
   newsavebox = {
      doc = "Define a new box.",
      signature = "m",
      args = {
         {
            meta = "\\cmd"
         }
      }
   },
   newtheorem = {
      doc = "Define a new theorem-like environment.",
      signature = "mom",
      args = {
         {
            meta = "name"
         },
         {
            meta = "numbered_like"
         },
         {
            meta = "title"
         }
      }
   },
   nocite = {
      doc = "Include an item in the bibliography."
   },
   noindent = {
      doc = "Do not indent this paragraph."
   },
   nolinebreak = {
      doc = "Avoid line break.",
      signature = "o",
      args = {
         {
            meta = "priority"
         }
      }
   },
   nopagebreak = {
      doc = "Avoid page break.",
      signature = "o",
      args = {
         {
            meta = "priority"
         }
      }
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
      doc = "Draw an ellipse.",
      signature = "r()o",
      args = {
         {
            meta = "width, height"
         },
         {
            meta = "portion"
         }
      }
   },
   overbrace = {
      signature = "m",
      args = {
         {
            meta = "math"
         }
      }
   },
   overline = {
      signature = "m",
      args = {
         {
            meta = "text"
         }
      }
   },
   pagebreak = {
      doc = "Force page break",
      signature = "o",
      args = {
         {
            meta = "priority"
         }
      }
   },
   pagenumbering = {
      doc = "Set the style used for page numbers.",
      signature = "m",
      args = {
         {
            meta = "style"
         }
      }
   },
   pageref = {
      doc = "Refer to a page number.",
      signature = "m",
      args = {
         {
            meta = "key"
         }
      }
   },
   pagestyle = {
      doc = "Change the headings/footings style.",
      signature = "m",
      args = {
         {
            meta = "style"
         }
      }
   },
   parbox = {
      doc = "Box with text in paragraph mode.",
      signature = "ooomm",
      args = {
         {
            meta = "position"
         },
         {
            meta = "height"
         },
         {
            meta = "inner-pos"
         },
         {
            meta = "width"
         },
         {
            meta = "text"
         }
      }
   },
   parskip = {
      doc = "Space added before paragraphs."
   },
   protect = {
      doc = "Using tricky commands."
   },
   providecommand = {
      doc = "Define a new command, if name not used.",
      signature = "moom",
      args = {
         {
            meta = "cmd"
         },
         {
            meta = "nargs"
         },
         {
            meta = "optargdefault"
         },
         {
            meta = "defn"
         }
      }
   },
   ["providecommand*"] = {
      signature = "moom",
      args = {
         {
            meta = "cmd"
         },
         {
            meta = "nargs"
         },
         {
            meta = "optargdefault"
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
      doc = "Place an object at a specified place.",
      signature = "r()",
      args = {
         {
            meta = "xcoord, ycoord"
         }
      }
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
      doc = "Raise or lower text.",
      signature = "moom",
      args = {
         {
            meta = "distance"
         },
         {
            meta = "height"
         },
         {
            meta = "depth"
         },
         {
            meta = "text"
         }
      }
   },
   ref = {
      doc = "Refer to a section, figure or similar.",
      signature = "m",
      args = {
         {
            meta = "key"
         }
      }
   },
   refstepcounter = {
      doc = "Add to a counter.",
      signature = "m",
      args = {
         {
            meta = "counter"
         }
      }
   },
   renewcommand = {
      doc = "Redefine a command.",
      signature = "moom",
      args = {
         {
            meta = "\\cmd"
         },
         {
            meta = "nargs"
         },
         {
            meta = "optargdefault"
         },
         {
            meta = "defn"
         }
      }
   },
   ["renewcommand*"] = {
      signature = "moom",
      args = {
         {
            meta = "\\cmd"
         },
         {
            meta = "nargs"
         },
         {
            meta = "optargdefault"
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
      signature = "moomm",
      args = {
         {
            meta = "env"
         },
         {
            meta = "nargs"
         },
         {
            meta = "optargdefault"
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
      doc = "Print value of a counter.",
      signature = "m",
      args = {
         {
            meta = "counter"
         }
      }
   },
   rule = {
      doc = "Inserting lines and rectangles.",
      signature = "omm",
      args = {
         {
            meta = "raise"
         },
         {
            meta = "width"
         },
         {
            meta = "thickness"
         }
      }
   },
   savebox = {
      doc = "Like \\makebox, but save the text for later use.",
      signature = "moom",
      args = {
         {
            meta = "\\boxcmd"
         },
         {
            meta = "width"
         },
         {
            meta = "pos"
         },
         {
            meta = "text"
         }
      }
   },
   sbox = {
      doc = "Like \\mbox, but save the text for later use.",
      signature = "mm",
      args = {
         {
            meta = "\\boxcmd"
         },
         {
            meta = "text"
         }
      }
   },
   setcounter = {
      doc = "Set the value of a counter.",
      signature = "mm",
      args = {
         {
            meta = "counter"
         },
         {
            meta = "value"
         }
      }
   },
   setlength = {
      doc = "Set the value of a length.",
      signature = "mm",
      args = {
         {
            meta = "\\len"
         },
         {
            meta = "amount"
         }
      }
   },
   settodepth = {
      doc = "Set a length to the depth of something.",
      signature = "mm",
      args = {
         {
            meta = "\\len"
         },
         {
            meta = "text"
         }
      }
   },
   settoheight = {
      doc = "Set a length to the height of something.",
      signature = "m",
      args = {
         {
            meta = "\\len"
         }
      }
   },
   settowidth = {
      doc = "Set a length to the width of something.",
      signature = "mm",
      args = {
         {
            meta = "\\len"
         },
         {
            meta = "text"
         }
      }
   },
   shortstack = {
      doc = "Make a pile of objects.",
      signature = "o",
      args = {
         {
            meta = "position"
         }
      }
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
      signature = "om",
      args = {
         {
            meta = "root"
         },
         {
            meta = "arg"
         }
      }
   },
   stackrel = {
      signature = "mm",
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
      doc = "Add to a counter, resetting subsidiary counters.",
      signature = "m",
      args = {
         {
            meta = "counter"
         }
      }
   },
   telephone = {
      doc = "Sender's phone number."
   },
   textcircled = {
      signature = "m",
      args = {
         {
            meta = "letter"
         }
      }
   },
   thanks = {
      signature = "m",
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
      doc = "Change the headings/footings style for this page.",
      signature = "m",
      args = {
         {
            meta = "style"
         }
      }
   },
   title = {
      signature = "m",
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
      doc = "Use two-column layout.",
      signature = "o",
      args = {
         {
            meta = "prelim one column text"
         }
      }
   },
   typein = {
      doc = "Read text from the terminal.",
      signature = "om",
      args = {
         {
            meta = "\\cmd"
         },
         {
            meta = "msg"
         }
      }
   },
   typeout = {
      doc = "Write text to the terminal.",
      signature = "m",
      args = {
         {
            meta = "msg"
         }
      }
   },
   underbrace = {
      signature = "m",
      args = {
         {
            meta = "math"
         }
      }
   },
   underline = {
      signature = "m",
      args = {
         {
            meta = "text"
         }
      }
   },
   uppercase = {
      signature = "m",
      args = {
         {
            meta = "text"
         }
      }
   },
   usebox = {
      doc = "Print saved text.",
      signature = "m",
      args = {
         {
            meta = "\\boxcmd"
         }
      }
   },
   usecounter = {
      doc = "Use a specified counter in a list environment.",
      signature = "m",
      args = {
         {
            meta = "counter"
         }
      }
   },
   usefont = {
      signature = "mmmm",
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
      signature = "om",
      args = {
         {
            meta = "options"
         },
         {
            meta = "pkg"
         }
      }
   },
   value = {
      doc = "Use the value of a counter in an expression.  ",
      signature = "m",
      args = {
         {
            meta = "counter"
         }
      }
   },
   vector = {
      doc = "Draw a line with an arrow.",
      signature = "r()m",
      args = {
         {
            meta = "xslope, yslope"
         },
         {
            meta = "length"
         }
      }
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
      doc = "Add arbitrary vertical space.",
      signature = "m",
      args = {
         {
            meta = "length"
         }
      }
   },
   ["vspace*"] = {
      signature = "m",
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
      doc = "Math arrays.",
      signature = "om",
      args = {
         {
            meta = "pos"
         },
         {
            meta = "cols"
         }
      }
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
      doc = "Floating figures.",
      signature = "o",
      args = {
         {
            meta = "placement"
         }
      }
   },
   ["figure*"] = {
      signature = "o",
      args = {
         {
            meta = "placement"
         }
      }
   },
   filecontents = {
      doc = "Writing multiple files from the source.",
      signature = "m",
      args = {
         {
            meta = "filename"
         }
      }
   },
   ["filecontents*"] = {
      signature = "m",
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
      doc = "Generic list environment.",
      signature = "mm",
      args = {
         {
            meta = "labeling"
         },
         {
            meta = "spacing"
         }
      }
   },
   lrbox = {
      doc = "An environment like \\sbox.",
      signature = "m",
      args = {
         {
            meta = "\\cmd"
         }
      }
   },
   math = {
      doc = "In-line math."
   },
   minipage = {
      doc = "Miniature page.",
      signature = "ooom",
      args = {
         {
            meta = "position"
         },
         {
            meta = "height"
         },
         {
            meta = "inner-pos"
         },
         {
            meta = "width"
         }
      }
   },
   picture = {
      doc = "Picture with text, arrows, lines and circles.",
      signature = "r()r()",
      args = {
         {
            meta = "width, height"
         },
         {
            meta = "xoffset, yoffset"
         }
      }
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
      doc = "Floating tables.",
      signature = "o",
      args = {
         {
            meta = "placement"
         }
      }
   },
   tabular = {
      doc = "Align text in columns.",
      signature = "om",
      args = {
         {
            meta = "pos"
         },
         {
            meta = "cols"
         }
      }
   },
   ["tabular*"] = {
      signature = "mom",
      args = {
         {
            meta = "width"
         },
         {
            meta = "pos"
         },
         {
            meta = "cols"
         }
      }
   },
   thebibliography = {
      doc = "Bibliography or reference list.",
      signature = "m",
      args = {
         {
            meta = "widest-label"
         }
      }
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

