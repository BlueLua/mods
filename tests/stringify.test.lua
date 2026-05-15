local mods = require "mods"

local kw = mods.keyword
local is_luajit = mods.runtime.is_luajit

local stringify = mods.stringify
local fmt = string.format

describe("mods.stringify", function()
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
      assert.are.equal(expected, stringify(input))
    end
  end)

  it("renders arrays as implicit entries by default", function()
    assert.are.equal('{\n  "a",\n  "b",\n  "c"\n}', stringify({ "a", "b", "c" }))
    assert.are.equal('{"a","b","c"}', stringify({ "a", "b", "c" }, { newline = "" }))
  end)

  it("optionally keeps contiguous array keys explicit", function()
    local opts = { omit_array_keys = false }
    assert.are.equal('{\n  [1] = "a",\n  [2] = "b",\n  [3] = "c"\n}', stringify({ "a", "b", "c" }, opts))
    assert.are.equal(
      '{[1]="a",[2]="b",[3]="c"}',
      stringify({ "a", "b", "c" }, { omit_array_keys = false, newline = "" })
    )
  end)

  it("renders empty arrays as empty braces", function()
    assert.are.equal("{}", stringify({}))
  end)

  it("renders dictionaries with indentation by default", function()
    local input = { hello = "world", answer = 42 }
    local expected = '{\n  answer = 42,\n  hello = "world"\n}'
    assert.are.equal(expected, stringify(input))
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
    assert.are.equal(expected, stringify(input))
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
  "a",
  "b",
  name = "Ada",
  nested = {
    "x",
    role = "Scientist"
  }
}]]
    assert.are.equal(expected, stringify(input))
  end)

  it("renders sparse numeric tables without nil placeholders", function()
    local input = {
      [1] = "a",
      [3] = "c",
      name = "Ada",
    }
    local expected = [[
{
  "a",
  [3] = "c",
  name = "Ada"
}]]
    assert.are.equal(expected, stringify(input))
  end)

  it("renders arrays with gaps as keyed tables", function()
    local input = { "a", nil, "b" }
    local expected = '{\n  "a",\n  [3] = "b"\n}'
    assert.are.equal(expected, stringify(input))
  end)

  it("keeps integer keys after gaps when omitting array keys", function()
    local input = {
      "a",
      nil,
      "b",
      nested = { "x", "y", nil, "z" },
    }
    local expected = [[
{
  "a",
  [3] = "b",
  nested = {
    "x",
    "y",
    [4] = "z"
  }
}]]
    assert.are.equal(expected, stringify(input))
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
  "a",
  [3] = "b",
  nested = {
    "x",
    [3] = "y"
  },
  role = "Scientist"
}]]
    assert.are.equal(expected, stringify(input))
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
    "x",
    "y"
  },
  user = {
    name = "Ada"
  }
}]]
    assert.are.equal(expected, stringify(input))
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
    assert.are.equal(expected, stringify(input))
  end)

  it("errors on non-function replacer", function()
    assert.has_error(function()
      stringify({}, { replacer = true })
    end, "stringify.opts.replacer: function expected, got boolean")
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
  "one",
  "two",
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
    assert.are.equal(expected, stringify(input, { replacer = replacer }))
  end)

  it("supports custom indentation", function()
    local input = { outer = { inner = true } }
    local expected = [[
{
..outer = {
....inner = true
..}
}]]
    assert.are.equal(expected, stringify(input, { indent = ".." }))
  end)

  it("errors on invalid indentation types", function()
    assert.has_error(function()
      stringify({}, { indent = true })
    end, "stringify.opts.indent: string expected, got boolean")
  end)

  it("supports custom newlines", function()
    local input = { outer = { inner = true } }
    local expected = "{\r\n  outer = {\r\n    inner = true\r\n  }\r\n}"
    assert.are.equal(expected, stringify(input, { newline = "\r\n" }))
  end)

  it("errors on invalid newline types", function()
    assert.has_error(function()
      stringify({}, { newline = true })
    end, "stringify.opts.newline: string expected, got boolean")
  end)

  it("errors on invalid option types", function()
    assert.has_error(function()
      stringify({}, true)
    end, "bad argument #2 (table expected, got boolean)")

    assert.has_error(function()
      stringify({}, { omit_array_keys = "yes" })
    end, "stringify.opts.omit_array_keys: boolean expected, got string")
  end)

  it("supports inline formatting", function()
    local input = { key = "value", key2 = { nested = { inner = true } }, ["not-valid"] = true }
    local expected = '{key="value",key2={nested={inner=true}},["not-valid"]=true}'
    assert.are.equal(expected, stringify(input, { newline = "" }))
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
    assert.are.equal(expected, stringify(root))
  end)

  for _, v in ipairs(kw.kwlist()) do
    it(fmt("brackets reserved keys for %q", v), function()
      local expected = '{\n  ["' .. v .. '"] = true\n}'
      assert.are.equal(expected, stringify({ [v] = true }))
    end)
  end
end)
