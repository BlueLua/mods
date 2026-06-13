---
description: "JSON encoding and decoding helpers."
---

# `json`

JSON encoding and decoding helpers.

> [!NOTE]
>
> This module aims to implement strict
> [RFC 8259](https://www.rfc-editor.org/rfc/rfc8259) JSON behavior.

## Usage

```lua
local json = require "mods.json"

local encoded = json.encode({ ok = true, value = 42 })
local decoded = json.decode(encoded)

print(encoded)       --> {"ok":true,"value":42}
print(decoded.ok)    --> true
print(decoded.value) --> 42
```

## Behavior

- booleans, strings, and finite numbers map directly to JSON values

```lua
print(json.encode(true)) --> true
print(json.encode("hi")) --> "hi"
print(json.encode(12.5)) --> 12.5
```

- `json.null` encodes to `null`, and decoded `null` becomes `json.null`

```lua
local value = json.decode('{"a":null}')
print(value.a == json.null)   --> true
print(json.encode(json.null)) --> null
```

- tables encode as arrays or objects based on their keys

```lua
print(json.encode({}))           --> []
print(json.encode({ "a", "b" })) --> ["a","b"]
print(json.encode({ a = 1 }))    --> {"a":1}
```

- standalone JSON values like booleans, strings, and numbers are valid

```lua
print(json.decode("true"))   --> true
print(json.decode('"text"')) --> text
print(json.decode("42"))     --> 42
```

- encoding rejects unsupported Lua types, cyclic tables, mixed tables, sparse
  arrays, `NaN`, and infinities

```lua
local t = {}
t.self = t

assert(json.encode(function() end))
--> unsupported type: function

assert(json.encode(t))
--> cannot encode cyclic table

assert(json.encode({ [1] = "a", b = true }))
--> cannot encode mixed table

assert(json.encode({ [1] = "a", [3] = "c" }))
--> cannot encode sparse array

assert(json.encode(0 / 0))
--> cannot encode NaN

assert(json.encode(math.huge))
--> cannot encode infinity
```

- decoding rejects comments, trailing commas, single-quoted strings, and invalid
  escapes

```lua
assert(json.decode('{"a":1,}'))
--> expected string key at line 1, column 8

assert(json.decode('{"a":1}// comment'))
--> unexpected trailing content at line 1, column 8

assert(json.decode("{'a':1}"))
--> expected string key at line 1, column 2

assert(json.decode('["\\x"]'))
--> invalid escape sequence at line 1, column 3
```

## Functions

<a id="fn-decode"></a>

### `decode(s)`

Decode a JSON string into Lua values.

**Parameters**:

- `s` (`string`): JSON string.

**Return**:

- `value` (`any`): Decoded Lua value.
- `err` (`string?`): Error message when decoding fails.

**Example**:

```lua
local value = json.decode('{"user":"Ada","active":true,"note":null}')
print(value.user)              --> Ada
print(value.active)            --> true
print(value.note == json.null) --> true
```

<a id="fn-encode"></a>

### `encode(value, opts?)`

Encode a Lua value as JSON.

**Parameters**:

- `value` (`any`): Lua value to encode.
- `opts?` (`{sort_keys?:boolean, indent?:string}`): Encoding options.

**Return**:

- `json` (`string?`): JSON string.
- `err` (`string?`): Error message when encoding fails.

**Example**:

```lua
local s = json.encode({
  ok = true,
  items = { 1, 2, 3 },
}, {
  indent = "  ",
})

print(s)
-- {
--   "ok": true,
--   "items": [
--     1,
--     2,
--     3
--   ]
-- }
```
