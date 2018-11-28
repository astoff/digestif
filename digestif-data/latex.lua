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
      args = {
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      },
      heading_level = 4, signature = "som"
   },
   part = {
      action = "heading",
      args = {
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      },
      heading_level = -1, signature = "som"
   },
   ref = {
      action = "ref",
      args = signature("m", "reference")
   },
   section = {
      action = "heading",
      args = {
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      },
      heading_level = 1, signature = "som"
   },
   subparagraph = {
      action = "heading",
      args = {
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      },
      heading_level = 5, signature = "som"
   },
   subsection = {
      action = "heading",
      args = {
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      },
      heading_level = 2, signature = "som"
   },
   subsubsection = {
      action = "heading",
      args = {
         {
            meta = "unnumbered"
         },
         {
            meta = "short title"
         },
         {
            meta = "title"
         }
      },
      heading_level = 3, signature = "som"
   },
   test = {
      args = {
         {
            keys = {
               blue = {},
               bluuue = {},
               green = {},
               ["line width"] = {
                  values = {
                     thick = {},
                     thin = {}
                  }
               },
               red = {}
            },
            meta = "options"
         },
         {
            meta = "text"
         }
      },
      signature = "om"
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
   sususu = {
      args = {
         {
            keys = {
               blue = {},
               bluuue = {},
               green = {},
               ["line width"] = {
                  values = {
                     thick = {},
                     thin = {}
                  }
               },
               red = {}
            },
            meta = "options"
         }
      },
      signature = "m"
   }
}
