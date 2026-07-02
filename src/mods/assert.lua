local validate = require("mods.validate")

return setmetatable({}, {
  __index = function(t, k)
    local validator = validate[k]
    if not validator then
      return
    end

    return rawset(t, k, function(v, msg, optional, lvl)
      local ok, err = validator(v, msg, optional)
      if ok then
        return v
      end
      error(err, lvl or 2)
    end)[k]
  end,

  ---@param validator mods.validatorName
  __call = function(t, v, validator, ...)
    local assert = t[validator or "truthy"]
    if assert then
      return assert(v, ...)
    end
  end,
})
