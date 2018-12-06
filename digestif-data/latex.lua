name = "latex"
dependencies = {
   "latex-latexrefman"}
module = {
   dependencies = {
      "latex-latexrefman"
   },
   name = "latex"
}
commands = {
   ["("] = {
      action = "math"},
   [")"] = {
      action = "endmath"},
   ["["] = {
      action = "math"},
   ["]"] = {
      action = "endmath"},
   begin = {
      action = "begin",
      args = signature("m", "environment")},
   bibitem = {
     action = "bibitem",
     args = signature("om", "label", "key"),
     doc = "Create a bibliography item."
   },
   cite = {
     action = "cite",
     args = signature("om", "text", "key"),
     doc = "Cite a bibliography item."
   },
   bibliography = {
      action = "input",
      args = signature("m", "bib files"),
      filename = "%s.bib"
   },
   chapter = {
      action = "heading",
      heading_level = 0,
      args = signature("som",
         {meta = "unnumbered"},
         {meta = "short title"},
         {meta = "title"})},
   documentclass = {
      action = "input",
      args = signature("om", "options", "class"),
      filename = "%s.cls"
   },
   ['end'] = {
      action = "end",
      args = signature("m", "environment")
   },
   include = {
      action = "input",
      args = signature("m", "file name"),
      filename = "%s.tex"
   },
   label = {
      action = "label",
      args = signature("m", "reference")
   },
   paragraph = {
      action = "heading",
      args = signature("som",
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      ),
      heading_level = 4
   },
   part = {
      action = "heading",
      args = signature("som",
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      ),
      heading_level = -1
   },
   ref = {
      action = "ref",
      args = signature("m", "reference")
   },
   section = {
      action = "heading",
      args = signature("som",
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      ),
      heading_level = 1
   },
   subparagraph = {
      action = "heading",
      args = signature("som",
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      ),
      heading_level = 5
   },
   subsection = {
      action = "heading",
      args = signature("som",
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      ),
      heading_level = 2
   },
   subsubsection = {
      action = "heading",
      args = signature("som",
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      ),
      heading_level = 3
   },
   usepackage = {
      action = "input",
      args = signature("om", "options", "packages"),
      filename = "%s.sty"
   }
}
environments = {
   description = {
      action = "list"
   },
   displaymath = {
      action = "math"
   },
   document = {
      action = "document"
   },
   enumerate = {
      action = "list"
   },
   itemize = {
      action = "list"
   },
   math = {
      action = "math"
   },
}
