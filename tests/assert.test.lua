local mods = require("mods")

local ensure = mods.assert
local validate = mods.validate

describe("mods.assert", function()
  it("is callable and runs successfully when validation passes", function()
    assert.no_error(function()
      ensure("hello", "string")
      ensure(123, "number")
    end)
  end)

  it("throws error on validation failure when called directly", function()
    assert.has_error(function()
      ensure("hello", "number")
    end, "number expected, got string")

    assert.has_error(function()
      ensure(nil, "defined")
    end, "defined value expected, got no value")
  end)

  it("defaults to truthy check when validator is omitted", function()
    assert.are_equal("yes", ensure("yes"))
    assert.are_equal(true, ensure(true))
    assert.has_error(function()
      ensure(false)
    end, "truthy value expected, got false")
  end)

  it("provides dynamic validator fields", function()
    assert.are_equal("hello", ensure.string("hello"))
    assert.are_equal(42, ensure.number(42))
    assert.has_error(function()
      ensure.string(42)
    end, "string expected, got number")
  end)

  it("supports optional parameter to skip nil values", function()
    assert.is_nil(ensure.string(nil, nil, true))
    assert.has_error(function()
      ensure.string(nil, nil, false)
    end, "string expected, got no value")
  end)

  it("supports case-insensitive lookup of validator fields", function()
    assert.are_equal(42, ensure.NumBer(42))
    assert.has_error(function()
      ensure.StRiNg(42)
    end, "string expected, got number")
  end)

  it("supports custom messages on validator fields", function()
    assert.has_error(function()
      ensure.string(42, "Expected {{expected}} but got {{got}}")
    end, "Expected string but got number")
  end)

  it("supports custom messages when called directly", function()
    assert.has_error(function()
      ensure(42, "string", "Expected {{expected}} but got {{got}}")
    end, "Expected string but got number")
  end)

  it("handles newly registered validators dynamically", function()
    validate.register("even", function(v)
      return type(v) == "number" and v % 2 == 0
    end, "even number expected, got {{value}}")

    assert.are_equal(4, ensure.even(4))
    assert.has_error(function()
      ensure.even(3)
    end, "even number expected, got 3")
  end)
end)
