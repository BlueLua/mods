# mods

[![Test](https://img.shields.io/github/actions/workflow/status/BlueLua/mods/test.yml?branch=main&label=test&style=flat-square)](https://github.com/BlueLua/mods/actions/workflows/test.yml)
[![LuaRocks](https://img.shields.io/luarocks/v/BlueLua/mods?color=blue&style=flat-square)](https://luarocks.org/modules/BlueLua/mods)
![Lua Versions](https://img.shields.io/badge/lua-5.1%20%7C%205.2%20%7C%205.3%20%7C%205.4%20%7C%205.5%20%7C%20LuaJIT-blue?style=flat-square)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20windows-blue?style=flat-square)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](https://github.com/BlueLua/mods/blob/main/LICENSE)

Modular Lua utilities for common tasks - lazy-loaded, zero dependencies.

Check out the [documentation] for guides and examples.

## ✨ Features

- **Predictable APIs**: A cohesive collection of helper utilities for common
  programming tasks and data structures.
- **Lazy Loading**: Automatic lazy loading of sub-modules to keep startup times
  fast.
- **Lightweight**: Pure Lua with no dependencies, except optional
  [LFS](https://github.com/lunarmodules/luafilesystem) for file operations.
- **Multiple Lua Versions**: Compatible with LuaJIT, Lua 5.1, 5.2, 5.3, 5.4, and
  5.5.
- **Cross-Platform**: Works consistently across Windows, macOS, and Linux.

## 📦 Installation

```sh
luarocks install mods
```

## 🚀 Usage

```lua
local mods = require "mods"

local stripped = mods.str.strip("   hello world   ")
print(stripped) -- Output: "hello world"
```

[documentation]: https://bluelua.github.io/mods
