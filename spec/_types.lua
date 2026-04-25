---@meta

---@class luassert.internal
local internal = {}

---Assert that a value is a `mods.List`.
function internal.list(v) end

---Assert that a value is a `mods.Set`.
function internal.set(v) end

---Assert that a value is callable.
function internal.callable(v) end

---@class luassert:luassert.internal
assert = {}

assert.equals = assert.equal
assert.Equals = assert.equal

assert.is_list = internal.list
assert.is_set = internal.set
assert.is_callable = internal.callable

assert.List = internal.list
assert.Set = internal.set
assert.Callable = internal.callable

---@class BustedEach
---@field expected? any
---@field throws?   true|string
---@field args?     any[]
---@field init?     any

---@alias BustedEachEntry BustedEach|fun():nil

---
---Generate busted cases from grouped test tables.
---
---Supported entry shapes:
---
---## `args`
---
---Used for plain function calls.
---
---```lua
---each("mods.keyword", kw, {
---  isidentifier = {
---    { args = { "hello_world" }, expected = true },
---  },
---})
---```
---
---## `init`
---
---Used to construct an object before calling the named method.
---
---```lua
---each("List", List, {
---  count = {
---    { init = { { "a", "b", "a" } }, args = { "a" }, expected = 2 },
---  },
---})
---```
---
---## `throws`
---
---Used for cases that should raise.
---
---```lua
---each("mods.str", str, {
---  partition = {
---    { args = { "abc", "" }, throws = "empty separator" },
---  },
---})
---```
---
---## `expected = function(res) ... end`
---
---Used when the assertion needs more than a plain equality check.
---
---```lua
---each("mods.keyword", kw, {
---  kwlist = {
---    {
---      args = nil,
---      expected = function(res)
---        assert.Table(res)
---        assert.False(rawequal(res, kw.kwlist()))
---      end,
---    },
---  },
---})
---```
---
---## `function() ... end`
---
---A bare function entry is treated as a custom test body and run directly inside `it(...)`.
---
---```lua
---each("mods.keyword", kw, {
---  iskeyword = {
---    {
---      function()
---        assert.True(kw.iskeyword("local"))
---        assert.True(kw.iskeyword("function"))
---      end,
---      { args = { "hello" }, expected = false },
---    },
---  },
---})
---```
---
---@param name? string
---@param api table
---@param tests table<string, BustedEachEntry[]>
function _G.each(name, api, tests) end
