local Parser = require "digestif.Parser"
local p = Parser()

describe("Argument parser", function()
  local arg_m = {}
  local arg_o = {delimiters = {"[", "]"}, optional = true}
  local arg_s = {literal = "*", optional = true}

  it("parses complete arguments", function()
       local ret = p.parse_args({arg_s, arg_o, arg_m},
         "*[a{]}c]{d{e}f}")
       local exp = {
         {pos = 1, cont = 2},
         {pos = 3, cont = 8, outer_cont = 9, outer_pos = 2},
         {pos = 10, cont = 15, outer_cont = 16, outer_pos = 9},
         pos = 1,
         cont = 16
       }
       assert.same(exp, ret)
  end)

  it("parses omitted optionals", function()
       local ret = p.parse_args({arg_s, arg_o, arg_m},
         "{def}")
       local exp = {
         {omitted = true},
         {omitted = true},
         {pos = 2, cont = 5, outer_cont = 6, outer_pos = 1},
         cont = 6,
         pos = 1
       }
       assert.same(exp, ret)
  end)

  it("skips over blanks and comments", function()
       local ret = p.parse_args({arg_o, arg_m},
         " [a%]\n]\t{d%}\nf}")
       local exp = {
         {pos = 3, cont = 7, outer_cont = 8, outer_pos = 2},
         {pos = 10, cont = 15, outer_cont = 16, outer_pos = 9},
         cont = 16,
         pos = 1
       }
       assert.same(exp, ret)
  end)

  it("succeeds at end of paragraph", function()
       local ret = p.parse_args({arg_m},
         "{d\n\nf}")
       local exp = {
         {pos = 2, cont = 3, outer_cont = 3, outer_pos = 1, incomplete = true},
         cont = 3,
         pos = 1
       }
       assert.same(exp, ret)

       local ret = p.parse_args({arg_o, arg_m},
         "[a\n\nc]{d\n\nf}")
       local exp = {
         {pos = 2, cont = 3, outer_cont = 3, outer_pos = 1, incomplete = true},
         {pos = 3, cont = 4}, -- should this be there?
         -- incomplete = true, -- shouldn't this be there?
         cont = 4,
         pos = 1
       }
       assert.same(exp, ret)
  end)
end)

describe("List parser", function()
  it("parses lists", function()
       local ret = p.parse_list("a,,b%,\n,c{,}")
       local exp = {
         {pos = 1, cont = 2},
         {pos = 4, cont = 8},
         {pos = 9, cont = 13}
       }
       assert.same(exp, ret)
  end)

  it("reads lists", function()
       local ret = p.read_list("a,,b%,\n,c{,},d%e\nf")
       local exp = {"a", "b", "c{,}", "d%e\nf"}
       assert.same(exp, ret)
  end)

  it("parses key-value lists", function()
       local ret = p.parse_kvlist("a,,b = 123, c = {,}")
       local exp = {
         {pos = 1, cont = 2, key = {pos = 1, cont = 2}},
         {pos = 4, cont = 11, key = {pos = 4, cont = 6}, value = {pos = 8, cont = 11}},
         {pos = 13, cont = 20, key = {pos = 13, cont = 15}, value = {pos = 17, cont = 20}}
       }
       assert.same(exp, ret)
  end)


end)
