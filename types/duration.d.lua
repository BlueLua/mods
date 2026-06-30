---@meta _

---Representation of duration parts.
---@class mods.DurationParts
---@field milliseconds? number The millisecond component (1000 ms = 1 second).
---@field seconds?      number The second component (60 seconds = 1 minute).
---@field minutes?      number The minute component (60 minutes = 1 hour).
---@field hours?        number The hour component (24 hours = 1 day).
---@field days?         number The day component (7 days = 1 week).
---@field weeks?        number The week component.
---@field months?       number The month component (12 months = 1 year).
---@field quarters?     number The quarter component (3 months = 1 quarter).
---@field years?        number The year component.

---Rounding mode to use when humanizing durations.
---@alias mods.durationHumanizeRoundMode
---| boolean Whether to round (true) or not (false).
---| 'round' Round to the nearest integer.
---| 'floor' Round down (floor).
---| 'ceil'  Round up (ceil).

---Supported units of time for duration representation and calculations.
---@alias mods.durationUnit
---| 'ms'           Milliseconds
---| 'milliseconds' Milliseconds
---| 'millisecond'  Milliseconds
---| 's'            Seconds
---| 'secs'         Seconds
---| 'sec'          Seconds
---| 'seconds'      Seconds
---| 'second'       Seconds
---| 'm'            Minutes
---| 'mins'         Minutes
---| 'min'          Minutes
---| 'minutes'      Minutes
---| 'minute'       Minutes
---| 'h'            Hours
---| 'hours'        Hours
---| 'hour'         Hours
---| 'd'            Days
---| 'days'         Days
---| 'day'          Days
---| 'w'            Weeks
---| 'weeks'        Weeks
---| 'week'         Weeks
---| 'M'            Months
---| 'months'       Months
---| 'month'        Months
---| 'q'            Quarters
---| 'quarters'     Quarters
---| 'quarter'      Quarters
---| 'y'            Years
---| 'years'        Years
---| 'year'         Years

---Configuration options for humanizing durations into relative-style strings.
---@class mods.DurationHumanizeOptions
---@field with_suffix? boolean Whether to include `ago` / `in` style wording.
---@field short?       boolean Whether to use abbreviated unit labels like `2h`.
---@field round?       mods.durationHumanizeRoundMode Rounding mode for custom unit output.
---@field max_unit?    mods.durationUnit Largest unit allowed when choosing the displayed unit.
---@field min_unit?    mods.durationUnit Smallest unit allowed when choosing the displayed unit.

---
---Represent, calculate, and humanize time spans.
---
---## Usage
---
---```lua
---local mods = require "mods"
---local Duration = mods.duration
---
---local shift = Duration({ day = 2, hour = 3 })
---print(shift:format("D [days] HH:mm")) --> 2 days 03:00
---```
---
---@class mods.duration
local M = {}

---
---Create a duration from numeric parts, an ISO 8601 string, or another duration.
---
---```lua
---local a = Duration({ day = 2, hour = 3 })
---local b = Duration("PT1H30M")
---local c = Duration(a)
---```
---
---@param input? string|mods.DurationParts|mods.Duration Duration parts, an ISO 8601 string, or another duration.
---@return mods.Duration duration
---@nodiscard
function M.new(input) end

---
---Create a duration from a numeric amount and unit.
---
---```lua
---local d = Duration(90, "minute")
---```
---
---@param input number Numeric amount to convert into a duration.
---@param unit? mods.durationUnit Unit used with the numeric amount. Defaults to `"ms"`.
---@return mods.Duration duration
---@nodiscard
function M.new(input, unit) end

---
---Return `true` when the value is a duration created by `mods.duration(...)`.
---
---```lua
---print(Duration.is_duration(Duration({ day = 2 }))) --> true
---print(Duration.is_duration({ day = 2 }))           --> false
---```
---
---@param value any
---@return boolean isDuration
---@nodiscard
function M.is_duration(value) end

---
---Reusable immutable duration value for date arithmetic and formatting.
---
---@class mods.Duration
---@field private __index    fun(t:mods.Duration,k:any):any
---@field private __eq       fun(self: mods.Duration, other: mods.Duration): boolean
---@field private __tostring fun(self: mods.Duration): string
---@field milliseconds number Stored millisecond component.
---@field seconds      number Stored second component.
---@field minutes      number Stored minute component.
---@field hours        number Stored hour component.
---@field days         number Stored day component.
---@field months       number Stored month component.
---@field years        number Stored year component.
local Duration = {}

---
---Return a shallow copy of the duration value.
---
---```lua
---local d = Duration({ month = 1, day = 2 })
---local copy = d:clone()
---print(copy == d, rawequal(copy, d)) --> true false
---```
---
---@return mods.Duration duration
function Duration:clone() end

---
---Compare this duration to another duration-like value.
---
---Returns `-1` when smaller, `0` when equal, and `1` when larger.
---
---```lua
---print(Duration({ day = 1 }):compare({ hour = 24 })) --> 0
---```
---
---@param other number|string|mods.DurationParts|mods.Duration
---@return integer ordering
function Duration:compare(other) end

---
---Return the duration expressed in the requested unit.
---
---```lua
---local d = Duration({ day = 1, hour = 12 })
---print(d:as("hour")) --> 36
---```
---
---@param unit mods.durationUnit
---@return number amount
function Duration:as(unit) end

---
---Return a compacted duration using the module's canonical carry rules.
---
---```lua
---print(Duration({ minute = 90 }):normalize()) --> duration(hours=1, minutes=30)
---```
---
---@return mods.Duration duration
function Duration:normalize() end

---
---Return a new duration with another duration or unit amount added.
---
---```lua
---local a = Duration({ day = 2 })
---local b = a:add(3, "hour")
---print(b:format("D [days] HH:mm:ss")) --> 2 days 03:00:00
---```
---
---@param value number|mods.DurationParts|mods.Duration Signed amount to add, or another duration value.
---@param unit? mods.durationUnit Unit used when `value` is a number.
---@return mods.Duration duration
function Duration:add(value, unit) end

---
---Return a new duration with another duration or unit amount subtracted.
---
---```lua
---local a = Duration({ day = 2, hour = 3 })
---local b = a:subtract(3, "hour")
---print(b:format("D [days] HH:mm:ss")) --> 2 days 00:00:00
---```
---
---@param value number|mods.DurationParts|mods.Duration Signed amount to subtract, or another duration value.
---@param unit? mods.durationUnit Unit used when `value` is a number.
---@return mods.Duration duration
function Duration:subtract(value, unit) end

---
---Format the duration using duration tokens like `Y`, `MM`, `DD`, and `HH`.
---
---```lua
---local d = Duration({ day = 2, hour = 3, minute = 4 })
---print(d:format("D [days] HH:mm")) --> 2 days 03:04
---```
---
---@param pattern string Format pattern using supported duration tokens.
---@return string formatted
function Duration:format(pattern) end

---
---Return a human-readable relative-style phrase for the duration.
---
---By default this returns the bare phrase without `ago` / `in`. Pass `true`
---to include relative wording. You can also pass an options table for
---abbreviated output or explicit unit clamping.
---
---```lua
---local d = Duration({ day = 3 })
---print(d:humanize()) --> 3 days
---print(d:humanize(true)) --> in 3 days
---print(d:humanize({ short = true })) --> 3d
---```
---
---@param with_suffix_or_options? boolean|mods.DurationHumanizeOptions Whether to include `ago` / `in` style wording, or an options table.
---@param options? mods.DurationHumanizeOptions Additional options when the first argument is a boolean.
---@return string humanized
function Duration:humanize(with_suffix_or_options, options) end

---
---Return `true` when both duration values have identical components.
---
---```lua
---local a = Duration({ day = 2 })
---local b = Duration({ day = 2 })
---print(a:equals(b)) --> true
---```
---
---@param other any Value to compare against.
---@return boolean isEqual
function Duration:equals(other) end

---
---Return an ISO 8601 duration string.
---
---```lua
---print(Duration({ hour = 1, minute = 30 }):to_iso()) --> PT1H30M
---```
---
---@return string iso
function Duration:to_iso() end

---
---Return a debug-friendly string representation of the duration.
---
---```lua
---print(Duration({ day = 2, hour = 3 })) --> duration(days=2, hours=3)
---```
---
---@return string s
function Duration:tostring() end

---
---Return the same result as `tostring()` when coerced to a string.
---
---```lua
---print(Duration({ day = 2 })) --> duration(days=2)
---```
---
---@section Metamethods
---@return string s
function Duration:__tostring() end

---
---Return `true` when both duration values have identical components.
---
---```lua
---print(Duration({ day = 2 }) == Duration({ day = 2 })) --> true
---```
---
---@section Metamethods
---@param duration mods.Duration Duration to compare against.
---@return boolean isEqual
function Duration:__eq(duration) end

---
---Create a duration from numeric parts, an ISO 8601 string, or another duration.
---
---```lua
---local a = Duration({ day = 2, hour = 3 })
---local b = Duration("PT1H30M")
---local c = Duration(a)
---```
---
---@section Metamethods
---@param input? string|mods.DurationParts|mods.Duration Duration parts, an ISO 8601 string, or another duration.
---@return mods.Duration duration
function M:__call(input) end

---
---Create a duration from a numeric amount and unit.
---
---```lua
---local d = Duration(90, "minute")
---```
---
---@section Metamethods
---@param input number Numeric amount to convert into a duration.
---@param unit? mods.durationUnit Unit used with the numeric amount. Defaults to `"ms"`.
---@return mods.Duration duration
function M:__call(input, unit) end

return M
