name = "latex"

dependencies = {
  "latex-latexrefman",
  "plain-symbols"
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
      arguments = signature("m", "environment")},
   bibitem = {
     action = "bibitem",
     arguments = signature("om", "label", "key"),
     summary = "Create a bibliography item."
   },
   cite = {
     action = "cite",
     arguments = signature("om", "text", "key"),
     summary = "Cite a bibliography item."
   },
   bibliography = {
      action = "input",
      arguments = signature("m", "bib files"),
      filename = "?.bib"
   },
   chapter = {
      action = "heading",
      heading_level = 0,
      arguments = signature("som",
         {meta = "star"},
         {meta = "short title"},
         {meta = "title"})},
   documentclass = {
      action = "input",
      arguments = signature("om", "options", "class"),
      filename = "?.cls"
   },
   ['end'] = {
      action = "end",
      arguments = signature("m", "environment")
   },
   include = {
      action = "input",
      arguments = signature("m", "file name"),
      filename = "?.tex"
   },
   label = {
     action = "label",
     summary = "Create a label for this point of the text, for reference with \\ref, etc.",
     arguments = signature("m", "reference")
   },
   caption = {
     action = "caption",
     summary = "Create a caption for a floating figure or table.",
     arguments = signature("om", "short text", "text")
   },
   paragraph = {
      action = "heading",
      arguments = signature("som",
         {
            meta = "star"
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
      arguments = signature("som",
         {
            meta = "star"
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
     summary = "Make a cross-reference.",
     arguments = signature("m",
       {
         meta = "reference",
         summary = "A reference defined elsewhere with \\label."})
   },
   section = {
     action = "heading",
     summary = "Start a new section.",
      arguments = signature("som",
         {
           meta = "star",
           summary = "If present, make section unnumbered."
         },
         {
           meta = "short title",
           summary = "Short title for headers and table of contents."
         },
         {
           meta = "title",
           summary = "The section title."
         }
      ),
      heading_level = 1
   },
   subparagraph = {
      action = "heading",
      arguments = signature("som",
         {
            meta = "star"
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
      arguments = signature("som",
         {
            meta = "star"
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
      arguments = signature("som",
         {
            meta = "star"
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
      arguments = signature("om", "options", "packages"),
      filename = "?.sty"
   },
  -- the few extra latex math symbols, from
  -- https://github.com/wspr/unicode-math/ 
  cong = {
    summary = "congruent with",
    symbol = "≅"
  },
  doteq = {
    summary = "equals, single dot above",
    symbol = "≐"
  },
  notin = {
    summary = "negated set membership",
    symbol = "∉"
  },
  rightleftharpoons = {
    summary = "right harpoon over left",
    symbol = "⇌"
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
