local major_s, minor_s = _VERSION:match("^Lua (%d+)%.(%d+)$")
local major = tonumber(major_s) --[[@as integer]]
local minor = tonumber(minor_s) --[[@as integer]]
local is_luajit = rawget(_G, "jit") ~= nil
local is_windows = package.config:sub(1, 1) == "\\"

local M = {
  version = major * 100 + minor,
  major = major,
  minor = minor,
  is_luajit = is_luajit,
  is_windows = is_windows,
}

return M
