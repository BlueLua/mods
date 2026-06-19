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

## Fields

| Field     | Description                                                  |
| --------- | ------------------------------------------------------------ |
| [`day`]   | Day-of-month component.                                      |
| [`hour`]  | Hour component.                                              |
| [`min`]   | Minute component.                                            |
| [`month`] | Month component.                                             |
| [`ms`]    | Millisecond component.                                       |
| [`sec`]   | Second component.                                            |
| [`wday`]  | ISO weekday component where Monday is `1` and Sunday is `7`. |
| [`yday`]  | Day-of-year component starting at `1`.                       |
| [`year`]  | Year component.                                              |

### `day` (`modsCalendarMonthday`) {#day}

Day-of-month component.

```lua
print(Date("2026-03-30").day) --> 30
```

---

### `hour` (`integer`) {#hour}

Hour component.

```lua
print(Date("2026-03-30T14:45:06").hour) --> 14
```

---

### `min` (`integer`) {#min}

Minute component.

```lua
print(Date("2026-03-30T14:45:06").min) --> 45
```

---

### `month` (`modsCalendarMonth`) {#month}

Month component.

```lua
print(Date("2026-03-30").month) --> 3
```

---

### `ms` (`integer`) {#ms}

Millisecond component.

```lua
print(Date("2026-03-30T14:45:06.123").ms) --> 123
```

---

### `sec` (`integer`) {#sec}

Second component.

```lua
print(Date("2026-03-30T14:45:06").sec) --> 6
```

---

### `wday` (`modsCalendarWeekday`) {#wday}

ISO weekday component where Monday is `1` and Sunday is `7`.

```lua
print(Date("2026-03-30").wday) --> 1
```

---

### `yday` (`integer`) {#yday}

Day-of-year component starting at `1`.

```lua
print(Date("2026-03-30").yday) --> 89
```

---

### `year` (`integer`) {#year}

Year component.

```lua
print(Date("2026-03-30").year) --> 2026
```

## Functions

| Function                 | Description                                                              |
| ------------------------ | ------------------------------------------------------------------------ |
| [`new(input, pattern?)`] | Create a Date from a string using an optional pattern.                   |
| [`new(input?)`]          | Create a Date from a Unix timestamp (milliseconds) or a DateParts table. |

**Arithmetic**:

| Function                    | Description                                                         |
| --------------------------- | ------------------------------------------------------------------- |
| [`add(amount, unit?)`]      | Return a copy shifted by the given amount and unit.                 |
| [`diff(date, unit?)`]       | Return the signed difference to another Date in the requested unit. |
| [`subtract(amount, unit?)`] | Return a copy shifted backward by the given amount and unit.        |

**Boundaries**:

| Function          | Description                                   |
| ----------------- | --------------------------------------------- |
| [`endof(unit)`]   | Return the end boundary for the given unit.   |
| [`startof(unit)`] | Return the start boundary for the given unit. |

**Calendar**:

| Function                             | Description                                                                 |
| ------------------------------------ | --------------------------------------------------------------------------- |
| [`day_of_year(day_of_year_number?)`] | Return or set the day of the year.                                          |
| [`is_leap_year()`]                   | Return `true` when the value's year is a leap year.                         |
| [`iso_week(iso_week_number?)`]       | Return or set the ISO week-of-year number.                                  |
| [`iso_week_year()`]                  | Return the ISO week-year for the current date.                              |
| [`iso_weekday(iso_weekday_number?)`] | Return or set the ISO weekday number where Monday is `1` and Sunday is `7`. |
| [`iso_weeks_in_year()`]              | Return the number of ISO weeks in the current date's calendar year.         |
| [`month_days()`]                     | Return the number of days in the value's month.                             |
| [`quarter(quarter_number?)`]         | Return or set the quarter of the year.                                      |
| [`week(week_number?)`]               | Return or set the non-ISO week-of-year number.                              |
| [`week_year()`]                      | Return the non-ISO week-year for the current date.                          |
| [`weekday(weekday_number?)`]         | Return or set the locale-relative weekday like Day.js `weekday()`.          |
| [`weeks_in_year()`]                  | Return the number of weeks in the current locale week-year.                 |

**Compare**:

| Function        | Description                                                 |
| --------------- | ----------------------------------------------------------- |
| [`max(...)`]    | Return the latest value from the given dates.               |
| [`min(...)`]    | Return the earliest value from the given dates.             |
| [`minmax(...)`] | Return the earliest and latest values from the given dates. |

**Comparison**:

| Function                                         | Description                                                       |
| ------------------------------------------------ | ----------------------------------------------------------------- |
| [`is_after(date)`]                               | Return `true` when the value is later than `other`.               |
| [`is_before(date)`]                              | Return `true` when the value is earlier than `other`.             |
| [`is_between(start_date, end_date, inclusive?)`] | Return `true` when the value lies between two bounds.             |
| [`is_same(date)`]                                | Return `true` when the value is equal to `other`.                 |
| [`is_same_or_after(date)`]                       | Return `true` when the value is later than or equal to `other`.   |
| [`is_same_or_before(date)`]                      | Return `true` when the value is earlier than or equal to `other`. |
| [`is_today()`]                                   | Return `true` when the value falls on the current local day.      |
| [`is_tomorrow()`]                                | Return `true` when the value falls on the next local day.         |
| [`is_yesterday()`]                               | Return `true` when the value falls on the previous local day.     |

**Duration**:

| Function               | Description                                                                 |
| ---------------------- | --------------------------------------------------------------------------- |
| [`is_duration(value)`] | Return `true` when the value is a duration created by `date.duration(...)`. |

**Formatting**:

| Function            | Description                                                                                             |
| ------------------- | ------------------------------------------------------------------------------------------------------- |
| [`format(pattern)`] | Format the Date with tokens like `YYYY`, `MMM`, `dddd`, `Do`, `Q`, `hh`, `k`, `X`, `x`, `A`, and `SSS`. |
| [`tostring()`]      | Return the default string form `YYYY-MM-DD HH:mm:ss`.                                                   |

**Relative Time**:

| Function                        | Description                                                    |
| ------------------------------- | -------------------------------------------------------------- |
| [`from(date, without_suffix?)`] | Return relative time from another Date to this one.            |
| [`from_now(without_suffix?)`]   | Return relative time from the current local time to this Date. |
| [`to(date, without_suffix?)`]   | Return relative time from this Date to another one.            |
| [`to_now(without_suffix?)`]     | Return relative time from this Date to the current local time. |

**Unix**:

| Function            | Description                                                         |
| ------------------- | ------------------------------------------------------------------- |
| [`unix(timestamp)`] | Create a Date from a Unix timestamp in whole or fractional seconds. |

**Validation**:

| Function                       | Description                                                 |
| ------------------------------ | ----------------------------------------------------------- |
| [`is_valid(input?, pattern?)`] | Return `true` when the input can be parsed as a valid Date. |

**Metamethods**:

| Function         | Description                                                             |
| ---------------- | ----------------------------------------------------------------------- |
| [`__add(a, b)`]  | Return a copy shifted by integer milliseconds.                          |
| [`__eq(date)`]   | Return `true` when both Date values have identical components.          |
| [`__le(date)`]   | Return `true` when the left Date is earlier than or equal to the right. |
| [`__lt(date)`]   | Return `true` when the left Date is earlier than the right.             |
| [`__sub(a, b)`]  | Return either a shifted copy or a millisecond delta.                    |
| [`__tostring()`] | Return the same result as `tostring()` when coerced to a string.        |

### `new(input, pattern?)` {#new-1}

Create a Date from a string using an optional pattern.

**Parameters**:

- `input` (`string`): The date string to parse.
- `pattern?` (`string`): The format pattern.

**Returns**:

- **value** ([`mods.Date`])

**Example**:

```lua
local d1 = Date("2026-03-30")
local d2 = Date("12-25-1995", "MM-DD-YYYY")
```

---

### `new(input?)` {#new}

Create a Date from a Unix timestamp (milliseconds) or a DateParts table.

**Parameters**:

- `input?` (`number` | [`mods.DateParts`]): Unix timestamp (ms) or table of date
  components.

**Returns**:

- **value** ([`mods.Date`])

**Example**:

```lua
local d1 = Date(1745155206123)
local d2 = Date({ year = 2026, month = 3 })
```

---

### Arithmetic

#### `add(amount, unit?)` {#add}

Return a copy shifted by the given amount and unit.

**Parameters**:

- `amount` (`integer` | [`mods.DateDurationParts`]): Signed amount to add, or a
  duration-style table.
- `unit?` ([`mods.DateUnit`]): Unit for the addition.

**Returns**:

- `shifted` ([`mods.Date`]): Shifted date value.

**Example**:

```lua
local d = Date("2026-03-30T14:45:06")

print(d:add(2, "day"))               --> 2026-04-01 14:45:06
print(d:add(1, "quarter"))           --> 2026-06-30 14:45:06
print(d:add(1, "month"))             --> 2026-04-30 14:45:06
print(d:add(250, "ms"))              --> 2026-03-30 14:45:06.250
print(d:add({ month = 1, day = 2 })) --> 2026-05-02 14:45:06
```

---

#### `diff(date, unit?)` {#diff}

Return the signed difference to another Date in the requested unit.

**Parameters**:

- `date` ([`mods.Date`]): Date to compare against.
- `unit?` ([`mods.DateUnit`]): Unit used for the difference. Defaults to `"ms"`.

**Returns**:

- `delta` (`integer`): Signed difference in whole units.

**Example**:

```lua
local a = Date("2026-03-30T12:00:00")
local b = Date("2026-02-28T12:00:00")
print(a:diff(b, "month")) --> 1
print(a:diff(b, "day"))   --> 30
```

---

#### `subtract(amount, unit?)` {#subtract}

Return a copy shifted backward by the given amount and unit.

**Parameters**:

- `amount` (`integer` | [`mods.DateDurationParts`]): Signed amount to subtract,
  or a duration-style table.
- `unit?` ([`mods.DateUnit`]): Unit for the subtraction.

**Returns**:

- `shifted` ([`mods.Date`]): Shifted date value.

**Example**:

```lua
local d = Date("2026-03-30T14:45:06")
print(d:subtract(2, "day"))               --> 2026-03-28 14:45:06
print(d:subtract(1, "quarter"))           --> 2025-12-30 14:45:06
print(d:subtract(1, "month"))             --> 2026-02-28 14:45:06
print(d:subtract(250, "ms"))              --> 2026-03-30 14:45:05.750
print(d:subtract({ month = 1, day = 1 })) --> 2026-02-27 14:45:06
```

---

### Boundaries

#### `endof(unit)` {#endof}

Return the end boundary for the given unit.

**Parameters**:

- `unit` ([`mods.DateUnit`] | `"isoWeek"`): Boundary unit.

**Returns**:

- `bounded` ([`mods.Date`]): Date clamped to the end of the unit.

**Example**:

```lua
local d = Date("2026-03-30T14:45:06")
print(d:endof("month"))   --> 2026-03-31 23:59:59
print(d:endof("week"))    --> 2026-04-05 23:59:59
print(d:endof("isoWeek")) --> 2026-04-05 23:59:59
```

`"isoWeek"` is also supported here as a boundary-only unit.

---

#### `startof(unit)` {#startof}

Return the start boundary for the given unit.

**Parameters**:

- `unit` ([`mods.DateUnit`] | `"isoWeek"`): Boundary unit.

**Returns**:

- `bounded` ([`mods.Date`]): Date clamped to the start of the unit.

**Example**:

```lua
local d = Date("2026-03-30T14:45:06")
print(d:startof("day"))     --> 2026-03-30 00:00:00
print(d:startof("quarter")) --> 2026-01-01 00:00:00
print(d:startof("isoWeek")) --> 2026-03-30 00:00:00
```

`"isoWeek"` is also supported here as a boundary-only unit.

---

### Calendar

#### `day_of_year(day_of_year_number?)` {#day-of-year}

Return or set the day of the year.

**Parameters**:

- `day_of_year_number?` (`integer`): Day-of-year to set.

**Returns**:

- `dayOrDate` (`integer` | [`mods.Date`]): Current day-of-year number, or a
  shifted Date when `day_of_year_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:day_of_year())  --> 89
print(d:day_of_year(1)) --> 2026-01-01 00:00:00
```

---

#### `is_leap_year()` {#is-leap-year}

Return `true` when the value's year is a leap year.

**Returns**:

- `isLeapYear` (`boolean`): Whether the year is a leap year.

**Example**:

```lua
print(Date("2024-02-29"):is_leap_year()) --> true
```

---

#### `iso_week(iso_week_number?)` {#iso-week}

Return or set the ISO week-of-year number.

**Parameters**:

- `iso_week_number?` (`integer`): ISO week number to set.

**Returns**:

- `isoWeekOrDate` (`integer` | [`mods.Date`]): Current ISO week number, or a
  shifted Date when `iso_week_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:iso_week())   --> 14
print(d:iso_week(15)) --> 2026-04-06 00:00:00
```

---

#### `iso_week_year()` {#iso-week-year}

Return the ISO week-year for the current date.

**Returns**:

- `isoWeekYear` (`integer`): ISO week-year.

**Example**:

```lua
print(Date("2021-01-01"):iso_week_year()) --> 2020
```

---

#### `iso_weekday(iso_weekday_number?)` {#iso-weekday}

Return or set the ISO weekday number where Monday is `1` and Sunday is `7`.

**Parameters**:

- `iso_weekday_number?` (`integer`): ISO weekday to set.

**Returns**:

- `isoWeekdayOrDate` (`modsCalendarWeekday` | [`mods.Date`]): Current ISO
  weekday number, or a shifted Date when `iso_weekday_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:iso_weekday())  --> 1
print(d:iso_weekday(7)) --> 2026-04-05 00:00:00
```

---

#### `iso_weeks_in_year()` {#iso-weeks-in-year}

Return the number of ISO weeks in the current date's calendar year.

**Returns**:

- `isoWeeksInYear` (`integer`): Number of ISO weeks in the current date's
  calendar year.

**Example**:

```lua
local d = Date("2016-01-01")
print(Date("2016-01-01"):iso_weeks_in_year()) --> 52
print(Date("2016-06-01"):iso_weeks_in_year()) --> 52
```

---

#### `month_days()` {#month-days}

Return the number of days in the value's month.

**Returns**:

- `ndays` (`modsCalendarMonthday`): Number of days in the current month.

**Example**:

```lua
print(Date("2024-02-01"):month_days()) --> 29
```

---

#### `quarter(quarter_number?)` {#quarter}

Return or set the quarter of the year.

**Parameters**:

- `quarter_number?` (`integer`): Quarter to set.

**Returns**:

- `quarterOrDate` (`integer` | [`mods.Date`]): Current quarter number, or a
  shifted Date when `quarter_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:quarter())  --> 1
print(d:quarter(2)) --> 2026-06-30 00:00:00
```

---

#### `week(week_number?)` {#week}

Return or set the non-ISO week-of-year number.

**Parameters**:

- `week_number?` (`integer`): Week number to set.

**Returns**:

- `weekOrDate` (`integer` | [`mods.Date`]): Current week-of-year number, or a
  shifted Date when `week_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:week())   --> 14
print(d:week(15)) --> 2026-04-06 00:00:00
```

---

#### `week_year()` {#week-year}

Return the non-ISO week-year for the current date.

**Returns**:

- `weekYear` (`integer`): Week-year.

**Example**:

```lua
print(Date("2021-01-01"):week_year()) --> 2021
```

---

#### `weekday(weekday_number?)` {#weekday}

Return or set the locale-relative weekday like Day.js `weekday()`.

**Parameters**:

- `weekday_number?` (`integer`): Locale-relative weekday to set.

**Returns**:

- `weekdayOrDate` (`integer` | [`mods.Date`]): Current locale-relative weekday
  number, or a shifted Date when `weekday_number` is provided.

**Example**:

```lua
local d = Date("2026-03-30")
print(d:weekday())   --> 0
print(d:weekday(7))  --> 2026-04-06 00:00:00
print(d:weekday(-7)) --> 2026-03-23 00:00:00
```

The getter returns a number in the range `0..6`, relative to the current
[`mods.calendar.firstweekday`]. Passing an integer returns a shifted copy in the
same locale-relative week space, with negative and overflow values moving into
previous or next weeks.

---

#### `weeks_in_year()` {#weeks-in-year}

Return the number of weeks in the current locale week-year.

**Returns**:

- `weeksInYear` (`integer`): Number of weeks.

**Example**:

```lua
print(Date("2026-03-30"):weeks_in_year()) --> 52
```

---

### Compare

#### `max(...)` {#max}

Return the latest value from the given dates.

**Parameters**:

- `...` ([`mods.Date`] | [`mods.Date`]`[]`): Date values to compare. Each
  argument may be a date or a list of dates.

**Returns**:

- `date` ([`mods.Date`]): Latest date value.

**Example**:

```lua
local a = Date("2026-03-30")
local b = Date("2026-03-31")
print(Date.max(a, b))     --> 2026-03-31 00:00:00
print(Date.max({ a, b })) --> 2026-03-31 00:00:00
```

---

#### `min(...)` {#min-1}

Return the earliest value from the given dates.

**Parameters**:

- `...` ([`mods.Date`] | [`mods.Date`]`[]`): Date values to compare. Each
  argument may be a date or a list of dates.

**Returns**:

- `date` ([`mods.Date`]): Earliest date value.

**Example**:

```lua
local a = Date("2026-03-30")
local b = Date("2026-03-28")
print(Date.min(a, b))     --> 2026-03-28 00:00:00
print(Date.min({ a, b })) --> 2026-03-28 00:00:00
```

---

#### `minmax(...)` {#minmax}

Return the earliest and latest values from the given dates.

**Parameters**:

- `...` ([`mods.Date`] | [`mods.Date`]`[]`): Date values to compare. Each
  argument may be a date or a list of dates.

**Returns**:

- `minDate` ([`mods.Date`]): Earliest date value.
- `maxDate` ([`mods.Date`]): Latest date value.

**Example**:

```lua
local a = Date("2026-03-30")
local b = Date("2026-03-28")
local c = Date("2026-03-31")
local min_date, max_date = Date.minmax(a, b, c)
print(min_date) --> 2026-03-28 00:00:00
print(max_date) --> 2026-03-31 00:00:00
```

---

### Comparison

#### `is_after(date)` {#is-after}

Return `true` when the value is later than `other`.

**Parameters**:

- `date` ([`mods.Date`]): Date to compare against.

**Returns**:

- `isAfter` (`boolean`): Whether the value is later than `date`.

**Example**:

```lua
local a = Date("2026-03-31T12:00:00")
local b = Date("2026-03-30T12:00:00")
print(a:is_after(b)) --> true
```

---

#### `is_before(date)` {#is-before}

Return `true` when the value is earlier than `other`.

**Parameters**:

- `date` ([`mods.Date`]): Date to compare against.

**Returns**:

- `isBefore` (`boolean`): Whether the value is earlier than `date`.

**Example**:

```lua
local a = Date("2026-03-30T12:00:00")
local b = Date("2026-03-31T12:00:00")
print(a:is_before(b)) --> true
```

---

#### `is_between(start_date, end_date, inclusive?)` {#is-between}

Return `true` when the value lies between two bounds.

Bounds may be passed in either order. By default the comparison is exclusive;
pass `true` as the third argument to include the endpoints.

**Parameters**:

- `start_date` ([`mods.Date`]): One bound.
- `end_date` ([`mods.Date`]): The other bound.
- `inclusive?` (`boolean`): Whether to include the endpoints. Defaults to
  `false`.

**Returns**:

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

---

#### `is_same(date)` {#is-same}

Return `true` when the value is equal to `other`.

**Parameters**:

- `date` ([`mods.Date`]): Date to compare against.

**Returns**:

- `isSame` (`boolean`): Whether the value is equal to `date`.

**Example**:

```lua
local a = Date("2026-03-30T12:00:00")
local b = Date("2026-03-30T12:00:00")
print(a:is_same(b)) --> true
```

---

#### `is_same_or_after(date)` {#is-same-or-after}

Return `true` when the value is later than or equal to `other`.

**Parameters**:

- `date` ([`mods.Date`]): Date to compare against.

**Returns**:

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

---

#### `is_same_or_before(date)` {#is-same-or-before}

Return `true` when the value is earlier than or equal to `other`.

**Parameters**:

- `date` ([`mods.Date`]): Date to compare against.

**Returns**:

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

---

#### `is_today()` {#is-today}

Return `true` when the value falls on the current local day.

**Returns**:

- `isToday` (`boolean`): Whether the value is on today in local time.

**Example**:

```lua
print(Date():is_today()) --> true
```

---

#### `is_tomorrow()` {#is-tomorrow}

Return `true` when the value falls on the next local day.

**Returns**:

- `isTomorrow` (`boolean`): Whether the value is on tomorrow in local time.

**Example**:

```lua
print(Date():add(1, "day"):is_tomorrow()) --> true
```

---

#### `is_yesterday()` {#is-yesterday}

Return `true` when the value falls on the previous local day.

**Returns**:

- `isYesterday` (`boolean`): Whether the value is on yesterday in local time.

**Example**:

```lua
print(Date():subtract(1, "day"):is_yesterday()) --> true
```

---

### Duration

#### `is_duration(value)` {#is-duration}

Return `true` when the value is a duration created by `date.duration(...)`.

**Parameters**:

- `value` (`any`): Value to test.

**Returns**:

- `isDuration` (`boolean`): Whether the value is a [`mods.Duration`].

**Example**:

```lua
local shift = date.duration({ day = 2 })
print(date.is_duration(shift)) --> true
print(date.is_duration({ day = 2 })) --> false
```

---

### Formatting

#### `format(pattern)` {#format}

Format the Date with tokens like `YYYY`, `MMM`, `dddd`, `Do`, `Q`, `hh`, `k`,
`X`, `x`, `A`, and `SSS`.

**Parameters**:

- `pattern` (`string`): Format pattern using supported tokens.

**Returns**:

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

---

#### `tostring()` {#tostring}

Return the default string form `YYYY-MM-DD HH:mm:ss`.

**Returns**:

- `s` (`string`): Default datetime string.

**Example**:

```lua
print(Date("2026-03-30T14:45:06.123")) --> 2026-03-30 14:45:06.123
```

---

### Relative Time

#### `from(date, without_suffix?)` {#from}

Return relative time from another Date to this one.

By default the result includes a suffix like `ago` or a prefix like `in`. Pass
`true` to omit that suffix or prefix.

**Parameters**:

- `date` ([`mods.Date`]): Reference date.
- `without_suffix?` (`boolean`): Whether to omit `ago` / `in`.

**Returns**:

- `relative` (`string`): Relative time string.

**Example**:

```lua
local a = date("2026-03-30T14:45:06")
local b = date("2026-03-30T12:45:06")
print(a:from(b))       --> in 2 hours
print(a:from(b, true)) --> 2 hours
```

---

#### `from_now(without_suffix?)` {#from-now}

Return relative time from the current local time to this Date.

**Parameters**:

- `without_suffix?` (`boolean`): Whether to omit `ago` / `in`.

**Returns**:

- `relative` (`string`): Relative time string.

**Example**:

```lua
local d = date():add(1, "day")
print(d:from_now()) --> in a day
```

---

#### `to(date, without_suffix?)` {#to}

Return relative time from this Date to another one.

By default the result includes a suffix like `ago` or a prefix like `in`. Pass
`true` to omit that suffix or prefix.

**Parameters**:

- `date` ([`mods.Date`]): Reference date.
- `without_suffix?` (`boolean`): Whether to omit `ago` / `in`.

**Returns**:

- `relative` (`string`): Relative time string.

**Example**:

```lua
local a = date("2026-03-30T12:45:06")
local b = date("2026-03-30T14:45:06")
print(a:to(b))       --> in 2 hours
print(a:to(b, true)) --> 2 hours
```

---

#### `to_now(without_suffix?)` {#to-now}

Return relative time from this Date to the current local time.

**Parameters**:

- `without_suffix?` (`boolean`): Whether to omit `ago` / `in`.

**Returns**:

- `relative` (`string`): Relative time string.

**Example**:

```lua
local d = date():subtract(1, "day")
print(d:to_now()) --> in a day
```

---

### Unix

#### `unix(timestamp)` {#unix}

Create a Date from a Unix timestamp in whole or fractional seconds.

**Parameters**:

- `timestamp` (`number`): Unix timestamp in whole or fractional seconds.

**Returns**:

- `date` ([`mods.Date`]): Date value for the given Unix timestamp.

**Example**:

```lua
print(Date.unix(1318781876))          --> 2011-10-16 18:17:56
print(Date.unix(1318781876.721).year) --> 2011
```

---

### Validation

#### `is_valid(input?, pattern?)` {#is-valid}

Return `true` when the input can be parsed as a valid Date.

Unlike `Date(...)`, this helper never raises for invalid input; it just returns
`false`.

**Parameters**:

- `input?` (`string` | `number` | [`mods.DateParts`]): Value accepted by
  `Date(...)`. `nil` returns `false`.
- `pattern?` (`string`): Custom parse pattern used for string input.

**Returns**:

- `isValid` (`boolean`): Whether the input is parseable as a valid Date.

**Example**:

```lua
print(Date.is_valid())                           --> false
print(Date.is_valid("2026-03-30"))               --> true
print(Date.is_valid("2026-02-29"))               --> false
print(Date.is_valid("12-25-1995", "MM-DD-YYYY")) --> true
```

---

### Metamethods

#### `__add(a, b)` {#add-1}

Return a copy shifted by integer milliseconds.

This works as either `date + ms` or `ms + date`.

**Parameters**:

- `a` (`integer` | [`mods.Date`]): Milliseconds to add, or another Date.
- `b` (`integer` | [`mods.Date`]): Milliseconds to add, or another Date.

**Returns**:

- `sum` ([`mods.Date`]): Sum of the two dates.

**Example**:

```lua
local d = Date("2026-03-30T14:45:06")
print((d + 250)) --> 2026-03-30 14:45:06.250
print((250 + d)) --> 2026-03-30 14:45:06.250
```

---

#### `__eq(date)` {#eq}

Return `true` when both Date values have identical components.

**Parameters**:

- `date` ([`mods.Date`]): Date to compare against.

**Returns**:

- `isEqual` (`boolean`): `true` if both dates are equal, `false` otherwise.

**Example**:

```lua
print(Date("2026-03-30") == Date("2026-03-30")) --> true
```

---

#### `__le(date)` {#le}

Return `true` when the left Date is earlier than or equal to the right.

**Parameters**:

- `date` ([`mods.Date`]): Date to compare against.

**Returns**:

- `isEarlierOrEqual` (`boolean`): `true` if the left date is earlier or equal,
  `false` otherwise.

**Example**:

```lua
print(Date("2026-03-30") <= Date("2026-03-30")) --> true
```

---

#### `__lt(date)` {#lt}

Return `true` when the left Date is earlier than the right.

**Parameters**:

- `date` ([`mods.Date`]): Date to compare against.

**Returns**:

- `isEarlier` (`boolean`): `true` if the left date is earlier, `false`
  otherwise.

**Example**:

```lua
print(Date("2026-03-30") < Date("2026-03-31")) --> true
```

---

#### `__sub(a, b)` {#sub}

Return either a shifted copy or a millisecond delta.

When subtracting an integer, it shifts by that many milliseconds. When
subtracting another Date, it returns the signed millisecond difference.

**Parameters**:

- `a` (`integer` | [`mods.Date`]): Milliseconds to subtract, or another Date.
- `b` (`integer` | [`mods.Date`]): Milliseconds to subtract, or another Date.

**Returns**:

- `delta` ([`mods.Date`] | `integer`): Difference between dates.

**Example**:

```lua
local a = Date("2026-03-30T14:45:06.250")
local b = Date("2026-03-30T14:45:06")
print((a - 250)) --> 2026-03-30 14:45:06
print(a - b)     --> 250
```

---

#### `__tostring()` {#tostring-1}

Return the same result as `tostring()` when coerced to a string.

**Returns**:

- `string` (`string`): representation of the date.

**Example**:

```lua
print(Date("2026-03-30T14:45:06")) --> 2026-03-30 14:45:06
```

<!-- prettier-ignore-start -->
[ISO 8601]: https://en.wikipedia.org/wiki/ISO_8601
[`Date.unix(ts)`]: #fn-unix
[`__add(a, b)`]: #add-1
[`__eq(date)`]: #eq
[`__le(date)`]: #le
[`__lt(date)`]: #lt
[`__sub(a, b)`]: #sub
[`__tostring()`]: #tostring-1
[`add(amount, unit?)`]: #add
[`day_of_year(day_of_year_number?)`]: #day-of-year
[`day`]: #day
[`diff(date, unit?)`]: #diff
[`endof(unit)`]: #endof
[`format(pattern)`]: #format
[`from(date, without_suffix?)`]: #from
[`from_now(without_suffix?)`]: #from-now
[`hour`]: #hour
[`is_after(date)`]: #is-after
[`is_before(date)`]: #is-before
[`is_between(start_date, end_date, inclusive?)`]: #is-between
[`is_duration(value)`]: #is-duration
[`is_leap_year()`]: #is-leap-year
[`is_same(date)`]: #is-same
[`is_same_or_after(date)`]: #is-same-or-after
[`is_same_or_before(date)`]: #is-same-or-before
[`is_today()`]: #is-today
[`is_tomorrow()`]: #is-tomorrow
[`is_valid(input?, pattern?)`]: #is-valid
[`is_yesterday()`]: #is-yesterday
[`iso_week(iso_week_number?)`]: #iso-week
[`iso_week_year()`]: #iso-week-year
[`iso_weekday(iso_weekday_number?)`]: #iso-weekday
[`iso_weeks_in_year()`]: #iso-weeks-in-year
[`max(...)`]: #max
[`min(...)`]: #min-1
[`min`]: #min
[`minmax(...)`]: #minmax
[`mods.DateDurationParts`]: /mods/types#mods-datedurationparts
[`mods.DateParts`]: /mods/types#mods-dateparts
[`mods.DateUnit`]: /mods/types#mods-dateunit
[`mods.Date`]: /mods/api/date
[`mods.Duration`]: /mods/api/duration
[`mods.calendar.firstweekday`]: /mods/api/calendar#firstweekday
[`month_days()`]: #month-days
[`month`]: #month
[`ms`]: #ms
[`new(input, pattern?)`]: #new-1
[`new(input?)`]: #new
[`os.time`]: https://www.lua.org/manual/5.1/manual.html#pdf-os.time
[`quarter(quarter_number?)`]: #quarter
[`sec`]: #sec
[`startof(unit)`]: #startof
[`subtract(amount, unit?)`]: #subtract
[`to(date, without_suffix?)`]: #to
[`to_now(without_suffix?)`]: #to-now
[`tostring()`]: #tostring
[`unix(timestamp)`]: #unix
[`wday`]: #wday
[`week(week_number?)`]: #week
[`week_year()`]: #week-year
[`weekday(weekday_number?)`]: #weekday
[`weeks_in_year()`]: #weeks-in-year
[`yday`]: #yday
[`year`]: #year
[mstime]: https://github.com/luamod/mstime
<!-- prettier-ignore-end -->
