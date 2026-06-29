local mods = require "mods"

local Date = mods.date
local Duration = mods.duration

-- stylua: ignore start
local constructor_cases = {
  { expected = { years =   0, months = 0, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { nil } },
  { expected = { years =   0, months = 0, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { {} } },
  { expected = { years =   1, months = 0, days =  2, hours =   0, minutes =  0, seconds =  0, milliseconds =   3 }, args = { { years = 1, days = 2, milliseconds = 3 } } },
  { expected = { years =   0, months = 6, days = 14, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { quarters = 2, weeks = 2 } } },
  { expected = { years =   0, months = 0, days =  0, hours =   0, minutes = 90, seconds =  0, milliseconds =   0 }, args = { 90, "minute" } },
  { expected = { years =   0, months = 0, days =  0, hours = 1.5, minutes =  0, seconds =  0, milliseconds =   0 }, args = { 1.5, "hour" } },
  { expected = { years =   0, months = 0, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds = 500 }, args = { 500, "ms" } },
  { expected = { years =   0, months = 0, days =  0, hours =   0, minutes =  0, seconds = 30, milliseconds =   0 }, args = { 30, "seconds" } },
  { expected = { years =   0, months = 0, days =  0, hours =   2, minutes =  0, seconds =  0, milliseconds =   0 }, args = { 2, "hour" } },
  { expected = { years =   0, months = 0, days =  3, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { 3, "day" } },
  { expected = { years =   0, months = 4, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { 4, "month" } },
  { expected = { years =   2, months = 0, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { 2, "year" } },
  { expected = { years =   0, months = 3, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { 1, "quarter" } },
  { expected = { years =   0, months = 0, days = 14, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { 2, "week" } },
  { expected = { years =   1, months = 2, days =  3, hours =   4, minutes =  5, seconds =  6, milliseconds = 789 }, args = { "P1Y2M3DT4H5M6.789S" } },
  { expected = { years = 1.5, months = 0, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { years = 1.5 } } },

  { expected = { years =   0, months = 1, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { M           = 1 } } },
  { expected = { years =   0, months = 0, days =  1, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { d           = 1 } } },
  { expected = { years =   0, months = 0, days =  1, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { day         = 1 } } },
  { expected = { years =   0, months = 0, days =  0, hours =   1, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { h           = 1 } } },
  { expected = { years =   0, months = 0, days =  0, hours =   1, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { hour        = 1 } } },
  { expected = { years =   0, months = 0, days =  0, hours =   0, minutes =  1, seconds =  0, milliseconds =   0 }, args = { { m           = 1 } } },
  { expected = { years =   0, months = 0, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   1 }, args = { { millisecond = 1 } } },
  { expected = { years =   0, months = 0, days =  0, hours =   0, minutes =  1, seconds =  0, milliseconds =   0 }, args = { { minute      = 1 } } },
  { expected = { years =   0, months = 1, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { month       = 1 } } },
  { expected = { years =   0, months = 0, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   1 }, args = { { ms          = 1 } } },
  { expected = { years =   0, months = 3, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { q           = 1 } } },
  { expected = { years =   0, months = 3, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { quarter     = 1 } } },
  { expected = { years =   0, months = 0, days =  0, hours =   0, minutes =  0, seconds =  1, milliseconds =   0 }, args = { { s           = 1 } } },
  { expected = { years =   0, months = 0, days =  0, hours =   0, minutes =  0, seconds =  1, milliseconds =   0 }, args = { { second      = 1 } } },
  { expected = { years =   0, months = 0, days =  7, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { w           = 1 } } },
  { expected = { years =   0, months = 0, days =  7, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { week        = 1 } } },
  { expected = { years =   1, months = 0, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { y           = 1 } } },
  { expected = { years =   1, months = 0, days =  0, hours =   0, minutes =  0, seconds =  0, milliseconds =   0 }, args = { { year        = 1 } } },

  { throws = 'bad duration key "epoch"'      , args = { { epoch       = 1 } } },
  { throws = 'bad duration key "fortnight"'  , args = { { fortnight   = 1 } } },
  { throws = 'bad duration key "isdst"'      , args = { { isdst       = 1 } } },
  { throws = 'bad duration key "timestamp"'  , args = { { timestamp   = 1 } } },
  { throws = 'bad duration key "wday"'       , args = { { wday        = 1 } } },
  { throws = 'bad duration key "weekday"'    , args = { { weekday     = 1 } } },
  { throws = 'bad duration key "yday"'       , args = { { yday        = 1 } } },
}

local invalid_duration_cases = {
  { throws = 'bad duration key "epoch"'       , init = { { hours = 2 } }, args = { { epoch       = 1 } } },
  { throws = 'bad duration key "fortnight"'   , init = { { hours = 2 } }, args = { { fortnight   = 1 } } },
  { throws = 'bad duration key "isdst"'       , init = { { hours = 2 } }, args = { { isdst       = 1 } } },
  { throws = 'bad duration key "timestamp"'   , init = { { hours = 2 } }, args = { { timestamp   = 1 } } },
  { throws = 'bad duration key "wday"'        , init = { { hours = 2 } }, args = { { wday        = 1 } } },
  { throws = 'bad duration key "weekday"'     , init = { { hours = 2 } }, args = { { weekday     = 1 } } },
  { throws = 'bad duration key "yday"'        , init = { { hours = 2 } }, args = { { yday        = 1 } } },
}
-- stylua: ignore end

describe("mods.duration", function()
  -- stylua: ignore
  each("Duration", Duration, {
    __call = constructor_cases,
    new = constructor_cases,
    is_duration = {
      { expected = true , args = { Duration({ days = 2 }) } },
      { expected = false, args = nil },
      { expected = false, args = { Date() } },
      { expected = false, args = { {} } },
      { expected = false, args = { true }}
    },
    add = {
      {
        expected = { years = 0, months = 1, days = 5, hours = 4, minutes = 0, seconds = 0, milliseconds = 0 },
        init     = { { months = 1, days = 2 } },
        args     = { { days = 3, hours = 4 } }
      },
      {
        expected = { years = 0, months = 0, days = 0, hours = 1.5, minutes = 0, seconds = 0, milliseconds = 0 },
        init     = { { hours = 1 } },
        args     = { 0.5, "hour" }
      },
      {
        expected = { years = 0, months = 0, days = 0, hours = 2, minutes = 30, seconds = 0, milliseconds = 0 },
        init     = { { hours = 2 } },
        args     = { 30, "minute" }
      },
      invalid_duration_cases,
    },
    subtract = {
      {
        expected = { years = 0, months = 1, days = 2, hours = -4, minutes = 0, seconds = 0, milliseconds = 0 },
        init     = { { months = 1, days = 5 } }, args = { { days = 3, hours = 4 } }
      },
      {
        expected = { years = 0, months = 0, days = 0, hours = 2, minutes = -30, seconds = 0, milliseconds = 0 },
        init     = { { hours = 2 } }, args = { 30, "minute" }
      },
      invalid_duration_cases,
    },
    equals = {
      { expected = true , init = { { months = 1 } }, args = { Duration({ months = 1 }) } },
      { expected = false, init = { { months = 1 } }, args = { { months = 1 } } },
      { expected = false, init = { { months = 1 } }, args = { { days = 1 } } },
    },
    format = {
      {
        expected = "0007-06-11T27:02:01.009",
        init     = { { years = 7, quarters = 2, months = 0, weeks = 1, days = 4, hours = 27, minutes = 2, seconds = 1, milliseconds = 9 } },
        args     = { "YYYY-MM-DDTHH:mm:ss.SSS" }
      },
    },
    clone = {
      {
        init     = { { years = 1, months = 2, days = 3, hours = 4, minutes = 5, seconds = 6, milliseconds = 7 } },
        assert   = function(res)
          assert.is_true(Duration.is_duration(res))
          assert.same({ years = 1, months = 2, days = 3, hours = 4, minutes = 5, seconds = 6, milliseconds = 7 }, res)
        end,
      },
    },
    compare = {
      { expected = -1, init = { { days = 1 } }, args = { { hours = 25 } } },
      { expected =  0, init = { { days = 1 } }, args = { { hours = 24 } } },
      { expected =  1, init = { { days = 1 } }, args = { "PT23H" } },
    },
    as = {
      { expected = 1, init = { { milliseconds = 1 } }, args = { "ms" } },
      { expected = 1, init = { { milliseconds = 1 } }, args = { "milliseconds" } },
      { expected = 1.5, init = { { months = 1.5 } }, args = { "month" } },
      { expected = 36, init = { { days = 1, hours = 12 } }, args = { "hour" } },
      { expected = 36, init = { { days = 1, hours = 12 } }, args = { "hours" } },
      { expected = 18.238197909608, init = { { years = 1, months = 6, days = 7, hours = 6 } }, args = { "M" } },
      { expected = 6.0793993032026667, init = { { years = 1, months = 6, days = 7, hours = 6 } }, args = { "q" } },
      { throws = 'bad duration unit "fortnight"', init = { { days = 1 } }, args = { "fortnight" } },
    },
    normalize = {
      {
        init     = { { days = 29 } },
        expected = { years = 0, months = 1, days = 1, hours = 0, minutes = 0, seconds = 0, milliseconds = 0 },
      },
      {
        expected = { years = 0, months = 0, days = 1, hours = 4, minutes = 2, seconds = 2, milliseconds = 1 },
        init     = { { hours = 27, minutes = 61, seconds = 61, milliseconds = 1001 } }
      },
    },
    to_iso = {
      { expected = "P0D"         , init = { {} } },
      { expected = "PT1H30M"     , init = { { hours = 1, minutes = 30 } } },
      { expected = "PT1.25S"     , init = { { seconds = 1, milliseconds = 250 } } },
      { expected = "PT1.5H"      , init = { { hours = 1.5 } } },
      { expected = "-P2D"        , init = { { days = -2 } } },
      { expected = "PT1H-30M0.5S", init = { { hours = 1, minutes = -30, seconds = 1, milliseconds = -500 } } },
    },
    humanize = {
      { expected = "a month"     , init = { { months  =  1 } }, args = { nil } },
      { expected = "2 months"    , init = { { months  =  2 } }, args = { nil } },
      { expected = "in 2 months" , init = { { months  =  2 } }, args = { true } },
      { expected = "2 days"      , init = { { days    =  2 } }, args = { nil } },
      { expected = "an hour"     , init = { { hours   =  1 } }, args = { nil } },
      { expected = "in an hour"  , init = { { hours   =  1 } }, args = { true } },
      { expected = "a minute ago", init = { { minutes = -1 } }, args = { true } },
      { expected = "2d"          , init = { { days    =  2 } }, args = { { short = true } } },
      { expected = "48 hours"    , init = { { days    =  2 } }, args = { { max_unit = "hour" } } },
      { expected = "1 minute"    , init = { { seconds = 45 } }, args = { { min_unit = "minute" } } },
      { expected = "0 minutes"   , init = { { seconds = 45 } }, args = { { min_unit = "minute", round = "floor" } } },
      { expected = "in 45s"      , init = { { seconds = 45 } }, args = { { short = true, with_suffix = true } } },
    },
  })

  it("copies an existing duration without reusing the same table", function()
    local d = Duration({ months = 2, days = 3 })
    local copy = Duration(d)
    assert.same(d, copy)
    assert.is_false(rawequal(d, copy))
  end)
end)
