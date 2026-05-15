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
    assert.is_boolean(runtime.is_lua51)
    assert.is_boolean(runtime.is_lua52)
    assert.is_boolean(runtime.is_lua53)
    assert.is_boolean(runtime.is_lua54)
    assert.is_boolean(runtime.is_lua55)
    assert.is_boolean(runtime.is_luajit)
    assert.is_boolean(runtime.is_windows)
  end)

  it("flags Lua versions consistently", function()
    local version_flags = {}
    for minor = 1, 5 do
      local flag = "is_lua5" .. minor
      version_flags[flag] = version == "Lua 5." .. minor
    end

    assert.are_equal(version_flags.is_lua51, runtime.is_lua51)
    assert.are_equal(version_flags.is_lua52, runtime.is_lua52)
    assert.are_equal(version_flags.is_lua53, runtime.is_lua53)
    assert.are_equal(version_flags.is_lua54, runtime.is_lua54)
    assert.are_equal(version_flags.is_lua55, runtime.is_lua55)
  end)

  it("version encodes major/minor versions", function()
    assert.are_equal(500 + runtime.minor, runtime.version)
    assert.are_equal(version_nums[version], runtime.version)
  end)

  it("detects host windows flag from package.config", function()
    assert.are_equal(package.config:sub(1, 1) == "\\", runtime.is_windows)
  end)
end)
