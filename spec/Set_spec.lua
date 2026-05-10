---@diagnostic disable: undefined-global

local mods = require "mods"

local Set = mods.Set
local shallow_copy = mods.tbl.copy
local runtime = mods.runtime

local upper = string.upper
local fmt = string.format
local load = loadstring or load

describe("mods.Set", function()
  local patterns = [[
    _____ a____ ___de _b_d_ _bcd_ a_c__ __c__
    a_c_e a___e abc__ abcd_ abcde ab_de ABC__
  ]]

  patterns:gsub("%S+", function(p)
    local set = Set()
    p:gsub(".", function(c)
      set[c] = c ~= "_" and true or nil
    end)
    _G[p] = set
  end)

  -- stylua: ignore
  local tests = {
    --------------fname-------------|--set--|-input-|---expected---|-same_ref?
    { "add"                         , _b_d_ , "c"   , _bcd_        , true  },
    { "clear"                       , abcde , nil   , {}           , true  },
    { "contains"                    , abcde , "a"   , true         ,       },
    { "contains"                    , abcde , "z"   , false        ,       },
    { "copy"                        , abcde , nil   , abcde        , false },
    { "difference_update"           , a_c_e , _bcd_ , a___e        , true  },
    { "difference"                  , a_c_e , _bcd_ , a___e        , false },
    { "equals"                      , abcde , abcd_ , false        ,       },
    { "equals"                      , abcde , abcde , true         ,       },
    { "intersection_update"         , a_c_e , _bcd_ , __c__        , true  },
    { "intersection"                , a_c_e , _bcd_ , __c__        , false },
    { "isdisjoint"                  , _b_d_ , ___de , false        ,       },
    { "isdisjoint"                  , _b_d_ , a___e , true         ,       },
    { "isempty"                     , _____ , nil   , true         ,       },
    { "isempty"                     , abcde , nil   , false        ,       },
    { "issubset"                    , abcd_ , abcde , true         ,       },
    { "issubset"                    , abcde , abcd_ , false        ,       },
    { "issuperset"                  , abcd_ , abcde , false        ,       },
    { "issuperset"                  , abcde , abcd_ , true         ,       },
    { "join"                        , a____ , nil   , 'a'          ,       },
    { "len"                         , _____ , nil   , 0            ,       },
    { "len"                         , a_c__ , nil   , 2            ,       },
    { "map"                         , abc__ , upper , ABC__        , false },
    { "mirror"                      , a_c__ , nil   , {a="a",c="c"}, false },
    { "pop"                         , _____ , nil   , nil          ,       },
    { "remove"                      , _bcd_ , "c"   , _b_d_        , true  },
    { "symmetric_difference_update" , a_c_e , _bcd_ , ab_de        , true  },
    { "symmetric_difference"        , a_c_e , _bcd_ , ab_de        , false },
    { "tostring"                    , a____ , nil   , '{ "a" }'    ,       },
    { "union"                       , abc__ , ___de , abcde        , false },
    { "update"                      , abc__ , ___de , abcde        , true  },
    { "values"                      , _____ , nil   , {}           ,       },
  }

  for i = 1, #tests do
    local fname, set, input, expected, same_ref =
      unpack(tests[i] --[[@as {[1]:string,[2]:mods.Set,[3]:any,[4]:any,[5]:boolean?}]], 1, 5)

    -- First argument is a Set.
    it(fmt("Set({...}):%s(...)", fname), function()
      local s = set:copy()
      local res = Set[fname](s, input)

      assert.are_same(expected, res)

      if same_ref then
        assert.are_equal(true, rawequal(s, res), "Expected same set instance")
      else
        assert.are_equal(false, rawequal(s, res), "Expected different set instances")
      end
    end)

    -- First argument is a plain table.
    it(fmt("Set.%s({...}, ...)", fname), function()
      local s = shallow_copy(set)
      local res = Set[fname](s, input)
      assert.are_same(expected, res)
    end)

    if type(input) == "table" then
      -- Second argument is a List.
      it(fmt("Set({...}):%s(List({...}))", fname), function()
        local s = set:copy()
        local res = Set[fname](s, input:values())
        assert.are_same(expected, res)
      end)
    end
  end

  describe("join()", function()
    it("returns empty string for empty set", function()
      assert.are_equal("", Set():join(","))
      assert.are_equal("", Set():join(", ", true))
    end)

    it("defaults sep to empty string", function()
      local res = Set({ "a", "b" }):join()
      assert.is_true(res == "ab" or res == "ba")
    end)

    it("stringifies non-string values", function()
      local res = Set({ "a", 1, true }):join("|")
      assert.is_truthy(res:find("true"))
      assert.is_truthy(res:find("1"))
      assert.is_truthy(res:find("a"))
    end)

    it("quotes strings when quoted is enabled", function()
      local res = Set({ true, "a", "b" }):join(" | ", true)
      assert.is_truthy(res:find('"a"'))
      assert.is_truthy(res:find('"b"'))
      assert.is_truthy(res:find("true"))
    end)

    it("handles self-reference", function()
      local s = Set({ "a" })
      s:add(s)
      local res = s:join(" | ")
      assert.is_true(res == "a | <self>" or res == "<self> | a")
    end)
  end)

  it("pop() removes and returns an arbitrary element", function()
    local s = Set({ "a", "b", "c" })
    local v = s:pop()
    assert.is_true(v == "a" or v == "b" or v == "c")
    assert.is_nil(s[v])
  end)

  it("values() returns a mods.List with all set values", function()
    local ls = { "a", "b", "c" }
    local res = Set(ls):values()
    assert.is_list(res)
    assert.are_same(ls, res:sort())
  end)

  it("has() checks raw membership", function()
    local s = Set({ "a", "b", "c" })
    assert.is_true(s:has("a"))
    assert.is_false(s:has("__tostring"))
    assert.is_false(s:has("__index"))
  end)

  it("does not treat metatable methods as set members", function()
    local s = Set({ "a", "b", "c" })
    assert.is_true(s:contains("a"))
    assert.is_false(s:contains("__tostring"))

    s:add("__tostring")
    assert.is_true(s:contains("__tostring"))
  end)

  describe("metamethods", function()
    it("__call constructs a set from a list", function()
      local s = Set({ "a", "b", "c" })
      assert.is_set(s)
      assert.are_same({ a = true, b = true, c = true }, s)
    end)

    it("__tostring renders set output", function()
      local res = tostring(Set({ 1, "b" }))
      assert.is_true(res == '{ 1, "b" }' or res == '{ "b", 1 }')
    end)

    it("__add (+) returns set union", function()
      local a = Set({ "a", "b" })
      local b = Set({ "b", "c" })
      local u = a + b
      assert.are_same({ a = true, b = true, c = true }, u)
      assert.are_same({ a = true, b = true }, a)
      assert.are_same({ b = true, c = true }, b)
    end)

    it("__sub (-) returns set difference", function()
      local a = Set({ "a", "b", "c" })
      local b = Set({ "b", "x" })
      local d = a - b
      assert.are_same({ a = true, c = true }, d)
      assert.are_same({ a = true, b = true, c = true }, a)
      assert.are_same({ b = true, x = true }, b)
    end)

    if runtime.version > 502 then
      it("__bor (|) returns set union", function()
        local a = Set({ "a", "b" })
        local b = Set({ "b", "x" })
        local u = assert(load("local x, y = ...; return x | y"))(a, b)
        assert.are_same({ a = true, b = true, x = true }, u)
        assert.are_same({ a = true, b = true }, a)
        assert.are_same({ b = true, x = true }, b)
      end)

      it("__band (&) returns set intersection", function()
        local a = Set({ "a", "b", "c" })
        local b = Set({ "b", "x" })
        local i = assert(load("local x, y = ...; return x & y"))(a, b)
        assert.are_same({ b = true }, i)
        assert.are_same({ a = true, b = true, c = true }, a)
        assert.are_same({ b = true, x = true }, b)
      end)

      it("__bxor (^) returns set symmetric difference", function()
        local a = Set({ "a", "b", "c" })
        local b = Set({ "b", "x" })
        local d = assert(load("local x, y = ...; return x ~ y"))(a, b)
        assert.are_same({ a = true, c = true, x = true }, d)
        assert.are_same({ a = true, b = true, c = true }, a)
        assert.are_same({ b = true, x = true }, b)
      end)
    end

    it("__eq (==) returns set member equality", function()
      assert.is_true(Set({ "a", "b" }) == Set({ "b", "a" }))
      assert.is_false(Set({ "a", "b" }) == Set({ "a", "c" }))
      assert.is_false(Set({ "a", "b" }) == Set({ "a", "b", "c" }))
    end)

    it("__le (<=) returns subset check", function()
      local a = Set({ "a" })
      local b = Set({ "a", "b" })
      local c = Set({ "a", "b" })
      assert.is_true(a <= b)
      assert.is_true(b <= c)
      assert.is_false(b <= a)
    end)

    it("__lt (<) returns proper subset check", function()
      local a = Set({ "a" })
      local b = Set({ "a", "b" })
      local c = Set({ "a", "b" })
      assert.is_true(a < b)
      assert.is_false(b < c)
      assert.is_false(b < a)
    end)
  end)
end)
