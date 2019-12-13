local Cache = require "digestif.Cache"
local Manuscript = require"digestif.Manuscript"
require "digestif.config".data_dirs = {"./data"}

local FIXTURES = "./spec/fixtures/"

describe("Delivery of file contents", function()
  it("keeps stored files until told to forget", function()
    local tmp1, tmp2 = os.tmpname(), os.tmpname()
    os.remove(tmp1); os.remove(tmp2)

    local cache = Cache{[tmp1] = "foo"}
    cache:put(tmp2, "bar")

    local str1, str2 = cache(tmp1), cache(tmp2)
    assert.equal("foo", str1)
    assert.equal("bar", str2)

    cache:forget(tmp1)
    local str3 = cache(tmp1)
    assert.is_nil(str3)

    collectgarbage(); collectgarbage()
    assert.equal("bar", cache(tmp2))
  end)

  it("reads from disk and keeps file contents only while needed", function()
    local tmp1, tmp2 = os.tmpname(), os.tmpname()
    finally(function() os.remove(tmp1); os.remove(tmp2) end)
    io.open(tmp1, "w"):write("foo"):flush()
    io.open(tmp2, "w"):write("bar"):flush()

    local cache = Cache()
    
    local str1, token = cache(tmp1)
    local str2 = cache(tmp2)
    assert.equal("foo", str1)
    assert.equal("bar", str2)

    io.open(tmp1, "w"):write("foo2"):flush()
    io.open(tmp2, "w"):write("bar2"):flush()
    collectgarbage(); collectgarbage()

    str1, str2 = cache(tmp1), cache(tmp2)
    assert.equal("foo", str1)
    assert.equal("bar2", str2)

    token = nil
    collectgarbage(); collectgarbage()
    str1 = cache(tmp1)
    assert.equal("foo2", str1)
  end)
end)

describe("Construction of manuscript objects", function()
  it("finds the root manuscript via magic comments", function()
    local c = Cache()
    local m = c:manuscript(FIXTURES .. 'child.tex', "latex")
    assert.equal(FIXTURES .. 'child.tex', m.filename)
    assert.equal(FIXTURES .. 'root.tex', m.root.filename)
  end)

  it("works if root does not point back to to manuscript", function()
    local tmp = os.tmpname()
    finally(function() os.remove(tmp) end)
    
    local c = Cache()
    local m = c:manuscript(tmp, "latex", FIXTURES .. 'root.tex')
    assert.equal(tmp, m.filename)
    assert.is_nil(m.parent)
    assert.equal(m, m.root)
  end)

  it("keeps manuscripts only while reachable if contents were read from disk", function()
    local tmp1, tmp2 = os.tmpname(), os.tmpname()
    finally(function() os.remove(tmp1); os.remove(tmp2) end)
    io.open(tmp1, "w"):write("\\input{" .. tmp2 .. "}"):flush()
    io.open(tmp2, "w"):write("% !TeX root = " .. tmp1):flush()

    local alive1, alive2 = true, true
    
    local c = Cache()
    local m = c:manuscript(tmp2, "latex")
    assert.equal(tmp1, m.root.filename)

    m.tracker = setmetatable({}, {__gc = function() alive2 = false end})
    m.root.tracker = setmetatable({}, {__gc = function() alive1 = false end})

    collectgarbage(); collectgarbage()
    assert.is_true(alive1)
    assert.is_true(alive2)

    m = nil
    collectgarbage(); collectgarbage()
    assert.is_false(alive1)
    assert.is_false(alive2)
  end)

  it("keeps manuscripts with temporary contents until cache:forget", function()
    local tmp1, tmp2 = os.tmpname(), os.tmpname()
    finally(function() os.remove(tmp1); os.remove(tmp2) end)
    io.open(tmp1, "w"):write("\\input{" .. tmp2 .. "}"):flush()

    local alive1, alive2 = true, true
    
    local c = Cache{[tmp2] = "% !TeX root = " .. tmp1}
    local m = c:manuscript(tmp2, "latex")
    assert.equal(tmp1, m.root.filename)

    m.tracker = setmetatable({}, {__gc = function() alive2 = false end})
    m.root.tracker = setmetatable({}, {__gc = function() alive1 = false end})

    m = nil
    collectgarbage(); collectgarbage()
    assert.is_true(alive1)
    assert.is_true(alive2)

    c:forget(tmp2)
    collectgarbage(); collectgarbage()
    assert.is_false(alive1)
    assert.is_false(alive2)
end)

  it("keeps the root manuscript when the child changes", function()
    local tmp1, tmp2 = os.tmpname(), os.tmpname()
    finally(function() os.remove(tmp1); os.remove(tmp2) end)
    io.open(tmp1, "w"):write("\\input{" .. tmp2 .. "}"):flush()

    local alive1, alive2 = true, true
    
    local c = Cache{[tmp2] = "% !TeX root = " .. tmp1}
    local m = c:manuscript(tmp2, "latex")
    assert.equal(tmp1, m.root.filename)

    m.tracker = setmetatable({}, {__gc = function() alive2 = false end})
    m.root.tracker = setmetatable({}, {__gc = function() alive1 = false end})

    c:put(tmp2, "new version\n" .. "% !TeX root = " .. tmp1)
    collectgarbage(); collectgarbage()
    assert.is_true(alive1)

    os.remove(tmp1)
    m = c:manuscript(tmp2, "latex")
    collectgarbage(); collectgarbage()
    assert.is_true(alive1)
    assert.equal(tmp1, m.root.filename)
    -- the above will fail if tmp1 was re-read from disk and m.root
    -- reconstructed
  end)

  it("forgets root manuscript when no longer relevant", function()
    local tmp1, tmp2 = os.tmpname(), os.tmpname()
    finally(function() os.remove(tmp1); os.remove(tmp2) end)
    io.open(tmp1, "w"):write("\\input{" .. tmp2 .. "}"):flush()

    local alive1, alive2 = true, true
    
    local c = Cache{[tmp2] = "% !TeX root = " .. tmp1}
    local m = c:manuscript(tmp2, "latex")
    assert.equal(tmp1, m.root.filename)

    m.tracker = setmetatable({}, {__gc = function() alive2 = false end})
    m.root.tracker = setmetatable({}, {__gc = function() alive1 = false end})

    m = nil
    c:put(tmp2, "no root anymore")
    collectgarbage(); collectgarbage()
    assert.is_true(alive1)
    assert.is_true(alive2)

    c:manuscript(tmp2, "latex")
    collectgarbage(); collectgarbage()
    assert.is_false(alive1)
    assert.is_false(alive2)
  end)
end)
