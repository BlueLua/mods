local stringcase = require "mods.stringcase"

local fmt = string.format

describe("mods.stringcase", function()
  -- stylua: ignore
  local tests = {
    -----fname----|-------------expected--------------
    { "capital"  , { "Foo_bar-baz" , "Foobar baz"  } },
    { "sentence" , { "Foo_bar-baz" , "FooBar baz"  } },
    { "swap"     , { "FOO_BAR-BAZ" , "fOObAR BAZ"  } },
    { "lower"    , { "foo_bar-baz" , "foobar baz"  } },
    { "upper"    , { "FOO_BAR-BAZ" , "FOOBAR BAZ"  } },
    { "acronym"  , {             "FBB"             } },
    { "camel"    , {          "fooBarBaz"          } },
    { "pascal"   , {          "FooBarBaz"          } },
    { "snake"    , {         "foo_bar_baz"         } },
    { "kebab"    , {         "foo-bar-baz"         } },
    { "title"    , {         "Foo Bar Baz"         } },
    { "dot"      , {         "foo.bar.baz"         } },
    { "path"     , {         "foo/bar/baz"         } },
    { "space"    , {         "foo bar baz"         } },
    { "constant" , {         "FOO_BAR_BAZ"         } },
  }

  for i = 1, #tests do
    local fname, expected = unpack(tests[i] --[[@as {[1]:string, [2]:string[]}]], 1, 2)
    for j, s in ipairs({ "foo_bar-baz", "FooBar baz" }) do
      it(fmt("%s(%q) returns correct result", fname, s), function()
        -- Wrap in a table to make sure the function returns only one value.
        assert.are_same({ expected[j] or expected[1] }, { stringcase[fname](s) })
      end)
    end
  end
end)
