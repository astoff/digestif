local Schema = require "digestif.Schema"
local data = require "digestif.data"
require "digestif.config".data_dirs = {"./data"}
require "digestif.config".verbose = true

documentation_schema = Schema{
  description = "Hyperlink to documentation (texdoc, info, web, etc.)",
  type = "string",
  optional = true
}

key_schema = Schema{
  description = "Description of a valid key (possibly with values) to be passed as argument",
  fields = {
    summary = {
      description = "A short (one line) description of the key",
      type = "string",
      optional = true
    },
    documentation = documentation_schema,
    meta = {
      description = "If the key takes a value, a generic name of argument for pretty-printing",
      type = "string",
      optional = true
    },
    keys = {
      description = "The value of a key can be a list of keys or key-value pairs",
      keys = {type = "string"},
      values = nil, -- set recursively to key_schema below
      optional = true
    },
    values = {
      description = "A list of string, equivalent to a collection of keys with no extra details",
      items = {type = "string"},
      optional = true
    },
  }
}
key_schema.fields.keys.values = key_schema

argument_schema = Schema{
  description = "Description of a command argument",
  fields = {
    meta = {
      description = "Generic name of argument for pretty-printing",
      type = "string",
      optional = true
    },
    literal = {
      description = "A string, in case the argument is a literal piece of text",
      type = "string",
      optional = true
    },
    optional = {
      description = "Whether the argument can be omitted",
      type = "boolean",
      optional = true
    },
    delimiters = {
      description = [[Indicates the argument delimiters as follows:
                       - A pair of strings
                       - The boolean value false, to indicate no delimiters allowed
                       - nil to indicate optional curly braces delimiters]],
      optional = true,
      [1] = {items = {type = "string"},
             predicate = (function(x) return (type(x) == "table") and (#x == 2) end)},
      [2] = {description = "If false, indicates no delimiters are allowed",
             predicate = (function(x) return x == false end)}
    },
    symbol = {
      description = "The symbol inserted by this command, if applicable",
      type = "string",
      optional = true
    },
    keys = {
      description = [[Indicates the argument takes a list of key-value arguments;
                      this field then contains a table of possible keys and their properties]],
      keys = {type = "string"},
      values = key_schema,
      optional = true
    }
  }
}

command_schema = Schema{
  fields = {
    summary = {
      description = "A short (one line) description of the command",
      type = "string",
      optional = true
    },
    documentation = documentation_schema,
    arguments = {
      items = argument_schema,
      optional = true
    },
    action = {
      description = "A string used to tag commends with similar purpose",
      type = "string",
      optional = true
    }
  }
}

datafile_schema = Schema{
  fields = {
    comments = {
      description = "Metadata for the data file",
      type = "string",
      optional = true -- should be present, with license info
    },
    package = {
      description = "Information about the TeX component described by the data file",
      fields = {
        dependencies = {
          description = "A list of dependencies of the package",
          items = {enum = datafiles},
          optional = true
        },
        documentation = documentation_schema,
        name = {
          description = "Name of the package",
          type = "string"
        }
      },
      optional = true
    },
    commands = {
      description = "The list of commands defined by the package",
      keys = {type = "string"},
      values = command_schema,
      optional = true
    },
    environments = {
      description = "The list of environments defined by the package",
      keys = {type = "string"},
      values = command_schema,
      optional = true
    }
  }
}

describe("Data check", function()
  it("loads data files", function()
    assert.not_same(data.load_all(), {})
  end)

  for pkg in pairs(data.load_all()) do
    it("validates data for " .. pkg, function()
      datafile_schema:assert(data.require(pkg))
    end)
  end
end)
