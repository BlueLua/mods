--[[
  Portions of this module are derived from CPython's ntpath.py.
  Adapted and ported to Lua for this project's API and conventions.
  Source: https://github.com/python/cpython/blob/main/Lib/ntpath.py
  License: Python Software Foundation License Version 2 (PSF-2.0).
  Copyright (c) 2001 Python Software Foundation; All Rights Reserved.
]]

local mods = require "mods"
local Set = mods.set
local utils = mods.utils

local assert_arg = utils.assert_arg
local tbl_count = mods.tbl.count

local byte = string.byte
local char = string.char
local concat = table.concat
local find = string.find
local fmt = string.format
local getenv = os.getenv
local gmatch = string.gmatch
local gsub = string.gsub
local lower = string.lower
local match = string.match
local min = math.min
local move = table.move
local sub = string.sub
local upper = string.upper

local path = {}
path = setmetatable(path, {
  __index = function(_, k)
    path = mods.path
    return path[k]
  end,
})

---@type mods.ntpath
local M = {}

local ALT_SEP = "/"
local CURDIR = "."
local DRIVE_SEP = ":"
local EXT_SEP = "."
local PARDIR = ".."
local reserved_char = Set({ '"', "*", ":", "<", ">", "?", "|", "/", "\\" })
local reserved_names = Set({ "AUX", "CON", "CONIN$", "CONOUT$", "NUL", "PRN" })
local SEP = "\\"
local SEPS = "\\/"
local UNC_PREFIX = "\\\\?\\UNC\\"

for i = 1, 9 do
  reserved_names:add("COM" .. i):add("LPT" .. i)
end

local function starts_with(s, prefix)
  return sub(s, 1, #prefix) == prefix
end

local function is_sep(c)
  return c == SEP or c == ALT_SEP
end

local function norm_seps(p)
  return gsub(p, ALT_SEP, SEP)
end

local function rstrip_seps(s)
  local i = #s
  while i > 0 and is_sep(sub(s, i, i)) do
    i = i - 1
  end
  return sub(s, 1, i)
end

local function split_components(p, skip_curdir)
  local out = {}
  for part in gmatch(p, "[^\\]+") do
    if not skip_curdir or (part ~= "" and part ~= CURDIR) then
      out[#out + 1] = part
    end
  end
  return out
end

local function is_reserved_name(name)
  if name == "" then
    return false
  end

  local last = sub(name, -1)
  if last == EXT_SEP or last == " " then
    return name ~= CURDIR and name ~= PARDIR
  end

  for i = 1, #name do
    local c = sub(name, i, i)
    local b = byte(c)
    if (b and b < 32) or rawget(reserved_char, c) then
      return true
    end
  end

  local base = match(name, "^[^%.]*") or name
  base = upper(gsub(base, " +$", ""))
  return rawget(reserved_names, base) == true
end

function M.normcase(s)
  assert_arg(1, s, "string")
  return lower(norm_seps(s))
end

function M.isabs(p)
  assert_arg(1, p, "string")
  local s = norm_seps(sub(p, 1, 3))
  return sub(s, 2, 3) == DRIVE_SEP .. SEP or sub(s, 1, 2) == SEP .. SEP
end

function M.from_uri(uri)
  assert_arg(1, uri, "string")

  local body = match(uri, "^file:(.*)$")
  if not body then
    return nil, "invalid file uri"
  end

  local is_unc = match(body, "^//") ~= nil
  local is_drive = match(body, "^/*[%a][:|]") ~= nil
  if not is_unc and not is_drive then
    return nil, "invalid file uri"
  end

  if is_unc then
    local authority, rest = match(body, "^//([^/]*)(/.*)$")
    if authority and (authority == "" or authority == "localhost") then
      body = rest
    end
  end

  body = gsub(body, "%%(%x%x)", function(hex)
    return char(tonumber(hex, 16))
  end)
  body = gsub(body, "^/*([%a])[:|]", "%1:")
  if match(body, "^///+") then
    body = "//" .. gsub(body, "^/+", "")
  end

  body = gsub(body, ALT_SEP, SEP)
  if not M.isabs(body) then
    return nil, "uri is not absolute"
  end

  return body
end

function M.splitroot(p)
  assert_arg(1, p, "string")
  local normp = norm_seps(p)

  if sub(normp, 1, 1) == SEP then
    if sub(normp, 2, 2) == SEP then
      local start = upper(sub(normp, 1, 8)) == UNC_PREFIX and 9 or 3
      local index = find(normp, SEP, start, true)
      if not index then
        return p, "", ""
      end
      local index2 = find(normp, SEP, index + 1, true)
      if not index2 then
        return p, "", ""
      end
      return sub(p, 1, index2 - 1), sub(p, index2, index2), sub(p, index2 + 1)
    end
    return "", sub(p, 1, 1), sub(p, 2)
  end

  if sub(normp, 2, 2) == DRIVE_SEP then
    if sub(normp, 3, 3) == SEP then
      return sub(p, 1, 2), sub(p, 3, 3), sub(p, 4)
    end
    return sub(p, 1, 2), "", sub(p, 3)
  end

  return "", "", p
end

function M.splitdrive(p)
  assert_arg(1, p, "string")
  local drive, root, tail = M.splitroot(p)
  return drive, root .. tail
end

function M.join(p, ...)
  assert_arg(1, p, "string")
  local result_drive, result_root, result_path = M.splitroot(p)

  for i = 1, select("#", ...) do
    local part = select(i, ...)
    assert_arg(i + 1, part, "string")
    local p_drive, p_root, p_path = M.splitroot(part)

    if p_root ~= "" then
      if p_drive ~= "" or result_drive == "" then
        result_drive = p_drive
      end
      result_root = p_root
      result_path = p_path
    else
      local skip_append = false
      if p_drive ~= "" and p_drive ~= result_drive then
        if p_drive:lower() ~= result_drive:lower() then
          result_drive = p_drive
          result_root = p_root
          result_path = p_path
          skip_append = true
        else
          result_drive = p_drive
        end
      end

      if not skip_append then
        local last = sub(result_path, -1)
        if result_path ~= "" and not is_sep(last) then
          result_path = result_path .. SEP
        end
        result_path = result_path .. p_path
      end
    end
  end

  if result_path ~= "" and result_root == "" and result_drive ~= "" then
    local last = sub(result_drive, -1)
    if not find(DRIVE_SEP .. SEPS, last, 1, true) then
      return result_drive .. SEP .. result_path
    end
  end

  return result_drive .. result_root .. result_path
end

function M.split(p)
  assert_arg(1, p, "string")
  local drive, root, tail = M.splitroot(p)

  local i = #tail
  while i > 0 and not find(SEPS, sub(tail, i, i), 1, true) do
    i = i - 1
  end

  local head = rstrip_seps(sub(tail, 1, i))
  local last = sub(tail, i + 1)
  return drive .. root .. head, last
end

function M.splitext(p)
  assert_arg(1, p, "string")
  return path._splitext(p, SEP, ALT_SEP, EXT_SEP)
end

function M.basename(p)
  assert_arg(1, p, "string")
  local _, tail = M.split(p)
  return tail
end

function M.dirname(p)
  assert_arg(1, p, "string")
  return (M.split(p))
end

function M.ismount(p)
  assert_arg(1, p, "string")
  p = M.abspath(p)
  local drive, root, rest = M.splitroot(p)
  if drive ~= "" and is_sep(sub(drive, 1, 1)) then
    return rest == ""
  end
  return root ~= "" and rest == ""
end

function M.isreserved(p)
  assert_arg(1, p, "string")
  local _, _, tail = M.splitroot(p)
  tail = norm_seps(tail)

  local parts = split_components(tail)
  for i = #parts, 1, -1 do
    if is_reserved_name(parts[i]) then
      return true
    end
  end

  return false
end

function M.home()
  local userhome = getenv("USERPROFILE")
  if userhome and userhome ~= "" then
    return userhome
  end

  local homepath = getenv("HOMEPATH")
  if not homepath or homepath == "" then
    return nil, "home directory is not set"
  end

  return M.join(getenv("HOMEDRIVE") or "", homepath)
end

function M.expanduser(p)
  assert_arg(1, p, "string")
  if not starts_with(p, "~") then
    return p
  end

  local i = 2
  local n = #p
  while i <= n and not is_sep(sub(p, i, i)) do
    i = i + 1
  end

  local userhome, err = M.home()
  if not userhome then
    return nil, err
  end

  if i ~= 2 then
    local target_user = sub(p, 2, i - 1)
    local current_user = getenv("USERNAME")

    if target_user ~= current_user then
      if current_user ~= M.basename(userhome) then
        return nil, "home directory for user is not set"
      end
      userhome = M.join(M.dirname(userhome), target_user)
    end
  end

  return userhome .. sub(p, i)
end

function M.normpath(p)
  assert_arg(1, p, "string")
  if p == "" then
    return CURDIR
  end

  p = norm_seps(p)
  local drive, root, tail = M.splitroot(p)
  local prefix = drive .. root
  local comps = split_components(tail)
  local out = {}

  for i = 1, #comps do
    local comp = comps[i]
    if comp ~= "" and comp ~= CURDIR then
      if comp ~= PARDIR then
        out[#out + 1] = comp
      elseif #out > 0 and out[#out] ~= PARDIR then
        out[#out] = nil
      elseif root == "" then
        out[#out + 1] = comp
      end
    end
  end

  if prefix == "" and #out == 0 then
    out[1] = CURDIR
  end

  return prefix .. concat(out, SEP)
end

function M.abspath(p)
  assert_arg(1, p, "string")
  if not M.isabs(p) then
    local cwd, err = M.cwd()
    if not cwd then
      error(err, 2)
    end
    p = M.join(cwd, p)
  end
  return M.normpath(p)
end

function M.relpath(p, start)
  assert_arg(1, p, "string")
  if start ~= nil then
    assert_arg(2, start, "string")
  end
  if p == "" then
    return nil, "no path specified"
  end

  start = start or CURDIR

  local start_abs = M.abspath(start)
  local path_abs = M.abspath(p)
  local start_drive, _, start_rest = M.splitroot(start_abs)
  local path_drive, _, path_rest = M.splitroot(path_abs)

  if M.normcase(start_drive) ~= M.normcase(path_drive) then
    return nil, fmt("path is on mount '%s', start on mount '%s'", path_drive, start_drive)
  end

  local start_list = split_components(start_rest)
  local path_list = split_components(path_rest)

  local i = 1
  while i <= #start_list and i <= #path_list do
    if M.normcase(start_list[i]) ~= M.normcase(path_list[i]) then
      break
    end
    i = i + 1
  end

  local rel = {}
  for _ = i, #start_list do
    rel[#rel + 1] = PARDIR
  end
  move(path_list, i, #path_list, #rel + 1, rel)

  if #rel == 0 then
    return CURDIR
  end
  return concat(rel, SEP)
end

function M.commonpath(paths)
  assert_arg(1, paths, "table")
  if #paths == 0 then
    return nil, "paths list is empty"
  end

  local normed = {}
  for i = 1, #paths do
    assert_arg(i, paths[i], "string")
    normed[i] = norm_seps(paths[i])
  end

  local first_drive, first_root, first_tail = M.splitroot(normed[1])
  local first_parts = split_components(first_tail, true)
  local common_len = #first_parts

  local drives = {}
  local roots = {}
  drives[M.normcase(first_drive)] = true
  roots[first_root] = true

  for i = 2, #normed do
    local drive, root, tail = M.splitroot(normed[i])
    drives[M.normcase(drive)] = true
    roots[root] = true

    local parts = split_components(tail, true)
    local n = min(common_len, #parts)
    local j = 1
    while j <= n and M.normcase(first_parts[j]) == M.normcase(parts[j]) do
      j = j + 1
    end
    common_len = j - 1
  end

  local drive_count = tbl_count(drives)
  if drive_count ~= 1 then
    return nil, "paths don't have the same drive"
  end

  local root_count = tbl_count(roots)
  if root_count ~= 1 then
    if first_drive ~= "" then
      return nil, "can't mix absolute and relative paths"
    end
    return nil, "can't mix rooted and not-rooted paths"
  end

  local common = {}
  move(first_parts, 1, common_len, 1, common)

  return first_drive .. first_root .. concat(common, SEP)
end

function M._expand_percent_vars(p)
  local out = {}
  local i = 1
  local n = #p

  while i <= n do
    local ch = sub(p, i, i)
    if ch ~= "%" then
      out[#out + 1] = ch
      i = i + 1
    else
      if i > 1 and sub(p, i - 1, i - 1) == "'" then
        local close = find(p, "%", i + 1, true)
        if close then
          out[#out + 1] = sub(p, i, close)
          i = close + 1
        else
          out[#out + 1] = "%"
          i = i + 1
        end
      elseif i < n and sub(p, i + 1, i + 1) == "%" then
        out[#out + 1] = "%"
        i = i + 2
      else
        local close = find(p, "%", i + 1, true)
        if not close then
          out[#out + 1] = "%"
          i = i + 1
        else
          local name = sub(p, i + 1, close - 1)
          local v = getenv(name)
          out[#out + 1] = v and v or ("%" .. name .. "%")
          i = close + 1
        end
      end
    end
  end

  return concat(out)
end

setmetatable(M, {
  __index = function(t, k)
    local v = path[k]
    t[k] = v
    return v
  end,
})

if _TEST then
  getenv = function(name)
    return os.getenv(name)
  end
end

return M
