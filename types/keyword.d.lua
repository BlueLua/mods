---@meta mods.keyword

---
---Helpers for Lua keywords and identifiers.
---
---## Usage
---
---```lua
---kw = require "mods.keyword"
---
---kw.iskeyword("local"))         --> true
---kw.isidentifier("hello_world") --> true
---```
---
---@class mods.keyword
local M = {}

---
---Return `true` when `v` is a reserved Lua keyword.
---
---```lua
---kw.iskeyword("function") --> true
---kw.iskeyword("hello")    --> false
---```
---
---@section Predicates
---@param v any Value to validate.
---@return boolean isKeyword Whether the check succeeds.
---@nodiscard
function M.iskeyword(v) end

---
---Return `true` when `v` is a valid non-keyword Lua identifier.
---
---```lua
---kw.isidentifier("hello_world") --> true
---kw.isidentifier("local")       --> false
---```
---
---@section Predicates
---@param v any Value to validate.
---@return boolean isIdentifier Whether the check succeeds.
---@nodiscard
function M.isidentifier(v) end

---
---Return Lua keywords as a `mods.List`.
---
---```lua
---kw.kwlist():contains("and")    --> true
---kw.kwlist():contains("global") --> true -- Lua 5.5+
---```
---
---@section Collections
---@return mods.List<string> words List of Lua keywords.
---@nodiscard
function M.kwlist() end

---
---Return Lua keywords as a `mods.Set`.
---
---```lua
---kw.kwlset():contains("and")    --> true
---kw.kwlset():contains("global") --> true -- Lua 5.5+
---```
---
---@section Collections
---@return mods.Set<string> words Set of Lua keywords.
---@nodiscard
function M.kwset() end

---
---Normalize an input into a safe Lua identifier.
---
---```lua
---kw.normalize_identifier(" 2 bad-name ") --> "_2_bad_name"
---```
---
---@section Normalization
---@param s string Input string.
---@return string identifier Normalized Lua identifier.
---@nodiscard
function M.normalize_identifier(s) end

return M
