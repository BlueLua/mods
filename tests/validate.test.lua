local mods = require "mods"

local capitalize = mods.stringcase.capital
local quote = mods.utils.quote
local validate = mods.validate

local fmt = string.format

local function render_value(v)
  return type(v) == "string" and quote(v) or tostring(v)
end

describe("mods.validate", function()
  local fn = function() end
  local co = coroutine.create(fn)
  local ct = setmetatable({}, { __call = fn })
  local nct = setmetatable({}, { __call = true })
  local empty = {}

  it("exposes messages table", function()
    assert.are_equal("table", type(validate.messages))
  end)

  it("is callable", function()
    assert.is_callable(validate)
  end)

  it("defaults to truthy check when type is omitted", function()
    assert.are_same({ true }, { validate(true) })
    assert.are_same({ true }, { validate(1) })
    assert.are_same({ false, "truthy value expected, got no value" }, { validate() })
  end)

  it("supports case-insensitive key lookup", function()
    assert.are_equal(validate.number, validate.NumBer)
    assert.are_same({ true }, { validate.NumBer(1) })
  end)

  -- stylua: ignore
  local tests = {
    -----type----|----valid----|----invalid---|--------------------------errmsg--------------------------
    { "boolean"  , false       , 123          , "boolean expected, got number"                          },
    { "boolean"  , true        , nil          , "boolean expected, got no value"                        },
    { "function" , fn          , "abc"        , "function expected, got string"                         },
    { "nil"      , nil         , 123          , "nil expected, got number"                              },
    { "number"   , 123         , "123"        , "number expected, got string"                           },
    { "string"   , "abc"       , true         , "string expected, got boolean"                          },
    { "table"    , {}          , false        , "table expected, got boolean"                           },
    { "thread"   , co          , fn           , "thread expected, got function"                         },
    { "userdata" , io.stdout   , {}           , "userdata expected, got table"                          },

    { "callable" , ct          , nct          , fmt("callable value expected, got %s", tostring(nct))   },
    { "callable" , fn          , empty        , fmt("callable value expected, got %s", tostring(empty)) },
    { "false"    , false       , true         , "false value expected, got true"                        },
    { "falsy"    , false       , true         , "falsy value expected, got true"                        },
    { "falsy"    , nil         , 123          , "falsy value expected, got 123"                         },
    { "integer"  , 123         , 13.4         , "integer value expected, got 13.4"                      },
    { "integer"  , 123         , nil          , "integer value expected, got no value"                  },
    { "integer"  , 123         , "abc"        , 'integer value expected, got "abc"'                     },
    { "true"     , true        , false        , "true value expected, got false"                        },
    { "truthy"   , 123         , nil          , "truthy value expected, got no value"                   },
    { "truthy"   , true        , false        , "truthy value expected, got false"                      },

    { "file"     , "README.md" , "src"        , '"src" is not a valid file path'                        },
    { "file"     , "README.md" , false        , "string expected, got boolean"                          },
    { "file"     , "README.md" , "MISSING.md" , '"MISSING.md" is not a valid file path'                 },
    { "file"     , "README.md" , nil          , "string expected, got no value"                         },
    { "path"     , "README.md" , "MISSING.md" , '"MISSING.md" is not a valid path'                      },
    { "path"     , "README.md" , false        , "string expected, got boolean"                          },
    { "path"     , "src"       , nil          , "string expected, got no value"                         },
    { "dir"      , "src"       , "README.md"  , '"README.md" is not a valid directory path'             },
    { "dir"      , "src"       , 123          , "string expected, got number"                           },
    { "dir"      , "src"       , nil          , "string expected, got no value"                         },
  }

  for i = 1, #tests do
    local tp, valid, invalid, msg = unpack(tests[i] --[[@as {[1]:string, [2]:any, [3]:any, [4]:string}]], 1, 4)
    local fname = capitalize(tp)

    it(fmt("validate.%s is function", fname), function()
      assert.Function(validate[fname])
    end)

    it(fmt("validate.%s(%s) returns true", fname, inspect(valid)), function()
      assert.are_same({ true }, { validate[fname](valid) })
      assert.are_same({ true }, { validate(valid, tp) })
    end)

    it(fmt("validate.%s(%s) returns false", fname, inspect(invalid)), function()
      assert.are_same({ false, msg }, { validate[fname](invalid) })
      assert.are_same({ false, msg }, { validate(invalid, tp) })
    end)
  end

  it("uses default validator message template", function()
    assert.are_same({ false, "number expected, got string" }, { validate.number("x") })
    assert.are_same({ false, '"README.md" is not a valid directory path' }, { validate.dir("README.md") })
    assert.are_same(
      { false, fmt("callable value expected, got %s", render_value(empty)) },
      { validate.callable(empty) }
    )
  end)

  -------------------------
  --- Template Messages ---
  -------------------------

  describe("validate.messages", function()
    it("errors on non-string keys", function()
      assert.has_error(function()
        validate.messages[1] = "nope"
      end, "validate.messages[1]: string expected, got number")
    end)

    it("errors on non-string template", function()
      assert.has_error(function()
        validate.messages.number = 123 ---@diagnostic disable-line: assign-type-mismatch
      end, "validate.messages.number: string expected, got number")

      assert.has_error(function()
        validate.messages.number = nil
      end, "validate.messages.number: string expected, got no value")
    end)
  end)

  it("errors when passing non-string template argument", function()
    assert.has_error(function()
      ---@diagnostic disable-next-line: param-type-mismatch, missing-return
      validate.register("bad", function() end, 123)
    end, "bad argument #3 to 'register' (string expected, got number)")

    assert.has_error(function()
      validate(13.4, "integer", function() end)
    end, "bad argument #3 to 'integer' (string expected, got function)")

    assert.has_error(function()
      ---@diagnostic disable-next-line: param-type-mismatch
      validate.callable("not a callable", 123)
    end, "bad argument #2 to 'callable' (string expected, got number)")
  end)

  it("supports custom messages", function()
    local prev = validate.messages.number
    validate.messages.number = "need {{expected}}, got {{got}}"

    assert.are_same({ false, "need number, got string" }, { validate.number("x") })
    assert.are_same({ false, "need number, got string" }, { validate("x", "number") })

    validate.messages.number = prev
  end)

  it("accepts template overrides on validator functions", function()
    assert.are_same({ false, "need string, got number" }, {
      validate.string(123, "need {{expected}}, got {{got}}"),
    })
  end)

  ------------------
  --- Register() ---
  ------------------

  describe("register", function()
    it("registers custom validator and supports callable dispatch", function()
      validate.register("odd", function(v)
        return type(v) == "number" and v % 2 == 1
      end)

      assert.are_same({ true }, { validate.odd(3) })
      assert.are_same({ true }, { validate(3, "odd") })
      assert.are_same({ false, "odd expected, got number" }, { validate.odd(2) })
      assert.are_same({ false, "odd expected, got string" }, { validate("x", "odd") })
    end)

    it("supports custom default message template", function()
      validate.register("even", function(v)
        return type(v) == "number" and v % 2 == 0
      end, "{{expected}} check expected, got {{value}}")
      assert.are_same({ false, "even check expected, got 3" }, { validate.even(3) })
    end)

    it("allows overriding existing validators", function()
      validate.register("number", function(v)
        return v == 42
      end, "{{expected}} expected, got {{value}}")

      assert.are_same({ true }, { validate.number(42) })
      assert.are_same({ false, "number expected, got 1" }, { validate.number(1) })

      validate.register("number", function(v)
        return type(v) == "number"
      end)
    end)
  end)
end)
