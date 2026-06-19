---
title: "ntpath"
description: "Windows/NT-style path operations."
---

Windows/NT-style path operations.

> 💡Python `ntpath`-style behavior, ported to Lua.

## Usage

```lua
ntpath = mods.ntpath

print(ntpath.join([[C:\]], "Users", "me"))    --> "C:\Users\me"
print(ntpath.normcase([[A/B\C]]))             --> [[a\b\c]]
print(ntpath.splitdrive([[C:\Users\me]]))     --> "C:", [[\Users\me]]
print(ntpath.isreserved([[C:\Temp\CON.txt]])) --> true
```

> ✨ Same API as [`mods.path`], but with Windows/NT path semantics.

## Functions

### `_expand_percent_vars(p)` {#expand-percent-vars}

Expand percent-style variables in a string. **Parameters**:

- `p` (`string`)

**Returns**:

- `expanded` (`string`)

---

### `ismount(path)` {#ismount}

Return `true` when `path` points to a mount root.

**Parameters**:

- `path` (`string`): Path to inspect.

**Returns**:

- `isMount` (`boolean`): `true` if the path resolves to a mount root.

**Example**:

```lua
ntpath.ismount([[C:\]]) --> true
```

---

### `isreserved(path)` {#isreserved}

Return `true` when `path` contains a reserved NT filename.

**Parameters**:

- `path` (`string`): Path to inspect.

**Returns**:

- `isReserved` (`boolean`): `true` if any component is NT-reserved.

**Example**:

```lua
ntpath.isreserved([[a\CON.txt]]) --> true
```

<!-- prettier-ignore-start -->
[`mods.path`]: /mods/api/path
<!-- prettier-ignore-end -->
