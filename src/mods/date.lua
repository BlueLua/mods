---@diagnostic disable: missing-fields

-- TODO: refactor this module later and add more test cases.

local mods = require "mods"
local _, mstime = pcall(require, "mstime")

local Set = mods.set
local calendar = mods.calendar
local duration = mods.duration
local date_duration = require "mods._date_duration"
local utils = mods.utils
local tbl = mods.tbl

local assert_arg = utils.assert_arg
local validate = utils.validate
local tbl_keys = tbl.keys
local render_format_pattern = date_duration.render

local weekday = calendar.weekday
local getfirstweekday = calendar.getfirstweekday
local isleap = calendar.isleap
local monthrange = calendar.monthrange
local idiv = mods.operator.idiv

local abs = math.abs
local concat = table.concat
local floor = math.floor
local fmt = string.format
local lower = string.lower
local match = string.match
local modf = math.modf
local osdate = os.date
local sub = string.sub

---@type mods.dateMod
local M = {}

local now, day_of_year, days_from_civil, iso_week_parts, ordinal, to_unix_ms, week_of_year, week_parts

-- stylua: ignore start
local DURATION_UNITS = date_duration.duration_units

local DATE_TOKENS_1  = Set({ "Q", "M", "D", "d", "e", "E", "H", "h", "m", "s", "S", "A", "a", "W", "w", "X", "x", "k" })
local DATE_TOKENS_2  = Set({ "GG", "YY", "MM", "DD", "dd", "HH", "hh", "kk", "mm", "ss", "SS", "WW", "ww", "wo", "Qo" })
local DATE_TOKENS_3  = Set({ "SSS", "MMM", "ddd", "DDD" })
local DATE_TOKENS_4  = Set({ "YYYY", "GGGG", "gggg", "MMMM", "dddd", "DDDD" })

local SECONDS_PER_MINUTE = 60
local SECONDS_PER_HOUR   = 60 * SECONDS_PER_MINUTE
local SECONDS_PER_DAY    = 24 * SECONDS_PER_HOUR
local MS_PER_SECOND      = 1000
local MS_PER_DAY         = SECONDS_PER_DAY * MS_PER_SECOND

local END_HOUR = 23
local END_MIN  = 59
local END_SEC  = 59
local END_MS   = 999

local MONTH_NAMES_LONG    = calendar.months
local WEEKDAY_NAMES_LONG  = calendar.days
local MONTH_NAMES_SHORT   = MONTH_NAMES_LONG:map(function(m)   return m:sub(1, 3) end)
local WEEKDAY_NAMES_SHORT = WEEKDAY_NAMES_LONG:map(function(d) return d:sub(1, 3) end)
local WEEKDAY_NAMES_MIN   = WEEKDAY_NAMES_LONG:map(function(d) return d:sub(1, 2) end)
local MONTH_INDEX_LONG    = date_duration.month_index_long
local MONTH_INDEX_SHORT   = date_duration.month_index_short
local UNIT_MS = {
  ms           = 1,
  millisecond  = 1,
  milliseconds = 1,
  sec          =     MS_PER_SECOND,
  secs         =     MS_PER_SECOND,
  second       =     MS_PER_SECOND,
  seconds      =     MS_PER_SECOND,
  min          =     SECONDS_PER_MINUTE * MS_PER_SECOND,
  mins         =     SECONDS_PER_MINUTE * MS_PER_SECOND,
  minute       =     SECONDS_PER_MINUTE * MS_PER_SECOND,
  minutes      =     SECONDS_PER_MINUTE * MS_PER_SECOND,
  hour         =     SECONDS_PER_HOUR   * MS_PER_SECOND,
  hours        =     SECONDS_PER_HOUR   * MS_PER_SECOND,
  day          =     SECONDS_PER_DAY    * MS_PER_SECOND,
  days         =     SECONDS_PER_DAY    * MS_PER_SECOND,
  week         = 7 * SECONDS_PER_DAY    * MS_PER_SECOND,
  weeks        = 7 * SECONDS_PER_DAY    * MS_PER_SECOND,
}
local UNIT_MONTHS = {
  month    = 1,
  months   = 1,
  quarter  = 3,
  quarters = 3,
  year     = 12,
  years    = 12,
}
local UNIT_NAMES = date_duration.date_unit_names
local DURATION_KEYS  = date_duration.duration_keys
local PRESET_FORMATS = {
  l    = "M/D/YYYY",
  ll   = "MMM D, YYYY",
  lll  = "MMM D, YYYY h:mm A",
  llll = "ddd, MMM D, YYYY h:mm A",
  L    = "MM/DD/YYYY",
  LL   = "MMMM D, YYYY",
  LLL  = "MMMM D, YYYY h:mm A",
  LLLL = "dddd, MMMM D, YYYY h:mm A",
  LT   = "h:mm A",
  LTS  = "h:mm:ss A",
}
local FORMATTERS = {
  a    = function(self)      return self.hour < 12 and "am" or "pm"                                         end,
  A    = function(self)      return self.hour < 12 and "AM" or "PM"                                         end,
  d    = function(_, wday)   return tostring(wday % 7)                                                      end,
  D    = function(self)      return tostring(self.day)                                                      end,
  DDD  = function(self)      return tostring(day_of_year(self.year, self.month, self.day))                  end,
  Do   = function(self)      return ordinal(self.day)                                                       end,
  dd   = function(_, wday)   return WEEKDAY_NAMES_MIN[wday]                                                 end,
  DD   = function(self)      return fmt("%02d", self.day)                                                   end,
  DDDD = function(self)      return fmt("%03d", day_of_year(self.year, self.month, self.day))               end,
  ddd  = function(_, wday)   return WEEKDAY_NAMES_SHORT[wday]                                               end,
  dddd = function(_, wday)   return WEEKDAY_NAMES_LONG[wday]                                                end,
  e    = function(_, wday)   return tostring(wday % 7)                                                      end,
  E    = function(_, wday)   return tostring(wday)                                                          end,
  h    = function(_, _, h12) return tostring(h12)                                                           end,
  H    = function(self)      return tostring(self.hour)                                                     end,
  hh   = function(_, _, h12) return fmt("%02d", h12)                                                        end,
  HH   = function(self)      return fmt("%02d", self.hour)                                                  end,
  k    = function(self)      return tostring(self.hour    == 0 and 24 or self.hour)                         end,
  kk   = function(self)      return fmt("%02d", self.hour == 0 and 24 or self.hour)                         end,
  m    = function(self)      return tostring(self.min)                                                      end,
  M    = function(self)      return tostring(self.month)                                                    end,
  mm   = function(self)      return fmt("%02d", self.min)                                                   end,
  MM   = function(self)      return fmt("%02d", self.month)                                                 end,
  MMM  = function(self)      return MONTH_NAMES_SHORT[self.month]                                           end,
  MMMM = function(self)      return MONTH_NAMES_LONG[self.month]                                            end,
  Q    = function(self)      return tostring(idiv(self.month - 1, 3) + 1)                                   end,
  Qo   = function(self)      return ordinal(idiv(self.month - 1, 3) + 1)                                    end,
  s    = function(self)      return tostring(self.sec)                                                      end,
  S    = function(self)      return tostring(idiv(self.ms, 100))                                            end,
  ss   = function(self)      return fmt("%02d", self.sec)                                                   end,
  SS   = function(self)      return fmt("%02d", idiv(self.ms, 10))                                          end,
  SSS  = function(self)      return fmt("%03d", self.ms)                                                    end,
  W    = function(self)      return tostring(select(2, iso_week_parts(self.year, self.month, self.day)))    end,
  WW   = function(self)      return fmt("%02d", select(2, iso_week_parts(self.year, self.month, self.day))) end,
  w    = function(self)      return tostring(week_of_year(self.year, self.month, self.day))                 end,
  ww   = function(self)      return fmt("%02d", week_of_year(self.year, self.month, self.day))              end,
  wo   = function(self)      return ordinal(week_of_year(self.year, self.month, self.day))                  end,
  X    = function(self)      return tostring(idiv(to_unix_ms(self), MS_PER_SECOND))                         end,
  x    = function(self)      return tostring(to_unix_ms(self))                                              end,
  GG   = function(self)      return fmt("%02d", ( iso_week_parts(self.year, self.month, self.day)) % 100)   end,
  GGGG = function(self)      return fmt("%04d", ( iso_week_parts(self.year, self.month, self.day)))         end,
  gggg = function(self)      return fmt("%04d", ( week_parts(self.year, self.month, self.day)))             end,
  YY   = function(self)      return fmt("%02d", self.year % 100)                                            end,
  YYYY = function(self)      return fmt("%04d", self.year)                                                  end,
}
local compact_duration = date_duration.compact_duration
local PARSE_TOKENS = {
  MMMM = {
    pattern = "(%a+)",
    assign = function(parts, v)
      local month = MONTH_INDEX_LONG[lower(v)]
      if not month then
        error(fmt("invalid month name %q", v), 3)
      end
      parts.month = month
    end,
  },
  MMM = {
    pattern = "(%a+)",
    assign = function(parts, v)
      local month = MONTH_INDEX_SHORT[lower(v)]
      if not month then
        error(fmt("invalid month name %q", v), 3)
      end
      parts.month = month
    end,
  },
  YYYY = { pattern = "([%-]?%d%d%d%d+)", assign = function(parts, v) parts.year     = tonumber(v) end },
  MM   = { pattern = "(%d%d)"          , assign = function(parts, v) parts.month    = tonumber(v) end },
  DD   = { pattern = "(%d%d)"          , assign = function(parts, v) parts.day      = tonumber(v) end },
  HH   = { pattern = "(%d%d)"          , assign = function(parts, v) parts.hour     = tonumber(v) end },
  hh   = { pattern = "(%d%d)"          , assign = function(parts, v) parts.hour12   = tonumber(v) end },
  mm   = { pattern = "(%d%d)"          , assign = function(parts, v) parts.min      = tonumber(v) end },
  ss   = { pattern = "(%d%d)"          , assign = function(parts, v) parts.sec      = tonumber(v) end },
  SSS  = { pattern = "(%d%d%d)"        , assign = function(parts, v) parts.ms       = tonumber(v) end },
  M    = { pattern = "(%d%d?)"         , assign = function(parts, v) parts.month    = tonumber(v) end },
  D    = { pattern = "(%d%d?)"         , assign = function(parts, v) parts.day      = tonumber(v) end },
  H    = { pattern = "(%d%d?)"         , assign = function(parts, v) parts.hour     = tonumber(v) end },
  h    = { pattern = "(%d%d?)"         , assign = function(parts, v) parts.hour12   = tonumber(v) end },
  m    = { pattern = "(%d%d?)"         , assign = function(parts, v) parts.min      = tonumber(v) end },
  s    = { pattern = "(%d%d?)"         , assign = function(parts, v) parts.sec      = tonumber(v) end },
  A    = { pattern = "(%a%a)"          , assign = function(parts, v) parts.meridiem = lower(v)    end },
  a    = { pattern = "(%a%a)"          , assign = function(parts, v) parts.meridiem = lower(v)    end },
}
-- stylua: ignore end

local function validate_unit(v)
  local unit = UNIT_NAMES[v]
  if not unit then
    error(fmt("invalid unit %q (expected one of: %s)", v, tbl_keys(UNIT_NAMES):sort():join(", ")), 3)
  end
  return unit
end

function ordinal(n)
  local mod100 = n % 100
  if mod100 >= 11 and mod100 <= 13 then
    return n .. "th"
  end

  local mod10 = n % 10
  if mod10 == 1 then
    return n .. "st"
  elseif mod10 == 2 then
    return n .. "nd"
  elseif mod10 == 3 then
    return n .. "rd"
  end
  return n .. "th"
end

function to_unix_ms(self)
  local days = days_from_civil(self.year, self.month, self.day)
  local time_ms = ((self.hour * SECONDS_PER_HOUR) + (self.min * SECONDS_PER_MINUTE) + self.sec) * MS_PER_SECOND
    + self.ms
  return days * MS_PER_DAY + time_ms
end

---@type mods.Date
local Date = {}
Date.__index = function(self, k)
  local v = Date[k]
  if v then
    return v
  end

  if k == "wday" then
    self.wday = weekday(self.year, self.month, self.day)
  elseif k == "yday" then
    self.yday = day_of_year(self.year, self.month, self.day)
  end

  return rawget(self, k)
end

---@type fun(a:mods.Date|number,b:mods.Date|number):(date:mods.Date,n:number)
local function check_date_arith(a, b)
  if getmetatable(a) == Date then
    ---@cast a mods.Date
    if type(b) ~= "number" then
      local tp = getmetatable(b) == Date and "mods.Date" or type(b)
      error("attempt to perform arithmetic on a " .. tp .. " value", 3)
    end
    return a, b
  end

  ---@cast b mods.Date
  if type(a) ~= "number" then
    local tp = getmetatable(a) == Date and "mods.Date" or type(a)
    error("attempt to perform arithmetic on a " .. tp .. " value", 3)
  end
  return b, a
end

---@type fun(a:mods.Date,b:mods.Date):(a:mods.Date,b:mods.Date)
local function check_date_cmp(a, b)
  if getmetatable(a) ~= Date then
    error("attempt to compare " .. type(a) .. " with mods.Date", 3)
  end
  if getmetatable(b) ~= Date then
    error("attempt to compare mods.Date with " .. type(b), 3)
  end
  return a, b
end

---@type fun(a:integer, b:integer):(remainder:integer)
local function posmod(a, b)
  local r = a % b
  return r < 0 and r + b or r
end

local function make(year, month, day, hour, min, sec, ms)
  assert_arg(1, year, "number")
  assert_arg(2, month, "number", true)
  assert_arg(3, day, "number", true)
  assert_arg(4, hour, "number", true)
  assert_arg(5, min, "number", true)
  assert_arg(6, sec, "number", true)
  assert_arg(7, ms, "number", true)

  year = modf(year)
  month = month and modf(month) or 1
  day = day and modf(day) or 1
  hour = hour and modf(hour) or 0
  min = min and modf(min) or 0
  sec = sec and modf(sec) or 0
  ms = ms and modf(ms) or 0

  if month < 1 or month > 12 then
    error(fmt("bad month number %d; must be 1-12", month), 3)
  end

  local _, max_day = monthrange(year, month)

  -- stylua: ignore start
  if day  < 1 or day  > max_day  then error(fmt("bad day number %d for %04d-%02d", day, year, month), 3) end
  if hour < 0 or hour > END_HOUR then error(fmt("bad hour number %d; must be 0-23", hour), 3)            end
  if min  < 0 or min  > END_MIN  then error(fmt("bad minute number %d; must be 0-59", min), 3)           end
  if sec  < 0 or sec  > END_SEC  then error(fmt("bad second number %d; must be 0-59", sec), 3)           end
  if ms   < 0 or ms   > END_MS   then error(fmt("bad millisecond number %d; must be 0-999", ms), 3)      end
  -- stylua: ignore end

  return setmetatable({ year = year, month = month, day = day, hour = hour, min = min, sec = sec, ms = ms }, Date)
end

---@type fun(year:integer, month:integer, day:integer):(serialDays:integer)
function days_from_civil(year, month, day)
  year = month <= 2 and year - 1 or year
  local era = idiv(year >= 0 and year or year - 399, 400)
  local yoe = year - era * 400
  local mp = month + (month > 2 and -3 or 9)
  local doy = floor((153 * mp + 2) / 5) + day - 1
  local doe = yoe * 365 + floor(yoe / 4) - floor(yoe / 100) + doy
  return era * 146097 + doe - 719468
end

---@type fun(days:integer):(year:integer, month:integer, day:integer)
local function civil_from_days(days)
  days = days + 719468
  local era = idiv(days >= 0 and days or days - 146096, 146097)
  local doe = days - era * 146097
  local yoe = floor((doe - floor(doe / 1460) + floor(doe / 36524) - floor(doe / 146096)) / 365)
  local year = yoe + era * 400
  local doy = doe - (365 * yoe + floor(yoe / 4) - floor(yoe / 100))
  local mp = floor((5 * doy + 2) / 153)
  local day = doy - floor((153 * mp + 2) / 5) + 1
  local month = mp + (mp < 10 and 3 or -9)
  year = month <= 2 and year + 1 or year
  return year, month, day
end

---@type fun(year:integer, month:integer, day:integer):(isoYear:integer, isoWeek:integer)
iso_week_parts = function(year, month, day)
  local serial = days_from_civil(year, month, day)
  local wday = weekday(year, month, day)
  local thursday_serial = serial + (4 - wday)
  local iso_year = civil_from_days(thursday_serial)
  local week1_monday = days_from_civil(iso_year, 1, 4) - (weekday(iso_year, 1, 4) - 1)
  return iso_year, idiv(serial - week1_monday, 7) + 1
end

---@type fun(year:integer, month:integer, day:integer):(weekYear:integer, week:integer)
week_parts = function(year, month, day)
  local serial = days_from_civil(year, month, day)
  local week_start = serial - (weekday(year, month, day) % 7)
  local week1_start = function(y)
    return days_from_civil(y, 1, 1) - (weekday(y, 1, 1) % 7)
  end

  if week_start >= week1_start(year + 1) then
    year = year + 1
  elseif week_start < week1_start(year) then
    year = year - 1
  end

  return year, idiv(week_start - week1_start(year), 7) + 1
end

---@type fun(year:integer, month:integer, day:integer):(week:integer)
week_of_year = function(year, month, day)
  return select(2, week_parts(year, month, day))
end

---@type fun(year:integer):(weeks:integer)
local function weeks_in_year(year)
  local firstweekday = getfirstweekday()
  local week1_start = function(y)
    return days_from_civil(y, 1, 1) - posmod(weekday(y, 1, 1) - firstweekday, 7)
  end

  return idiv(week1_start(year + 1) - week1_start(year), 7)
end

---@type fun(year:integer, month:integer, day:integer):(dayOfYear:integer)
day_of_year = function(year, month, day)
  return days_from_civil(year, month, day) - days_from_civil(year, 1, 1) + 1
end

---@type fun(argn:integer, v:any):(dt:mods.Date)
local function assert_datetime(argn, v)
  if getmetatable(v) ~= Date then
    error(fmt("bad argument #%d (mods.Date expected)", argn), 3)
  end
  return v
end

-- stylua: ignore
---@type fun(a:mods.Date, b:mods.Date):(-1|0|1)
local function compare(a, b)
  if a.year  ~= b.year  then return a.year  < b.year  and -1 or 1 end
  if a.month ~= b.month then return a.month < b.month and -1 or 1 end
  if a.day   ~= b.day   then return a.day   < b.day   and -1 or 1 end
  if a.hour  ~= b.hour  then return a.hour  < b.hour  and -1 or 1 end
  if a.min   ~= b.min   then return a.min   < b.min   and -1 or 1 end
  if a.sec   ~= b.sec   then return a.sec   < b.sec   and -1 or 1 end
  if a.ms    ~= b.ms    then return a.ms    < b.ms    and -1 or 1 end
  return 0
end

---@type fun(self:mods.Date):(ms:integer)
local function serial_ms(self)
  local days = days_from_civil(self.year, self.month, self.day)
  local time_ms = ((self.hour * SECONDS_PER_HOUR + self.min * SECONDS_PER_MINUTE + self.sec) * MS_PER_SECOND) + self.ms
  return days * MS_PER_DAY + time_ms
end

---@type fun(total_ms:integer):(dt:mods.Date)
local function from_serial_ms(total_ms)
  local days = idiv(total_ms, MS_PER_DAY)
  local time_ms = posmod(total_ms, MS_PER_DAY)
  local year, month, day = civil_from_days(days)
  local total_seconds = floor(time_ms / MS_PER_SECOND)
  local ms = time_ms % MS_PER_SECOND
  local hour = floor(total_seconds / SECONDS_PER_HOUR)

  total_seconds = total_seconds % SECONDS_PER_HOUR
  local minute = floor(total_seconds / SECONDS_PER_MINUTE)
  local second = total_seconds % SECONDS_PER_MINUTE

  return make(year, month, day, hour, minute, second, ms)
end

---@type fun(unix_ms:integer):(dt:mods.Date)
local function from_unix_ms(ts)
  local seconds = idiv(ts, MS_PER_SECOND)
  local now = osdate("!*t", seconds) --[[@as table<string,integer>]]
  now.ms, now.wday = posmod(ts, MS_PER_SECOND), nil
  return setmetatable(now, Date)
end

---@type fun():(dt:mods.Date)
if type(mstime) == "function" then
  function now()
    return from_unix_ms(mstime())
  end
else
  function now()
    local t = osdate("*t") --[[@as table<string,integer>]]
    t.ms, t.wday = 0, nil
    return setmetatable(t, Date)
  end
end


-- stylua: ignore
---@type fun(s:string):(year:integer, month:integer, day:integer, has_date:boolean)
local function parse_date_part(s)
  local num = tonumber ---@cast num fun(v):number

  local year, month, day = match(s, "^(%-?%d+)%-(%d%d)%-(%d%d)$")
  if year then return num(year), num(month), num(day), true end

  year, month = match(s, "^(%-?%d+)%-(%d%d)$")
  if year then return num(year), num(month), 1, true end

  year = match(s, "^(%-?%d+)$")
  if year then return num(year), 1, 1, true end

  return 0, 0, 0, false
end

-- stylua: ignore
---@type fun(s:string):(hour:integer, min:integer, sec:integer, ms:integer, has_time:boolean)
local function parse_time_part(s)
  local num = tonumber ---@cast num fun(v):number

  local hour, min, sec, ms = match(s, "^(%d%d):(%d%d):(%d%d)%.(%d%d%d)$")
  if hour then return num(hour), num(min), num(sec), num(ms), true end

  hour, min, sec = match(s, "^(%d%d):(%d%d):(%d%d)$")
  if hour then return num(hour), num(min), num(sec), 0, true end

  hour, min = match(s, "^(%d%d):(%d%d)$")
  if hour then return num(hour), num(min), 0, 0, true end

  hour = match(s, "^(%d%d)$")
  if hour then return num(hour), 0, 0, 0, true end

  return 0, 0, 0, 0, false
end

---@type fun(s:string):(dt:mods.Date)
local function parse_datetime(s)
  local date_part, time_part = match(s, "^(.-)[T ](.+)$")
  if date_part then
    local year, month, day, has_date = parse_date_part(date_part)
    local hour, minute, second, ms, has_time = parse_time_part(time_part)
    if has_date and has_time then
      return make(year, month, day, hour, minute, second, ms)
    end
  else
    local year, month, day, has_date = parse_date_part(s)
    if has_date then
      return make(year, month, day)
    end
  end

  error(fmt("invalid date string %q", s), 3)
end

local function escape_lua_pat_char(c)
  return c:match("[%^%$%(%)%%%.%[%]%*%+%-%?]") and "%" .. c or c
end

---@type fun(s:string, pattern:string):(dt:mods.Date)
local function parse_with_format(s, pattern)
  local capture_order = {}
  local lua_pattern = { "^" }
  local i = 1

  while i <= #pattern do
    local token
    for size = 4, 1, -1 do
      local candidate = sub(pattern, i, i + size - 1)
      if PARSE_TOKENS[candidate] ~= nil then
        token = candidate
        break
      end
    end

    if token ~= nil then
      capture_order[#capture_order + 1] = token
      lua_pattern[#lua_pattern + 1] = PARSE_TOKENS[token].pattern
      i = i + #token
    else
      lua_pattern[#lua_pattern + 1] = escape_lua_pat_char(sub(pattern, i, i))
      i = i + 1
    end
  end

  lua_pattern[#lua_pattern + 1] = "$"
  local captures = { match(s, concat(lua_pattern)) }
  if #captures == 0 then
    error(fmt("invalid date string %q for format %q", s, pattern), 3)
  end

  local parts = { month = 1, day = 1, hour = 0, min = 0, sec = 0, ms = 0 }
  for j = 1, #capture_order do
    PARSE_TOKENS[capture_order[j]].assign(parts, captures[j])
  end

  if parts.hour12 ~= nil then
    local hour12 = parts.hour12
    if hour12 < 1 or hour12 > 12 then
      error(fmt("bad hour number %s; must be 1-12", tostring(hour12)), 3)
    end
    local meridiem = parts.meridiem
    if meridiem == "am" then
      parts.hour = hour12 % 12
    elseif meridiem == "pm" then
      parts.hour = (hour12 % 12) + 12
    else
      parts.hour = hour12 % 12
    end
  end

  if not parts.year then
    error(fmt("format %q must include YYYY", pattern), 3)
  end
  return make(parts.year, parts.month, parts.day, parts.hour, parts.min, parts.sec, parts.ms)
end

---@type fun(self:mods.Date, token:string):(piece:string)
local function format_token(self, token)
  local format = FORMATTERS[token]
  return format(self, weekday(self.year, self.month, self.day), (self.hour - 1) % 12 + 1) or token
end

---@type fun(self:mods.Date, months:integer):(shifted:mods.Date)
local function add_months(self, months)
  local month_index = self.year * 12 + (self.month - 1) + months
  local year = idiv(month_index, 12)
  local month = posmod(month_index, 12) + 1
  local day = self.day
  local _, max_day = monthrange(year, month)
  if day > max_day then
    day = max_day
  end
  return make(year, month, day, self.hour, self.min, self.sec, self.ms)
end

---@type fun(self:mods.Date, v:integer, unit:mods.DateUnit):(shifted:mods.Date)
local function add_unit(self, v, unit)
  local months = UNIT_MONTHS[unit]
  if months then
    return add_months(self, v * months)
  end
  local ms = UNIT_MS[unit]
  if not ms then
    error(fmt("bad add unit %q", unit), 3)
  end
  return from_serial_ms(serial_ms(self) + v * ms)
end

---@type fun(fname:string, delta:table):table<string, integer>
local function normalize_duration(fname, delta)
  assert_arg(1, delta, "table")

  local normalized = date_duration.zero_duration()

  for k, v in pairs(delta) do
    if not DURATION_KEYS[k] then
      error(fmt("bad duration key %q", tostring(k)), 3)
    end

    validate(fname .. "." .. k, v, "number")
    local value = modf(v)
    date_duration.add_duration_value(normalized, k, value)
  end

  return compact_duration(normalized)
end

local function add_or_subtract(self, v, unit, fname, sign)
  if type(v) == "table" then
    local delta = normalize_duration(fname, v)
    local out = self
    for _, name in ipairs(DURATION_UNITS) do
      local d = delta[name]
      if d ~= 0 then
        out = add_unit(out, d * sign, name)
      end
    end
    return out
  end

  assert_arg(1, v, "number")
  assert_arg(2, unit, "string")
  return add_unit(self, modf(v --[[@as number]]) * sign, unit)
end

---@type fun(self:mods.Date):(weekday:integer)
local function locale_weekday(self)
  return posmod(weekday(self.year, self.month, self.day) - getfirstweekday(), 7) + 1
end

---@type fun(t:mods.DateParts):(dt:mods.Date)
local function from_parts(t)
  assert_arg(1, t, "table")

  validate("year", t.year, "number")
  validate("month", t.month, "number", true)
  validate("day", t.day, "number", true)
  validate("hour", t.hour, "number", true)
  validate("min", t.min, "number", true)
  validate("sec", t.sec, "number", true)
  validate("ms", t.ms, "number", true)

  return make(t.year, t.month, t.day, t.hour, t.min, t.sec, t.ms)
end

---@param delta_ms number
---@param approx_months number
---@param without_suffix boolean?
---@return string
local function humanize_delta_ms(delta_ms, approx_months, without_suffix)
  local seconds_per_minute = 60

  if delta_ms == 0 then
    return without_suffix and "a few seconds" or "a few seconds ago"
  end

  local future = delta_ms > 0
  local seconds = floor((abs(delta_ms) + 500) / 1000)
  local phrase

  if seconds < 45 then
    phrase = "a few seconds"
  elseif seconds < 90 then
    phrase = "a minute"
  else
    local minutes = floor((seconds + 30) / seconds_per_minute)
    if minutes < 45 then
      phrase = fmt("%d minutes", minutes)
    elseif minutes < 90 then
      phrase = "an hour"
    else
      local hours = floor((minutes + 30) / 60)
      if hours < 22 then
        phrase = fmt("%d hours", hours)
      elseif hours < 36 then
        phrase = "a day"
      else
        local days = floor((hours + 12) / 24)
        if days < 26 then
          phrase = fmt("%d days", days)
        elseif days < 46 then
          phrase = "a month"
        else
          local months = abs(approx_months)
          if months < 1 then
            months = 1
          end
          if months < 11 then
            phrase = fmt("%d months", months)
          elseif months < 18 then
            phrase = "a year"
          else
            phrase = fmt("%d years", floor((months + 6) / 12))
          end
        end
      end
    end
  end

  if without_suffix then
    return phrase
  end
  return future and ("in " .. phrase) or (phrase .. " ago")
end

---@type fun(a:mods.Date, b:mods.Date):(months:integer)
local function diff_months(a, b)
  local sign = compare(a, b)
  if sign == 0 then
    return 0
  end

  local earlier = sign < 0 and a or b
  local later = sign < 0 and b or a
  local months = (later.year - earlier.year) * 12 + (later.month - earlier.month)
  if compare(add_months(earlier, months), later) > 0 then
    months = months - 1
  end

  return sign < 0 and -months or months
end

---@type fun(self:mods.Date, other:mods.Date, without_suffix:boolean?):(relative:string)
local function relative_time(self, other, without_suffix)
  local delta_ms = serial_ms(self) - serial_ms(other)
  return humanize_delta_ms(delta_ms, diff_months(self, other), without_suffix)
end

function M.new(v, pattern)
  assert_arg(2, pattern, "string", true)
  local vt = type(v)
  if vt == "nil" then
    return now()
  elseif vt == "string" then
    return pattern and parse_with_format(v, pattern) or parse_datetime(v)
  elseif vt == "number" then
    return from_unix_ms(v)
  elseif vt == "table" then
    return from_parts(v)
  end
  error(fmt('bad argument #1 to "date" (string, integer, table, or no value expected, got %s)', tostring(v)), 2)
end


-- stylua: ignore start
M.duration               = duration
function M.is_duration(v) return duration.is_duration(v)                                                 end
function M.min(...)       return (M.minmax(...))                                                         end
function M.max(...)       return select(2, M.minmax(...))                                                end
function M.unix(ts)       return from_unix_ms(floor(assert_arg(1, ts, "number") * MS_PER_SECOND))        end

function Date:is_after(d)          return compare(self, assert_datetime(1, d)) > 0                                   end
function Date:is_before(d)         return compare(self, assert_datetime(1, d)) < 0                                   end
function Date:is_leap_year()       return isleap(self.year)                                                          end
function Date:is_same_or_after(d)  return compare(self, assert_datetime(1, d)) >= 0                                  end
function Date:is_same_or_before(d) return compare(self, assert_datetime(1, d)) <= 0                                  end
function Date:is_same(d)           return compare(self, assert_datetime(1, d)) == 0                                  end
function Date:is_today()           return self:startof("day"):is_same(now():startof("day"))                    end
function Date:is_tomorrow()        return self:startof("day"):is_same(now():add(1, "day"):startof("day"))      end
function Date:is_yesterday()       return self:startof("day"):is_same(now():subtract(1, "day"):startof("day")) end
function Date:add(v, unit)         return add_or_subtract(self, v, unit, "add", 1)                                   end
function Date:subtract(v, unit)    return add_or_subtract(self, v, unit, "subtract", -1)                             end
function Date:month_days()         return select(2, monthrange(self.year, self.month))                               end
function Date:week_year()          return (week_parts(self.year, self.month, self.day))                              end
function Date:iso_week_year()      return (iso_week_parts(self.year, self.month, self.day))                          end
function Date:weeks_in_year()      return weeks_in_year(self:week_year())                                            end
function Date:iso_weeks_in_year()  return select(2, iso_week_parts(self.year, 12, 28))                               end
-- stylua: ignore end

function Date:weekday(v)
  assert_arg(1, v, "number", true)
  return v and self:add(modf(v), "day") or locale_weekday(self)
end

function Date:quarter(v)
  assert_arg(1, v, "number", true)
  local current = idiv(self.month - 1, 3) + 1
  return v and add_months(self, (modf(v) - current) * 3) or current
end

function Date:day_of_year(v)
  assert_arg(1, v, "number", true)
  if v then
    local date = make(self.year, 1, 1, self.hour, self.min, self.sec, self.ms)
    return date:add(modf(v) - 1, "day")
  end
  return day_of_year(self.year, self.month, self.day)
end

function Date:week(v)
  assert_arg(1, v, "number", true)
  return v and self:add((v - self:week()) * 7, "day") or select(2, week_parts(self.year, self.month, self.day))
end

function Date:iso_week(v)
  assert_arg(1, v, "number", true)
  if v then
    return self:add((v - self:iso_week()) * 7, "day")
  end
  return select(2, iso_week_parts(self.year, self.month, self.day))
end

function Date:iso_weekday(v)
  assert_arg(1, v, "number", true)
  return v and self:add(v - self:iso_weekday(), "day") or weekday(self.year, self.month, self.day)
end

function Date:format(pattern)
  assert_arg(1, pattern, "string")

  local wday = weekday(self.year, self.month, self.day)
  local h12 = (self.hour - 1) % 12 + 1

  return render_format_pattern(pattern, function(token)
    local preset = PRESET_FORMATS[token]
    if preset then
      return self:format(preset)
    end
    if DATE_TOKENS_4[token] then
      return format_token(self, token, wday, h12)
    end
  end, function(token)
    local preset = PRESET_FORMATS[token]
    if preset then
      return self:format(preset)
    end
    if DATE_TOKENS_3[token] then
      return format_token(self, token, wday, h12)
    end
  end, function(token)
    if token == "Do" or DATE_TOKENS_2[token] then
      return format_token(self, token, wday, h12)
    end
  end, function(token)
    if DATE_TOKENS_1[token] then
      return format_token(self, token, wday, h12)
    end
  end)
end

function Date:tostring()
  local s = self:format("YYYY-MM-DD HH:mm:ss")
  return self.ms == 0 and s or fmt("%s.%03d", s, self.ms)
end

function Date:from(other, without_suffix)
  assert_datetime(1, other)
  assert_arg(2, without_suffix, "boolean", true)
  return relative_time(self, other, without_suffix)
end

function Date:to(other, without_suffix)
  assert_datetime(1, other)
  assert_arg(2, without_suffix, "boolean", true)
  return relative_time(other, self, without_suffix)
end

function Date:from_now(without_suffix)
  assert_arg(1, without_suffix, "boolean", true)
  return relative_time(self, now(), without_suffix)
end

function Date:to_now(without_suffix)
  assert_arg(1, without_suffix, "boolean", true)
  return relative_time(now(), self, without_suffix)
end

function Date:diff(d, unit)
  assert_datetime(1, d)
  assert_arg(2, unit, "string", true)

  unit = validate_unit(unit or "ms")

  if unit == "year" then
    return (modf(diff_months(self, d) / 12))
  elseif unit == "quarter" then
    return (modf(diff_months(self, d) / 3))
  elseif unit == "month" then
    return diff_months(self, d)
  end

  return (modf((serial_ms(self) - serial_ms(d)) / UNIT_MS[unit]))
end

function Date:is_between(a, b, inclusive)
  assert_datetime(1, a)
  assert_datetime(2, b)
  assert_arg(3, inclusive, "boolean", true)

  if compare(a, b) > 0 then
    a, b = b, a
  end

  local left = compare(self, a)
  local right = compare(self, b)
  if inclusive then
    return left >= 0 and right <= 0
  end
  return left > 0 and right < 0
end

function Date:startof(unit)
  assert_arg(1, unit, "string")

  if unit == "isoWeek" then
    return self:add(1 - self:iso_weekday(), "day"):startof("day")
  end

  unit = validate_unit(unit)

  if unit == "year" then
    return make(self.year)
  elseif unit == "quarter" then
    local month = idiv(self.month - 1, 3) * 3 + 1
    return make(self.year, month)
  elseif unit == "month" then
    return make(self.year, self.month)
  elseif unit == "week" then
    return self:add(1 - self:weekday(), "day"):startof("day")
  elseif unit == "day" then
    return make(self.year, self.month, self.day)
  elseif unit == "hour" then
    return make(self.year, self.month, self.day, self.hour)
  elseif unit == "min" then
    return make(self.year, self.month, self.day, self.hour, self.min)
  elseif unit == "sec" then
    return make(self.year, self.month, self.day, self.hour, self.min, self.sec)
  end

  return self
end

function Date:endof(unit)
  assert_arg(1, unit, "string")

  if unit == "isoWeek" then
    return self:startof("isoWeek"):add(6, "day"):endof("day")
  end

  unit = validate_unit(unit)

  if unit == "year" then
    return make(self.year, 12, 31, END_HOUR, END_MIN, END_SEC, END_MS)
  elseif unit == "quarter" then
    local month = idiv(self.month - 1, 3) * 3 + 3
    local _, ndays = monthrange(self.year, month)
    return make(self.year, month, ndays, END_HOUR, END_MIN, END_SEC, END_MS)
  elseif unit == "month" then
    local _, ndays = monthrange(self.year, self.month)
    return make(self.year, self.month, ndays, END_HOUR, END_MIN, END_SEC, END_MS)
  elseif unit == "week" then
    return self:startof("week"):add(6, "day"):endof("day")
  elseif unit == "day" then
    return make(self.year, self.month, self.day, END_HOUR, END_MIN, END_SEC, END_MS)
  elseif unit == "hour" then
    return make(self.year, self.month, self.day, self.hour, END_MIN, END_SEC, END_MS)
  elseif unit == "min" then
    return make(self.year, self.month, self.day, self.hour, self.min, END_SEC, END_MS)
  elseif unit == "sec" then
    return make(self.year, self.month, self.day, self.hour, self.min, self.sec, END_MS)
  end

  return self
end

function M.is_valid(input, pattern)
  if not input or (pattern and type(pattern) ~= "string") then
    return false
  end

  local tp = type(input)
  if tp == "number" then
    return true
  elseif tp == "table" then
    return pcall(from_parts, input)
  elseif tp ~= "string" then
    return false
  end

  return (pcall(pattern and parse_with_format or parse_datetime, input, pattern))
end

function M.minmax(...)
  local min, max

  for i = 1, select("#", ...) do
    local v = select(i, ...)
    if type(v) == "table" and getmetatable(v) ~= Date then
      local first = v[1]

      if getmetatable(first) ~= Date then
        error(fmt("invalid value at index %d in argument #1 (mods.Date expected)", i), 3)
      end

      if not min then
        min, max = first, first
      elseif compare(first, min) < 0 then
        min = first
      elseif compare(first, max) > 0 then
        max = first
      end

      for j = 2, #v do
        local d = v[j]
        if getmetatable(d) ~= Date then
          error(fmt("invalid value at index %d in argument #%d (mods.Date expected)", j, i), 3)
        end

        if compare(d, min) < 0 then
          min = d
        end
        if compare(d, max) > 0 then
          max = d
        end
      end
    else
      local d = assert_datetime(i, v)
      if not min then
        min, max = d, d
      else
        if compare(d, min) < 0 then
          min = d
        end
        if compare(d, max) > 0 then
          max = d
        end
      end
    end
  end

  if not min then
    assert_datetime(1, nil)
  end

  return min, max
end

Date.__eq = Date.is_same
Date.__tostring = Date.tostring

function Date.__le(a, b)
  a, b = check_date_cmp(a, b)
  return a:is_same_or_before(b)
end

function Date.__lt(a, b)
  a, b = check_date_cmp(a, b)
  return a:is_before(b)
end

function Date.__add(a, b)
  local date, n = check_date_arith(a, b)
  return date:add(n, "ms")
end

function Date.__sub(a, b)
  local date, n = check_date_arith(a, b)
  return date:add(-n, "ms")
end

function M.__call(_, input, pattern)
  return M.new(input, pattern)
end

return setmetatable(M, M)
