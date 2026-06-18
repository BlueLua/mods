---@meta mods.utils

---
---Shared utility helpers used across the Mods library.
---
---## Usage
---
---```lua
---utils = mods.utils
---
---print(utils.quote('hello "world"')) --> 'hello "world"'
---```
---
---@class mods.utils
local M = {}

---
---Smart-quote a string for readable Lua-like output.
---
---```lua
---print(utils.quote('He said "hi"')) -- 'He said "hi"'
---print(utils.quote('say "hi" and \\'bye\\'')) -- "say \"hi\" and 'bye'"
---```
---
---@section Formatting
---@param v string String to quote.
---@return string out Quoted string.
---@nodiscard
function M.quote(v) end

---
---Format a key chain as a Lua-like table access path.
---
---```lua
---p1 = utils.keypath("t", "a", "b", "c")        --> "t.a.b.c"
---p2 = utils.keypath("ctx", "users", 1, "name") --> "ctx.users[1].name"
---p3 = utils.keypath("ctx", "invalid-key")      --> 'ctx["invalid-key"]'
---p4 = utils.keypath()                          --> ""
---```
---
---@section Formatting
---@param ... any Additional arguments.
---@return string path Rendered key path.
---@nodiscard
function M.keypath(...) end

---
---Format a list-like table as a comma-separated argument string.
---
---```lua
---utils.args_repr({ "a", 1, true }) --> '"a", 1, true'
---```
---
---@section Formatting
---@param v any Value to format. `nil` returns an empty string.
---@return string out Argument list string.
---@nodiscard
function M.args_repr(v) end

---
---Assert argument value using `mods.validate` and raise a Lua error on failure.
---
---```lua
---utils.assert_arg(1, "ok", "string") --> "ok"
---utils.assert_arg(2, nil, "string", true) --> nil
---utils.assert_arg(2, 123, "string")
-----> raises: bad argument #2 (expected string, got number)
---utils.assert_arg(3, "x", "number", false, "need {{expected}}, got {{got}}")
-----> raises: bad argument #3 (need number, got string)
---```
---
---> [!NOTE]
--->
---> When the caller function name is available, error text includes
---> `to '<function>'` (Lua-style bad argument context).
---
---@section Validation
---@generic T
---@param argn integer Argument index for error context.
---@param v T Value to check.
---@param validator? mods.ValidatorName Validator name (defaults to `"truthy"`).
---@param optional? boolean Skip errors when `v` is `nil` (defaults to `false`).
---@param lv? integer Error level passed to `error` (defaults to `3`).
---@return T validatedValue Same input value on success, or `nil` when optional.
function M.assert_arg(argn, v, validator, optional, lv) end

---
---Validate a value using `mods.validate` and raise a Lua error on failure.
---
---```lua
---utils.validate("path", "ok", "string")
---utils.validate("name", nil, "string", true)
---utils.validate("count", "x", "number")
-----> raises: count: expected number, got string
---```
---
---@section Validation
---@param name string Name for the error prefix.
---@param v any Value to validate.
---@param validator? mods.ValidatorName Validator name (defaults to `"truthy"`).
---@param optional? boolean Skip errors when `v` is `nil` (defaults to `false`).
---@param msg? string Optional override template passed to `mods.validate`.
---@return nil none
function M.validate(name, v, validator, optional, msg) end

---
---Validate a value using `mods.validate` and raise a Lua error on failure.
---
---```lua
---utils.validate({ "ctx", "users", 1, "name" }, nil, "string", true)
---utils.validate({ "ctx", "users", 1, "name" }, 123, "string")
-----> raises: ctx.users[1].name: expected string, got number
---```
---
---> [!NOTE]
--->
---> On failure, `path` is rendered with `mods.utils.keypath`.
---
---@section Validation
---@param path table Path parts for the error name.
---@param v any Value to validate.
---@param validator? mods.ValidatorName Validator name (defaults to `"truthy"`).
---@param optional? boolean Skip errors when `v` is `nil` (defaults to `false`).
---@param msg? string Optional override template passed to `mods.validate`.
---@return nil none
function M.validate(path, v, validator, optional, msg) end

---
---Return a lazy proxy for a module.
---
---The proxy rewrites its metamethods after first access while keeping the proxy
---table itself free of cached fields.
---
---```lua
---local fs = utils.lazy_module("mods.fs")
---print(fs.exists("README.md"))
---
---local stringify = utils.lazy_module("mods.stringify")
---print(stringify({ a = 1 }))
---```
---
---> [!NOTE]
--->
---> Supports both table-returning modules and function-returning modules.
---
---@section Lazy Loading
---@param name string Module name passed to `require`.
---@param err? string Optional error message raised when loading fails.
---@return {} module Lazy proxy for the loaded module.
---@nodiscard
function M.lazy_module(name, err) end

return M
