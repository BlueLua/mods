---@meta _

---Custom error message templates for validators, indexed by validator name.
---@class modsValidatorMessages
---@field [string] string Custom message template for a validator.
---
---@field boolean?  string Custom message template for boolean validator failures.
---@field cdata?    string Custom message template for cdata validator failures.
---@field function? string Custom message template for function validator failures.
---@field nil?      string Custom message template for nil validator failures.
---@field number?   string Custom message template for number validator failures.
---@field string?   string Custom message template for string validator failures.
---@field table?    string Custom message template for table validator failures.
---@field thread?   string Custom message template for thread validator failures.
---@field userdata? string Custom message template for userdata validator failures.
---
---@field callable? string Custom message template for callable validator failures.
---@field false?    string Custom message template for false validator failures.
---@field falsy?    string Custom message template for falsy validator failures.
---@field defined?  string Custom message template for defined validator failures.
---@field finite?   string Custom message template for finite validator failures.
---@field float?    string Custom message template for float validator failures.
---@field infinite? string Custom message template for infinite validator failures.
---@field integer?  string Custom message template for integer validator failures.
---@field nan?      string Custom message template for nan validator failures.
---@field true?     string Custom message template for true validator failures.
---@field truthy?   string Custom message template for truthy validator failures.
---
---@field block_device? string Custom message template for block device validator failures.
---@field char_device? string Custom message template for character device validator failures.
---@field device? string Custom message template for device validator failures.
---@field dir?    string Custom message template for directory validator failures.
---@field fifo?   string Custom message template for named pipe validator failures.
---@field file?   string Custom message template for file validator failures.
---@field symlink? string Custom message template for symbolic link validator failures.
---@field path?   string Custom message template for path validator failures.
---@field socket? string Custom message template for socket validator failures.

---
---Validation helpers for Lua values and filesystem path types.
---
---## Usage
---
---```lua
---local validate = mods.validate
---
---ok, err = validate.number("nope") --> false, "number expected, got string"
---ok, err = validate(123, "number") --> true, nil
---```
---
---## `validate()`
---`validate(v, validator)` dispatches to the registered validator.
---If `validator` is omitted, it defaults to `"truthy"`.
---
---```lua
---validate()         --> false, "truthy value expected, got no value"
---validate(1)        --> true, nil
---validate(1, "nil") --> false, "nil expected, got number"
---```
---
---> [!IMPORTANT]
--->
---> Path checks require **LuaFileSystem**
---> ([`lfs`](https://github.com/lunarmodules/luafilesystem))
---> and raise an error if it is not installed.
---
---## Validator Names
---
---Validator names are case-insensitive for field access.
---
---```lua
---validate.number(1) --> true, nil
---validate.NumBer(1) --> true, nil
---```
---
---`validator` in `validate(v, validator)` is matched as-is (case-sensitive):
---
---```lua
---validate(1, "number") --> true, nil
---validate(1, "NuMbEr") --> false, "NuMbEr expected, got number"
--- ```
---
---## Custom Messages
---
---Validator functions accept an optional template override as the second
---argument: <code v-pre>validate.number(v, "need {{expected}}, got {{got}}")`</code>.
---
---You can also set `validate.messages.<name>` to define
---default templates per validator.
---
---```lua
---validate.string(123, "want {{expected}}, got {{got}}")
-----> false, "want string, got number"
---```
---
---@class mods.validate
---@field [string] fun(...):(isValid:boolean,errmsg:string?)
---
---Custom error-message templates for validator failures.
---
---Set `validate.messages.<name>`, where `<name>` is a validator name
---(for example: `number`, `truthy`, `file`).
---
---The error-message template is used only when validation fails and an error message is returned.
---
---```lua
---validate.messages.number = "need {{expected}}, got {{got}}"
---ok, err = validate.number("x") --> false, "need number, got string"
---```
---
---**Placeholders**:
---
---* <code v-pre>{{expected}}</code>: The check target (for example `number`,
---  `string`, `truthy`).
---* <code v-pre>{{got}}</code>: The detected failure kind (usually a Lua type;
---  path validators use `invalid path`).
---* <code v-pre>{{value}}</code>: The passed value, formatted for display (strings
---  are quoted).
---
---> [!NOTE]
--->
---> When the passed value is `nil`, rendered value text uses `no value`.
--->
---> ```lua
---> validate.messages.truthy = "{{expected}} value expected, got {{value}}"
---> validate.truthy(nil) --> false, "truthy value expected, got no value"
---> ```
---
---**Default Messages**:
---
---* Type checks: <code v-pre>{{expected}} expected, got {{got}}</code>
---* Value checks: <code v-pre>{{expected}} value expected, got {{value}}</code>
---* Path checks:
---  <code v-pre>{{value}} is not a valid {{expected}} path</code>
---  (for `path`: <code v-pre>{{value}} is not a valid path</code>)
---
---> [!NOTE]
--->
---> For path checks, if the value is not a `string`, the message falls back to
---> `messages.string` (as if `validate.string` was called).
---
---@field messages modsValidatorMessages
---
---@overload fun(v:any, validator?:mods.validatorName, msg?:string):(boolean, string?)
local M = {}

---
---Returns `true` when `v` is a boolean. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.boolean(true) --> true, nil
---ok, err = validate.boolean(1)    --> false, "boolean expected, got number"
---```
---
---@section Type Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.boolean = function(v, msg) end

---
---Returns `true` when `v` is a function. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.Function(function() end) --> true, nil
---ok, err = validate.Function(1)
-----> false, "function expected, got number"
---```
---
---@section Type Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.Function = function(v, msg) end

---
---Returns `true` when `v` is `nil`. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.Nil(nil) --> true, nil
---ok, err = validate.Nil(0)   --> false, "nil expected, got number"
---```
---
---@section Type Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.Nil = function(v, msg) end

---
---Returns `true` when `v` is a number. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.number(42)  --> true, nil
---ok, err = validate.number("x") --> false, "number expected, got string"
---```
---
---@section Type Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.number = function(v, msg) end

---
---Returns `true` when `v` is a string. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.string("hello") --> true, nil
---ok, err = validate.string(1)       --> false, "string expected, got number"
---```
---
---@section Type Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.string = function(v, msg) end

---
---Returns `true` when `v` is a table. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.table({}) --> true, nil
---ok, err = validate.table(1)  --> false, "table expected, got number"
---```
---
---@section Type Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.table = function(v, msg) end

---
---Returns `true` when `v` is a thread. Otherwise returns `false` and an error
---message.
---
---```lua
---co = coroutine.create(function() end)
---ok, err = validate.thread(co) --> true, nil
---ok, err = validate.thread(1)  --> false, "thread expected, got number"
---```
---
---@section Type Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.thread = function(v, msg) end

---
---Returns `true` when `v` is a userdata value. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.userdata(io.stdout) --> true, nil
---ok, err = validate.userdata(1)         --> false, "userdata expected, got number"
---```
---
---@section Type Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.userdata = function(v, msg) end

---
---Returns `true` when `v` is a cdata value (LuaJIT only). Otherwise returns
---`false` and an error message.
---
---```lua
---ok, err = validate.cdata(v)
---```
---
---@section Type Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.cdata = function(v, msg) end

---
---Returns `true` when `v` is exactly `false`. Otherwise returns `false` and an
---error message.
---
---```lua
---ok, err = validate.False(false) --> true, nil
---ok, err = validate.False(true)  --> false, "false value expected, got true"
---```
---
---@section Value Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.False = function(v, msg) end

---
---Returns `true` when `v` is exactly `true`. Otherwise returns `false` and an
---error message.
---
---```lua
---ok, err = validate.True(true)  --> true, nil
---ok, err = validate.True(false) --> false, "true value expected, got false"
---```
---
---@section Value Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.True = function(v, msg) end

---
---Returns `true` when `v` is defined (not `nil`). Otherwise returns `false`
---and an error message.
---
---```lua
---ok, err = validate.defined(1)   --> true, nil
---ok, err = validate.defined(nil) --> false, "defined value expected, got no value"
---```
---
---@section Value Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.defined = function(v, msg) end

---
---Returns `true` when `v` is falsy. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.falsy(false) --> true, nil
---ok, err = validate.falsy(1)     --> false, "falsy value expected, got 1"
---```
---
---@section Value Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.falsy = function(v, msg) end

---
---Returns `true` when `v` is callable. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.callable(type) --> true, nil
---ok, err = validate.callable(1)    --> false, "callable value expected, got 1"
---```
---
---@section Value Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.callable = function(v, msg) end

---
---Returns `true` when `v` is an integer. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.integer(1)   --> true, nil
---ok, err = validate.integer(1.5) --> false, "integer value expected, got 1.5"
---```
---
---@section Value Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.integer = function(v, msg) end

---
---Returns `true` when `v` is a NaN (not-a-number) value. Otherwise returns
---`false` and an error message.
---
---```lua
---ok, err = validate.nan(0/0) --> true, nil
---ok, err = validate.nan(1)   --> false, "nan value expected, got 1"
---```
---
---@section Value Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.nan = function(v, msg) end

---
---Returns `true` when `v` is truthy. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.truthy(1)     --> true, nil
---ok, err = validate.truthy(false) --> false, "truthy value expected, got false"
---```
---
---@section Value Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.truthy = function(v, msg) end

---
---Returns `true` when `v` is a valid filesystem path. Otherwise returns `false`
---and an error message.
---
---```lua
---ok, err = validate.path("README.md")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.path = function(v, msg) end

---
---Returns `true` when `v` is a block device path. Otherwise returns `false`
---and an error message.
---
---```lua
---ok, err = validate.block_device(".")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.block_device = function(v, msg) end

---
---Returns `true` when `v` is a char device path. Otherwise returns `false` and
---an error message.
---
---```lua
---ok, err = validate.char_device(".")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.char_device = function(v, msg) end

---
---Returns `true` when `v` is a block or char device path. Otherwise returns
---`false` and an error message.
---
---```lua
---ok, err = validate.device(".")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.device = function(v, msg) end

---
---Returns `true` when `v` is a directory path. Otherwise returns `false` and an
---error message.
---
---```lua
---ok, err = validate.dir(".")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.dir = function(v, msg) end

---
---Returns `true` when `v` is a FIFO path. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.fifo(".")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.fifo = function(v, msg) end

---
---Returns `true` when `v` is a file path. Otherwise returns `false` and an error
---message.
---
---```lua
---ok, err = validate.file(".")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.file = function(v, msg) end

---
---Returns `true` when `v` is a symlink path. Otherwise returns `false` and an
---error message.
---
---```lua
---ok, err = validate.symlink(".")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.symlink = function(v, msg) end

---
---Returns `true` when `v` is a socket path. Otherwise returns `false` and an
---error message.
---
---```lua
---ok, err = validate.socket(".")
---```
---
---@section Path Checks
---@param v any Value to validate.
---@param msg? string Optional override template.
---@return boolean isValid Whether the check succeeds.
---@return string? err Error message when the check fails.
M.socket = function(v, msg) end

---
---Register or override a validator function by name.
---
---```lua
---validate.register("odd", function(v)
---  return type(v) == "number" and v % 2 == 1
---end, "{{value}} does not satisfy {{expected}}")
---
---ok, err = validate.odd(3)     --> true, nil
---ok, err = validate.odd("x")   --> false, '"x" does not satisfy odd'
---ok, err = validate(2, "odd")  --> false, "2 does not satisfy odd"
---```
---
---> [!NOTE]
--->
---> * If `template` is provided, it becomes the default message template for that validator.
---> * If `template` is omitted, failures use: `{{expected}} expected, got {{got}}`.
---
---@section Registration
---@param name string Validator name.
---@param validator fun(v:any):(ok:boolean) Validator function.
---@param template? string Optional default message template.
---@return nil none
function M.register(name, validator, template) end

return M
