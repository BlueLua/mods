---
title: "runtime"
description: "Lua runtime metadata and version compatibility flags."
---

Lua runtime metadata and version compatibility flags.

## Usage

```lua
runtime = mods.runtime

print(runtime.version)  --> 501 | 502 | 503 | 504 | 505
print(runtime.is_lua55)    --> true | false
```

## Fields

| Field          | Description                                       |
| -------------- | ------------------------------------------------- |
| [`is_lua51`]   | True only on Lua 5.1 runtimes.                    |
| [`is_lua52`]   | True only on Lua 5.2 runtimes.                    |
| [`is_lua53`]   | True only on Lua 5.3 runtimes.                    |
| [`is_lua54`]   | True only on Lua 5.4 runtimes.                    |
| [`is_lua55`]   | True only on Lua 5.5 runtimes.                    |
| [`is_luajit`]  | True when running under LuaJIT.                   |
| [`is_windows`] | True when running on a Windows host.              |
| [`major`]      | Major version number parsed from `version`.       |
| [`minor`]      | Minor version number parsed from `version`.       |
| [`version`]    | Numeric version encoded as `major * 100 + minor`. |

### `is_lua51` (`boolean`) {#is-lua51}

True only on Lua 5.1 runtimes.

```lua
print(runtime.is_lua51) --> true | false
```

---

### `is_lua52` (`boolean`) {#is-lua52}

True only on Lua 5.2 runtimes.

```lua
print(runtime.is_lua52) --> true | false
```

---

### `is_lua53` (`boolean`) {#is-lua53}

True only on Lua 5.3 runtimes.

```lua
print(runtime.is_lua53) --> true | false
```

---

### `is_lua54` (`boolean`) {#is-lua54}

True only on Lua 5.4 runtimes.

```lua
print(runtime.is_lua54) --> true | false
```

---

### `is_lua55` (`boolean`) {#is-lua55}

True only on Lua 5.5 runtimes.

```lua
print(runtime.is_lua55) --> true | false
```

---

### `is_luajit` (`boolean`) {#is-luajit}

True when running under LuaJIT.

```lua
print(runtime.is_luajit) --> true | false
```

---

### `is_windows` (`boolean`) {#is-windows}

True when running on a Windows host.

```lua
print(runtime.is_windows) --> true | false
```

---

### `major` (`5`) {#major}

Major version number parsed from `version`.

```lua
print(runtime.major) --> 5
```

---

### `minor` (`1` | `2` | `3` | `4` | `5`) {#minor}

Minor version number parsed from `version`.

```lua
print(runtime.minor) --> 1 | 2 | 3 | 4 | 5
```

---

### `version` (`501` | `502` | `503` | `504` | `505`) {#version}

Numeric version encoded as `major * 100 + minor`.

```lua
print(runtime.version) --> 501 | 502 | 503 | 504 | 505
```

<!-- prettier-ignore-start -->
[`is_lua51`]: #is-lua51
[`is_lua52`]: #is-lua52
[`is_lua53`]: #is-lua53
[`is_lua54`]: #is-lua54
[`is_lua55`]: #is-lua55
[`is_luajit`]: #is-luajit
[`is_windows`]: #is-windows
[`major`]: #major
[`minor`]: #minor
[`version`]: #version
<!-- prettier-ignore-end -->
