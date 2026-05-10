local mods = require "mods"

local kw = mods.keyword
local is_luajit = mods.runtime.is_luajit

local repr = mods.repr
local fmt = string.format

describe("mods.repr", function()
  local nan = is_luajit and "nan" or "-nan"

  it("renders primitives", function()
    local fn = function() end
    local co = coroutine.create(fn)

    -- stylua: ignore
    local tests = {
      { nil            , "nil"              },
      { true           , "true"             },
      { false          , "false"            },
      { 42             , "42"               },
      { 0/0            , nan                },
      { 1/0            , "inf"              },
      { -1/0           , "-inf"             },
      { 'He said "hi"' , [['He said "hi"']] },
      { fn             , tostring(fn)       },
      { co             , tostring(co)       },
    }

    for i = 1, #tests do
      local input, expected = unpack(tests[i] --[[@as {[1]:any, [2]:string}]], 1, 2)
      assert.are_equal(expected, repr(input))
    end
  end)

  it("renders arrays as keyed tables", function()
    assert.are_equal('{\n  [1] = "a",\n  [2] = "b",\n  [3] = "c"\n}', repr({ "a", "b", "c" }))
    assert.are_equal('{[1]="a",[2]="b",[3]="c"}', repr({ "a", "b", "c" }, nil, ""))
  end)

  it("renders empty arrays as empty braces", function()
    assert.are_equal("{}", repr({}))
  end)

  it("renders dictionaries with indentation by default", function()
    local input = { hello = "world", answer = 42 }
    local expected = '{\n  answer = 42,\n  hello = "world"\n}'
    assert.are_equal(expected, repr(input))
  end)

  it("renders non-identifier keys with brackets", function()
    local input = {
      ["not-valid"] = true,
      ["with space"] = "x",
      [false] = "no",
    }
    local expected = [[
{
  ["not-valid"] = true,
  ["with space"] = "x",
  [false] = "no"
}]]
    assert.are_equal(expected, repr(input))
  end)

  it("renders mixed tables as keyed tables", function()
    local input = {
      "a",
      "b",
      name = "Ada",
      nested = {
        "x",
        role = "Scientist",
      },
    }
    local expected = [[
{
  [1] = "a",
  [2] = "b",
  name = "Ada",
  nested = {
    [1] = "x",
    role = "Scientist"
  }
}]]
    assert.are_equal(expected, repr(input))
  end)

  it("renders sparse numeric tables without nil placeholders", function()
    local input = {
      [1] = "a",
      [3] = "c",
      name = "Ada",
    }
    local expected = [[
{
  [1] = "a",
  [3] = "c",
  name = "Ada"
}]]
    assert.are_equal(expected, repr(input))
  end)

  it("renders arrays with gaps as keyed tables", function()
    local input = { "a", nil, "b" }
    local expected = '{\n  [1] = "a",\n  [3] = "b"\n}'
    assert.are_equal(expected, repr(input))
  end)

  it("renders sparse mixed tables as keyed tables", function()
    local input = {
      "a",
      nil,
      "b",
      role = "Scientist",
      nested = { "x", nil, "y" },
    }
    local expected = [[
{
  [1] = "a",
  [3] = "b",
  nested = {
    [1] = "x",
    [3] = "y"
  },
  role = "Scientist"
}]]
    assert.are_equal(expected, repr(input))
  end)

  it("renders empty tables and nested tables", function()
    local input = {
      empty = {},
      list = { "x", "y" },
      user = { name = "Ada" },
    }
    local expected = [[
{
  empty = {},
  list = {
    [1] = "x",
    [2] = "y"
  },
  user = {
    name = "Ada"
  }
}]]
    assert.are_equal(expected, repr(input))
  end)

  it("ignores metatables when rendering tables", function()
    local input = setmetatable({
      __tostring = "",
      name = "Ada",
      nested = setmetatable({
        __key = "nested",
        ok = true,
      }, { __index = { hidden = "no" } }),
    }, { __index = { ignored = true } })

    local expected = [[
{
  __tostring = "",
  name = "Ada",
  nested = {
    __key = "nested",
    ok = true
  }
}]]
    assert.are_equal(expected, repr(input))
  end)

  it("errors on non-function replacer", function()
    assert.has_error(function()
      repr({}, true)
    end, "bad argument #2 (function expected, got boolean)")
  end)

  it("supports replacer functions for filtering", function()
    local input = {
      [1] = "one",
      [2] = "two",
      [9] = "nine",
      [false] = "no",
      [true] = "yes",
      drop = "hidden",
      name = "Ada",
      role = "Engineer",
      nested = {
        name = "Grace",
        role = "Scientist",
        [2] = "two",
        team = "Compiler",
        drop = "hidden",
      },
    }

    local function replacer(k, v)
      if k == "name" then
        return v:upper()
      end
      if k ~= "drop" then
        return v
      end
    end

    local expected = [[
{
  [1] = "one",
  [2] = "two",
  [9] = "nine",
  name = "ADA",
  nested = {
    [2] = "two",
    name = "GRACE",
    role = "Scientist",
    team = "Compiler"
  },
  role = "Engineer",
  [false] = "no",
  [true] = "yes"
}]]
    assert.are_equal(expected, repr(input, replacer))
  end)

  it("supports custom indentation", function()
    local input = { outer = { inner = true } }
    local expected = [[
{
..outer = {
....inner = true
..}
}]]
    assert.are_equal(expected, repr(input, nil, ".."))
  end)

  it("errors on invalid indentation types", function()
    assert.has_error(function()
      repr({}, nil, true)
    end, "bad argument #3 (number or string expected, got boolean)")
  end)

  it("supports inline formatting", function()
    local input = { key = "value", key2 = { nested = { inner = true } }, ["not-valid"] = true }
    local expected = '{key="value",key2={nested={inner=true}},["not-valid"]=true}'
    assert.are_equal(expected, repr(input, nil, ""))
  end)

  it("renders circular references without crashing", function()
    local root = { title = "root" }
    local child = { name = "child" }
    root.child = child
    root.self = root
    child.parent = root

    local expected = [[
{
  child = {
    name = "child",
    parent = <cycle>
  },
  self = <cycle>,
  title = "root"
}]]
    assert.are_equal(expected, repr(root))
  end)

  for _, v in ipairs(kw.kwlist()) do
    it(fmt("brackets reserved keys for %q", v), function()
      local expected = '{\n  ["' .. v .. '"] = true\n}'
      assert.are_equal(expected, repr({ [v] = true }))
    end)
  end
end)
