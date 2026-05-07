local mods = require "mods"

local keypath = mods.utils.keypath
local quote = mods.utils.quote

local concat = table.concat
local insert = table.insert
local move = table.move
local remove = table.remove
local sort = table.sort
local unpack = table.unpack
local random = math.random

---@type mods.List
local List = {}
List.__index = List

local function collect_by_membership(ls, set, keep_if_present)
  local res = List()
  for i = 1, #ls do
    local v = ls[i]
    local present = set[v] ~= nil
    if present == keep_if_present then
      res[#res + 1] = v
    end
  end
  return res
end

local function index_of(self, v)
  for i = 1, #self do
    if self[i] == v then
      return i
    end
  end
end

local function join_values(self, sep, quoted)
  local out = {}
  for i = 1, #self do
    local v = self[i]
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

local function lex_cmp(a, b)
  local limit = #a
  if #b < limit then
    limit = #b
  end
  for i = 1, limit do
    local av = a[i]
    local bv = b[i]
    if av ~= bv then
      if av < bv then
        return -1
      elseif bv < av then
        return 1
      end
      return nil
    end
  end
  if #a < #b then
    return -1
  elseif #a > #b then
    return 1
  end
  return 0
end

function List:all(pred)
  for i = 1, #self do
    if not pred(self[i]) then
      return false
    end
  end
  return true
end

function List:any(pred)
  for i = 1, #self do
    if pred(self[i]) then
      return true
    end
  end
  return false
end

function List:append(v)
  self[#self + 1] = v
  return self
end

function List:clear()
  for i = #self, 1, -1 do
    self[i] = nil
  end
  return self
end

function List:contains(v)
  return index_of(self, v) ~= nil
end

function List:copy()
  return List(move(self, 1, #self, 1, {}))
end

function List:count(v)
  local c = 0
  for i = 1, #self do
    if self[i] == v then
      c = c + 1
    end
  end
  return c
end

function List:difference(t)
  local set = getmetatable(t) == mods.Set and t or mods.Set(t)
  return collect_by_membership(self, set, false)
end

function List:drop(n)
  local len = #self
  if n == nil or n <= 0 then
    return List(move(self, 1, len, 1, {}))
  end
  return List(move(self, n + 1, len, 1, {}))
end

function List:equals(ls)
  local len = #self
  if len ~= #ls then
    return false
  end

  for i = 1, len do
    if self[i] ~= ls[i] then
      return false
    end
  end
  return true
end

function List:extend(t)
  if getmetatable(t) == mods.Set then
    for k in pairs(t) do
      self[#self + 1] = k
    end
    return self
  end
  for i = 1, #t do
    self[#self + 1] = t[i]
  end
  return self
end

function List:extract(pred)
  local extracted = List()
  local keep_i = 1
  local extracted_i = 1
  local len = #self
  for i = 1, len do
    local v = self[i]
    if pred(v) then
      extracted[extracted_i] = v
      extracted_i = extracted_i + 1
    else
      self[keep_i] = v
      keep_i = keep_i + 1
    end
  end
  for i = keep_i, len do
    self[i] = nil
  end
  return extracted
end

function List:filter(pred)
  local res = List()
  for i = 1, #self do
    local v = self[i]
    if pred(v) then
      res[#res + 1] = v
    end
  end
  return res
end

function List:first()
  return self[1]
end

function List:flatten()
  local res = List()
  for i = 1, #self do
    local v = self[i]
    if type(v) == "table" then
      for j = 1, #v do
        res[#res + 1] = v[j]
      end
    else
      res[#res + 1] = v
    end
  end
  return res
end

function List:foreach(fn)
  for i = 1, #self do
    fn(self[i])
  end
end

function List:group_by(fn)
  local res = {}
  for i = 1, #self do
    local v = self[i]
    local key = fn(v)
    local bucket = res[key]
    if bucket == nil then
      bucket = List()
      res[key] = bucket
    end
    bucket[#bucket + 1] = v
  end
  return res
end

function List:index_if(pred)
  for i = 1, #self do
    if pred(self[i]) then
      return i
    end
  end
end

function List:insert(pos, v)
  if v == nil then
    insert(self, pos)
  else
    insert(self, pos, v)
  end
  return self
end

function List:intersection(t)
  local set = getmetatable(t) == mods.Set and t or mods.Set(t)
  return collect_by_membership(self, set, true)
end

function List:invert()
  local res = {}
  for i = 1, #self do
    res[self[i]] = i
  end
  return res
end

function List:mirror()
  local res = {}
  for i = 1, #self do
    local v = self[i]
    res[v] = v
  end
  return res
end

function List:keypath()
  return keypath(unpack(self))
end

function List:last()
  return self[#self]
end

function List:len()
  return #self
end

function List:isempty()
  return #self == 0
end

function List:lt(ls)
  return lex_cmp(self, ls) == -1
end

function List:le(ls)
  local cmp = lex_cmp(self, ls)
  return cmp == -1 or cmp == 0
end

function List:map(fn)
  local ls = List()
  for i = 1, #self do
    ls[i] = fn(self[i])
  end
  return ls
end

function List:mul(n)
  local res = List()
  if n == nil or n <= 0 then
    return res
  end
  for _ = 1, n do
    res:extend(self)
  end
  return res
end

function List:prepend(v)
  insert(self, 1, v)
  return self
end

function List:reduce(fn, init)
  local len = #self
  if len == 0 then
    return init
  end
  local acc
  local start = 1
  if init == nil then
    acc = self[1]
    start = 2
  else
    acc = init
  end
  for i = start, len do
    acc = fn(acc, self[i])
  end
  return acc
end

function List:remove(v)
  for i = 1, #self do
    if self[i] == v then
      remove(self, i)
      break
    end
  end
  return self
end

function List:reverse()
  local i, j = 1, #self
  while i < j do
    self[i], self[j] = self[j], self[i]
    i, j = i + 1, j - 1
  end
  return self
end

function List:slice(i, j)
  local len = #self
  local res = List()
  if len == 0 then
    return res
  end
  local start = i or 1
  local finish = j or len
  if start < 0 then
    start = len + start + 1
  end
  if finish < 0 then
    finish = len + finish + 1
  end
  if start < 1 then
    start = 1
  end
  if finish > len then
    finish = len
  end
  if start > finish then
    return res
  end
  move(self, start, finish, 1, res)
  return res
end

function List:sort(comp)
  sort(self, comp)
  return self
end

function List:shuffle(rng)
  local random = rng or random
  for i = #self, 2, -1 do
    local j = random(1, i)
    self[i], self[j] = self[j], self[i]
  end
  return self
end

function List:take(n)
  if n == nil or n <= 0 then
    return List()
  end
  local limit = #self
  if n < limit then
    limit = n
  end
  return List(move(self, 1, limit, 1, {}))
end

function List:uniq()
  local res = List()
  local seen = {}
  for i = 1, #self do
    local v = self[i]
    if not seen[v] then
      seen[v] = true
      res[#res + 1] = v
    end
  end
  return res
end

function List:zip(t)
  local res = List()

  if getmetatable(t) == mods.Set then
    local limit = #self
    for k in pairs(t) do
      local i = #res + 1
      if i > limit then
        break
      end
      res[i] = { self[i], k }
    end
    return res
  end

  local limit = #self
  if #t < limit then
    limit = #t
  end
  for i = 1, limit do
    res[i] = { self[i], t[i] }
  end
  return res
end

List.index = index_of
List.join = join_values
List.tostring = stringify
List.concat = concat
List.pop = remove

List.__add = List.extend
List.__eq = List.equals
List.__le = List.le
List.__lt = List.lt
List.__mul = function(a, b)
  ---@diagnostic disable-next-line: param-type-mismatch
  return type(a) == "number" and b:mul(a) or a:mul(b)
end
List.__sub = List.difference
List.__tostring = stringify

return setmetatable(List, {
  __index = function(t, k)
    if k == "toset" then
      local fn = mods.Set
      rawset(t, k, fn)
      return fn
    end
  end,
  __call = function(_, ls)
    return setmetatable(ls or {}, List)
  end,
})
