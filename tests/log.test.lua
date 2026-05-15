local mods = require "mods"

local log = mods.log

local function capture_logs(opts)
  local out = {}
  opts = opts or {}
  opts.handler = function(record)
    out[#out + 1] = record
  end
  return log(opts), out
end

describe("mods.log", function()
  it('defaults logger level to "warn"', function()
    assert.are_equal("warn", log().level)
  end)

  it("formats output without logger name", function()
    local logger, recs = capture_logs()
    logger:warn("careful")
    assert.are_equal("[WARN]: careful", recs[1].line)
  end)

  it("formats output with logger name", function()
    local logger, recs = capture_logs({ name = "app" })
    logger:warn("careful")
    assert.are_equal("[WARN] (app): careful", recs[1].line)
  end)

  describe("constructor options", function()
    it("rejects unknown options", function()
      assert.has_error(function()
        log({ extra = true })
      end, "unknown log option: extra")
    end)

    it('accepts "level"', function()
      local logger, recs = capture_logs({ level = "debug" })
      logger:info("hello")
      assert.are_equal(1, #recs, "expected one log record")
      assert.are_equal("info", recs[1].levelname)
    end)

    it("rejects invalid level", function()
      assert.has_error(function()
        log({ level = "verbose" })
      end, "unknown log level: verbose")
    end)

    it('accepts "name"', function()
      local logger, recs = capture_logs({ name = "app" })
      logger:warn("hello")
      assert.are_equal(1, #recs, "expected one log record")
      assert.are_equal("app", recs[1].name)
    end)

    it('accepts "handler"', function()
      -- stylua: ignore start
      local logger = log({ handler = function(record) error(record.line) end })
      assert.has_error(function() logger:warn("hello") end, "[WARN]: hello")
    end)

    it('accepts "off" for "level"', function()
      assert.are_equal("off", log({ level = "off" }).level)
    end)
  end)

  describe("level filtering", function()
    -- stylua: ignore
    local tests = {
      { level = "debug", expected = { "debug", "info" , "warn" , "error" }},
      { level = "info" , expected = { "info" , "warn" , "error",         }},
      { level = "warn" , expected = { "warn" , "error",                  }},
      { level = "error", expected = { "error"                            }},
      { level = "off"  , expected = {                                    }},
    }

    for _, t in ipairs(tests) do
      it(("emits expected records at %q"):format(t.level), function()
        local logger, recs = capture_logs({ level = t.level })

        logger:debug("a")
        logger:info("b")
        logger:warn("c")
        logger:error("d")

        local actual = {}
        for i = 1, #recs do
          actual[i] = recs[i].levelname
        end
        assert.are_same(t.expected, actual)
      end)
    end
  end)

  describe("records", function()
    it("passes normalized records to the handler", function()
      local logger, recs = capture_logs({ name = "app" })
      logger:error("failed", 404, false)
      assert.are_equal(1, #recs, "expected one log record")
      assert.are_same({
        levelname = "error",
        levelno = 40,
        name = "app",
        message = "failed 404 false",
        line = "[ERROR] (app): failed 404 false",
      }, {
        levelname = recs[1].levelname,
        levelno = recs[1].levelno,
        name = recs[1].name,
        message = recs[1].message,
        line = recs[1].line,
      })
    end)

    it("preserves variadic arguments in args", function()
      local logger, recs = capture_logs({ level = "debug" })
      logger:debug("a", nil, "c")
      assert.are_equal(1, #recs, "expected one log record")
      assert.are_equal(3, recs[1].args.n)
      assert.are_equal("a nil c", recs[1].message)
      assert.are_same({ "a", nil, "c" }, { recs[1].args[1], recs[1].args[2], recs[1].args[3] })
    end)
  end)

  describe("Logger:log()", function()
    it("emits records for direct method calls", function()
      local logger, recs = capture_logs({ level = "debug" })
      logger:log("info", "hello", "world")
      assert.are_equal("[INFO]: hello world", recs[1].line)
    end)

    it("rejects invalid emitted levels", function()
      assert.has_error(function()
        log():log("verbose", "hello")
      end, "unknown log level: verbose")
    end)
  end)
end)
