---
description: "Lua runtime metadata and version compatibility flags."
---

# `runtime`

Lua runtime metadata and version compatibility flags.

## Usage

```lua
runtime = require "mods.runtime"

print(runtime.version)  --> 501 | 502 | 503 | 504 | 505
print(runtime.is_lua55)    --> true | false
```

## Fields

| Field                       | Description                                       |
| --------------------------- | ------------------------------------------------- |
| [`is_lua51`](#is-lua51)     | True only on Lua 5.1 runtimes.                    |
| [`is_lua52`](#is-lua52)     | True only on Lua 5.2 runtimes.                    |
| [`is_lua53`](#is-lua53)     | True only on Lua 5.3 runtimes.                    |
| [`is_lua54`](#is-lua54)     | True only on Lua 5.4 runtimes.                    |
| [`is_lua55`](#is-lua55)     | True only on Lua 5.5 runtimes.                    |
| [`is_luajit`](#is-luajit)   | True when running under LuaJIT.                   |
| [`is_windows`](#is-windows) | True when running on a Windows host.              |
| [`major`](#major)           | Major version number parsed from `version`.       |
| [`minor`](#minor)           | Minor version number parsed from `version`.       |
| [`version`](#version)       | Numeric version encoded as `major * 100 + minor`. |

<a id="is-lua51"></a>

### `is_lua51` (`boolean`)

True only on Lua 5.1 runtimes.

```lua
print(runtime.is_lua51) --> true | false
```

<a id="is-lua52"></a>

### `is_lua52` (`boolean`)

True only on Lua 5.2 runtimes.

```lua
print(runtime.is_lua52) --> true | false
```

<a id="is-lua53"></a>

### `is_lua53` (`boolean`)

True only on Lua 5.3 runtimes.

```lua
print(runtime.is_lua53) --> true | false
```

<a id="is-lua54"></a>

### `is_lua54` (`boolean`)

True only on Lua 5.4 runtimes.

```lua
print(runtime.is_lua54) --> true | false
```

<a id="is-lua55"></a>

### `is_lua55` (`boolean`)

True only on Lua 5.5 runtimes.

```lua
print(runtime.is_lua55) --> true | false
```

<a id="is-luajit"></a>

### `is_luajit` (`boolean`)

True when running under LuaJIT.

```lua
print(runtime.is_luajit) --> true | false
```

<a id="is-windows"></a>

### `is_windows` (`boolean`)

True when running on a Windows host.

```lua
print(runtime.is_windows) --> true | false
```

<a id="major"></a>

### `major` (`5`)

Major version number parsed from `version`.

```lua
print(runtime.major) --> 5
```

<a id="minor"></a>

### `minor` (`1|2|3|4|5`)

Minor version number parsed from `version`.

```lua
print(runtime.minor) --> 1 | 2 | 3 | 4 | 5
```

<a id="version"></a>

### `version` (`501|502|503|504|505`)

Numeric version encoded as `major * 100 + minor`.

```lua
print(runtime.version) --> 501 | 502 | 503 | 504 | 505
```
