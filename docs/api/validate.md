---
title: "validate"
description: "Validation helpers for Lua values and filesystem path types."
---

Validation helpers for Lua values and filesystem path types.

## Usage

```lua
local validate = mods.validate

ok, err = validate.number("nope") --> false, "number expected, got string"
ok, err = validate(123, "number") --> true, nil
```

## `validate()`

`validate(v, validator)` dispatches to the registered validator. If `validator`
is omitted, it defaults to `"truthy"`.

```lua
validate()         --> false, "truthy value expected, got no value"
validate(1)        --> true, nil
validate(1, "nil") --> false, "nil expected, got number"
```

> [!IMPORTANT]
>
> Path checks require **LuaFileSystem** ([`lfs`]) and raise an error if it is
> not installed.

## Validator Names

Validator names are case-insensitive for field access.

```lua
validate.number(1) --> true, nil
validate.NumBer(1) --> true, nil
```

`validator` in `validate(v, validator)` is matched as-is (case-sensitive):

```lua
validate(1, "number") --> true, nil
validate(1, "NuMbEr") --> false, "NuMbEr expected, got number"
```

## Custom Messages

Validator functions accept an optional template override as the second argument:
<code v-pre>validate.number(v, "need {{expected}}, got {{got}}")`</code>.

You can also set `validate.messages.<name>` to define default templates per
validator.

```lua
validate.string(123, "want {{expected}}, got {{got}}")
--> false, "want string, got number"
```

## Fields

### `messages` (`modsValidatorMessages`) {#messages}

Custom error-message templates for validator failures.

Set `validate.messages.<name>`, where `<name>` is a validator name (for example:
`number`, `truthy`, `file`).

The error-message template is used only when validation fails and an error
message is returned.

```lua
validate.messages.number = "need {{expected}}, got {{got}}"
ok, err = validate.number("x") --> false, "need number, got string"
```

**Placeholders**:

- <code v-pre>{{expected}}</code>: The check target (for example `number`,
  `string`, `truthy`).
- <code v-pre>{{got}}</code>: The detected failure kind (usually a Lua type;
  path validators use `invalid path`).
- <code v-pre>{{value}}</code>: The passed value, formatted for display (strings
  are quoted).

> [!NOTE]
>
> When the passed value is `nil`, rendered value text uses `no value`.
>
> ```lua
> validate.messages.truthy = "{{expected}} value expected, got {{value}}"
> validate.truthy(nil) --> false, "truthy value expected, got no value"
> ```

**Default Messages**:

- Type checks: <code v-pre>{{expected}} expected, got {{got}}</code>
- Value checks: <code v-pre>{{expected}} value expected, got {{value}}</code>
- Path checks: <code v-pre>{{value}} is not a valid {{expected}} path</code>
  (for `path`: <code v-pre>{{value}} is not a valid path</code>)

> [!NOTE]
>
> For path checks, if the value is not a `string`, the message falls back to
> `messages.string` (as if `validate.string` was called).

## Functions

**Path Checks**:

| Function            | Description                                                                                             |
| ------------------- | ------------------------------------------------------------------------------------------------------- |
| [`block(v, msg?)`]  | Returns `true` when `v` is a block device path. Otherwise returns `false` and an error message.         |
| [`char(v, msg?)`]   | Returns `true` when `v` is a char device path. Otherwise returns `false` and an error message.          |
| [`device(v, msg?)`] | Returns `true` when `v` is a block or char device path. Otherwise returns `false` and an error message. |
| [`dir(v, msg?)`]    | Returns `true` when `v` is a directory path. Otherwise returns `false` and an error message.            |
| [`fifo(v, msg?)`]   | Returns `true` when `v` is a FIFO path. Otherwise returns `false` and an error message.                 |
| [`file(v, msg?)`]   | Returns `true` when `v` is a file path. Otherwise returns `false` and an error message.                 |
| [`link(v, msg?)`]   | Returns `true` when `v` is a symlink path. Otherwise returns `false` and an error message.              |
| [`path(v, msg?)`]   | Returns `true` when `v` is a valid filesystem path. Otherwise returns `false` and an error message.     |
| [`socket(v, msg?)`] | Returns `true` when `v` is a socket path. Otherwise returns `false` and an error message.               |

**Registration**:

| Function                                 | Description                                        |
| ---------------------------------------- | -------------------------------------------------- |
| [`register(name, validator, template?)`] | Register or override a validator function by name. |

**Type Checks**:

| Function              | Description                                                                                  |
| --------------------- | -------------------------------------------------------------------------------------------- |
| [`boolean(v, msg?)`]  | Returns `true` when `v` is a boolean. Otherwise returns `false` and an error message.        |
| [`function(v, msg?)`] | Returns `true` when `v` is a function. Otherwise returns `false` and an error message.       |
| [`nil(v, msg?)`]      | Returns `true` when `v` is `nil`. Otherwise returns `false` and an error message.            |
| [`number(v, msg?)`]   | Returns `true` when `v` is a number. Otherwise returns `false` and an error message.         |
| [`string(v, msg?)`]   | Returns `true` when `v` is a string. Otherwise returns `false` and an error message.         |
| [`table(v, msg?)`]    | Returns `true` when `v` is a table. Otherwise returns `false` and an error message.          |
| [`thread(v, msg?)`]   | Returns `true` when `v` is a thread. Otherwise returns `false` and an error message.         |
| [`userdata(v, msg?)`] | Returns `true` when `v` is a userdata value. Otherwise returns `false` and an error message. |

**Value Checks**:

| Function              | Description                                                                                 |
| --------------------- | ------------------------------------------------------------------------------------------- |
| [`callable(v, msg?)`] | Returns `true` when `v` is callable. Otherwise returns `false` and an error message.        |
| [`false(v, msg?)`]    | Returns `true` when `v` is exactly `false`. Otherwise returns `false` and an error message. |
| [`falsy(v, msg?)`]    | Returns `true` when `v` is falsy. Otherwise returns `false` and an error message.           |
| [`integer(v, msg?)`]  | Returns `true` when `v` is an integer. Otherwise returns `false` and an error message.      |
| [`true(v, msg?)`]     | Returns `true` when `v` is exactly `true`. Otherwise returns `false` and an error message.  |
| [`truthy(v, msg?)`]   | Returns `true` when `v` is truthy. Otherwise returns `false` and an error message.          |

### Path Checks

#### `block(v, msg?)` {#block}

Returns `true` when `v` is a block device path. Otherwise returns `false` and an
error message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.block(".")
```

---

#### `char(v, msg?)` {#char}

Returns `true` when `v` is a char device path. Otherwise returns `false` and an
error message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.char(".")
```

---

#### `device(v, msg?)` {#device}

Returns `true` when `v` is a block or char device path. Otherwise returns
`false` and an error message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.device(".")
```

---

#### `dir(v, msg?)` {#dir}

Returns `true` when `v` is a directory path. Otherwise returns `false` and an
error message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.dir(".")
```

---

#### `fifo(v, msg?)` {#fifo}

Returns `true` when `v` is a FIFO path. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.fifo(".")
```

---

#### `file(v, msg?)` {#file}

Returns `true` when `v` is a file path. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.file(".")
```

---

#### `link(v, msg?)` {#link}

Returns `true` when `v` is a symlink path. Otherwise returns `false` and an
error message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.link(".")
```

---

#### `path(v, msg?)` {#path}

Returns `true` when `v` is a valid filesystem path. Otherwise returns `false`
and an error message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.path("README.md")
```

---

#### `socket(v, msg?)` {#socket}

Returns `true` when `v` is a socket path. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.socket(".")
```

---

### Registration

#### `register(name, validator, template?)` {#register}

Register or override a validator function by name.

**Parameters**:

- `name` (`string`): Validator name.
- `validator` (`fun(v:any):(ok:boolean)`): Validator function.
- `template?` (`string`): Optional default message template.

**Returns**:

- `none` (`nil`)

**Example**:

```lua
validate.register("odd", function(v)
  return type(v) == "number" and v % 2 == 1
end, "{{value}} does not satisfy {{expected}}")

ok, err = validate.odd(3)     --> true, nil
ok, err = validate.odd("x")   --> false, '"x" does not satisfy odd'
ok, err = validate(2, "odd")  --> false, "2 does not satisfy odd"
```

> [!NOTE]
>
> - If `template` is provided, it becomes the default message template for that
>   validator.
> - If `template` is omitted, failures use:
>   `{{expected}} expected, got {{got}}`.

---

### Type Checks

#### `boolean(v, msg?)` {#boolean}

Returns `true` when `v` is a boolean. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.boolean(true) --> true, nil
ok, err = validate.boolean(1)    --> false, "boolean expected, got number"
```

---

#### `function(v, msg?)` {#function}

Returns `true` when `v` is a function. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.Function(function() end) --> true, nil
ok, err = validate.Function(1)
--> false, "function expected, got number"
```

---

#### `nil(v, msg?)` {#nil}

Returns `true` when `v` is `nil`. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.Nil(nil) --> true, nil
ok, err = validate.Nil(0)   --> false, "nil expected, got number"
```

---

#### `number(v, msg?)` {#number}

Returns `true` when `v` is a number. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.number(42)  --> true, nil
ok, err = validate.number("x") --> false, "number expected, got string"
```

---

#### `string(v, msg?)` {#string}

Returns `true` when `v` is a string. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.string("hello") --> true, nil
ok, err = validate.string(1)       --> false, "string expected, got number"
```

---

#### `table(v, msg?)` {#table}

Returns `true` when `v` is a table. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.table({}) --> true, nil
ok, err = validate.table(1)  --> false, "table expected, got number"
```

---

#### `thread(v, msg?)` {#thread}

Returns `true` when `v` is a thread. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
co = coroutine.create(function() end)
ok, err = validate.thread(co) --> true, nil
ok, err = validate.thread(1)  --> false, "thread expected, got number"
```

---

#### `userdata(v, msg?)` {#userdata}

Returns `true` when `v` is a userdata value. Otherwise returns `false` and an
error message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.userdata(io.stdout) --> true, nil
ok, err = validate.userdata(1)         --> false, "userdata expected, got number"
```

---

### Value Checks

#### `callable(v, msg?)` {#callable}

Returns `true` when `v` is callable. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.callable(type) --> true, nil
ok, err = validate.callable(1)    --> false, "callable value expected, got 1"
```

---

#### `false(v, msg?)` {#false}

Returns `true` when `v` is exactly `false`. Otherwise returns `false` and an
error message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.False(false) --> true, nil
ok, err = validate.False(true)  --> false, "false value expected, got true"
```

---

#### `falsy(v, msg?)` {#falsy}

Returns `true` when `v` is falsy. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.falsy(false) --> true, nil
ok, err = validate.falsy(1)     --> false, "falsy value expected, got 1"
```

---

#### `integer(v, msg?)` {#integer}

Returns `true` when `v` is an integer. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.integer(1)   --> true, nil
ok, err = validate.integer(1.5) --> false, "integer value expected, got 1.5"
```

---

#### `true(v, msg?)` {#true}

Returns `true` when `v` is exactly `true`. Otherwise returns `false` and an
error message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.True(true)  --> true, nil
ok, err = validate.True(false) --> false, "true value expected, got false"
```

---

#### `truthy(v, msg?)` {#truthy}

Returns `true` when `v` is truthy. Otherwise returns `false` and an error
message.

**Parameters**:

- `v` (`any`): Value to validate.
- `msg?` (`string`): Optional override template.

**Returns**:

- `isValid` (`boolean`): Whether the check succeeds.
- `err?` (`string`): Error message when the check fails.

**Example**:

```lua
ok, err = validate.truthy(1)     --> true, nil
ok, err = validate.truthy(false) --> false, "truthy value expected, got false"
```

<!-- prettier-ignore-start -->
[`block(v, msg?)`]: #block
[`boolean(v, msg?)`]: #boolean
[`callable(v, msg?)`]: #callable
[`char(v, msg?)`]: #char
[`device(v, msg?)`]: #device
[`dir(v, msg?)`]: #dir
[`false(v, msg?)`]: #false
[`falsy(v, msg?)`]: #falsy
[`fifo(v, msg?)`]: #fifo
[`file(v, msg?)`]: #file
[`function(v, msg?)`]: #function
[`integer(v, msg?)`]: #integer
[`lfs`]: https://github.com/lunarmodules/luafilesystem
[`link(v, msg?)`]: #link
[`nil(v, msg?)`]: #nil
[`number(v, msg?)`]: #number
[`path(v, msg?)`]: #path
[`register(name, validator, template?)`]: #register
[`socket(v, msg?)`]: #socket
[`string(v, msg?)`]: #string
[`table(v, msg?)`]: #table
[`thread(v, msg?)`]: #thread
[`true(v, msg?)`]: #true
[`truthy(v, msg?)`]: #truthy
[`userdata(v, msg?)`]: #userdata
<!-- prettier-ignore-end -->
