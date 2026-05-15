local mods = require "mods"

local kw = mods.keyword
local ver = mods.runtime.version
local List = mods.list

-- stylua: ignore
local keywords =  List({
  "and"   , "break" , "do"  , "else"    , "elseif",
  "end"   , "false" , "for" , "function", "if"    ,
  "in"    , "local" , "nil" , "not"     , "or"    ,
  "repeat", "return", "then", "true"    , "until" , "while"
})

keywords[#keywords + 1] = ver > 501 and "goto" or nil
keywords[#keywords + 1] = ver > 504 and "global" or nil
keywords:sort()

-- stylua: ignore
each("mods.keyword", kw, {
  kwlist = {
    {
      assert = function()
        assert.Same(keywords, kw.kwlist())
        assert.List(kw.kwlist())
        assert.False(rawequal(kw.kwlist(), kw.kwlist()))
      end,
    },
  },
  kwset = {
    {
      assert = function()
        assert.Same(keywords:toset(), kw.kwset())
        assert.Set(kw.kwset())
        assert.False(rawequal(kw.kwset(), kw.kwset()))
      end,
    },
  },
  iskeyword= {
    {
      function()
        for _, input in ipairs(keywords) do
          assert.True(kw.iskeyword(input))
        end
      end,
      { args = { "_"         }, expected = false },
      { args = { ""          }, expected = false },
      { args = { "Function"  }, expected = false },
      { args = { "global1"   }, expected = false },
      { args = { "goto1"     }, expected = false },
      { args = { "hello"     }, expected = false },
      { args = { "local_var" }, expected = false },
      { args = { "nil?"      }, expected = false },
      { args = { "while_"    }, expected = false },
      { args = { {}          }, expected = false },
      { args = { 123         }, expected = false },
      { args = { false       }, expected = false },
    },
  },
  isidentifier = {
    { args = { "hello"       }, expected =  true      },
    { args = { "hello_world" }, expected =  true      },
    { args = { "_name2"      }, expected =  true      },
    { args = { "global"      }, expected =  ver < 505 },
    { args = { "goto"        }, expected =  ver < 502 },
    { args = { "(var"        }, expected =  false     },
    { args = { "[var"        }, expected =  false     },
    { args = { "local"       }, expected =  false     },
    { args = { "function"    }, expected =  false     },
    { args = { "2bad"        }, expected =  false     },
    { args = { "bad-name"    }, expected =  false     },
    { args = { false         }, expected =  false     },
    { args = { nil           }, expected =  false     },
  },
  normalize_identifier = {
    { args = { " 2 bad-name " }, expected = "_2_bad_name"                        },
    { args = { "global"       }, expected = ver >= 505 and "global_" or "global" },
    { args = { "local"        }, expected = "local_"                             },
    { args = { ""             }, expected = "_"                                  },
    { args = { "   "          }, expected = "_"                                  },
  },
})
