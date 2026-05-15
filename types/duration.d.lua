---@meta mods.duration

---@alias mods.DurationParts {milliseconds:number?, seconds:number?, minutes:number?, hours:number?, days:number?, weeks:number?, months:number?, quarters:number?, years:number?}
---@alias mods.DurationHumanizeRoundMode boolean|'round'|'floor'|'ceil'

---@class mods.DurationHumanizeOptions
---@field with_suffix? boolean Whether to include `ago` / `in` style wording.
---@field short? boolean Whether to use abbreviated unit labels like `2h`.
---@field round? mods.DurationHumanizeRoundMode Rounding mode for custom unit output.
---@field max_unit? mods.DateUnit Largest unit allowed when choosing the displayed unit.
---@field min_unit? mods.DateUnit Smallest unit allowed when choosing the displayed unit.

---
---Reusable immutable duration values for date arithmetic and formatting.
---
---## Usage
---
---```lua
---local Duration = require "mods.duration"
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
---@param unit? mods.DateUnit Unit used with the numeric amount. Defaults to `"ms"`.
---@return mods.Duration duration
---@nodiscard
function M.new(input, unit) end

---
---Return `true` when the value is a duration created by `mods.duration(...)`
---or `mods.date.duration(...)`.
---
---```lua
---local Duration = require "mods.duration"
---print(Duration.is_duration(Duration({ day = 2 }))) --> true
---print(Duration.is_duration({ day = 2 })) --> false
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
---local Duration = require "mods.duration"
---local d = Duration({ month = 1, day = 2 })
---local copy = d:clone()
---print(copy == d, rawequal(copy, d)) --> true false
---```
---
---@section Duration
---@return mods.Duration duration
function Duration:clone() end

---
---Compare this duration to another duration-like value.
---
---Returns `-1` when smaller, `0` when equal, and `1` when larger.
---
---```lua
---local Duration = require "mods.duration"
---print(Duration({ day = 1 }):compare({ hour = 24 })) --> 0
---```
---
---@section Duration
---@param other number|string|mods.DurationParts|mods.Duration
---@return integer ordering
function Duration:compare(other) end

---
---Return the duration expressed in the requested unit.
---
---```lua
---local Duration = require "mods.duration"
---local d = Duration({ day = 1, hour = 12 })
---print(d:as("hour")) --> 36
---```
---
---@section Duration
---@param unit mods.DateUnit
---@return number amount
function Duration:as(unit) end

---
---Return a compacted duration using the module's canonical carry rules.
---
---```lua
---local Duration = require "mods.duration"
---print(Duration({ minute = 90 }):normalize()) --> duration(hours=1, minutes=30)
---```
---
---@section Duration
---@return mods.Duration duration
function Duration:normalize() end

---
---Return a new duration with another duration or unit amount added.
---
---```lua
---local Duration = require "mods.duration"
---local a = Duration({ day = 2 })
---local b = a:add(3, "hour")
---print(b:format("D [days] HH:mm:ss")) --> 2 days 03:00:00
---```
---
---@section Duration
---@param value number|mods.DurationParts|mods.Duration Signed amount to add, or another duration value.
---@param unit? mods.DateUnit Unit used when `value` is a number.
---@return mods.Duration duration
function Duration:add(value, unit) end

---
---Return a new duration with another duration or unit amount subtracted.
---
---```lua
---local Duration = require "mods.duration"
---local a = Duration({ day = 2, hour = 3 })
---local b = a:subtract(3, "hour")
---print(b:format("D [days] HH:mm:ss")) --> 2 days 00:00:00
---```
---
---@section Duration
---@param value number|mods.DurationParts|mods.Duration Signed amount to subtract, or another duration value.
---@param unit? mods.DateUnit Unit used when `value` is a number.
---@return mods.Duration duration
function Duration:subtract(value, unit) end

---
---Format the duration using duration tokens like `Y`, `MM`, `DD`, and `HH`.
---
---```lua
---local Duration = require "mods.duration"
---local d = Duration({ day = 2, hour = 3, minute = 4 })
---print(d:format("D [days] HH:mm")) --> 2 days 03:04
---```
---
---@section Duration
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
---local Duration = require "mods.duration"
---local d = Duration({ day = 3 })
---print(d:humanize()) --> 3 days
---print(d:humanize(true)) --> in 3 days
---print(d:humanize({ short = true })) --> 3d
---```
---
---@section Duration
---@param with_suffix_or_options? boolean|mods.DurationHumanizeOptions Whether to include `ago` / `in` style wording, or an options table.
---@param options? mods.DurationHumanizeOptions Additional options when the first argument is a boolean.
---@return string humanized
function Duration:humanize(with_suffix_or_options, options) end

---
---Return `true` when both duration values have identical components.
---
---```lua
---local Duration = require "mods.duration"
---local a = Duration({ day = 2 })
---local b = Duration({ day = 2 })
---print(a:equals(b)) --> true
---```
---
---@section Duration
---@param other any Value to compare against.
---@return boolean isEqual
function Duration:equals(other) end

---
---Return an ISO 8601 duration string.
---
---```lua
---local Duration = require "mods.duration"
---print(Duration({ hour = 1, minute = 30 }):to_iso()) --> PT1H30M
---```
---
---@section Duration
---@return string iso
function Duration:to_iso() end

---
---Return a debug-friendly string representation of the duration.
---
---```lua
---local Duration = require "mods.duration"
---print(Duration({ day = 2, hour = 3 })) --> duration(days=2, hours=3)
---```
---
---@section Duration
---@return string s
function Duration:tostring() end

---
---Return the same result as `tostring()` when coerced to a string.
---
---```lua
---local Duration = require "mods.duration"
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
---local Duration = require "mods.duration"
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
---local Duration = require "mods.duration"
---local a = Duration({ day = 2, hour = 3 })
---local b = Duration("PT1H30M")
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
---local Duration = require "mods.duration"
---local d = Duration(90, "minute")
---```
---
---@section Metamethods
---@param input number Numeric amount to convert into a duration.
---@param unit? mods.DateUnit Unit used with the numeric amount. Defaults to `"ms"`.
---@return mods.Duration duration
function M:__call(input, unit) end

return M
