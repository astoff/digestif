comments = [[
Extracted from the PGF manual
URL: https://github.com/pgf-tikz/pgf/
Original license: GNU FDL v1.2+ or LPPL 1.3+
]]
package = {
   documentation = "generic/pgf/pgfmanual.pdf",
   name = "pgf"
}
commands = {
   beginpgfgraphicnamed = {
      arguments = {
         {
            meta = "file name prefix"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>beginpgfgraphicnamed"
   },
   endpgfgraphicnamed = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>endpgfgraphicnamed"
   },
   ifpgfmathmathunitsdeclared = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>ifpgfmathmathunitsdeclared"
   },
   ifpgfmathunitsdeclared = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>ifpgfmathunitsdeclared"
   },
   ifpgfrememberpicturepositiononpage = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>ifpgfrememberpicturepositiononpage"
   },
   ifpgfshadingmodelcmyk = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>ifpgfshadingmodelcmyk"
   },
   ifpgfshadingmodelgray = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>ifpgfshadingmodelgray"
   },
   ifpgfshadingmodelrgb = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>ifpgfshadingmodelrgb"
   },
   ["ifpgfsys@eorule"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>ifpgfsys@eorule"
   },
   ["ifpgfsys@transparency@group@isolated"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>ifpgfsys@transparency@group@isolated"
   },
   ["ifpgfsys@transparency@group@knockout"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>ifpgfsys@transparency@group@knockout"
   },
   ["pgf@process"] = {
      arguments = {
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgf@process"
   },
   ["pgf@protocolsizes"] = {
      arguments = {
         {
            meta = "x-dimension"
         },
         {
            meta = "y-dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgf@protocolsizes"
   },
   ["pgf@relevantforpicturesizefalse"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgf@relevantforpicturesizefalse"
   },
   ["pgf@relevantforpicturesizetrue"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgf@relevantforpicturesizetrue"
   },
   ["pgf@sys@bp"] = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgf@sys@bp"
   },
   pgfactualjobname = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfactualjobname"
   },
   pgfaliasid = {
      arguments = {
         {
            meta = "alias"
         },
         {
            meta = "name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfaliasid"
   },
   pgfaliasimage = {
      arguments = {
         {
            meta = "new image name"
         },
         {
            meta = "existing image name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfaliasimage"
   },
   pgfalternateextension = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfalternateextension"
   },
   pgfanimateattribute = {
      arguments = {
         {
            meta = "attribute"
         },
         {
            keys = "$DIGESTIFDATA/pgf/keys/pgf",
            meta = "options"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfanimateattribute"
   },
   pgfanimateattributecode = {
      arguments = {
         {
            meta = "attribute"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfanimateattributecode"
   },
   pgfapproximatenonlineartransformation = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfapproximatenonlineartransformation"
   },
   pgfapproximatenonlineartranslation = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfapproximatenonlineartranslation"
   },
   pgfarrowsaddtolateoptions = {
      arguments = {
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowsaddtolateoptions"
   },
   pgfarrowsaddtolengthscalelist = {
      arguments = {
         {
            meta = "dimension register"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowsaddtolengthscalelist"
   },
   pgfarrowsaddtooptions = {
      arguments = {
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowsaddtooptions"
   },
   pgfarrowsaddtowidthscalelist = {
      arguments = {
         {
            meta = "dimension register"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowsaddtowidthscalelist"
   },
   pgfarrowshullpoint = {
      arguments = {
         {
            meta = "x dimension"
         },
         {
            meta = "y dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowshullpoint"
   },
   pgfarrowslengthdependent = {
      arguments = {
         {
            meta = "dimension"
         },
         {
            meta = "length factor"
         },
         {
            meta = "dummy"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowslengthdependent"
   },
   pgfarrowslinewidthdependent = {
      arguments = {
         {
            meta = "dimension"
         },
         {
            meta = "line width factor"
         },
         {
            meta = "outer factor"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowslinewidthdependent"
   },
   pgfarrowssave = {
      arguments = {
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowssave"
   },
   pgfarrowssavethe = {
      arguments = {
         {
            meta = "register"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowssavethe"
   },
   pgfarrowssetbackend = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowssetbackend"
   },
   pgfarrowssetlineend = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowssetlineend"
   },
   pgfarrowssettipend = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowssettipend"
   },
   pgfarrowssetvisualbackend = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowssetvisualbackend"
   },
   pgfarrowssetvisualtipend = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowssetvisualtipend"
   },
   pgfarrowsthreeparameters = {
      arguments = {
         {
            meta = "line-width dependent size specification"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowsthreeparameters"
   },
   pgfarrowsupperhullpoint = {
      arguments = {
         {
            meta = "x dimension"
         },
         {
            meta = "y dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfarrowsupperhullpoint"
   },
   pgfcalendar = {
      arguments = {
         {
            meta = "prefix"
         },
         {
            meta = "start date"
         },
         {
            meta = "end date"
         },
         {
            meta = "rendering code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendar"
   },
   pgfcalendardatetojulian = {
      arguments = {
         {
            meta = "date"
         },
         {
            meta = "counter"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendardatetojulian"
   },
   pgfcalendareastersunday = {
      arguments = {
         {
            meta = "year"
         },
         {
            meta = "counter"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendareastersunday"
   },
   pgfcalendarifdate = {
      arguments = {
         {
            meta = "date"
         },
         {
            meta = "tests"
         },
         {
            meta = "code"
         },
         {
            meta = "else code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendarifdate"
   },
   pgfcalendarjuliantodate = {
      arguments = {
         {
            meta = "Julian day"
         },
         {
            meta = "year macro"
         },
         {
            meta = "month macro"
         },
         {
            meta = "day macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendarjuliantodate"
   },
   pgfcalendarjuliantoweekday = {
      arguments = {
         {
            meta = "Julian day"
         },
         {
            meta = "week day counter"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendarjuliantoweekday"
   },
   pgfcalendarmonthname = {
      arguments = {
         {
            meta = "month number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendarmonthname"
   },
   pgfcalendarmonthshortname = {
      arguments = {
         {
            meta = "month number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendarmonthshortname"
   },
   pgfcalendarshorthand = {
      arguments = {
         {
            meta = "kind"
         },
         {
            meta = "representation"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendarshorthand"
   },
   pgfcalendarsuggestedname = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendarsuggestedname"
   },
   pgfcalendarweekdayname = {
      arguments = {
         {
            meta = "week day number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendarweekdayname"
   },
   pgfcalendarweekdayshortname = {
      arguments = {
         {
            meta = "week day number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcalendarweekdayshortname"
   },
   pgfclearid = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfclearid"
   },
   pgfcoordinate = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "coordinate"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcoordinate"
   },
   pgfcurvilineardistancetotime = {
      arguments = {
         {
            meta = "distance"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfcurvilineardistancetotime"
   },
   pgfdata = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            keys = "$DIGESTIFDATA/pgf/keys/pgf",
            meta = "options",
            optional = true
         },
         {
            meta = "inline data"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdata"
   },
   pgfdeclarearrow = {
      arguments = {
         {
            meta = "config"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclarearrow"
   },
   pgfdeclaredataformat = {
      arguments = {
         {
            meta = "format name"
         },
         {
            meta = "catcode code"
         },
         {
            meta = "startup code"
         },
         {
            meta = "line arguments"
         },
         {
            meta = "line code"
         },
         {
            meta = "empty line code"
         },
         {
            meta = "end code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclaredataformat"
   },
   pgfdeclaredecoration = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "initial state"
         },
         {
            meta = "states"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclaredecoration"
   },
   pgfdeclarefading = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "contents"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclarefading"
   },
   pgfdeclarefunctionalshading = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "color list",
            optional = true
         },
         {
            meta = "shading name"
         },
         {
            meta = "lower left corner"
         },
         {
            meta = "upper right corner"
         },
         {
            meta = "init code"
         },
         {
            meta = "type 4 function"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclarefunctionalshading"
   },
   pgfdeclarehorizontalshading = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "color list",
            optional = true
         },
         {
            meta = "shading name"
         },
         {
            meta = "shading height"
         },
         {
            meta = "color specification"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclarehorizontalshading"
   },
   pgfdeclareimage = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            keys = "$DIGESTIFDATA/pgf/keys/pgf",
            meta = "options",
            optional = true
         },
         {
            meta = "image name"
         },
         {
            meta = "filename"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclareimage"
   },
   pgfdeclarelayer = {
      arguments = {
         {
            meta = "name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclarelayer"
   },
   pgfdeclarelindenmayersystem = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "specification"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclarelindenmayersystem"
   },
   pgfdeclaremask = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            keys = "$DIGESTIFDATA/pgf/keys/pgf",
            meta = "options",
            optional = true
         },
         {
            meta = "mask name"
         },
         {
            meta = "filename"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclaremask"
   },
   pgfdeclaremetadecorate = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "initial state"
         },
         {
            meta = "states"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclaremetadecorate"
   },
   pgfdeclarepatternformonly = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "variables",
            optional = true
         },
         {
            meta = "name"
         },
         {
            meta = "bottom left"
         },
         {
            meta = "top right"
         },
         {
            meta = "tile size"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclarepatternformonly"
   },
   pgfdeclarepatterninherentlycolored = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "variables",
            optional = true
         },
         {
            meta = "name"
         },
         {
            meta = "lower left"
         },
         {
            meta = "upper right"
         },
         {
            meta = "tile size"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclarepatterninherentlycolored"
   },
   pgfdeclareplothandler = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "arguments"
         },
         {
            meta = "configuration"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclareplothandler"
   },
   pgfdeclareplotmark = {
      arguments = {
         {
            meta = "plot mark name"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclareplotmark"
   },
   pgfdeclareradialshading = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "color list",
            optional = true
         },
         {
            meta = "shading name"
         },
         {
            meta = "center point"
         },
         {
            meta = "color specification"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclareradialshading"
   },
   pgfdeclareshape = {
      arguments = {
         {
            meta = "shape name"
         },
         {
            meta = "shape specification"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclareshape"
   },
   pgfdeclareverticalshading = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "color list",
            optional = true
         },
         {
            meta = "shading name"
         },
         {
            meta = "shading width"
         },
         {
            meta = "color specification"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdeclareverticalshading"
   },
   pgfdecorateaftercode = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecorateaftercode"
   },
   pgfdecoratebeforecode = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecoratebeforecode"
   },
   pgfdecoratecurrentpath = {
      arguments = {
         {
            meta = "name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecoratecurrentpath"
   },
   pgfdecoratedangle = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecoratedangle"
   },
   pgfdecoratedcompleteddistance = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecoratedcompleteddistance"
   },
   pgfdecoratedinputsegmentcompleteddistance = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecoratedinputsegmentcompleteddistance"
   },
   pgfdecoratedinputsegmentlength = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecoratedinputsegmentlength"
   },
   pgfdecoratedinputsegmentremainingdistance = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecoratedinputsegmentremainingdistance"
   },
   pgfdecoratedpath = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecoratedpath"
   },
   pgfdecoratedpathlength = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecoratedpathlength"
   },
   pgfdecoratedremainingdistance = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecoratedremainingdistance"
   },
   pgfdecorateexistingpath = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecorateexistingpath"
   },
   pgfdecoratepath = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "path commands"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecoratepath"
   },
   pgfdecorationpath = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdecorationpath"
   },
   pgfdvdeclarestylesheet = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "keys"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfdvdeclarestylesheet"
   },
   pgferror = {
      arguments = {
         {
            meta = "message"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgferror"
   },
   pgfextra = {
      arguments = {
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfextra"
   },
   pgfextractx = {
      arguments = {
         {
            meta = "dimension"
         },
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfextractx"
   },
   pgfextracty = {
      arguments = {
         {
            meta = "dimension"
         },
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfextracty"
   },
   pgffuncshadingcmyktogray = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgffuncshadingcmyktogray"
   },
   pgffuncshadingcmyktorgb = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgffuncshadingcmyktorgb"
   },
   pgffuncshadinggraytocmyk = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgffuncshadinggraytocmyk"
   },
   pgffuncshadinggraytorgb = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgffuncshadinggraytorgb"
   },
   pgffuncshadingrgbtocmyk = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgffuncshadingrgbtocmyk"
   },
   pgffuncshadingrgbtogray = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgffuncshadingrgbtogray"
   },
   pgfgaliasid = {
      arguments = {
         {
            meta = "1"
         },
         {
            meta = "2"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgaliasid"
   },
   pgfgdaddspecificationhook = {
      arguments = {
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdaddspecificationhook"
   },
   pgfgdbegineventgroup = {
      arguments = {
         {
            meta = "parameter"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdbegineventgroup"
   },
   pgfgdbeginlayout = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdbeginlayout"
   },
   pgfgdbeginscope = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdbeginscope"
   },
   pgfgdedge = {
      arguments = {
         {
            meta = "first node"
         },
         {
            meta = "second node"
         },
         {
            meta = "edge direction"
         },
         {
            meta = "edge options"
         },
         {
            meta = "edge nodes"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdedge"
   },
   pgfgdendeventgroup = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdendeventgroup"
   },
   pgfgdendlayout = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdendlayout"
   },
   pgfgdendscope = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdendscope"
   },
   pgfgdevent = {
      arguments = {
         {
            meta = "kind"
         },
         {
            meta = "parameter"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdevent"
   },
   pgfgdeventgroup = {
      arguments = {
         {
            meta = "parameters"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdeventgroup"
   },
   pgfgdsetedgecallback = {
      arguments = {
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdsetedgecallback"
   },
   pgfgdsetlatenodeoption = {
      arguments = {
         {
            meta = "node name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdsetlatenodeoption"
   },
   pgfgdsetrequestcallback = {
      arguments = {
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdsetrequestcallback"
   },
   pgfgdsubgraphnode = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "node options"
         },
         {
            meta = "node text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgdsubgraphnode"
   },
   pgfgetlastxy = {
      arguments = {
         {
            meta = "macro for $x$"
         },
         {
            meta = "macro for $y$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgetlastxy"
   },
   pgfgettransform = {
      arguments = {
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgettransform"
   },
   pgfgettransformentries = {
      arguments = {
         {
            meta = "macro for a"
         },
         {
            meta = "macro for b"
         },
         {
            meta = "macro for c"
         },
         {
            meta = "macro for d"
         },
         {
            meta = "macro for shift x"
         },
         {
            meta = "macro for shift y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfgettransformentries"
   },
   pgfhorizontaltransformationadjustment = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfhorizontaltransformationadjustment"
   },
   pgfidrefnextuse = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfidrefnextuse"
   },
   pgfidrefprevuse = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfidrefprevuse"
   },
   pgfifidreferenced = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "then code"
         },
         {
            meta = "else code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfifidreferenced"
   },
   pgfimage = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            keys = "$DIGESTIFDATA/pgf/keys/pgf",
            meta = "options",
            optional = true
         },
         {
            meta = "filename"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfimage"
   },
   pgfintersectionofpaths = {
      arguments = {
         {
            meta = "path 1"
         },
         {
            meta = "path 2"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfintersectionofpaths"
   },
   pgfintersectionsolutions = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfintersectionsolutions"
   },
   pgfintersectionsortbyfirstpath = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfintersectionsortbyfirstpath"
   },
   pgfintersectionsortbysecondpath = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfintersectionsortbysecondpath"
   },
   pgfkeys = {
      arguments = {
         {
            meta = "key list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeys"
   },
   pgfkeysactivatefamilies = {
      arguments = {
         {
            meta = "family list"
         },
         {
            meta = "deactivate macro name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysactivatefamilies"
   },
   pgfkeysactivatefamiliesandfilteroptions = {
      arguments = {
         {
            meta = "family list"
         },
         {
            meta = "key--value-list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysactivatefamiliesandfilteroptions"
   },
   pgfkeysactivatefamily = {
      arguments = {
         {
            meta = "family name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysactivatefamily"
   },
   pgfkeysactivatesinglefamilyandfilteroptions = {
      arguments = {
         {
            meta = "family name"
         },
         {
            meta = "key--value-list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysactivatesinglefamilyandfilteroptions"
   },
   pgfkeysalso = {
      arguments = {
         {
            meta = "key list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysalso"
   },
   pgfkeysalsofiltered = {
      arguments = {
         {
            meta = "key--value-list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysalsofiltered"
   },
   pgfkeysalsofilteredfrom = {
      arguments = {
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysalsofilteredfrom"
   },
   pgfkeysalsofrom = {
      arguments = {
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysalsofrom"
   },
   pgfkeysdeactivatefamily = {
      arguments = {
         {
            meta = "family name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysdeactivatefamily"
   },
   pgfkeysdef = {
      arguments = {
         {
            meta = "key"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysdef"
   },
   pgfkeysdefargs = {
      arguments = {
         {
            meta = "key"
         },
         {
            meta = "argument pattern"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysdefargs"
   },
   pgfkeysdefnargs = {
      arguments = {
         {
            meta = "key"
         },
         {
            meta = "argument count"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysdefnargs"
   },
   pgfkeysedef = {
      arguments = {
         {
            meta = "key"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysedef"
   },
   pgfkeysedefargs = {
      arguments = {
         {
            meta = "key"
         },
         {
            meta = "argument pattern"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysedefargs"
   },
   pgfkeysedefnargs = {
      arguments = {
         {
            meta = "key"
         },
         {
            meta = "argument count"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysedefnargs"
   },
   pgfkeysevalkeyfilterwith = {
      arguments = {
         {
            meta = "full key"
         },
         {
            literal = "="
         },
         {
            meta = "filter arguments"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysevalkeyfilterwith"
   },
   pgfkeysfiltered = {
      arguments = {
         {
            meta = "key--value-list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysfiltered"
   },
   pgfkeysgetfamily = {
      arguments = {
         {
            meta = "key"
         },
         {
            meta = "resultmacro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysgetfamily"
   },
   pgfkeysgetvalue = {
      arguments = {
         {
            meta = "full key"
         },
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysgetvalue"
   },
   pgfkeysifdefined = {
      arguments = {
         {
            meta = "full key"
         },
         {
            meta = "if"
         },
         {
            meta = "else"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysifdefined"
   },
   pgfkeysiffamilydefined = {
      arguments = {
         {
            meta = "family"
         },
         {
            meta = "true case"
         },
         {
            meta = "false case"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysiffamilydefined"
   },
   pgfkeysinstallkeyfilter = {
      arguments = {
         {
            meta = "full key"
         },
         {
            meta = "optional arguments"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysinstallkeyfilter"
   },
   pgfkeysinstallkeyfilterhandler = {
      arguments = {
         {
            meta = "full key"
         },
         {
            meta = "optional arguments"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysinstallkeyfilterhandler"
   },
   pgfkeysisfamilyactive = {
      arguments = {
         {
            meta = "family"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysisfamilyactive"
   },
   pgfkeyslet = {
      arguments = {
         {
            meta = "full key"
         },
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeyslet"
   },
   pgfkeyssavekeyfilterstateto = {
      arguments = {
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeyssavekeyfilterstateto"
   },
   pgfkeyssetfamily = {
      arguments = {
         {
            meta = "key"
         },
         {
            meta = "family"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeyssetfamily"
   },
   pgfkeyssetvalue = {
      arguments = {
         {
            meta = "full key"
         },
         {
            meta = "token text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeyssetvalue"
   },
   pgfkeysvalueof = {
      arguments = {
         {
            meta = "full key"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfkeysvalueof"
   },
   pgflibraryfpuifactive = {
      arguments = {
         {
            meta = "true-code"
         },
         {
            meta = "false-code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflibraryfpuifactive"
   },
   pgflindenmayersystem = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "axiom"
         },
         {
            meta = "order"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflindenmayersystem"
   },
   pgflowlevel = {
      arguments = {
         {
            meta = "transformation code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflowlevel"
   },
   pgflowlevelobj = {
      arguments = {
         {
            meta = "transformation code"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflowlevelobj"
   },
   pgflowlevelsynccm = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflowlevelsynccm"
   },
   pgflsystemcurrentleftangle = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemcurrentleftangle"
   },
   pgflsystemcurrentrightangle = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemcurrentrightangle"
   },
   pgflsystemcurrentstep = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemcurrentstep"
   },
   pgflsystemdrawforward = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemdrawforward"
   },
   pgflsystemmoveforward = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemmoveforward"
   },
   pgflsystemrandomizeleftangle = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemrandomizeleftangle"
   },
   pgflsystemrandomizerightangle = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemrandomizerightangle"
   },
   pgflsystemrandomizestep = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemrandomizestep"
   },
   pgflsystemrestorestate = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemrestorestate"
   },
   pgflsystemsavestate = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemsavestate"
   },
   pgflsystemturnleft = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemturnleft"
   },
   pgflsystemturnright = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgflsystemturnright"
   },
   pgfmathaddtocount = {
      arguments = {
         {
            meta = "count register"
         },
         {
            meta = "expression"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathaddtocount"
   },
   pgfmathaddtocounter = {
      arguments = {
         {
            meta = "counter"
         },
         {
            meta = "expression"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathaddtocounter"
   },
   pgfmathaddtolength = {
      arguments = {
         {
            meta = "register"
         },
         {
            meta = "expression"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathaddtolength"
   },
   pgfmathanglebetweenlines = {
      arguments = {
         {
            meta = "$p_1$"
         },
         {
            meta = "$q_1$"
         },
         {
            meta = "$p_2$"
         },
         {
            meta = "$q_2$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathanglebetweenlines"
   },
   pgfmathanglebetweenpoints = {
      arguments = {
         {
            meta = "p"
         },
         {
            meta = "q"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathanglebetweenpoints"
   },
   pgfmathapproxequalto = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathapproxequalto"
   },
   pgfmathbasetoBase = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "number"
         },
         {
            meta = "base-1"
         },
         {
            meta = "base-2"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathbasetoBase"
   },
   pgfmathbasetobase = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "number"
         },
         {
            meta = "base-1"
         },
         {
            meta = "base-2"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathbasetobase"
   },
   pgfmathbasetodec = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "number"
         },
         {
            meta = "base"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathbasetodec"
   },
   pgfmathdeclarefunction = {
      arguments = {
         {
            literal = "*"
         },
         {
            meta = "name"
         },
         {
            meta = "number of arguments"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathdeclarefunction"
   },
   pgfmathdeclarerandomlist = {
      arguments = {
         {
            meta = "list name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathdeclarerandomlist"
   },
   pgfmathdectoBase = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "number"
         },
         {
            meta = "base"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathdectoBase"
   },
   pgfmathdectobase = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "number"
         },
         {
            meta = "base"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathdectobase"
   },
   pgfmathfloat = {
      arguments = {
         {
            meta = "op"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloat"
   },
   pgfmathfloatabserror = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatabserror"
   },
   pgfmathfloatcreate = {
      arguments = {
         {
            meta = "flags"
         },
         {
            meta = "mantissa"
         },
         {
            meta = "exponent"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatcreate"
   },
   pgfmathfloatgetexponent = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "exponentcount"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatgetexponent"
   },
   pgfmathfloatgetflags = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "flagscount"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatgetflags"
   },
   pgfmathfloatgetflagstomacro = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatgetflagstomacro"
   },
   pgfmathfloatgetmantissa = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "mantissadimen"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatgetmantissa"
   },
   pgfmathfloatgetmantissatok = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "mantissatoks"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatgetmantissatok"
   },
   pgfmathfloatifapproxequalrel = {
      arguments = {
         {
            meta = "a"
         },
         {
            meta = "b"
         },
         {
            meta = "true-code"
         },
         {
            meta = "false-code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatifapproxequalrel"
   },
   pgfmathfloatifflags = {
      arguments = {
         {
            meta = "floating point number"
         },
         {
            meta = "flag"
         },
         {
            meta = "true-code"
         },
         {
            meta = "false-code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatifflags"
   },
   pgfmathfloatint = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatint"
   },
   pgfmathfloatlessthan = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatlessthan"
   },
   pgfmathfloatmultiplyfixed = {
      arguments = {
         {
            meta = "float"
         },
         {
            meta = "fixed"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatmultiplyfixed"
   },
   pgfmathfloatparsenumber = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatparsenumber"
   },
   pgfmathfloatqparsenumber = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatqparsenumber"
   },
   pgfmathfloatrelerror = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatrelerror"
   },
   pgfmathfloatround = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatround"
   },
   pgfmathfloatroundzerofill = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatroundzerofill"
   },
   pgfmathfloatsetextprecision = {
      arguments = {
         {
            meta = "shift"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatsetextprecision"
   },
   pgfmathfloatshift = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "num"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatshift"
   },
   pgfmathfloattoextentedprecision = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloattoextentedprecision"
   },
   pgfmathfloattofixed = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloattofixed"
   },
   pgfmathfloattoint = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloattoint"
   },
   pgfmathfloattomacro = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "flagsmacro"
         },
         {
            meta = "mantissamacro"
         },
         {
            meta = "exponentmacro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloattomacro"
   },
   pgfmathfloattoregisters = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "flagscount"
         },
         {
            meta = "mantissadimen"
         },
         {
            meta = "exponentcount"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloattoregisters"
   },
   pgfmathfloattoregisterstok = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "flagscount"
         },
         {
            meta = "mantissatoks"
         },
         {
            meta = "exponentcount"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloattoregisterstok"
   },
   pgfmathfloattosci = {
      arguments = {
         {
            meta = "float"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloattosci"
   },
   pgfmathfloatvalueof = {
      arguments = {
         {
            meta = "float"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathfloatvalueof"
   },
   pgfmathgeneratepseudorandomnumber = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathgeneratepseudorandomnumber"
   },
   pgfmathifisint = {
      arguments = {
         {
            meta = "number constant"
         },
         {
            meta = "true code"
         },
         {
            meta = "false code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathifisint"
   },
   pgfmathlog = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathlog"
   },
   pgfmathparse = {
      arguments = {
         {
            meta = "expression"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathparse"
   },
   pgfmathpostparse = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathpostparse"
   },
   pgfmathprintnumber = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathprintnumber"
   },
   pgfmathprintnumberto = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathprintnumberto"
   },
   pgfmathqparse = {
      arguments = {
         {
            meta = "expression"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathqparse"
   },
   pgfmathrandominteger = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "minimum"
         },
         {
            meta = "maximum"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathrandominteger"
   },
   pgfmathrandomitem = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "list name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathrandomitem"
   },
   pgfmathreciprocal = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathreciprocal"
   },
   pgfmathredeclarefunction = {
      arguments = {
         {
            meta = "function name"
         },
         {
            meta = "algorithm code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathredeclarefunction"
   },
   pgfmathroundto = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathroundto"
   },
   pgfmathroundtozerofill = {
      arguments = {
         {
            meta = "x"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathroundtozerofill"
   },
   pgfmathsetbasenumberlength = {
      arguments = {
         {
            meta = "integer"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathsetbasenumberlength"
   },
   pgfmathsetcount = {
      arguments = {
         {
            meta = "count register"
         },
         {
            meta = "expression"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathsetcount"
   },
   pgfmathsetcounter = {
      arguments = {
         {
            meta = "counter"
         },
         {
            meta = "expression"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathsetcounter"
   },
   pgfmathsetlength = {
      arguments = {
         {
            meta = "register"
         },
         {
            meta = "expression"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathsetlength"
   },
   pgfmathsetlengthmacro = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "expression"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathsetlengthmacro"
   },
   pgfmathsetmacro = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "expression"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathsetmacro"
   },
   pgfmathsetseed = {
      arguments = {
         {
            meta = "integer"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathsetseed"
   },
   pgfmathtodigitlist = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathtodigitlist"
   },
   pgfmathtruncatemacro = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "expression"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmathtruncatemacro"
   },
   pgfmatrix = {
      arguments = {
         {
            meta = "shape"
         },
         {
            meta = "anchor"
         },
         {
            meta = "name"
         },
         {
            meta = "usage"
         },
         {
            meta = "shift"
         },
         {
            meta = "pre-code"
         },
         {
            meta = "matrix cells"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmatrix"
   },
   pgfmatrixbegincode = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmatrixbegincode"
   },
   pgfmatrixcurrentcolumn = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmatrixcurrentcolumn"
   },
   pgfmatrixcurrentrow = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmatrixcurrentrow"
   },
   pgfmatrixemptycode = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmatrixemptycode"
   },
   pgfmatrixendcode = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmatrixendcode"
   },
   pgfmatrixendrow = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "additional sep list",
            optional = true
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmatrixendrow"
   },
   pgfmatrixnextcell = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "additional sep list",
            optional = true
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmatrixnextcell"
   },
   pgfmetadecoratedcompleteddistance = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmetadecoratedcompleteddistance"
   },
   pgfmetadecoratedinputsegmentcompleteddistance = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmetadecoratedinputsegmentcompleteddistance"
   },
   pgfmetadecoratedinputsegmentremainingdistance = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmetadecoratedinputsegmentremainingdistance"
   },
   pgfmetadecoratedpathlength = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmetadecoratedpathlength"
   },
   pgfmetadecoratedremainingdistance = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmetadecoratedremainingdistance"
   },
   pgfmultipartnode = {
      arguments = {
         {
            meta = "shape"
         },
         {
            meta = "anchor"
         },
         {
            meta = "name"
         },
         {
            meta = "path usage command"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfmultipartnode"
   },
   pgfnode = {
      arguments = {
         {
            meta = "shape"
         },
         {
            meta = "anchor"
         },
         {
            meta = "label text"
         },
         {
            meta = "name"
         },
         {
            meta = "path usage command"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfnode"
   },
   pgfnodealias = {
      arguments = {
         {
            meta = "new name"
         },
         {
            meta = "existing node"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfnodealias"
   },
   pgfnodepostsetupcode = {
      arguments = {
         {
            meta = "node name"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfnodepostsetupcode"
   },
   pgfnoderename = {
      arguments = {
         {
            meta = "new name"
         },
         {
            meta = "existing node"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfnoderename"
   },
   pgfooappend = {
      arguments = {
         {
            meta = "attribute"
         },
         {
            meta = "value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfooappend"
   },
   pgfooclass = {
      arguments = {
         {
            delims = {
               "(",
               ")"
            },
            meta = "list of superclasses"
         },
         {
            meta = "class name"
         },
         {
            meta = "body"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfooclass"
   },
   pgfooeset = {
      arguments = {
         {
            meta = "attribute"
         },
         {
            meta = "value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfooeset"
   },
   pgfoogc = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfoogc"
   },
   pgfooget = {
      arguments = {
         {
            meta = "attribute"
         },
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfooget"
   },
   pgfoolet = {
      arguments = {
         {
            meta = "attribute"
         },
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfoolet"
   },
   pgfoonew = {
      arguments = {
         {
            meta = "object handle or attribute"
         },
         {
            literal = "="
         },
         {
            literal = "new "
         },
         {
            meta = "class name"
         },
         {
            delims = {
               "(",
               ")"
            },
            meta = "constructor arguments"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfoonew"
   },
   pgfooobj = {
      arguments = {
         {
            meta = "id"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfooobj"
   },
   pgfooprefix = {
      arguments = {
         {
            meta = "attribute"
         },
         {
            meta = "value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfooprefix"
   },
   pgfooset = {
      arguments = {
         {
            meta = "attribute"
         },
         {
            meta = "value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfooset"
   },
   pgfoosuper = {
      arguments = {
         {
            literal = "("
         },
         {
            meta = "class"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfoosuper"
   },
   pgfoothis = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfoothis"
   },
   pgfoovalueof = {
      arguments = {
         {
            meta = "attribute"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfoovalueof"
   },
   pgfpagescurrentpagewillbelogicalpage = {
      arguments = {
         {
            meta = "number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpagescurrentpagewillbelogicalpage"
   },
   pgfpagesdeclarelayout = {
      arguments = {
         {
            meta = "layout"
         },
         {
            meta = "before actions"
         },
         {
            meta = "after actions"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpagesdeclarelayout"
   },
   pgfpageslogicalpageoptions = {
      arguments = {
         {
            meta = "logical page number"
         },
         {
            keys = "$DIGESTIFDATA/pgf/keys/pgf",
            meta = "options"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpageslogicalpageoptions"
   },
   pgfpagesphysicalpageoptions = {
      arguments = {
         {
            keys = "$DIGESTIFDATA/pgf/keys/pgf",
            meta = "options"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpagesphysicalpageoptions"
   },
   pgfpagesshipoutlogicalpage = {
      arguments = {
         {
            meta = "number"
         },
         {
            meta = "box"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpagesshipoutlogicalpage"
   },
   pgfpagesuselayout = {
      arguments = {
         {
            meta = "layout"
         },
         {
            delims = {
               "[",
               "]"
            },
            keys = "$DIGESTIFDATA/pgf/keys/pgf",
            meta = "options",
            optional = true
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpagesuselayout"
   },
   pgfparserdeffinal = {
      arguments = {
         {
            meta = "parser name"
         },
         {
            meta = "action"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfparserdeffinal"
   },
   pgfparserdefunknown = {
      arguments = {
         {
            meta = "parser name"
         },
         {
            meta = "state"
         },
         {
            meta = "action"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfparserdefunknown"
   },
   pgfparserifmark = {
      arguments = {
         {
            meta = "arg"
         },
         {
            meta = "true"
         },
         {
            meta = "false"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfparserifmark"
   },
   pgfparserletter = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfparserletter"
   },
   pgfparserparse = {
      arguments = {
         {
            meta = "parser name"
         },
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfparserparse"
   },
   pgfparserreinsert = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfparserreinsert"
   },
   pgfparserset = {
      arguments = {
         {
            meta = "key list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfparserset"
   },
   pgfparserstate = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfparserstate"
   },
   pgfparserswitch = {
      arguments = {
         {
            meta = "state"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfparserswitch"
   },
   pgfparsertoken = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfparsertoken"
   },
   pgfparsetime = {
      arguments = {
         {
            meta = "time"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfparsetime"
   },
   pgfpatharc = {
      arguments = {
         {
            meta = "start angle"
         },
         {
            meta = "end angle"
         },
         {
            literal = "{"
         },
         {
            meta = "radius"
         },
         {
            literal = " and "
         },
         {
            meta = "y-radius"
         },
         {
            literal = "}"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpatharc"
   },
   pgfpatharcaxes = {
      arguments = {
         {
            meta = "start angle"
         },
         {
            meta = "end angle"
         },
         {
            meta = "first axis"
         },
         {
            meta = "second axis"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpatharcaxes"
   },
   pgfpatharcto = {
      arguments = {
         {
            meta = "x-radius"
         },
         {
            meta = "y-radius"
         },
         {
            meta = "rotation"
         },
         {
            meta = "large arc flag"
         },
         {
            meta = "counterclockwise flag"
         },
         {
            meta = "target point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpatharcto"
   },
   pgfpatharctomaxstepsize = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpatharctomaxstepsize"
   },
   pgfpatharctoprecomputed = {
      arguments = {
         {
            meta = "center point"
         },
         {
            meta = "start angle"
         },
         {
            meta = "end angle"
         },
         {
            meta = "end point"
         },
         {
            meta = "x-radius"
         },
         {
            meta = "y-radius"
         },
         {
            meta = "ratio x-radius/y-radius"
         },
         {
            meta = "ratio y-radius/x-radius"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpatharctoprecomputed"
   },
   pgfpathcircle = {
      arguments = {
         {
            meta = "center"
         },
         {
            meta = "radius"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathcircle"
   },
   pgfpathclose = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathclose"
   },
   pgfpathcosine = {
      arguments = {
         {
            meta = "vector"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathcosine"
   },
   pgfpathcurvebetweentime = {
      arguments = {
         {
            meta = "time $t_1$"
         },
         {
            meta = "time $t_2$"
         },
         {
            meta = "point p"
         },
         {
            meta = "point $s_1$"
         },
         {
            meta = "point $s_2$"
         },
         {
            meta = "point q"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathcurvebetweentime"
   },
   pgfpathcurvebetweentimecontinue = {
      arguments = {
         {
            meta = "time $t_1$"
         },
         {
            meta = "time $t_2$"
         },
         {
            meta = "point p"
         },
         {
            meta = "point $s_1$"
         },
         {
            meta = "point $s_2$"
         },
         {
            meta = "point q"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathcurvebetweentimecontinue"
   },
   pgfpathcurveto = {
      arguments = {
         {
            meta = "support 1"
         },
         {
            meta = "support 2"
         },
         {
            meta = "coordinate"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathcurveto"
   },
   pgfpathellipse = {
      arguments = {
         {
            meta = "center"
         },
         {
            meta = "first axis"
         },
         {
            meta = "second axis"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathellipse"
   },
   pgfpathgrid = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            keys = "$DIGESTIFDATA/pgf/keys/pgf",
            meta = "options",
            optional = true
         },
         {
            meta = "first corner"
         },
         {
            meta = "second corner"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathgrid"
   },
   pgfpathlineto = {
      arguments = {
         {
            meta = "coordinate"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathlineto"
   },
   pgfpathmoveto = {
      arguments = {
         {
            meta = "coordinate"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathmoveto"
   },
   pgfpathparabola = {
      arguments = {
         {
            meta = "bend vector"
         },
         {
            meta = "end vector"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathparabola"
   },
   pgfpathqcircle = {
      arguments = {
         {
            meta = "radius"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathqcircle"
   },
   pgfpathqcurveto = {
      arguments = {
         {
            meta = "$s^1_x$"
         },
         {
            meta = "$s^1_y$"
         },
         {
            meta = "$s^2_x$"
         },
         {
            meta = "$s^2_y$"
         },
         {
            meta = "$t_x$"
         },
         {
            meta = "$t_y$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathqcurveto"
   },
   pgfpathqlineto = {
      arguments = {
         {
            meta = "x dimension"
         },
         {
            meta = "y dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathqlineto"
   },
   pgfpathqmoveto = {
      arguments = {
         {
            meta = "x dimension"
         },
         {
            meta = "y dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathqmoveto"
   },
   pgfpathquadraticcurveto = {
      arguments = {
         {
            meta = "support"
         },
         {
            meta = "coordinate"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathquadraticcurveto"
   },
   pgfpathrectangle = {
      arguments = {
         {
            meta = "corner"
         },
         {
            meta = "diagonal vector"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathrectangle"
   },
   pgfpathrectanglecorners = {
      arguments = {
         {
            meta = "corner"
         },
         {
            meta = "opposite corner"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathrectanglecorners"
   },
   pgfpathsine = {
      arguments = {
         {
            meta = "vector"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathsine"
   },
   pgfpathsvg = {
      arguments = {
         {
            meta = "path"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpathsvg"
   },
   pgfplotbarwidth = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotbarwidth"
   },
   pgfplotfunction = {
      arguments = {
         {
            meta = "variable"
         },
         {
            meta = "sample list"
         },
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotfunction"
   },
   pgfplotgnuplot = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "prefix",
            optional = true
         },
         {
            meta = "function"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotgnuplot"
   },
   pgfplothandlerclosedcurve = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerclosedcurve"
   },
   pgfplothandlerconstantlineto = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerconstantlineto"
   },
   pgfplothandlerconstantlinetomarkmid = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerconstantlinetomarkmid"
   },
   pgfplothandlerconstantlinetomarkright = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerconstantlinetomarkright"
   },
   pgfplothandlercurveto = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlercurveto"
   },
   pgfplothandlerdiscard = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerdiscard"
   },
   pgfplothandlergapcycle = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlergapcycle"
   },
   pgfplothandlergaplineto = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlergaplineto"
   },
   pgfplothandlerjumpmarkleft = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerjumpmarkleft"
   },
   pgfplothandlerjumpmarkmid = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerjumpmarkmid"
   },
   pgfplothandlerjumpmarkright = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerjumpmarkright"
   },
   pgfplothandlerlineto = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerlineto"
   },
   pgfplothandlermark = {
      arguments = {
         {
            meta = "mark code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlermark"
   },
   pgfplothandlermarklisted = {
      arguments = {
         {
            meta = "mark code"
         },
         {
            meta = "index list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlermarklisted"
   },
   pgfplothandlerpolarcomb = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerpolarcomb"
   },
   pgfplothandlerpolygon = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerpolygon"
   },
   pgfplothandlerrecord = {
      arguments = {
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerrecord"
   },
   pgfplothandlerxbar = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerxbar"
   },
   pgfplothandlerxbarinterval = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerxbarinterval"
   },
   pgfplothandlerxcomb = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerxcomb"
   },
   pgfplothandlerybar = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerybar"
   },
   pgfplothandlerybarinterval = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerybarinterval"
   },
   pgfplothandlerycomb = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplothandlerycomb"
   },
   pgfplotstreamend = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotstreamend"
   },
   pgfplotstreamnewdataset = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotstreamnewdataset"
   },
   pgfplotstreampoint = {
      arguments = {
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotstreampoint"
   },
   pgfplotstreampointoutlier = {
      arguments = {
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotstreampointoutlier"
   },
   pgfplotstreampointundefined = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotstreampointundefined"
   },
   pgfplotstreamspecial = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotstreamspecial"
   },
   pgfplotstreamstart = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotstreamstart"
   },
   pgfplotxyfile = {
      arguments = {
         {
            meta = "filename"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotxyfile"
   },
   pgfplotxyzfile = {
      arguments = {
         {
            meta = "filename"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotxyzfile"
   },
   pgfplotxzerolevelstreamconstant = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotxzerolevelstreamconstant"
   },
   pgfplotyzerolevelstreamconstant = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfplotyzerolevelstreamconstant"
   },
   pgfpoint = {
      arguments = {
         {
            meta = "x coordinate"
         },
         {
            meta = "y coordinate"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpoint"
   },
   pgfpointadd = {
      arguments = {
         {
            meta = "$v_1$"
         },
         {
            meta = "$v_2$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointadd"
   },
   pgfpointanchor = {
      arguments = {
         {
            meta = "node"
         },
         {
            meta = "anchor"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointanchor"
   },
   pgfpointarcaxesattime = {
      arguments = {
         {
            meta = "time $t$"
         },
         {
            meta = "center"
         },
         {
            meta = "0-degree axis"
         },
         {
            meta = "90-degree axis"
         },
         {
            meta = "start angle"
         },
         {
            meta = "end angle"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointarcaxesattime"
   },
   pgfpointborderellipse = {
      arguments = {
         {
            meta = "direction point"
         },
         {
            meta = "corner"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointborderellipse"
   },
   pgfpointborderrectangle = {
      arguments = {
         {
            meta = "direction point"
         },
         {
            meta = "corner"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointborderrectangle"
   },
   pgfpointcurveattime = {
      arguments = {
         {
            meta = "time $t$"
         },
         {
            meta = "point $p$"
         },
         {
            meta = "point $s_1$"
         },
         {
            meta = "point $s_2$"
         },
         {
            meta = "point $q$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointcurveattime"
   },
   pgfpointcurvilinearbezierorthogonal = {
      arguments = {
         {
            meta = "distance"
         },
         {
            meta = "offset"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointcurvilinearbezierorthogonal"
   },
   pgfpointcurvilinearbezierpolar = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointcurvilinearbezierpolar"
   },
   pgfpointcylindrical = {
      arguments = {
         {
            meta = "degree"
         },
         {
            meta = "radius"
         },
         {
            meta = "height"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointcylindrical"
   },
   pgfpointdecoratedinputsegmentlast = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointdecoratedinputsegmentlast"
   },
   pgfpointdecoratedpathfirst = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointdecoratedpathfirst"
   },
   pgfpointdecoratedpathlast = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointdecoratedpathlast"
   },
   pgfpointdecorationpathlast = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointdecorationpathlast"
   },
   pgfpointdiff = {
      arguments = {
         {
            meta = "start"
         },
         {
            meta = "end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointdiff"
   },
   pgfpointintersectionofcircles = {
      arguments = {
         {
            meta = "$p_1$"
         },
         {
            meta = "$p_2$"
         },
         {
            meta = "$r_1$"
         },
         {
            meta = "$r_2$"
         },
         {
            meta = "solution"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointintersectionofcircles"
   },
   pgfpointintersectionoflines = {
      arguments = {
         {
            meta = "$p$"
         },
         {
            meta = "$q$"
         },
         {
            meta = "$s$"
         },
         {
            meta = "$t$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointintersectionoflines"
   },
   pgfpointintersectionsolution = {
      arguments = {
         {
            meta = "number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointintersectionsolution"
   },
   pgfpointlineatdistance = {
      arguments = {
         {
            meta = "distance"
         },
         {
            meta = "start point"
         },
         {
            meta = "end point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointlineatdistance"
   },
   pgfpointlineattime = {
      arguments = {
         {
            meta = "time $t$"
         },
         {
            meta = "point $p$"
         },
         {
            meta = "point $q$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointlineattime"
   },
   pgfpointmetadecoratedpathfirst = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointmetadecoratedpathfirst"
   },
   pgfpointmetadecoratedpathlast = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointmetadecoratedpathlast"
   },
   pgfpointnormalised = {
      arguments = {
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointnormalised"
   },
   pgfpointorigin = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointorigin"
   },
   pgfpointpolar = {
      arguments = {
         {
            meta = "degree"
         },
         {
            literal = "{"
         },
         {
            meta = "radius"
         },
         {
            literal = "/"
         },
         {
            meta = "y-radius"
         },
         {
            literal = "}"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointpolar"
   },
   pgfpointpolarxy = {
      arguments = {
         {
            meta = "degree"
         },
         {
            literal = "{"
         },
         {
            meta = "radius"
         },
         {
            literal = "/"
         },
         {
            meta = "y-radius"
         },
         {
            literal = "}"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointpolarxy"
   },
   pgfpointscale = {
      arguments = {
         {
            meta = "factor"
         },
         {
            meta = "coordinate"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointscale"
   },
   pgfpointshapeborder = {
      arguments = {
         {
            meta = "node"
         },
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointshapeborder"
   },
   pgfpointspherical = {
      arguments = {
         {
            meta = "longitude"
         },
         {
            meta = "latitude"
         },
         {
            meta = "radius"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointspherical"
   },
   pgfpointtransformednonlinear = {
      arguments = {
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointtransformednonlinear"
   },
   pgfpointxy = {
      arguments = {
         {
            meta = "$s_x$"
         },
         {
            meta = "$s_y$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointxy"
   },
   pgfpointxyz = {
      arguments = {
         {
            meta = "$s_x$"
         },
         {
            meta = "$s_y$"
         },
         {
            meta = "$s_z$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpointxyz"
   },
   pgfpoptype = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpoptype"
   },
   pgfpositionnodelater = {
      arguments = {
         {
            meta = "macro name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpositionnodelater"
   },
   pgfpositionnodelaterbox = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpositionnodelaterbox"
   },
   pgfpositionnodelatermaxx = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpositionnodelatermaxx"
   },
   pgfpositionnodelatermaxy = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpositionnodelatermaxy"
   },
   pgfpositionnodelaterminx = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpositionnodelaterminx"
   },
   pgfpositionnodelaterminy = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpositionnodelaterminy"
   },
   pgfpositionnodelatername = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpositionnodelatername"
   },
   pgfpositionnodelaterpath = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpositionnodelaterpath"
   },
   pgfpositionnodenow = {
      arguments = {
         {
            meta = "coordinate"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpositionnodenow"
   },
   pgfprofileend = {
      arguments = {
         {
            meta = "profiler entry name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfprofileend"
   },
   pgfprofileifisrunning = {
      arguments = {
         {
            meta = "profiler entry name"
         },
         {
            meta = "true code"
         },
         {
            meta = "false code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfprofileifisrunning"
   },
   pgfprofilenew = {
      arguments = {
         {
            meta = "name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfprofilenew"
   },
   pgfprofilenewforcommand = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "profiler entry name",
            optional = true
         },
         {
            meta = "\\textbackslash macro"
         },
         {
            meta = "arguments"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfprofilenewforcommand"
   },
   pgfprofilenewforcommandpattern = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "profiler entry name",
            optional = true
         },
         {
            meta = "\\textbackslash macro"
         },
         {
            meta = "argument pattern"
         },
         {
            meta = "invocation pattern"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfprofilenewforcommandpattern"
   },
   pgfprofilenewforenvironment = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            meta = "profiler entry name",
            optional = true
         },
         {
            meta = "environment name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfprofilenewforenvironment"
   },
   pgfprofilepostprocess = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfprofilepostprocess"
   },
   pgfprofilesetrel = {
      arguments = {
         {
            meta = "profiler entry name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfprofilesetrel"
   },
   pgfprofileshowinvocationsexpandedfor = {
      arguments = {
         {
            meta = "profiler entry name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfprofileshowinvocationsexpandedfor"
   },
   pgfprofileshowinvocationsfor = {
      arguments = {
         {
            meta = "profiler entry name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfprofileshowinvocationsfor"
   },
   pgfprofilestart = {
      arguments = {
         {
            meta = "profiler entry name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfprofilestart"
   },
   pgfpushtype = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfpushtype"
   },
   pgfqbox = {
      arguments = {
         {
            meta = "box number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfqbox"
   },
   pgfqboxsynced = {
      arguments = {
         {
            meta = "box number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfqboxsynced"
   },
   pgfqkeys = {
      arguments = {
         {
            meta = "default path"
         },
         {
            meta = "key list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfqkeys"
   },
   pgfqkeysactivatefamiliesandfilteroptions = {
      arguments = {
         {
            meta = "family list"
         },
         {
            meta = "default path"
         },
         {
            meta = "key--value-list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfqkeysactivatefamiliesandfilteroptions"
   },
   pgfqkeysactivatesinglefamilyandfilteroptions = {
      arguments = {
         {
            meta = "family name"
         },
         {
            meta = "default path"
         },
         {
            meta = "key--value-list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfqkeysactivatesinglefamilyandfilteroptions"
   },
   pgfqkeysalso = {
      arguments = {
         {
            meta = "default path"
         },
         {
            meta = "key list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfqkeysalso"
   },
   pgfqkeysfiltered = {
      arguments = {
         {
            meta = "default-path"
         },
         {
            meta = "key--value-list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfqkeysfiltered"
   },
   pgfqpoint = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfqpoint"
   },
   pgfqpointscale = {
      arguments = {
         {
            meta = "factor"
         },
         {
            meta = "coordinate"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfqpointscale"
   },
   pgfqpointxy = {
      arguments = {
         {
            meta = "$s_x$"
         },
         {
            meta = "$s_y$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfqpointxy"
   },
   pgfqpointxyz = {
      arguments = {
         {
            meta = "$s_x$"
         },
         {
            meta = "$s_y$"
         },
         {
            meta = "$s_z$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfqpointxyz"
   },
   pgfrdfabout = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfabout"
   },
   pgfrdfcontent = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfcontent"
   },
   pgfrdfdatatype = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfdatatype"
   },
   pgfrdfhref = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfhref"
   },
   pgfrdfinlist = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfinlist"
   },
   pgfrdfprefix = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfprefix"
   },
   pgfrdfproperty = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfproperty"
   },
   pgfrdfrel = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfrel"
   },
   pgfrdfresource = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfresource"
   },
   pgfrdfrev = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfrev"
   },
   pgfrdfsrc = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfsrc"
   },
   pgfrdftypeof = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdftypeof"
   },
   pgfrdfvocab = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrdfvocab"
   },
   pgfrealjobname = {
      arguments = {
         {
            meta = "name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfrealjobname"
   },
   pgfresetboundingbox = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfresetboundingbox"
   },
   pgfsetadditionalshadetransform = {
      arguments = {
         {
            meta = "transformation"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetadditionalshadetransform"
   },
   pgfsetarrows = {
      arguments = {
         {
            meta = "argument"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetarrows"
   },
   pgfsetarrowsend = {
      arguments = {
         {
            meta = "end arrow tip specification"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetarrowsend"
   },
   pgfsetarrowsstart = {
      arguments = {
         {
            meta = "start arrow tip specification"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetarrowsstart"
   },
   pgfsetbaseline = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetbaseline"
   },
   pgfsetbaselinepointlater = {
      arguments = {
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetbaselinepointlater"
   },
   pgfsetbaselinepointnow = {
      arguments = {
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetbaselinepointnow"
   },
   pgfsetbeveljoin = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetbeveljoin"
   },
   pgfsetblendmode = {
      arguments = {
         {
            meta = "mode"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetblendmode"
   },
   pgfsetbuttcap = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetbuttcap"
   },
   pgfsetcolor = {
      arguments = {
         {
            meta = "color"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetcolor"
   },
   pgfsetcornersarced = {
      arguments = {
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetcornersarced"
   },
   pgfsetcurvilinearbeziercurve = {
      arguments = {
         {
            meta = "start"
         },
         {
            meta = "first support"
         },
         {
            meta = "second support"
         },
         {
            meta = "end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetcurvilinearbeziercurve"
   },
   pgfsetdash = {
      arguments = {
         {
            meta = "list of even length of dimensions"
         },
         {
            meta = "phase"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetdash"
   },
   pgfsetdecorationsegmenttransformation = {
      arguments = {
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetdecorationsegmenttransformation"
   },
   pgfseteorule = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfseteorule"
   },
   pgfsetfading = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "transformations"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetfading"
   },
   pgfsetfadingforcurrentpath = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "transformations"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetfadingforcurrentpath"
   },
   pgfsetfadingforcurrentpathstroked = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "transformations"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetfadingforcurrentpathstroked"
   },
   pgfsetfillcolor = {
      arguments = {
         {
            meta = "color"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetfillcolor"
   },
   pgfsetfillopacity = {
      arguments = {
         {
            meta = "value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetfillopacity"
   },
   pgfsetfillpattern = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "color"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetfillpattern"
   },
   pgfsetinnerlinewidth = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetinnerlinewidth"
   },
   pgfsetinnerstrokecolor = {
      arguments = {
         {
            meta = "color"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetinnerstrokecolor"
   },
   pgfsetlayers = {
      arguments = {
         {
            meta = "layer list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetlayers"
   },
   pgfsetlinetofirstplotpoint = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetlinetofirstplotpoint"
   },
   pgfsetlinewidth = {
      arguments = {
         {
            meta = "line width"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetlinewidth"
   },
   pgfsetmatrixcolumnsep = {
      arguments = {
         {
            meta = "sep list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetmatrixcolumnsep"
   },
   pgfsetmatrixrowsep = {
      arguments = {
         {
            meta = "sep list"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetmatrixrowsep"
   },
   pgfsetmiterjoin = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetmiterjoin"
   },
   pgfsetmiterlimit = {
      arguments = {
         {
            meta = "miter limit factor"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetmiterlimit"
   },
   pgfsetmovetofirstplotpoint = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetmovetofirstplotpoint"
   },
   pgfsetnonzerorule = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetnonzerorule"
   },
   pgfsetplotmarkphase = {
      arguments = {
         {
            meta = "phase"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetplotmarkphase"
   },
   pgfsetplotmarkrepeat = {
      arguments = {
         {
            meta = "repeat"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetplotmarkrepeat"
   },
   pgfsetplotmarksize = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetplotmarksize"
   },
   pgfsetplottension = {
      arguments = {
         {
            meta = "value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetplottension"
   },
   pgfsetrectcap = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetrectcap"
   },
   pgfsetroundcap = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetroundcap"
   },
   pgfsetroundjoin = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetroundjoin"
   },
   pgfsetshortenend = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetshortenend"
   },
   pgfsetshortenstart = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetshortenstart"
   },
   pgfsetstrokecolor = {
      arguments = {
         {
            meta = "color"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetstrokecolor"
   },
   pgfsetstrokeopacity = {
      arguments = {
         {
            meta = "value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetstrokeopacity"
   },
   pgfsettransform = {
      arguments = {
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsettransform"
   },
   pgfsettransformentries = {
      arguments = {
         {
            meta = "a"
         },
         {
            meta = "b"
         },
         {
            meta = "c"
         },
         {
            meta = "d"
         },
         {
            meta = "shiftx"
         },
         {
            meta = "shifty"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsettransformentries"
   },
   pgfsettransformnonlinearflatness = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsettransformnonlinearflatness"
   },
   pgfsetxvec = {
      arguments = {
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetxvec"
   },
   pgfsetyvec = {
      arguments = {
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetyvec"
   },
   pgfsetzvec = {
      arguments = {
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsetzvec"
   },
   pgfshadecolortocmyk = {
      arguments = {
         {
            meta = "color name"
         },
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfshadecolortocmyk"
   },
   pgfshadecolortogray = {
      arguments = {
         {
            meta = "color name"
         },
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfshadecolortogray"
   },
   pgfshadecolortorgb = {
      arguments = {
         {
            meta = "color name"
         },
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfshadecolortorgb"
   },
   pgfshadepath = {
      arguments = {
         {
            meta = "shading name"
         },
         {
            meta = "angle"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfshadepath"
   },
   pgfsnapshot = {
      arguments = {
         {
            meta = "time"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsnapshot"
   },
   pgfsnapshotafter = {
      arguments = {
         {
            meta = "time"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsnapshotafter"
   },
   ["pgfsys@animate"] = {
      arguments = {
         {
            meta = "attribute"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animate"
   },
   ["pgfsys@animation@accesskey"] = {
      arguments = {
         {
            meta = "character"
         },
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@accesskey"
   },
   ["pgfsys@animation@accumulate"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@accumulate"
   },
   ["pgfsys@animation@base"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@base"
   },
   ["pgfsys@animation@canvas@transform"] = {
      arguments = {
         {
            meta = "pre"
         },
         {
            meta = "post"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@canvas@transform"
   },
   ["pgfsys@animation@event"] = {
      arguments = {
         {
            meta = "id"
         },
         {
            meta = "type"
         },
         {
            meta = "event name"
         },
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@event"
   },
   ["pgfsys@animation@freezeatend"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@freezeatend"
   },
   ["pgfsys@animation@movealong"] = {
      arguments = {
         {
            meta = "path"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@movealong"
   },
   ["pgfsys@animation@noaccumulate"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@noaccumulate"
   },
   ["pgfsys@animation@norotatealong"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@norotatealong"
   },
   ["pgfsys@animation@offset"] = {
      arguments = {
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@offset"
   },
   ["pgfsys@animation@removeatend"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@removeatend"
   },
   ["pgfsys@animation@repeat"] = {
      arguments = {
         {
            meta = "number of times"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@repeat"
   },
   ["pgfsys@animation@repeat@dur"] = {
      arguments = {
         {
            meta = "seconds"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@repeat@dur"
   },
   ["pgfsys@animation@repeat@event"] = {
      arguments = {
         {
            meta = "id"
         },
         {
            meta = "type"
         },
         {
            meta = "repeat count"
         },
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@repeat@event"
   },
   ["pgfsys@animation@repeat@indefinite"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@repeat@indefinite"
   },
   ["pgfsys@animation@restart@always"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@restart@always"
   },
   ["pgfsys@animation@restart@never"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@restart@never"
   },
   ["pgfsys@animation@restart@whennotactive"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@restart@whennotactive"
   },
   ["pgfsys@animation@rotatealong"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@rotatealong"
   },
   ["pgfsys@animation@syncbegin"] = {
      arguments = {
         {
            meta = "sync base id"
         },
         {
            meta = "type"
         },
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@syncbegin"
   },
   ["pgfsys@animation@syncend"] = {
      arguments = {
         {
            meta = "sync base id"
         },
         {
            meta = "type"
         },
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@syncend"
   },
   ["pgfsys@animation@time"] = {
      arguments = {
         {
            meta = "time"
         },
         {
            meta = "entry spline control x"
         },
         {
            meta = "entry spline control y"
         },
         {
            meta = "exit spline control x"
         },
         {
            meta = "exit spline control y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@time"
   },
   ["pgfsys@animation@tip@markers"] = {
      arguments = {
         {
            meta = "start marker"
         },
         {
            meta = "end marker"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@tip@markers"
   },
   ["pgfsys@animation@val@color@cmy"] = {
      arguments = {
         {
            meta = "cyan"
         },
         {
            meta = "magenta"
         },
         {
            meta = "yellow"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@color@cmy"
   },
   ["pgfsys@animation@val@color@cmyk"] = {
      arguments = {
         {
            meta = "cyan"
         },
         {
            meta = "magenta"
         },
         {
            meta = "yellow"
         },
         {
            meta = "black"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@color@cmyk"
   },
   ["pgfsys@animation@val@color@gray"] = {
      arguments = {
         {
            meta = "gray value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@color@gray"
   },
   ["pgfsys@animation@val@color@rgb"] = {
      arguments = {
         {
            meta = "red"
         },
         {
            meta = "green"
         },
         {
            meta = "blue"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@color@rgb"
   },
   ["pgfsys@animation@val@current"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@current"
   },
   ["pgfsys@animation@val@dash"] = {
      arguments = {
         {
            meta = "pattern"
         },
         {
            meta = "phase"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@dash"
   },
   ["pgfsys@animation@val@dimension"] = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@dimension"
   },
   ["pgfsys@animation@val@path"] = {
      arguments = {
         {
            meta = "low-level path construction command"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@path"
   },
   ["pgfsys@animation@val@scalar"] = {
      arguments = {
         {
            meta = "number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@scalar"
   },
   ["pgfsys@animation@val@scale"] = {
      arguments = {
         {
            meta = "x scale"
         },
         {
            meta = "y scale"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@scale"
   },
   ["pgfsys@animation@val@text"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@text"
   },
   ["pgfsys@animation@val@translate"] = {
      arguments = {
         {
            meta = "x dimension"
         },
         {
            meta = "y dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@translate"
   },
   ["pgfsys@animation@val@viewbox"] = {
      arguments = {
         {
            meta = "$x_1$"
         },
         {
            meta = "$y_1$"
         },
         {
            meta = "$x_2$"
         },
         {
            meta = "$y_2$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@val@viewbox"
   },
   ["pgfsys@animation@whom"] = {
      arguments = {
         {
            meta = "id"
         },
         {
            meta = "type"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@animation@whom"
   },
   ["pgfsys@append@type"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@append@type"
   },
   ["pgfsys@attach@to@id"] = {
      arguments = {
         {
            meta = "id"
         },
         {
            meta = "type"
         },
         {
            meta = "begin code"
         },
         {
            meta = "end code"
         },
         {
            meta = "setup code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@attach@to@id"
   },
   ["pgfsys@begin@idscope"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@begin@idscope"
   },
   ["pgfsys@begininvisible"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@begininvisible"
   },
   ["pgfsys@beginpicture"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@beginpicture"
   },
   ["pgfsys@beginpurepicture"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@beginpurepicture"
   },
   ["pgfsys@beginscope"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@beginscope"
   },
   ["pgfsys@beveljoin"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@beveljoin"
   },
   ["pgfsys@blend@mode"] = {
      arguments = {
         {
            meta = "value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@blend@mode"
   },
   ["pgfsys@buttcap"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@buttcap"
   },
   ["pgfsys@clipnext"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@clipnext"
   },
   ["pgfsys@closepath"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@closepath"
   },
   ["pgfsys@closestroke"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@closestroke"
   },
   ["pgfsys@color@cmy"] = {
      arguments = {
         {
            meta = "cyan"
         },
         {
            meta = "magenta"
         },
         {
            meta = "yellow"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@cmy"
   },
   ["pgfsys@color@cmy@fill"] = {
      arguments = {
         {
            meta = "cyan"
         },
         {
            meta = "magenta"
         },
         {
            meta = "yellow"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@cmy@fill"
   },
   ["pgfsys@color@cmy@stroke"] = {
      arguments = {
         {
            meta = "cyan"
         },
         {
            meta = "magenta"
         },
         {
            meta = "yellow"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@cmy@stroke"
   },
   ["pgfsys@color@cmyk"] = {
      arguments = {
         {
            meta = "cyan"
         },
         {
            meta = "magenta"
         },
         {
            meta = "yellow"
         },
         {
            meta = "black"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@cmyk"
   },
   ["pgfsys@color@cmyk@fill"] = {
      arguments = {
         {
            meta = "cyan"
         },
         {
            meta = "magenta"
         },
         {
            meta = "yellow"
         },
         {
            meta = "black"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@cmyk@fill"
   },
   ["pgfsys@color@cmyk@stroke"] = {
      arguments = {
         {
            meta = "cyan"
         },
         {
            meta = "magenta"
         },
         {
            meta = "yellow"
         },
         {
            meta = "black"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@cmyk@stroke"
   },
   ["pgfsys@color@gray"] = {
      arguments = {
         {
            meta = "black"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@gray"
   },
   ["pgfsys@color@gray@fill"] = {
      arguments = {
         {
            meta = "black"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@gray@fill"
   },
   ["pgfsys@color@gray@stroke"] = {
      arguments = {
         {
            meta = "black"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@gray@stroke"
   },
   ["pgfsys@color@reset"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@reset"
   },
   ["pgfsys@color@reset@inorderfalse"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@reset@inorderfalse"
   },
   ["pgfsys@color@reset@inordertrue"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@reset@inordertrue"
   },
   ["pgfsys@color@rgb"] = {
      arguments = {
         {
            meta = "red"
         },
         {
            meta = "green"
         },
         {
            meta = "blue"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@rgb"
   },
   ["pgfsys@color@rgb@fill"] = {
      arguments = {
         {
            meta = "red"
         },
         {
            meta = "green"
         },
         {
            meta = "blue"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@rgb@fill"
   },
   ["pgfsys@color@rgb@stroke"] = {
      arguments = {
         {
            meta = "red"
         },
         {
            meta = "green"
         },
         {
            meta = "blue"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@rgb@stroke"
   },
   ["pgfsys@color@unstacked"] = {
      arguments = {
         {
            meta = "\\LaTeX\\ color"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@color@unstacked"
   },
   ["pgfsys@curveto"] = {
      arguments = {
         {
            meta = "$x_1$"
         },
         {
            meta = "$y_1$"
         },
         {
            meta = "$x_2$"
         },
         {
            meta = "$y_2$"
         },
         {
            meta = "$x_3$"
         },
         {
            meta = "$y_3$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@curveto"
   },
   ["pgfsys@declarepattern"] = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "$x_1$"
         },
         {
            meta = "$y_1$"
         },
         {
            meta = "$x_2$"
         },
         {
            meta = "$y_2$"
         },
         {
            meta = "$x$ step"
         },
         {
            meta = "$y$ step"
         },
         {
            meta = "code"
         },
         {
            meta = "flag"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@declarepattern"
   },
   ["pgfsys@defineimage"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@defineimage"
   },
   ["pgfsys@definemask"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@definemask"
   },
   ["pgfsys@defobject"] = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "lower left"
         },
         {
            meta = "upper right"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@defobject"
   },
   ["pgfsys@discardpath"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@discardpath"
   },
   ["pgfsys@end@idscope"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@end@idscope"
   },
   ["pgfsys@endinvisible"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@endinvisible"
   },
   ["pgfsys@endpicture"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@endpicture"
   },
   ["pgfsys@endpurepicture"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@endpurepicture"
   },
   ["pgfsys@endscope"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@endscope"
   },
   ["pgfsys@endviewbox"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@endviewbox"
   },
   ["pgfsys@fadingfrombox"] = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "box"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@fadingfrombox"
   },
   ["pgfsys@fill"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@fill"
   },
   ["pgfsys@fill@opacity"] = {
      arguments = {
         {
            meta = "value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@fill@opacity"
   },
   ["pgfsys@fillstroke"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@fillstroke"
   },
   ["pgfsys@functionalshading"] = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "lower left corner"
         },
         {
            meta = "upper right corner"
         },
         {
            meta = "type 4 function"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@functionalshading"
   },
   ["pgfsys@getposition"] = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@getposition"
   },
   ["pgfsys@global@papersize"] = {
      arguments = {
         {
            meta = "width"
         },
         {
            meta = "height"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@global@papersize"
   },
   ["pgfsys@hbox"] = {
      arguments = {
         {
            meta = "box number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@hbox"
   },
   ["pgfsys@hboxsynced"] = {
      arguments = {
         {
            meta = "box number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@hboxsynced"
   },
   ["pgfsys@horishading"] = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "height"
         },
         {
            meta = "specification"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@horishading"
   },
   ["pgfsys@imagesuffixlist"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@imagesuffixlist"
   },
   ["pgfsys@invoke"] = {
      arguments = {
         {
            meta = "literals"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@invoke"
   },
   ["pgfsys@lineto"] = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@lineto"
   },
   ["pgfsys@marker@declare"] = {
      arguments = {
         {
            meta = "macro"
         },
         {
            meta = "code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@marker@declare"
   },
   ["pgfsys@marker@use"] = {
      arguments = {
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@marker@use"
   },
   ["pgfsys@markposition"] = {
      arguments = {
         {
            meta = "name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@markposition"
   },
   ["pgfsys@miterjoin"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@miterjoin"
   },
   ["pgfsys@moveto"] = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@moveto"
   },
   ["pgfsys@new@id"] = {
      arguments = {
         {
            meta = "macro"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@new@id"
   },
   ["pgfsys@opacity"] = {
      arguments = {
         {
            meta = "value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@opacity"
   },
   ["pgfsys@papersize"] = {
      arguments = {
         {
            meta = "width"
         },
         {
            meta = "height"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@papersize"
   },
   ["pgfsys@pictureboxsynced"] = {
      arguments = {
         {
            meta = "box number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@pictureboxsynced"
   },
   ["pgfsys@pop@type"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@pop@type"
   },
   ["pgfsys@push@type"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@push@type"
   },
   ["pgfsys@radialshading"] = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "starting point"
         },
         {
            meta = "specification"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@radialshading"
   },
   ["pgfsys@rdf@about"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@about"
   },
   ["pgfsys@rdf@content"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@content"
   },
   ["pgfsys@rdf@datatype"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@datatype"
   },
   ["pgfsys@rdf@href"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@href"
   },
   ["pgfsys@rdf@inlist"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@inlist"
   },
   ["pgfsys@rdf@prefix"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@prefix"
   },
   ["pgfsys@rdf@property"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@property"
   },
   ["pgfsys@rdf@rel"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@rel"
   },
   ["pgfsys@rdf@resource"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@resource"
   },
   ["pgfsys@rdf@rev"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@rev"
   },
   ["pgfsys@rdf@src"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@src"
   },
   ["pgfsys@rdf@typeof"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@typeof"
   },
   ["pgfsys@rdf@vocab"] = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rdf@vocab"
   },
   ["pgfsys@rect"] = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "y"
         },
         {
            meta = "width"
         },
         {
            meta = "height"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rect"
   },
   ["pgfsys@rectcap"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@rectcap"
   },
   ["pgfsys@roundcap"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@roundcap"
   },
   ["pgfsys@roundjoin"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@roundjoin"
   },
   ["pgfsys@setdash"] = {
      arguments = {
         {
            meta = "pattern"
         },
         {
            meta = "phase"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@setdash"
   },
   ["pgfsys@setlinewidth"] = {
      arguments = {
         {
            meta = "width"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@setlinewidth"
   },
   ["pgfsys@setmiterlimit"] = {
      arguments = {
         {
            meta = "factor"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@setmiterlimit"
   },
   ["pgfsys@setpatterncolored"] = {
      arguments = {
         {
            meta = "name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@setpatterncolored"
   },
   ["pgfsys@setpatternuncolored"] = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "red"
         },
         {
            meta = "green"
         },
         {
            meta = "blue"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@setpatternuncolored"
   },
   ["pgfsys@stroke"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@stroke"
   },
   ["pgfsys@stroke@opacity"] = {
      arguments = {
         {
            meta = "value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@stroke@opacity"
   },
   ["pgfsys@thepageheight"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@thepageheight"
   },
   ["pgfsys@thepagewidth"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@thepagewidth"
   },
   ["pgfsys@transformcm"] = {
      arguments = {
         {
            meta = "a"
         },
         {
            meta = "b"
         },
         {
            meta = "c"
         },
         {
            meta = "d"
         },
         {
            meta = "e"
         },
         {
            meta = "f"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@transformcm"
   },
   ["pgfsys@transformshift"] = {
      arguments = {
         {
            meta = "x displacement"
         },
         {
            meta = "y displacement"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@transformshift"
   },
   ["pgfsys@transformxyscale"] = {
      arguments = {
         {
            meta = "x scale"
         },
         {
            meta = "y scale"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@transformxyscale"
   },
   ["pgfsys@transparencygroupfrombox"] = {
      arguments = {
         {
            meta = "box"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@transparencygroupfrombox"
   },
   ["pgfsys@typesetpicturebox"] = {
      arguments = {
         {
            meta = "box"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@typesetpicturebox"
   },
   ["pgfsys@use@id"] = {
      arguments = {
         {
            meta = "id"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@use@id"
   },
   ["pgfsys@use@type"] = {
      arguments = {
         {
            meta = "type"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@use@type"
   },
   ["pgfsys@usefading"] = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "a"
         },
         {
            meta = "b"
         },
         {
            meta = "c"
         },
         {
            meta = "d"
         },
         {
            meta = "e"
         },
         {
            meta = "f"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@usefading"
   },
   ["pgfsys@useobject"] = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "extra code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@useobject"
   },
   ["pgfsys@vertshading"] = {
      arguments = {
         {
            meta = "name"
         },
         {
            meta = "width"
         },
         {
            meta = "specification"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@vertshading"
   },
   ["pgfsys@viewboxmeet"] = {
      arguments = {
         {
            meta = "$x_1$"
         },
         {
            meta = "$y_1$"
         },
         {
            meta = "$x_2$"
         },
         {
            meta = "$y_2$"
         },
         {
            meta = "$x'_1$"
         },
         {
            meta = "$y'_1$"
         },
         {
            meta = "$x'_2$"
         },
         {
            meta = "$y'_2$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@viewboxmeet"
   },
   ["pgfsys@viewboxslice"] = {
      arguments = {
         {
            meta = "$x_1$"
         },
         {
            meta = "$y_1$"
         },
         {
            meta = "$x_2$"
         },
         {
            meta = "$y_2$"
         },
         {
            meta = "$x'_1$"
         },
         {
            meta = "$y'_1$"
         },
         {
            meta = "$x'_2$"
         },
         {
            meta = "$y'_2$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsys@viewboxslice"
   },
   pgfsysanimate = {
      arguments = {
         {
            meta = "attribute"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimate"
   },
   pgfsysanimkeyaccesskey = {
      arguments = {
         {
            meta = "character"
         },
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyaccesskey"
   },
   pgfsysanimkeyaccumulate = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyaccumulate"
   },
   pgfsysanimkeybase = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeybase"
   },
   pgfsysanimkeycanvastransform = {
      arguments = {
         {
            meta = "pre"
         },
         {
            meta = "post"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeycanvastransform"
   },
   pgfsysanimkeyevent = {
      arguments = {
         {
            meta = "id"
         },
         {
            meta = "type"
         },
         {
            meta = "event name"
         },
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyevent"
   },
   pgfsysanimkeyfreezeatend = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyfreezeatend"
   },
   pgfsysanimkeymovealong = {
      arguments = {
         {
            meta = "path"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeymovealong"
   },
   pgfsysanimkeynoaccumulate = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeynoaccumulate"
   },
   pgfsysanimkeynorotatealong = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeynorotatealong"
   },
   pgfsysanimkeyoffset = {
      arguments = {
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyoffset"
   },
   pgfsysanimkeyremoveatend = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyremoveatend"
   },
   pgfsysanimkeyrepeat = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyrepeat"
   },
   pgfsysanimkeyrepeatdur = {
      arguments = {
         {
            meta = "seconds"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyrepeatdur"
   },
   pgfsysanimkeyrepeatevent = {
      arguments = {
         {
            meta = "id"
         },
         {
            meta = "type"
         },
         {
            meta = "repeat count"
         },
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyrepeatevent"
   },
   pgfsysanimkeyrepeatindefinite = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyrepeatindefinite"
   },
   pgfsysanimkeyrestartalways = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyrestartalways"
   },
   pgfsysanimkeyrestartnever = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyrestartnever"
   },
   pgfsysanimkeyrestartwhennotactive = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyrestartwhennotactive"
   },
   pgfsysanimkeyrotatealong = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeyrotatealong"
   },
   pgfsysanimkeysnapshotstart = {
      arguments = {
         {
            meta = "time offset"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeysnapshotstart"
   },
   pgfsysanimkeysyncbegin = {
      arguments = {
         {
            meta = "sync base id"
         },
         {
            meta = "type"
         },
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeysyncbegin"
   },
   pgfsysanimkeysyncend = {
      arguments = {
         {
            meta = "sync base id"
         },
         {
            meta = "type"
         },
         {
            meta = "time offset"
         },
         {
            meta = "begin or end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeysyncend"
   },
   pgfsysanimkeytime = {
      arguments = {
         {
            meta = "time"
         },
         {
            meta = "entry spline control x"
         },
         {
            meta = "entry spline control y"
         },
         {
            meta = "exit spline control x"
         },
         {
            meta = "exit spline control y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeytime"
   },
   pgfsysanimkeytipmarkers = {
      arguments = {
         {
            meta = "start marker"
         },
         {
            meta = "end marker"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeytipmarkers"
   },
   pgfsysanimkeywhom = {
      arguments = {
         {
            meta = "id"
         },
         {
            meta = "type"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimkeywhom"
   },
   pgfsysanimsnapshot = {
      arguments = {
         {
            meta = "time"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimsnapshot"
   },
   pgfsysanimsnapshotafter = {
      arguments = {
         {
            meta = "time"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimsnapshotafter"
   },
   pgfsysanimvalcolorcmy = {
      arguments = {
         {
            meta = "cyan"
         },
         {
            meta = "magenta"
         },
         {
            meta = "yellow"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvalcolorcmy"
   },
   pgfsysanimvalcolorcmyk = {
      arguments = {
         {
            meta = "cyan"
         },
         {
            meta = "magenta"
         },
         {
            meta = "yellow"
         },
         {
            meta = "black"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvalcolorcmyk"
   },
   pgfsysanimvalcolorgray = {
      arguments = {
         {
            meta = "gray value"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvalcolorgray"
   },
   pgfsysanimvalcolorrgb = {
      arguments = {
         {
            meta = "red"
         },
         {
            meta = "green"
         },
         {
            meta = "blue"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvalcolorrgb"
   },
   pgfsysanimvalcurrent = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvalcurrent"
   },
   pgfsysanimvaldash = {
      arguments = {
         {
            meta = "pattern"
         },
         {
            meta = "phase"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvaldash"
   },
   pgfsysanimvaldimension = {
      arguments = {
         {
            meta = "dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvaldimension"
   },
   pgfsysanimvalpath = {
      arguments = {
         {
            meta = "low-level path construction commands"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvalpath"
   },
   pgfsysanimvalscalar = {
      arguments = {
         {
            meta = "number"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvalscalar"
   },
   pgfsysanimvalscale = {
      arguments = {
         {
            meta = "x scale"
         },
         {
            meta = "y scale"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvalscale"
   },
   pgfsysanimvaltext = {
      arguments = {
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvaltext"
   },
   pgfsysanimvaltranslate = {
      arguments = {
         {
            meta = "x dimension"
         },
         {
            meta = "y dimension"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvaltranslate"
   },
   pgfsysanimvalviewbox = {
      arguments = {
         {
            meta = "$x_1$"
         },
         {
            meta = "$y_1$"
         },
         {
            meta = "$x_2$"
         },
         {
            meta = "$y_2$"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysanimvalviewbox"
   },
   pgfsysdriver = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysdriver"
   },
   ["pgfsysprotocol@bufferedfalse"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysprotocol@bufferedfalse"
   },
   ["pgfsysprotocol@bufferedtrue"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysprotocol@bufferedtrue"
   },
   ["pgfsysprotocol@flushcurrentprotocol"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysprotocol@flushcurrentprotocol"
   },
   ["pgfsysprotocol@getcurrentprotocol"] = {
      arguments = {
         {
            meta = "macro name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysprotocol@getcurrentprotocol"
   },
   ["pgfsysprotocol@invokecurrentprotocol"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysprotocol@invokecurrentprotocol"
   },
   ["pgfsysprotocol@literal"] = {
      arguments = {
         {
            meta = "literal text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysprotocol@literal"
   },
   ["pgfsysprotocol@literalbuffered"] = {
      arguments = {
         {
            meta = "literal text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysprotocol@literalbuffered"
   },
   ["pgfsysprotocol@setcurrentprotocol"] = {
      arguments = {
         {
            meta = "macro name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsysprotocol@setcurrentprotocol"
   },
   ["pgfsyssoftpath@closepath"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsyssoftpath@closepath"
   },
   ["pgfsyssoftpath@curveto"] = {
      arguments = {
         {
            meta = "a"
         },
         {
            meta = "b"
         },
         {
            meta = "c"
         },
         {
            meta = "d"
         },
         {
            meta = "x"
         },
         {
            meta = "y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsyssoftpath@curveto"
   },
   ["pgfsyssoftpath@flushcurrentpath"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsyssoftpath@flushcurrentpath"
   },
   ["pgfsyssoftpath@getcurrentpath"] = {
      arguments = {
         {
            meta = "macro name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsyssoftpath@getcurrentpath"
   },
   ["pgfsyssoftpath@invokecurrentpath"] = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsyssoftpath@invokecurrentpath"
   },
   ["pgfsyssoftpath@lineto"] = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsyssoftpath@lineto"
   },
   ["pgfsyssoftpath@moveto"] = {
      arguments = {
         {
            meta = "x"
         },
         {
            meta = "y"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsyssoftpath@moveto"
   },
   ["pgfsyssoftpath@rect"] = {
      arguments = {
         {
            meta = "lower left x"
         },
         {
            meta = "lower left y"
         },
         {
            meta = "width"
         },
         {
            meta = "height"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsyssoftpath@rect"
   },
   ["pgfsyssoftpath@setcurrentpath"] = {
      arguments = {
         {
            meta = "macro name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfsyssoftpath@setcurrentpath"
   },
   pgftext = {
      arguments = {
         {
            delims = {
               "[",
               "]"
            },
            keys = "$DIGESTIFDATA/pgf/keys/pgf",
            meta = "options",
            optional = true
         },
         {
            meta = "text"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftext"
   },
   pgftransformarcaxesattime = {
      arguments = {
         {
            meta = "time $t$"
         },
         {
            meta = "center"
         },
         {
            meta = "0-degree axis"
         },
         {
            meta = "90-degree axis"
         },
         {
            meta = "start angle"
         },
         {
            meta = "end angle"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformarcaxesattime"
   },
   pgftransformarrow = {
      arguments = {
         {
            meta = "start"
         },
         {
            meta = "end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformarrow"
   },
   pgftransformationadjustments = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformationadjustments"
   },
   pgftransformcm = {
      arguments = {
         {
            meta = "a"
         },
         {
            meta = "b"
         },
         {
            meta = "c"
         },
         {
            meta = "d"
         },
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformcm"
   },
   pgftransformcurveattime = {
      arguments = {
         {
            meta = "time"
         },
         {
            meta = "start"
         },
         {
            meta = "first support"
         },
         {
            meta = "second support"
         },
         {
            meta = "end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformcurveattime"
   },
   pgftransforminvert = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransforminvert"
   },
   pgftransformlineattime = {
      arguments = {
         {
            meta = "time"
         },
         {
            meta = "start"
         },
         {
            meta = "end"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformlineattime"
   },
   pgftransformnonlinear = {
      arguments = {
         {
            meta = "transformation code"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformnonlinear"
   },
   pgftransformreset = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformreset"
   },
   pgftransformresetnontranslations = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformresetnontranslations"
   },
   pgftransformrotate = {
      arguments = {
         {
            meta = "angles"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformrotate"
   },
   pgftransformscale = {
      arguments = {
         {
            meta = "factor"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformscale"
   },
   pgftransformshift = {
      arguments = {
         {
            meta = "point"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformshift"
   },
   pgftransformtriangle = {
      arguments = {
         {
            meta = "a"
         },
         {
            meta = "b"
         },
         {
            meta = "c"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformtriangle"
   },
   pgftransformxscale = {
      arguments = {
         {
            meta = "factor"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformxscale"
   },
   pgftransformxshift = {
      arguments = {
         {
            meta = "dimensions"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformxshift"
   },
   pgftransformxslant = {
      arguments = {
         {
            meta = "factor"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformxslant"
   },
   pgftransformyscale = {
      arguments = {
         {
            meta = "factor"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformyscale"
   },
   pgftransformyshift = {
      arguments = {
         {
            meta = "dimensions"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformyshift"
   },
   pgftransformyslant = {
      arguments = {
         {
            meta = "factor"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgftransformyslant"
   },
   pgfuseid = {
      arguments = {
         {
            meta = "name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfuseid"
   },
   pgfuseimage = {
      arguments = {
         {
            meta = "image name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfuseimage"
   },
   pgfusepath = {
      arguments = {
         {
            meta = "actions"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfusepath"
   },
   pgfusepathqclip = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfusepathqclip"
   },
   pgfusepathqfill = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfusepathqfill"
   },
   pgfusepathqfillstroke = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfusepathqfillstroke"
   },
   pgfusepathqstroke = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfusepathqstroke"
   },
   pgfuseplotmark = {
      arguments = {
         {
            meta = "plot mark name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfuseplotmark"
   },
   pgfuseshading = {
      arguments = {
         {
            meta = "shading name"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfuseshading"
   },
   pgfusetype = {
      arguments = {
         {
            meta = "type"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfusetype"
   },
   pgfverticaltransformationadjustment = {
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfverticaltransformationadjustment"
   },
   pgfwarning = {
      arguments = {
         {
            meta = "message"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>pgfwarning"
   },
   usepgflibrary = {
      arguments = {
         {
            meta = "list of libraries"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>usepgflibrary"
   },
   usepgfmodule = {
      arguments = {
         {
            meta = "module names"
         }
      },
      documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf.<CS>usepgfmodule"
   }
}
keys = {
   pgf = {
      ["/pgfparser/silent"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgfparser/silent",
         meta = "⟨boolean⟩"
      },
      ["/pgfparser/status"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgfparser/status",
         meta = "⟨boolean⟩"
      },
      ["and gate IEC symbol"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/and:gate:IEC:symbol",
         meta = "⟨text⟩"
      },
      ["animate/events/click"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animate/events/click"
      },
      ["animation/along"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/along",
         meta = "⟨path⟩"
      },
      ["animation/arrows"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/arrows",
         meta = "⟨start tip spec⟩-⟨end tip spec⟩"
      },
      ["animation/begin"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/begin",
         meta = "⟨time⟩"
      },
      ["animation/begin on"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/begin:on",
         meta = "⟨options⟩"
      },
      ["animation/end"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/end",
         meta = "⟨time⟩"
      },
      ["animation/end on"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/end:on",
         meta = "⟨options⟩"
      },
      ["animation/entry"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/entry",
         meta = "{time}{value}"
      },
      ["animation/events/begin"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/begin"
      },
      ["animation/events/delay"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/delay",
         meta = "⟨time⟩"
      },
      ["animation/events/end"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/end"
      },
      ["animation/events/event"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/event",
         meta = "⟨event name⟩"
      },
      ["animation/events/focus in"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/focus:in"
      },
      ["animation/events/focus out"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/focus:out"
      },
      ["animation/events/key"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/key",
         meta = "⟨key⟩"
      },
      ["animation/events/mouse down"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/mouse:down"
      },
      ["animation/events/mouse move"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/mouse:move"
      },
      ["animation/events/mouse out"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/mouse:out"
      },
      ["animation/events/mouse over"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/mouse:over"
      },
      ["animation/events/mouse up"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/mouse:up"
      },
      ["animation/events/of"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/of",
         meta = "⟨id⟩.⟨type⟩"
      },
      ["animation/events/of next"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/of:next",
         meta = "⟨id⟩.⟨type⟩"
      },
      ["animation/events/repeat"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/events/repeat",
         meta = "⟨number⟩"
      },
      ["animation/freeze at end"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/freeze:at:end",
         meta = "⟨true or false⟩"
      },
      ["animation/name"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/name",
         meta = "⟨name⟩"
      },
      ["animation/origin"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/origin",
         meta = "⟨pgf point⟩"
      },
      ["animation/repeat"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/repeat",
         meta = "⟨specification⟩"
      },
      ["animation/repeats"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/repeats",
         meta = "⟨specification⟩"
      },
      ["animation/restart"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/restart",
         meta = "⟨choice⟩"
      },
      ["animation/rotate along"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/rotate:along",
         meta = "⟨Boolean⟩"
      },
      ["animation/shorten <"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/shorten:<",
         meta = "⟨dimension⟩"
      },
      ["animation/shorten >"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/shorten:>",
         meta = "⟨dimension⟩"
      },
      ["animation/whom"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animation/whom",
         meta = "⟨id⟩.⟨type⟩"
      },
      ["animations/entry control"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animations/entry:control",
         meta = "{time fraction}{value fraction}"
      },
      ["animations/exit control"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animations/exit:control",
         meta = "{time fraction}{value fraction}"
      },
      ["animations/jump"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animations/jump"
      },
      ["animations/linear"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animations/linear"
      },
      ["animations/stay"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/animations/stay"
      },
      ["arrow box arrows"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:box:arrows",
         meta = "{⟨list⟩}"
      },
      ["arrow box east arrow"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:box:east:arrow",
         meta = "⟨distance⟩"
      },
      ["arrow box head extend"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:box:head:extend",
         meta = "⟨length⟩"
      },
      ["arrow box head indent"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:box:head:indent",
         meta = "⟨length⟩"
      },
      ["arrow box north arrow"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:box:north:arrow",
         meta = "⟨distance⟩"
      },
      ["arrow box shaft width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:box:shaft:width",
         meta = "⟨length⟩"
      },
      ["arrow box south arrow"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:box:south:arrow",
         meta = "⟨distance⟩"
      },
      ["arrow box tip angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:box:tip:angle",
         meta = "⟨angle⟩"
      },
      ["arrow box west arrow"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:box:west:arrow",
         meta = "⟨distance⟩"
      },
      ["arrow keys/angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/angle",
         meta = "⟨angle⟩:⟨dimension⟩ ⟨line width factor⟩ ⟨outer factor⟩"
      },
      ["arrow keys/angle'"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/angle'",
         meta = "⟨angle⟩"
      },
      ["arrow keys/arc"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/arc",
         meta = "⟨degrees⟩"
      },
      ["arrow keys/bend"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/bend"
      },
      ["arrow keys/cap angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/cap:angle",
         meta = "⟨angle⟩"
      },
      ["arrow keys/color"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/color",
         meta = "⟨color or empty⟩"
      },
      ["arrow keys/fill"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/fill",
         meta = "⟨color or none⟩"
      },
      ["arrow keys/flex"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/flex",
         meta = "⟨factor⟩"
      },
      ["arrow keys/flex'"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/flex'",
         meta = "⟨factor⟩"
      },
      ["arrow keys/harpoon"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/harpoon"
      },
      ["arrow keys/inset"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/inset",
         meta = "⟨dimension⟩ ⟨line width factor⟩ ⟨outer factor⟩"
      },
      ["arrow keys/inset'"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/inset'",
         meta = "⟨dimension⟩ ⟨length factor⟩ ⟨line width factor⟩"
      },
      ["arrow keys/left"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/left"
      },
      ["arrow keys/length"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/length",
         meta = "⟨dimension⟩ ⟨line width factor⟩ ⟨outer factor⟩"
      },
      ["arrow keys/line cap"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/line:cap",
         meta = "⟨round or butt⟩"
      },
      ["arrow keys/line join"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/line:join",
         meta = "⟨round or miter⟩"
      },
      ["arrow keys/line width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/line:width",
         meta = "⟨dimension⟩ ⟨line width factor⟩ ⟨outer factor⟩"
      },
      ["arrow keys/line width'"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/line:width'",
         meta = "⟨dimension⟩ ⟨length factor⟩"
      },
      ["arrow keys/n"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/n",
         meta = "⟨number⟩"
      },
      ["arrow keys/open"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/open"
      },
      ["arrow keys/quick"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/quick"
      },
      ["arrow keys/reversed"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/reversed"
      },
      ["arrow keys/right"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/right"
      },
      ["arrow keys/round"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/round"
      },
      ["arrow keys/sep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/sep",
         meta = "⟨dimension⟩ ⟨line width factor⟩ ⟨outer factor⟩"
      },
      ["arrow keys/sharp"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/sharp"
      },
      ["arrow keys/slant"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/slant",
         meta = "⟨factor⟩"
      },
      ["arrow keys/swap"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/swap"
      },
      ["arrow keys/width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/width",
         meta = "⟨dimension⟩ ⟨line width factor⟩ ⟨outer factor⟩"
      },
      ["arrow keys/width'"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrow:keys/width'",
         meta = "⟨dimension⟩ ⟨length factor⟩ ⟨line width factor⟩"
      },
      ["arrows keys/scale"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrows:keys/scale",
         meta = "⟨factor⟩"
      },
      ["arrows keys/scale length"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrows:keys/scale:length",
         meta = "⟨factor⟩"
      },
      ["arrows keys/scale width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/arrows:keys/scale:width",
         meta = "⟨factor⟩"
      },
      aspect = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/aspect",
         meta = "⟨value⟩"
      },
      ["bar interval shift"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/bar:interval:shift",
         meta = "{factor}"
      },
      ["bar interval width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/bar:interval:width",
         meta = "{scale}"
      },
      ["bar shift"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/bar:shift",
         meta = "{dimension}"
      },
      ["bar width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/bar:width",
         meta = "{dimension}"
      },
      ["buffer gate IEC symbol"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/buffer:gate:IEC:symbol",
         meta = "⟨text⟩"
      },
      ["callout absolute pointer"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/callout:absolute:pointer",
         meta = "⟨coordinate⟩"
      },
      ["callout pointer arc"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/callout:pointer:arc",
         meta = "⟨angle⟩"
      },
      ["callout pointer end size"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/callout:pointer:end:size",
         meta = "⟨value⟩"
      },
      ["callout pointer segments"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/callout:pointer:segments",
         meta = "⟨number⟩"
      },
      ["callout pointer shorten"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/callout:pointer:shorten",
         meta = "⟨distance⟩"
      },
      ["callout pointer start size"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/callout:pointer:start:size",
         meta = "⟨value⟩"
      },
      ["callout pointer width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/callout:pointer:width",
         meta = "⟨length⟩"
      },
      ["callout relative pointer"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/callout:relative:pointer",
         meta = "⟨coordinate⟩"
      },
      ["chamfered rectangle angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/chamfered:rectangle:angle",
         meta = "⟨angle⟩"
      },
      ["chamfered rectangle corners"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/chamfered:rectangle:corners",
         meta = "⟨list⟩"
      },
      ["chamfered rectangle sep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/chamfered:rectangle:sep",
         meta = "⟨length⟩"
      },
      ["chamfered rectangle xsep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/chamfered:rectangle:xsep",
         meta = "⟨length⟩"
      },
      ["chamfered rectangle ysep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/chamfered:rectangle:ysep",
         meta = "⟨length⟩"
      },
      ["circular sector angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/circular:sector:angle",
         meta = "⟨angle⟩"
      },
      ["cloud ignores aspect"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/cloud:ignores:aspect",
         meta = "⟨boolean⟩"
      },
      ["cloud puff arc"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/cloud:puff:arc",
         meta = "⟨angle⟩"
      },
      ["cloud puffs"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/cloud:puffs",
         meta = "⟨integer⟩"
      },
      ["cylinder body fill"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/cylinder:body:fill",
         meta = "⟨color⟩"
      },
      ["cylinder end fill"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/cylinder:end:fill",
         meta = "⟨color⟩"
      },
      ["cylinder uses custom fill"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/cylinder:uses:custom:fill",
         meta = "⟨boolean⟩"
      },
      ["dart tail angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/dart:tail:angle",
         meta = "⟨angle⟩"
      },
      ["dart tip angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/dart:tip:angle",
         meta = "⟨angle⟩"
      },
      ["data visualization/style sheets/⟨style sheet⟩/default style"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/data:visualization/style:sheets/⟨style:sheet⟩/default:style",
         meta = "⟨value⟩"
      },
      ["data/format"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/data/format",
         meta = "⟨format⟩"
      },
      ["data/headline"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/data/headline",
         meta = "⟨headline⟩"
      },
      ["data/inline"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/data/inline"
      },
      ["data/new set"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/data/new:set",
         meta = "⟨name⟩"
      },
      ["data/read from file"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/data/read:from:file",
         meta = "⟨filename⟩"
      },
      ["data/samples"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/data/samples",
         meta = "⟨number⟩"
      },
      ["data/separator"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/data/separator",
         meta = "⟨character⟩"
      },
      ["data/set"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/data/set",
         meta = "⟨name⟩"
      },
      ["data/store in set"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/data/store:in:set",
         meta = "⟨name⟩"
      },
      ["data/use set"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/data/use:set",
         meta = "⟨name⟩"
      },
      ["declare function"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/declare:function",
         meta = "⟨function definitions⟩"
      },
      decoration = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration",
         meta = "⟨decoration options⟩"
      },
      ["decoration automaton/auto corner on length"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration:automaton/auto:corner:on:length",
         meta = "⟨dimension⟩"
      },
      ["decoration automaton/auto end on length"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration:automaton/auto:end:on:length",
         meta = "⟨dimension⟩"
      },
      ["decoration automaton/if input segment is closepath"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration:automaton/if:input:segment:is:closepath",
         meta = "⟨options⟩"
      },
      ["decoration automaton/next state"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration:automaton/next:state",
         meta = "⟨new state⟩"
      },
      ["decoration automaton/persistent postcomputation"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration:automaton/persistent:postcomputation",
         meta = "⟨postcode⟩"
      },
      ["decoration automaton/persistent precomputation"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration:automaton/persistent:precomputation",
         meta = "⟨precode⟩"
      },
      ["decoration automaton/repeat state"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration:automaton/repeat:state",
         meta = "⟨repetitions⟩"
      },
      ["decoration automaton/switch if input segment less than"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration:automaton/switch:if:input:segment:less:than",
         meta = " ⟨dimension⟩ to ⟨new state⟩"
      },
      ["decoration automaton/switch if less than"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration:automaton/switch:if:less:than",
         meta = "⟨dimension⟩ to ⟨new state⟩"
      },
      ["decoration automaton/width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration:automaton/width",
         meta = "⟨dimension⟩"
      },
      ["decoration/amplitude"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/amplitude",
         meta = "⟨dimension⟩"
      },
      ["decoration/anchor"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/anchor",
         meta = "⟨anchor⟩"
      },
      ["decoration/angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/angle",
         meta = "⟨degree⟩"
      },
      ["decoration/aspect"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/aspect",
         meta = "⟨factor⟩"
      },
      ["decoration/closepath code"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/closepath:code",
         meta = "⟨code⟩"
      },
      ["decoration/curveto code"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/curveto:code",
         meta = "⟨code⟩"
      },
      ["decoration/end radius"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/end:radius",
         meta = "⟨dimension⟩"
      },
      ["decoration/foot angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/foot:angle"
      },
      ["decoration/foot length"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/foot:length"
      },
      ["decoration/foot of"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/foot:of"
      },
      ["decoration/foot sep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/foot:sep"
      },
      ["decoration/lineto code"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/lineto:code",
         meta = "⟨code⟩"
      },
      ["decoration/mark"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/mark",
         meta = "at position ⟨pos⟩ with ⟨code⟩"
      },
      ["decoration/mark connection node"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/mark:connection:node",
         meta = "⟨node name⟩"
      },
      ["decoration/mark info/distance from start"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/mark:info/distance:from:start"
      },
      ["decoration/mark info/sequence number"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/mark:info/sequence:number"
      },
      ["decoration/meta-amplitude"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/meta-amplitude",
         meta = "⟨dimension⟩"
      },
      ["decoration/meta-segment length"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/meta-segment:length",
         meta = "⟨dimension⟩"
      },
      ["decoration/mirror"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/mirror",
         meta = "⟨boolean⟩"
      },
      ["decoration/moveto code"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/moveto:code",
         meta = "⟨code⟩"
      },
      ["decoration/name"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/name",
         meta = "⟨name⟩"
      },
      ["decoration/path has corners"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/path:has:corners",
         meta = "⟨boolean⟩"
      },
      ["decoration/pre"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/pre",
         meta = "⟨decoration⟩"
      },
      ["decoration/pre length"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/pre:length",
         meta = "⟨dimension⟩"
      },
      ["decoration/radius"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/radius",
         meta = "⟨dimension⟩"
      },
      ["decoration/raise"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/raise",
         meta = "⟨dimension⟩"
      },
      ["decoration/reset marks"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/reset:marks"
      },
      ["decoration/reverse path"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/reverse:path",
         meta = "⟨boolean⟩"
      },
      ["decoration/segment length"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/segment:length",
         meta = "⟨dimension⟩"
      },
      ["decoration/shape"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape",
         meta = "⟨shape name⟩"
      },
      ["decoration/shape end height"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:end:height",
         meta = "⟨length⟩"
      },
      ["decoration/shape end size"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:end:size",
         meta = "⟨length⟩"
      },
      ["decoration/shape end width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:end:width",
         meta = "⟨length⟩"
      },
      ["decoration/shape evenly spread"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:evenly:spread",
         meta = "⟨number⟩"
      },
      ["decoration/shape height"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:height",
         meta = "⟨dimension⟩"
      },
      ["decoration/shape scaled"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:scaled",
         meta = "⟨boolean⟩"
      },
      ["decoration/shape sep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:sep",
         meta = "⟨spacing⟩"
      },
      ["decoration/shape size"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:size",
         meta = "⟨dimension⟩"
      },
      ["decoration/shape sloped"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:sloped",
         meta = "⟨boolean⟩"
      },
      ["decoration/shape start height"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:start:height",
         meta = "⟨length⟩"
      },
      ["decoration/shape start size"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:start:size",
         meta = "⟨length⟩"
      },
      ["decoration/shape start width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:start:width",
         meta = "⟨length⟩"
      },
      ["decoration/shape width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/shape:width",
         meta = "⟨dimension⟩"
      },
      ["decoration/start radius"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/start:radius",
         meta = "⟨dimension⟩"
      },
      ["decoration/stride length"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/stride:length"
      },
      ["decoration/text"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text",
         meta = "⟨text⟩"
      },
      ["decoration/text align"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:align",
         meta = "⟨align⟩"
      },
      ["decoration/text align/align"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:align/align",
         meta = "⟨alignment⟩"
      },
      ["decoration/text align/center"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:align/center"
      },
      ["decoration/text align/fit to path"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:align/fit:to:path",
         meta = "⟨boolean⟩"
      },
      ["decoration/text align/fit to path stretching spaces"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:align/fit:to:path:stretching:spaces",
         meta = "⟨boolean⟩"
      },
      ["decoration/text align/left"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:align/left"
      },
      ["decoration/text align/left indent"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:align/left:indent",
         meta = "⟨length⟩"
      },
      ["decoration/text align/right"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:align/right"
      },
      ["decoration/text align/right indent"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:align/right:indent",
         meta = "⟨length⟩"
      },
      ["decoration/text color"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:color",
         meta = "⟨color⟩"
      },
      ["decoration/text effects/character command"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/character:command",
         meta = "⟨macro⟩"
      },
      ["decoration/text effects/character count"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/character:count",
         meta = "⟨macro⟩"
      },
      ["decoration/text effects/character total"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/character:total",
         meta = "⟨macro⟩"
      },
      ["decoration/text effects/character widths"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/character:widths",
         meta = "{effects}"
      },
      ["decoration/text effects/character ⟨number⟩"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/character:⟨number⟩"
      },
      ["decoration/text effects/characters"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/characters",
         meta = "{effects}"
      },
      ["decoration/text effects/every character"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/every:character"
      },
      ["decoration/text effects/every character width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/every:character:width"
      },
      ["decoration/text effects/every first letter"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/every:first:letter"
      },
      ["decoration/text effects/every last letter"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/every:last:letter"
      },
      ["decoration/text effects/every letter"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/every:letter"
      },
      ["decoration/text effects/every word"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/every:word"
      },
      ["decoration/text effects/every word separator"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/every:word:separator"
      },
      ["decoration/text effects/fit text to path"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/fit:text:to:path",
         meta = "⟨true or false⟩"
      },
      ["decoration/text effects/group letters"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/group:letters"
      },
      ["decoration/text effects/letter count"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/letter:count",
         meta = "⟨macro⟩"
      },
      ["decoration/text effects/letter ⟨number⟩"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/letter:⟨number⟩"
      },
      ["decoration/text effects/path from text"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/path:from:text",
         meta = "{true or false}"
      },
      ["decoration/text effects/path from text angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/path:from:text:angle",
         meta = "⟨angle⟩"
      },
      ["decoration/text effects/repeat text"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/repeat:text",
         meta = "⟨times⟩"
      },
      ["decoration/text effects/replace characters"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/replace:characters",
         meta = "⟨characters⟩ with {code}"
      },
      ["decoration/text effects/reverse text"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/reverse:text"
      },
      ["decoration/text effects/scale text to path"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/scale:text:to:path",
         meta = "⟨true or false⟩"
      },
      ["decoration/text effects/style characters"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/style:characters",
         meta = "{characters} with {effects}"
      },
      ["decoration/text effects/text along path"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/text:along:path"
      },
      ["decoration/text effects/word count"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/word:count",
         meta = "⟨macro⟩"
      },
      ["decoration/text effects/word separator"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/word:separator",
         meta = "⟨character⟩"
      },
      ["decoration/text effects/word total"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/word:total",
         meta = "⟨macro⟩"
      },
      ["decoration/text effects/word ⟨m⟩ letter ⟨n⟩"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/word:⟨m⟩:letter:⟨n⟩"
      },
      ["decoration/text effects/word ⟨number⟩"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:effects/word:⟨number⟩"
      },
      ["decoration/text format delimiters"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text:format:delimiters",
         meta = "{before}{after}"
      },
      ["decoration/text/effetcs/letter total"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/text/effetcs/letter:total",
         meta = "⟨macro⟩"
      },
      ["decoration/transform"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decoration/transform",
         meta = "⟨transformations⟩"
      },
      ["decorations/post"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decorations/post",
         meta = "⟨decoration⟩"
      },
      ["decorations/post length"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/decorations/post:length",
         meta = "⟨dimension⟩"
      },
      ["direction ee arrow"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/direction:ee:arrow",
         meta = "⟨right arrow tip name⟩"
      },
      ["double arrow head extend"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/double:arrow:head:extend",
         meta = "⟨length⟩"
      },
      ["double arrow head indent"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/double:arrow:head:indent",
         meta = "⟨length⟩"
      },
      ["double arrow tip angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/double:arrow:tip:angle",
         meta = "⟨angle⟩"
      },
      ["every data"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/every:data"
      },
      ["every decoration"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/every:decoration"
      },
      ["fixed point arithmetic"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fixed:point:arithmetic",
         meta = "⟨options⟩"
      },
      ["fixed point/scale file plot x"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fixed:point/scale:file:plot:x",
         meta = "⟨factor⟩"
      },
      ["fixed point/scale file plot y"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fixed:point/scale:file:plot:y",
         meta = "⟨factor⟩"
      },
      ["fixed point/scale file plot z"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fixed:point/scale:file:plot:z",
         meta = "⟨factor⟩"
      },
      ["fixed point/scale results"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fixed:point/scale:results",
         meta = "⟨factor⟩"
      },
      ["foreach/count"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/foreach/count",
         meta = "⟨macro⟩ from ⟨value⟩"
      },
      ["foreach/evaluate"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/foreach/evaluate",
         meta = "⟨variable⟩ as ⟨macro⟩ using ⟨formula⟩"
      },
      ["foreach/parse"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/foreach/parse",
         meta = "{boolean}"
      },
      ["foreach/remember"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/foreach/remember",
         meta = "⟨variable⟩ as ⟨macro⟩ (initially ⟨value⟩)"
      },
      ["foreach/var"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/foreach/var",
         meta = "⟨variable⟩"
      },
      fpu = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fpu",
         meta = "{boolean}"
      },
      ["fpu/handlers/empty number"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fpu/handlers/empty:number",
         meta = "{input}{unreadable part}"
      },
      ["fpu/handlers/invalid number"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fpu/handlers/invalid:number",
         meta = "{input}{unreadable part}"
      },
      ["fpu/handlers/wrong lowlevel format"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fpu/handlers/wrong:lowlevel:format",
         meta = "{input}{unreadable part}"
      },
      ["fpu/output format"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fpu/output:format",
         meta = "⟨float,sci,fixed⟩"
      },
      ["fpu/rel thresh"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fpu/rel:thresh",
         meta = "{number}"
      },
      ["fpu/scale results"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/fpu/scale:results",
         meta = "{scale}"
      },
      ["gap around stream point"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/gap:around:stream:point",
         meta = "⟨dimension⟩"
      },
      ["generic circle IEC/before background"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/generic:circle:IEC/before:background",
         meta = "⟨code⟩"
      },
      ["generic diode IEC/before background"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/generic:diode:IEC/before:background",
         meta = "⟨code⟩"
      },
      ["handle new data sets in plots"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/handle:new:data:sets:in:plots",
         meta = "⟨how⟩"
      },
      ["handle outlier points in plots"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/handle:outlier:points:in:plots",
         meta = "⟨how⟩"
      },
      ["handle undefined points in plots"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/handle:undefined:points:in:plots",
         meta = "⟨how⟩"
      },
      ["images/external info"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/images/external:info",
         meta = "{boolean}"
      },
      ["images/include external"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/images/include:external"
      },
      ["inner sep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/inner:sep",
         meta = "⟨dimension⟩"
      },
      ["inner xsep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/inner:xsep",
         meta = "⟨dimension⟩"
      },
      ["inner ysep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/inner:ysep",
         meta = "⟨dimension⟩"
      },
      ["isosceles triangle apex angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/isosceles:triangle:apex:angle",
         meta = "⟨angle⟩"
      },
      ["isosceles triangle stretches"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/isosceles:triangle:stretches",
         meta = "⟨boolean⟩"
      },
      ["key filter handlers/append filtered to"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filter:handlers/append:filtered:to",
         meta = "{macro}"
      },
      ["key filter handlers/ignore"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filter:handlers/ignore"
      },
      ["key filter handlers/log"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filter:handlers/log"
      },
      ["key filters/active families"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/active:families"
      },
      ["key filters/active families and known"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/active:families:and:known"
      },
      ["key filters/active families or descendants of"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/active:families:or:descendants:of",
         meta = "{path prefix}"
      },
      ["key filters/active families or no family"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/active:families:or:no:family",
         meta = "{key filter 1}{key filter 2}"
      },
      ["key filters/active families or no family DEBUG"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/active:families:or:no:family:DEBUG",
         meta = "{key filter 1}{key filter 2}"
      },
      ["key filters/and"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/and",
         meta = "{key filter 1}{key filter 2}"
      },
      ["key filters/defined"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/defined"
      },
      ["key filters/equals"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/equals",
         meta = "{full key}"
      },
      ["key filters/false"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/false"
      },
      ["key filters/is descendant of"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/is:descendant:of",
         meta = "{path}"
      },
      ["key filters/not"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/not",
         meta = "{key filter}"
      },
      ["key filters/or"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/or",
         meta = "{key filter 1}{key filter 2}"
      },
      ["key filters/true"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/key:filters/true"
      },
      ["kite lower vertex angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/kite:lower:vertex:angle",
         meta = "⟨angle⟩"
      },
      ["kite upper vertex angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/kite:upper:vertex:angle",
         meta = "⟨angle⟩"
      },
      ["kite vertex angles"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/kite:vertex:angles",
         meta = "⟨angle specification⟩"
      },
      ["l-system"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/l-system",
         meta = "{keys}"
      },
      ["lindenmayer system"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/lindenmayer:system",
         meta = "{keys}"
      },
      ["lindenmayer system/anchor"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/lindenmayer:system/anchor",
         meta = "⟨anchor⟩"
      },
      ["lindenmayer system/axiom"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/lindenmayer:system/axiom",
         meta = "{string}"
      },
      ["lindenmayer system/left angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/lindenmayer:system/left:angle",
         meta = "⟨angle⟩"
      },
      ["lindenmayer system/name"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/lindenmayer:system/name",
         meta = "{name}"
      },
      ["lindenmayer system/order"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/lindenmayer:system/order",
         meta = "{integer}"
      },
      ["lindenmayer system/randomize angle percent"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/lindenmayer:system/randomize:angle:percent",
         meta = "⟨percentage⟩"
      },
      ["lindenmayer system/randomize step percent"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/lindenmayer:system/randomize:step:percent",
         meta = "⟨percentage⟩"
      },
      ["lindenmayer system/right angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/lindenmayer:system/right:angle",
         meta = "⟨angle⟩"
      },
      ["lindenmayer system/rule set"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/lindenmayer:system/rule:set",
         meta = "{list}"
      },
      ["lindenmayer system/step"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/lindenmayer:system/step",
         meta = "⟨length⟩"
      },
      ["local bounding box"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/local:bounding:box",
         meta = "⟨node name⟩"
      },
      ["logic gate IEC symbol align"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/logic:gate:IEC:symbol:align",
         meta = "⟨align⟩"
      },
      ["logic gate IEC symbol color"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/logic:gate:IEC:symbol:color",
         meta = "⟨color⟩"
      },
      ["logic gate anchors use bounding box"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/logic:gate:anchors:use:bounding:box",
         meta = "⟨boolean⟩"
      },
      ["logic gate input sep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/logic:gate:input:sep",
         meta = "⟨length⟩"
      },
      ["logic gate inputs"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/logic:gate:inputs",
         meta = "⟨input list⟩"
      },
      ["logic gate inverted radius"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/logic:gate:inverted:radius",
         meta = "⟨length⟩"
      },
      ["magnetic tape tail"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/magnetic:tape:tail",
         meta = "⟨proportion⟩"
      },
      ["magnetic tape tail extend"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/magnetic:tape:tail:extend",
         meta = "⟨distance⟩"
      },
      ["magnifying glass handle angle aspect"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/magnifying:glass:handle:angle:aspect",
         meta = "⟨factor⟩"
      },
      ["magnifying glass handle angle fill"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/magnifying:glass:handle:angle:fill",
         meta = "⟨degree⟩"
      },
      ["mark color"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/mark:color",
         meta = "{color}"
      },
      ["meta-decoration automaton/next state"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/meta-decoration:automaton/next:state",
         meta = "⟨new state⟩"
      },
      ["meta-decoration automaton/switch if less than"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/meta-decoration:automaton/switch:if:less:than",
         meta = "⟨dimension⟩ to ⟨new state⟩"
      },
      ["meta-decoration automaton/width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/meta-decoration:automaton/width",
         meta = "⟨dimension⟩"
      },
      ["minimum height"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/minimum:height",
         meta = "⟨dimension⟩"
      },
      ["minimum size"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/minimum:size",
         meta = "⟨dimension⟩"
      },
      ["minimum width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/minimum:width",
         meta = "⟨dimension⟩"
      },
      ["nand gate IEC symbol"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/nand:gate:IEC:symbol",
         meta = "⟨text⟩"
      },
      ["nor gate IEC symbol"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/nor:gate:IEC:symbol",
         meta = "⟨text⟩"
      },
      ["not gate IEC symbol"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/not:gate:IEC:symbol",
         meta = "⟨text⟩"
      },
      ["number format/1000 sep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/1000:sep",
         meta = "{text}"
      },
      ["number format/1000 sep in fractionals"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/1000:sep:in:fractionals",
         meta = "{boolean}"
      },
      ["number format/\\protect\\atmarktext dec sep mark"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/\\protect\\atmarktext:dec:sep:mark",
         meta = "{text}"
      },
      ["number format/\\protect\\atmarktext sci exponent mark"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/\\protect\\atmarktext:sci:exponent:mark",
         meta = "{text}"
      },
      ["number format/assume math mode"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/assume:math:mode",
         meta = "{boolean}"
      },
      ["number format/dec sep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/dec:sep",
         meta = "{text}"
      },
      ["number format/every relative"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/every:relative"
      },
      ["number format/fixed"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/fixed"
      },
      ["number format/fixed zerofill"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/fixed:zerofill",
         meta = "{boolean}"
      },
      ["number format/frac"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/frac"
      },
      ["number format/frac TeX"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/frac:TeX",
         meta = "{\\macro}"
      },
      ["number format/frac denom"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/frac:denom",
         meta = "⟨int⟩"
      },
      ["number format/frac shift"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/frac:shift",
         meta = "{integer}"
      },
      ["number format/frac whole"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/frac:whole",
         meta = "⟨true,false⟩"
      },
      ["number format/int detect"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/int:detect"
      },
      ["number format/int trunc"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/int:trunc"
      },
      ["number format/min exponent for 1000 sep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/min:exponent:for:1000:sep",
         meta = "{number}"
      },
      ["number format/precision"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/precision",
         meta = "{number}"
      },
      ["number format/print sign"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/print:sign",
         meta = "{boolean}"
      },
      ["number format/read comma as period"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/read:comma:as:period",
         meta = "⟨true,false⟩"
      },
      ["number format/relative style"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/relative:style",
         meta = "{options}"
      },
      ["number format/retain unit mantissa"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/retain:unit:mantissa",
         meta = "⟨true,false⟩"
      },
      ["number format/sci"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci"
      },
      ["number format/sci 10\\textasciicircum e"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci:10\\textasciicircum:e"
      },
      ["number format/sci 10e"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci:10e"
      },
      ["number format/sci E"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci:E"
      },
      ["number format/sci e"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci:e"
      },
      ["number format/sci generic"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci:generic",
         meta = "{keys}"
      },
      ["number format/sci generic/exponent"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci:generic/exponent",
         meta = "{text}"
      },
      ["number format/sci generic/mantissa sep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci:generic/mantissa:sep",
         meta = "{text}"
      },
      ["number format/sci precision"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci:precision",
         meta = "⟨number or empty⟩"
      },
      ["number format/sci subscript"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci:subscript"
      },
      ["number format/sci superscript"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci:superscript"
      },
      ["number format/sci zerofill"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/sci:zerofill",
         meta = "{boolean}"
      },
      ["number format/set decimal separator"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/set:decimal:separator",
         meta = "{text}"
      },
      ["number format/set thousands separator"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/set:thousands:separator",
         meta = "{text}"
      },
      ["number format/showpos"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/showpos",
         meta = "{boolean}"
      },
      ["number format/skip 0."] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/skip:0.",
         meta = "{boolean}"
      },
      ["number format/use comma"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/use:comma"
      },
      ["number format/use period"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/use:period"
      },
      ["number format/verbatim"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/verbatim"
      },
      ["number format/zerofill"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/number:format/zerofill",
         meta = "{boolean}"
      },
      ["or gate IEC symbol"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/or:gate:IEC:symbol",
         meta = "⟨text⟩"
      },
      ["outer sep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/outer:sep",
         meta = "⟨dimension or ``auto''⟩"
      },
      ["outer xsep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/outer:xsep",
         meta = "⟨dimension⟩"
      },
      ["outer ysep"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/outer:ysep",
         meta = "⟨dimension⟩"
      },
      ["plot/gnuplot call"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/plot/gnuplot:call",
         meta = "⟨gnuplot invocation⟩"
      },
      ["random starburst"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/random:starburst",
         meta = "⟨integer⟩"
      },
      ["rectangle split allocate boxes"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rectangle:split:allocate:boxes",
         meta = "⟨number⟩"
      },
      ["rectangle split draw splits"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rectangle:split:draw:splits",
         meta = "⟨boolean⟩"
      },
      ["rectangle split empty part depth"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rectangle:split:empty:part:depth",
         meta = "⟨length⟩"
      },
      ["rectangle split empty part height"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rectangle:split:empty:part:height",
         meta = "⟨length⟩"
      },
      ["rectangle split empty part width"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rectangle:split:empty:part:width",
         meta = "⟨length⟩"
      },
      ["rectangle split horizontal"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rectangle:split:horizontal",
         meta = "⟨boolean⟩"
      },
      ["rectangle split ignore empty parts"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rectangle:split:ignore:empty:parts",
         meta = "⟨boolean⟩"
      },
      ["rectangle split part align"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rectangle:split:part:align",
         meta = "{⟨list⟩}"
      },
      ["rectangle split part fill"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rectangle:split:part:fill",
         meta = "{⟨list⟩}"
      },
      ["rectangle split parts"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rectangle:split:parts",
         meta = "⟨number⟩"
      },
      ["rectangle split use custom fill"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rectangle:split:use:custom:fill",
         meta = "⟨boolean⟩"
      },
      ["regular polygon sides"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/regular:polygon:sides",
         meta = "⟨integer⟩"
      },
      ["rounded rectangle arc length"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rounded:rectangle:arc:length",
         meta = "⟨angle⟩"
      },
      ["rounded rectangle east arc"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rounded:rectangle:east:arc",
         meta = "⟨arc type⟩"
      },
      ["rounded rectangle left arc"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rounded:rectangle:left:arc",
         meta = "⟨arc type⟩"
      },
      ["rounded rectangle right arc"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rounded:rectangle:right:arc",
         meta = "⟨arc type⟩"
      },
      ["rounded rectangle west arc"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/rounded:rectangle:west:arc",
         meta = "⟨arc type⟩"
      },
      ["shape aspect"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/shape:aspect",
         meta = "⟨aspect ratio⟩"
      },
      ["shape border rotate"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/shape:border:rotate",
         meta = "⟨angle⟩"
      },
      ["shape border uses incircle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/shape:border:uses:incircle",
         meta = "⟨boolean⟩"
      },
      ["signal from"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/signal:from",
         meta = "⟨direction⟩ and ⟨opposite direction⟩"
      },
      ["signal pointer angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/signal:pointer:angle",
         meta = "⟨angle⟩"
      },
      ["signal to"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/signal:to",
         meta = "⟨direction⟩ and ⟨opposite direction⟩"
      },
      ["single arrow head extend"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/single:arrow:head:extend",
         meta = "⟨length⟩"
      },
      ["single arrow head indent"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/single:arrow:head:indent",
         meta = "⟨length⟩"
      },
      ["single arrow tip angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/single:arrow:tip:angle",
         meta = "⟨angle⟩"
      },
      ["star point height"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/star:point:height",
         meta = "⟨distance⟩"
      },
      ["star point ratio"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/star:point:ratio",
         meta = "⟨number⟩"
      },
      ["star points"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/star:points",
         meta = "⟨integer⟩"
      },
      ["starburst point height"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/starburst:point:height",
         meta = "⟨length⟩"
      },
      ["starburst points"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/starburst:points",
         meta = "⟨integer⟩"
      },
      step = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/step",
         meta = "⟨vector⟩"
      },
      stepx = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/stepx",
         meta = "⟨dimension⟩"
      },
      stepy = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/stepy",
         meta = "⟨dimension⟩"
      },
      ["tape bend bottom"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/tape:bend:bottom",
         meta = "⟨bend style⟩"
      },
      ["tape bend height"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/tape:bend:height",
         meta = "⟨length⟩"
      },
      ["tape bend top"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/tape:bend:top",
         meta = "⟨bend style⟩"
      },
      ["tex4ht node/class"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/tex4ht:node/class",
         meta = "⟨class name⟩"
      },
      ["tex4ht node/css"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/tex4ht:node/css",
         meta = "⟨filename⟩"
      },
      ["tex4ht node/escape"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/tex4ht:node/escape",
         meta = "⟨boolean⟩"
      },
      ["tex4ht node/id"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/tex4ht:node/id",
         meta = "⟨id name⟩"
      },
      ["text mark"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text:mark",
         meta = "{text}"
      },
      ["text mark as node"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text:mark:as:node",
         meta = "{boolean}"
      },
      ["text mark style"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text:mark:style",
         meta = "{options for mark=text}"
      },
      ["text/at"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text/at",
         meta = "⟨point⟩"
      },
      ["text/base"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text/base"
      },
      ["text/bottom"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text/bottom"
      },
      ["text/left"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text/left"
      },
      ["text/right"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text/right"
      },
      ["text/rotate"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text/rotate",
         meta = "⟨degree⟩"
      },
      ["text/top"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text/top"
      },
      ["text/x"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text/x",
         meta = "⟨dimension⟩"
      },
      ["text/y"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/text/y",
         meta = "⟨dimension⟩"
      },
      tips = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/tips",
         meta = "⟨value⟩"
      },
      ["trapezium angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/trapezium:angle",
         meta = "⟨angle⟩"
      },
      ["trapezium left angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/trapezium:left:angle",
         meta = "⟨angle⟩"
      },
      ["trapezium right angle"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/trapezium:right:angle",
         meta = "⟨angle⟩"
      },
      ["trapezium stretches"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/trapezium:stretches",
         meta = "⟨boolean⟩"
      },
      ["trapezium stretches body"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/trapezium:stretches:body",
         meta = "⟨boolean⟩"
      },
      ["trig format"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/trig:format",
         meta = "⟨deg,rad⟩"
      },
      ["trim lowlevel"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/trim:lowlevel",
         meta = "⟨true,false⟩"
      },
      ["xnor gate IEC symbol"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/xnor:gate:IEC:symbol",
         meta = "⟨text⟩"
      },
      ["xor gate IEC symbol"] = {
         documentation = "texdoc:generic/pgf/pgfmanual.pdf#pgf./pgf/xor:gate:IEC:symbol",
         meta = "⟨text⟩"
      }
   }
}
