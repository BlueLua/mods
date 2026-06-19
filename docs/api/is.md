---
title: "is"
description: "Type predicates for Lua values and filesystem path types."
---

Type predicates for Lua values and filesystem path types.

## Usage

```lua
is = mods.is

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

<!-- markdownlint-disable MD028 -->

> [!IMPORTANT]
>
> Path checks require **LuaFileSystem** ([`lfs`]) and raise an error if it is
> not installed.

<!-- markdownlint-enable MD028 -->

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

| Function      | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| [`block(v)`]  | Returns `true` when `v` is a block device path.              |
| [`char(v)`]   | Returns `true` when `v` is a character device path.          |
| [`device(v)`] | Returns `true` when `v` is a block or character device path. |
| [`dir(v)`]    | Returns `true` when `v` is a directory path.                 |
| [`fifo(v)`]   | Returns `true` when `v` is a FIFO path.                      |
| [`file(v)`]   | Returns `true` when `v` is a file path.                      |
| [`link(v)`]   | Returns `true` when `v` is a symlink path.                   |
| [`path(v)`]   | Returns `true` when `v` is a valid filesystem path.          |
| [`socket(v)`] | Returns `true` when `v` is a socket path.                    |

**Type Checks**:

| Function        | Description                            |
| --------------- | -------------------------------------- |
| [`boolean(v)`]  | Returns `true` when `v` is a boolean.  |
| [`function(v)`] | Returns `true` when `v` is a function. |
| [`nil(v)`]      | Returns `true` when `v` is `nil`.      |
| [`number(v)`]   | Returns `true` when `v` is a number.   |
| [`string(v)`]   | Returns `true` when `v` is a string.   |
| [`table(v)`]    | Returns `true` when `v` is a table.    |
| [`thread(v)`]   | Returns `true` when `v` is a thread.   |
| [`userdata(v)`] | Returns `true` when `v` is userdata.   |

**Value Checks**:

| Function        | Description                                 |
| --------------- | ------------------------------------------- |
| [`callable(v)`] | Returns `true` when `v` is callable.        |
| [`false(v)`]    | Returns `true` when `v` is exactly `false`. |
| [`falsy(v)`]    | Returns `true` when `v` is falsy.           |
| [`integer(v)`]  | Returns `true` when `v` is an integer.      |
| [`true(v)`]     | Returns `true` when `v` is exactly `true`.  |
| [`truthy(v)`]   | Returns `true` when `v` is truthy.          |

### Path Checks

#### `block(v)` {#block}

Returns `true` when `v` is a block device path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isBlock` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.block("/dev/sda")
```

---

#### `char(v)` {#char}

Returns `true` when `v` is a character device path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isChar` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.char("/dev/null")
```

---

#### `device(v)` {#device}

Returns `true` when `v` is a block or character device path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isDevice` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.device("/dev/null")
```

---

#### `dir(v)` {#dir}

Returns `true` when `v` is a directory path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isDir` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.dir("/tmp")
```

---

#### `fifo(v)` {#fifo}

Returns `true` when `v` is a FIFO path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFifo` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.fifo("/path/to/fifo")
```

---

#### `file(v)` {#file}

Returns `true` when `v` is a file path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFile` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.file("README.md")
```

---

#### `link(v)` {#link}

Returns `true` when `v` is a symlink path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isLink` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.link("/path/to/link")
```

---

#### `path(v)` {#path}

Returns `true` when `v` is a valid filesystem path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isPath` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.path("README.md")
```

> [!NOTE]
>
> Returns `true` for broken symlinks.

---

#### `socket(v)` {#socket}

Returns `true` when `v` is a socket path.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isSocket` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.socket("/path/to/socket")
```

---

### Type Checks

#### `boolean(v)` {#boolean}

Returns `true` when `v` is a boolean.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isBoolean` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.boolean(true)
```

---

#### `function(v)` {#function}

Returns `true` when `v` is a function.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFunction` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.Function(function() end)
```

---

#### `nil(v)` {#nil}

Returns `true` when `v` is `nil`.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isNil` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.Nil(nil)
```

---

#### `number(v)` {#number}

Returns `true` when `v` is a number.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isNumber` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.number(3.14)
```

---

#### `string(v)` {#string}

Returns `true` when `v` is a string.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isString` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.string("hello")
```

---

#### `table(v)` {#table}

Returns `true` when `v` is a table.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isTable` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.table({})
```

---

#### `thread(v)` {#thread}

Returns `true` when `v` is a thread.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isThread` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.thread(coroutine.create(function() end))
```

---

#### `userdata(v)` {#userdata}

Returns `true` when `v` is userdata.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isUserdata` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.userdata(io.stdout)
```

---

### Value Checks

#### `callable(v)` {#callable}

Returns `true` when `v` is callable.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isCallable` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.callable(function() end)
```

---

#### `false(v)` {#false}

Returns `true` when `v` is exactly `false`.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFalse` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.False(false)
```

---

#### `falsy(v)` {#falsy}

Returns `true` when `v` is falsy.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isFalsy` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.falsy(false)
```

---

#### `integer(v)` {#integer}

Returns `true` when `v` is an integer.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isInteger` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.integer(42)
```

---

#### `true(v)` {#true}

Returns `true` when `v` is exactly `true`.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isTrue` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.True(true)
```

---

#### `truthy(v)` {#truthy}

Returns `true` when `v` is truthy.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isTruthy` (`boolean`): Whether the check succeeds.

**Example**:

```lua
is.truthy("non-empty")
```

<!-- prettier-ignore-start -->
[`block(v)`]: #block
[`boolean(v)`]: #boolean
[`callable(v)`]: #callable
[`char(v)`]: #char
[`device(v)`]: #device
[`dir(v)`]: #dir
[`false(v)`]: #false
[`falsy(v)`]: #falsy
[`fifo(v)`]: #fifo
[`file(v)`]: #file
[`function(v)`]: #function
[`integer(v)`]: #integer
[`lfs`]: https://github.com/lunarmodules/luafilesystem
[`link(v)`]: #link
[`nil(v)`]: #nil
[`number(v)`]: #number
[`path(v)`]: #path
[`socket(v)`]: #socket
[`string(v)`]: #string
[`table(v)`]: #table
[`thread(v)`]: #thread
[`true(v)`]: #true
[`truthy(v)`]: #truthy
[`userdata(v)`]: #userdata
<!-- prettier-ignore-end -->
