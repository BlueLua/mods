local mods = require "mods"
local operator = mods.operator

local args_repr = mods.utils.args_repr
local fmt = string.format

describe("mods.operator", function()
  local t = { a = 1 }
  local function sum(a, b)
    return a + b
  end
  -- stylua: ignore 
  local tests = {
    ---operator--|--------params--------|-expected---
    { "add"      , { 3, 4             } , 7       },
    { "sub"      , { 3, 4             } , -1      },
    { "mul"      , { 3, 4             } , 12      },
    { "div"      , { 10, 4            } , 2.5     },
    { "idiv"     , { 5, 2             } , 2       },
    { "mod"      , { 5, 2             } , 1       },
    { "pow"      , { 2, 4             } , 16      },
    { "unm"      , { -3               } , 3       },

    { "eq"       , { 1, 1             } , true    },
    { "neq"      , { 1, 2             } , true    },
    { "lt"       , { 1, 2             } , true    },
    { "le"       , { 2, 2             } , true    },
    { "gt"       , { 3, 2             } , true    },
    { "ge"       , { 2, 2             } , true    },

    { "land"     , { "hello", "world" } , "world" },
    { "land"     , { false, true      } , false   },
    { "land"     , { true,  true      } , true    },
    { "lnot"     , { true             } , false   },
    { "lor"      , { "hello", "world" } , "hello" },
    { "lor"      , { false, false     } , false   },
    { "lor"      , { false, true      } , true    },

    { "concat"   , { "a", "b"         } , "ab"    },
    { "len"      , { "abc"            } , 3       },

    { "index"    , { t, "a"           } , 1       },
    { "index"    , { t, "b"           } , nil     },
    { "call"     , { sum, 1, 2        } , 3       },
    { "setindex" , { t, "a", 2        } , 2       },
  }

  for i = 1, #tests do
    local fname, params, expected = unpack(tests[i] --[[@as {[1]:string, [2]:any[], [3]:any}]], 1, 3)
    it(fmt("%s(%s) returns correct result", fname, args_repr(params)), function()
      assert.are_equal(expected, operator[fname](unpack(params)))
    end)
  end
end)
