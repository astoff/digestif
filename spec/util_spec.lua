local util = require "digestif.util"
local lpeg = require "lpeg"

describe("Splitting and trimming", function()
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
end)

describe("Line splitting", function()
  it("splits a string at line breaks", function()
    local text = {"one", "", "three"}
    local str = table.concat(text, "\n")
    local f = util.lines(str)
    assert.same({1, 1, 3}, {f()})
    assert.same({2, 5, 4}, {f()})
    assert.same({3, 6, 10}, {f()})
    assert.same({}, {f()})
    assert.has_error(function() return f{} end)

    assert.same({1,5,6}, util.line_indices(str))
  end)

  it("finds a blank line at the beginning", function()
    local f = util.lines("\nabc")
    assert.same({1,1,0}, {f()})

    assert.same({1,2}, util.line_indices("\nabc"))
  end)

  it("finds a blank line at the end", function()
    local f = util.lines("abc\n")
    assert.same({1,1,3}, {f()})
    assert.same({2,5,4}, {f()})
    assert.same({}, {f()})

    assert.same({1,5}, util.line_indices("abc\n"))
  end)

  it("works on empty strings", function()
    local f = util.lines("")
    assert.same({1, 1, 0}, {f()})

    local g = util.lines("\n")
    assert.same({1, 1, 0}, {g()})

    assert.same({1}, util.line_indices(""))
    assert.same({1, 2}, util.line_indices("\n"))
  end)
end)

describe("Fuzzy matching", function()
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
    local a = util.try_read_file({"spec/nonexistent", "spec/fixtures"}, "file1.tex")
    local b = util.try_read_file({"spec/nonexistent", "spec/fixtures"}, "nonexistent")
    assert.is_string(a)
    assert.is_nil(b)
  end)
end)
