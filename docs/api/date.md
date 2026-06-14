---
title: "date"
description: "Timezone-naive date helpers and immutable date values."
---

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
> - String inputs accept [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)
>   forms, variants using a space instead of `T`, and custom formats via
>   `Date(input, pattern)`:
>
>   ```lua
>   Date("2026-03-30T14:45:06")
>   Date("2026-03-30 14:45:06")
>   Date("12/25/1995", "MM/DD/YYYY")
>   ```
>
> - When `input` is a number, it is treated as Unix milliseconds. Use
>   [`Date.unix(ts)`](#fn-unix) if you have a timestamp in seconds.
>
>   ```lua
>   local a = Date(1745155206123)       -- Milliseconds
>   local b = Date.unix(1745155206.123) -- Seconds
>   print(a == b)                      --> true
>   ```
>
> - When calling `Date` without arguments, it uses
>   [mstime](https://github.com/luamod/mstime) for millisecond precision if
>   installed; otherwise it falls back to
>   [`os.time`](https://www.lua.org/manual/5.1/manual.html#pdf-os.time).

## Functions

| Function                          | Description                                                              |
| --------------------------------- | ------------------------------------------------------------------------ |
| [`new(input, pattern?)`](#fn-new) | Create a Date from a string using an optional pattern.                   |
| [`new(input?)`](#fn-new)          | Create a Date from a Unix timestamp (milliseconds) or a DateParts table. |

**Arithmetic**:

| Function                                  | Description                                                         |
| ----------------------------------------- | ------------------------------------------------------------------- |
| [`add(amount, unit?)`](#fn-add)           | Return a copy shifted by the given amount and unit.                 |
| [`diff(date, unit?)`](#fn-diff)           | Return the signed difference to another Date in the requested unit. |
| [`subtract(amount, unit?)`](#fn-subtract) | Return a copy shifted backward by the given amount and unit.        |

**Boundaries**:

| Function                       | Description                                   |
| ------------------------------ | --------------------------------------------- |
| [`endof(unit)`](#fn-endof)     | Return the end boundary for the given unit.   |
| [`startof(unit)`](#fn-startof) | Return the start boundary for the given unit. |

**Calendar**:

| Function                                              | Description                                                                 |
| ----------------------------------------------------- | --------------------------------------------------------------------------- |
| [`day_of_year(day_of_year_number?)`](#fn-day-of-year) | Return or set the day of the year.                                          |
| [`is_leap_year()`](#fn-is-leap-year)                  | Return `true` when the value's year is a leap year.                         |
| [`iso_week(iso_week_number?)`](#fn-iso-week)          | Return or set the ISO week-of-year number.                                  |
| [`iso_week_year()`](#fn-iso-week-year)                | Return the ISO week-year for the current date.                              |
| [`iso_weekday(iso_weekday_number?)`](#fn-iso-weekday) | Return or set the ISO weekday number where Monday is `1` and Sunday is `7`. |
| [`iso_weeks_in_year()`](#fn-iso-weeks-in-year)        | Return the number of ISO weeks in the current date's calendar year.         |
| [`month_days()`](#fn-month-days)                      | Return the number of days in the value's month.                             |
| [`quarter(quarter_number?)`](#fn-quarter)             | Return or set the quarter of the year.                                      |
| [`week(week_number?)`](#fn-week)                      | Return or set the non-ISO week-of-year number.                              |
| [`week_year()`](#fn-week-year)                        | Return the non-ISO week-year for the current date.                          |
| [`weekday(weekday_number?)`](#fn-weekday)             | Return or set the locale-relative weekday like Day.js `weekday()`.          |
| [`weeks_in_year()`](#fn-weeks-in-year)                | Return the number of weeks in the current locale week-year.                 |

**Compare**:

| Function                    | Description                                                 |
| --------------------------- | ----------------------------------------------------------- |
| [`max(...)`](#fn-max)       | Return the latest value from the given dates.               |
| [`min(...)`](#fn-min)       | Return the earliest value from the given dates.             |
| [`minmax(...)`](#fn-minmax) | Return the earliest and latest values from the given dates. |

**Comparison**:

| Function                                                         | Description                                                       |
| ---------------------------------------------------------------- | ----------------------------------------------------------------- |
| [`is_after(date)`](#fn-is-after)                                 | Return `true` when the value is later than `other`.               |
| [`is_before(date)`](#fn-is-before)                               | Return `true` when the value is earlier than `other`.             |
| [`is_between(start_date, end_date, inclusive?)`](#fn-is-between) | Return `true` when the value lies between two bounds.             |
| [`is_same(date)`](#fn-is-same)                                   | Return `true` when the value is equal to `other`.                 |
| [`is_same_or_after(date)`](#fn-is-same-or-after)                 | Return `true` when the value is later than or equal to `other`.   |
| [`is_same_or_before(date)`](#fn-is-same-or-before)               | Return `true` when the value is earlier than or equal to `other`. |
| [`is_today()`](#fn-is-today)                                     | Return `true` when the value falls on the current local day.      |
| [`is_tomorrow()`](#fn-is-tomorrow)                               | Return `true` when the value falls on the next local day.         |
| [`is_yesterday()`](#fn-is-yesterday)                             | Return `true` when the value falls on the previous local day.     |

**Duration**:

| Function                                | Description                                                                 |
| --------------------------------------- | --------------------------------------------------------------------------- |
| [`is_duration(value)`](#fn-is-duration) | Return `true` when the value is a duration created by `date.duration(...)`. |

**Formatting**:

| Function                        | Description                                                                                             |
| ------------------------------- | ------------------------------------------------------------------------------------------------------- |
| [`format(pattern)`](#fn-format) | Format the Date with tokens like `YYYY`, `MMM`, `dddd`, `Do`, `Q`, `hh`, `k`, `X`, `x`, `A`, and `SSS`. |
| [`tostring()`](#fn-tostring)    | Return the default string form `YYYY-MM-DD HH:mm:ss`.                                                   |

**Relative Time**:

| Function                                    | Description                                                    |
| ------------------------------------------- | -------------------------------------------------------------- |
| [`from(date, without_suffix?)`](#fn-from)   | Return relative time from another Date to this one.            |
| [`from_now(without_suffix?)`](#fn-from-now) | Return relative time from the current local time to this Date. |
| [`to(date, without_suffix?)`](#fn-to)       | Return relative time from this Date to another one.            |
| [`to_now(without_suffix?)`](#fn-to-now)     | Return relative time from this Date to the current local time. |

**Unix**:

| Function                      | Description                                                         |
| ----------------------------- | ------------------------------------------------------------------- |
| [`unix(timestamp)`](#fn-unix) | Create a Date from a Unix timestamp in whole or fractional seconds. |

**Validation**:

| Function                                     | Description                                                 |
| -------------------------------------------- | ----------------------------------------------------------- |
| [`is_valid(input?, pattern?)`](#fn-is-valid) | Return `true` when the input can be parsed as a valid Date. |

**Metamethods**:

| Function                       | Description                                                             |
| ------------------------------ | ----------------------------------------------------------------------- |
| [`__add(a, b)`](#fn-add)       | Return a copy shifted by integer milliseconds.                          |
| [`__eq(date)`](#fn-eq)         | Return `true` when both Date values have identical components.          |
| [`__le(date)`](#fn-le)         | Return `true` when the left Date is earlier than or equal to the right. |
| [`__lt(date)`](#fn-lt)         | Return `true` when the left Date is earlier than the right.             |
| [`__sub(a, b)`](#fn-sub)       | Return either a shifted copy or a millisecond delta.                    |
| [`__tostring()`](#fn-tostring) | Return the same result as `tostring()` when coerced to a string.        |

<a id="fn-new"></a>

### `new(input, pattern?)`

Create a Date from a string using an optional pattern.

**Parameters**:

- `input` (`string`): The date string to parse.
- `pattern?` (`string`): The format pattern.

**Return**:

- **value** (`mods.Date`)

**Example**:

```lua
local d1 = Date("2026-03-30")
local d2 = Date("12-25-1995", "MM-DD-YYYY")
```

<a id="fn-new"></a>

### `new(input?)`

Create a Date from a Unix timestamp (milliseconds) or a DateParts table.

**Parameters**:

- `input?` (`number|mods.DateParts`): Unix timestamp (ms) or table of date
  components.

**Return**:

- **value** (`mods.Date`)

**Example**:

```lua
local d1 = Date(1745155206123)
local d2 = Date({ year = 2026, month = 3 })
```

### Arithmetic

<a id="fn-add"></a>

#### `add(amount, unit?)`

Return a copy shifted by the given amount and unit.

**Parameters**:

- `amount` (`integer|mods.DateDurationParts`): Signed amount to add, or a
  duration-style table.
- `unit?`
  (`'ms'|'milliseconds'|'millisecond'|'s'|'secs'|'sec'|'seconds'|'second'|'m'|'mins'|'min'|'minutes'|'minute'|'h'|'hours'|'hour'|'d'|'days'|'day'|'w'|'weeks'|'week'|'M'|'months'|'month'|'q'|'quarters'|'quarter'|'y'|'years'|'year'`):
  Unit for the addition.

**Return**:

- `shifted` (`mods.Date`): Shifted date value.

**Example**:

```lua
local d = Date("2026-03-30T14:45:06")

print(d:add(2, "day"))               --> 2026-04-01 14:45:06
print(d:add(1, "quarter"))           --> 2026-06-30 14:45:06
print(d:add(1, "month"))             --> 2026-04-30 14:45:06
print(d:add(250, "ms"))              --> 2026-03-30 14:45:06.250
print(d:add({ month = 1, day = 2 })) --> 2026-05-02 14:45:06
```

<a id="fn-diff"></a>

#### `diff(date, unit?)`

Return the signed difference to another Date in the requested unit.

**Parameters**:

- `date` (`mods.Date`): Date to compare against.
- `unit?`
  (`'ms'|'milliseconds'|'millisecond'|'s'|'secs'|'sec'|'seconds'|'second'|'m'|'mins'|'min'|'minutes'|'minute'|'h'|'hours'|'hour'|'d'|'days'|'day'|'w'|'weeks'|'week'|'M'|'months'|'month'|'q'|'quarters'|'quarter'|'y'|'years'|'year'`):
  Unit used for the difference. Defaults to `"ms"`.

**Return**:

- `delta` (`integer`): Signed difference in whole units.

**Example**:

```lua
local a = Date("2026-03-30T12:00:00")
local b = Date("2026-02-28T12:00:00")
print(a:diff(b, "month")) --> 1
print(a:diff(b, "day"))   --> 30
```

<a id="fn-subtract"></a>

#### `subtract(amount, unit?)`

Return a copy shifted backward by the given amount and unit.

**Parameters**:

- `amount` (`integer|mods.DateDurationParts`): Signed amount to subtract, or a
  duration-style table.
- `unit?`
  (`'ms'|'milliseconds'|'millisecond'|'s'|'secs'|'sec'|'seconds'|'second'|'m'|'mins'|'min'|'minutes'|'minute'|'h'|'hours'|'hour'|'d'|'days'|'day'|'w'|'weeks'|'week'|'M'|'months'|'month'|'q'|'quarters'|'quarter'|'y'|'years'|'year'`):
  Unit for the subtraction.

**Return**:

- `shifted` (`mods.Date`): Shifted date value.

**Example**:

```lua
local d = Date("2026-03-30T14:45:06")
print(d:subtract(2, "day"))               --> 2026-03-28 14:45:06
print(d:subtract(1, "quarter"))           --> 2025-12-30 14:45:06
print(d:subtract(1, "month"))             --> 2026-02-28 14:45:06
print(d:subtract(250, "ms"))              --> 2026-03-30 14:45:05.750
print(d:subtract({ month = 1, day = 1 })) --> 2026-02-27 14:45:06
```

### Boundaries

<a id="fn-endof"></a>

#### `endof(unit)`

Return the end boundary for the given unit.

**Parameters**:

- `unit` (`mods.DateUnit|"isoWeek"`): Boundary unit.

**Return**:

- `bounded` (`mods.Date`): Date clamped to the end of the unit.

**Example**:

```lua
local d = Date("2026-03-30T14:45:06")
print(d:endof("month"))   --> 2026-03-31 23:59:59
print(d:endof("week"))    --> 2026-04-05 23:59:59
print(d:endof("isoWeek")) --> 2026-04-05 23:59:59
```

`"isoWeek"` is also supported here as a boundary-only unit.

<a id="fn-startof"></a>

#### `startof(unit)`

Return the start boundary for the given unit.

**Parameters**:

- `unit` (`mods.DateUnit|"isoWeek"`): Boundary unit.

**Return**:

- `bounded` (`mods.Date`): Date clamped to the start of the unit.

**Example**:

```lua
local d = Date("2026-03-30T14:45:06")
print(d:startof("day"))     --> 2026-03-30 00:00:00
print(d:startof("quarter")) --> 2026-01-01 00:00:00
print(d:startof("isoWeek")) --> 2026-03-30 00:00:00
```

`"isoWeek"` is also supported here as a boundary-only unit.

### Calendar

<a id="fn-day-of-year"></a>

#### `day_of_year(day_of_year_number?)`

Return or set the day of the year.

**Parameters**:

- `day_of_year_number?` (`integer`): Day-of-year to set.

**Return**:

- `dayOrDate` (`integer|mods.Date`): Current day-of-year number, or a shifted
  Date when `day_of_year_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:day_of_year())  --> 89
print(d:day_of_year(1)) --> 2026-01-01 00:00:00
```

<a id="fn-is-leap-year"></a>

#### `is_leap_year()`

Return `true` when the value's year is a leap year.

**Return**:

- `isLeapYear` (`boolean`): Whether the year is a leap year.

**Example**:

```lua
print(Date("2024-02-29"):is_leap_year()) --> true
```

<a id="fn-iso-week"></a>

#### `iso_week(iso_week_number?)`

Return or set the ISO week-of-year number.

**Parameters**:

- `iso_week_number?` (`integer`): ISO week number to set.

**Return**:

- `isoWeekOrDate` (`integer|mods.Date`): Current ISO week number, or a shifted
  Date when `iso_week_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:iso_week())   --> 14
print(d:iso_week(15)) --> 2026-04-06 00:00:00
```

<a id="fn-iso-week-year"></a>

#### `iso_week_year()`

Return the ISO week-year for the current date.

**Return**:

- `isoWeekYear` (`integer`): ISO week-year.

**Example**:

```lua
print(Date("2021-01-01"):iso_week_year()) --> 2020
```

<a id="fn-iso-weekday"></a>

#### `iso_weekday(iso_weekday_number?)`

Return or set the ISO weekday number where Monday is `1` and Sunday is `7`.

**Parameters**:

- `iso_weekday_number?` (`integer`): ISO weekday to set.

**Return**:

- `isoWeekdayOrDate` (`modsCalendarWeekday|mods.Date`): Current ISO weekday
  number, or a shifted Date when `iso_weekday_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:iso_weekday())  --> 1
print(d:iso_weekday(7)) --> 2026-04-05 00:00:00
```

<a id="fn-iso-weeks-in-year"></a>

#### `iso_weeks_in_year()`

Return the number of ISO weeks in the current date's calendar year.

**Return**:

- `isoWeeksInYear` (`integer`): Number of ISO weeks in the current date's
  calendar year.

**Example**:

```lua
local d = Date("2016-01-01")
print(Date("2016-01-01"):iso_weeks_in_year()) --> 52
print(Date("2016-06-01"):iso_weeks_in_year()) --> 52
```

<a id="fn-month-days"></a>

#### `month_days()`

Return the number of days in the value's month.

**Return**:

- `ndays` (`modsCalendarMonthday`): Number of days in the current month.

**Example**:

```lua
print(Date("2024-02-01"):month_days()) --> 29
```

<a id="fn-quarter"></a>

#### `quarter(quarter_number?)`

Return or set the quarter of the year.

**Parameters**:

- `quarter_number?` (`integer`): Quarter to set.

**Return**:

- `quarterOrDate` (`integer|mods.Date`): Current quarter number, or a shifted
  Date when `quarter_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:quarter())  --> 1
print(d:quarter(2)) --> 2026-06-30 00:00:00
```

<a id="fn-week"></a>

#### `week(week_number?)`

Return or set the non-ISO week-of-year number.

**Parameters**:

- `week_number?` (`integer`): Week number to set.

**Return**:

- `weekOrDate` (`integer|mods.Date`): Current week-of-year number, or a shifted
  Date when `week_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:week())   --> 14
print(d:week(15)) --> 2026-04-06 00:00:00
```

<a id="fn-week-year"></a>

#### `week_year()`

Return the non-ISO week-year for the current date.

**Return**:

- `weekYear` (`integer`): Week-year.

**Example**:

```lua
print(Date("2021-01-01"):week_year()) --> 2021
```

<a id="fn-weekday"></a>

#### `weekday(weekday_number?)`

Return or set the locale-relative weekday like Day.js `weekday()`.

**Parameters**:

- `weekday_number?` (`integer`): Locale-relative weekday to set.

**Return**:

- `weekdayOrDate` (`integer|mods.Date`): Current locale-relative weekday number,
  or a shifted Date when `weekday_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:weekday())   --> 0
print(d:weekday(7))  --> 2026-04-06 00:00:00
print(d:weekday(-7)) --> 2026-03-23 00:00:00
```

The getter returns a number in the range `0..6`, relative to the current
`mods.calendar.firstweekday`. Passing an integer returns a shifted copy in the
same locale-relative week space, with negative and overflow values moving into
previous or next weeks.

<a id="fn-weeks-in-year"></a>

#### `weeks_in_year()`

Return the number of weeks in the current locale week-year.

**Return**:

- `weeksInYear` (`integer`): Number of weeks.

**Example**:

```lua
print(Date("2026-03-30"):weeks_in_year()) --> 52
```

### Compare

<a id="fn-max"></a>

#### `max(...)`

Return the latest value from the given dates.

**Parameters**:

- `...` (`mods.Date|mods.Date[]`): Date values to compare. Each argument may be
  a date or a list of dates.

**Return**:

- `date` (`mods.Date`): Latest date value.

**Example**:

```lua
local a = Date("2026-03-30")
local b = Date("2026-03-31")
print(Date.max(a, b))     --> 2026-03-31 00:00:00
print(Date.max({ a, b })) --> 2026-03-31 00:00:00
```

<a id="fn-min"></a>

#### `min(...)`

Return the earliest value from the given dates.

**Parameters**:

- `...` (`mods.Date|mods.Date[]`): Date values to compare. Each argument may be
  a date or a list of dates.

**Return**:

- `date` (`mods.Date`): Earliest date value.

**Example**:

```lua
local a = Date("2026-03-30")
local b = Date("2026-03-28")
print(Date.min(a, b))     --> 2026-03-28 00:00:00
print(Date.min({ a, b })) --> 2026-03-28 00:00:00
```

<a id="fn-minmax"></a>

#### `minmax(...)`

Return the earliest and latest values from the given dates.

**Parameters**:

- `...` (`mods.Date|mods.Date[]`): Date values to compare. Each argument may be
  a date or a list of dates.

**Return**:

- `minDate` (`mods.Date`): Earliest date value.
- `maxDate` (`mods.Date`): Latest date value.

**Example**:

```lua
local a = Date("2026-03-30")
local b = Date("2026-03-28")
local c = Date("2026-03-31")
local min_date, max_date = Date.minmax(a, b, c)
print(min_date) --> 2026-03-28 00:00:00
print(max_date) --> 2026-03-31 00:00:00
```

### Comparison

<a id="fn-is-after"></a>

#### `is_after(date)`

Return `true` when the value is later than `other`.

**Parameters**:

- `date` (`mods.Date`): Date to compare against.

**Return**:

- `isAfter` (`boolean`): Whether the value is later than `date`.

**Example**:

```lua
local a = Date("2026-03-31T12:00:00")
local b = Date("2026-03-30T12:00:00")
print(a:is_after(b)) --> true
```

<a id="fn-is-before"></a>

#### `is_before(date)`

Return `true` when the value is earlier than `other`.

**Parameters**:

- `date` (`mods.Date`): Date to compare against.

**Return**:

- `isBefore` (`boolean`): Whether the value is earlier than `date`.

**Example**:

```lua
local a = Date("2026-03-30T12:00:00")
local b = Date("2026-03-31T12:00:00")
print(a:is_before(b)) --> true
```

<a id="fn-is-between"></a>

#### `is_between(start_date, end_date, inclusive?)`

Return `true` when the value lies between two bounds.

Bounds may be passed in either order. By default the comparison is exclusive;
pass `true` as the third argument to include the endpoints.

**Parameters**:

- `start_date` (`mods.Date`): One bound.
- `end_date` (`mods.Date`): The other bound.
- `inclusive?` (`boolean`): Whether to include the endpoints. Defaults to
  `false`.

**Return**:

- `isBetween` (`boolean`): Whether the value lies between the two bounds.

**Example**:

```lua
local d = Date("2026-03-30T12:00:00")
local a = Date("2026-03-30T00:00:00")
local b = Date("2026-03-31T00:00:00")
print(d:is_between(a, b))        --> true
print(a:is_between(a, b))        --> false
print(a:is_between(a, b, true))  --> true
```

<a id="fn-is-same"></a>

#### `is_same(date)`

Return `true` when the value is equal to `other`.

**Parameters**:

- `date` (`mods.Date`): Date to compare against.

**Return**:

- `isSame` (`boolean`): Whether the value is equal to `date`.

**Example**:

```lua
local a = Date("2026-03-30T12:00:00")
local b = Date("2026-03-30T12:00:00")
print(a:is_same(b)) --> true
```

<a id="fn-is-same-or-after"></a>

#### `is_same_or_after(date)`

Return `true` when the value is later than or equal to `other`.

**Parameters**:

- `date` (`mods.Date`): Date to compare against.

**Return**:

- `isSameOrAfter` (`boolean`): Whether the value is later than or equal to
  `date`.

**Example**:

```lua
local a = Date("2026-03-31T12:00:00")
local b = Date("2026-03-30T12:00:00")
local c = Date("2026-03-31T12:00:00")
print(a:is_same_or_after(b)) --> true
print(a:is_same_or_after(c)) --> true
```

<a id="fn-is-same-or-before"></a>

#### `is_same_or_before(date)`

Return `true` when the value is earlier than or equal to `other`.

**Parameters**:

- `date` (`mods.Date`): Date to compare against.

**Return**:

- `isSameOrBefore` (`boolean`): Whether the value is earlier than or equal to
  `date`.

**Example**:

```lua
local a = Date("2026-03-30T12:00:00")
local b = Date("2026-03-30T12:00:00")
local c = Date("2026-03-31T12:00:00")
print(a:is_same_or_before(b)) --> true
print(a:is_same_or_before(c)) --> true
```

<a id="fn-is-today"></a>

#### `is_today()`

Return `true` when the value falls on the current local day.

**Return**:

- `isToday` (`boolean`): Whether the value is on today in local time.

**Example**:

```lua
print(Date():is_today()) --> true
```

<a id="fn-is-tomorrow"></a>

#### `is_tomorrow()`

Return `true` when the value falls on the next local day.

**Return**:

- `isTomorrow` (`boolean`): Whether the value is on tomorrow in local time.

**Example**:

```lua
print(Date():add(1, "day"):is_tomorrow()) --> true
```

<a id="fn-is-yesterday"></a>

#### `is_yesterday()`

Return `true` when the value falls on the previous local day.

**Return**:

- `isYesterday` (`boolean`): Whether the value is on yesterday in local time.

**Example**:

```lua
print(Date():subtract(1, "day"):is_yesterday()) --> true
```

### Duration

<a id="fn-is-duration"></a>

#### `is_duration(value)`

Return `true` when the value is a duration created by `date.duration(...)`.

**Parameters**:

- `value` (`any`): Value to test.

**Return**:

- `isDuration` (`boolean`): Whether the value is a `mods.Duration`.

**Example**:

```lua
local shift = date.duration({ day = 2 })
print(date.is_duration(shift)) --> true
print(date.is_duration({ day = 2 })) --> false
```

### Formatting

<a id="fn-format"></a>

#### `format(pattern)`

Format the Date with tokens like `YYYY`, `MMM`, `dddd`, `Do`, `Q`, `hh`, `k`,
`X`, `x`, `A`, and `SSS`.

**Parameters**:

- `pattern` (`string`): Format pattern using supported tokens.

**Return**:

- `formatted` (`string`): Formatted datetime string.

**Example**:

```lua
local d = Date("2026-03-30T14:45:06.123")
local ts = Date(1523520536123)
print(d:format("YYYY/MM/DD HH:mm:ss.SSS")) --> 2026/03/30 14:45:06.123
print(d:format("ddd, MMM Do YYYY h:mm A")) --> Mon, Mar 30th 2026 2:45 PM
print(d:format("LLLL"))                    --> Monday, March 30, 2026 2:45 PM
print(d:format("GGGG-[W]WW"))              --> 2026-W14
print(ts:format("X x"))                    --> 1523520536 1523520536123
```

> [!NOTE]
>
> Wrap literal text in `[...]` to escape it, for example:
>
> ```lua
> d:format("GGGG-[W]WW") -- 2026-W14
> d:format("[hours:]HH") -- hours:14
> ```

**Supported tokens**:

| Token  | Example            | Meaning                            |
| ------ | ------------------ | ---------------------------------- |
| `YY`   | `26`               | 2-digit year                       |
| `YYYY` | `2026`             | 4-digit year                       |
| `Q`    | `1-4`              | Quarter                            |
| `Qo`   | `1st..4th`         | Ordinal quarter                    |
| `M`    | `1-12`             | Month                              |
| `MM`   | `03-12`            | Month, zero-padded                 |
| `MMM`  | `Jan-Dec`          | Short month name                   |
| `MMMM` | `January-December` | Full month name                    |
| `D`    | `1-31`             | Day of month                       |
| `DD`   | `01-31`            | Day of month, zero-padded          |
| `DDD`  | `1-366`            | Day of year                        |
| `DDDD` | `001-366`          | Day of year, zero-padded           |
| `d`    | `0-6`              | Weekday number where Sunday is `0` |
| `e`    | `0-6`              | Weekday number where Sunday is `0` |
| `E`    | `1-7`              | ISO weekday number                 |
| `dd`   | `Su-Sa`            | Minimal weekday name               |
| `ddd`  | `Sun-Sat`          | Short weekday name                 |
| `dddd` | `Sunday-Saturday`  | Full weekday name                  |
| `Do`   | `1st..31th`        | Ordinal day of month               |
| `H`    | `0-23`             | 24-hour                            |
| `HH`   | `00-23`            | 24-hour, zero-padded               |
| `h`    | `1-12`             | 12-hour                            |
| `hh`   | `01-12`            | 12-hour, zero-padded               |
| `k`    | `1-24`             | 1-24 hour                          |
| `kk`   | `01-24`            | 1-24 hour, zero-padded             |
| `m`    | `0-59`             | Minute                             |
| `mm`   | `00-59`            | Minute, zero-padded                |
| `s`    | `0-59`             | Second                             |
| `ss`   | `00-59`            | Second, zero-padded                |
| `S`    | `0-9`              | Hundreds digit of milliseconds     |
| `SS`   | `00-99`            | First two digits of milliseconds   |
| `SSS`  | `000-999`          | Millisecond, zero-padded           |
| `w`    | `1-53`             | Week of year                       |
| `ww`   | `01-53`            | Week of year, zero-padded          |
| `wo`   | `1st..53rd`        | Ordinal week of year               |
| `W`    | `1-53`             | ISO week of year                   |
| `WW`   | `01-53`            | ISO week of year, zero-padded      |
| `GG`   | `26`               | 2-digit ISO week-year              |
| `GGGG` | `2026`             | ISO week-year                      |
| `gggg` | `2026`             | Week-year                          |
| `a`    | `am pm`            | Meridiem lowercase                 |
| `A`    | `AM PM`            | Meridiem uppercase                 |
| `x`    | `1523520536123`    | Unix timestamp in milliseconds     |
| `X`    | `1523520536`       | Unix timestamp in seconds          |

English preset aliases:

| Alias  | Expands to                  |
| ------ | --------------------------- |
| `LT`   | `h:mm A`                    |
| `LTS`  | `h:mm:ss A`                 |
| `L`    | `MM/DD/YYYY`                |
| `LL`   | `MMMM D, YYYY`              |
| `LLL`  | `MMMM D, YYYY h:mm A`       |
| `LLLL` | `dddd, MMMM D, YYYY h:mm A` |
| `l`    | `M/D/YYYY`                  |
| `ll`   | `MMM D, YYYY`               |
| `lll`  | `MMM D, YYYY h:mm A`        |
| `llll` | `ddd, MMM D, YYYY h:mm A`   |

<a id="fn-tostring"></a>

#### `tostring()`

Return the default string form `YYYY-MM-DD HH:mm:ss`.

**Return**:

- `s` (`string`): Default datetime string.

**Example**:

```lua
print(Date("2026-03-30T14:45:06.123")) --> 2026-03-30 14:45:06.123
```

### Relative Time

<a id="fn-from"></a>

#### `from(date, without_suffix?)`

Return relative time from another Date to this one.

By default the result includes a suffix like `ago` or a prefix like `in`. Pass
`true` to omit that suffix or prefix.

**Parameters**:

- `date` (`mods.Date`): Reference date.
- `without_suffix?` (`boolean`): Whether to omit `ago` / `in`.

**Return**:

- `relative` (`string`): Relative time string.

**Example**:

```lua
local a = date("2026-03-30T14:45:06")
local b = date("2026-03-30T12:45:06")
print(a:from(b))       --> in 2 hours
print(a:from(b, true)) --> 2 hours
```

<a id="fn-from-now"></a>

#### `from_now(without_suffix?)`

Return relative time from the current local time to this Date.

**Parameters**:

- `without_suffix?` (`boolean`): Whether to omit `ago` / `in`.

**Return**:

- `relative` (`string`): Relative time string.

**Example**:

```lua
local d = date():add(1, "day")
print(d:from_now()) --> in a day
```

<a id="fn-to"></a>

#### `to(date, without_suffix?)`

Return relative time from this Date to another one.

By default the result includes a suffix like `ago` or a prefix like `in`. Pass
`true` to omit that suffix or prefix.

**Parameters**:

- `date` (`mods.Date`): Reference date.
- `without_suffix?` (`boolean`): Whether to omit `ago` / `in`.

**Return**:

- `relative` (`string`): Relative time string.

**Example**:

```lua
local a = date("2026-03-30T12:45:06")
local b = date("2026-03-30T14:45:06")
print(a:to(b))       --> in 2 hours
print(a:to(b, true)) --> 2 hours
```

<a id="fn-to-now"></a>

#### `to_now(without_suffix?)`

Return relative time from this Date to the current local time.

**Parameters**:

- `without_suffix?` (`boolean`): Whether to omit `ago` / `in`.

**Return**:

- `relative` (`string`): Relative time string.

**Example**:

```lua
local d = date():subtract(1, "day")
print(d:to_now()) --> in a day
```

### Unix

<a id="fn-unix"></a>

#### `unix(timestamp)`

Create a Date from a Unix timestamp in whole or fractional seconds.

**Parameters**:

- `timestamp` (`number`): Unix timestamp in whole or fractional seconds.

**Return**:

- `date` (`mods.Date`): Date value for the given Unix timestamp.

**Example**:

```lua
print(Date.unix(1318781876))          --> 2011-10-16 18:17:56
print(Date.unix(1318781876.721).year) --> 2011
```

### Validation

<a id="fn-is-valid"></a>

#### `is_valid(input?, pattern?)`

Return `true` when the input can be parsed as a valid Date.

Unlike `Date(...)`, this helper never raises for invalid input; it just returns
`false`.

**Parameters**:

- `input?` (`string|number|mods.DateParts`): Value accepted by `Date(...)`.
  `nil` returns `false`.
- `pattern?` (`string`): Custom parse pattern used for string input.

**Return**:

- `isValid` (`boolean`): Whether the input is parseable as a valid Date.

**Example**:

```lua
print(Date.is_valid())                           --> false
print(Date.is_valid("2026-03-30"))               --> true
print(Date.is_valid("2026-02-29"))               --> false
print(Date.is_valid("12-25-1995", "MM-DD-YYYY")) --> true
```

### Metamethods

<a id="fn-add"></a>

#### `__add(a, b)`

Return a copy shifted by integer milliseconds.

This works as either `date + ms` or `ms + date`.

**Parameters**:

- `a` (`integer|mods.Date`): Milliseconds to add, or another Date.
- `b` (`integer|mods.Date`): Milliseconds to add, or another Date.

**Return**:

- `sum` (`mods.Date`): Sum of the two dates.

**Example**:

```lua
local d = Date("2026-03-30T14:45:06")
print((d + 250)) --> 2026-03-30 14:45:06.250
print((250 + d)) --> 2026-03-30 14:45:06.250
```

<a id="fn-eq"></a>

#### `__eq(date)`

Return `true` when both Date values have identical components.

**Parameters**:

- `date` (`mods.Date`): Date to compare against.

**Return**:

- `isEqual` (`boolean`): `true` if both dates are equal, `false` otherwise.

**Example**:

```lua
print(Date("2026-03-30") == Date("2026-03-30")) --> true
```

<a id="fn-le"></a>

#### `__le(date)`

Return `true` when the left Date is earlier than or equal to the right.

**Parameters**:

- `date` (`mods.Date`): Date to compare against.

**Return**:

- `isEarlierOrEqual` (`boolean`): `true` if the left date is earlier or equal,
  `false` otherwise.

**Example**:

```lua
print(Date("2026-03-30") <= Date("2026-03-30")) --> true
```

<a id="fn-lt"></a>

#### `__lt(date)`

Return `true` when the left Date is earlier than the right.

**Parameters**:

- `date` (`mods.Date`): Date to compare against.

**Return**:

- `isEarlier` (`boolean`): `true` if the left date is earlier, `false`
  otherwise.

**Example**:

```lua
print(Date("2026-03-30") < Date("2026-03-31")) --> true
```

<a id="fn-sub"></a>

#### `__sub(a, b)`

Return either a shifted copy or a millisecond delta.

When subtracting an integer, it shifts by that many milliseconds. When
subtracting another Date, it returns the signed millisecond difference.

**Parameters**:

- `a` (`integer|mods.Date`): Milliseconds to subtract, or another Date.
- `b` (`integer|mods.Date`): Milliseconds to subtract, or another Date.

**Return**:

- `delta` (`mods.Date|integer`): Difference between dates.

**Example**:

```lua
local a = Date("2026-03-30T14:45:06.250")
local b = Date("2026-03-30T14:45:06")
print((a - 250)) --> 2026-03-30 14:45:06
print(a - b)     --> 250
```

<a id="fn-tostring"></a>

#### `__tostring()`

Return the same result as `tostring()` when coerced to a string.

**Return**:

- `string` (`string`): representation of the date.

**Example**:

```lua
print(Date("2026-03-30T14:45:06")) --> 2026-03-30 14:45:06
```

## Fields

| Field             | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| [`day`](#day)     | Day-of-month component.                                      |
| [`hour`](#hour)   | Hour component.                                              |
| [`min`](#min)     | Minute component.                                            |
| [`month`](#month) | Month component.                                             |
| [`ms`](#ms)       | Millisecond component.                                       |
| [`sec`](#sec)     | Second component.                                            |
| [`wday`](#wday)   | ISO weekday component where Monday is `1` and Sunday is `7`. |
| [`yday`](#yday)   | Day-of-year component starting at `1`.                       |
| [`year`](#year)   | Year component.                                              |

<a id="day"></a>

### `day` (`modsCalendarMonthday`)

Day-of-month component.

```lua
print(Date("2026-03-30").day) --> 30
```

<a id="hour"></a>

### `hour` (`integer`)

Hour component.

```lua
print(Date("2026-03-30T14:45:06").hour) --> 14
```

<a id="min"></a>

### `min` (`integer`)

Minute component.

```lua
print(Date("2026-03-30T14:45:06").min) --> 45
```

<a id="month"></a>

### `month` (`modsCalendarMonth`)

Month component.

```lua
print(Date("2026-03-30").month) --> 3
```

<a id="ms"></a>

### `ms` (`integer`)

Millisecond component.

```lua
print(Date("2026-03-30T14:45:06.123").ms) --> 123
```

<a id="sec"></a>

### `sec` (`integer`)

Second component.

```lua
print(Date("2026-03-30T14:45:06").sec) --> 6
```

<a id="wday"></a>

### `wday` (`modsCalendarWeekday`)

ISO weekday component where Monday is `1` and Sunday is `7`.

```lua
print(Date("2026-03-30").wday) --> 1
```

<a id="yday"></a>

### `yday` (`integer`)

Day-of-year component starting at `1`.

```lua
print(Date("2026-03-30").yday) --> 89
```

<a id="year"></a>

### `year` (`integer`)

Year component.

```lua
print(Date("2026-03-30").year) --> 2026
```
