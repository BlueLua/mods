local mods = require "mods"

local List = mods.list

---@type mods.tbl
local M = {}

local function deep_equal(a, b, seen)
  if rawequal(a, b) then
    return true
  end

  local at = type(a)
  if at ~= type(b) then
    return false
  end

  if at ~= "table" then
    return false
  end

  local seen_a = seen[a]
  if not seen_a then
    seen_a = {}
    seen[a] = seen_a
  elseif seen_a[b] then
    return true
  end
  seen_a[b] = true

  for k, v in pairs(a) do
    if not deep_equal(v, b[k], seen) then
      return false
    end
  end

  for k in pairs(b) do
    if a[k] == nil then
      return false
    end
  end

  return true
end

function M.clear(t)
  for k in pairs(t) do
    t[k] = nil
  end
end

function M.copy(t)
  local res = {}
  for k, v in pairs(t) do
    res[k] = v
  end
  return res
end

function M.count(t)
  local len = 0
  for _ in pairs(t) do
    len = len + 1
  end
  return len
end

local function deepcopy(v, seen)
  if type(v) ~= "table" then
    return v
  end

  local cached = seen[v]
  if cached ~= nil then
    return cached
  end

  local res = {}
  seen[v] = res
  for k, v_ in pairs(v) do
    res[deepcopy(k, seen)] = deepcopy(v_, seen)
  end

  local mt = getmetatable(v)
  if mt ~= nil then
    setmetatable(res, mt)
  end
  return res
end

function M.deepcopy(t)
  return deepcopy(t, {})
end

function M.deep_equal(a, b)
  return deep_equal(a, b, {})
end

function M.filter(t, pred)
  local res = {}
  for k, v in pairs(t) do
    if pred(v) then
      res[k] = v
    end
  end
  return res
end

function M.find(t, v)
  for k, v_ in pairs(t) do
    if v == v_ then
      return k
    end
  end
end

function M.is_same(a, b)
  for k, v in pairs(a) do
    if b[k] ~= v then
      return false
    end
  end
  for k, v in pairs(b) do
    if a[k] ~= v then
      return false
    end
  end
  return true
end

function M.find_if(t, pred)
  for k, v in pairs(t) do
    if pred(v, k) then
      return v, k
    end
  end
end

function M.get(t, ...)
  local v = t
  local n = select("#", ...)
  for i = 1, n do
    local k = select(i, ...)
    if v[k] == nil then
      return
    end
    v = v[k]
  end
  return v
end

function M.invert(t)
  local res = {}
  for k, v in pairs(t) do
    res[v] = k
  end
  return res
end

function M.isempty(t)
  return not next(t)
end

function M.keys(t)
  local ls = List()
  local i = 1
  for k in pairs(t) do
    ls[i] = k
    i = i + 1
  end
  return ls
end

function M.spairs(t)
  local keys = M.keys(t):sort()
  local i = 0
  return function()
    i = i + 1
    local k = keys[i]
    if k == nil then
      return nil
    end
    return k, t[k]
  end
end

function M.foreach(t, fn)
  for k, v in pairs(t) do
    fn(v, k)
  end
end

function M.map(t, fn)
  local res = {}
  for k, v in pairs(t) do
    res[k] = fn(k, v)
  end
  return res
end

function M.update(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

function M.values(t)
  local ls = List()
  local i = 1
  for _, v in pairs(t) do
    ls[i] = v
    i = i + 1
  end
  return ls
end

return M
