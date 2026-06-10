---@diagnostic disable: undefined-global

local mods = require "mods"

local List = mods.list
local Set = mods.set

local args_repr = mods.utils.args_repr
local stringify = mods.stringify
local shallow_copy = mods.tbl.copy

local fmt = string.format
local upper = string.upper
local len = string.len
local unpack = table.unpack

describe("mods.list", function()
  local L = List
  local patterns = [[
    _____ ____e ___de __c__ _b_d_ _bc__ _bcd_ a___e a_c__
    a_c_e ab___ abc__ abcd_ abcde edcba ABC__ AZ___ _ZAZA
    AZAZA __2__ _12__ _1_3_ _123_ _1_3_ _12_4 a1 b2 abcabc  
  ]]

  patterns:gsub("%S+", function(p)
    local ls = List()
    p:gsub(".", function(c)
      ls[#ls + 1] = c ~= "_" and (tonumber(c) or c) or nil
    end)
    _G[p] = ls
  end)

  -- stylua: ignore start
  local not_c   = function(v) return v ~= "c" end
  local not_z   = function(v) return v ~= "z" end
  local is_b    = function(v) return v == "b" end
  local is_c    = function(v) return v == "c" end
  local add     = function(a, b) return a + b end
  local ac, e   = a_c__, ____e
  local a1_e2   = { a = 1, e = 2 }
  local words   = List({ "aa", "b", "ccc", "dd" })
  local by_len  = { List({ "b" }), List({ "aa", "dd" }), List({ "ccc" }) }
  local mixed   = List({ "a", 1, true, false, "b", "a", 2 })
  local by_type = {
    ["string"]  = List({ "a", "b", "a" }),
    ["number"]  = List({ 1, 2 }),
    ["boolean"] = List({ true, false}),
  }

  it("equals() compares lists with shallow equality", function()
    assert.is_true(List({ "a", "b" }):equals(List({ "a", "b" })))
    assert.is_true(List({ "a", "b", a1 }):equals(List({ "a", "b", a1 })))
    assert.is_false(List({ "a", "b", {} }):equals(List({ "a", "b", {} })))
    assert.is_false(List({ "a", "b" }):equals(List({ "a", "c" })))
    assert.is_false(List({ "a", "b" }):equals(List({ "a", "b", "c" })))

    local a = {}
    assert.is_true(List({ a }):equals(List({ a })))
    assert.is_false(List({ {} }):equals(List({ {} })))
  end)


  local tests = {
    ------fname------|----list---|-----params-----|----expected----|-same_ref?---
    { "all"          , _____     , { is_b       } , true           ,       },
    { "all"          , abc__     , { is_b       } , false          ,       },
    { "all"          , abc__     , { not_z      } , true           ,       },
    { "any"          , abc__     , { is_b       } , true           ,       },
    { "append"       , abc__     , {            } , abc__          , true  },
    { "append"       , abc__     , { "d"        } , abcd_          , true  },
    { "clear"        , abcde     , {            } , _____          , true  },
    { "concat"       , abcde     , {            } , "abcde"        ,       },
    { "contains"     , _bcd_     , {            } , false          ,       },
    { "contains"     , _bcd_     , { "C"        } , false          ,       },
    { "contains"     , _bcd_     , { "c"        } , true           ,       },
    { "copy"         , abcde     , {            } , abcde          , false },
    { "count"        , AZAZA     , {            } , 0              ,       },
    { "count"        , AZAZA     , { 'A'        } , 3              ,       },
    { "difference"   , a_c_e     , { _bcd_      } , a___e          , false },
    { "drop"         , abc__     , { 1          } , _bc__          , false },
    { "extend"       , abc__     , { ___de      } , abcde          , true  },
    { "extract"      , abc__     , { not_c      } , ab___          , false },
    { "filter"       , _bcd_     , { not_c      } , _b_d_          , false },
    { "first"        , abc__     , {            } , "a"            ,       },
    { "flatten"      , L({ac,e}) , {            } , a_c_e          , false },
    { "group_by"     , mixed     , { type       } , by_type        , false },
    { "group_by"     , words     , { len        } , by_len         , false },
    { "index_if"     , abcde     , { is_c       } , 3              ,       },
    { "index"        , abcde     , {            } , nil            ,       },
    { "index"        , abcde     , { "c"        } , 3              ,       },
    { "insert"       , a_c__     , { 2, "b"     } , abc__          , true  },
    { "insert"       , abc__     , { "d"        } , abcd_          , true  },
    { "intersection" , a_c_e     , { _bcd_      } , __c__          , false },
    { "invert"       , a___e     , {            } , a1_e2          , false },
    { "mirror"       , a___e     , {            } , { a="a",e="e" }, false },
    { "isempty"      , _____     , {            } , true           ,       },
    { "isempty"      , abc__     , {            } , false          ,       },
    { "join"         , abc__     , { ","        } , "a,b,c"        ,       },
    { "join"         , abcde     , {            } , "abcde"        ,       },
    { "keypath"      , abc__     , {            } , "a.b.c"        ,       },
    { "last"         , abc__     , {            } , "c"            ,       },
    { "le"           , _1_3_     , { _12__      } , false          ,       },
    { "le"           , _12__     , { _1_3_      } , true           ,       },
    { "le"           , _12__     , { _12__      } , true           ,       },
    { "len"          , _____     , {            } , 0              ,       },
    { "len"          , a_c__     , {            } , 2              ,       },
    { "lt"           , _1_3_     , { _12__      } , false          ,       },
    { "lt"           , _12__     , { __2__      } , true           ,       },
    { "lt"           , _12__     , { _1_3_      } , true           ,       },
    { "lt"           , _12__     , { _12__      } , false          ,       },
    { "lt"           , _12__     , { _12_4      } , true           ,       },
    { "map"          , abc__     , { upper      } , ABC__          , false },
    { "mul"          , abc__     , { 0          } , _____          , false },
    { "mul"          , abc__     , { 2          } , abcabc         , false },
    { "pop"          , abc__     , {            } , "c"            ,       },
    { "pop"          , abcde     , { 1          } , "a"            ,       },
    { "pop"          , abcde     , { 5          } , "e"            ,       },
    { "prepend"      , _bc__     , { "a"        } , abc__          , true  },
    { "reduce"       , _____     , { add, 5     } , 5              ,       },
    { "reduce"       , _123_     , { add        } , 6              ,       },
    { "reduce"       , _123_     , { add, 0     } , 6              ,       },
    { "reduce"       , _123_     , { add, 4     } , 10             ,       },
    { "remove"       , abc__     , {            } , abc__          , true  },
    { "remove"       , AZAZA     , { "A"        } , _ZAZA          , true  },
    { "reverse"      , abcde     , {            } , edcba          , true  },
    { "slice"        , abcde     , {            } , abcde          , false },
    { "slice"        , abcde     , { 2, 4       } , _bcd_          , false },
    { "sort"         , edcba     , {            } , abcde          , true  },
    { "take"         , abcde     , { 3          } , abc__          , false },
    { "toset"        , AZAZA     , {            } , Set(AZAZA)     , false },
    { "tostring"     , a___e     , {            } , '{ "a", "e" }' ,       },
    { "uniq"         , AZAZA     , {            } , AZ___          , false },
    { "zip"          , abc__     , { _12__      } , { a1, b2 }     , false },

    -- Cases where the second argument is provided as a Set.
    { "difference"   , a_c_e     , { Set(_bcd_) } , a___e          , false },
    { "extend"       , a_c__     , { Set(____e) } , a_c_e          , true  },
    { "intersection" , a_c_e     , { Set(_bcd_) } , __c__          , false },
    { "zip"          , abc__     , { Set(_12__) } , { a1, b2 }     , false },
  }
  -- stylua: ignore end

  for i = 1, #tests do
    local fname, ls, params, expected, same_ref =
      unpack(tests[i] --[[@as {[1]:string,[2]:mods.List,[3]:{},[4]:any,[5]:boolean?}]], 1, 5)

    -- First argument is a List.
    it(fmt("List(%s):%s(%s)", stringify(ls, { newline = "" }), fname, args_repr(params)), function()
      local l = ls:copy()
      local res = List[fname](l, unpack(params))
      assert.are_same(expected, res)

      if same_ref then
        assert.are_equal(true, rawequal(l, res), "Expected same list reference")
      elseif same_ref == false then
        assert.are_equal(false, rawequal(l, res), "Expected different list reference")
      end
    end)

    -- First argument is a plain table.
    it(fmt("List.%s({...}, ...)", fname), function()
      local l = shallow_copy(ls)
      local res = List[fname](l, unpack(params))
      assert.are_same(expected, res)
    end)
  end

  it("foreach() applies a function to each element and returns nil", function()
    local ls = List({ "a", "b", "c" })
    local joined = ""
    local res = ls:foreach(function(v)
      joined = joined .. v
    end)
    assert.are_equal("abc", joined)
    assert.is_nil(res)
  end)

  describe("join()", function()
    it("stringifies non-string values", function()
      local ls = List({ "a", 1, true })
      assert.are_equal("a,1,true", ls:join(","))
    end)

    it("quotes strings when quoted is enabled", function()
      local ls = List({ "a", "b", 1 })
      assert.are_equal('"a", "b", 1', ls:join(", ", true))
    end)

    it("handles self-reference", function()
      local ls = List({ "a" })
      ls:append(ls)
      assert.are_equal("a,<self>", ls:join(","))
    end)
  end)

  describe("sort()", function()
    it("sorts in place with a custom comparison function", function()
      local ls = List({ "ccc", "a", "bb" })
      local res = ls:sort(function(a, b)
        return #a < #b
      end)

      assert.are_same({ "a", "bb", "ccc" }, res)
      assert.are_equal(true, rawequal(ls, res), "Expected same list reference")
    end)
  end)

  describe("shuffle()", function()
    it("shuffles in place using math.random by default", function()
      local ls = List({ "a", "b" })
      local res = ls:shuffle()
      assert.is_true(res:equals(List({ "a", "b" })) or res:equals(List({ "b", "a" })))
      assert.are_equal(true, rawequal(ls, res), "Expected same list reference")
    end)

    it("shuffles in place using the provided rng", function()
      local calls = {}
      local function rng(lo, hi)
        calls[#calls + 1] = { lo, hi }
        return lo
      end

      local ls = List({ "a", "b", "c", "d", "e" })
      local res = ls:shuffle(rng)

      assert.are_same({ "b", "c", "d", "e", "a" }, res)
      assert.are_equal(true, rawequal(ls, res), "Expected same list reference")
      assert.are_same({ { 1, 5 }, { 1, 4 }, { 1, 3 }, { 1, 2 } }, calls)
    end)
  end)

  describe("metamethods", function()
    it("__add (+) extends and returns the left list", function()
      local a = List({ "a", "b" })
      local b = { "c", "d" }
      local c = { "e", "f" }
      local d = a + b + c
      assert.are_same(d, { "a", "b", "c", "d", "e", "f" })
      assert.are_equal(true, rawequal(a, d), "__add returns same lhs ref")
    end)

    it("__sub (-) returns list difference", function()
      local a = List({ "a", "b", "c", "a" })
      local b = { "b", "x" }
      assert.are_same({ "a", "c", "a" }, a - b)
      assert.are_same({ "a", "b", "c", "a" }, a)
    end)

    it("__tostring renders list output", function()
      assert.are_equal('{ "a", "b", 1 }', tostring(List({ "a", "b", 1 })))
    end)

    it("__eq (==) compares lists with shallow equality", function()
      assert.is_true(List({ "a", "b" }) == List({ "a", "b" }))
      assert.is_false(List({ "a", "b" }) == List({ "a", "c" }))
      assert.is_false(List({ "a", "b" }) == List({ "a", "b", "c" }))
    end)

    it("__lt (<) compares lists lexicographically", function()
      assert.is_true(List({ 1, 2 }) < List({ 1, 3 }))
      assert.is_true(List({ 1, 2 }) < List({ 1, 2, 0 }))
      assert.is_false(List({ 1, 3 }) < List({ 1, 2 }))
      assert.is_false(List({ 1, 2 }) < List({ 1, 2 }))
    end)

    it("__le (<=) compares lists lexicographically", function()
      assert.is_true(List({ 1, 2 }) <= List({ 1, 2 }))
      assert.is_true(List({ 1, 2 }) <= List({ 1, 3 }))
      assert.is_false(List({ 1, 3 }) <= List({ 1, 2 }))
    end)

    it("__mul (*) repeats lists", function()
      local a = List({ "a", "b" })
      assert.are_same({ "a", "b", "a", "b", "a", "b" }, a * 3)
      assert.are_same({ "a", "b", "a", "b", "a", "b" }, 3 * a)
      assert.are_same({ "a", "b" }, a)
    end)

    it("> compares lists via __lt", function()
      assert.is_true(List({ 1, 3 }) > List({ 1, 2 }))
      assert.is_false(List({ 1, 2 }) > List({ 1, 3 }))
    end)

    it(">= compares lists via __le", function()
      assert.is_true(List({ 1, 2 }) >= List({ 1, 2 }))
      assert.is_true(List({ 1, 3 }) >= List({ 1, 2 }))
      assert.is_false(List({ 1, 2 }) >= List({ 1, 3 }))
    end)
  end)
end)
