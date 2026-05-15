local mods = require "mods"

local List = mods.list
local tbl = mods.tbl

local args_repr = mods.utils.args_repr
local deepcopy = tbl.deepcopy
local fmt = string.format

describe("mods.tbl", function()
  local loc = { a = { b = { c = { d = {} } } } }
  local n123 = { 1, 2, 3 }
  local abc = { "a", "b", "c" }

  -- stylua: ignore start
  local a1_b2_c3    = { a = 1    ,  b = 2    , c = 3    }
  local a2_b4_c6    = { a = 2    ,  b = 4    , c = 6    }
  local aA_bB_cC    = { a = "A"  ,  b = "B"  , c = "C"  }
  local Aa_Bb_Cc    = { A = "a"  ,  B = "b"  , C = "c"  }
  local Aa_Cc       = { A = "a"  ,  C = "c"  ,          }
  local a1_b2_cc    = { a = 1    ,  b = 2    , c = "c"  }
  local aa1_bb2_cc3 = { a = "a1" ,  b = "b2" , c = "c3" }
  local x1_y2       = { x = 1    ,  y = 2    ,          }
  local x1_y2_z4    = { x = 1    ,  y = 2    , z = 4    }
  local x1_y3_z4    = { x = 1    ,  y = 3    , z = 4    }
  local y3_z4       = { y = 3    ,  z = 4    ,          }

  local multi    = function(v) return v * 2 end
  local not_b    = function(v) return v ~= "b" end
  local gt_2     = function(v) return v > 2 end
  local gt_5     = function(v) return v > 5 end
  local concat   = function(a, b) return a .. b end
  local is_equal = function(a, b) return a == b end

  local tests = {
    -----fname---|----------params--------|--expected---|-same_ref?
    { "count"    , { {}                 } , 0           ,       },
    { "count"    , { a1_b2_c3           } , 3           ,       },
    { "filter"   , { a1_b2_c3, gt_2     } , { c = 3 }   , false },
    { "filter"   , { a1_b2_c3, gt_5     } , {}          , false },
    { "filter"   , { Aa_Bb_Cc, not_b    } , Aa_Cc       , false },
    { "find"     , { a1_b2_c3, "2"      } , nil         ,       },
    { "find"     , { a1_b2_c3, 2        } , "b"         ,       },
    { "find"     , { abc, "b"           } , 2           ,       },
    { "is_same"  , { a1_b2_c3, a1_b2_c3 } , true        , false },
    { "is_same"  , { a1_b2_c3, a2_b4_c6 } , false       , false },
    { "is_same"  , { x1_y2, x1_y2_z4    } , false       , false },
    { "get"      , { loc                } , loc         , true  },
    { "get"      , { loc, "a", "b", "c" } , loc.a.b.c   , false },
    { "get"      , { loc, "a", "d", "d" } , nil         ,       },
    { "invert"   , { aA_bB_cC           } , Aa_Bb_Cc    , false },
    { "invert"   , { Aa_Bb_Cc           } , aA_bB_cC    , false },
    { "isempty"  , { {}                 } , true        ,       },
    { "isempty"  , { abc                } , false       ,       },
    { "update"   , { x1_y2, y3_z4       } , x1_y3_z4    , true  },
    { "update"   , { y3_z4, x1_y2       } , x1_y2_z4    , true  },
    { "copy"     , { a1_b2_c3           } , a1_b2_c3    , false },
    { "deepcopy" , { a1_b2_c3           } , a1_b2_c3    , false },
    { "find_if"  , { a1_b2_cc, is_equal } , "c"         , false },
    { "keys"     , { a1_b2_c3,          } , abc         , false },
    { "map"      , { a1_b2_c3, multi    } , a2_b4_c6    , false },
    { "pairmap"  , { a1_b2_c3, concat   } , aa1_bb2_cc3 , false },
    { "values"   , { a1_b2_c3           } , n123        , false },
  }
  -- stylua: ignore end

  for i = 1, #tests do
    local fname, params, expected, same_ref =
      unpack(tests[i] --[[@as {[1]:string, [2]:any[], [3]:any, [4]:boolean?}]], 1, 4)

    it(fmt("%s(%s) returns correct result", fname, args_repr(params)), function()
      params = deepcopy(params)
      local res = tbl[fname](unpack(params))
      local actual = res

      actual = (fname == "keys" or fname == "values") and actual:sort() or actual
      assert.are_same(expected, actual)

      if same_ref then
        assert.are_equal(params[1], actual, "Expected same table reference")
      elseif same_ref == false then
        assert.not_equal(params[1], actual, "Expected different table reference")
      end
    end)
  end

  it("clear() empties table in-place and returns nil", function()
    local t = { a = 1, b = 2, c = 3 }
    local res = tbl.clear(t)
    assert.is_nil(res)
    assert.are_same({}, t)
  end)

  it("keys() returns a mods.List", function()
    local res = tbl.keys({ a = 1, b = 2 })
    assert.is_list(res)
  end)

  it("values() returns a mods.List", function()
    local res = tbl.values({ a = 1, b = 2 })
    assert.is_list(res)
  end)

  it("foreach() calls function for each entry", function()
    local t = { a = 1, b = 2, c = 3 }
    local keys, values = List(), List()
    tbl.foreach(t, function(v, k)
      keys:append(k)
      values:append(v)
    end)
    assert.are_same(keys:sort(), keys:sort())
    assert.are_same({ 1, 2, 3 }, values:sort())
  end)

  it("spairs() iterates in sorted key order", function()
    local t = { b = 2, a = 1, c = 3 }
    local out = {}
    for k, v in tbl.spairs(t) do
      out[#out + 1] = k .. v
    end
    assert.are_same({ "a1", "b2", "c3" }, out)
  end)

  describe("deep_equal()", function()
    it("compares nested tables structurally", function()
      local left = { a = { b = { c = 1 } } }
      local right = { a = { b = { c = 1 } } }
      local mismatch = { a = { b = { c = 2 } } }

      assert.is_true(tbl.deep_equal(left, right))
      assert.is_false(tbl.deep_equal(left, mismatch))
    end)

    it("handles cycles and repeated references", function()
      local cycle1 = {}
      local cycle2 = {}
      cycle1.self = cycle1
      cycle2.self = cycle2

      local shared1 = { x = { y = 1 } }
      shared1.a = shared1.x
      shared1.b = shared1.x

      local shared2 = { x = { y = 1 } }
      shared2.a = { y = 1 }
      shared2.b = { y = 1 }

      assert.is_true(tbl.deep_equal(cycle1, cycle2))
      assert.is_true(tbl.deep_equal(shared1, shared2))
    end)
  end)

  describe("deepcopy()", function()
    it("should copy nested tables", function()
      local t = { a = { b = { c = 5 } } }
      local c = tbl.deepcopy(t)
      assert.not_equal(t.a, c.a)
      assert.not_equal(t.a.b, c.a.b)
      assert.are_same(t, c)
    end)

    it("handles self-references without looping", function()
      local t = {}
      t.self = t
      local c = tbl.deepcopy(t)
      assert.not_equal(t, c)
      assert.are_equal(c.self, c)
    end)

    it("preserves shared references within loops", function()
      local shared = { value = 1 }
      local t = { first = shared, second = shared, loop = { ref = shared } }
      shared.owner = t

      local c = tbl.deepcopy(t)
      assert.not_equal(t, c)
      assert.not_equal(shared, c.first)
      assert.are_equal(c.first, c.second)
      assert.are_equal(c.first, c.loop.ref)
      assert.are_equal(c.first.owner, c)
    end)

    it("should copy metatables correctly", function()
      local mt = { __index = { fallback = { value = "meta" } } }
      local shared = { z = 3 }
      local t = setmetatable({
        x = 1,
        nested = { y = 2, shared = shared },
        arr = { 1, 2, 3 },
        shared = shared,
      }, mt)
      local c = tbl.deepcopy(t)
      assert.not_equal(t, c)
      assert.not_equal(t.nested, c.nested)
      assert.not_equal(t.arr, c.arr)
      assert.not_equal(shared, c.shared)
      assert.are_equal(c.shared, c.nested.shared)
      assert.are_same(t, c)
      assert.are_equal(getmetatable(t), getmetatable(c))
      assert.are_same(mt, getmetatable(c))
      assert.are_equal("meta", c.fallback.value)
    end)
  end)
end)
