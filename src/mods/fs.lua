local mods = require "mods"

local List = mods.list
local is = mods.is
local path = mods.path
local utils = mods.utils
local lfs = mods.utils.lazy_module("lfs") ---@module "lfs"

local parents = path.parents
local normpath = path.normpath
local is_relative_to = path.is_relative_to
local basename = path.basename
local join = path.join
local assert_arg = utils.assert_arg
local validate = utils.validate
local isdir = is.dir
local islink = is.link

local open = io.open
local os_remove = os.remove
local rename = os.rename

---@type mods.fs
local M = {}

local CURDIR = "."
local PARDIR = ".."
local is_windows = mods.runtime.is_windows
local entry_types = {
  ["block device"] = "block",
  ["char device"] = "char",
  ["named pipe"] = "fifo",
}

local function is_dir_marker(entry)
  return entry == CURDIR or entry == PARDIR
end

local function is_hidden(entry)
  return entry:sub(1, 1) == "."
end

local function remove(item)
  if islink(item) then
    if is_windows then
      local ok = lfs.rmdir(item)
      if ok then
        return true
      end
    end
    return os_remove(item)
  end

  if isdir(item) then
    return lfs.rmdir(item)
  end

  return os_remove(item)
end

-- `lfs.dir` throws on failure, so use `pcall` to preserve its error text as `false, err`.
local function open_dir(p)
  local ok, iter, dir_obj = pcall(lfs.dir, p)
  if not ok then
    -- On `pcall` failure, `iter` contains the error message from `lfs.dir`.
    return false, iter
  end
  return iter, dir_obj
end

local function check_dir(p)
  local mode, err = lfs.attributes(p, "mode")
  if not mode then
    return nil, err
  end
  if mode ~= "directory" then
    return nil, "Not a directory"
  end
  return true
end

---@param name LuaFileSystem.AttributeName
local function get_attr(p, name)
  local value, errmsg, errcode = lfs.attributes(p, name)
  if not value then
    return nil, errmsg, errcode
  end
  return value
end

---Read entire file contents using given mode.
---@return string? body, string? err, integer? errcode
local function read(p, mode)
  local f, errmsg, errcode = open(p, mode)
  if not f then
    return nil, errmsg, errcode
  end

  local body = f:read("*a")
  f:close()
  return body
end

---Write file contents using the given mode.
local function write(p, data, mode)
  local f, errmsg, errcode = open(p, mode)
  if not f then
    return nil, errmsg, errcode
  end

  local ok, write_err = f:write(data)
  f:close()
  if not ok then
    return nil, write_err
  end

  return true
end

---Recursively scan a directory tree into output list.
---@param root string
---@param ls string[]
---@param follow_symlinks? boolean
local function scan_dir(root, ls, follow_symlinks)
  local iter, dir_obj = open_dir(root)
  if not iter then
    return false, dir_obj
  end

  for entry in iter, dir_obj do
    if not is_dir_marker(entry) then
      local child = join(root, entry)
      ls[#ls + 1] = child
      if isdir(child) and (follow_symlinks or not islink(child)) then
        local ok, err = scan_dir(child, ls, follow_symlinks)
        if not ok then
          return false, err
        end
      end
    end
  end

  return true
end

local function collect_dir_items(root, opts, items, fullpath)
  local iter, dir_obj = open_dir(root)
  if not iter then
    return false, dir_obj
  end

  local stat = lfs.attributes
  local lstat = lfs.symlinkattributes
  local follow = opts.follow
  local hidden = opts.hidden
  local recursive = opts.recursive
  local type = opts.type

  for entry in iter, dir_obj do
    if not is_dir_marker(entry) and (hidden or not is_hidden(entry)) then
      local child = join(root, entry)
      local link_mode = lstat(child, "mode")
      local tp = entry_types[link_mode] or link_mode or "unknown"
      local child_is_dir = tp == "directory"
      if follow and tp == "link" then
        child_is_dir = stat(child, "mode") == "directory"
      end
      if not type or type == tp then
        items[#items + 1] = { fullpath and child or entry, tp }
      end
      if recursive and child_is_dir and (follow or tp ~= "link") then
        local ok, err = collect_dir_items(child, opts, items, fullpath)
        if not ok then
          return false, err
        end
      end
    end
  end
  return true
end

local function copy_tree(src, dst)
  local normed_src = normpath(src)
  local normed_dst = normpath(dst)
  if is_relative_to(normed_dst, normed_src) then
    return nil, "cannot copy a directory into itself or its descendant"
  end

  local ok, errmsg, errcode
  ok, errmsg, errcode = M.mkdir(dst, true)
  if not ok then
    return nil, errmsg, errcode
  end

  local items = {}
  local collected, collect_err = collect_dir_items(src, { recursive = false }, items, true)
  if not collected then
    return nil, collect_err
  end

  for i = 1, #items do
    local child, type = items[i][1], items[i][2]
    local target = join(dst, basename(child))
    if type == "directory" then
      ok, errmsg, errcode = copy_tree(child, target)
      if not ok then
        return nil, errmsg, errcode
      end
    else
      local body
      body, errmsg, errcode = M.read_bytes(child)
      if not body then
        return nil, errmsg, errcode
      end

      ok, errmsg, errcode = M.write_bytes(target, body)
      if not ok then
        return nil, errmsg, errcode
      end
    end
  end

  return true
end

local function normalize_dir_opts(fname, opts)
  opts = opts or {}
  validate(fname .. ".opts.follow", opts.follow, "boolean", true)
  validate(fname .. ".opts.hidden", opts.hidden, "boolean", true)
  validate(fname .. ".opts.recursive", opts.recursive, "boolean", true)
  validate(fname .. ".opts.names", opts.names, "boolean", true)
  validate(fname .. ".opts.type", opts.type, "string", true)

  return {
    follow = opts.follow == true,
    hidden = opts.hidden ~= false,
    names = opts.names == true,
    recursive = opts.recursive == true,
    type = opts.type,
  }
end

local function dir_items_iter(state)
  local item = state.items[state.index]
  if item == nil then
    return nil
  end
  state.index = state.index + 1
  return item[1], item[2]
end

function M.getsize(p)
  assert_arg(1, p, "string")
  return get_attr(p, "size")
end

function M.getatime(p)
  assert_arg(1, p, "string")
  return get_attr(p, "access")
end

function M.getmtime(p)
  assert_arg(1, p, "string")
  return get_attr(p, "modification")
end

function M.getctime(p)
  assert_arg(1, p, "string")
  return get_attr(p, "change")
end

function M.samefile(path_a, path_b)
  assert_arg(1, path_a, "string")
  assert_arg(2, path_b, "string")

  local a, b, errmsg, errcode

  a, errmsg, errcode = M.stat(path_a)
  if not a then
    return nil, errmsg, errcode
  end

  b, errmsg, errcode = M.stat(path_b)
  if not b then
    return nil, errmsg, errcode
  end

  if a.ino == 0 or b.ino == 0 then
    return path.normcase(path.abspath(path_a)) == path.normcase(path.abspath(path_b))
  end

  return a.dev == b.dev and a.ino == b.ino
end

function M.touch(p)
  assert_arg(1, p, "string")

  -- `lfs.touch` updates timestamps for existing files but does not create new ones.
  if M.exists(p) then
    return lfs.touch(p)
  end

  local file, errmsg, errcode = open(p, "ab")
  if not file then
    return nil, errmsg, errcode
  end

  file:close()
  return true
end

function M.link(a, linkpath)
  assert_arg(1, a, "string")
  assert_arg(2, linkpath, "string")
  return lfs.link(a, linkpath, false)
end

function M.symlink(p, linkpath)
  assert_arg(1, p, "string")
  assert_arg(2, linkpath, "string")
  return lfs.link(p, linkpath, true)
end

function M.exists(p)
  assert_arg(1, p, "string")
  return lfs.attributes(p, "mode") ~= nil
end

function M.lexists(p)
  assert_arg(1, p, "string")
  return lfs.symlinkattributes(p, "mode") ~= nil
end

function M.write_bytes(p, data)
  assert_arg(1, p, "string")
  assert_arg(2, data, "string")
  return write(p, data, "wb")
end

function M.write_text(p, data)
  assert_arg(1, p, "string")
  assert_arg(2, data, "string")
  return write(p, data, "w")
end

function M.read_bytes(p)
  assert_arg(1, p, "string")
  return read(p, "rb")
end

function M.read_text(p)
  assert_arg(1, p, "string")
  return read(p, "r")
end

function M.rm(p, recursive)
  assert_arg(1, p, "string")
  assert_arg(2, recursive, "boolean", true)

  if recursive then
    if islink(p) then
      return remove(p)
    end

    local ok, err
    ok, err = check_dir(p)
    if not ok then
      return nil, err
    end

    local items = {}

    ok, err = scan_dir(p, items, false)
    if not ok then
      return nil, err
    end

    for i = #items, 1, -1 do
      ok, err = remove(items[i]) ---@diagnostic disable-line: cast-local-type
      if not ok then
        return nil, err
      end
    end

    return remove(p)
  end

  return remove(p)
end

function M.mkdir(p, parents_)
  assert_arg(1, p, "string")
  assert_arg(2, parents_, "boolean", true)

  local mkdir = lfs.mkdir
  if not parents_ then
    return mkdir(p)
  end

  local normed = normpath(p)
  local dirs = parents(normed)
  for i = #dirs, 1, -1 do
    local dir = dirs[i]
    if dir ~= CURDIR and not isdir(dir) then
      local ok, errmsg, errcode = mkdir(dir)
      if not ok then
        return nil, errmsg, errcode
      end
    end
  end

  if normed ~= CURDIR and not isdir(normed) then
    return mkdir(normed)
  end

  return true
end

function M.cp(src, dst)
  assert_arg(1, src, "string")
  assert_arg(2, dst, "string")

  if isdir(src) then
    return copy_tree(src, dst)
  end

  local body, errmsg, errcode = M.read_bytes(src)
  if not body then
    return nil, errmsg, errcode
  end

  local ok
  ok, errmsg, errcode = M.write_bytes(dst, body)
  if not ok then
    return nil, errmsg, errcode
  end

  return true
end

function M.listdir(p, opts)
  assert_arg(1, p, "string")
  assert_arg(2, opts, "table", true)
  opts = normalize_dir_opts("listdir", opts)

  local ok, err
  ok, err = check_dir(p)
  if not ok then
    return nil, err
  end

  local items = {}
  ok, err = collect_dir_items(p, opts, items, not opts.names)
  if not ok then
    return nil, err
  end

  local out = List()
  for i = 1, #items do
    out[#out + 1] = items[i][1]
  end
  return out
end

function M.dir(p, opts)
  assert_arg(1, p, "string")
  assert_arg(2, opts, "table", true)
  opts = normalize_dir_opts("dir", opts)

  local ok, err
  ok, err = check_dir(p)
  if not ok then
    return nil, err
  end

  local items = {}
  ok, err = collect_dir_items(p, opts, items, false)
  if not ok then
    return nil, err
  end
  return dir_items_iter, { index = 1, items = items }
end

M.rename = rename

return setmetatable(M, {
  __index = function(t, k)
    local v = ({ cwd = lfs.currentdir, cd = lfs.chdir, stat = lfs.attributes, lstat = lfs.symlinkattributes })[k]
    t[k] = v
    return v
  end,
})
