local Schema = require "digestif.Schema"

describe("Schema validation", function()
  it("checks predicates", function()
    Schema{predicate = function(x) return x > 0 end}:assert(1)
    Schema{predicate = function(x) return x > 0 end}:assert_fail(0)
  end)

  it("checks type", function()
    Schema{type = "number"}:assert(1)
    Schema{type = "number"}:assert_fail("test")       
    Schema{type = "number"}:assert_fail()       
    Schema{type = "boolean"}:assert_fail(nil)       
  end)

  it("checks optionals", function()
    Schema{type = "number", optional = true}:assert(1)
    Schema{type = "number", optional = true}:assert(nil)
    Schema{type = "number", optional = true}:assert_fail("test")       
  end)

  it("checks fields", function()
    sch = Schema{
      fields = {
        num = {type = "number"},
        str = {type = "string"},
        opt = {type = "number", optional = true}
      }
    }
    sch:assert({num = 1, str = "test"})
    sch:assert({num = 1, str = "test", opt = 2})
    sch:assert_fail({num = 1})
    sch:assert_fail({num = true, str = "test", opt = 2})
    sch:assert_fail({num = 1, str = "test", opt = true})
  end)

  it("checks items", function()
    Schema{items = {type = "number"}}:assert({1,2,3})
    Schema{items = {type = "number"}}:assert_fail({1,"x",3})
    Schema{items = {type = "number"}}:assert_fail("test")
  end)

  it("checks enums", function()
    Schema{enum = {1,2,3}}:assert(2)
    Schema{enum = {1,2,3}}:assert_fail(4)
  end)

  it("checks keys", function()
    Schema{keys = {type = "string"}}:assert({a = 1, b = 2})
    Schema{keys = {type = "string"}}:assert_fail({a = 1, b = 2, [true] = 3})
  end)

  it("checks values", function()
    Schema{values = {type = "number"}}:assert({a = 1, b = 2})
    Schema{values = {type = "number"}}:assert_fail({a = 1, b = 2, c = true})
  end)
  
  it("checks alternatives", function()
    sch = Schema{{type = 'number'}, {type = 'boolean'}}
    sch:assert(1)
    sch:assert(true)
    sch:assert_fail("test")
    sch:assert_fail()
  end)
end)

