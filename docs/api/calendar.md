---
title: "calendar"
description: "Calculate weekday alignments, leap years, and month lengths."
---

Calculate weekday alignments, leap years, and month lengths.

> [!WARNING]
>
> This module is still under development and may not be stable. The API is
> incomplete and may change in future versions.

## Usage

```lua
cal = mods.calendar

print(cal.weekday(2026, 3, 26)) --> 4
```

## Fields

### `days` ([`mods.List`]`<string>`) {#days}

Weekday names indexed from `1` (Monday) to `7` (Sunday).

```lua
print(cal.days[1]) --> Monday
print(cal.days[7]) --> Sunday
```

---

### `firstweekday` ([`mods.CalendarWeekday`]) {#firstweekday}

The default first weekday field.

```lua
print(cal.firstweekday) --> 1
cal.firstweekday = cal.SUNDAY
print(cal.firstweekday) --> 7
```

> [!NOTE]
>
> Reading or writing this property is equivalent to calling `getfirstweekday()`
> or `setfirstweekday()`.

---

### `months` ([`mods.List`]`<string>`) {#months}

Month names indexed from `1` to `12`.

```lua
print(cal.months[1])  --> January
print(cal.months[12]) --> December
```

## Functions

| Function                          | Description                       |
| --------------------------------- | --------------------------------- |
| [`getfirstweekday()`]             | Return the default first weekday. |
| [`setfirstweekday(firstweekday)`] | Set the default first weekday.    |

**Calendar Calculations**:

| Function                      | Description                                                             |
| ----------------------------- | ----------------------------------------------------------------------- |
| [`isleap(year)`]              | Return `true` for leap years.                                           |
| [`leapdays(y1, y2)`]          | Return the number of leap years from `y1` up to but not including `y2`. |
| [`monthrange(year, month)`]   | Return the first weekday and number of days for a month.                |
| [`weekday(year, month, day)`] | Return weekday number where Monday is `1` and Sunday is `7`.            |

**Formatting**:

| Function                              | Description                                 |
| ------------------------------------- | ------------------------------------------- |
| [`weekheader(width?, firstweekday?)`] | Return the formatted weekday header string. |

**Iterators**:

| Function                                  | Description                                                            |
| ----------------------------------------- | ---------------------------------------------------------------------- |
| [`monthdays(year, month, firstweekday?)`] | Iterate `(year, month, day, weekday)` tuples for a full calendar grid. |
| [`weekdays(firstweekday?)`]               | Iterate weekday numbers for one full week.                             |

### `getfirstweekday()` {#getfirstweekday}

Return the default first weekday.

**Returns**:

- `firstweekday` ([`mods.CalendarWeekday`]): Monday

**Example**:

```lua
local cal = mods.calendar
print(cal.getfirstweekday()) --> 1
```

> [!NOTE]
>
> This returns the same value as `cal.firstweekday`.

---

### `setfirstweekday(firstweekday)` {#setfirstweekday}

Set the default first weekday.

**Parameters**:

- `firstweekday` ([`mods.CalendarWeekday`]): Monday

**Example**:

```lua
local cal = mods.calendar
cal.setfirstweekday(cal.SUNDAY)
```

> [!NOTE]
>
> This updates the same value as `cal.firstweekday = ...`.

---

### Calendar Calculations

#### `isleap(year)` {#isleap}

Return `true` for leap years.

**Parameters**:

- `year` (`integer`)

**Returns**:

- `isLeap` (`boolean`)

**Example**:

```lua
local cal = mods.calendar
print(cal.isleap(2024)) --> true
```

---

#### `leapdays(y1, y2)` {#leapdays}

Return the number of leap years from `y1` up to but not including `y2`.

**Parameters**:

- `y1` (`integer`)
- `y2` (`integer`)

**Returns**:

- `count` (`integer`)

**Example**:

```lua
local cal = mods.calendar
print(cal.leapdays(2000, 2025)) --> 7
```

---

#### `monthrange(year, month)` {#monthrange}

Return the first weekday and number of days for a month.

**Parameters**:

- `year` (`integer`)
- `month` (`integer`)

**Returns**:

- `weekday` ([`mods.CalendarWeekday`]): Monday
- `ndays` (`integer`)

**Example**:

```lua
local cal = mods.calendar
wday, ndays = cal.monthrange(2026, 2)
print(wday, ndays) --> 7 28
```

---

#### `weekday(year, month, day)` {#weekday}

Return weekday number where Monday is `1` and Sunday is `7`.

**Parameters**:

- `year` (`integer`)
- `month` ([`mods.CalendarMonth`]): January
- `day` ([`mods.modsCalendarMonthday`]): 1st day of the month

**Returns**:

- `weekday` ([`mods.CalendarWeekday`]): Monday

**Example**:

```lua
local cal = mods.calendar
print(cal.weekday(2026, 3, 26)) --> 4
```

---

### Formatting

#### `weekheader(width?, firstweekday?)` {#weekheader}

Return the formatted weekday header string.

**Parameters**:

- `width?` (`integer`)
- `firstweekday?` ([`mods.CalendarWeekday`]): Monday

**Returns**:

- `header` (`string`)

**Example**:

```lua
local cal = mods.calendar

print(cal.weekheader(1, cal.SUNDAY)) --> "S M T W T F S"
print(cal.weekheader(2, cal.SUNDAY)) --> "Su Mo Tu We Th Fr Sa"
print(cal.weekheader(3, cal.SUNDAY)) --> "Sun Mon Tue Wed Thu Fri Sat"
```

---

### Iterators

#### `monthdays(year, month, firstweekday?)` {#monthdays}

Iterate `(year, month, day, weekday)` tuples for a full calendar grid.

**Parameters**:

- `year` (`integer`)
- `month` ([`mods.CalendarMonth`]): January
- `firstweekday?` ([`mods.CalendarWeekday`]): Monday

**Returns**:

- `iter`
  (`fun():year:integer,month:`[`mods.CalendarMonth`]`,day:`[`mods.modsCalendarMonthday`]`,weekday:`[`mods.CalendarWeekday`])

**Example**:

```lua
local List = mods.list
local cal = mods.calendar
local str = mods.str

local header = cal.weekheader(2)
local lines = List({
  str.center(("%s %d"):format(cal.months[cal.FEBRUARY], 2026), #header),
  header,
})

local cells = List()
for _, m, d, _ in cal.monthdays(2026, cal.FEBRUARY) do
  cells:append(m == cal.FEBRUARY and ("%2d"):format(d) or "  ")
  if #cells == 7 then
    lines:append(cells:join(" "))
    cells = List()
  end
end

print(lines:join("\n"))
--    February 2026
-- Mo Tu We Th Fr Sa Su
--                    1
--  2  3  4  5  6  7  8
--  9 10 11 12 13 14 15
-- 16 17 18 19 20 21 22
-- 23 24 25 26 27 28
```

---

#### `weekdays(firstweekday?)` {#weekdays}

Iterate weekday numbers for one full week.

**Parameters**:

- `firstweekday?` ([`mods.CalendarWeekday`]): Monday

**Returns**:

- `iter` (`fun():`[`mods.CalendarWeekday`])

**Example**:

```lua
local cal = mods.calendar
local weekdays = {}
for day in cal.weekdays() do
  weekdays[#weekdays + 1] = day
end
print(table.concat(weekdays, ", ")) --> "1, 2, 3, 4, 5, 6, 7"
```

<!-- prettier-ignore-start -->
[`getfirstweekday()`]: #getfirstweekday
[`isleap(year)`]: #isleap
[`leapdays(y1, y2)`]: #leapdays
[`mods.CalendarMonth`]: /mods/types#mods-calendarmonth
[`mods.CalendarWeekday`]: /mods/types#mods-calendarweekday
[`mods.List`]: /mods/api/list
[`mods.modsCalendarMonthday`]: /mods/types#mods-modscalendarmonthday
[`monthdays(year, month, firstweekday?)`]: #monthdays
[`monthrange(year, month)`]: #monthrange
[`setfirstweekday(firstweekday)`]: #setfirstweekday
[`weekday(year, month, day)`]: #weekday
[`weekdays(firstweekday?)`]: #weekdays
[`weekheader(width?, firstweekday?)`]: #weekheader
<!-- prettier-ignore-end -->
