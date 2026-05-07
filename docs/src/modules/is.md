---
description: "Type predicates for Lua values and filesystem path types."
---

# `is`

Type predicates for Lua values and filesystem path types.

## Usage

```lua
is = require "mods.is"

ok = is.number(3.14)       --> true
ok = is("hello", "string") --> true
ok = is.table({})          --> true
```

> [!NOTE]
>
> Function names are case-insensitive.
>
> ```lua
> is.table({})  --> true
> is.Table({})  --> true
> is.tAbLe({})  --> true
> ```

> [!IMPORTANT]
>
> Path checks require **LuaFileSystem**
> ([`lfs`](https://github.com/lunarmodules/luafilesystem)) and raise an error if
> it is not installed.

## `is()`

`is` is also callable as `is(value, type)` to check if a value is of a given
type.

```lua
is("hello", "string") --> true
is("hello", "String") --> true
is("hello", "STRING") --> true
```

## Functions

**Path Checks**:

| Function                  | Description                                                  |
| ------------------------- | ------------------------------------------------------------ |
| [`block(v)`](#fn-block)   | Returns `true` when `v` is a block device path.              |
| [`char(v)`](#fn-char)     | Returns `true` when `v` is a character device path.          |
| [`device(v)`](#fn-device) | Returns `true` when `v` is a block or character device path. |
| [`dir(v)`](#fn-dir)       | Returns `true` when `v` is a directory path.                 |
| [`fifo(v)`](#fn-fifo)     | Returns `true` when `v` is a FIFO path.                      |
| [`file(v)`](#fn-file)     | Returns `true` when `v` is a file path.                      |
| [`link(v)`](#fn-link)     | Returns `true` when `v` is a symlink path.                   |
| [`path(v)`](#fn-path)     | Returns `true` when `v` is a valid filesystem path.          |
| [`socket(v)`](#fn-socket) | Returns `true` when `v` is a socket path.                    |

**Type Checks**:

| Function                      | Description                            |
| ----------------------------- | -------------------------------------- |
| [`boolean(v)`](#fn-boolean)   | Returns `true` when `v` is a boolean.  |
| [`function(v)`](#fn-function) | Returns `true` when `v` is a function. |
| [`nil(v)`](#fn-nil)           | Returns `true` when `v` is `nil`.      |
| [`number(v)`](#fn-number)     | Returns `true` when `v` is a number.   |
| [`string(v)`](#fn-string)     | Returns `true` when `v` is a string.   |
| [`table(v)`](#fn-table)       | Returns `true` when `v` is a table.    |
| [`thread(v)`](#fn-thread)     | Returns `true` when `v` is a thread.   |
| [`userdata(v)`](#fn-userdata) | Returns `true` when `v` is userdata.   |

**Value Checks**:

| Function                      | Description                                 |
| ----------------------------- | ------------------------------------------- |
| [`callable(v)`](#fn-callable) | Returns `true` when `v` is callable.        |
| [`false(v)`](#fn-false)       | Returns `true` when `v` is exactly `false`. |
| [`falsy(v)`](#fn-falsy)       | Returns `true` when `v` is falsy.           |
| [`integer(v)`](#fn-integer)   | Returns `true` when `v` is an integer.      |
| [`true(v)`](#fn-true)         | Returns `true` when `v` is exactly `true`.  |
| [`truthy(v)`](#fn-truthy)     | Returns `true` when `v` is truthy.          |

### Path Checks

<a id="fn-block"></a>

#### `block(v)`

Returns `true` when `v` is a block device path.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isBlock` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.block("/dev/sda")
```

<a id="fn-char"></a>

#### `char(v)`

Returns `true` when `v` is a character device path.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isChar` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.char("/dev/null")
```

<a id="fn-device"></a>

#### `device(v)`

Returns `true` when `v` is a block or character device path.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isDevice` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.device("/dev/null")
```

<a id="fn-dir"></a>

#### `dir(v)`

Returns `true` when `v` is a directory path.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isDir` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.dir("/tmp")
```

<a id="fn-fifo"></a>

#### `fifo(v)`

Returns `true` when `v` is a FIFO path.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isFifo` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.fifo("/path/to/fifo")
```

<a id="fn-file"></a>

#### `file(v)`

Returns `true` when `v` is a file path.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isFile` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.file("README.md")
```

<a id="fn-link"></a>

#### `link(v)`

Returns `true` when `v` is a symlink path.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isLink` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.link("/path/to/link")
```

<a id="fn-path"></a>

#### `path(v)`

Returns `true` when `v` is a valid filesystem path.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isPath` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.path("README.md")
```

> [!NOTE]
>
> Returns `true` for broken symlinks.

<a id="fn-socket"></a>

#### `socket(v)`

Returns `true` when `v` is a socket path.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isSocket` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.socket("/path/to/socket")
```

### Type Checks

<a id="fn-boolean"></a>

#### `boolean(v)`

Returns `true` when `v` is a boolean.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isBoolean` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.boolean(true)
```

<a id="fn-function"></a>

#### `function(v)`

Returns `true` when `v` is a function.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isFunction` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.Function(function() end)
```

<a id="fn-nil"></a>

#### `nil(v)`

Returns `true` when `v` is `nil`.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isNil` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.Nil(nil)
```

<a id="fn-number"></a>

#### `number(v)`

Returns `true` when `v` is a number.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isNumber` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.number(3.14)
```

<a id="fn-string"></a>

#### `string(v)`

Returns `true` when `v` is a string.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isString` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.string("hello")
```

<a id="fn-table"></a>

#### `table(v)`

Returns `true` when `v` is a table.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isTable` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.table({})
```

<a id="fn-thread"></a>

#### `thread(v)`

Returns `true` when `v` is a thread.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isThread` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.thread(coroutine.create(function() end))
```

<a id="fn-userdata"></a>

#### `userdata(v)`

Returns `true` when `v` is userdata.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isUserdata` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.userdata(io.stdout)
```

### Value Checks

<a id="fn-callable"></a>

#### `callable(v)`

Returns `true` when `v` is callable.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isCallable` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.callable(function() end)
```

<a id="fn-false"></a>

#### `false(v)`

Returns `true` when `v` is exactly `false`.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isFalse` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.False(false)
```

<a id="fn-falsy"></a>

#### `falsy(v)`

Returns `true` when `v` is falsy.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isFalsy` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.falsy(false)
```

<a id="fn-integer"></a>

#### `integer(v)`

Returns `true` when `v` is an integer.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isInteger` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.integer(42)
```

<a id="fn-true"></a>

#### `true(v)`

Returns `true` when `v` is exactly `true`.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isTrue` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.True(true)
```

<a id="fn-truthy"></a>

#### `truthy(v)`

Returns `true` when `v` is truthy.

**Parameters**:

- `v` (`any`): Value to validate.

**Return**:

- `isTruthy` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.truthy("non-empty")
```
