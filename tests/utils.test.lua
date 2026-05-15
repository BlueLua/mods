local utils = require("mods").utils

local args_repr = utils.args_repr
local fmt = string.format

describe("mods.utils", function()
  local tests
  local fn = function() end

  ---------------
  --- quote() ---
  ---------------

  -- stylua: ignore
  tests = {
    --------------input--------------|--------------expected---------------
    { "foo"                          , '"foo"'                            },
    { ""                             , '""'                               },
    { ""                             , '""'                               },
    { '"'                            , [['"']]                            },
    { "'"                            , [["'"]]                            },
    { "it's ok"                      , [["it's ok"]]                      },
    { [[a "b" c]]                    , [['a "b" c']]                      },
    { "a 'b' c"                      , [["a 'b' c"]]                      },
    { "bar_baz"                      , '"bar_baz"'                        },
    { [[he said "hi"]]               , [['he said "hi"']]                 },
    { "hello world"                  , '"hello world"'                    },
    { [[back\slash]]                 , [["back\slash"]]                   },
    { [['mix "quotes" and 'single']] , [["'mix \"quotes\" and 'single'"]] },
  }

  for i = 1, #tests do
    local input, expected = unpack(tests[i] --[[@as {[1]:string, [2]:string}]], 1, 2)
    it(fmt("quote(%q) returns correct result", input), function()
      assert.are_equal(expected, utils.quote(input))
    end)
  end

  -----------------
  --- keypath() ---
  -----------------

  -- stylua: ignore
  tests = {
    -------------params-------------|-------------expected--------------
    { {                           } , ""                               },
    { { "ctx", "end"              } , 'ctx["end"]'                     },
    { { "ctx", "invalid-key"      } , 'ctx["invalid-key"]'             },
    { { "ctx", "users", 1, "name" } , "ctx.users[1].name"              },
    { { "t"                       } , "t"                              },
    { { "t", "a", "b", "c"        } , "t.a.b.c"                        },
    { { fn, "end"                 } , fmt('[%s]["end"]', tostring(fn)) },
  }

  for i = 1, #tests do
    local params, expected = unpack(tests[i] --[[@as {[1]:any[], [2]:string}]], 1, 2)
    it(fmt("keypath(%s) returns correct result", args_repr(params)), function()
      assert.are_equal(expected, utils.keypath(unpack(params)))
    end)
  end

  -------------------
  --- args_repr() ---
  -------------------

  -- stylua: ignore
  tests = {
    ---------input----------|------expected--------
    { nil                   , ""                  },
    { {                   } , ""                  },
    { { "a", 1, true      } , '"a", 1, true'      },
    { { "x", "y", "z", {} } , '"x", "y", "z", {}' },
  }

  for i = 1, #tests do
    local input, expected = unpack(tests[i] --[[@as {[1]:any[], [2]:string}]], 1, 2)
    it(fmt("args_repr(%s) returns correct result", args_repr(input)), function()
      assert.are_equal(expected, utils.args_repr(input))
    end)
  end

  it("args_repr() omits metatables from inspected tables", function()
    local input = { setmetatable({ "a" }, { __index = { "b" } }) }
    assert.are_equal('{ "a" }', utils.args_repr(input))
  end)

  describe("assert_arg()", function()
    it("returns same value when validation passes", function()
      assert.are_equal("abc", utils.assert_arg(1, "abc", "string"))
      assert.are_equal(123, utils.assert_arg(2, 123, "number"))
    end)

    it("returns nil when optional and value is nil", function()
      assert.is_nil(utils.assert_arg(1, nil, "string", true))
    end)

    it("defaults to truthy check when type is omitted", function()
      assert.are_equal("ok", utils.assert_arg(1, "ok"))
      assert.has_error(function()
        utils.assert_arg(2, false)
      end, "bad argument #2 (truthy value expected, got false)")
    end)

    it("throws with bad argument prefix on validation failure", function()
      assert.has_error(function()
        utils.assert_arg(3, 123, "string")
      end, "bad argument #3 (string expected, got number)")
    end)
  end)

  describe("validate()", function()
    it("errors with label prefix on validation failure", function()
      assert.has_error(function()
        utils.validate("count", "x", "number")
      end, "count: number expected, got string")
    end)

    it("uses keypath when label is a table", function()
      assert.has_error(function()
        utils.validate({ "ctx", "users", 1, "name" }, 123, "string")
      end, "ctx.users[1].name: string expected, got number")
    end)

    it("does not error when optional and value is nil", function()
      assert.no_error(function()
        utils.validate("name", nil, "string", true)
      end)
    end)

    it("passes custom message template to validate when provided", function()
      assert.has_error(function()
        utils.validate("count", "x", "number", false, "need {{expected}}, got {{got}}")
      end, "count: need number, got string")
    end)
  end)

  describe("lazy_module()", function()
    local function is_module_loaded(name)
      return package.loaded[name] ~= nil
    end

    it("does not load the module until a field is accessed", function()
      local modname = "mods.stringcase"
      package.loaded[modname] = nil

      local proxy = utils.lazy_module(modname)

      assert.is_false(is_module_loaded(modname))
      _ = proxy.missing
      assert.is_true(is_module_loaded(modname))
    end)

    it("proxies reads and writes to the loaded module", function()
      local modname = "mods.is"
      local proxy = utils.lazy_module(modname)
      local loaded = require(modname) --[[@as mods.is]]
      local k, v = "_lazy_module_proxy_value", 3

      assert.is_nil(proxy[k])
      assert.same(loaded.boolean, proxy.boolean)
      assert.is_nil(rawget(proxy, "boolean"))

      proxy[k] = v
      assert.are_equal(v, proxy[k])
      assert.are_equal(v, loaded[k])
      assert.is_nil(rawget(proxy, k))

      proxy[k] = nil
      assert.is_nil(proxy[k])
      assert.is_nil(loaded[k])

      loaded[k] = v
      assert.are_equal(v, loaded[k])
      assert.are_equal(v, proxy[k])
      assert.is_nil(rawget(proxy, k))

      loaded[k] = nil
      assert.is_nil(loaded[k])
      assert.is_nil(proxy[k])
    end)

    it("supports writes before any read access", function()
      local proxy = utils.lazy_module "mods.is"
      local loaded = require "mods.is" --[[@as mods.is]]
      local k, v = "_lazy_module_first_write", 11

      proxy[k] = v
      assert.are_equal(v, loaded[k])
      assert.are_equal(v, proxy[k])
      assert.is_nil(rawget(proxy, k))
    end)

    it("rewrites its metamethods to the loaded module", function()
      local proxy = utils.lazy_module("mods.validate")
      _ = proxy.boolean

      assert.are_equal(require("mods.validate"), getmetatable(proxy).__index)
      assert.are_equal(require("mods.validate"), getmetatable(proxy).__newindex)
    end)

    it("supports __call when the loaded module is callable", function()
      local proxy = utils.lazy_module("mods.validate")
      local loaded = require("mods.validate")

      assert.is_true(proxy(true, "truthy"))
      assert.is_false(proxy(false, "truthy"))

      -- `__call` is cached after the first proxy call.
      assert.are_equal(getmetatable(loaded).__call, getmetatable(proxy).__call)
    end)

    it("supports __call when the loaded module is a function", function()
      local proxy = utils.lazy_module("mods.template")
      local loaded = require("mods.template")

      assert.are_equal(loaded("{{name}}", { name = "Ada" }), proxy("{{name}}", { name = "Ada" }))
      assert.are_equal(loaded("{{name}}", { name = "Grace" }), proxy("{{name}}", { name = "Grace" }))
      assert.is_nil(getmetatable(proxy).__index)
      assert.is_nil(getmetatable(proxy).__newindex)
    end)
  end)
end)
