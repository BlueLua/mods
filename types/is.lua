---@meta mods.is

---@module 'mods.list'
local List

---@alias modsValidatorName
---|type
---|string
---
---|'callable'
---|'false'
---|'falsy'
---|'integer'
---|'true'
---|'truthy'
---
---|'block'
---|'char'
---|'device'
---|'dir'
---|'fifo'
---|'file'
---|'link'
---|'path'
---|'socket'

---
---Type predicates for Lua values and filesystem path types.
---
---## Usage
---
---```lua
---is = require "mods.is"
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
---> [!IMPORTANT]
--->
---> Path checks require **LuaFileSystem**
---> ([`lfs`](https://github.com/lunarmodules/luafilesystem))
---> and raise an error if it is not installed.
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
---@overload fun(v:any, tp:modsValidatorName):boolean
local M = {}

---@private
---Names of filesystem path-check predicates shared by related modules/tests.
M._path_validator_names = List({ "path", "block", "char", "dir", "fifo", "file", "link", "socket", "device" })

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
M.Boolean = M.boolean

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
M["function"] = function(v) end
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
M["nil"] = function(v) end
M.Nil = M["nil"]

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
M.Number = M.number

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
M.String = M.string

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
M.Table = M.table

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
M.Thread = M.thread

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
M.Userdata = M.userdata

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
M["false"] = function(v) end
M.False = M["false"]

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
M["true"] = function(v) end
M.True = M["true"]

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
M.Falsy = M.falsy

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
M.Callable = M.callable

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
M.Integer = M.integer

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
M.Truthy = M.truthy

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
M.Path = M.path

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
M.Block = M.block

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
M.Char = M.char

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
M.Device = M.device

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
M.Dir = M.dir

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
M.Fifo = M.fifo

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
M.File = M.file

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
M.Link = M.link

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
M.Socket = M.socket

return M
