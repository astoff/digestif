local package_config = package.config
local util

setup(function()
  package.config = "\\\n;\n?\n!\n-\n"
  util = require "digestif.util"
end)

teardown(function()
  package.config = package_config
end)

describe("Windows path manipulation", function()
  it("joins paths", function()
    assert.same(util.path_join("a/b", "c/"), "a/b/c/")
    assert.same(util.path_join("a", "/b"), "/b")
    assert.same(util.path_join("a/b//", "c"), "a/b//c")
    assert.same(util.path_join("", "abc"), "abc")
    assert.same(util.path_join("a", "c:/b"), "c:/b")
    assert.same(util.path_join("a", "c:\\b"), "c:\\b")
  end)

  it("splits paths", function()
    assert.same({util.path_split("a/b/c")}, {"a/b", "c"})
    assert.same({util.path_split("a/b/")}, {"a/b", ""})
    assert.same({util.path_split("abc")}, {"", "abc"})
    assert.same({util.path_split("a\\b\\c")}, {"a\\b", "c"})
    assert.same({util.path_split("a/b\\")}, {"a/b", ""})
  end)

  it("normalizes paths", function()
    assert.same(util.path_normalize("a//b///c"), "a/b/c")
    assert.same(util.path_normalize("a/b/./c"), "a/b/c")
    assert.same(util.path_normalize("a/./c"), "a/c")
    assert.same(util.path_normalize("/a/./c"), "/a/c")
    assert.same(util.path_normalize("a/../c"), "c")
    assert.same(util.path_normalize("/a/b/../c"), "/a/c")
    assert.same(util.path_normalize("/a/b/../../c"), "/c")
    assert.same(util.path_normalize("../a"), "../a")
    assert.same(util.path_normalize("a./b"), "a./b")
    assert.same(util.path_normalize("a../b"), "a../b")
    -- Windows-specific
    assert.same(util.path_normalize("a:\\b\\c"), "a:/b/c")
    assert.same(util.path_normalize("a\\\\b\\\\\\c"), "a/b/c")
    assert.same(util.path_normalize("a\\.\\c"), "a/c")
    assert.same(util.path_normalize("\\a\\.\\c"), "/a/c")
    assert.same(util.path_normalize("a\\..\\c"), "c")
    assert.same(util.path_normalize("\\a\\b\\..\\c"), "/a/c")
    assert.same(util.path_normalize("\\a\\b\\..\\..\\c"), "/c")
    assert.same(util.path_normalize("..\\a"), "../a")
    assert.same(util.path_normalize("a.\\b"), "a./b")
    assert.same(util.path_normalize("a..\\b"), "a../b")
  end)
end)
