---
title: "duration"
description:
  "Reusable immutable duration values for date arithmetic and formatting."
---

Reusable immutable duration values for date arithmetic and formatting.

## Usage

```lua
local Duration = require "mods.duration"

local shift = Duration({ day = 2, hour = 3 })
print(shift:format("D [days] HH:mm")) --> 2 days 03:00
```

## Functions

| Function               | Description                                                                                                  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------ |
| [`new(input, unit?)`]  | Create a duration from a numeric amount and unit.                                                            |
| [`new(input?)`]        | Create a duration from numeric parts, an ISO 8601 string, or another duration.                               |
| [`is_duration(value)`] | Return `true` when the value is a duration created by [`mods.duration(...)`] or [`mods.date.duration(...)`]. |

**Duration**:

| Function                                        | Description                                                               |
| ----------------------------------------------- | ------------------------------------------------------------------------- |
| [`add(value, unit?)`]                           | Return a new duration with another duration or unit amount added.         |
| [`as(unit)`]                                    | Return the duration expressed in the requested unit.                      |
| [`clone()`]                                     | Return a shallow copy of the duration value.                              |
| [`compare(other)`]                              | Compare this duration to another duration-like value.                     |
| [`equals(other)`]                               | Return `true` when both duration values have identical components.        |
| [`format(pattern)`]                             | Format the duration using duration tokens like `Y`, `MM`, `DD`, and `HH`. |
| [`humanize(with_suffix_or_options?, options?)`] | Return a human-readable relative-style phrase for the duration.           |
| [`normalize()`]                                 | Return a compacted duration using the module's canonical carry rules.     |
| [`subtract(value, unit?)`]                      | Return a new duration with another duration or unit amount subtracted.    |
| [`to_iso()`]                                    | Return an ISO 8601 duration string.                                       |
| [`tostring()`]                                  | Return a debug-friendly string representation of the duration.            |

**Metamethods**:

| Function                 | Description                                                                    |
| ------------------------ | ------------------------------------------------------------------------------ |
| [`__call(input, unit?)`] | Create a duration from a numeric amount and unit.                              |
| [`__call(input?)`]       | Create a duration from numeric parts, an ISO 8601 string, or another duration. |
| [`__eq(duration)`]       | Return `true` when both duration values have identical components.             |
| [`__tostring()`]         | Return the same result as `tostring()` when coerced to a string.               |

### `new(input, unit?)` {#new-1}

Create a duration from a numeric amount and unit.

**Parameters**:

- `input` (`number`): Numeric amount to convert into a duration.
- `unit?` ([`mods.DateUnit`]): Unit used with the numeric amount. Defaults to
  `"ms"`.

**Returns**:

- `duration` ([`mods.Duration`])

**Example**:

```lua
local d = Duration(90, "minute")
```

---

### `new(input?)` {#new}

Create a duration from numeric parts, an ISO 8601 string, or another duration.

**Parameters**:

- `input?` (`string` | [`mods.DurationParts`] | [`mods.Duration`]): Duration
  parts, an ISO 8601 string, or another duration.

**Returns**:

- `duration` ([`mods.Duration`])

**Example**:

```lua
local a = Duration({ day = 2, hour = 3 })
local b = Duration("PT1H30M")
```

---

### `is_duration(value)` {#is-duration}

Return `true` when the value is a duration created by [`mods.duration(...)`] or
[`mods.date.duration(...)`].

**Parameters**:

- `value` (`any`)

**Returns**:

- `isDuration` (`boolean`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration.is_duration(Duration({ day = 2 }))) --> true
print(Duration.is_duration({ day = 2 })) --> false
```

---

### Duration

#### `add(value, unit?)` {#add}

Return a new duration with another duration or unit amount added.

**Parameters**:

- `value` (`number` | [`mods.DurationParts`] | [`mods.Duration`]): Signed amount
  to add, or another duration value.
- `unit?` ([`mods.DateUnit`]): Unit used when `value` is a number.

**Returns**:

- `duration` ([`mods.Duration`])

**Example**:

```lua
local Duration = require "mods.duration"
local a = Duration({ day = 2 })
local b = a:add(3, "hour")
print(b:format("D [days] HH:mm:ss")) --> 2 days 03:00:00
```

---

#### `as(unit)` {#as}

Return the duration expressed in the requested unit.

**Parameters**:

- `unit` ([`mods.DateUnit`])

**Returns**:

- `amount` (`number`)

**Example**:

```lua
local Duration = require "mods.duration"
local d = Duration({ day = 1, hour = 12 })
print(d:as("hour")) --> 36
```

---

#### `clone()` {#clone}

Return a shallow copy of the duration value.

**Returns**:

- `duration` ([`mods.Duration`])

**Example**:

```lua
local Duration = require "mods.duration"
local d = Duration({ month = 1, day = 2 })
local copy = d:clone()
print(copy == d, rawequal(copy, d)) --> true false
```

---

#### `compare(other)` {#compare}

Compare this duration to another duration-like value.

Returns `-1` when smaller, `0` when equal, and `1` when larger.

**Parameters**:

- `other` (`number` | `string` | [`mods.DurationParts`] | [`mods.Duration`])

**Returns**:

- `ordering` (`integer`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ day = 1 }):compare({ hour = 24 })) --> 0
```

---

#### `equals(other)` {#equals}

Return `true` when both duration values have identical components.

**Parameters**:

- `other` (`any`): Value to compare against.

**Returns**:

- `isEqual` (`boolean`)

**Example**:

```lua
local Duration = require "mods.duration"
local a = Duration({ day = 2 })
local b = Duration({ day = 2 })
print(a:equals(b)) --> true
```

---

#### `format(pattern)` {#format}

Format the duration using duration tokens like `Y`, `MM`, `DD`, and `HH`.

**Parameters**:

- `pattern` (`string`): Format pattern using supported duration tokens.

**Returns**:

- `formatted` (`string`)

**Example**:

```lua
local Duration = require "mods.duration"
local d = Duration({ day = 2, hour = 3, minute = 4 })
print(d:format("D [days] HH:mm")) --> 2 days 03:04
```

---

#### `humanize(with_suffix_or_options?, options?)` {#humanize}

Return a human-readable relative-style phrase for the duration.

By default this returns the bare phrase without `ago` / `in`. Pass `true` to
include relative wording. You can also pass an options table for abbreviated
output or explicit unit clamping.

**Parameters**:

- `with_suffix_or_options?` (`boolean` | [`mods.DurationHumanizeOptions`]):
  Whether to include `ago` / `in` style wording, or an options table.
- `options?` ([`mods.DurationHumanizeOptions`]): Additional options when the
  first argument is a boolean.

**Returns**:

- `humanized` (`string`)

**Example**:

```lua
local Duration = require "mods.duration"
local d = Duration({ day = 3 })
print(d:humanize()) --> 3 days
print(d:humanize(true)) --> in 3 days
print(d:humanize({ short = true })) --> 3d
```

---

#### `normalize()` {#normalize}

Return a compacted duration using the module's canonical carry rules.

**Returns**:

- `duration` ([`mods.Duration`])

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ minute = 90 }):normalize()) --> duration(hours=1, minutes=30)
```

---

#### `subtract(value, unit?)` {#subtract}

Return a new duration with another duration or unit amount subtracted.

**Parameters**:

- `value` (`number` | [`mods.DurationParts`] | [`mods.Duration`]): Signed amount
  to subtract, or another duration value.
- `unit?` ([`mods.DateUnit`]): Unit used when `value` is a number.

**Returns**:

- `duration` ([`mods.Duration`])

**Example**:

```lua
local Duration = require "mods.duration"
local a = Duration({ day = 2, hour = 3 })
local b = a:subtract(3, "hour")
print(b:format("D [days] HH:mm:ss")) --> 2 days 00:00:00
```

---

#### `to_iso()` {#to-iso}

Return an ISO 8601 duration string.

**Returns**:

- `iso` (`string`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ hour = 1, minute = 30 }):to_iso()) --> PT1H30M
```

---

#### `tostring()` {#tostring}

Return a debug-friendly string representation of the duration.

**Returns**:

- `s` (`string`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ day = 2, hour = 3 })) --> duration(days=2, hours=3)
```

---

### Metamethods

#### `__call(input, unit?)` {#call-1}

Create a duration from a numeric amount and unit.

**Parameters**:

- `input` (`number`): Numeric amount to convert into a duration.
- `unit?` ([`mods.DateUnit`]): Unit used with the numeric amount. Defaults to
  `"ms"`.

**Returns**:

- `duration` ([`mods.Duration`])

**Example**:

```lua
local Duration = require "mods.duration"
local d = Duration(90, "minute")
```

---

#### `__call(input?)` {#call}

Create a duration from numeric parts, an ISO 8601 string, or another duration.

**Parameters**:

- `input?` (`string` | [`mods.DurationParts`] | [`mods.Duration`]): Duration
  parts, an ISO 8601 string, or another duration.

**Returns**:

- `duration` ([`mods.Duration`])

**Example**:

```lua
local Duration = require "mods.duration"
local a = Duration({ day = 2, hour = 3 })
local b = Duration("PT1H30M")
```

---

#### `__eq(duration)` {#eq}

Return `true` when both duration values have identical components.

**Parameters**:

- `duration` ([`mods.Duration`]): Duration to compare against.

**Returns**:

- `isEqual` (`boolean`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ day = 2 }) == Duration({ day = 2 })) --> true
```

---

#### `__tostring()` {#tostring-1}

Return the same result as `tostring()` when coerced to a string.

**Returns**:

- `s` (`string`)

**Example**:

```lua
local Duration = require "mods.duration"
print(Duration({ day = 2 })) --> duration(days=2)
```

<!-- prettier-ignore-start -->
[`__call(input, unit?)`]: #call-1
[`__call(input?)`]: #call
[`__eq(duration)`]: #eq
[`__tostring()`]: #tostring-1
[`add(value, unit?)`]: #add
[`as(unit)`]: #as
[`clone()`]: #clone
[`compare(other)`]: #compare
[`equals(other)`]: #equals
[`format(pattern)`]: #format
[`humanize(with_suffix_or_options?, options?)`]: #humanize
[`is_duration(value)`]: #is-duration
[`mods.DateUnit`]: /mods/types#mods-dateunit
[`mods.DurationHumanizeOptions`]: /mods/types#mods-durationhumanizeoptions
[`mods.DurationParts`]: /mods/types#mods-durationparts
[`mods.Duration`]: /mods/api/duration
[`mods.date.duration(...)`]: /mods/api/date#duration
[`mods.duration(...)`]: /mods/api/duration
[`new(input, unit?)`]: #new-1
[`new(input?)`]: #new
[`normalize()`]: #normalize
[`subtract(value, unit?)`]: #subtract
[`to_iso()`]: #to-iso
[`tostring()`]: #tostring
<!-- prettier-ignore-end -->
