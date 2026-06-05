local mods = require "mods"

local fmt = string.format

describe("mods", function()
  it("loads modules without requiring lfs", function()
    local current_module = ""
    local old_preload = package.preload["lfs"]
    local old_loaded_lfs = package.loaded["lfs"]
    package.loaded["lfs"] = nil
    package.preload["lfs"] = function()
      local suffix = fmt(" (triggered by mods.%s)", current_module)
      error("lfs should not be required when loading mods modules" .. suffix, 2)
    end

    package.preload["lfs"] = old_preload
    package.loaded["lfs"] = old_loaded_lfs
  end)

  it("throws when accessing an unknown module", function()
    assert.has_error(function()
      ---@diagnostic disable-next-line: undefined-field
      return mods.not_a_real_module
    end)
  end)
end)
