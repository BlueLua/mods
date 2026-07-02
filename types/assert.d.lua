---@meta _

---
---Validation assertion helpers that throw an error if the validation fails.
---
---```lua
---local assert = mods.assert
---
---assert.number(123)    --> 123
---assert.number("nope") --> raises error: "number expected, got string"
---assert(123, "number") --> runs validation, returns nil
---```
---
---@class mods.assert
---@field [string] fun<T>(v:T, optional?:boolean, msg?:string, lvl?:integer):T
---@overload fun<T>(v:T, validator:mods.validatorName, msg?:string, optional?:boolean, lvl?:integer):T
local M = {}

--------------------------------------------------------------------------------
-- Type Checks
--------------------------------------------------------------------------------

---
---Asserts that `v` is a boolean. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.boolean(true) --> true
---assert.boolean(1)    --> raises error: "boolean expected, got number"
---```
---
---@section Type Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.boolean(v, msg, optional, lvl) end

---
---Asserts that `v` is a cdata value (LuaJIT only). Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.cdata(val) --> val
---```
---
---@section Type Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.cdata(v, msg, optional, lvl) end

---
---Asserts that `v` is a function. Returns `v` if successful, otherwise raises an error.
---
---```lua
---local fn = function() end
---assert.Function(fn) --> fn
---assert.Function(1)  --> raises error: "function expected, got number"
---```
---
---@section Type Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.Function(v, msg, optional, lvl) end

---
---Asserts that `v` is `nil`. Returns `nil` if successful, otherwise raises an error.
---
---```lua
---assert.Nil(nil) --> nil
---assert.Nil(0)   --> raises error: "nil expected, got number"
---```
---
---@section Type Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.Nil(v, msg, optional, lvl) end

---
---Asserts that `v` is a number. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.number(42)  --> 42
---assert.number("x") --> raises error: "number expected, got string"
---```
---
---@section Type Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.number(v, msg, optional, lvl) end

---
---Asserts that `v` is a string. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.string("hello") --> "hello"
---assert.string(1)       --> raises error: "string expected, got number"
---```
---
---@section Type Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.string(v, msg, optional, lvl) end

---
---Asserts that `v` is a table. Returns `v` if successful, otherwise raises an error.
---
---```lua
---local t = {}
---assert.table(t) --> t
---assert.table(1) --> raises error: "table expected, got number"
---```
---
---@section Type Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.table(v, msg, optional, lvl) end

---
---Asserts that `v` is a thread. Returns `v` if successful, otherwise raises an error.
---
---```lua
---local co = coroutine.create(function() end)
---assert.thread(co) --> co
---assert.thread(1)  --> raises error: "thread expected, got number"
---```
---
---@section Type Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.thread(v, msg, optional, lvl) end

---
---Asserts that `v` is a userdata value. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.userdata(io.stdout) --> io.stdout
---assert.userdata(1)         --> raises error: "userdata expected, got number"
---```
---
---@section Type Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.userdata(v, msg, optional, lvl) end

--------------------------------------------------------------------------------
-- Value Checks
--------------------------------------------------------------------------------

---
---Asserts that `v` is callable. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.callable(print) --> print
---assert.callable(1)     --> raises error: "callable value expected, got 1"
---```
---
---@section Value Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.callable(v, msg, optional, lvl) end

---
---Asserts that `v` is defined (not `nil`). Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.defined(1)   --> 1
---assert.defined(nil) --> raises error: "defined value expected, got no value"
---```
---
---@section Value Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.defined(v, msg, optional, lvl) end

---
---Asserts that `v` is exactly `false`. Returns `false` if successful, otherwise raises an error.
---
---```lua
---assert.False(false) --> false
---assert.False(true)  --> raises error: "false value expected, got true"
---```
---
---@section Value Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.False(v, msg, optional, lvl) end

---
---Asserts that `v` is falsy (either `false` or `nil`). Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.falsy(false) --> false
---assert.falsy(1)     --> raises error: "falsy value expected, got 1"
---```
---
---@section Value Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.falsy(v, msg, optional, lvl) end

---
---Asserts that `v` is a finite number. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.finite(123)       --> 123
---assert.finite(math.huge) --> raises error: "finite value expected, got inf"
---```
---
---@section Value Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.finite(v, msg, optional, lvl) end

---
---Asserts that `v` is a float (has a fractional part). Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.float(1.5) --> 1.5
---assert.float(1)   --> raises error: "float value expected, got 1"
---```
---
---@section Value Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.float(v, msg, optional, lvl) end

---
---Asserts that `v` is an infinite number. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.infinite(math.huge) --> inf
---assert.infinite(123)       --> raises error: "infinite value expected, got 123"
---```
---
---@section Value Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.infinite(v, msg, optional, lvl) end

---
---Asserts that `v` is an integer. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.integer(1)   --> 1
---assert.integer(1.5) --> raises error: "integer value expected, got 1.5"
---```
---
---@section Value Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.integer(v, msg, optional, lvl) end

---
---Asserts that `v` is a NaN (not-a-number) value. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.nan(0/0) --> NaN
---assert.nan(1)   --> raises error: "nan value expected, got 1"
---```
---
---@section Value Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.nan(v, msg, optional, lvl) end

---
---Asserts that `v` is exactly `true`. Returns `true` if successful, otherwise raises an error.
---
---```lua
---assert.True(true)  --> true
---assert.True(false) --> raises error: "true value expected, got false"
---```
---
---@section Value Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.True(v, msg, optional, lvl) end

---
---Asserts that `v` is truthy (neither `false` nor `nil`). Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.truthy(1)     --> 1
---assert.truthy(false) --> raises error: "truthy value expected, got false"
---```
---
---@section Value Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T v The passed value.
function M.truthy(v, msg, optional, lvl) end

--------------------------------------------------------------------------------
-- Path Checks (Requires LuaFileSystem / lfs)
--------------------------------------------------------------------------------

---
---Asserts that `v` is a valid filesystem path. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.path("README.md") --> "README.md"
---```
---
---@section Path Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T path The passed path string.
function M.path(v, msg, optional, lvl) end

---
---Asserts that `v` is a block device path. Returns `v` if successful, otherwise raises an error.
---
---@section Path Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T path The passed path string.
function M.block_device(v, msg, optional, lvl) end

---
---Asserts that `v` is a character device path. Returns `v` if successful, otherwise raises an error.
---
---@section Path Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T path The passed path string.
function M.char_device(v, msg, optional, lvl) end

---
---Asserts that `v` is a block or character device path. Returns `v` if successful, otherwise raises an error.
---
---@section Path Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T path The passed path string.
function M.device(v, msg, optional, lvl) end

---
---Asserts that `v` is a directory path. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.dir("src") --> "src"
---```
---
---@section Path Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T path The passed path string.
function M.dir(v, msg, optional, lvl) end

---
---Asserts that `v` is a FIFO path. Returns `v` if successful, otherwise raises an error.
---
---@section Path Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T path The passed path string.
function M.fifo(v, msg, optional, lvl) end

---
---Asserts that `v` is a file path. Returns `v` if successful, otherwise raises an error.
---
---```lua
---assert.file("README.md") --> "README.md"
---```
---
---@section Path Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T path The passed path string.
function M.file(v, msg, optional, lvl) end

---
---Asserts that `v` is a symlink path. Returns `v` if successful, otherwise raises an error.
---
---@section Path Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T path The passed path string.
function M.symlink(v, msg, optional, lvl) end

---
---Asserts that `v` is a socket path. Returns `v` if successful, otherwise raises an error.
---
---@section Path Checks
---@generic T
---@param v T Value to validate.
---@param msg? string Optional override template.
---@param optional? boolean Skip validation when `v` is `nil`.
---@param lvl? integer Optional error level for `error()` (defaults to 2).
---@return T path The passed path string.
function M.socket(v, msg, optional, lvl) end

return M
