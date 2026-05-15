--[[
  Portions of this module are derived from CPython's pathlib.py.
  Adapted and ported to Lua for this project's API and conventions.
  Source: https://github.com/python/cpython/blob/main/Lib/pathlib/__init__.py
  License: Python Software Foundation License Version 2 (PSF-2.0).
  Copyright (c) 2001 Python Software Foundation; All Rights Reserved.
]]

local mods = require "mods"

local List = mods.list
local runtime = mods.runtime
local str = mods.str
local utils = mods.utils

local is_win = runtime.is_windows
local assert_arg = utils.assert_arg
local rfind = str.rfind

local byte = string.byte
local concat = table.concat
local find = string.find
local fmt = string.format
local format = string.format
local getenv = os.getenv
local gmatch = string.gmatch
local gsub = string.gsub
local match = string.match
local move = table.move
local sub = string.sub

---@type mods.path
local M = {}

local CURDIR = "."
local DRIVE_SEP = ":"
local PARDIR = ".."
local EXT_SEP = "."
local SEP = is_win and "\\" or "/"

for k, v in pairs(is_win and mods.ntpath or mods.posixpath) do
  M[k] = v
end

local function is_absolute(drive, root)
  return is_win and drive ~= "" and root ~= "" or (not is_win and root ~= "")
end

---@return string drive, string root, string tail
local function splitroot(p)
  p = is_win and gsub(p, "/", "\\") or p
  local drive, root, tail = M.splitroot(p)
  if sub(drive, 1, 2) == "\\\\" then
    root = "\\"
  end
  return drive, root, tail
end

---@return string drive, string root, string[] tail
local function parse_path(p)
  local drive, root, tail_ = splitroot(p)
  local tail = {}
  for part in gmatch(tail_, "[^" .. SEP .. "]+") do
    if part ~= CURDIR then
      tail[#tail + 1] = part
    end
  end
  return drive, root, tail
end

local function parts_equal(a, b, case_sensitive)
  if case_sensitive == false or (case_sensitive == nil and is_win) then
    return M.normcase(a) == M.normcase(b)
  end
  return a == b
end

local function name_of(p)
  local _, _, tail = parse_path(p)
  return tail[#tail] or ""
end

local function relative_parts(p, other)
  local drive, root, tail = parse_path(p)
  local other_drive, other_root, other_tail = parse_path(other)

  if not parts_equal(drive .. root, other_drive .. other_root) then
    return
  end
  if #other_tail > #tail then
    return
  end

  for i = 1, #other_tail do
    if not parts_equal(tail[i], other_tail[i]) then
      return
    end
  end

  local out = {}
  move(tail, #other_tail + 1, #tail, 1, out)
  return out
end

local function expandvars(getenv_fn, s, pattern, prefix, suffix)
  return gsub(s, pattern, function(name)
    local v = getenv_fn(name)
    return v and v or (prefix .. name .. suffix)
  end)
end

function M._splitext(p, sep, altsep, extsep)
  local sep_index = rfind(p, sep) or 0
  if altsep then
    local altsep_index = rfind(p, altsep) or 0
    sep_index = altsep_index > sep_index and altsep_index or sep_index
  end

  local dot_index = rfind(p, extsep) or 0
  if dot_index > sep_index then
    local filename_index = sep_index + 1
    while filename_index < dot_index do
      if sub(p, filename_index, filename_index) ~= extsep then
        return sub(p, 1, dot_index - 1), sub(p, dot_index)
      end
      filename_index = filename_index + 1
    end
  end

  return p, ""
end

function M.anchor(p)
  assert_arg(1, p, "string")
  local drive, root = splitroot(p)
  return drive .. root
end

function M.as_posix(p)
  assert_arg(1, p, "string")
  return (gsub(p, "\\", "/"))
end

function M.as_uri(p)
  assert_arg(1, p, "string")
  local drive, root = M.splitroot(p)
  if not is_absolute(drive, root) then
    return nil, "path is not absolute"
  end
  local posix = M.as_posix(p)
  local prefix
  local path

  if match(drive, "^%a:$") then
    prefix = "file:///" .. drive:lower()
    path = sub(posix, 3)
  elseif drive ~= "" then
    prefix = "file:"
    path = posix
  else
    prefix = "file://"
    path = posix
  end

  local encoded = gsub(path, "[^%w%-%._~/]", function(c)
    return format("%%%02X", byte(c))
  end)

  return prefix .. encoded
end

function M.parents(p)
  assert_arg(1, p, "string")
  local drive, root, tail = parse_path(p)
  local out = {}
  for i = #tail - 1, 0, -1 do
    local parts = {}
    for j = 1, i do
      parts[j] = tail[j]
    end
    local value = drive .. root .. concat(parts, SEP)
    out[#out + 1] = value ~= "" and value or CURDIR
  end
  return List(out)
end

function M.drive(p)
  assert_arg(1, p, "string")
  return (splitroot(p))
end

function M.commonprefix(paths)
  assert_arg(1, paths, "table")
  if #paths == 0 then
    return ""
  end

  local min_path = paths[1]
  local max_path = paths[1]
  for i = 1, #paths do
    local path_ = paths[i]
    assert_arg(i, path_, "string")
    if path_ < min_path then
      min_path = path_
    elseif path_ > max_path then
      max_path = path_
    end
  end

  local i = 1
  local n = #min_path
  while i <= n and sub(min_path, i, i) == sub(max_path, i, i) do
    i = i + 1
  end
  return sub(min_path, 1, i - 1)
end

function M.expandvars(p)
  assert_arg(1, p, "string")
  local res = expandvars(getenv, p, "%${([^}]*)}", "${", "}")
  res = expandvars(getenv, res, "%$([%w_]+)", "$", "")
  return is_win and mods.ntpath._expand_percent_vars(res) or res
end

function M.is_relative_to(p, other)
  assert_arg(1, p, "string")
  assert_arg(2, other, "string")
  return relative_parts(p, other) ~= nil
end

function M.parts(p)
  assert_arg(1, p, "string")
  local drive, root, tail = parse_path(p)
  local out = {}
  local anchor = drive .. root
  if anchor ~= "" then
    out[#out + 1] = anchor
  end
  move(tail, 1, #tail, anchor ~= "" and 2 or 1, out)
  return List(out)
end

function M.relative_to(p, other, walk_up)
  assert_arg(1, p, "string")
  assert_arg(2, other, "string")
  local parts = relative_parts(p, other)
  if parts then
    return #parts == 0 and CURDIR or concat(parts, SEP)
  end

  if not walk_up then
    return nil, fmt("'%s' is not in the subpath of '%s'", p, other)
  end

  local drive, root, tail = parse_path(p)
  local other_drive, other_root, other_tail = parse_path(other)

  if not parts_equal(drive .. root, other_drive .. other_root) then
    return nil, fmt("'%s' is not in the subpath of '%s'", p, other)
  end

  local common = 0
  local max = #tail < #other_tail and #tail or #other_tail
  for i = 1, max do
    if not parts_equal(tail[i], other_tail[i]) then
      break
    end
    common = i
  end

  parts = {}
  for _ = 1, #other_tail - common do
    parts[#parts + 1] = PARDIR
  end
  move(tail, common + 1, #tail, #parts + 1, parts)

  return concat(parts, SEP)
end

function M.with_name(p, name)
  assert_arg(1, p, "string")
  assert_arg(2, name, "string")

  local has_sep = find(name, "/", 1, true) or (is_win and find(name, "\\", 1, true))
  if name == "" or name == CURDIR or has_sep then
    return nil, fmt("invalid name '%s'", name)
  end

  local drive, root, tail = parse_path(p)
  if #tail == 0 then
    return nil, fmt("'%s' has an empty name", p)
  end

  if is_win and drive == "" and root == "" and #tail == 1 and find(name, DRIVE_SEP, 1, true) ~= nil then
    return ".\\" .. name
  end

  tail[#tail] = name
  return drive .. root .. concat(tail, SEP)
end

function M.with_stem(p, stem)
  assert_arg(1, p, "string")
  assert_arg(2, stem, "string")
  if stem == "" then
    return nil, fmt("'%s' has an empty stem", p)
  end
  local _, ext = M.splitext(name_of(p))
  return M.with_name(p, stem .. ext)
end

function M.with_suffix(p, suffix)
  assert_arg(1, p, "string")
  assert_arg(2, suffix, "string")
  if suffix ~= "" and sub(suffix, 1, 1) ~= EXT_SEP then
    return nil, fmt("invalid suffix '%s'", suffix)
  end
  local stem = M.stem(p)
  if stem == "" then
    return nil, fmt("'%s' has an empty name", p)
  end
  return M.with_name(p, stem .. suffix)
end

function M.root(p)
  assert_arg(1, p, "string")
  local _, root = splitroot(p)
  return root
end

function M.stem(p)
  assert_arg(1, p, "string")
  return (M.splitext(name_of(p)))
end

function M.suffixes(p)
  assert_arg(1, p, "string")
  local suffixes = List()
  local stem, ext = M.splitext(name_of(p))
  while ext ~= "" do
    suffixes[#suffixes + 1] = ext
    stem, ext = M.splitext(stem)
  end
  return suffixes:reverse()
end

if _TEST then
  local ntpath = mods.ntpath
  local posixpath = mods.posixpath
  local function set_semantics(win)
    is_win, SEP = win, win and "\\" or "/"
    mods.tbl.update(M, win and ntpath or posixpath)
  end

  ---@diagnostic disable: inject-field
  -- stylua: ignore start
  function M._set_windows_semantics() set_semantics(true) end
  function M._set_posix_semantics() set_semantics(false) end
  getenv = function(name) return os.getenv(name) end
end

return setmetatable(M, {
  __index = function(t, k)
    if k == "cwd" then
      local cwd = mods.fs.cwd
      t[k] = cwd
      return cwd
    end
  end,
})
