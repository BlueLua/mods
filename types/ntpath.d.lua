---@meta mods.ntpath

---Windows/NT-style path operations.
---
--->💡Python `ntpath`-style behavior, ported to Lua.
---
---## Usage
---
---```lua
---ntpath = require "mods.ntpath"
---
---print(ntpath.join([[C:\]], "Users", "me"))    --> "C:\Users\me"
---print(ntpath.normcase([[A/B\C]]))             --> [[a\b\c]]
---print(ntpath.splitdrive([[C:\Users\me]]))     --> "C:", [[\Users\me]]
---print(ntpath.isreserved([[C:\Temp\CON.txt]])) --> true
---```
---
--->✨ Same API as `mods.path`, but with Windows/NT path semantics.
---
---
---@class mods.ntpath:mods.path
local M = {}

---
---Expand percent-style variables in a string.
---
---@param p string
---@return string expanded
---@private
function M._expand_percent_vars(p) end
---
---Return `true` when `path` points to a mount root.
---
---```lua
---ntpath.ismount([[C:\]]) --> true
---```
---
---@param path string Path to inspect.
---@return boolean isMount `true` if the path resolves to a mount root.
---@nodiscard
function M.ismount(path) end

---
---Return `true` when `path` contains a reserved NT filename.
---
---```lua
---ntpath.isreserved([[a\CON.txt]]) --> true
---```
---
---@param path string Path to inspect.
---@return boolean isReserved `true` if any component is NT-reserved.
---@nodiscard
function M.isreserved(path) end

return M
