local mods = require "mods"

local List = mods.list
local keyword = mods.keyword
local stringcase = mods.stringcase

local byte = string.byte
local char = string.char
local concat = table.concat
local find = string.find
local floor = math.floor
local gmatch = string.gmatch
local gsub = string.gsub
local lower = string.lower
local match = string.match
local rep = string.rep
local sub = string.sub
local upper = string.upper

---@type mods.str
local M = {}

local function norm_range(s, start, stop)
  if start == nil then
    start = 1
  elseif start < 0 then
    start = #s + start + 1
  end

  if stop == nil then
    stop = #s
  elseif stop < 0 then
    stop = #s + stop + 1
  end

  if start < 1 then
    start = 1
  end
  if stop > #s then
    stop = #s
  end

  return start, stop
end

local function escape_class(s)
  return gsub(s, "([]%%^-])", "%%%1")
end

local function first_char_or_space(fillchar)
  return fillchar and sub(fillchar, 1, 1) or " "
end

local function split_whitespace_words(s)
  local parts = {}
  for w in gmatch(s, "%S+") do
    parts[#parts + 1] = w
  end
  return parts
end

local function norm_range_exclusive(s, start, stop)
  local a = start
  local b = stop

  if a == nil then
    a = 1
  elseif a < 0 then
    a = #s + a + 1
  end

  if b == nil then
    b = #s + 1
  elseif b < 0 then
    b = #s + b + 1
  end

  if a < 1 then
    a = 1
  elseif a > #s + 1 then
    a = #s + 1
  end

  if b < 1 then
    b = 1
  elseif b > #s + 1 then
    b = #s + 1
  end

  return a, b
end

function M.center(s, width, fillchar)
  if width <= #s then
    return s
  end
  local pad = width - #s
  local left = floor(pad / 2)
  local right = pad - left
  local fc = first_char_or_space(fillchar)
  return rep(fc, left) .. s .. rep(fc, right)
end

function M.count(s, subp, start, stop)
  local a, b = norm_range_exclusive(s, start, stop)
  if b <= a then
    return 0
  end
  local slice = sub(s, a, b - 1)
  if subp == "" then
    return (b - a) + 1
  end

  local n = 0
  local pos = 1
  local sublen = #subp
  while true do
    local i = find(slice, subp, pos, true)
    if not i then
      break
    end
    n = n + 1
    pos = i + sublen
  end
  return n
end

function M.expandtabs(s, tabsize)
  local ts = tabsize or 8
  if ts <= 0 then
    return (gsub(s, "\t", ""))
  end

  local out = {}
  local col = 0
  for i = 1, #s do
    local c = sub(s, i, i)
    if c == "\t" then
      local spaces = ts - (col % ts)
      out[#out + 1] = rep(" ", spaces)
      col = col + spaces
    else
      out[#out + 1] = c
      col = (c == "\n" or c == "\r") and 0 or (col + 1)
    end
  end
  return concat(out)
end

function M.endswith(s, suffix, start, stop)
  if type(suffix) == "table" then
    for i = 1, #suffix do
      if M.endswith(s, suffix[i], start, stop) then
        return true
      end
    end
    return false
  end

  local a, b = norm_range_exclusive(s, start, stop)
  if suffix == "" then
    return a <= b
  end

  local slen = #suffix
  if b - a < slen then
    return false
  end

  local endpos = b - 1
  local startpos = endpos - slen + 1
  if startpos < a then
    return false
  end

  return sub(s, startpos, endpos) == suffix
end

function M.find(s, subp, start, stop)
  local a, b = norm_range_exclusive(s, start, stop)

  if subp == "" then
    return a <= b and a or nil
  end
  if b <= a then
    return
  end
  local i = find(s, subp, a, true)
  if not i then
    return
  end
  if i + #subp - 1 >= b then
    return
  end
  return i
end

function M.format_map(s, mapping)
  return (
    gsub(s, "{(.-)}", function(k)
      local v = mapping[k]
      if v == nil then
        return "nil"
      end
      return tostring(v)
    end)
  )
end

function M.isalnum(s)
  return find(s, "^%w+$") == 1
end

function M.isalpha(s)
  return find(s, "^%a+$") == 1
end

function M.isascii(s)
  for i = 1, #s do
    if byte(s, i) > 127 then
      return false
    end
  end
  return true
end

function M.isdecimal(s)
  return find(s, "^%d+$") == 1
end

function M.islower(s)
  return match(s, "%a") ~= nil and match(s, "%u") == nil
end

function M.isspace(s)
  return find(s, "^%s+$") == 1
end

function M.istitle(s)
  local has = false
  for word in gmatch(s, "%a+") do
    local first = sub(word, 1, 1)
    local rest = sub(word, 2)
    if first ~= upper(first) or rest ~= lower(rest) then
      return false
    end
    has = true
  end
  return has
end

function M.isupper(s)
  return match(s, "%a") ~= nil and match(s, "%l") == nil
end

function M.isprintable(s)
  for i = 1, #s do
    local b = byte(s, i)
    if b < 32 or b > 126 then
      return false
    end
  end
  return true
end

function M.join(sep, list)
  return concat(list, sep)
end

function M.ljust(s, width, fillchar)
  if width <= #s then
    return s
  end
  local fc = first_char_or_space(fillchar)
  return s .. rep(fc, width - #s)
end

function M.lstrip(s, chars)
  if chars == nil then
    return (gsub(s, "^%s+", ""))
  end
  if chars == "" then
    return s
  end
  local set = escape_class(chars)
  return (gsub(s, "^[" .. set .. "]+", ""))
end

function M.rstrip(s, chars)
  if chars == nil then
    return (gsub(s, "%s+$", ""))
  end
  if chars == "" then
    return s
  end
  local set = escape_class(chars)
  return (gsub(s, "[" .. set .. "]+$", ""))
end

function M.strip(s, chars)
  if chars == "" then
    return s
  end
  return M.lstrip(M.rstrip(s, chars), chars)
end

function M.partition(s, sep)
  if sep == "" then
    error("empty separator")
  end
  local i, j = find(s, sep, 1, true)
  if not i then
    return s, "", ""
  end
  return sub(s, 1, i - 1), sep, sub(s, j + 1)
end

function M.removeprefix(s, prefix)
  if prefix ~= "" and sub(s, 1, #prefix) == prefix then
    return sub(s, #prefix + 1)
  end
  return s
end

function M.removesuffix(s, suffix)
  if suffix ~= "" and sub(s, -#suffix) == suffix then
    return sub(s, 1, #s - #suffix)
  end
  return s
end

function M.replace(s, old, new, count)
  if count == 0 then
    return s
  end

  if count == nil or count < 0 then
    count = -1
  end

  if old == "" then
    local limit = count
    if limit < 0 then
      limit = #s + 1
    end
    if limit == 0 then
      return s
    end
    local out = {}
    out[#out + 1] = new
    local n = 1
    for i = 1, #s do
      out[#out + 1] = sub(s, i, i)
      if n < limit then
        out[#out + 1] = new
        n = n + 1
      end
    end
    return concat(out)
  end

  local out = {}
  local start = 1
  local n = 0
  while true do
    local i, j = find(s, old, start, true)
    if not i or (count >= 0 and n >= count) then
      break
    end
    out[#out + 1] = sub(s, start, i - 1)
    out[#out + 1] = new
    start = j + 1
    n = n + 1
  end
  out[#out + 1] = sub(s, start)
  return concat(out)
end

function M.rfind(s, subp, start, stop)
  local a, b = norm_range(s, start, stop)
  if subp == "" then
    return b
  end
  if b < a then
    return
  end
  local slice = sub(s, a, b)
  local last
  local pos = 1
  while true do
    local i = find(slice, subp, pos, true)
    if not i then
      break
    end
    last = i
    pos = i + 1
  end
  if not last then
    return
  end
  return a + last - 1
end

function M.rjust(s, width, fillchar)
  if width <= #s then
    return s
  end
  local fc = first_char_or_space(fillchar)
  return rep(fc, width - #s) .. s
end

function M.rpartition(s, sep)
  if sep == "" then
    error("empty separator")
  end
  local i, j = nil, nil
  local pos = 1
  while true do
    local a, b = find(s, sep, pos, true)
    if not a then
      break
    end
    i, j = a, b
    pos = a + 1
  end
  if not i then
    return "", "", s
  end
  return sub(s, 1, i - 1), sep, sub(s, j + 1)
end

function M.rsplit(s, sep, maxsplit)
  if sep == nil then
    local parts = split_whitespace_words(s)
    if maxsplit == nil or maxsplit < 0 or #parts <= maxsplit + 1 then
      return List(parts)
    end
    local keep = maxsplit + 1
    local out = List()
    local start = #parts - keep + 1
    out[1] = concat(parts, " ", 1, start - 1)
    for i = start, #parts do
      out[#out + 1] = parts[i]
    end
    return out
  end

  if sep == "" then
    error("empty separator")
  end

  local splits = maxsplit or -1
  if splits == 0 then
    return List({ s })
  end

  local parts = {}
  local part_n = 0
  local seplen = #sep
  local pos = #s
  local i = pos - seplen + 1
  while i >= 1 and (splits < 0 or part_n < splits) do
    if sub(s, i, i + seplen - 1) == sep then
      part_n = part_n + 1
      parts[part_n] = sub(s, i + seplen, pos)
      pos = i - 1
      i = pos - seplen + 1
    else
      i = i - 1
    end
  end

  part_n = part_n + 1
  parts[part_n] = sub(s, 1, pos)
  local out = List()
  for idx = part_n, 1, -1 do
    out[#out + 1] = parts[idx]
  end
  return out
end

function M.split(s, sep, maxsplit)
  if sep == nil then
    local parts = split_whitespace_words(s)
    if maxsplit == nil or maxsplit < 0 or #parts <= maxsplit + 1 then
      return List(parts)
    end
    local out = List()
    local keep = maxsplit + 1
    for i = 1, keep - 1 do
      out[#out + 1] = parts[i]
    end
    out[#out + 1] = concat(parts, " ", keep, #parts)
    return out
  end

  if sep == "" then
    error("empty separator")
  end

  local splits = maxsplit or -1
  if splits == 0 then
    return List({ s })
  end

  local parts = List()
  local pos = 1
  while true do
    local i, j = find(s, sep, pos, true)
    if not i or (splits >= 0 and #parts >= splits) then
      break
    end
    parts[#parts + 1] = sub(s, pos, i - 1)
    pos = j + 1
  end
  parts[#parts + 1] = sub(s, pos)
  return parts
end

function M.splitlines(s, keepends)
  local out = List()
  local i = 1
  while i <= #s do
    local j = i
    while j <= #s do
      local b = byte(s, j)
      if b == 10 or b == 13 then
        break
      end
      j = j + 1
    end

    if j > #s then
      out[#out + 1] = sub(s, i)
      break
    end

    local e = j
    if byte(s, j) == 13 and byte(s, j + 1) == 10 then
      e = j + 1
    end

    if keepends then
      out[#out + 1] = sub(s, i, e)
    else
      out[#out + 1] = sub(s, i, j - 1)
    end

    i = e + 1
  end
  return out
end

function M.startswith(s, prefix, start, stop)
  if type(prefix) == "table" then
    for i = 1, #prefix do
      if M.startswith(s, prefix[i], start, stop) then
        return true
      end
    end
    return false
  end

  if start == nil and stop == nil then
    if prefix == "" then
      return true
    end
    local plen = #prefix
    return #s >= plen and sub(s, 1, plen) == prefix
  end

  local a, b = norm_range_exclusive(s, start, stop)
  if prefix == "" then
    return a <= b
  end

  local plen = #prefix
  if b - a < plen then
    return false
  end

  return sub(s, a, a + plen - 1) == prefix
end

function M.title(s)
  return (gsub(lower(s), "(%a)(%w*)", function(f, r)
    return upper(f) .. r
  end))
end

function M.translate(s, table_map)
  local out = {}
  for i = 1, #s do
    local b = byte(s, i)
    local c = char(b)
    local v = table_map[b]
    if v == nil then
      v = table_map[c]
    end

    if v == nil then
      out[#out + 1] = c
    elseif v ~= false then
      out[#out + 1] = type(v) == "number" and char(v) or tostring(v)
    end
  end
  return concat(out)
end

function M.zfill(s, width)
  if width <= #s then
    return s
  end
  local sign = sub(s, 1, 1)
  if sign == "+" or sign == "-" then
    return sign .. rep("0", width - #s) .. sub(s, 2)
  end
  return rep("0", width - #s) .. s
end

M.capitalize = stringcase.capital
M.isidentifier = keyword.isidentifier
M.lower = lower
M.swapcase = stringcase.swap
M.upper = upper

return M
