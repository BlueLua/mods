local mods = require "mods"

local isidentifier = mods.keyword.isidentifier
local quote = mods.utils.quote
local assert_arg = mods.utils.assert_arg

local concat = table.concat
local rep = string.rep
local sort = table.sort
local sub = string.sub
local min = math.min

local TYPE_RANK = { n = 0 }
for type_name in ("number string boolean table function userdata thread"):gmatch("%S+") do
  TYPE_RANK.n = TYPE_RANK.n + 1
  TYPE_RANK[type_name] = TYPE_RANK.n
end

local render

local function normalize_space(space)
  local indent = "  "

  if space == nil then
    return indent, false
  end

  local ts = type(space)
  if ts ~= "number" and ts ~= "string" then
    error(("bad argument #3 (number or string expected, got %s)"):format(ts), 3)
  end

  if ts == "number" then
    if space <= 0 then
      return "", true
    end
    return rep(" ", min(space, 10)), false
  end

  if space == "" then
    return "", true
  end
  return sub(space, 1, 10), false
end

local function key_less(a, b)
  a, b = a.key, b.key

  local ta = type(a)
  local tb = type(b)
  if ta ~= tb then
    return TYPE_RANK[ta] < TYPE_RANK[tb]
  end

  if ta == "number" or ta == "string" then
    return a < b
  elseif ta == "boolean" then
    return (not a) and b
  end

  return tostring(a) < tostring(b)
end

local function render_key(k)
  if type(k) == "string" then
    if isidentifier(k) then
      return k
    end
    k = quote(k)
  else
    k = tostring(k)
  end
  return "[" .. k .. "]"
end

local function apply_replacer(state, k, v)
  local replacer = state.replacer
  if replacer == nil then
    return v
  end
  return replacer(k, v)
end

local function collect_entries(value, state)
  local entries = {}

  for k, v in pairs(value) do
    v = apply_replacer(state, k, v)
    if v ~= nil then
      entries[#entries + 1] = { key = k, value = v }
    end
  end

  sort(entries, key_less)
  return entries
end

local function render_entry(entry, depth, state)
  local eq = state.inline and "=" or " = "
  local k, v = entry.key, entry.value
  return render_key(k) .. eq .. render(v, k, depth + 1, state, true)
end

local function render_entries(entries, depth, state)
  local parts = {}

  if state.inline then
    for i = 1, #entries do
      parts[i] = render_entry(entries[i], depth, state)
    end
    return "{" .. concat(parts, ",") .. "}"
  end

  local indent = rep(state.indent, depth)
  for i = 1, #entries do
    parts[i] = indent .. render_entry(entries[i], depth, state)
  end
  return "{\n" .. concat(parts, ",\n") .. "\n" .. rep(state.indent, depth - 1) .. "}"
end

function render(v, k, depth, state, replaced)
  if not replaced then
    v = apply_replacer(state, k, v)
  end

  local tv = type(v)
  if tv == "string" then
    return quote(v)
  elseif tv ~= "table" then
    return tostring(v)
  end

  local stack = state.stack

  if stack[v] then
    return "<cycle>"
  end
  stack[v] = true

  if next(v) == nil then
    stack[v] = nil
    return "{}"
  end

  local entries = collect_entries(v, state)
  if #entries == 0 then
    stack[v] = nil
    return "{}"
  end

  local out = render_entries(entries, depth, state)
  stack[v] = nil
  return out
end

return function(v, replacer, space)
  local indent, inline = normalize_space(space)
  local state = {
    indent = indent,
    inline = inline,
    replacer = assert_arg(2, replacer, "function", true),
    stack = {},
  }
  return render(v, "", 1, state)
end
