local major_s, minor_s = _VERSION:match("^Lua (%d+)%.(%d+)$")
local is_windows = package.config:sub(1, 1) == "\\"

return {
  version = tonumber(major_s) * 100 + tonumber(minor_s),
  major = tonumber(major_s),
  minor = tonumber(minor_s),
  is_luajit = rawget(_G, "jit") ~= nil,
  is_windows = is_windows,
  is_unix = not is_windows,
}
