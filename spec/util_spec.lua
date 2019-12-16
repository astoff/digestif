local util = require "digestif.util"
local lpeg = require "lpeg"

describe("Table utils", function()
  it("folding works", function()
    assert.equal(10, util.foldl1(function(x,y) return x+y end, {1,2,3,4}))
    assert.equal(0, util.foldl1(function(x,y) return x+y end, {0}))
  end)

  it("nested get and put work", function()
    local nested_get, nested_put = util.nested_get, util.nested_put
    local tbl = {a = {b = {c = "x"}}}
    assert.equal (tbl,       nested_get (tbl))
    assert.same  ({c = "x"}, nested_get (tbl, "a", "b"))
    assert.equal ("x",       nested_get (tbl, "a", "b", "c"))
    assert.is_nil(           nested_get (tbl, "a", "b", "c", "d"))

    local tbl2, tbl3 = {}, {}
    assert.has_error(function() nested_put("x", {}) end)
    assert.has_error(function() nested_put("x", {}, 1, nil) end)
    nested_put("z", tbl2, "d")
    assert.same({d = "z"}, tbl2)
    nested_put("x", tbl3, "a", "b", "c")
    assert.same(tbl, tbl3)
    nested_put("y", tbl3, "a", "b", "d")
    assert.same({c = "x", d = "y"}, nested_get(tbl3, "a", "b"))
  end)
end)

describe("Memoization", function()
  local tester = 0
  local function f(x, y)
    tester = tester + 1
    return (x or 0) + (y or 0)
  end
  local g = util.memoize(f)
  local function compute(...)
    tester = 0
    assert.equal(f(...), g(...))
  end

  it("remebers things", function()
    compute(1);    assert.equal(2, tester); compute(1);    assert.equal(1, tester)
    compute(1, 2); assert.equal(2, tester); compute(1, 2); assert.equal(1, tester)
    compute(1);    assert.equal(1, tester)
  end)

  it("gives the right results", function()
    compute();
    compute(nil)
    compute(nil, 1)
    compute(1, nil)
    compute(2, 1)
    compute(1, 3)
  end)
end)

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

describe("UTF-8 agnostic substring", function()
   local substring8 = util.substring8
   it("works", function()
     assert.equal("😃", substring8("😠😃", 2))
     assert.equal("😃", substring8("😃😠", 1, 1))
     assert.equal("alô", substring8("alô", 1, -2))
     assert.equal("alô", substring8("alô", 1, -1))
     assert.equal("2", substring8("123", 2, -2))
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
