local mods = require "mods"

local is = mods.is
local quote = mods.utils.quote
local validate = mods.utils.validate
local template = mods.template
local lower = string.lower
local fmt = string.format
local Set = mods.set

---@type mods.validate
local M = { messages = {} }

---@type modsValidatorMessages
local messages = {}
local validators = {}
local path_validator_names =
  Set({ "path", "block_device", "char_device", "dir", "fifo", "file", "link", "socket", "device" })

setmetatable(M.messages, {
  __index = messages,
  __newindex = function(_, k, v)
    local path = { "validate", "messages", k }
    validate(path, k, "string")
    validate(path, v, "string")
    messages[k] = v
  end,
})

local function validate_template(argn, name, v)
  if v == nil then
    return
  end

  local vt = type(v)
  if vt ~= "string" then
    error(fmt("bad argument #%d to '%s' (string expected, got %s)", argn, name, vt), 3)
  end
end

---@param tp type
local function render_msg(expected, tp, v, tmpl)
  local vt = type(v)
  v = vt == "string" and quote(v) or tostring(v)
  expected = tostring(expected)

  if not tmpl then
    if vt ~= "string" and rawget(path_validator_names, expected) then
      tmpl = messages.string
      expected = "string"
    else
      tmpl = messages[expected] or "{{expected}} expected, got {{got}}"
    end
  end

  return template(tmpl, {
    expected = expected,
    got = tp == "nil" and "no value" or tp,
    value = v == "nil" and "no value" or v,
  })
end

function M.register(name, validator, tmpl)
  local key = lower(name)

  if tmpl == nil then
    messages[key] = fmt("%s expected, got {{got}}", name)
  else
    validate_template(3, "register", tmpl)
    messages[key] = tmpl
  end

  local wrapped = function(v, tmpl_)
    if validator(v) then
      return true
    end
    if tmpl_ ~= nil then
      validate_template(2, name, tmpl_)
    end
    return false, render_msg(key, type(v), v, tmpl_)
  end

  validators[key] = wrapped
  M[key] = wrapped
end

for k in ("boolean function nil number string table thread userdata cdata"):gmatch("%S+") do
  M.register(k, is[k])
end

for k in ("false true falsy truthy integer callable finite infinite float nan defined"):gmatch("%S+") do
  M.register(k, is[k], fmt("%s value expected, got {{value}}", k))
end

for k in pairs(path_validator_names) do
  local expected = ({ dir = "directory", block_device = "block device", char_device = "character device" })[k] or k
  M.register(k, is[k], fmt("{{value}} is not a valid %s path", expected))
end

messages.path = "{{value}} is not a valid path"

return setmetatable(M, {
  __index = function(_, k)
    if type(k) == "string" then
      return validators[lower(k)]
    end
  end,

  ---@param validator mods.validatorName
  __call = function(_, v, validator, tmpl)
    validator = validator or "truthy"
    validate_template(3, validator, tmpl)

    local validate_ = validators[validator]
    if validate_ then
      return validate_(v, tmpl)
    end

    local tp = type(v)
    if tp == validator then
      return true
    end
    return false, render_msg(validator, tp, v, tmpl)
  end,
})
