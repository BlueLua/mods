local mods = require "mods"

local isidentifier = mods.keyword.isidentifier
local quote = mods.utils.quote
local assert_arg = mods.utils.assert_arg
local validate = mods.utils.validate

local concat = table.concat
local rep = string.rep
local sort = table.sort

local TYPE_RANK = { n = 0 }
local render

for type_name in ("number string boolean table function userdata thread"):gmatch("%S+") do
  TYPE_RANK.n = TYPE_RANK.n + 1
  TYPE_RANK[type_name] = TYPE_RANK.n
end

local function keyless(a, b)
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

  sort(entries, keyless)
  return entries
end

local function render_entry(entry, depth, state)
  local eq = state.inline and "=" or " = "
  local k, v = entry.key, entry.value
  if entry.implicit then
    return render(v, k, depth + 1, state, true)
  end
  return render_key(k) .. eq .. render(v, k, depth + 1, state, true)
end

local function render_entries(entries, depth, state)
  local parts = {}
  local next_array_key = 1

  if state.inline then
    for i = 1, #entries do
      local entry = entries[i]
      if state.omit_array_keys and entry.key == next_array_key then
        entry.implicit = true
        next_array_key = next_array_key + 1
      end
      parts[i] = render_entry(entry, depth, state)
    end
    return "{" .. concat(parts, ",") .. "}"
  end

  local indent = rep(state.indent, depth)
  for i = 1, #entries do
    local entry = entries[i]
    if state.omit_array_keys and entry.key == next_array_key then
      entry.implicit = true
      next_array_key = next_array_key + 1
    end
    parts[i] = indent .. render_entry(entry, depth, state)
  end

  local sep = state.newline
  return "{" .. sep .. concat(parts, "," .. sep) .. sep .. rep(state.indent, depth - 1) .. "}"
end

function render(v, k, depth, opts, replaced)
  if not replaced then
    v = apply_replacer(opts, k, v)
  end

  local tv = type(v)
  if tv == "string" then
    return quote(v)
  elseif tv ~= "table" then
    return tostring(v)
  end

  local stack = opts.stack

  if stack[v] then
    return "<cycle>"
  end
  stack[v] = true

  if next(v) == nil then
    stack[v] = nil
    return "{}"
  end

  local entries = collect_entries(v, opts)
  if #entries == 0 then
    stack[v] = nil
    return "{}"
  end

  local out = render_entries(entries, depth, opts)
  stack[v] = nil
  return out
end

return function(v, opts)
  opts = assert_arg(2, opts, "table", true) or {}

  validate("stringify.opts.omit_array_keys", opts.omit_array_keys, "boolean", true)
  validate("stringify.opts.indent", opts.indent, "string", true)
  validate("stringify.opts.newline", opts.newline, "string", true)
  validate("stringify.opts.replacer", opts.replacer, "function", true)

  local newline = opts.newline == nil and "\n" or opts.newline
  return render(v, "", 1, {
    omit_array_keys = opts.omit_array_keys ~= false,
    indent = opts.indent or "  ",
    inline = newline == "",
    newline = newline,
    replacer = opts.replacer,
    stack = {},
  })
end
