---
description: "Windows/NT-style path operations."
---

# `ntpath`

Windows/NT-style path operations.

> 💡Python `ntpath`-style behavior, ported to Lua.

## Usage

```lua
ntpath = require "mods.ntpath"

print(ntpath.join([[C:\]], "Users", "me"))    --> "C:\Users\me"
print(ntpath.normcase([[A/B\C]]))             --> [[a\b\c]]
print(ntpath.splitdrive([[C:\Users\me]]))     --> "C:", [[\Users\me]]
print(ntpath.isreserved([[C:\Temp\CON.txt]])) --> true
```

> ✨ Same API as [`mods.path`](/modules/path), but with Windows/NT path
> semantics.

## Functions

<a id="fn-expand-percent-vars"></a>

### `_expand_percent_vars(p)`

Expand percent-style variables in a string. **Parameters**:

- `p` (`string`)

**Return**:

- `expanded` (`string`)

<a id="fn-ismount"></a>

### `ismount(path)`

Return `true` when `path` points to a mount root.

**Parameters**:

- `path` (`string`): Path to inspect.

**Return**:

- `isMount` (`boolean`): `true` if the path resolves to a mount root.

**Example**:

```lua
ntpath.ismount([[C:\]]) --> true
```

<a id="fn-isreserved"></a>

### `isreserved(path)`

Return `true` when `path` contains a reserved NT filename.

**Parameters**:

- `path` (`string`): Path to inspect.

**Return**:

- `isReserved` (`boolean`): `true` if any component is NT-reserved.

**Example**:

```lua
ntpath.isreserved([[a\CON.txt]]) --> true
```
