local helpers = require "spec.helpers"
local mods = require "mods"

local cal = mods.calendar

local test_functions = helpers.test_functions

describe("mods.calendar", function()
  after_each(function()
    cal.setfirstweekday(cal.MONDAY)
  end)

  -- stylua: ignore
  local months = {
    "January", "February", "March"    , "April"  , "May"     , "June"    ,
    "July"   , "August"  , "September", "October", "November", "December",
  }
  local days = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" }

  test_functions(cal, {
    -- stylua: ignore start
    --{{expected}, {args}}

    isleap = {
      -- Typical Leap Years vs Non-Leap Years
      {{ true  }, { 2024 }},
      {{ false }, { 2025 }},

      -- Century Years (must be divisible by 400 to be leap)
      {{ true  }, { 2000 }},
      {{ false }, { 2100 }},

      {{ true  }, { 1600 }},
      {{ false }, { 1900 }},

      {{ true  }, { 2400 }},
    },
    leapdays = {
      {{ 0 }, { 2000, 2000 }},
      {{ 1 }, { 2000, 2001 }},
      {{ 0 }, { 2010, 2011 }},
      {{ 7 }, { 2000, 2025 }},
    },
    weekday = {
      {{ cal.THURSDAY }, { 1970, 1, 1  }},
      {{ cal.THURSDAY }, { 2026, 3, 26 }},
    },
    monthrange = {
      {{ cal.THURSDAY, 29 }, { 2024, 2 }},
      {{ cal.SUNDAY  , 28 }, { 2026, 2 }},
    },
    weekheader = {
      {{ "Mo Tu We Th Fr Sa Su"                                                         }, {    }},
      {{ "M T W T F S S"                                                                }, { 1  }},
      {{ "Mo Tu We Th Fr Sa Su"                                                         }, { 2  }},
      {{ "Mon Tue Wed Thu Fri Sat Sun"                                                  }, { 3  }},
      {{ "Monday     Tuesday    Wednesday  Thursday   Friday     Saturday   Sunday    " }, { 10 }},
    },
  })

  it("exports month constants", function()
    for no, name in ipairs(months) do
      assert.are_equal(no, cal[name:upper()])
    end
  end)

  it("exports weekday constants", function()
    local weekdays = days
    for no, name in ipairs(weekdays) do
      assert.are_equal(no, cal[name:upper()])
    end
  end)

  it("exports month names", function()
    assert.is_list(cal.months)
    assert.are_same(months, cal.months)
  end)

  it("exports weekday names", function()
    assert.is_list(cal.days)
    assert.are_same(days, cal.days)
  end)

  describe("weekdays()", function()
    it("returns a function iterator", function()
      assert.is_function(cal.weekdays())
    end)

    it("iterates Monday-first by default", function()
      local weekdays = {}
      for weekday in cal.weekdays() do
        weekdays[#weekdays + 1] = weekday
      end
      assert.are_same({ 1, 2, 3, 4, 5, 6, 7 }, weekdays)
    end)

    it("iterates from the requested first weekday", function()
      local weekdays = {}
      for weekday in cal.weekdays(cal.SUNDAY) do
        weekdays[#weekdays + 1] = weekday
      end
      assert.are_same({ 7, 1, 2, 3, 4, 5, 6 }, weekdays)
    end)
  end)

  describe("monthdays()", function()
    it("returns (year, month, day, weekday) tuples", function()
      local items = {}
      for year, month, day, weekday in cal.monthdays(2026, 2) do
        items[#items + 1] = { year, month, day, weekday }
      end
      assert.are_same({ 2026, 1, 26, cal.MONDAY }, items[1])
      assert.are_same({ 2026, 2, 1, cal.SUNDAY }, items[7])
      assert.are_same({ 2026, 3, 1, cal.SUNDAY }, items[35])
    end)

    it("pads February 2026 to full Monday-first weeks by default", function()
      local items = {}
      for year, month, day in cal.monthdays(2026, 2) do
        items[#items + 1] = ("%04d-%02d-%02d"):format(year, month, day)
      end
      -- stylua: ignore
      assert.are_same({
        "2026-01-26", "2026-01-27", "2026-01-28", "2026-01-29", "2026-01-30", "2026-01-31", "2026-02-01",
        "2026-02-02", "2026-02-03", "2026-02-04", "2026-02-05", "2026-02-06", "2026-02-07", "2026-02-08",
        "2026-02-09", "2026-02-10", "2026-02-11", "2026-02-12", "2026-02-13", "2026-02-14", "2026-02-15",
        "2026-02-16", "2026-02-17", "2026-02-18", "2026-02-19", "2026-02-20", "2026-02-21", "2026-02-22",
        "2026-02-23", "2026-02-24", "2026-02-25", "2026-02-26", "2026-02-27", "2026-02-28", "2026-03-01",
      }, items)
    end)

    it("respects the requested first weekday", function()
      local items = {}
      for year, month, day in cal.monthdays(2026, 2, cal.SUNDAY) do
        items[#items + 1] = ("%04d-%02d-%02d"):format(year, month, day)
      end
      -- stylua: ignore
      assert.are_same({
        "2026-02-01", "2026-02-02", "2026-02-03", "2026-02-04", "2026-02-05", "2026-02-06", "2026-02-07",
        "2026-02-08", "2026-02-09", "2026-02-10", "2026-02-11", "2026-02-12", "2026-02-13", "2026-02-14",
        "2026-02-15", "2026-02-16", "2026-02-17", "2026-02-18", "2026-02-19", "2026-02-20", "2026-02-21",
        "2026-02-22", "2026-02-23", "2026-02-24", "2026-02-25", "2026-02-26", "2026-02-27", "2026-02-28",
      }, items)
    end)
  end)

  it("weekheader() returns headers for Sunday-first weeks", function()
    assert.are_equal("Su Mo Tu We Th Fr Sa", cal.weekheader(2, cal.SUNDAY))
  end)

  it("getfirstweekday() returns the module-global default", function()
    assert.are_equal(cal.MONDAY, cal.getfirstweekday())
    cal.setfirstweekday(cal.SUNDAY)
    assert.are_equal(cal.SUNDAY, cal.getfirstweekday())
  end)

  it("firstweekday field is readable and writable as a property", function()
    assert.are_equal(cal.MONDAY, cal.firstweekday)
    cal.firstweekday = cal.SUNDAY
    assert.are_equal(cal.SUNDAY, cal.firstweekday)
    assert.are_equal(cal.SUNDAY, cal.getfirstweekday())
  end)

  describe("validation", function()
    describe("argument types", function()
      it("errors on invalid types", function()
        -- Argument #1 validation.
        assert.Error(function()
          cal.isleap(true)
        end, "bad argument #1 (integer value expected, got true)")
        assert.Error(function()
          cal.monthdays(false, 2)
        end, "bad argument #1 (integer value expected, got false)")
        assert.Error(function()
          cal.monthrange(2026.5, 3)
        end, "bad argument #1 (integer value expected, got 2026.5)")
        assert.Error(function()
          cal.setfirstweekday(7.5)
        end, "bad argument #1 (integer value expected, got 7.5)")
        assert.Error(function()
          cal.setfirstweekday(true)
        end, "bad argument #1 (integer value expected, got true)")
        assert.Error(function()
          cal.weekdays(false)
        end, "bad argument #1 (integer value expected, got false)")
        assert.Error(function()
          cal.weekheader("2")
        end, [[bad argument #1 (integer value expected, got "2")]])

        -- Argument #2 validation.
        assert.Error(function()
          cal.leapdays(2000, false)
        end, "bad argument #2 (integer value expected, got false)")
        assert.Error(function()
          cal.monthdays(2026, "2")
        end, [[bad argument #2 (integer value expected, got "2")]])
        assert.Error(function()
          cal.monthrange(2026)
        end, "bad argument #2 (integer value expected, got no value)")
        assert.Error(function()
          cal.weekday(2026, "3", 1)
        end, [[bad argument #2 (integer value expected, got "3")]])
        assert.Error(function()
          cal.weekheader(2, "7")
        end, [[bad argument #2 (integer value expected, got "7")]])

        -- Argument #3 validation.
        assert.Error(function()
          cal.monthdays(2026, 2, "7")
        end, [[bad argument #3 (integer value expected, got "7")]])
      end)

      it("accepts valid types", function()
        assert.has_no_error(function()
          cal.isleap(2026)
        end)
        assert.has_no_error(function()
          cal.monthrange(2026, 3)
        end)
      end)
    end)

    describe("month range", function()
      it("errors on out-of-range months", function()
        assert.Error(function()
          cal.monthrange(2026, 0)
        end, "bad month number 0; must be 1-12")
        assert.Error(function()
          cal.monthrange(2026, 13)
        end, "bad month number 13; must be 1-12")
        assert.Error(function()
          cal.monthdays(2026, 0)
        end, "bad month number 0; must be 1-12")
        assert.Error(function()
          cal.monthdays(2026, 13)
        end, "bad month number 13; must be 1-12")
      end)

      it("accepts valid months", function()
        assert.has_no_error(function()
          cal.monthrange(2026, 1)
        end)
        assert.has_no_error(function()
          cal.monthrange(2026, 12)
        end)
      end)
    end)

    describe("weekday range", function()
      it("errors on out-of-range weekdays", function()
        assert.Error(function()
          cal.monthdays(2026, 2, 8)
        end, "bad weekday number 8; must be 1 (Monday) to 7 (Sunday)")
        assert.Error(function()
          cal.setfirstweekday(0)
        end, "bad weekday number 0; must be 1 (Monday) to 7 (Sunday)")
        assert.Error(function()
          cal.setfirstweekday(8)
        end, "bad weekday number 8; must be 1 (Monday) to 7 (Sunday)")
        assert.Error(function()
          cal.weekdays(0)
        end, "bad weekday number 0; must be 1 (Monday) to 7 (Sunday)")
        assert.Error(function()
          cal.weekheader(2, 8)
        end, "bad weekday number 8; must be 1 (Monday) to 7 (Sunday)")
      end)

      it("accepts valid weekdays", function()
        assert.has_no_error(function()
          cal.setfirstweekday(1)
        end)
        assert.has_no_error(function()
          cal.setfirstweekday(7)
        end)
      end)
    end)

    describe("day range", function()
      it("errors on out-of-range days", function()
        assert.Error(function()
          cal.weekday(2026, 2, 29)
        end, "bad day number 29 for 2026-02")
      end)

      it("accepts valid days", function()
        assert.has_no_error(function()
          cal.weekday(2024, 2, 29)
        end) -- Leap year
        assert.has_no_error(function()
          cal.weekday(2026, 2, 28)
        end)
      end)
    end)

    describe("other constraints", function()
      it("errors on invalid width", function()
        assert.Error(function()
          cal.weekheader(0)
        end, "bad argument #1 to 'weekheader' (width must be a positive integer)")
      end)

      it("accepts valid width", function()
        assert.has_no_error(function()
          cal.weekheader(1)
        end)
      end)
    end)
  end)
end)
