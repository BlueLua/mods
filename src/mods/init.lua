require("mods._compat")

return setmetatable({ _VERSION = "mods 1.0.0" }, { -- x-release-please-version
  __index = function(t, k)
    local modname = "mods." .. tostring(k)
    local ok, v = pcall(require, modname)
    if not ok then
      error(v, 2)
    end
    return rawset(t, k, v)[k]
  end,
})
