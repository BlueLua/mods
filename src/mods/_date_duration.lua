local mods = require "mods"

local lower = string.lower
local concat = table.concat
local match = string.match
local sub = string.sub

local month_names_long = mods.calendar.months
local month_names_short = month_names_long:map(function(month)
  return month:sub(1, 3)
end)

local seconds_per_minute = 60
local seconds_per_hour = 60 * seconds_per_minute
local seconds_per_day = 24 * seconds_per_hour
local ms_per_second = 1000
local ms_per_day = seconds_per_day * ms_per_second

local M = {}

M.duration_units = { "years", "months", "days", "hours", "minutes", "seconds", "milliseconds" }
M.DURATION_UNITS = M.duration_units

M.date_unit_names = {
  ms = "ms",
  millisecond = "ms",
  milliseconds = "ms",
  s = "sec",
  sec = "sec",
  secs = "sec",
  second = "sec",
  seconds = "sec",
  m = "min",
  min = "min",
  mins = "min",
  minute = "min",
  minutes = "min",
  h = "hour",
  hour = "hour",
  hours = "hour",
  d = "day",
  day = "day",
  days = "day",
  w = "week",
  week = "week",
  weeks = "week",
  M = "month",
  month = "month",
  months = "month",
  q = "quarter",
  quarter = "quarter",
  quarters = "quarter",
  y = "year",
  year = "year",
  years = "year",
}
M.duration_unit_names = {
  ms = "milliseconds",
  millisecond = "milliseconds",
  milliseconds = "milliseconds",
  s = "seconds",
  sec = "seconds",
  secs = "seconds",
  second = "seconds",
  seconds = "seconds",
  m = "minutes",
  min = "minutes",
  mins = "minutes",
  minute = "minutes",
  minutes = "minutes",
  h = "hours",
  hour = "hours",
  hours = "hours",
  d = "days",
  day = "days",
  days = "days",
  w = "weeks",
  week = "weeks",
  weeks = "weeks",
  M = "months",
  month = "months",
  months = "months",
  q = "quarters",
  quarter = "quarters",
  quarters = "quarters",
  y = "years",
  year = "years",
  years = "years",
}
M.duration_keys = mods.tbl.keys(M.duration_unit_names):toset()
M.month_index_long = month_names_long:map(lower):invert()
M.month_index_short = month_names_short:map(lower):invert()

function M.render(pattern, resolve4, resolve3, resolve2, resolve1)
  local out = {}
  local i = 1

  while i <= #pattern do
    local literal = match(pattern, "^%[(.-)%]", i)
    if literal ~= nil then
      out[#out + 1] = literal
      i = i + #literal + 2
    else
      local token = sub(pattern, i, i + 3)
      local piece = resolve4(token)
      if piece ~= nil then
        out[#out + 1] = piece
        i = i + 4
      else
        token = sub(pattern, i, i + 2)
        piece = resolve3(token)
        if piece ~= nil then
          out[#out + 1] = piece
          i = i + 3
        else
          token = sub(pattern, i, i + 1)
          piece = resolve2(token)
          if piece ~= nil then
            out[#out + 1] = piece
            i = i + 2
          else
            token = sub(pattern, i, i)
            piece = resolve1(token)
            out[#out + 1] = piece ~= nil and piece or token
            i = i + 1
          end
        end
      end
    end
  end

  return concat(out)
end

function M.zero_duration()
  return {
    years = 0,
    months = 0,
    days = 0,
    hours = 0,
    minutes = 0,
    seconds = 0,
    milliseconds = 0,
  }
end

function M.copy_duration_fields(src, out)
  out = out or M.zero_duration()
  for i = 1, #M.duration_units do
    local unit = M.duration_units[i]
    out[unit] = src[unit]
  end
  return out
end

function M.add_duration_value(parts, key, value)
  local target = M.duration_unit_names[key]
  if target == "quarters" then
    parts.months = parts.months + value * 3
  elseif target == "weeks" then
    parts.days = parts.days + value * 7
  else
    parts[target] = parts[target] + value
  end
end

function M.split_signed(total, base)
  local sign = total < 0 and -1 or 1
  total = math.abs(total)
  local whole = math.floor(total / base)
  local remainder = total % base
  return sign * whole, sign * remainder
end

function M.compact_duration(parts)
  local total_ms = parts.days * ms_per_day
    + parts.hours * seconds_per_hour * ms_per_second
    + parts.minutes * seconds_per_minute * ms_per_second
    + parts.seconds * ms_per_second
    + parts.milliseconds

  parts.days, total_ms = M.split_signed(total_ms, ms_per_day)
  parts.hours, total_ms = M.split_signed(total_ms, seconds_per_hour * ms_per_second)
  parts.minutes, total_ms = M.split_signed(total_ms, seconds_per_minute * ms_per_second)
  parts.seconds, parts.milliseconds = M.split_signed(total_ms, ms_per_second)

  local months_from_days, days = M.split_signed(parts.days, 28)
  parts.months = parts.months + months_from_days
  parts.days = days

  local years, months = M.split_signed(parts.months, 12)
  parts.years = parts.years + years
  parts.months = months

  return parts
end

return M
