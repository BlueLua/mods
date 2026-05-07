---
description: "Calendar and date helpers."
---

# `calendar`

Calendar and date helpers.

## Usage

```lua
cal = require "mods.calendar"

print(cal.weekday(2026, 3, 26)) --> 4
```

## Functions

| Function                                               | Description                       |
| ------------------------------------------------------ | --------------------------------- |
| [`getfirstweekday()`](#fn-getfirstweekday)             | Return the default first weekday. |
| [`setfirstweekday(firstweekday)`](#fn-setfirstweekday) | Set the default first weekday.    |

**Calendar Calculations**:

| Function                                    | Description                                                             |
| ------------------------------------------- | ----------------------------------------------------------------------- |
| [`isleap(year)`](#fn-isleap)                | Return `true` for leap years.                                           |
| [`leapdays(y1, y2)`](#fn-leapdays)          | Return the number of leap years from `y1` up to but not including `y2`. |
| [`monthrange(year, month)`](#fn-monthrange) | Return the first weekday and number of days for a month.                |
| [`weekday(year, month, day)`](#fn-weekday)  | Return weekday number where Monday is `1` and Sunday is `7`.            |

**Formatting**:

| Function                                              | Description                                 |
| ----------------------------------------------------- | ------------------------------------------- |
| [`weekheader(width?, firstweekday?)`](#fn-weekheader) | Return the formatted weekday header string. |

**Iterators**:

| Function                                                 | Description                                                            |
| -------------------------------------------------------- | ---------------------------------------------------------------------- |
| [`monthdays(year, month, firstweekday?)`](#fn-monthdays) | Iterate `(year, month, day, weekday)` tuples for a full calendar grid. |
| [`weekdays(firstweekday?)`](#fn-weekdays)                | Iterate weekday numbers for one full week.                             |

<a id="fn-getfirstweekday"></a>

### `getfirstweekday()`

Return the default first weekday.

**Return**:

- `firstweekday` (`1|2|3|4|5|6|7`)

**Example**:

```lua
print(cal.getfirstweekday()) --> 1
```

> [!NOTE]
>
> This returns the same value as `cal.firstweekday`.

<a id="fn-setfirstweekday"></a>

### `setfirstweekday(firstweekday)`

Set the default first weekday.

**Parameters**:

- `firstweekday` (`1|2|3|4|5|6|7`)

**Example**:

```lua
cal.setfirstweekday(cal.SUNDAY)
```

> [!NOTE]
>
> This updates the same value as `cal.firstweekday = ...`.

### Calendar Calculations

<a id="fn-isleap"></a>

#### `isleap(year)`

Return `true` for leap years.

**Parameters**:

- `year` (`integer`)

**Return**:

- `isLeap` (`boolean`)

**Example**:

```lua
print(cal.isleap(2024)) --> true
```

<a id="fn-leapdays"></a>

#### `leapdays(y1, y2)`

Return the number of leap years from `y1` up to but not including `y2`.

**Parameters**:

- `y1` (`integer`)
- `y2` (`integer`)

**Return**:

- `count` (`integer`)

**Example**:

```lua
print(cal.leapdays(2000, 2025)) --> 7
```

<a id="fn-monthrange"></a>

#### `monthrange(year, month)`

Return the first weekday and number of days for a month.

**Parameters**:

- `year` (`integer`)
- `month` (`integer`)

**Return**:

- `weekday` (`1|2|3|4|5|6|7`)
- `ndays` (`integer`)

**Example**:

```lua
wday, ndays = cal.monthrange(2026, 2)
print(wday, ndays) --> 7 28
```

<a id="fn-weekday"></a>

#### `weekday(year, month, day)`

Return weekday number where Monday is `1` and Sunday is `7`.

**Parameters**:

- `year` (`integer`)
- `month` (`1|2|3|4|5|6|7|8|9|10|11|12`)
- `day`
  (`1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31`)

**Return**:

- `weekday` (`1|2|3|4|5|6|7`)

**Example**:

```lua
print(cal.weekday(2026, 3, 26)) --> 4
```

### Formatting

<a id="fn-weekheader"></a>

#### `weekheader(width?, firstweekday?)`

Return the formatted weekday header string.

**Parameters**:

- `width?` (`integer`)
- `firstweekday?` (`1|2|3|4|5|6|7`)

**Return**:

- `header` (`string`)

**Example**:

```lua
print(cal.weekheader(1, cal.SUNDAY)) --> "S M T W T F S"
print(cal.weekheader(2, cal.SUNDAY)) --> "Su Mo Tu We Th Fr Sa"
print(cal.weekheader(3, cal.SUNDAY)) --> "Sun Mon Tue Wed Thu Fri Sat"
```

### Iterators

<a id="fn-monthdays"></a>

#### `monthdays(year, month, firstweekday?)`

Iterate `(year, month, day, weekday)` tuples for a full calendar grid.

**Parameters**:

- `year` (`integer`)
- `month` (`1|2|3|4|5|6|7|8|9|10|11|12`)
- `firstweekday?` (`1|2|3|4|5|6|7`)

**Return**:

- `iter`
  (`fun():year:integer,month:modsCalendarMonth,day:modsCalendarMonthday,weekday:modsCalendarWeekday`)

**Example**:

```lua
local mods = require "mods"

local List = mods.List
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

<a id="fn-weekdays"></a>

#### `weekdays(firstweekday?)`

Iterate weekday numbers for one full week.

**Parameters**:

- `firstweekday?` (`1|2|3|4|5|6|7`)

**Return**:

- `iter` (`fun():modsCalendarWeekday`)

**Example**:

```lua
local weekdays = {}
for day in cal.weekdays() do
  weekdays[#weekdays + 1] = day
end
print(table.concat(weekdays, ", ")) --> "1, 2, 3, 4, 5, 6, 7"
```

## Fields

<a id="days"></a>

### `days` (`mods.List<string>`)

Weekday names indexed from `1` (Monday) to `7` (Sunday).

```lua
print(cal.days[1]) --> Monday
print(cal.days[7]) --> Sunday
```

<a id="firstweekday"></a>

### `firstweekday` (`1|2|3|4|5|6|7`)

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

<a id="months"></a>

### `months` (`mods.List<string>`)

Month names indexed from `1` to `12`.

```lua
print(cal.months[1])  --> January
print(cal.months[12]) --> December
```
