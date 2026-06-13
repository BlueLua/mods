---
description:
  "Reusable immutable duration values for date arithmetic and formatting."
---

# `duration`

Reusable immutable duration values for date arithmetic and formatting.

## Usage

```lua
local Duration = require "mods.duration"

local shift = Duration({ day = 2, hour = 3 })
print(shift:format("D [days] HH:mm")) --> 2 days 03:00
```

## Functions

| Function                                | Description                                                                                              |
| --------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| [`is_duration(value)`](#fn-is-duration) | Return `true` when the value is a duration created by `mods.duration(...)` or `mods.date.duration(...)`. |
| [`new(input, unit?)`](#fn-new)          | Create a duration from a numeric amount and unit.                                                        |
| [`new(input?)`](#fn-new)                | Create a duration from numeric parts, an ISO 8601 string, or another duration.                           |

**Duration**:

| Function                                                      | Description                                                               |
| ------------------------------------------------------------- | ------------------------------------------------------------------------- |
| [`add(value, unit?)`](#fn-add)                                | Return a new duration with another duration or unit amount added.         |
| [`as(unit)`](#fn-as)                                          | Return the duration expressed in the requested unit.                      |
| [`clone()`](#fn-clone)                                        | Return a shallow copy of the duration value.                              |
| [`compare(other)`](#fn-compare)                               | Compare this duration to another duration-like value.                     |
| [`equals(other)`](#fn-equals)                                 | Return `true` when both duration values have identical components.        |
| [`format(pattern)`](#fn-format)                               | Format the duration using duration tokens like `Y`, `MM`, `DD`, and `HH`. |
| [`humanize(with_suffix_or_options?, options?)`](#fn-humanize) | Return a human-readable relative-style phrase for the duration.           |
| [`normalize()`](#fn-normalize)                                | Return a compacted duration using the module's canonical carry rules.     |
| [`subtract(value, unit?)`](#fn-subtract)                      | Return a new duration with another duration or unit amount subtracted.    |
| [`to_iso()`](#fn-to-iso)                                      | Return an ISO 8601 duration string.                                       |
| [`tostring()`](#fn-tostring)                                  | Return a debug-friendly string representation of the duration.            |

**Metamethods**:

| Function                           | Description                                                                    |
| ---------------------------------- | ------------------------------------------------------------------------------ |
| [`__call(input, unit?)`](#fn-call) | Create a duration from a numeric amount and unit.                              |
| [`__call(input?)`](#fn-call)       | Create a duration from numeric parts, an ISO 8601 string, or another duration. |
| [`__eq(duration)`](#fn-eq)         | Return `true` when both duration values have identical components.             |
| [`__tostring()`](#fn-tostring)     | Return the same result as `tostring()` when coerced to a string.               |

<a id="fn-is-duration"></a>

### `is_duration(value)`

Return `true` when the value is a duration created by `mods.duration(...)` or
`mods.date.duration(...)`.

**Parameters**:

- `value` (`any`)

**Return**:

- `isDuration` (`boolean`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration.is_duration(Duration({ day = 2 }))) --> true
print(Duration.is_duration({ day = 2 })) --> false
```

<a id="fn-new"></a>

### `new(input, unit?)`

Create a duration from a numeric amount and unit.

**Parameters**:

- `input` (`number`): Numeric amount to convert into a duration.
- `unit?` (`mods.DateUnit`): Unit used with the numeric amount. Defaults to
  `"ms"`.

**Return**:

- `duration` (`mods.Duration`)

**Example**:

```lua
local d = Duration(90, "minute")
```

<a id="fn-new"></a>

### `new(input?)`

Create a duration from numeric parts, an ISO 8601 string, or another duration.

**Parameters**:

- `input?` (`string|mods.DurationParts|mods.Duration`): Duration parts, an ISO
  8601 string, or another duration.

**Return**:

- `duration` (`mods.Duration`)

**Example**:

```lua
local a = Duration({ day = 2, hour = 3 })
local b = Duration("PT1H30M")
```

### Duration

<a id="fn-add"></a>

#### `add(value, unit?)`

Return a new duration with another duration or unit amount added.

**Parameters**:

- `value` (`number|mods.DurationParts|mods.Duration`): Signed amount to add, or
  another duration value.
- `unit?` (`mods.DateUnit`): Unit used when `value` is a number.

**Return**:

- `duration` (`mods.Duration`)

**Example**:

```lua
local Duration = require "mods.duration"
local a = Duration({ day = 2 })
local b = a:add(3, "hour")
print(b:format("D [days] HH:mm:ss")) --> 2 days 03:00:00
```

<a id="fn-as"></a>

#### `as(unit)`

Return the duration expressed in the requested unit.

**Parameters**:

- `unit` (`mods.DateUnit`)

**Return**:

- `amount` (`number`)

**Example**:

```lua
local Duration = require "mods.duration"
local d = Duration({ day = 1, hour = 12 })
print(d:as("hour")) --> 36
```

<a id="fn-clone"></a>

#### `clone()`

Return a shallow copy of the duration value.

**Return**:

- `duration` (`mods.Duration`)

**Example**:

```lua
local Duration = require "mods.duration"
local d = Duration({ month = 1, day = 2 })
local copy = d:clone()
print(copy == d, rawequal(copy, d)) --> true false
```

<a id="fn-compare"></a>

#### `compare(other)`

Compare this duration to another duration-like value.

Returns `-1` when smaller, `0` when equal, and `1` when larger.

**Parameters**:

- `other` (`number|string|mods.DurationParts|mods.Duration`)

**Return**:

- `ordering` (`integer`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ day = 1 }):compare({ hour = 24 })) --> 0
```

<a id="fn-equals"></a>

#### `equals(other)`

Return `true` when both duration values have identical components.

**Parameters**:

- `other` (`any`): Value to compare against.

**Return**:

- `isEqual` (`boolean`)

**Example**:

```lua
local Duration = require "mods.duration"
local a = Duration({ day = 2 })
local b = Duration({ day = 2 })
print(a:equals(b)) --> true
```

<a id="fn-format"></a>

#### `format(pattern)`

Format the duration using duration tokens like `Y`, `MM`, `DD`, and `HH`.

**Parameters**:

- `pattern` (`string`): Format pattern using supported duration tokens.

**Return**:

- `formatted` (`string`)

**Example**:

```lua
local Duration = require "mods.duration"
local d = Duration({ day = 2, hour = 3, minute = 4 })
print(d:format("D [days] HH:mm")) --> 2 days 03:04
```

<a id="fn-humanize"></a>

#### `humanize(with_suffix_or_options?, options?)`

Return a human-readable relative-style phrase for the duration.

By default this returns the bare phrase without `ago` / `in`. Pass `true` to
include relative wording. You can also pass an options table for abbreviated
output or explicit unit clamping.

**Parameters**:

- `with_suffix_or_options?` (`boolean|mods.DurationHumanizeOptions`): Whether to
  include `ago` / `in` style wording, or an options table.
- `options?` (`mods.DurationHumanizeOptions`): Additional options when the first
  argument is a boolean.

**Return**:

- `humanized` (`string`)

**Example**:

```lua
local Duration = require "mods.duration"
local d = Duration({ day = 3 })
print(d:humanize()) --> 3 days
print(d:humanize(true)) --> in 3 days
print(d:humanize({ short = true })) --> 3d
```

<a id="fn-normalize"></a>

#### `normalize()`

Return a compacted duration using the module's canonical carry rules.

**Return**:

- `duration` (`mods.Duration`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ minute = 90 }):normalize()) --> duration(hours=1, minutes=30)
```

<a id="fn-subtract"></a>

#### `subtract(value, unit?)`

Return a new duration with another duration or unit amount subtracted.

**Parameters**:

- `value` (`number|mods.DurationParts|mods.Duration`): Signed amount to
  subtract, or another duration value.
- `unit?` (`mods.DateUnit`): Unit used when `value` is a number.

**Return**:

- `duration` (`mods.Duration`)

**Example**:

```lua
local Duration = require "mods.duration"
local a = Duration({ day = 2, hour = 3 })
local b = a:subtract(3, "hour")
print(b:format("D [days] HH:mm:ss")) --> 2 days 00:00:00
```

<a id="fn-to-iso"></a>

#### `to_iso()`

Return an ISO 8601 duration string.

**Return**:

- `iso` (`string`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ hour = 1, minute = 30 }):to_iso()) --> PT1H30M
```

<a id="fn-tostring"></a>

#### `tostring()`

Return a debug-friendly string representation of the duration.

**Return**:

- `s` (`string`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ day = 2, hour = 3 })) --> duration(days=2, hours=3)
```

### Metamethods

<a id="fn-call"></a>

#### `__call(input, unit?)`

Create a duration from a numeric amount and unit.

**Parameters**:

- `input` (`number`): Numeric amount to convert into a duration.
- `unit?` (`mods.DateUnit`): Unit used with the numeric amount. Defaults to
  `"ms"`.

**Return**:

- `duration` (`mods.Duration`)

**Example**:

```lua
local Duration = require "mods.duration"
local d = Duration(90, "minute")
```

<a id="fn-call"></a>

#### `__call(input?)`

Create a duration from numeric parts, an ISO 8601 string, or another duration.

**Parameters**:

- `input?` (`string|mods.DurationParts|mods.Duration`): Duration parts, an ISO
  8601 string, or another duration.

**Return**:

- `duration` (`mods.Duration`)

**Example**:

```lua
local Duration = require "mods.duration"
local a = Duration({ day = 2, hour = 3 })
local b = Duration("PT1H30M")
```

<a id="fn-eq"></a>

#### `__eq(duration)`

Return `true` when both duration values have identical components.

**Parameters**:

- `duration` (`mods.Duration`): Duration to compare against.

**Return**:

- `isEqual` (`boolean`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ day = 2 }) == Duration({ day = 2 })) --> true
```

<a id="fn-tostring"></a>

#### `__tostring()`

Return the same result as `tostring()` when coerced to a string.

**Return**:

- `s` (`string`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ day = 2 })) --> duration(days=2)
```
