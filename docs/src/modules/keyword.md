---
description: "Helpers for Lua keywords and identifiers."
---

# `keyword`

Helpers for Lua keywords and identifiers.

## Usage

```lua
kw = require "mods.keyword"

kw.iskeyword("local"))         --> true
kw.isidentifier("hello_world") --> true
```

## Functions

**Collections**:

| Function                 | Description                                            |
| ------------------------ | ------------------------------------------------------ |
| [`kwlist()`](#fn-kwlist) | Return Lua keywords as a [`mods.List`](/modules/list). |
| [`kwset()`](#fn-kwset)   | Return Lua keywords as a [`mods.Set`](/modules/set).   |

**Normalization**:

| Function                                              | Description                                    |
| ----------------------------------------------------- | ---------------------------------------------- |
| [`normalize_identifier(s)`](#fn-normalize-identifier) | Normalize an input into a safe Lua identifier. |

**Predicates**:

| Function                              | Description                                                   |
| ------------------------------------- | ------------------------------------------------------------- |
| [`isidentifier(v)`](#fn-isidentifier) | Return `true` when `v` is a valid non-keyword Lua identifier. |
| [`iskeyword(v)`](#fn-iskeyword)       | Return `true` when `v` is a reserved Lua keyword.             |

### Collections

<a id="fn-kwlist"></a>

#### `kwlist()`

Return Lua keywords as a [`mods.List`](/modules/list).

**Return**:

- `words` (`mods.List<string>`): List of Lua keywords.

**Example**:

```lua
kw.kwlist():contains("and")    --> true
kw.kwlist():contains("global") --> true -- Lua 5.5+
```

<a id="fn-kwset"></a>

#### `kwset()`

Return Lua keywords as a [`mods.Set`](/modules/set).

**Return**:

- `words` (`mods.Set<string>`): Set of Lua keywords.

**Example**:

```lua
kw.kwlset():contains("and")    --> true
kw.kwlset():contains("global") --> true -- Lua 5.5+
```

### Normalization

<a id="fn-normalize-identifier"></a>

#### `normalize_identifier(s)`

Normalize an input into a safe Lua identifier.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `identifier` (`string`): Normalized Lua identifier.

**Example**:

```lua
kw.normalize_identifier(" 2 bad-name ") --> "_2_bad_name"
```

### Predicates

<a id="fn-isidentifier"></a>

#### `isidentifier(v)`

Return `true` when `v` is a valid non-keyword Lua identifier.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isIdentifier` (`boolean`): Whether the check succeeds.

**Example**:

```lua
kw.isidentifier("hello_world") --> true
kw.isidentifier("local")       --> false
```

<a id="fn-iskeyword"></a>

#### `iskeyword(v)`

Return `true` when `v` is a reserved Lua keyword.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isKeyword` (`boolean`): Whether the check succeeds.

**Example**:

```lua
kw.iskeyword("function") --> true
kw.iskeyword("hello")    --> false
```
