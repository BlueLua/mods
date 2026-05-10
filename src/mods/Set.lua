local mods = require "mods"

local tbl = mods.tbl
local utils = mods.utils

local quote = utils.quote
local is_same = tbl.is_same
local concat = table.concat

---@type mods.Set
local Set = {}
Set.__index = Set

local List
local function as_set(t)
  if not List then
    List = mods.List
  end
  return getmetatable(t) == List and Set(t) or t
end

local function copy_set(self)
  local set = setmetatable({}, Set)
  for k in pairs(self) do
    set[k] = true
  end
  return set
end

local function join_values(self, sep, quoted)
  local out = {}
  for v in pairs(self) do
    local i = #out + 1
    if v == self then
      out[i] = "<self>"
    elseif quoted and type(v) == "string" then
      out[i] = quote(v)
    else
      out[i] = tostring(v)
    end
  end
  return concat(out, sep)
end

local function stringify(self)
  return "{ " .. join_values(self, ", ", true) .. " }"
end

local function has(set, k)
  return rawget(set, k) ~= nil
end

function Set:add(v)
  self[v] = true
  return self
end

function Set:clear()
  for k in pairs(self) do
    self[k] = nil
  end
  return self
end

function Set:difference_update(t)
  for k in pairs(as_set(t)) do
    self[k] = nil
  end
  return self
end

function Set:difference(t)
  return copy_set(self):difference_update(t)
end

function Set:intersection_update(t)
  for k in pairs(self) do
    if not as_set(t)[k] then
      self[k] = nil
    end
  end
  return self
end

function Set:intersection(t)
  return copy_set(self):intersection_update(t)
end

function Set:isdisjoint(t)
  for k in pairs(self) do
    if as_set(t)[k] then
      return false
    end
  end
  return true
end

function Set:issubset(t)
  for k in pairs(self) do
    if not as_set(t)[k] then
      return false
    end
  end
  return true
end

function Set:issuperset(t)
  for k in pairs(as_set(t)) do
    if not self[k] then
      return false
    end
  end
  return true
end

function Set:contains(v)
  return self[v] ~= nil
end

function Set:map(fn)
  local set = setmetatable({}, Set)
  for k in pairs(self) do
    set[fn(k)] = true
  end
  return set
end

function Set:mirror()
  local res = {}
  for k in pairs(self) do
    res[k] = k
  end
  return res
end

function Set:pop()
  local k = next(self)
  if k == nil then
    return
  end
  self[k] = nil
  return k
end

function Set:remove(v)
  self[v] = nil
  return self
end

function Set:symmetric_difference_update(t)
  for k in pairs(as_set(t)) do
    self[k] = not self[k] and true or nil
  end
  return self
end

function Set:symmetric_difference(t)
  return copy_set(self):symmetric_difference_update(t)
end

function Set:union(t)
  return copy_set(self):update(t)
end

function Set:update(t)
  for k in pairs(as_set(t)) do
    self[k] = true
  end
  return self
end

function Set:equals(t)
  return is_same(self, as_set(t))
end

Set.has = has
Set.copy = copy_set
Set.isempty = tbl.isempty
Set.join = join_values
Set.len = tbl.count
Set.tostring = stringify
Set.values = tbl.keys

Set.__add = Set.union
Set.__band = Set.intersection
Set.__bor = Set.union
Set.__bxor = Set.symmetric_difference
Set.__eq = Set.equals
Set.__le = Set.issubset
Set.__lt = function(a, b)
  return a:issubset(b) and not a:issuperset(b)
end
Set.__sub = Set.difference
Set.__tostring = stringify

return setmetatable(Set, {
  __call = function(_, t)
    local set = setmetatable({}, Set)
    if t == nil then
      return set
    end
    for i = 1, #t do
      set[t[i]] = true
    end
    return set
  end,
})
