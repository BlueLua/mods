---@meta _

---Representation of date components.
---@class mods.DateParts
---@field ms?    integer The millisecond of the second (`0` to `999`).
---@field sec?   integer The second of the minute (`0` to `59`).
---@field min?   integer The minute of the hour (`0` to `59`).
---@field hour?  integer The hour of the day (`0` to `23`).
---@field day?   integer The day of the month (`1` to `31`).
---@field month? integer The month of the year (`1` to `12`).
---@field year   integer The 4-digit year (e.g., `2026`).
---@field wday?  integer The weekday number (typically `1` to `7` where Sunday is `1`).
---@field yday?  integer The day of the year (`1` to `366`).
---@field isdst? boolean `true` if Daylight Saving Time (DST) is active, `false` otherwise.

---
---Create, calculate, compare, and format timezone-naive dates.
---
---> [!WARNING]
--->
---> `mods.List` `evdev.device` This module is still under development and may not be stable.
---> The API is incomplete and may change in future versions.
---
---## Usage
---
---```lua
---local Date = mods.date
---
---local a = Date("2026-03-30T14:45:06")
---local b = Date("2026-03-30 14:45:06.123")
---local c = Date("2026-03-31")
---local d = Date("12-25-1995", "MM-DD-YYYY")
---local e = Date({ year = 2026, month = 3, day = 30, hour = 14, min = 45 })
---local f = Date({ year = 2026 })
---
---print(a)                               --> 2026-03-30 14:45:06
---print(b.ms)                            --> 123
---print(a:format("YYYY/MM/DD HH:mm:ss")) --> 2026/03/30 14:45:06
---print(a:is_before(c))                  --> true
---print(a < c)                           --> true
---print(d)                               --> 1995-12-25 00:00:00
---print(e.sec)                           --> 0
---print(f)                               --> 2026-01-01 00:00:00
---```
---
---> [!NOTE]
--->
---> - String inputs accept [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)
--->   `Date(input, pattern)`
--->   (see [format tokens](https://bluelua.github.io/mods/reference/date-tokens)
--->   and [preset aliases](https://bluelua.github.io/mods/reference/date-presets)):
--->
--->   ```lua
--->   Date("2026-03-30T14:45:06")
--->   Date("2026-03-30 14:45:06")
--->   Date("12/25/1995", "MM/DD/YYYY")
--->   ```
--->
---> - When `input` is a number, it is treated as Unix milliseconds. Use
--->   [`Date.unix(ts)`](#fn-unix) if you have a timestamp in seconds.
--->
--->   ```lua
--->   local a = Date(1745155206123)       -- Milliseconds
--->   local b = Date.unix(1745155206.123) -- Seconds
--->   print(a == b)                      --> true
--->   ```
--->
---> - When calling `Date` without arguments, it uses
--->   [`timeutil`](https://github.com/BlueLua/timeutil)
--->   for millisecond precision if installed; otherwise it falls back to
--->   [`os.time`](https://www.lua.org/manual/5.1/manual.html#pdf-os.time).
---
---@class mods.date
---@overload fun(input:string, pattern:string):mods.Date
---@overload fun(input?:number|mods.DateParts):mods.Date
local M = {}

---
---Create a Date from a Unix timestamp (milliseconds) or a
---[`DateParts`](https://bluelua.github.io/mods/reference/date-parts) table.
---
---```lua
---local d1 = Date(1745155206123)
---local d2 = Date({ year = 2026, month = 3 })
---```
---
---@param input? number|mods.DateParts Unix timestamp (ms) or table of date components.
---@return mods.Date
---@nodiscard
function M.new(input) end

---
---Create a Date from a string using an optional pattern.
---
---See [format tokens](https://bluelua.github.io/mods/reference/date-tokens)
---and [preset aliases](https://bluelua.github.io/mods/reference/date-presets).
---
---```lua
---local d1 = Date("2026-03-30")
---local d2 = Date("12-25-1995", "MM-DD-YYYY")
---```
---
---@param input string The date string to parse.
---@param pattern? string The format pattern.
---@return mods.Date
---@nodiscard
function M.new(input, pattern) end

---
---Create a Date from a Unix timestamp in whole or fractional seconds.
---
---```lua
---print(Date.unix(1318781876))          --> 2011-10-16 18:17:56
---print(Date.unix(1318781876.721).year) --> 2011
---```
---
---@param timestamp number Unix timestamp in whole or fractional seconds.
---@return mods.Date date Date value for the given Unix timestamp.
function M.unix(timestamp) end

---
---Return `true` when the input can be parsed as a valid Date.
---
---See [format tokens](https://bluelua.github.io/mods/reference/date-tokens)
---and [preset aliases](https://bluelua.github.io/mods/reference/date-presets).
---
---Unlike `Date(...)`, this helper never raises for invalid input; it just
---returns `false`.
---
---```lua
---print(Date.is_valid())                           --> false
---print(Date.is_valid("2026-03-30"))               --> true
---print(Date.is_valid("2026-02-29"))               --> false
---print(Date.is_valid("12-25-1995", "MM-DD-YYYY")) --> true
---```
---
---@section Validation
---@param input? string|number|mods.DateParts Value accepted by `Date(...)`. `nil` returns `false`.
---@param pattern? string Custom parse pattern used for string input.
---@return boolean isValid Whether the input is parseable as a valid Date.
function M.is_valid(input, pattern) end

---
---Return the earliest value from the given dates.
---
---```lua
---local a = Date("2026-03-30")
---local b = Date("2026-03-28")
---print(Date.min(a, b))     --> 2026-03-28 00:00:00
---print(Date.min({ a, b })) --> 2026-03-28 00:00:00
---```
---
---@section Compare
---@param ... mods.Date|mods.Date[] Date values to compare. Each argument may be a date or a list of dates.
---@return mods.Date date Earliest date value.
function M.min(...) end

---
---Return the latest value from the given dates.
---
---```lua
---local a = Date("2026-03-30")
---local b = Date("2026-03-31")
---print(Date.max(a, b))     --> 2026-03-31 00:00:00
---print(Date.max({ a, b })) --> 2026-03-31 00:00:00
---```
---
---@section Compare
---@param ... mods.Date|mods.Date[] Date values to compare. Each argument may be a date or a list of dates.
---@return mods.Date date Latest date value.
function M.max(...) end

---
---Return the earliest and latest values from the given dates.
---
---```lua
---local a = Date("2026-03-30")
---local b = Date("2026-03-28")
---local c = Date("2026-03-31")
---local min_date, max_date = Date.minmax(a, b, c)
---print(min_date) --> 2026-03-28 00:00:00
---print(max_date) --> 2026-03-31 00:00:00
---```
---
---@section Compare
---@param ... mods.Date|mods.Date[] Date values to compare. Each argument may be a date or a list of dates.
---@return mods.Date minDate Earliest date value.
---@return mods.Date maxDate Latest date value.
function M.minmax(...) end

---
---Immutable timezone-naive datetime value.
---
---@class mods.Date
---@field private __index fun(self, k):any
---
---Year component.
---
---```lua
---print(Date("2026-03-30").year) --> 2026
---```
---@field year integer
---
---Month component.
---
---```lua
---print(Date("2026-03-30").month) --> 3
---```
---@field month mods.calendarMonth
---
---Day-of-month component.
---
---```lua
---print(Date("2026-03-30").day) --> 30
---```
---@field day mods.calendarMonthDay
---
---Hour component.
---
---```lua
---print(Date("2026-03-30T14:45:06").hour) --> 14
---```
---@field hour integer
---
---Minute component.
---
---```lua
---print(Date("2026-03-30T14:45:06").min) --> 45
---```
---@field min integer
---
---Second component.
---
---```lua
---print(Date("2026-03-30T14:45:06").sec) --> 6
---```
---@field sec integer
---
---Millisecond component.
---
---```lua
---print(Date("2026-03-30T14:45:06.123").ms) --> 123
---```
---@field ms integer
---
---ISO weekday component where Monday is `1` and Sunday is `7`.
---
---```lua
---print(Date("2026-03-30").wday) --> 1
---```
---@field wday mods.calendarWeekday
---
---Day-of-year component starting at `1`.
---
---```lua
---print(Date("2026-03-30").yday) --> 89
---```
---@field yday integer
local Date = {}

---
---Return or set the locale-relative weekday like Day.js `weekday()`.
---
---```lua
---local d = Date("2026-03-30")
---print(d:weekday())   --> 0
---print(d:weekday(7))  --> 2026-04-06 00:00:00
---print(d:weekday(-7)) --> 2026-03-23 00:00:00
---```
---
---The getter returns a number in the range `0..6`, relative to the current
---`mods.calendar.firstweekday`. Passing an integer returns a shifted copy in
---the same locale-relative week space, with negative and overflow values
---moving into previous or next weeks.
---
---
---@section Calendar
---@param weekday_number? integer Locale-relative weekday to set.
---@return integer|mods.Date weekdayOrDate Current locale-relative weekday number, or a shifted Date when `weekday_number` is provided.
---@nodiscard
function Date:weekday(weekday_number) end

---
---Return or set the quarter of the year.
---
---```lua
---local d = Date("2026-03-30")
---print(d:quarter())  --> 1
---print(d:quarter(2)) --> 2026-06-30 00:00:00
---```
---
---@section Calendar
---@param quarter_number? integer Quarter to set.
---@return integer|mods.Date quarterOrDate Current quarter number, or a shifted Date when `quarter_number` is provided.
---@nodiscard
function Date:quarter(quarter_number) end

---
---Return or set the day of the year.
---
---```lua
---local d = Date("2026-03-30")
---print(d:day_of_year())  --> 89
---print(d:day_of_year(1)) --> 2026-01-01 00:00:00
---```
---
---@section Calendar
---@param day_of_year_number? integer Day-of-year to set.
---@return integer|mods.Date dayOrDate Current day-of-year number, or a shifted Date when `day_of_year_number` is provided.
---@nodiscard
function Date:day_of_year(day_of_year_number) end

---
---Return or set the non-ISO week-of-year number.
---
---```lua
---local d = Date("2026-03-30")
---print(d:week())   --> 14
---print(d:week(15)) --> 2026-04-06 00:00:00
---```
---
---@section Calendar
---@param week_number? integer Week number to set.
---@return integer|mods.Date weekOrDate Current week-of-year number, or a shifted Date when `week_number` is provided.
---@nodiscard
function Date:week(week_number) end

---
---Return the non-ISO week-year for the current date.
---
---```lua
---print(Date("2021-01-01"):week_year()) --> 2021
---```
---
---@section Calendar
---@return integer weekYear Week-year.
---@nodiscard
function Date:week_year() end

---
---Return the number of weeks in the current locale week-year.
---
---```lua
---print(Date("2026-03-30"):weeks_in_year()) --> 52
---```
---
---@section Calendar
---@return integer weeksInYear Number of weeks.
---@nodiscard
function Date:weeks_in_year() end

---
---Return or set the ISO week-of-year number.
---
---```lua
---local d = Date("2026-03-30")
---print(d:iso_week())   --> 14
---print(d:iso_week(15)) --> 2026-04-06 00:00:00
---```
---
---@section Calendar
---@param iso_week_number? integer ISO week number to set.
---@return integer|mods.Date isoWeekOrDate Current ISO week number, or a shifted Date when `iso_week_number` is provided.
---@nodiscard
function Date:iso_week(iso_week_number) end

---
---Return or set the ISO weekday number where Monday is `1` and Sunday is `7`.
---
---```lua
---local d = Date("2026-03-30")
---print(d:iso_weekday())  --> 1
---print(d:iso_weekday(7)) --> 2026-04-05 00:00:00
---```
---
---@section Calendar
---@param iso_weekday_number? integer ISO weekday to set.
---@return mods.calendarWeekday|mods.Date isoWeekdayOrDate Current ISO weekday number, or a shifted Date when `iso_weekday_number` is provided.
---@nodiscard
function Date:iso_weekday(iso_weekday_number) end

---
---Return the ISO week-year for the current date.
---
---```lua
---print(Date("2021-01-01"):iso_week_year()) --> 2020
---```
---
---@section Calendar
---@return integer isoWeekYear ISO week-year.
---@nodiscard
function Date:iso_week_year() end

---
---Return the number of ISO weeks in the current date's calendar year.
---
---```lua
---local d = Date("2016-01-01")
---print(Date("2016-01-01"):iso_weeks_in_year()) --> 52
---print(Date("2016-06-01"):iso_weeks_in_year()) --> 52
---```
---
---@section Calendar
---@return integer isoWeeksInYear Number of ISO weeks in the current date's calendar year.
---@nodiscard
function Date:iso_weeks_in_year() end

---
---Return `true` when the value's year is a leap year.
---
---```lua
---print(Date("2024-02-29"):is_leap_year()) --> true
---```
---
---@section Calendar
---@return boolean isLeapYear Whether the year is a leap year.
---@nodiscard
function Date:is_leap_year() end

---
---Return the number of days in the value's month.
---
---```lua
---print(Date("2024-02-01"):month_days()) --> 29
---```
---
---@section Calendar
---@return mods.calendarMonthDay ndays Number of days in the current month.
---@nodiscard
function Date:month_days() end

---
---Format the Date with tokens like `YYYY`, `MMM`, `dddd`, `Do`, `Q`, `hh`,
---`k`, `X`, `x`, `A`, and `SSS`.
---
---```lua
---local d = Date("2026-03-30T14:45:06.123")
---local ts = Date(1523520536123)
---print(d:format("YYYY/MM/DD HH:mm:ss.SSS")) --> 2026/03/30 14:45:06.123
---print(d:format("ddd, MMM Do YYYY h:mm A")) --> Mon, Mar 30th 2026 2:45 PM
---print(d:format("LLLL"))                    --> Monday, March 30, 2026 2:45 PM
---print(d:format("GGGG-[W]WW"))              --> 2026-W14
---print(ts:format("X x"))                    --> 1523520536 1523520536123
---```
---
---> [!NOTE]
--->
---> Wrap literal text in `[...]` to escape it, for example:
--->
---> ```lua
---> d:format("GGGG-[W]WW") -- 2026-W14
---> d:format("[hours:]HH") -- hours:14
---> ```
---See [format tokens](https://bluelua.github.io/mods/reference/date-tokens)
---and [preset aliases](https://bluelua.github.io/mods/reference/date-presets).
---
---@section Formatting
---@param pattern string Format pattern using supported tokens.
---@return string formatted Formatted datetime string.
---@nodiscard
function Date:format(pattern) end

---
---Return the default string form `YYYY-MM-DD HH:mm:ss`.
---
---```lua
---print(Date("2026-03-30T14:45:06.123")) --> 2026-03-30 14:45:06.123
---```
---
---@section Formatting
---@return string s Default datetime string.
---@nodiscard
function Date:tostring() end

---
---Return a copy shifted by the given amount and unit.
---
---```lua
---local d = Date("2026-03-30T14:45:06")
---
---print(d:add(2, "day"))               --> 2026-04-01 14:45:06
---print(d:add(1, "quarter"))           --> 2026-06-30 14:45:06
---print(d:add(1, "month"))             --> 2026-04-30 14:45:06
---print(d:add(250, "ms"))              --> 2026-03-30 14:45:06.250
---print(d:add({ month = 1, day = 2 })) --> 2026-05-02 14:45:06
---```
---
---@section Arithmetic
---@param amount integer|mods.DurationParts Signed amount to add, or a duration-style table.
---@param unit? mods.durationUnit Unit for the addition.
---@return mods.Date shifted Shifted date value.
---@nodiscard
function Date:add(amount, unit) end

---
---Return a copy shifted backward by the given amount and unit.
---
---```lua
---local d = Date("2026-03-30T14:45:06")
---print(d:subtract(2, "day"))               --> 2026-03-28 14:45:06
---print(d:subtract(1, "quarter"))           --> 2025-12-30 14:45:06
---print(d:subtract(1, "month"))             --> 2026-02-28 14:45:06
---print(d:subtract(250, "ms"))              --> 2026-03-30 14:45:05.750
---print(d:subtract({ month = 1, day = 1 })) --> 2026-02-27 14:45:06
---```
---
---@section Arithmetic
---@param amount integer|mods.DurationParts Signed amount to subtract, or a duration-style table.
---@param unit? mods.durationUnit Unit for the subtraction.
---@return mods.Date shifted Shifted date value.
---@nodiscard
function Date:subtract(amount, unit) end

---
---Return the signed difference to another Date in the requested unit.
---
---```lua
---local a = Date("2026-03-30T12:00:00")
---local b = Date("2026-02-28T12:00:00")
---print(a:diff(b, "month")) --> 1
---print(a:diff(b, "day"))   --> 30
---```
---
---@section Arithmetic
---@param date mods.Date Date to compare against.
---@param unit? mods.durationUnit Unit used for the difference. Defaults to `"ms"`.
---@return integer delta Signed difference in whole units.
---@nodiscard
function Date:diff(date, unit) end

---
---Return `true` when the value is earlier than `other`.
---
---```lua
---local a = Date("2026-03-30T12:00:00")
---local b = Date("2026-03-31T12:00:00")
---print(a:is_before(b)) --> true
---```
---
---@section Comparison
---@param date mods.Date Date to compare against.
---@return boolean isBefore Whether the value is earlier than `date`.
---@nodiscard
function Date:is_before(date) end

---
---Return `true` when the value is equal to `other`.
---
---```lua
---local a = Date("2026-03-30T12:00:00")
---local b = Date("2026-03-30T12:00:00")
---print(a:is_same(b)) --> true
---```
---
---@section Comparison
---@param date mods.Date Date to compare against.
---@return boolean isSame Whether the value is equal to `date`.
---@nodiscard
function Date:is_same(date) end

---
---Return `true` when the value is earlier than or equal to `other`.
---
---```lua
---local a = Date("2026-03-30T12:00:00")
---local b = Date("2026-03-30T12:00:00")
---local c = Date("2026-03-31T12:00:00")
---print(a:is_same_or_before(b)) --> true
---print(a:is_same_or_before(c)) --> true
---```
---
---@section Comparison
---@param date mods.Date Date to compare against.
---@return boolean isSameOrBefore Whether the value is earlier than or equal to `date`.
---@nodiscard
function Date:is_same_or_before(date) end

---
---Return `true` when the value is later than `other`.
---
---```lua
---local a = Date("2026-03-31T12:00:00")
---local b = Date("2026-03-30T12:00:00")
---print(a:is_after(b)) --> true
---```
---
---@section Comparison
---@param date mods.Date Date to compare against.
---@return boolean isAfter Whether the value is later than `date`.
---@nodiscard
function Date:is_after(date) end

---
---Return `true` when the value is later than or equal to `other`.
---
---```lua
---local a = Date("2026-03-31T12:00:00")
---local b = Date("2026-03-30T12:00:00")
---local c = Date("2026-03-31T12:00:00")
---print(a:is_same_or_after(b)) --> true
---print(a:is_same_or_after(c)) --> true
---```
---
---@section Comparison
---@param date mods.Date Date to compare against.
---@return boolean isSameOrAfter Whether the value is later than or equal to `date`.
---@nodiscard
function Date:is_same_or_after(date) end

---
---Return `true` when the value falls on the current local day.
---
---```lua
---print(Date():is_today()) --> true
---```
---
---@section Comparison
---@return boolean isToday Whether the value is on today in local time.
---@nodiscard
function Date:is_today() end

---
---Return `true` when the value falls on the next local day.
---
---```lua
---print(Date():add(1, "day"):is_tomorrow()) --> true
---```
---
---@section Comparison
---@return boolean isTomorrow Whether the value is on tomorrow in local time.
---@nodiscard
function Date:is_tomorrow() end

---
---Return `true` when the value falls on the previous local day.
---
---```lua
---print(Date():subtract(1, "day"):is_yesterday()) --> true
---```
---
---@section Comparison
---@return boolean isYesterday Whether the value is on yesterday in local time.
---@nodiscard
function Date:is_yesterday() end

---
---Return `true` when the value lies between two bounds.
---
---Bounds may be passed in either order. By default the comparison is
---exclusive; pass `true` as the third argument to include the endpoints.
---
---```lua
---local d = Date("2026-03-30T12:00:00")
---local a = Date("2026-03-30T00:00:00")
---local b = Date("2026-03-31T00:00:00")
---print(d:is_between(a, b))        --> true
---print(a:is_between(a, b))        --> false
---print(a:is_between(a, b, true))  --> true
---```
---
---@section Comparison
---@param start_date mods.Date One bound.
---@param end_date mods.Date The other bound.
---@param inclusive? boolean Whether to include the endpoints. Defaults to `false`.
---@return boolean isBetween Whether the value lies between the two bounds.
---@nodiscard
function Date:is_between(start_date, end_date, inclusive) end

---
---Return the start boundary for the given unit.
---
---```lua
---local d = Date("2026-03-30T14:45:06")
---print(d:startof("day"))     --> 2026-03-30 00:00:00
---print(d:startof("quarter")) --> 2026-01-01 00:00:00
---print(d:startof("isoWeek")) --> 2026-03-30 00:00:00
---```
---
---`"isoWeek"` is also supported here as a boundary-only unit.
---
---@section Boundaries
---@param unit mods.durationUnit|"isoWeek" Boundary unit.
---@return mods.Date bounded Date clamped to the start of the unit.
---@nodiscard
function Date:startof(unit) end

---
---Return the end boundary for the given unit.
---
---```lua
---local d = Date("2026-03-30T14:45:06")
---print(d:endof("month"))   --> 2026-03-31 23:59:59
---print(d:endof("week"))    --> 2026-04-05 23:59:59
---print(d:endof("isoWeek")) --> 2026-04-05 23:59:59
---```
---
---`"isoWeek"` is also supported here as a boundary-only unit.
---
---@section Boundaries
---@param unit mods.durationUnit|"isoWeek" Boundary unit.
---@return mods.Date bounded Date clamped to the end of the unit.
---@nodiscard
function Date:endof(unit) end

---
---Return relative time from another Date to this one.
---
---By default the result includes a suffix like `ago` or a prefix like `in`.
---Pass `true` to omit that suffix or prefix.
---
---```lua
---local a = date("2026-03-30T14:45:06")
---local b = date("2026-03-30T12:45:06")
---print(a:from(b))       --> in 2 hours
---print(a:from(b, true)) --> 2 hours
---```
---
---@section Relative Time
---@param date mods.Date Reference date.
---@param without_suffix? boolean Whether to omit `ago` / `in`.
---@return string relative Relative time string.
---@nodiscard
function Date:from(date, without_suffix) end

---
---Return relative time from this Date to another one.
---
---By default the result includes a suffix like `ago` or a prefix like `in`.
---Pass `true` to omit that suffix or prefix.
---
---```lua
---local a = date("2026-03-30T12:45:06")
---local b = date("2026-03-30T14:45:06")
---print(a:to(b))       --> in 2 hours
---print(a:to(b, true)) --> 2 hours
---```
---
---@section Relative Time
---@param date mods.Date Reference date.
---@param without_suffix? boolean Whether to omit `ago` / `in`.
---@return string relative Relative time string.
---@nodiscard
function Date:to(date, without_suffix) end

---
---Return relative time from the current local time to this Date.
---
---```lua
---local d = date():add(1, "day")
---print(d:from_now()) --> in a day
---```
---
---@section Relative Time
---@param without_suffix? boolean Whether to omit `ago` / `in`.
---@return string relative Relative time string.
---@nodiscard
function Date:from_now(without_suffix) end

---
---Return relative time from this Date to the current local time.
---
---```lua
---local d = date():subtract(1, "day")
---print(d:to_now()) --> in a day
---```
---
---@section Relative Time
---@param without_suffix? boolean Whether to omit `ago` / `in`.
---@return string relative Relative time string.
---@nodiscard
function Date:to_now(without_suffix) end

---
---Return a copy shifted by integer milliseconds.
---
---This works as either `date + ms` or `ms + date`.
---
---```lua
---local d = Date("2026-03-30T14:45:06")
---print((d + 250)) --> 2026-03-30 14:45:06.250
---print((250 + d)) --> 2026-03-30 14:45:06.250
---```
---
---@section Metamethods
---@param a integer|mods.Date Milliseconds to add, or another Date.
---@param b integer|mods.Date Milliseconds to add, or another Date.
---@return mods.Date sum Sum of the two dates.
function Date.__add(a, b) end

---
---Return either a shifted copy or a millisecond delta.
---
---When subtracting an integer, it shifts by that many milliseconds. When
---subtracting another Date, it returns the signed millisecond difference.
---
---```lua
---local a = Date("2026-03-30T14:45:06.250")
---local b = Date("2026-03-30T14:45:06")
---print((a - 250)) --> 2026-03-30 14:45:06
---print(a - b)     --> 250
---```
---
---@section Metamethods
---@param a integer|mods.Date Milliseconds to subtract, or another Date.
---@param b integer|mods.Date Milliseconds to subtract, or another Date.
---@return mods.Date|integer delta Difference between dates.
function Date:__sub(a, b) end

---
---Return the same result as `tostring()` when coerced to a string.
---
---```lua
---print(Date("2026-03-30T14:45:06")) --> 2026-03-30 14:45:06
---```
---
---@section Metamethods
---@return string string representation of the date.
function Date:__tostring() end

---
---Return `true` when both Date values have identical components.
---
---```lua
---print(Date("2026-03-30") == Date("2026-03-30")) --> true
---```
---
---@section Metamethods
---@param date mods.Date Date to compare against.
---@return boolean isEqual `true` if both dates are equal, `false` otherwise.
function Date:__eq(date) end

---
---Return `true` when the left Date is earlier than the right.
---
---```lua
---print(Date("2026-03-30") < Date("2026-03-31")) --> true
---```
---
---@section Metamethods
---@param date mods.Date Date to compare against.
---@return boolean isEarlier `true` if the left date is earlier, `false` otherwise.
function Date:__lt(date) end

---
---Return `true` when the left Date is earlier than or equal to the right.
---
---```lua
---print(Date("2026-03-30") <= Date("2026-03-30")) --> true
---```
---
---@section Metamethods
---@param date mods.Date Date to compare against.
---@return boolean isEarlierOrEqual `true` if the left date is earlier or equal, `false` otherwise.
function Date:__le(date) end

return M
