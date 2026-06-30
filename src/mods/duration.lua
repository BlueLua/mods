---@diagnostic disable: missing-fields

-- TODO: refactor this module later and add more test cases.

local date_duration = require "mods._date_duration"
local mods = require "mods"

local Set = mods.set
local List = mods.list
local render_format_pattern = date_duration.render
local utils = mods.utils

local assert_arg = utils.assert_arg
local compact_duration = date_duration.compact_duration
local copy_duration_fields = date_duration.copy_duration_fields
local zero_duration = date_duration.zero_duration
local add_duration_value = date_duration.add_duration_value
local split_signed = date_duration.split_signed

local abs = math.abs
local ceil = math.ceil
local concat = table.concat
local floor = math.floor
local fmt = string.format
local gsub = string.gsub
local match = string.match
local rep = string.rep
local sub = string.sub

local format_number, total_ms, total_days, total_months

-- stylua: ignore start
local SECONDS_PER_MINUTE = 60
local SECONDS_PER_HOUR   = 60 * SECONDS_PER_MINUTE
local SECONDS_PER_DAY    = 24 * SECONDS_PER_HOUR
local MS_PER_SECOND      = 1000
local MS_PER_DAY         = SECONDS_PER_DAY * MS_PER_SECOND

local HUMANIZE_UNIT_ORDER =
  { "years", "quarters", "months", "weeks", "days", "hours", "minutes", "seconds", "milliseconds" }
local HUMANIZE_UNIT_INDEX = List(HUMANIZE_UNIT_ORDER):invert()
local HUMANIZE_UNITS = {
  years        = { singular = "year"       , plural = "years"       , short = "y"  },
  quarters     = { singular = "quarter"    , plural = "quarters"    , short = "q"  },
  months       = { singular = "month"      , plural = "months"      , short = "mo" },
  weeks        = { singular = "week"       , plural = "weeks"       , short = "w"  },
  days         = { singular = "day"        , plural = "days"        , short = "d"  },
  hours        = { singular = "hour"       , plural = "hours"       , short = "h"  },
  minutes      = { singular = "minute"     , plural = "minutes"     , short = "m"  },
  seconds      = { singular = "second"     , plural = "seconds"     , short = "s"  },
  milliseconds = { singular = "millisecond", plural = "milliseconds", short = "ms" },
}

local DURATION_UNITS      = date_duration.duration_units
local DURATION_UNIT_NAMES = date_duration.duration_unit_names
local DURATION_TOKENS_1   = Set({ "Y" , "M" , "D" , "H" , "m" , "s"  })
local DURATION_TOKENS_2   = Set({ "YY", "MM", "DD", "HH", "mm", "ss" })
local DURATION_FORMATTERS = {
  Y    = function(t) return format_number(t.years)                end,
  YY   = function(t) return format_number(abs(t.years) % 100, 2)  end,
  YYYY = function(t) return format_number(abs(t.years), 4)        end,
  M    = function(t) return format_number(t.months)               end,
  MM   = function(t) return format_number(abs(t.months), 2)       end,
  D    = function(t) return format_number(t.days)                 end,
  DD   = function(t) return format_number(abs(t.days), 2)         end,
  H    = function(t) return format_number(t.hours)                end,
  HH   = function(t) return format_number(abs(t.hours), 2)        end,
  m    = function(t) return format_number(t.minutes)              end,
  mm   = function(t) return format_number(abs(t.minutes), 2)      end,
  s    = function(t) return format_number(t.seconds)              end,
  ss   = function(t) return format_number(abs(t.seconds), 2)      end,
  SSS  = function(t) return format_number(abs(t.milliseconds), 3) end,
}
local DURATION_TOTAL_FIELDS = {
  milliseconds = function (self) return total_ms(self)                                        end,
  seconds      = function (self) return total_ms(self) / MS_PER_SECOND                        end,
  minutes      = function (self) return total_ms(self) / (SECONDS_PER_MINUTE * MS_PER_SECOND) end,
  hours        = function (self) return total_ms(self) / (SECONDS_PER_HOUR * MS_PER_SECOND)   end,
  days         = function (self) return total_days(self)                                      end,
  weeks        = function (self) return total_days(self) / 7                                  end,
  months       = function (self) return total_months(self)                                    end,
  quarters     = function (self) return total_months(self) / 3                                end,
  years        = function (self) return total_months(self) / 12                               end,
}
-- stylua: ignore end

---@type mods.duration
local M = {}

---@type mods.Duration
local Duration = {}

local function new_duration(parts)
  local out = {}
  for _, unit in ipairs(DURATION_UNITS) do
    out[unit] = parts[unit] or 0
  end
  return setmetatable(out, Duration)
end

local function time_ms(d)
  return d.hours * SECONDS_PER_HOUR * MS_PER_SECOND
    + d.minutes * SECONDS_PER_MINUTE * MS_PER_SECOND
    + d.seconds * MS_PER_SECOND
    + d.milliseconds
end

-- stylua: ignore start
local function is_duration(value)     return getmetatable(value) == Duration       end
local function clone_duration(d)      return new_duration(copy_duration_fields(d)) end
local function month_units(d)         return d.years * 12 + d.months               end
local function months_to_days(months) return months * 146097 / 4800                end
local function days_to_months(days)   return days * 4800 / 146097                  end

function total_months(d) return month_units(d) + days_to_months(d.days + time_ms(d) / MS_PER_DAY)              end
function total_days(d)   return months_to_days(month_units(d)) + d.days + time_ms(d) / MS_PER_DAY              end
function total_ms(d)     return months_to_days(month_units(d)) * MS_PER_DAY + d.days * MS_PER_DAY + time_ms(d) end
-- stylua: ignore end

function format_number(v, width)
  if v % 1 == 0 then
    if width == nil then
      return tostring(v)
    end
    return fmt("%0" .. width .. "d", v)
  end
  return fmt("%.15g", v)
end

---@type fun(delta:table, level:integer?):table<string, number>
local function normalize_duration(delta, lvl)
  assert_arg(1, delta, "table")

  if is_duration(delta) then
    return copy_duration_fields(delta)
  end

  local normalized = zero_duration()

  for key, value in pairs(delta) do
    if not DURATION_UNIT_NAMES[key] then
      error(fmt("bad duration key %q", tostring(key)), lvl or 3)
    end
    if type(value) ~= "number" then
      error(fmt("bad duration value for %s; number expected, got %s", tostring(key), tostring(value)), lvl or 3)
    end

    add_duration_value(normalized, key, value)
  end

  return normalized
end

local function humanize_delta_ms(delta_ms, approx_months, without_suffix)
  local future = delta_ms > 0
  local seconds = abs(delta_ms) / MS_PER_SECOND
  local phrase

  if seconds < 45 then
    phrase = "a few seconds"
  elseif seconds < 90 then
    phrase = "a minute"
  else
    local minutes = seconds / SECONDS_PER_MINUTE
    if minutes < 45 then
      phrase = fmt("%d minutes", floor(minutes + 0.5))
    elseif minutes < 90 then
      phrase = "an hour"
    else
      local hours = minutes / SECONDS_PER_MINUTE
      if hours < 22 then
        phrase = fmt("%d hours", floor(hours + 0.5))
      elseif hours < 36 then
        phrase = "a day"
      else
        local days = hours / 24
        if days < 26 then
          phrase = fmt("%d days", floor(days + 0.5))
        elseif days < 45 then
          phrase = "a month"
        elseif approx_months < 12 then
          phrase = fmt("%d months", approx_months)
        elseif approx_months < 18 then
          phrase = "a year"
        else
          phrase = fmt("%d years", floor((approx_months + 6) / 12))
        end
      end
    end
  end

  if without_suffix then
    return phrase
  end
  return future and ("in " .. phrase) or (phrase .. " ago")
end

local function humanize_round(v, mode)
  if mode == nil or mode == true or mode == "round" then
    return floor(v + 0.5)
  elseif mode == false or mode == "floor" then
    return floor(v)
  elseif mode == "ceil" then
    return ceil(v)
  end
  error(fmt("bad humanize round mode %q", tostring(mode)), 4)
end

local function humanize_phrase(amount, unit, short)
  local lbl = HUMANIZE_UNITS[unit]
  if short then
    return tostring(amount) .. lbl.short
  elseif amount == 1 then
    return "1 " .. lbl.singular
  end
  return tostring(amount) .. " " .. lbl.plural
end

local function humanize_custom(self, opts)
  local max_field = opts.max_unit and DURATION_UNIT_NAMES[opts.max_unit] or HUMANIZE_UNIT_ORDER[1]
  local min_field = opts.min_unit and DURATION_UNIT_NAMES[opts.min_unit] or HUMANIZE_UNIT_ORDER[#HUMANIZE_UNIT_ORDER]
  local max_index = HUMANIZE_UNIT_INDEX[max_field]
  local min_index = HUMANIZE_UNIT_INDEX[min_field]

  if not (max_index and min_index) then
    error("bad humanize unit range", 4)
  elseif max_index > min_index then
    error(fmt("bad humanize unit range %q..%q", tostring(opts.max_unit), tostring(opts.min_unit)), 4)
  end

  local chosen = HUMANIZE_UNIT_ORDER[min_index]
  for i = max_index, min_index do
    local unit = HUMANIZE_UNIT_ORDER[i]
    if abs(DURATION_TOTAL_FIELDS[unit](self)) >= 1 then
      chosen = unit
      break
    end
  end

  local amount = humanize_round(abs(DURATION_TOTAL_FIELDS[chosen](self)), opts.round)
  local phrase = humanize_phrase(amount, chosen, opts.short)
  local a = total_ms(self)
  local b = total_ms(M.new())
  local sign = a < b and -1 or a > b and 1 or 0

  if opts.with_suffix then
    if sign > 0 then
      return "in " .. phrase
    elseif sign < 0 then
      return phrase .. " ago"
    end
  end
  return phrase
end

local function add_duration(self, other, sign)
  local out = clone_duration(self)
  local delta = M.new(other)
  for _, unit in ipairs(DURATION_UNITS) do
    out[unit] = out[unit] + sign * delta[unit]
  end
  return out
end

local function parse_iso_integer(raw, input, level)
  local v = tonumber(raw)
  if v == nil or v % 1 ~= 0 then
    error(fmt("bad ISO 8601 duration %q", input), level or 3)
  end
  return v
end

local function parse_iso_seconds(raw, input, level)
  local sign = 1
  local head = sub(raw, 1, 1)
  if head == "-" then
    sign = -1
    raw = sub(raw, 2)
  elseif head == "+" then
    raw = sub(raw, 2)
  end

  local seconds, fraction = match(raw, "^(%d+)[.,](%d+)$")
  if not seconds then
    return sign * parse_iso_integer(raw, input, level), 0
  end
  if #fraction > 3 then
    error(fmt("bad ISO 8601 duration %q; fractional seconds must use at most 3 digits", input), level or 3)
  end

  return sign * tonumber(seconds), sign * tonumber(fraction .. rep("0", 3 - #fraction))
end

local function take_iso_component(part, pattern)
  local value
  local out = gsub(part, pattern, function(v)
    value = v
    return ""
  end, 1)
  return out, value
end

local function parse_iso_duration(input, lvl)
  local sign, body = match(input, "^([+-]?)P(.+)$")
  if not body then
    error(fmt("bad ISO 8601 duration %q", input), lvl or 3)
  end

  local parts = zero_duration()
  local applied = false
  local factor = sign == "-" and -1 or 1
  local date_part, time_part = match(body, "^([^T]*)(.*)$")
  local time_body = time_part ~= "" and match(time_part, "^T(.*)$") or ""
  local v

  date_part, v = take_iso_component(date_part, "([+-]?%d+)Y")
  if v then
    parts.years = parts.years + factor * parse_iso_integer(v, input, lvl)
    applied = true
  end

  date_part, v = take_iso_component(date_part, "([+-]?%d+)M")
  if v then
    parts.months = parts.months + factor * parse_iso_integer(v, input, lvl)
    applied = true
  end

  date_part, v = take_iso_component(date_part, "([+-]?%d+)W")
  if v then
    parts.days = parts.days + factor * parse_iso_integer(v, input, lvl) * 7
    applied = true
  end

  date_part, v = take_iso_component(date_part, "([+-]?%d+)D")
  if v then
    parts.days = parts.days + factor * parse_iso_integer(v, input, lvl)
    applied = true
  end

  if time_body then
    time_body, v = take_iso_component(time_body, "([+-]?%d+)H")
    if v then
      parts.hours = parts.hours + factor * parse_iso_integer(v, input, lvl)
      applied = true
    end

    time_body, v = take_iso_component(time_body, "([+-]?%d+)M")
    if v then
      parts.minutes = parts.minutes + factor * parse_iso_integer(v, input, lvl)
      applied = true
    end

    time_body, v = take_iso_component(time_body, "([+-]?%d+[.,]?%d*)S")
    if v then
      local seconds, milliseconds = parse_iso_seconds(v, input, lvl)
      parts.seconds = parts.seconds + factor * seconds
      parts.milliseconds = parts.milliseconds + factor * milliseconds
      applied = true
    end
  end

  if not applied or date_part ~= "" or time_body ~= "" then
    error(fmt("bad ISO 8601 duration %q", input), lvl or 3)
  end

  return new_duration(parts)
end

local function format_iso_seconds(ms)
  if ms == 0 then
    return
  end

  local sign = ms < 0 and "-" or ""
  local value = abs(ms) / MS_PER_SECOND
  return sign .. format_number(value) .. "S"
end

function M.new(v, unit)
  assert_arg(2, unit, "string", true)

  local tp = type(v)
  if tp == "nil" then
    return new_duration(zero_duration())
  elseif tp == "table" then
    if is_duration(v) then
      return clone_duration(v)
    end
    return new_duration(normalize_duration(v, 3))
  elseif tp == "number" then
    assert_arg(1, v, "number")
    local field = DURATION_UNIT_NAMES[unit or "ms"]
    if not field then
      error(fmt("bad duration unit %q", tostring(unit)), 3)
    end
    local parts = zero_duration()
    add_duration_value(parts, unit or "ms", v)
    return new_duration(parts)
  elseif tp == "string" then
    return parse_iso_duration(v, 3)
  end

  error(fmt('bad argument #1 to "duration" (number, table, string, or no value expected, got %s)', tostring(v)), 3)
end

function Duration:format(pattern)
  assert_arg(1, pattern, "string")

  local years, months = split_signed(month_units(self), 12)
  local total = time_ms(self)
  local hours, remainder = split_signed(total, SECONDS_PER_HOUR * MS_PER_SECOND)
  local minutes, remainder2 = split_signed(remainder, SECONDS_PER_MINUTE * MS_PER_SECOND)
  local seconds, milliseconds = split_signed(remainder2, MS_PER_SECOND)
  local parts = {
    years = years,
    months = months,
    days = self.days,
    hours = hours,
    minutes = minutes,
    seconds = seconds,
    milliseconds = milliseconds,
  }

  return render_format_pattern(pattern, function(token)
    if token == "YYYY" then
      return DURATION_FORMATTERS[token](parts)
    end
  end, function(token)
    if token == "SSS" then
      return DURATION_FORMATTERS[token](parts)
    end
  end, function(token)
    if rawget(DURATION_TOKENS_2, token) then
      return DURATION_FORMATTERS[token](parts)
    end
  end, function(token)
    if rawget(DURATION_TOKENS_1, token) then
      return DURATION_FORMATTERS[token](parts)
    end
  end)
end

function Duration:humanize(with_suffix, opts)
  if type(with_suffix) == "boolean" or with_suffix == nil then
    assert_arg(1, with_suffix, "boolean", true)
    assert_arg(2, opts, "table", true)
    if opts == nil or (opts.short == nil and opts.round == nil and opts.max_unit == nil and opts.min_unit == nil) then
      return humanize_delta_ms(total_ms(self), floor(abs(total_months(self)) + 0.5), not with_suffix)
    end
  end

  if type(with_suffix) == "table" then
    opts = with_suffix
  else
    assert_arg(1, with_suffix, "boolean", true)
    assert_arg(2, opts, "table", true)
    opts = opts or {}
    if with_suffix ~= nil and opts.with_suffix == nil then
      opts.with_suffix = with_suffix
    end
  end
  if opts.short == nil and opts.round == nil and opts.max_unit == nil and opts.min_unit == nil then
    return humanize_delta_ms(total_ms(self), floor(abs(total_months(self)) + 0.5), not opts.with_suffix)
  end
  return humanize_custom(self, opts)
end

function Duration:equals(other)
  if getmetatable(other) ~= Duration then
    return false
  end
  for _, unit in ipairs(DURATION_UNITS) do
    if self[unit] ~= other[unit] then
      return false
    end
  end
  return true
end

-- stylua: ignore start
function Duration:clone()     return clone_duration(self) end
function Duration:normalize() return new_duration(compact_duration(copy_duration_fields(self))) end
-- stylua: ignore end

function Duration:add(v, unit)
  return unit and add_duration(self, M.new(v, unit), 1) or add_duration(self, v, 1)
end
function Duration:subtract(v, unit)
  return unit and add_duration(self, M.new(v, unit), -1) or add_duration(self, v, -1)
end

function Duration:compare(d)
  local a = total_ms(self)
  local b = total_ms(M.new(d))
  return a < b and -1 or a > b and 1 or 0
end

function Duration:as(unit)
  local field = type(unit) == "string" and DURATION_UNIT_NAMES[unit]
  if not field then
    error(fmt("bad duration unit %q", tostring(unit)), 3)
  end
  return DURATION_TOTAL_FIELDS[field](self)
end

function Duration:to_iso()
  local date_parts = {}
  local time_parts = {}
  local sign = 0
  for _, unit in ipairs(DURATION_UNITS) do
    local value = self[unit]
    if value < 0 then
      if sign > 0 then
        sign = nil
        break
      end
      sign = -1
    elseif value > 0 then
      if sign < 0 then
        sign = nil
        break
      end
      sign = 1
    end
  end

  -- stylua: ignore start
  local years   = sign == -1 and abs(self.years)   or self.years
  local months  = sign == -1 and abs(self.months)  or self.months
  local days    = sign == -1 and abs(self.days)    or self.days
  local hours   = sign == -1 and abs(self.hours)   or self.hours
  local minutes = sign == -1 and abs(self.minutes) or self.minutes

  if years   ~= 0 then date_parts[#date_parts + 1] = tostring(years)   .. "Y" end
  if months  ~= 0 then date_parts[#date_parts + 1] = tostring(months)  .. "M" end
  if days    ~= 0 then date_parts[#date_parts + 1] = tostring(days)    .. "D" end
  if hours   ~= 0 then time_parts[#time_parts + 1] = tostring(hours)   .. "H" end
  if minutes ~= 0 then time_parts[#time_parts + 1] = tostring(minutes) .. "M" end
  -- stylua: ignore end

  local second_milliseconds
  if sign == -1 then
    second_milliseconds = abs(self.seconds * MS_PER_SECOND + self.milliseconds)
  else
    second_milliseconds = self.seconds * MS_PER_SECOND + self.milliseconds
  end

  local seconds = format_iso_seconds(second_milliseconds)
  if seconds then
    time_parts[#time_parts + 1] = seconds
  end

  if #date_parts == 0 and #time_parts == 0 then
    return "P0D"
  end

  local out = { sign == -1 and "-" or "", "P", concat(date_parts) }
  if #time_parts > 0 then
    out[#out + 1] = "T"
    out[#out + 1] = concat(time_parts)
  end
  return concat(out)
end

function Duration:tostring()
  local parts = {}
  local ordered_parts = {
    { "years", self.years },
    { "months", self.months },
    { "days", self.days },
    { "hours", self.hours },
    { "minutes", self.minutes },
    { "seconds", self.seconds },
    { "milliseconds", self.milliseconds },
  }
  for i = 1, #ordered_parts do
    local unit, v = ordered_parts[i][1], ordered_parts[i][2]
    if v ~= 0 then
      parts[#parts + 1] = fmt("%s=%s", unit, format_number(v))
    end
  end
  return "duration(" .. concat(parts, ", ") .. ")"
end

Duration.__eq = Duration.equals
Duration.__tostring = Duration.tostring

Duration.__index = function(self, k)
  local v = Duration[k]
  return v == nil and rawget(self, k) or v
end

function M.__call(_, ...)
  return M.new(...)
end

M.is_duration = is_duration

return setmetatable(M, M)
