local runtime = require "mods.runtime"
local version = _VERSION

describe("mods.runtime", function()
  local version_nums = {}
  for minor = 1, 5 do
    version_nums["Lua 5." .. minor] = 500 + minor
  end

  it("exposes version metadata", function()
    assert.are_equal(version_nums[version], runtime.version)
    assert.is_number(runtime.major)
    assert.is_number(runtime.minor)
    assert.is_boolean(runtime.is_luajit)
    assert.is_boolean(runtime.is_windows)
  end)

  it("version encodes major/minor versions", function()
    assert.are_equal(500 + runtime.minor, runtime.version)
    assert.are_equal(version_nums[version], runtime.version)
  end)

  it("detects host windows flag from package.config", function()
    assert.are_equal(package.config:sub(1, 1) == "\\", runtime.is_windows)
  end)
end)
