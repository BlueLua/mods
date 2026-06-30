---@meta _

---Supported validation and type check names.
---@alias mods.validatorName
---| type       Any standard Lua type name (e.g., `"table"`, `"number"`).
---| string     Any validator name.
---| 'callable' A function or table with a `__call` metamethod.
---| 'false'    The boolean value false.
---| 'finite'   A finite number.
---| 'float'    A float number.
---| 'infinite' An infinite number.
---| 'falsy'    A falsy value (nil or false).
---| 'integer'  An integer number.
---| 'true'     The boolean value true.
---| 'truthy'   A truthy value (not nil and not false).
---| 'block'    A block device path.
---| 'char'     A character device path.
---| 'device'   A character or block device path.
---| 'dir'      A directory path.
---| 'fifo'     A named pipe (FIFO) path.
---| 'file'     A regular file path.
---| 'link'     A symbolic link path.
---| 'path'     Any existing path or symbolic link.
---| 'socket'   A socket path.

---
---Type predicates for Lua values and filesystem path types.
---
---## Usage
---
---```lua
---is = mods.is
---
---ok = is.number(3.14)       --> true
---ok = is("hello", "string") --> true
---ok = is.table({})          --> true
---```
---
--->[!NOTE]
--->
--->Function names are case-insensitive.
--->
--->```lua
--->is.table({})  --> true
--->is.Table({})  --> true
--->is.tAbLe({})  --> true
--->```
---
---<!-- markdownlint-disable MD028 -->
---
---> [!IMPORTANT]
--->
---> Path checks require **LuaFileSystem**
---> ([`lfs`](https://github.com/lunarmodules/luafilesystem))
---> and raise an error if it is not installed.
---
---<!-- markdownlint-enable MD028 -->
---
---## `is()`
---
---`is` is also callable as `is(value, type)` to check if a value is of a given type.
---
---```lua
---is("hello", "string") --> true
---is("hello", "String") --> true
---is("hello", "STRING") --> true
---```
---
---@class mods.is
---@overload fun(v:any, tp:mods.validatorName):boolean
local M = {}

---
---Returns `true` when `v` is a boolean.
---
---```lua
---is.boolean(true)
---```
---
---@section Type Checks
---@param v any Value to validate.
---@return boolean isBoolean Whether the check succeeds.
---@nodiscard
M.boolean = function(v) end

---
---Returns `true` when `v` is a function.
---
---```lua
---is.Function(function() end)
---```
---
---@section Type Checks
---@param v any Value to validate.
---@return boolean isFunction Whether the check succeeds.
---@nodiscard
M.Function = function(v) end

---
---Returns `true` when `v` is `nil`.
---
---```lua
---is.Nil(nil)
---```
---
---@section Type Checks
---@param v any Value to validate.
---@return boolean isNil Whether the check succeeds.
---@nodiscard
M.Nil = function(v) end

---
---Returns `true` when `v` is a number.
---
---```lua
---is.number(3.14)
---```
---
---@section Type Checks
---@param v any Value to validate.
---@return boolean isNumber Whether the check succeeds.
---@nodiscard
M.number = function(v) end

---
---Returns `true` when `v` is a string.
---
---```lua
---is.string("hello")
---```
---
---@section Type Checks
---@param v any Value to validate.
---@return boolean isString Whether the check succeeds.
---@nodiscard
M.string = function(v) end

---
---Returns `true` when `v` is a table.
---
---```lua
---is.table({})
---```
---
---@section Type Checks
---@param v any Value to validate.
---@return boolean isTable Whether the check succeeds.
---@nodiscard
M.table = function(v) end

---
---Returns `true` when `v` is a thread.
---
---```lua
---is.thread(coroutine.create(function() end))
---```
---
---@section Type Checks
---@param v any Value to validate.
---@return boolean isThread Whether the check succeeds.
---@nodiscard
M.thread = function(v) end

---
---Returns `true` when `v` is userdata.
---
---```lua
---is.userdata(io.stdout)
---```
---
---@section Type Checks
---@param v any Value to validate.
---@return boolean isUserdata Whether the check succeeds.
---@nodiscard
M.userdata = function(v) end

---
---Truthiness, exact-value, and callable checks.
---

---
---Returns `true` when `v` is exactly `false`.
---
---```lua
---is.False(false)
---```
---
---@section Value Checks
---@param v any Value to validate.
---@return boolean isFalse Whether the check succeeds.
---@nodiscard
M.False = function(v) end

---
---Returns `true` when `v` is exactly `true`.
---
---```lua
---is.True(true)
---```
---
---@section Value Checks
---@param v any Value to validate.
---@return boolean isTrue Whether the check succeeds.
---@nodiscard
M.True = function(v) end

---
---Returns `true` when `v` is falsy.
---
---```lua
---is.falsy(false)
---```
---
---@section Value Checks
---@param v any Value to validate.
---@return boolean isFalsy Whether the check succeeds.
---@nodiscard
M.falsy = function(v) end

---
---Returns `true` when `v` is callable.
---
---```lua
---is.callable(function() end)
---```
---
---@section Value Checks
---@param v any Value to validate.
---@return boolean isCallable Whether the check succeeds.
---@nodiscard
M.callable = function(v) end

---
---Returns `true` when `v` is a finite number.
---
---```lua
---is.finite(42) --> true
---```
---
---@section Value Checks
---@param v any Value to validate.
---@return boolean isFinite Whether the check succeeds.
---@nodiscard
M.finite = function(v) end

---
---Returns `true` when `v` is a float number.
---
---```lua
---is.float(1.5) --> true
---is.float(1.0) --> true (on Lua >= 5.3) or false (on Lua <= 5.2)
---```
---
---@section Value Checks
---@param v any Value to validate.
---@return boolean isFloat Whether the check succeeds.
---@nodiscard
M.float = function(v) end

---
---Returns `true` when `v` is an infinite number.
---
---```lua
---is.infinite(math.huge)  --> true
---```
---
---@section Value Checks
---@param v any Value to validate.
---@return boolean isInfinite Whether the check succeeds.
---@nodiscard
M.infinite = function(v) end

---
---Returns `true` when `v` is an integer.
---
---```lua
---is.integer(42)
---```
---
---@section Value Checks
---@param v any Value to validate.
---@return boolean isInteger Whether the check succeeds.
---@nodiscard
M.integer = function(v) end

---
---Returns `true` when `v` is truthy.
---
---```lua
---is.truthy("non-empty")
---```
---
---@section Value Checks
---@param v any Value to validate.
---@return boolean isTruthy Whether the check succeeds.
---@nodiscard
M.truthy = function(v) end

---
---Returns `true` when `v` is a valid filesystem path.
---
---```lua
---is.path("README.md")
---```
---
---> [!NOTE]
--->
---> Returns `true` for broken symlinks.
---
---@section Path Checks
---@param v any Value to validate.
---@return boolean isPath Whether the check succeeds.
---@nodiscard
M.path = function(v) end

---
---Returns `true` when `v` is a block device path.
---
---```lua
---is.block("/dev/sda")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@return boolean isBlock Whether the check succeeds.
---@nodiscard
M.block = function(v) end

---
---Returns `true` when `v` is a character device path.
---
---```lua
---is.char("/dev/null")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@return boolean isChar Whether the check succeeds.
---@nodiscard
M.char = function(v) end

---
---Returns `true` when `v` is a block or character device path.
---
---```lua
---is.device("/dev/null")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@return boolean isDevice Whether the check succeeds.
---@nodiscard
M.device = function(v) end

---
---Returns `true` when `v` is a directory path.
---
---```lua
---is.dir("/tmp")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@return boolean isDir Whether the check succeeds.
---@nodiscard
M.dir = function(v) end

---
---Returns `true` when `v` is a FIFO path.
---
---```lua
---is.fifo("/path/to/fifo")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@return boolean isFifo Whether the check succeeds.
---@nodiscard
M.fifo = function(v) end

---
---Returns `true` when `v` is a file path.
---
---```lua
---is.file("README.md")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@return boolean isFile Whether the check succeeds.
---@nodiscard
M.file = function(v) end

---
---Returns `true` when `v` is a symlink path.
---
---```lua
---is.link("/path/to/link")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@return boolean isLink Whether the check succeeds.
---@nodiscard
M.link = function(v) end

---
---Returns `true` when `v` is a socket path.
---
---```lua
---is.socket("/path/to/socket")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@return boolean isSocket Whether the check succeeds.
---@nodiscard
M.socket = function(v) end
return M
