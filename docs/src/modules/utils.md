---
description: "Shared utility helpers used across the Mods library."
---

# `utils`

Shared utility helpers used across the Mods library.

## Usage

```lua
utils = require "mods.utils"

print(utils.quote('hello "world"')) --> 'hello "world"'
```

## Functions

**Formatting**:

| Function                        | Description                                                    |
| ------------------------------- | -------------------------------------------------------------- |
| [`args_repr(v)`](#fn-args-repr) | Format a list-like table as a comma-separated argument string. |
| [`keypath(...)`](#fn-keypath)   | Format a key chain as a Lua-like table access path.            |
| [`quote(v)`](#fn-quote)         | Smart-quote a string for readable Lua-like output.             |

**Lazy Loading**:

| Function                                     | Description                       |
| -------------------------------------------- | --------------------------------- |
| [`lazy_module(name, err?)`](#fn-lazy-module) | Return a lazy proxy for a module. |

**Validation**:

| Function                                                            | Description                                                                                        |
| ------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| [`assert_arg(argn, v, validator?, optional?, lv?)`](#fn-assert-arg) | Assert argument value using [`mods.validate`](/modules/validate) and raise a Lua error on failure. |
| [`validate(name, v, validator?, optional?, msg?)`](#fn-validate)    | Validate a value using [`mods.validate`](/modules/validate) and raise a Lua error on failure.      |
| [`validate(path, v, validator?, optional?, msg?)`](#fn-validate)    | Validate a value using [`mods.validate`](/modules/validate) and raise a Lua error on failure.      |

### Formatting

<a id="fn-args-repr"></a>

#### `args_repr(v)`

Format a list-like table as a comma-separated argument string.

**Parameters**:

- `v` (`any`): Value to format. `nil` returns an empty string.

**Return**:

- `out` (`string`): Argument list string.

**Example**:

```lua
utils.args_repr({ "a", 1, true }) --> '"a", 1, true'
```

> [!NOTE]
>
> Requires [`inspect`](https://github.com/kikito/inspect.lua)

<a id="fn-keypath"></a>

#### `keypath(...)`

Format a key chain as a Lua-like table access path.

**Parameters**:

- `...` (`any`): Additional arguments.

**Return**:

- `path` (`string`): Rendered key path.

**Example**:

```lua
p1 = utils.keypath("t", "a", "b", "c")        --> "t.a.b.c"
p2 = utils.keypath("ctx", "users", 1, "name") --> "ctx.users[1].name"
p3 = utils.keypath("ctx", "invalid-key")      --> 'ctx["invalid-key"]'
p4 = utils.keypath()                          --> ""
```

<a id="fn-quote"></a>

#### `quote(v)`

Smart-quote a string for readable Lua-like output.

**Parameters**:

- `v` (`string`): String to quote.

**Return**:

- `out` (`string`): Quoted string.

**Example**:

```lua
print(utils.quote('He said "hi"')) -- 'He said "hi"'
print(utils.quote('say "hi" and \\'bye\\'')) -- "say \"hi\" and 'bye'"
```

### Lazy Loading

<a id="fn-lazy-module"></a>

#### `lazy_module(name, err?)`

Return a lazy proxy for a module.

The proxy rewrites its metamethods after first access while keeping the proxy
table itself free of cached fields.

**Parameters**:

- `name` (`string`): Module name passed to `require`.
- `err?` (`string`): Optional error message raised when loading fails.

**Return**:

- `module` (`{}`): Lazy proxy for the loaded module.

**Example**:

```lua
local fs = utils.lazy_module("mods.fs")
print(fs.exists("README.md"))

local repr = utils.lazy_module("mods.repr")
print(repr({ a = 1 }))
```

> [!NOTE]
>
> Supports both table-returning modules and function-returning modules.

### Validation

<a id="fn-assert-arg"></a>

#### `assert_arg(argn, v, validator?, optional?, lv?)`

Assert argument value using [`mods.validate`](/modules/validate) and raise a Lua
error on failure.

**Parameters**:

- `argn` (`integer`): Argument index for error context.
- `v` (`T`): Value to check.
- `validator?` (`modsValidatorName`): Validator name (defaults to `"truthy"`).
- `optional?` (`boolean`): Skip errors when `v` is `nil` (defaults to `false`).
- `lv?` (`integer`): Error level passed to `error` (defaults to `3`).

**Return**:

- `validatedValue` (`T`): Same input value on success, or `nil` when optional.

**Example**:

```lua
utils.assert_arg(1, "ok", "string") --> "ok"
utils.assert_arg(2, nil, "string", true) --> nil
utils.assert_arg(2, 123, "string")
--> raises: bad argument #2 (expected string, got number)
utils.assert_arg(3, "x", "number", false, "need {{expected}}, got {{got}}")
--> raises: bad argument #3 (need number, got string)
```

> [!NOTE]
>
> When the caller function name is available, error text includes
> `to '<function>'` (Lua-style bad argument context).

<a id="fn-validate"></a>

#### `validate(name, v, validator?, optional?, msg?)`

Validate a value using [`mods.validate`](/modules/validate) and raise a Lua
error on failure.

**Parameters**:

- `name` (`string`): Name for the error prefix.
- `v` (`any`): Value to validate.
- `validator?` (`modsValidatorName`): Validator name (defaults to `"truthy"`).
- `optional?` (`boolean`): Skip errors when `v` is `nil` (defaults to `false`).
- `msg?` (`string`): Optional override template passed to
  [`mods.validate`](/modules/validate).

**Return**:

- `none` (`nil`)

**Example**:

```lua
utils.validate("path", "ok", "string")
utils.validate("name", nil, "string", true)
utils.validate("count", "x", "number")
--> raises: count: expected number, got string
```

<a id="fn-validate"></a>

#### `validate(path, v, validator?, optional?, msg?)`

Validate a value using [`mods.validate`](/modules/validate) and raise a Lua
error on failure.

**Parameters**:

- `path` (`table`): Path parts for the error name.
- `v` (`any`): Value to validate.
- `validator?` (`modsValidatorName`): Validator name (defaults to `"truthy"`).
- `optional?` (`boolean`): Skip errors when `v` is `nil` (defaults to `false`).
- `msg?` (`string`): Optional override template passed to
  [`mods.validate`](/modules/validate).

**Return**:

- `none` (`nil`)

**Example**:

```lua
utils.validate({ "ctx", "users", 1, "name" }, nil, "string", true)
utils.validate({ "ctx", "users", 1, "name" }, 123, "string")
--> raises: ctx.users[1].name: expected string, got number
```

> [!NOTE]
>
> On failure, `path` is rendered with
> [`mods.utils.keypath`](/modules/utils#fn-keypath).
