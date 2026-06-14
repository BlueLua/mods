---
title: "stringify"
description: "Render Lua values as readable source-like text."
---

Render Lua values as readable source-like text.

## Usage

```lua
local stringify = require("mods").stringify

local t = { "first", name = "Ada"}

print(stringify(t))
--> {
-->   "first",
-->   name = "Ada"
--> }
```

<a id="fn-stringify"></a>

## `stringify(value, opts?)`

Render Lua values as readable source-like text.

**Parameters**:

- `value` (`any`): Lua value to render.
- `opts?`
  (`{omit_array_keys?:boolean, indent?:string, newline?:string, replacer?:fun(k,v):(result:any)}`):
  Rendering options.

**Return**:

- `out` (`string`): Readable string representation.

**Example**:

```lua
local stringify = require("mods").stringify

local t = {
  "first",
  "second",
  name = "Ada",
  ok = true,
  nested = { value = 42 },
}

print(stringify(t))
--> {
-->   "first",
-->   "second",
-->   name = "Ada",
-->   nested = {
-->     value = 42
-->   },
-->   ok = true
--> }
```

### Key formatting

Strings are quoted and reserved keys use bracket notation.

```lua
print(stringify({ name = "Ada", ["with space"] = true }))
--> {
-->   ["with space"] = true,
-->   name = "Ada"
--> }
```

### Cycle rendering

Circular references render as `<cycle>`.

```lua
local t = {}
t.self = t

print(stringify(t))
--> {
-->   self = <cycle>
--> }
```

## Options

### `omit_array_keys`

Contiguous positive integer keys render as implicit array entries by default.
Set `omit_array_keys = false` to keep them explicit.

```lua
print(stringify({ "first", nil, "third" }, { omit_array_keys = false }))
--> {
-->   [1] = "first",
-->   [3] = "third"
--> }
```

### `indent`

`indent` controls the repeated indentation prefix. It defaults to two spaces.

```lua
print(stringify({ a = { b = true } }, { indent = ".." }))
--> {
-->   a = {
-->     b = true
-->   }
--> }
```

### `newline`

`newline` controls the line separator. Use `newline = ""` for inline output.

```lua
print(stringify({ a = 1, b = 2 }, { newline = "" }))
--> {a=1,b=2}
```

### `replacer`

`replacer` can transform or remove values before they are rendered.

```lua
local function replacer(k, v)
  if k == "secret" then
    return nil
  end
  return v
end

print(stringify({ name = "Ada", secret = "hidden" }, { replacer = replacer }))
--> {
-->   name = "Ada"
--> }
```
