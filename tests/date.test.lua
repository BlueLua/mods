local mods = require "mods"

local cal = mods.calendar
local Date = mods.date

local is_lua51 = mods.runtime.is_lua51
local args_repr = mods.utils.args_repr
local spairs = mods.tbl.spairs

local fmt = string.format

describe("mods.date", function()
  local today = Date()
  local yesterday = today:subtract(1, "days")
  local tomorrow = today:add(1, "days")

  describe("construction", function()
    it("constructs the current local time", function()
      assert.is_table(Date())
    end)

    -- stylua: ignore
    local tests = {
      { { year = 2025, month = 4, day = 20, hour = 13, min = 20, sec = 6, ms = 123, yday = 110 }, { 1745155206123 } },

      { { year = 2026, month = 1, day =  1, hour =  0, min =  0, sec = 0, ms =   0 }, { { year = 2026                                                                            } } },
      { { year = 2026, month = 3, day =  1, hour =  0, min =  0, sec = 0, ms =   0 }, { { year = 2026  , month = 3                                                               } } },
      { { year = 2026, month = 3, day = 30, hour =  0, min =  0, sec = 0, ms =   0 }, { { year = 2026  , month = 3  , day = 30                                                   } } },
      { { year = 2026, month = 3, day = 30, hour = 14, min =  0, sec = 0, ms =   0 }, { { year = 2026  , month = 3  , day = 30  , hour = 14                                      } } },
      { { year = 2026, month = 3, day = 30, hour = 14, min = 45, sec = 0, ms =   0 }, { { year = 2026  , month = 3  , day = 30  , hour = 14  , min = 45                          } } },
      { { year = 2026, month = 3, day = 30, hour = 14, min = 45, sec = 6, ms =   0 }, { { year = 2026  , month = 3  , day = 30  , hour = 14  , min = 45  , sec = 6               } } },
      { { year = 2026, month = 3, day = 30, hour = 14, min = 45, sec = 6, ms = 123 }, { { year = 2026  , month = 3  , day = 30  , hour = 14  , min = 45  , sec = 6  , ms = 123   } } },
      { { year = 2026, month = 3, day = 30, hour = 14, min = 45, sec = 6, ms = 123 }, { { year = 2026.9, month = 3.8, day = 30.7, hour = 14.6, min = 45.5, sec = 6.4, ms = 123.3 } } },

      { { year = 2026, month =  3, day = 30, hour = 14, min = 45, sec = 6, ms =   0 }, { "2026-03-30T14:45:06"     } },
      { { year = 2026, month =  3, day = 30, hour = 14, min = 45, sec = 6, ms = 123 }, { "2026-03-30T14:45:06.123" } },
      { { year = 2026, month =  3, day = 30, hour =  0, min =  0, sec = 0, ms =   0 }, { "2026-03-30"              } },
      { { year = 2026, month =  3, day = 30, hour = 14, min =  0, sec = 0, ms =   0 }, { "2026-03-30T14"           } },
      { { year = 2026, month =  3, day = 30, hour = 14, min = 45, sec = 0, ms =   0 }, { "2026-03-30 14:45"        } },
      { { year = 2026, month =  3, day = 30, hour = 14, min = 45, sec = 6, ms =   0 }, { "2026-03-30 14:45:06"     } },
      { { year = 2026, month =  3, day = 30, hour =  0, min =  0, sec = 0, ms =   0 }, { "2026-03-30"              } },
      { { year = 2026, month =  3, day = 30, hour = 14, min = 45, sec = 6, ms = 123 }, { "2026-03-30 14:45:06.123" } },

      { { year = 1995, month = 12, day = 25, hour =  0, min =  0, sec = 0, ms = 0 }, { "12/25/1995", "MM/DD/YYYY" } },
      { { year = 2026, month =  3, day = 30, hour =  0, min =  0, sec = 0, ms = 0 }, { "30.03.2026", "DD.MM.YYYY" } },
    }

    for i = 1, #tests do
      local expected, args = unpack(tests[i] --[[@as {[1]:string, [2]:{}}]])
      it(fmt("Date(%s)", args_repr(args)), function()
        local res = Date(unpack(args))
        res.isdst = nil
        assert.same(expected, res)
      end)
    end

    -- stylua: ignore
    local errors = {
      { 'invalid date string "2026/03/30"'  , { "2026/03/30" } },
      { "bad day number 29 for 2026-02"     , { "2026-02-29" } },
      { "bad month number 13; must be 1-12" , { "2026-13-01" } },

      { 'format "DD-DD" must include YYYY'  , { "25-12"              , "DD-DD"               } },
      { "bad month number 13; must be 1-12" , { "2026-13-30"         , "YYYY-MM-DD"          } },
      { "bad day number 29 for 2026-02"     , { "2026-02-29"         , "YYYY-MM-DD"          } },
      { "bad hour number 24; must be 0-23"  , { "03/30/2026 24:45"   , "MM/DD/YYYY HH:mm"    } },
      { "bad minute number 60; must be 0-59", { "03/30/2026 14:60"   , "MM/DD/YYYY HH:mm"    } },
      { "bad second number 60; must be 0-59", { "03/30/2026 14:45:60", "MM/DD/YYYY HH:mm:ss" } },
      { 'invalid month name "Smarch"'       , { "Smarch 30, 2026"    , "MMMM D, YYYY"        } },
      { 'invalid month name "Sma"'          , { "Sma 30, 2026"       , "MMM D, YYYY"         } },
      { "bad hour number 0; must be 1-12"   , { "03/30/2026 00:45 PM", "MM/DD/YYYY hh:mm A"  } },
      { "bad hour number 13; must be 1-12"  , { "03/30/2026 13:45 PM", "MM/DD/YYYY hh:mm A"  } },

      { 'invalid date string "2026/03/30" for format "YYYY-MM-DD"'                           , { "2026/03/30", "YYYY-MM-DD" } },
      { 'invalid date string "03/30/2026 14:45:06.1000" for format "MM/DD/YYYY HH:mm:ss.SSS"', {"03/30/2026 14:45:06.1000", "MM/DD/YYYY HH:mm:ss.SSS" } },
    }

    for i = 1, #errors do
      local errmsg, args = unpack(errors[i] --[[@as {[1]:string, [2]:{}}]])
      it(fmt("Date(%s)", args_repr(args)), function()
        assert.has_error(function()
          Date(unpack(args))
        end, errmsg)
      end)
    end
  end)

  describe("locale-aware calendar access", function()
    after_each(function()
      cal.setfirstweekday(cal.MONDAY)
    end)

    it("matches weekday values when Monday is first", function()
      cal.setfirstweekday(cal.MONDAY)
      local d = Date("2026-03-30")
      assert.are.equal(1, d:weekday())
      assert.are.equal("2026-03-23 00:00:00", tostring(d:weekday(-7)))
      assert.are.equal("2026-04-06 00:00:00", tostring(d:weekday(7)))
    end)

    it("matches weekday values when Sunday is first", function()
      cal.setfirstweekday(cal.SUNDAY)
      local d = Date("2026-03-30")
      assert.are.equal(2, d:weekday())
      assert.are.equal("2026-03-23 00:00:00", tostring(d:weekday(-7)))
      assert.are.equal("2026-04-06 00:00:00", tostring(d:weekday(7)))
    end)

    it("keeps startof and endof week aligned with the configured first weekday", function()
      cal.setfirstweekday(cal.SUNDAY)
      local d = Date("2026-03-30T14:45:06.123")
      assert.are.equal("2026-03-29 00:00:00", tostring(d:startof("week")))
      assert.are.equal("2026-04-04 23:59:59.999", tostring(d:endof("week")))
    end)

    it("supports ISO week boundaries independently of locale week settings", function()
      cal.setfirstweekday(cal.SUNDAY)
      local d = Date("2026-03-30T14:45:06.123")
      assert.are.equal("2026-03-30 00:00:00", tostring(d:startof("isoWeek")))
      assert.are.equal("2026-04-05 23:59:59.999", tostring(d:endof("isoWeek")))
    end)
  end)

  -- stylua: ignore
  local tests = {
    add = {
      { { year = 2026, month = 3, day = 30, wday = 1, yday =  89, hour = 14, min = 45, sec =  6, ms = 500 }, "2026-03-30T14:45:06", { 500, "ms"      } },
      { { year = 2026, month = 3, day = 30, wday = 1, yday =  89, hour = 14, min = 45, sec = 36, ms =   0 }, "2026-03-30T14:45:06", {  30, "second"  } },
      { { year = 2026, month = 3, day = 30, wday = 1, yday =  89, hour = 15, min =  0, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {  15, "minute"  } },
      { { year = 2026, month = 3, day = 31, wday = 2, yday =  90, hour =  0, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {  10, "hour"    } },
      { { year = 2026, month = 4, day =  4, wday = 6, yday =  94, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {   5, "day"     } },
      { { year = 2026, month = 4, day = 13, wday = 1, yday = 103, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {   2, "week"    } },
      { { year = 2026, month = 6, day = 30, wday = 2, yday = 181, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {   3, "month"   } },
      { { year = 2026, month = 2, day = 28, wday = 6, yday =  59, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-01-31T14:45:06", {   1, "month"   } },
      { { year = 2026, month = 9, day = 30, wday = 3, yday = 273, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {   2, "quarter" } },
      { { year = 2031, month = 3, day = 30, wday = 7, yday =  89, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {   5, "year"    } },
      { { year = 2026, month = 3, day = 29, wday = 7, yday =  88, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {  -1, "day"     } },

      { { year = 2026, month = 3, day = 30, wday = 1, yday =  89, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", { { month = 0, day     = 0                                                                                  } } },
      { { year = 2026, month = 5, day =  2, wday = 6, yday = 122, hour = 17, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", { { month = 1, day     = 2, hour  = 3                                                                       } } },
      { { year = 2027, month = 8, day =  7, wday = 6, yday = 219, hour = 15, min = 46, sec =  7, ms =   1 }, "2026-03-30T14:45:06", { { year  = 1, quarter = 1, month = 1.1, week = 1, day = 1.5, hour = 1, min = 1, sec = 1, ms = 1 } } },

      errors = {
        { "bad argument #1 (number expected, got no value)",                       },
        { "bad argument #2 (string expected, got number)"  , { 1, 2              } },
        { 'bad add unit "fortnight"'                       , { 1, "fortnight"    } },
        { 'bad duration key "fortnight"'                   , { { fortnight = 1 } } },
        { 'bad duration key "weekday"'                     , { { weekday = 1 } } },
        { 'bad duration key "wday"'                      , { { wday = 1 } } },
        { 'bad duration key "yday"'                      , { { yday = 1 } } },
        { 'bad duration key "isdst"'                     , { { isdst = 1 } } },
        { 'bad duration key "timestamp"'                  , { { timestamp = 1 } } },
        { 'bad duration key "epoch"'                     , { { epoch = 1 } } },
      }
    },
    subtract = {
      { { year = 2026, month =  3, day = 30, wday =  1, yday =  89, hour = 14, min = 45, sec =  5, ms = 500 }, "2026-03-30T14:45:06", { 500, "ms"      } },
      { { year = 2026, month =  3, day = 30, wday =  1, yday =  89, hour = 14, min = 44, sec = 36, ms =   0 }, "2026-03-30T14:45:06", {  30, "second"  } },
      { { year = 2026, month =  3, day = 30, wday =  1, yday =  89, hour = 14, min = 30, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {  15, "minute"  } },
      { { year = 2026, month =  3, day = 30, wday =  1, yday =  89, hour =  4, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {  10, "hour"    } },
      { { year = 2026, month =  3, day = 25, wday =  3, yday =  84, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {   5, "day"     } },
      { { year = 2026, month =  3, day = 16, wday =  1, yday =  75, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {   2, "week"    } },
      { { year = 2025, month = 12, day = 30, wday =  2, yday = 364, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {   3, "month"   } },
      { { year = 2025, month = 12, day = 31, wday =  3, yday = 365, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-01-31T14:45:06", {   1, "month"   } },
      { { year = 2025, month =  9, day = 30, wday =  2, yday = 273, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {   2, "quarter" } },
      { { year = 2021, month =  3, day = 30, wday =  2, yday =  89, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {   5, "year"    } },
      { { year = 2026, month =  3, day = 31, wday =  2, yday =  90, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", {  -1, "day"     } },

      { { year = 2026, month =  3, day = 30, wday =  1, yday =  89, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", { { month = 0, day     = 0 } } },
      { { year = 2026, month =  2, day = 26, wday =  4, yday =  57, hour = 11, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06", { { month = 1, day     = 2, hour  = 3 } } },
      { { year = 2024, month = 11, day = 22, wday =  5, yday = 327, hour = 13, min = 44, sec =  4, ms = 999 }, "2026-03-30T14:45:06", { { year  = 1, quarter = 1, month = 1.1, week = 1, day = 1.5, hour = 1, min = 1, sec = 1, ms = 1 } } },

      errors = {
        { "subtract.day: number expected, got string"    , { { day       = "1" } } },
        { 'bad duration key "fortnight"'                 , { { fortnight = 1 }   } },
        { "bad argument #1 (number expected, got string)", { "1", "day"          } },
        { 'bad add unit "fortnight"'                     , { 1  , "fortnight"    } },
        { 'bad duration key "weekday"'                   , { { weekday = 1 } } },
        { 'bad duration key "wday"'                      , { { wday = 1 } } },
        { 'bad duration key "yday"'                      , { { yday = 1 } } },
        { 'bad duration key "isdst"'                     , { { isdst = 1 } } },
        { 'bad duration key "timestamp"'                  , { { timestamp = 1 } } },
        { 'bad duration key "epoch"'                     , { { epoch = 1 } } },
      }
    },
    diff = {
      { 106170000, "2026-03-30T12:00:00"    , { Date("2026-03-29T06:30:30"    )            } },
      { 0        , "2026-03-30T12:00:00"    , { Date("2026-03-30T12:00:00"    ), "ms"      } },
      { 150      , "2026-03-30T14:45:06.900", { Date("2026-03-30T14:45:06.750"), "ms"      } },
      { 106170   , "2026-03-30T12:00:00"    , { Date("2026-03-29T06:30:30"    ), "seconds" } },
      { 106170   , "2026-03-30T12:00:00"    , { Date("2026-03-29T06:30:30"    ), "second"  } },
      { -106170  , "2026-03-29T06:30:30"    , { Date("2026-03-30T12:00:00"    ), "seconds" } },
      { 1769     , "2026-03-30T12:00:00"    , { Date("2026-03-29T06:30:30"    ), "minutes" } },
      { 90       , "2026-03-30T12:00:00"    , { Date("2026-03-30T10:30:00"    ), "minutes" } },
      { 29       , "2026-03-30T12:00:00"    , { Date("2026-03-29T06:30:30"    ), "hours"   } },
      { 2        , "2026-03-30T12:00:00"    , { Date("2026-03-30T10:00:00"    ), "hours"   } },
      { 1        , "2026-03-30T12:00:00"    , { Date("2026-03-29T06:30:30"    ), "days"    } },
      { 2        , "2026-03-30T12:00:00"    , { Date("2026-03-28T12:00:00"    ), "days"    } },
      { 0        , "2026-03-30T12:00:00"    , { Date("2026-03-29T06:30:30"    ), "weeks"   } },
      { 1        , "2026-03-30T12:00:00"    , { Date("2026-03-20T12:00:00"    ), "weeks"   } },
      { 1        , "2026-03-31T12:00:00"    , { Date("2026-02-28T12:00:00"    ), "month"   } },
      { 1        , "2026-03-31T12:00:00"    , { Date("2026-02-28T12:00:00"    ), "months"  } },
      { 0        , "2026-03-31T12:00:00"    , { Date("2026-02-28T12:00:00"    ), "quarter" } },
      { 1        , "2026-06-30T12:00:00"    , { Date("2026-03-30T12:00:00"    ), "quarter" } },
      { 1        , "2027-03-31T12:00:00"    , { Date("2026-03-31T12:00:00"    ), "year"    } },
      { -1       , "2026-03-31T12:00:00"    , { Date("2027-03-31T12:00:00"    ), "year"    } },

      errors = {
        { "bad argument #1 (mods.Date expected)",                                              },
        { 'invalid unit "fortnight" (expected one of: M, d, day, days, h, hour, hours, m, millisecond, milliseconds, min, mins, minute, minutes, month, months, ms, q, quarter, quarters, s, sec, second, seconds, secs, w, week, weeks, y, year, years)', { Date(), "fortnight" } },
      }
    },
    startof = {
      { { year = 2026, month = 3, day = 30, wday = 1, yday = 89, hour = 14, min = 45, sec =  6, ms = 123 }, "2026-03-30T14:45:06.123", { "ms"      } },
      { { year = 2026, month = 3, day = 30, wday = 1, yday = 89, hour = 14, min = 45, sec =  6, ms =   0 }, "2026-03-30T14:45:06.123", { "second"  } },
      { { year = 2026, month = 3, day = 30, wday = 1, yday = 89, hour = 14, min = 45, sec =  0, ms =   0 }, "2026-03-30T14:45:06.123", { "minute"  } },
      { { year = 2026, month = 3, day = 30, wday = 1, yday = 89, hour = 14, min =  0, sec =  0, ms =   0 }, "2026-03-30T14:45:06.123", { "hour"    } },
      { { year = 2026, month = 3, day = 30, wday = 1, yday = 89, hour =  0, min =  0, sec =  0, ms =   0 }, "2026-03-30T14:45:06.123", { "day"     } },
      { { year = 2026, month = 3, day = 30, wday = 1, yday = 89, hour =  0, min =  0, sec =  0, ms =   0 }, "2026-03-30T14:45:06.123", { "week"    } },
      { { year = 2026, month = 3, day =  1, wday = 7, yday = 60, hour =  0, min =  0, sec =  0, ms =   0 }, "2026-03-30T14:45:06.123", { "month"   } },
      { { year = 2026, month = 1, day =  1, wday = 4, yday =  1, hour =  0, min =  0, sec =  0, ms =   0 }, "2026-03-30T14:45:06.123", { "quarter" } },
      { { year = 2026, month = 1, day =  1, wday = 4, yday =  1, hour =  0, min =  0, sec =  0, ms =   0 }, "2026-03-30T14:45:06.123", { "year"    } },
      { { year = 2026, month = 3, day = 30, wday = 1, yday = 89, hour =  0, min =  0, sec =  0, ms =   0 }, "2026-03-30T14:45:06.123", { "isoWeek" } },
      errors = {
        { "bad argument #1 (string expected, got no value)" },
        { 'invalid unit "fortnight" (expected one of: M, d, day, days, h, hour, hours, m, millisecond, milliseconds, min, mins, minute, minutes, month, months, ms, q, quarter, quarters, s, sec, second, seconds, secs, w, week, weeks, y, year, years)', { "fortnight" } },
      }
    },
    endof = {
      { { year = 2026, month =  3, day = 30, wday = 1, yday =  89, hour = 14, min = 45, sec =  6, ms = 123 }, "2026-03-30T14:45:06.123", { "ms"      } },
      { { year = 2026, month =  3, day = 30, wday = 1, yday =  89, hour = 14, min = 45, sec =  6, ms = 999 }, "2026-03-30T14:45:06.123", { "second"  } },
      { { year = 2026, month =  3, day = 30, wday = 1, yday =  89, hour = 14, min = 45, sec = 59, ms = 999 }, "2026-03-30T14:45:06.123", { "minute"  } },
      { { year = 2026, month =  3, day = 30, wday = 1, yday =  89, hour = 14, min = 59, sec = 59, ms = 999 }, "2026-03-30T14:45:06.123", { "hour"    } },
      { { year = 2026, month =  3, day = 30, wday = 1, yday =  89, hour = 23, min = 59, sec = 59, ms = 999 }, "2026-03-30T14:45:06.123", { "day"     } },
      { { year = 2026, month =  4, day =  5, wday = 7, yday =  95, hour = 23, min = 59, sec = 59, ms = 999 }, "2026-03-30T14:45:06.123", { "week"    } },
      { { year = 2026, month =  3, day = 31, wday = 2, yday =  90, hour = 23, min = 59, sec = 59, ms = 999 }, "2026-03-30T14:45:06.123", { "month"   } },
      { { year = 2026, month =  3, day = 31, wday = 2, yday =  90, hour = 23, min = 59, sec = 59, ms = 999 }, "2026-03-30T14:45:06.123", { "quarter" } },
      { { year = 2026, month = 12, day = 31, wday = 4, yday = 365, hour = 23, min = 59, sec = 59, ms = 999 }, "2026-03-30T14:45:06.123", { "year"    } },
      { { year = 2026, month =  4, day =  5, wday = 7, yday =  95, hour = 23, min = 59, sec = 59, ms = 999 }, "2026-03-30T14:45:06.123", { "isoWeek" } },
    },
    is_leap_year = {
      { true , "2024" },
      { false, "2025" },
    },
    day_of_year = {
      { 89, "2026-03-30" },
      { 60, "2024-02-29" },
    },
    week = {
      { 14, "2026-03-30" },
      { 1 , "2021-01-01" },
      { 53, "2016-12-31" },
    },
    iso_week = {
      { 14, "2026-03-30" },
      { 53, "2021-01-01" },
      { 1 , "2021-01-04" },
    },
weekday = {
      { cal.MONDAY, "2026-03-30" },
      { cal.SUNDAY, "2016-01-03" },
      { cal.FRIDAY, "2021-01-01" },
    },
    iso_weekday = {
      { cal.MONDAY, "2026-03-30" },
      { cal.SUNDAY, "2016-01-03" },
      { cal.FRIDAY, "2021-01-01" },
    },
    month_days = {
      { 29, "2024-02-01" },
      { 28, "2025-02-01" },
    },
    quarter = {
      { 1, "2026-03-30" },
      { 4, "2026-10-01" },
    },
    weeks_in_year = {
      { 52, "2026" },
      { 52, "2021" },
      { 52, "2016" },
    },
    iso_weeks_in_year = {
      { 53, "2026"       },
      { 52, "2021"       },
      { 52, "2016"       },
      { 52, "2016-06-01" },
    },
    week_year = {
      { 2026, "2026-03-30" },
      { 2021, "2021-01-01" },
      { 2016, "2016-12-31" },
    },
    iso_week_year = {
      { 2026, "2026-03-30" },
      { 2020, "2021-01-01" },
      { 2016, "2016-12-31" },
    },
    is_before = {
      { true , "2026-03-30T14:45:06", { Date("2026-03-30T14:45:07") } },
      { false, "2026-03-30T14:45:07", { Date("2026-03-30T14:45:06") } },
      { false, "2026-03-30T14:45:06", { Date("2026-03-30T14:45:06") } },
      errors = {
        { "bad argument #1 (mods.Date expected)" },
      }
    },
    is_same = {
      { true , "2026-03-30T14:45:06.123", { Date("2026-03-30T14:45:06.123") } },
      { false, "2026-03-30T14:45:06.124", { Date("2026-03-30T14:45:06.123") } },
      { false, "2026-03-30T14:45:06.124", { Date("2026-03-30T14:45:06.123") } },
      errors = {
        { "bad argument #1 (mods.Date expected)" },
      },
    },
    is_today = {
      { true , today     },
      { false, yesterday },
      { false, tomorrow  },
    },
    is_yesterday = {
      { true , yesterday },
      { false, today },
      { false, tomorrow },
    },
    is_tomorrow = {
      { true , tomorrow },
      { false, today },
      { false, yesterday },
    },
    is_same_or_before = {
      { true , "2026-03-30T14:45:06", { Date("2026-03-30T14:45:06") } },
      { true , "2026-03-30T14:45:06", { Date("2026-03-30T14:45:07") } },
      { false, "2026-03-30T14:45:07", { Date("2026-03-30T14:45:06") } },
      errors = {
        { "bad argument #1 (mods.Date expected)" },
      },
    },
    is_after = {
      { true , "2026-03-30T14:45:07", { Date("2026-03-30T14:45:06") } },
      { false, "2026-03-30T14:45:06", { Date("2026-03-30T14:45:07") } },
      { false, "2026-03-30T14:45:06", { Date("2026-03-30T14:45:06") } },
      errors = {
        { "bad argument #1 (mods.Date expected)" },
      },
    },
    is_same_or_after = {
      { true , "2026-03-30T14:45:07", { Date("2026-03-30T14:45:06") } },
      { true , "2026-03-30T14:45:07", { Date("2026-03-30T14:45:07") } },
      { false, "2026-03-30T14:45:06", { Date("2026-03-30T14:45:07") } },
      errors = {
        { "bad argument #1 (mods.Date expected)" },
      },
    },
    is_between = {
      { true , "2026-03-30T14:45:06", { Date("2026-03-30T14:45:05"), Date("2026-03-30T14:45:07") } },
      { true , "2026-03-30T14:45:06", { Date("2026-03-30T14:45:07"), Date("2026-03-30T14:45:05") } },
      { false, "2026-03-30T14:45:05", { Date("2026-03-30T14:45:05"), Date("2026-03-30T14:45:07") } },
      { false, "2026-03-30T14:45:07", { Date("2026-03-30T14:45:05"), Date("2026-03-30T14:45:07") } },

      -- inclusive bounds
      { true , "2026-03-30T14:45:05", { Date("2026-03-30T14:45:05"), Date("2026-03-30T14:45:07"), true } },
      { true , "2026-03-30T14:45:07", { Date("2026-03-30T14:45:05"), Date("2026-03-30T14:45:07"), true } },
    },
    format = {
      -- Year and unix timestamps.

      { "26"                      , "2026"        , { "YY"   } },
      { "2026"                    , "2026"        , { "YYYY" } },
      { "1523520536"              , 1523520536123 , { "X"    } },
      { "1523520536123"           , 1523520536123 , { "x"    } },

      -- Quarter and month.

      { "1"                       , "2026"   , { "Q"    } },
      { "4"                       , "2026-10", { "Q"    } },
      { "1"                       , "2026"   , { "M"    } },
      { "01"                      , "2026-01", { "MM"   } },
      { "Jan"                     , "2026-01", { "MMM"  } },
      { "January"                 , "2026-01", { "MMMM" } },

      -- Day and weekday.

      { "1"                       , "2026-03"   , { "D"    } },
      { "01"                      , "2026-03-01", { "DD"   } },
      { "0"                       , "2026-03-22", { "d"    } },
      { "6"                       , "2026-03-28", { "d"    } },
      { "Su"                      , "2026-03-22", { "dd"   } },
      { "Sun"                     , "2026-03-22", { "ddd"  } },
      { "Sunday"                  , "2026-03-22", { "dddd" } },
      { "1st"                     , "2026-03-01", { "Do"   } },
      { "2nd"                     , "2026-03-02", { "Do"   } },
      { "3rd"                     , "2026-03-03", { "Do"   } },
      { "4th"                     , "2026-03-04", { "Do"   } },
      { "21st"                    , "2026-03-21", { "Do"   } },
      { "22nd"                    , "2026-03-22", { "Do"   } },
      { "23rd"                    , "2026-03-23", { "Do"   } },
      { "10th"                    , "2026-03-10", { "Do"   } },
      { "11th"                    , "2026-03-11", { "Do"   } },
      { "30th"                    , "2026-03-30", { "Do"   } },
      { "31st"                    , "2026-03-31", { "Do"   } },

      -- Hour and meridiem.

      { "0"                       , "2026-03-30 00", { "H"  } },
      { "1"                       , "2026-03-30 01", { "H"  } },
      { "00"                      , "2026-03-30 00", { "HH" } },
      { "1"                       , "2026-03-30 13", { "h"  } },
      { "01"                      , "2026-03-30 13", { "hh" } },
      { "1"                       , "2026-03-30 01", { "k"  } },
      { "01"                      , "2026-03-30 01", { "kk" } },
      { "am"                      , "2026-03-30 00", { "a"  } },
      { "pm"                      , "2026-03-30 23", { "a"  } },
      { "AM"                      , "2026-03-30 00", { "A"  } },
      { "PM"                      , "2026-03-30 23", { "A"  } },

      -- Minute, second, and millisecond.

      { "0"                       , "2026-03-30T15"          , { "m"   } },
      { "1"                       , "2026-03-30T15:01"       , { "m"   } },
      { "01"                      , "2026-03-30T15:01"       , { "mm"  } },
      { "0"                       , "2026-03-30T15:01"       , { "s"   } },
      { "2"                       , "2026-03-30T15:16:02"    , { "s"   } },
      { "02"                      , "2026-03-30T15:16:02"    , { "ss"  } },
      { "0"                       , "2026-03-30T15:16:02"    , { "S"   } },
      { "0"                       , "2026-03-30T15:16:02.010", { "S"   } },
      { "1"                       , "2026-03-30T15:16:02.123", { "S"   } },
      { "00"                      , "2026-03-30T15:16:06"    , { "SS"  } },
      { "12"                      , "2026-03-30T15:16:06.123", { "SS"  } },
      { "000"                     , "2026-03-30T15:16:02"    , { "SSS" } },
      { "123"                     , "2026-03-30T15:16:02.123", { "SSS" } },

      -- Combined patterns.

      { "2026/03/30 14:05:06"           , "2026-03-30T14:05:06.123", { "YYYY/MM/DD HH:mm:ss"       } },
      { "26 2026"                       , "2026-03-30T14:05:06.123", { "YY YYYY"                   } },
      { "3 03 Mar March"                , "2026-03-30T14:05:06.123", { "M MM MMM MMMM"             } },
      { "30 30th 1 1 Mo Mon Monday"     , "2026-03-30T14:05:06.123", { "D Do d e dd ddd dddd"      } },
      { "89 089"                        , "2026-03-30T14:05:06.123", { "DDD DDDD"                  } },
      { "60 060"                        , "2024-02-29T12:00:00"    , { "DDD DDDD"                  } },
      { "1"                             , "2026-03-30T14:05:06.123", { "E"                         } },
      { "14 14 2 02 14 14 PM pm"        , "2026-03-30T14:05:06.123", { "H HH h hh k kk A a"        } },
      { "5 05 1 1st 6 06 1 12 123"      , "2026-03-30T14:05:06.123", { "m mm Q Qo s ss S SS SSS"   } },
      { "14 14 26 2026 14 14 14th 2026" , "2026-03-30T14:05:06.123", { "W WW GG GGGG w ww wo gggg" } },
      { "53 53 20 2020 1 01 1st 2021"   , "2021-01-01T12:00:00"    , { "W WW GG GGGG w ww wo gggg" } },
      { "1 01 21 2021 2 02 2nd 2021"    , "2021-01-04T12:00:00"    , { "W WW GG GGGG w ww wo gggg" } },
      { "53 53 15 2015 2 02 2nd 2016"   , "2016-01-03T12:00:00"    , { "W WW GG GGGG w ww wo gggg" } },
      { "52 52 16 2016 53 53 53rd 2016" , "2016-12-31T12:00:00"    , { "W WW GG GGGG w ww wo gggg" } },
      { "2:05 PM"                       , "2026-03-30T14:05:06.123", { "LT"                        } },
      { "2:05:06 PM"                    , "2026-03-30T14:05:06.123", { "LTS"                       } },
      { "03/30/2026"                    , "2026-03-30T14:05:06.123", { "L"                         } },
      { "March 30, 2026"                , "2026-03-30T14:05:06.123", { "LL"                        } },
      { "March 30, 2026 2:05 PM"        , "2026-03-30T14:05:06.123", { "LLL"                       } },
      { "Monday, March 30, 2026 2:05 PM", "2026-03-30T14:05:06.123", { "LLLL"                      } },
      { "3/30/2026"                     , "2026-03-30T14:05:06.123", { "l"                         } },
      { "Mar 30, 2026"                  , "2026-03-30T14:05:06.123", { "ll"                        } },
      { "Mar 30, 2026 2:05 PM"          , "2026-03-30T14:05:06.123", { "lll"                       } },
      { "Mon, Mar 30, 2026 2:05 PM"     , "2026-03-30T14:05:06.123", { "llll"                      } },
      { "2026-W14"                      , "2026-03-30T14:05:06.123", { "GGGG-[W]WW"                } },
      { "Today: March 30, 2026"         , "2026-03-30T14:05:06.123", { "[Today:] LL"               } },
      { "1523520536 1523520536123"      , 1523520536123            , { "X x"                       } },
      { "Mon, Mar 30 2026 2:05 PM"      , "2026-03-30T14:05:06.123", { "ddd, MMM D YYYY h:mm A"    } },

      errors = {
        { "bad argument #1 (string expected, got no value)" },
        { "bad argument #1 (string expected, got number)", { 123 } },
      }
    },

  }

  for fname, t in spairs(tests) do
    local errors = t.errors

    for i = 1, #t do
      local expected, date, args = unpack(t[i] --[[@as {[1]:any, [2]:any, [3]:any?}]])
      it(fmt("date(%q):%s(%s)", tostring(date), fname, args_repr(args)), function()
        local d = Date(date)
        local res = d[fname](d, unpack(args or {}))
        assert.same(expected, res)
      end)
    end

    for i = 1, #(errors or {}) do
      local errmsg, args = unpack(errors[i] --[[@as {[1]:string, [2]:any[]?}]])
      it(fmt("date():%s(%s)", fname, args_repr(args)), function()
        local d = Date()
        assert.has_error(function()
          d[fname](d, unpack(args or {}))
        end, errmsg)
      end)
    end
  end

  --------------------------------------
  ------------- tostring() -------------
  --------------------------------------

  -- stylua: ignore
  tests = {
    { "2026-03-30 14:45:06"    , { "2026-03-30T14:45:06"                                      } },
    { "2026-03-30 14:45:06"    , { "2026-03-30 14:45:06"                                      } },
    { "2026-03-30 00:00:00"    , { "2026-03-30"                                               } },
    { "2026-03-30 14:45:06.123", { "2026-03-30T14:45:06.123"                                  } },
    { "1995-01-01 00:00:00"    , { "1995"                       , "YYYY"                      } },
    { "1995-12-01 00:00:00"    , { "1995-12"                    , "YYYY-MM"                   } },
    { "2026-03-30 00:00:00"    , { "2026/03/30"                 , "YYYY/MM/DD"                } },
    { "2026-03-30 00:00:00"    , { "2026.03.30"                 , "YYYY.MM.DD"                } },
    { "1995-12-25 00:00:00"    , { "12-25-1995"                 , "MM-DD-YYYY"                } },
    { "1995-12-25 00:00:00"    , { "25-12-1995"                 , "DD-MM-YYYY"                } },
    { "2026-03-30 00:00:00"    , { "20260330"                   , "YYYYMMDD"                  } },
    { "2026-03-30 14:45:00"    , { "03/30/2026 14:45"           , "MM/DD/YYYY HH:mm"          } },
    { "2026-03-30 14:45:06"    , { "03/30/2026 14:45:06"        , "MM/DD/YYYY HH:mm:ss"       } },
    { "2026-03-30 14:45:06.123", { "03/30/2026 14:45:06.123"    , "MM/DD/YYYY HH:mm:ss.SSS"   } },
    { "2026-03-05 04:07:09"    , { "3/5/2026 4:7:9"             , "M/D/YYYY H:m:s"            } },
    { "2026-03-30 14:45:00"    , { "3/30/2026 14:45"            , "M/D/YYYY H:m"              } },
    { "2026-03-30 14:45:00"    , { "2026-03-30 @ 14:45"         , "YYYY-MM-DD @ HH:mm"        } },
    { "2026-03-30 14:45:00"    , { "[2026-03-30] 14:45"         , "[YYYY-MM-DD] HH:mm"        } },
    { "2026-03-30 14:45:00"    , { "03/30/2026 02:45 PM"        , "MM/DD/YYYY hh:mm A"        } },
    { "2026-03-30 02:45:00"    , { "03/30/2026 02:45 am"        , "MM/DD/YYYY hh:mm a"        } },
    { "2026-03-30 00:00:00"    , { "03/30/2026 12:00 AM"        , "MM/DD/YYYY hh:mm A"        } },
    { "2026-03-30 12:00:00"    , { "03/30/2026 12:00 PM"        , "MM/DD/YYYY hh:mm A"        } },
    { "2026-03-30 14:45:00"    , { "03/30/2026 2:45 PM"         , "MM/DD/YYYY h:mm A"         } },
    { "2026-03-30 00:00:00"    , { "Mar 30, 2026"               , "MMM D, YYYY"               } },
    { "2026-03-30 00:00:00"    , { "mar 30, 2026"               , "MMM D, YYYY"               } },
    { "2026-03-30 00:00:00"    , { "MAR 30, 2026"               , "MMM D, YYYY"               } },
    { "2026-03-30 00:00:00"    , { "March 30, 2026"             , "MMMM D, YYYY"              } },
    { "2026-03-30 00:00:00"    , { "march 30, 2026"             , "MMMM D, YYYY"              } },
    { "2026-03-30 00:00:00"    , { "MARCH 30, 2026"             , "MMMM D, YYYY"              } },
    { "2026-03-30 14:45:00"    , { "Mar 30, 2026 2:45 PM"       , "MMM D, YYYY h:mm A"        } },
    { "2026-03-30 14:45:06.123", { "March 30, 2026 14:45:06.123", "MMMM D, YYYY HH:mm:ss.SSS" } },
    { "2026-03-30 07:00:00"    , { "03/30/2026 7"               , "MM/DD/YYYY H"              } },
    { "2026-03-30 23:00:00"    , { "03/30/2026 11 PM"           , "MM/DD/YYYY h A"            } },
    { "-044-03-15 00:00:00"    , { "-0044-03-15"                , "YYYY-MM-DD"                } },
    { "-044-03-15 12:34:56"    , { "-0044-03-15 12:34:56"       , "YYYY-MM-DD HH:mm:ss"       } },

    { "2026-01-01 00:00:00", { { year = 2026 } } },
    { "2026-03-30 14:45:06", { { year = 2026, month = 3, day = 30, hour = 14, min = 45, sec = 6 } } },
  }

  for _, t in ipairs(tests) do
    local expected, args = unpack(t --[[@as {[1]:string, [2]:{}}]])
    it(fmt("Date(%s):tostring()", args_repr(args)), function()
      assert.are_equal(expected, Date(unpack(args)):tostring())
    end)
  end

  ----------------------------------------
  -------------- is_valid() --------------
  ----------------------------------------

  -- stylua: ignore
  tests = {
    -- Argument Types

    { true , { { year = 2026              } } },
    { false, { { year = "2026"            } } },
    { true , { 1523520536123                } },
    { false, { { year = 2026, month = "3" } } },
    { true , { "2026-03-30"                 } },
    { false, { true                         } },
    { false, { false                        } },

    -- Pattern & Format Validation

    { true , { "12-25-1995"             , "MM-DD-YYYY"              } },
    { false, { "12-25-1995"             , "YYYY-MM-DD"              } },
    { true , { "03/30/2026 14:45:06.123", "MM/DD/YYYY HH:mm:ss.SSS" } },
    { false, { "03/30/2026"             , "MM-DD-YYYY"              } },

    -- Part Range Validation

    { true , { { year = 2026, month = 12          } } },
    { false, { { year = 2026, month = 0           } } },
    { false, { { year = 2026, month = 13          } } },
    { true , { { year = 2026, month = 3, day =  1 } } },
    { false, { { year = 2026, month = 3, day =  0 } } },
    { false, { { year = 2026, month = 3, day = 32 } } },
    { true , { { year = 2026, hour  = 23          } } },
    { false, { { year = 2026, hour  = -1          } } },
    { false, { { year = 2026, hour  = 24          } } },
    { true , { { year = 2026, min   = 59          } } },
    { false, { { year = 2026, min   = -1          } } },
    { false, { { year = 2026, min   = 60          } } },
    { true , { { year = 2026, sec   = 59          } } },
    { false, { { year = 2026, sec   = -1          } } },
    { false, { { year = 2026, sec   = 60          } } },
    { true , { { year = 2026, ms    = 999         } } },
    { false, { { year = 2026, ms    = -1          } } },
    { false, { { year = 2026, ms    = 1000        } } },

    -- Calendar Math & Logic Validation

    { false, { {               month = 3, day = 30 } } },
    { true , { { year  = 2026, month = 4, day = 30 } } },
    { false, { { year  = 2026, month = 4, day = 31 } } },
    { true , { { year  = 2024, month = 2, day = 29 } } }, -- Leap Year
    { false, { { year  = 2025, month = 2, day = 29 } } }, -- Non-Leap Year
    { true , { { year  = 2026                      } } },
  }

  for _, t in ipairs(tests) do
    local expected, args = unpack(t --[[@as {[1]:boolean, [2]:any}]], 1, 2)
    it(fmt("is_valid(%s)", args_repr(args)), function()
      local res = Date.is_valid(unpack(args))
      assert.are_equal(expected, res)
    end)
  end

  describe("min/max/minmax()", function()
    local a = Date("2026-03-30T14:45:06")
    local b = Date("2026-03-28T14:45:06")
    local c = Date("2026-03-31T14:45:06")
    local d = Date("2026-04-01T14:45:06")

    it("returns the earliest and latest dates", function()
      local min_date, max_date = Date.minmax(a, b, c)
      assert.same(b, min_date)
      assert.same(c, max_date)
    end)

    it("accepts a list of dates", function()
      local ls = { a, b, c }
      assert.same(b, Date.min(ls))
      assert.same(c, Date.max(ls))

      local min_date, max_date = Date.minmax(ls)
      assert.same(b, min_date)
      assert.same(c, max_date)
    end)

    it("keeps a single date unchanged", function()
      local min_date, max_date = Date.minmax({ a })
      assert.same(a, Date.min({ a }))
      assert.same(a, Date.max({ a }))
      assert.same(a, min_date)
      assert.same(a, max_date)
    end)

    it("accepts a date and a list of dates", function()
      local ls = { a, b, c }
      assert.same(b, Date.min(ls, d))
      assert.same(d, Date.max(ls, d))
      assert.same(b, Date.min(d, ls))
      assert.same(c, Date.max(a, ls))

      local min_date, max_date = Date.minmax(d, ls)
      assert.same(b, min_date)
      assert.same(d, max_date)
    end)

    -- stylua: ignore
    it("errors on invalid argument types", function()
      assert.Error(function() Date.min()                          end, "bad argument #1 (mods.Date expected)")
      assert.Error(function() Date.max(a, "2026-03-31")           end, "bad argument #2 (mods.Date expected)")
      assert.Error(function() Date.min({})                        end, "invalid value at index 1 in argument #1 (mods.Date expected)")
      assert.Error(function() Date.max(a, b, { c, "2026-03-30" }) end, "invalid value at index 2 in argument #3 (mods.Date expected)")
    end)
  end)

  describe("unix", function()
    it("creates a Date from unix seconds", function()
      local d = Date.unix(1745155206)
      assert.are_equal(2025, d.year)
      assert.are_equal(4, d.month)
      assert.are_equal(20, d.day)
    end)

    it("creates a Date from fractional unix seconds", function()
      local d = Date.unix(1745155206.123)
      assert.are_equal(123, d.ms)
    end)

    it("truncates sub-millisecond unix precision", function()
      local d = Date.unix(1745155206.1239)
      assert.are_equal(123, d.ms)
    end)
  end)

  describe("locale-aware getters and setters", function()
    it("supports quarter getter/setter", function()
      local d = Date("2026-03-30T14:45:06")
      assert.are.equal(1, d:quarter())
      assert.are.equal("2026-06-30 14:45:06", tostring(d:quarter(2)))
      assert.are.equal("2027-03-30 14:45:06", tostring(d:quarter(5)))
    end)

    it("supports day-of-year getter/setter", function()
      local d = Date("2026-03-30T14:45:06")
      assert.are.equal(89, d:day_of_year())
      assert.are.equal("2026-01-01 14:45:06", tostring(d:day_of_year(1)))
      assert.are.equal("2027-01-01 14:45:06", tostring(d:day_of_year(366)))
    end)

    it("supports week and iso_week getters/setters", function()
      local d = Date("2026-03-30T14:45:06")
      assert.are.equal(14, d:week())
      assert.are.equal(14, d:iso_week())
      assert.are.equal("2026-04-06 14:45:06", tostring(d:week(15)))
      assert.are.equal("2026-04-06 14:45:06", tostring(d:iso_week(15)))
    end)

    it("supports locale-aware weeks_in_year", function()
      cal.setfirstweekday(cal.MONDAY)
      assert.are.equal(52, Date("2026-03-30T14:45:06"):weeks_in_year())

      cal.setfirstweekday(cal.SUNDAY)
      assert.are.equal(53, Date("2016-06-01T14:45:06"):weeks_in_year())
    end)

    it("supports iso_weekday getter/setter with overflow", function()
      local d = Date("2026-03-30T14:45:06")
      assert.are.equal(cal.MONDAY, d:iso_weekday())
      assert.are.equal("2026-04-05 14:45:06", tostring(d:iso_weekday(7)))
      assert.are.equal("2026-04-06 14:45:06", tostring(d:iso_weekday(8)))
    end)
  end)

  describe("setters", function()
    it("weekday(n) adds n days", function()
      local d = Date("2026-03-30")
      assert.are_equal(1, d.wday)
      local result = d:weekday(0)
      assert.are_equal(1, result.wday)
      assert.are_equal("2026-03-30", result:format("YYYY-MM-DD"))
      local result2 = d:weekday(1)
      assert.are_equal(2, result2.wday)
    end)

    it("quarter(n) changes to the nth quarter", function()
      local d = Date("2026-03-30")
      assert.are_equal(1, d:quarter())
      local result = d:quarter(3)
      assert.are_equal(3, result:quarter())
      assert.are_equal(9, result.month)
    end)

    it("day_of_year(n) changes to day n of year", function()
      local d = Date("2026-03-30"):day_of_year(15)
      assert.are_equal(15, d.day)
      assert.are_equal(1, d.month)
    end)

    it("week(n) changes to week n of year", function()
      local d = Date("2026-03-30"):week(14)
      assert.are_equal(14, d:week())
    end)

    it("iso_week(n) changes to ISO week n", function()
      local d = Date("2026-03-30"):iso_week(14)
      assert.are_equal(14, d:iso_week())
    end)

    it("iso_weekday(n) changes to ISO weekday n", function()
      local d = Date("2026-03-30"):iso_weekday(2)
      assert.are_equal(2, d:iso_weekday())
    end)
  end)

  describe("metamethods", function()
    it("__eq (==)", function()
      assert.is_true(Date("2026-03-30T14:45:06") == Date("2026-03-30 14:45:06"))
      assert.is_false(Date("2026-03-30T14:45:06") == Date("2026-03-30 14:45:07"))
      assert.is_false(Date("2026-03-30T14:45:06") == "2026-03-30 14:45:06")
    end)

    it("__lt (<)", function()
      assert.is_true(Date("2026-03-30T14:45:06") < Date("2026-03-30T14:45:07"))
      assert.is_false(Date("2026-03-30T14:45:07") < Date("2026-03-30T14:45:06"))
      assert.is_false(Date("2026-03-30T14:45:06") < Date("2026-03-30T14:45:06"))

      assert.Error(function()
        _ = Date("2026-03-30T14:45:06") < ""
      end, fmt("attempt to compare %s with string", is_lua51 and "table" or "mods.Date"))
      assert.Error(function()
        _ = 123 < Date("2026-03-30T14:45:06")
      end, fmt("attempt to compare number with %s", is_lua51 and "table" or "mods.Date"))
    end)

    it("__le (<=)", function()
      assert.is_true(Date("2026-03-30T14:45:06") <= Date("2026-03-30T14:45:06"))
      assert.is_true(Date("2026-03-30T14:45:06") <= Date("2026-03-30T14:45:07"))
      assert.is_false(Date("2026-03-30T14:45:07") <= Date("2026-03-30T14:45:06"))

      assert.Error(function()
        _ = Date("2026-03-30T14:45:06") <= ""
      end, fmt("attempt to compare %s with string", is_lua51 and "table" or "mods.Date"))
      assert.Error(function()
        _ = 123 <= Date("2026-03-30T14:45:06")
      end, fmt("attempt to compare number with %s", is_lua51 and "table" or "mods.Date"))
    end)

    it("__gt (>)", function()
      assert.is_true(Date("2026-03-30T14:45:07") > Date("2026-03-30T14:45:06"))
      assert.is_false(Date("2026-03-30T14:45:06") > Date("2026-03-30T14:45:07"))
      assert.is_false(Date("2026-03-30T14:45:06") > Date("2026-03-30T14:45:06"))

      assert.Error(function()
        _ = Date("2026-03-30T14:45:06") > ""
      end, fmt("attempt to compare string with %s", is_lua51 and "table" or "mods.Date"))
      assert.Error(function()
        _ = 123 > Date("2026-03-30T14:45:06")
      end, fmt("attempt to compare %s with number", is_lua51 and "table" or "mods.Date"))
    end)

    it("__ge (>=)", function()
      assert.is_true(Date("2026-03-30T14:45:06") >= Date("2026-03-30T14:45:06"))
      assert.is_true(Date("2026-03-30T14:45:07") >= Date("2026-03-30T14:45:06"))
      assert.is_false(Date("2026-03-30T14:45:06") >= Date("2026-03-30T14:45:07"))

      assert.Error(function()
        _ = Date("2026-03-30T14:45:06") >= 123
      end, fmt("attempt to compare number with %s", is_lua51 and "table" or "mods.Date"))
      assert.Error(function()
        _ = "" >= Date("2026-03-30T14:45:06")
      end, fmt("attempt to compare %s with string", is_lua51 and "table" or "mods.Date"))
    end)

    it("__add (+)", function()
      local date = Date("2026-03-30T14:45:06")
      assert.are_equal("2026-03-30 14:45:06.250", (date + 250.55):tostring())
      assert.are_equal("2026-03-30 14:45:06.250", (250.55 + date):tostring())

      assert.Error(function()
        _ = Date("2026-03-30T14:45:06") + ""
      end, "attempt to perform arithmetic on a string value")
      assert.Error(function()
        _ = {} + Date("2026-03-30T14:45:06")
      end, "attempt to perform arithmetic on a table value")
      assert.Error(function()
        _ = Date() + Date()
      end, "attempt to perform arithmetic on a mods.Date value")
    end)

    it("__sub (-)", function()
      local date = Date("2026-03-30T14:45:06")
      assert.are_equal("2026-03-30 14:45:05.750", (date - 250.55):tostring())
      assert.are_equal("2026-03-30 14:45:05.750", (250.55 - date):tostring())

      assert.Error(function()
        _ = Date("2026-03-30T14:45:06") - ""
      end, "attempt to perform arithmetic on a string value")
      assert.Error(function()
        _ = {} - Date("2026-03-30T14:45:06")
      end, "attempt to perform arithmetic on a table value")
      assert.Error(function()
        _ = Date() + Date()
      end, "attempt to perform arithmetic on a mods.Date value")
    end)

    it("__tostring (tostring)", function()
      assert.are_equal("2026-03-30 14:45:06", tostring(Date("2026-03-30T14:45:06")))
      assert.are_equal("2026-03-30 14:45:06.123", tostring(Date("2026-03-30T14:45:06.123")))
    end)
  end)

  describe("relative time", function()
    local d = Date("2026-03-30T12:00:00")

    it("formats future and past relative dates", function()
      assert.are_equal("in 3 days", d:add(3, "day"):from(d))
      assert.are_equal("3 days ago", d:from(d:add(3, "day")))
      assert.are_equal("in 2 hours", d:to(d:add(2, "hour")))
      assert.are_equal("2 hours ago", d:add(2, "hour"):to(d))
    end)

    it("supports omitting suffixes", function()
      assert.are_equal("3 days", d:add(3, "day"):from(d, true))
      assert.are_equal("2 hours", d:to(d:add(2, "hour"), true))
      assert.are_equal("a few seconds", d:from(d, true))
    end)

    it("covers all humanized relative-time buckets", function()
      -- stylua: ignore
      local tests = {
        { "a few seconds", d:add(30, "second")},
        { "a minute"     , d:add( 1, "minute")},
        { "2 minutes"    , d:add( 2, "minute")},
        { "an hour"      , d:add( 1, "hour"  )},
        { "2 hours"      , d:add( 2, "hour"  )},
        { "a day"        , d:add( 1, "day"   )},
        { "3 days"       , d:add( 3, "day"   )},
        { "a month"      , d:add( 1, "month" )},
        { "3 months"     , d:add( 3, "month" )},
        { "a year"       , d:add( 1, "year"  )},
        { "2 years"      , d:add( 2, "year"  )},
      }

      for i = 1, #tests do
        local expected, other = unpack(tests[i] --[[@as {[1]:string, [2]:mods.Date}]])
        assert.are_equal("in " .. expected, other:from(d))
        assert.are_equal(expected .. " ago", d:from(other))
        assert.are_equal("in " .. expected, d:to(other))
        assert.are_equal(expected .. " ago", other:to(d))
        assert.are_equal(expected, other:from(d, true))
        assert.are_equal(expected, d:to(other, true))
      end
    end)

    it("formats relative time against now", function()
      local now = Date()
      assert.are_equal("in a day", now:add(1, "day"):from_now())
      assert.are_equal("a day ago", now:subtract(1, "day"):from_now())
      assert.are_equal("in a day", now:subtract(1, "day"):to_now())
      assert.are_equal("a day ago", now:add(1, "day"):to_now())
      assert.are_equal("a day", now:add(1, "day"):from_now(true))
      assert.are_equal("a day", now:subtract(1, "day"):to_now(true))
    end)
  end)
end)
