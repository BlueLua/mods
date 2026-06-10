local mods = require "mods"

local stringify ---@module "mods.stringify"
local validate ---@module "mods.validate"

local concat = table.concat
local find = string.find
local fmt = string.format
local gsub = string.gsub
local unpack = table.unpack

---@type mods.utils
local M = {}

local function isidentifier(v)
  isidentifier = mods.keyword.isidentifier
  return isidentifier(v)
end

function M.quote(v)
  if find(v, '"', 1, true) and not find(v, "'", 1, true) then
    return "'" .. v .. "'"
  end
  return '"' .. gsub(v, '"', '\\"') .. '"'
end

function M.keypath(...)
  local n = select("#", ...)
  if n == 0 then
    return ""
  end

  local res = {}
  for i = 1, n do
    local k = select(i, ...)
    if isidentifier(k) then
      res[#res + 1] = (#res > 0 and "." or "") .. k
    elseif type(k) == "string" then
      res[#res + 1] = "[" .. M.quote(k) .. "]"
    else
      res[#res + 1] = "[" .. tostring(k) .. "]"
    end
  end
  return concat(res)
end

function M.args_repr(v)
  if v == nil or next(v) == nil then
    return ""
  end
  local parts = {}
  for i = 1, #v do
    parts[i] = stringify(v[i], { newline = "" })
  end
  return concat(parts, ", ")
end

function M.assert_arg(argn, v, validator, optional, lv)
  local ok, err = validate(v, validator)
  if ok or (optional and v == nil) then
    return v
  end
  error(fmt("bad argument #%d (%s)", argn, err), lv or 3)
end

function M.validate(label, v, validator, optional, msg)
  local ok, err = validate(v, validator, msg)
  if ok or (optional and v == nil) then
    return
  end
  label = type(label) == "table" and M.keypath(unpack(label)) or label
  local message = fmt("%s: %s", label, err)
  error(message, 2)
end

function M.lazy_module(name, err)
  local load_err = err or fmt("failed to load module '%s'", name)
  local mt = {}

  local function load()
    local ok, mod = pcall(require, name)
    if not ok then
      error(load_err, 3)
    end

    if type(mod) == "table" then
      mt.__index = mod
      mt.__newindex = mod
      mt.__call = getmetatable(mod) and getmetatable(mod).__call or nil
    elseif type(mod) == "function" then
      mt.__index = nil
      mt.__newindex = nil
      mt.__call = function(_, ...)
        return mod(...)
      end
    end

    return mod
  end

  mt.__index = function(_, k)
    return load()[k]
  end

  mt.__newindex = function(_, k, v)
    load()[k] = v
  end

  mt.__call = function(_, ...)
    return load()(...)
  end

  return setmetatable({}, mt)
end

stringify = M.lazy_module("mods.stringify")
validate = M.lazy_module("mods.validate")

return M
