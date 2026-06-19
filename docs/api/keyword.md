---
title: "keyword"
description: "Helpers for Lua keywords and identifiers."
---

Helpers for Lua keywords and identifiers.

## Usage

```lua
kw = mods.keyword

kw.iskeyword("local"))         --> true
kw.isidentifier("hello_world") --> true
```

## Functions

**Collections**:

| Function     | Description                             |
| ------------ | --------------------------------------- |
| [`kwlist()`] | Return Lua keywords as a [`mods.List`]. |
| [`kwset()`]  | Return Lua keywords as a [`mods.Set`].  |

**Normalization**:

| Function                    | Description                                    |
| --------------------------- | ---------------------------------------------- |
| [`normalize_identifier(s)`] | Normalize an input into a safe Lua identifier. |

**Predicates**:

| Function            | Description                                                   |
| ------------------- | ------------------------------------------------------------- |
| [`isidentifier(v)`] | Return `true` when `v` is a valid non-keyword Lua identifier. |
| [`iskeyword(v)`]    | Return `true` when `v` is a reserved Lua keyword.             |

### Collections

#### `kwlist()` {#kwlist}

Return Lua keywords as a [`mods.List`].

**Returns**:

- `words` ([`mods.List`]`<string>`): List of Lua keywords.

**Example**:

```lua
kw.kwlist():contains("and")    --> true
kw.kwlist():contains("global") --> true -- Lua 5.5+
```

---

#### `kwset()` {#kwset}

Return Lua keywords as a [`mods.Set`].

**Returns**:

- `words` ([`mods.Set`]`<string>`): Set of Lua keywords.

**Example**:

```lua
kw.kwlset():contains("and")    --> true
kw.kwlset():contains("global") --> true -- Lua 5.5+
```

---

### Normalization

#### `normalize_identifier(s)` {#normalize-identifier}

Normalize an input into a safe Lua identifier.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `identifier` (`string`): Normalized Lua identifier.

**Example**:

```lua
kw.normalize_identifier(" 2 bad-name ") --> "_2_bad_name"
```

---

### Predicates

#### `isidentifier(v)` {#isidentifier}

Return `true` when `v` is a valid non-keyword Lua identifier.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isIdentifier` (`boolean`): Whether the check succeeds.

**Example**:

```lua
kw.isidentifier("hello_world") --> true
kw.isidentifier("local")       --> false
```

---

#### `iskeyword(v)` {#iskeyword}

Return `true` when `v` is a reserved Lua keyword.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isKeyword` (`boolean`): Whether the check succeeds.

**Example**:

```lua
kw.iskeyword("function") --> true
kw.iskeyword("hello")    --> false
```

<!-- prettier-ignore-start -->
[`isidentifier(v)`]: #isidentifier
[`iskeyword(v)`]: #iskeyword
[`kwlist()`]: #kwlist
[`kwset()`]: #kwset
[`mods.List`]: /mods/api/list
[`mods.Set`]: /mods/api/set
[`normalize_identifier(s)`]: #normalize-identifier
<!-- prettier-ignore-end -->
