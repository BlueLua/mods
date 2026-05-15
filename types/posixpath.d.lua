---@meta mods.posixpath

---
---POSIX-style path operations.
---
--->💡 Python `posixpath`-style behavior, ported to Lua.
---
---## Usage
---
---```lua
---posixpath = require "mods.posixpath"
---
---print(posixpath.join("/usr", "bin"))               --> "/usr/bin"
---print(posixpath.normpath("/a//./b/.."))            --> "/a"
---print(posixpath.splitext("archive.tar.gz"))        --> "archive.tar", ".gz"
---print(posixpath.relpath("/usr/local/bin", "/usr")) --> "local/bin"
---```
---
--->✨ Same API as `mods.path`, but with POSIX path semantics.
---
---@class mods.posixpath:mods.path
local M = {}

return M
