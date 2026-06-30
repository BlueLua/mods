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
    assert.is_boolean(runtime.is_unix)
  end)

  it("version encodes major/minor versions", function()
    assert.are_equal(500 + runtime.minor, runtime.version)
    assert.are_equal(version_nums[version], runtime.version)
  end)

  it("detects host OS flags from package.config", function()
    local is_win = package.config:sub(1, 1) == "\\"
    assert.are_equal(is_win, runtime.is_windows)
    assert.are_equal(not is_win, runtime.is_unix)
  end)
end)
