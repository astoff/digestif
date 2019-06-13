local util = require "digestif.util"
local lpeg = require "lpeg"

describe("LPeg utilities", function()
  it("splits a string", function()
    local s = ",a,b,,c,"
    assert.same(util.split(",")(s), {"a", "b", "c"})
    assert.same(util.split(",", nil, true)(s), {"", "a", "b", "", "c", ""})
  end)

  it("trims a string", function()
    local s = "  \n text \t "
    assert.same(util.trim()(s), "text")
    assert.same(util.trim(" ")(s), "\n text \t")
  end)

  it("cleans a string", function()
    local s = "  \n  text  text \t "
    assert.same(util.clean()(s), "text text")
    assert.same(util.clean(" ")(s), "\n text text \t")
  end)

  it("does fuzzy matching", function()
    local f = util.fuzzy_matcher("Abc")   
    assert(f"Abxc" > f"Axbxc")
    assert.truthy(f"ABC")
    assert.falsy(f"abc")
  end)
end)

describe("Path manipulation", function()
  it("joins paths", function()
    assert.same(util.path_join("a", "b/", "c"), "a/b/c")
    assert.same(util.path_join("a", "/b", "c//", "d/"), "/b/c/d/")
  end)

  it("splits paths", function()
    assert.same({util.path_split("a/b/c")}, {"a/b/", "c"})
    assert.same({util.path_split("a/b/")}, {"a/", "b"})
  end)
end)

describe("Try read file", function()
  it("works", function()
    local a = util.try_read_file({"spec/nonexistent", "spec/data"}, "file1.tex")
    local b = util.try_read_file({"spec/nonexistent", "spec/data"}, "nonexistent")
    assert.is_string(a)
    assert.is_nil(b)
  end)
end)
