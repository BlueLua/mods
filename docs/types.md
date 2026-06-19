---
title: "Types"
description: "Types defined in the mods module."
---

Types defined in the mods module.

## [`mods.CalendarMonth`](https://github.com/BlueLua/mods/blob/main/types/calendar.d.lua#L12-L25)

| Value | Description |
| ----- | ----------- |
| `1`   | January     |
| `2`   | February    |
| `3`   | March       |
| `4`   | April       |
| `5`   | May         |
| `6`   | June        |
| `7`   | July        |
| `8`   | August      |
| `9`   | September   |
| `10`  | October     |
| `11`  | November    |
| `12`  | December    |

## [`mods.CalendarWeekday`](https://github.com/BlueLua/mods/blob/main/types/calendar.d.lua#L3-L11)

| Value | Description |
| ----- | ----------- |
| `1`   | Monday      |
| `2`   | Tuesday     |
| `3`   | Wednesday   |
| `4`   | Thursday    |
| `5`   | Friday      |
| `6`   | Saturday    |
| `7`   | Sunday      |

## [`mods.dateMod`](https://github.com/BlueLua/mods/blob/main/types/date.d.lua#L6-L62)

Timezone-naive date helpers and immutable date values.

## Usage

```lua
local Date = require "mods.date"

local a = Date("2026-03-30T14:45:06")
local b = Date("2026-03-30 14:45:06.123")
local c = Date("2026-03-31")
local d = Date("12-25-1995", "MM-DD-YYYY")
local e = Date({ year = 2026, month = 3, day = 30, hour = 14, min = 45 })
local f = Date({ year = 2026 })

print(a)                               --> 2026-03-30 14:45:06
print(b.ms)                            --> 123
print(a:format("YYYY/MM/DD HH:mm:ss")) --> 2026/03/30 14:45:06
print(a:is_before(c))                  --> true
print(a < c)                           --> true
print(d)                               --> 1995-12-25 00:00:00
print(e.sec)                           --> 0
print(f)                               --> 2026-01-01 00:00:00
```

> [!NOTE]
>
> - String inputs accept [ISO 8601] forms, variants using a space instead of
>   `T`, and custom formats via `Date(input, pattern)`:
>
>   ```lua
>   Date("2026-03-30T14:45:06")
>   Date("2026-03-30 14:45:06")
>   Date("12/25/1995", "MM/DD/YYYY")
>   ```
>
> - When `input` is a number, it is treated as Unix milliseconds. Use
>   [`Date.unix(ts)`] if you have a timestamp in seconds.
>
>   ```lua
>   local a = Date(1745155206123)       -- Milliseconds
>   local b = Date.unix(1745155206.123) -- Seconds
>   print(a == b)                      --> true
>   ```
>
> - When calling `Date` without arguments, it uses [mstime] for millisecond
>   precision if installed; otherwise it falls back to [`os.time`].

| Field      | Type                 | Optional | Description        |
| ---------- | -------------------- | -------- | ------------------ |
| `duration` | [`mods.durationMod`] | No       |
| `private`  | `__call`             | No       | fun(...):mods.Date |

## [`mods.DateParts`](https://github.com/BlueLua/mods/blob/main/types/date.d.lua#L3-L5)

| Field   | Type      | Optional |
| ------- | --------- | -------- |
| `day`   | `integer` | Yes      |
| `hour`  | `integer` | Yes      |
| `isdst` | `boolean` | Yes      |
| `min`   | `integer` | Yes      |
| `month` | `integer` | Yes      |
| `ms`    | `integer` | Yes      |
| `sec`   | `integer` | Yes      |
| `wday`  | `integer` | Yes      |
| `yday`  | `integer` | Yes      |
| `year`  | `integer` | No       |

## [`mods.DateUnit`](https://github.com/BlueLua/mods/blob/main/types/date.d.lua#L3-L5)

&nbsp;`"d"` &nbsp;`"day"` &nbsp;`"days"` &nbsp;`"h"` &nbsp;`"hour"`
&nbsp;`"hours"` &nbsp;`"M"` &nbsp;`"m"` &nbsp;`"millisecond"`
&nbsp;`"milliseconds"` &nbsp;`"min"` &nbsp;`"mins"` &nbsp;`"minute"`
&nbsp;`"minutes"` &nbsp;`"month"` &nbsp;`"months"` &nbsp;`"ms"` &nbsp;`"q"`
&nbsp;`"quarter"` &nbsp;`"quarters"` &nbsp;`"s"` &nbsp;`"sec"` &nbsp;`"second"`
&nbsp;`"seconds"` &nbsp;`"secs"` &nbsp;`"w"` &nbsp;`"week"` &nbsp;`"weeks"`
&nbsp;`"y"` &nbsp;`"year"` &nbsp;`"years"`

## [`mods.DurationHumanizeOptions`](https://github.com/BlueLua/mods/blob/main/types/duration.d.lua#L6-L12)

| Field         | Type                               | Optional | Description                                             |
| ------------- | ---------------------------------- | -------- | ------------------------------------------------------- |
| `max_unit`    | [`mods.DateUnit`]                  | Yes      | Largest unit allowed when choosing the displayed unit.  |
| `min_unit`    | [`mods.DateUnit`]                  | Yes      | Smallest unit allowed when choosing the displayed unit. |
| `round`       | [`mods.DurationHumanizeRoundMode`] | Yes      | Rounding mode for custom unit output.                   |
| `short`       | `boolean`                          | Yes      | Whether to use abbreviated unit labels like `2h`.       |
| `with_suffix` | `boolean`                          | Yes      | Whether to include `ago` / `in` style wording.          |

## [`mods.DurationHumanizeRoundMode`](https://github.com/BlueLua/mods/blob/main/types/duration.d.lua#L3-L5)

&nbsp;`"ceil"` &nbsp;`"floor"` &nbsp;`"round"` &nbsp;`boolean`

## [`mods.DurationParts`](https://github.com/BlueLua/mods/blob/main/types/duration.d.lua#L3-L5)

| Field          | Type     | Optional |
| -------------- | -------- | -------- |
| `days`         | `number` | Yes      |
| `hours`        | `number` | Yes      |
| `milliseconds` | `number` | Yes      |
| `minutes`      | `number` | Yes      |
| `months`       | `number` | Yes      |
| `quarters`     | `number` | Yes      |
| `seconds`      | `number` | Yes      |
| `weeks`        | `number` | Yes      |
| `years`        | `number` | Yes      |

## [`mods.FsEntryType`](https://github.com/BlueLua/mods/blob/main/types/fs.d.lua#L3-L12)

| Value         | Description                           |
| ------------- | ------------------------------------- |
| `"block"`     | A block device.                       |
| `"char"`      | A character device.                   |
| `"directory"` | A directory.                          |
| `"fifo"`      | A named pipe (FIFO).                  |
| `"file"`      | A regular file.                       |
| `"link"`      | A symbolic link.                      |
| `"socket"`    | A socket.                             |
| `"unknown"`   | An unknown or unsupported entry type. |

## [`mods.GlobOptions`](https://github.com/BlueLua/mods/blob/main/types/glob.d.lua#L3-L4)

| Field        | Type      | Optional |
| ------------ | --------- | -------- |
| `follow`     | `boolean` | Yes      |
| `hidden`     | `boolean` | Yes      |
| `ignorecase` | `boolean` | Yes      |
| `recursive`  | `boolean` | Yes      |

## [`mods.log.levelno`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L13-L20)

| Name    | Value         |
| ------- | ------------- |
| `debug` | `10`          |
| `error` | `40`          |
| `info`  | `20`          |
| `off`   | `"math.huge"` |
| `warn`  | `30`          |

## [`mods.log.new.opts`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L30-L34)

| Field     | Type                | Optional | Description                                                                  |
| --------- | ------------------- | -------- | ---------------------------------------------------------------------------- |
| `handler` | [`mods.LogHandler`] | Yes      | Optional handler function that receives each emitted record.                 |
| `level`   | [`mods.LogLevel`]   | Yes      | Minimum enabled level; use `"off"` to disable logging. Defaults to `"warn"`. |
| `name`    | `string`            | Yes      | Optional logger name included in emitted records.                            |

## [`mods.log.record`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L22-L29)

| Field       | Type                         | Optional | Description                          |
| ----------- | ---------------------------- | -------- | ------------------------------------ |
| `args`      | `{[integer]:any, n:integer}` | No       | Original variadic arguments.         |
| `levelname` | [`mods.LogLevel`]            | No       | Log level name.                      |
| `levelno`   | `integer`                    | No       | Numeric severity used for filtering. |
| `line`      | `string`                     | No       | Formatted plain-text log line.       |
| `message`   | `string`                     | No       | Joined message string.               |

## [`mods.LogHandler`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L11-L12)

`fun(record: mods.log.record)`

## [`mods.LogLevel`](https://github.com/BlueLua/mods/blob/main/types/log.d.lua#L3-L10)

| Value     | Description                |
| --------- | -------------------------- |
| `"debug"` | Debug messages.            |
| `"error"` | Error messages.            |
| `"info"`  | Informational messages.    |
| `"off"`   | Logging disabled.          |
| `"warn"`  | Warning messages.          |
| `string`  | Any custom log level name. |

## [`mods.modsCalendarMonthday`](https://github.com/BlueLua/mods/blob/main/types/calendar.d.lua#L26-L58)

| Value | Description           |
| ----- | --------------------- |
| `1`   | 1st day of the month  |
| `2`   | 2nd day of the month  |
| `3`   | 3rd day of the month  |
| `4`   | 4th day of the month  |
| `5`   | 5th day of the month  |
| `6`   | 6th day of the month  |
| `7`   | 7th day of the month  |
| `8`   | 8th day of the month  |
| `9`   | 9th day of the month  |
| `10`  | 10th day of the month |
| `11`  | 11th day of the month |
| `12`  | 12th day of the month |
| `13`  | 13th day of the month |
| `14`  | 14th day of the month |
| `15`  | 15th day of the month |
| `16`  | 16th day of the month |
| `17`  | 17th day of the month |
| `18`  | 18th day of the month |
| `19`  | 19th day of the month |
| `20`  | 20th day of the month |
| `21`  | 21st day of the month |
| `22`  | 22nd day of the month |
| `23`  | 23rd day of the month |
| `24`  | 24th day of the month |
| `25`  | 25th day of the month |
| `26`  | 26th day of the month |
| `27`  | 27th day of the month |
| `28`  | 28th day of the month |
| `29`  | 29th day of the month |
| `30`  | 30th day of the month |
| `31`  | 31st day of the month |

## [`mods.ValidatorName`](https://github.com/BlueLua/mods/blob/main/types/is.d.lua#L6-L24)

| Value        | Description                                               |
| ------------ | --------------------------------------------------------- |
| `"block"`    | A block device path.                                      |
| `"callable"` | A function or table with a `__call` metamethod.           |
| `"char"`     | A character device path.                                  |
| `"device"`   | A character or block device path.                         |
| `"dir"`      | A directory path.                                         |
| `"false"`    | The boolean value false.                                  |
| `"falsy"`    | A falsy value (nil or false).                             |
| `"fifo"`     | A named pipe (FIFO) path.                                 |
| `"file"`     | A regular file path.                                      |
| `"integer"`  | An integer number.                                        |
| `"link"`     | A symbolic link path.                                     |
| `"path"`     | Any existing path or symbolic link.                       |
| `"socket"`   | A socket path.                                            |
| `"true"`     | The boolean value true.                                   |
| `"truthy"`   | A truthy value (not nil and not false).                   |
| `string`     | Any validator name.                                       |
| `type`       | Any standard Lua type name (e.g., `"table"`, `"number"`). |

## [`modsValidatorMessages`](https://github.com/BlueLua/mods/blob/main/types/validate.d.lua#L3-L31)

| Field      | Type     | Optional |
| ---------- | -------- | -------- |
| `[string]` | `string` | No       |
| `block`    | `string` | Yes      |
| `boolean`  | `string` | Yes      |
| `callable` | `string` | Yes      |
| `char`     | `string` | Yes      |
| `device`   | `string` | Yes      |
| `dir`      | `string` | Yes      |
| `false`    | `string` | Yes      |
| `falsy`    | `string` | Yes      |
| `fifo`     | `string` | Yes      |
| `file`     | `string` | Yes      |
| `function` | `string` | Yes      |
| `integer`  | `string` | Yes      |
| `link`     | `string` | Yes      |
| `nil`      | `string` | Yes      |
| `number`   | `string` | Yes      |
| `path`     | `string` | Yes      |
| `socket`   | `string` | Yes      |
| `string`   | `string` | Yes      |
| `table`    | `string` | Yes      |
| `thread`   | `string` | Yes      |
| `true`     | `string` | Yes      |
| `truthy`   | `string` | Yes      |
| `userdata` | `string` | Yes      |

<!-- prettier-ignore-start -->
[ISO 8601]: https://en.wikipedia.org/wiki/ISO_8601
[`Date.unix(ts)`]: #fn-unix
[`mods.DateUnit`]: /mods/types#mods-dateunit
[`mods.DurationHumanizeRoundMode`]: /mods/types#mods-durationhumanizeroundmode
[`mods.LogHandler`]: /mods/types#mods-loghandler
[`mods.LogLevel`]: /mods/types#mods-loglevel
[`mods.durationMod`]: /mods/types#mods-durationmod
[`os.time`]: https://www.lua.org/manual/5.1/manual.html#pdf-os.time
[mstime]: https://github.com/luamod/mstime
<!-- prettier-ignore-end -->
