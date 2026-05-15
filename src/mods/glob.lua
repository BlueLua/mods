local mods = require "mods"

local List = mods.list
local Set = mods.set
local path = mods.path
local utils = mods.utils

local assert_arg = utils.assert_arg
local validate = utils.validate
local listdir = mods.fs.listdir
local isdir = mods.is.dir
local as_posix = path.as_posix
local join = path.join
local relpath = path.relpath

local concat = table.concat
local gsub = string.gsub
local lower = string.lower
local match = string.match
local sub = string.sub

---@type mods.glob
local M = {}

local is_windows = mods.runtime.is_windows
local escaped_glob_chars = Set({ "*", "?", "[", "]", "{", "}", "!", ",", "\\" })
local magic_chars = Set({ "*", "?", "[", "]", "{", "}" })

local function new_match_cache()
  return {
    brace_expansions = {},
    compiled_parts = {},
  }
end

-- Split a path or pattern into segments while preserving escaped glob backslashes.
local function split_parts(p)
  local parts = {}
  local start = 1

  for i = 1, #p do
    local next_i = i + 1
    local c = sub(p, i, i)
    local next_c = sub(p, next_i, next_i)
    if c == "/" or (is_windows and c == "\\" and not escaped_glob_chars[next_c]) then
      parts[#parts + 1] = sub(p, start, i - 1)
      start = next_i
    end
  end

  parts[#parts + 1] = sub(p, start)
  return parts
end

local function is_hidden_part(part)
  return sub(part, 1, 1) == "."
end

local function has_hidden_parts(parts)
  for i = 1, #parts do
    if is_hidden_part(parts[i]) then
      return true
    end
  end
  return false
end

-- Check whether hidden path parts are explicitly allowed by the pattern.
local function hidden_match_allowed(path_parts, pattern_parts, path_i, pattern_i)
  while true do
    local path_part = path_parts[path_i]
    if path_part == nil then
      return true
    end

    local pattern_part = pattern_parts[pattern_i]
    if pattern_part == nil then
      return false
    end

    if pattern_part == "**" then
      if pattern_parts[pattern_i + 1] == nil then
        return false
      end
      if hidden_match_allowed(path_parts, pattern_parts, path_i, pattern_i + 1) then
        return true
      end
      if is_hidden_part(path_part) then
        return false
      end
      path_i = path_i + 1
    else
      if is_hidden_part(path_part) and not is_hidden_part(pattern_part) then
        return false
      end
      path_i = path_i + 1
      pattern_i = pattern_i + 1
    end
  end
end

-- Escape one literal character for use in a Lua pattern.
local function escape_lua_char(c)
  return (gsub(c, "([%^%$%(%)%%%.%[%]%+%-%*%?])", "%%%1"))
end

local function fold_case(s, ignorecase)
  return ignorecase and lower(s) or s
end

-- Translate one bracket class like `[a-z]` or `[!0-9]` into a Lua pattern class.
local function translate_class(part, i)
  local j = i + 1
  if sub(part, j, j) == "" then
    return "%[", i
  end

  local out = {}
  if sub(part, j, j) == "!" then
    out[#out + 1] = "^"
    j = j + 1
  end

  local first = true
  while j <= #part do
    local c = sub(part, j, j)
    if c == "]" and not first then
      return "[" .. concat(out) .. "]", j
    end

    if c == "\\" and j < #part then
      j = j + 1
      c = escape_lua_char(sub(part, j, j))
    elseif c == "%" then
      c = "%%"
    end

    out[#out + 1] = c
    first = false
    j = j + 1
  end

  return "%[", i
end

-- Compile one glob segment to a cached Lua pattern.
local function compile_part(pattern, cache)
  local compiled_parts = cache.compiled_parts
  local compiled = compiled_parts[pattern]
  if compiled then
    return compiled
  end

  local out = {}
  local i = 1
  while i <= #pattern do
    local c = sub(pattern, i, i)
    if c == "\\" and i < #pattern then
      i = i + 1
      out[#out + 1] = escape_lua_char(sub(pattern, i, i))
    elseif c == "*" then
      out[#out + 1] = "[^/]*"
    elseif c == "?" then
      out[#out + 1] = "[^/]"
    elseif c == "[" then
      local class, j = translate_class(pattern, i)
      out[#out + 1] = class
      i = j
    else
      out[#out + 1] = escape_lua_char(c)
    end
    i = i + 1
  end

  compiled = "^" .. concat(out) .. "$"
  compiled_parts[pattern] = compiled
  return compiled
end

-- Split a brace body on top-level commas only.
local function split_brace_alternatives(s)
  local out = {}
  local depth = 0
  local start = 1
  local i = 1

  while i <= #s do
    local c = sub(s, i, i)
    if c == "\\" then
      i = i + 1
    elseif c == "," and depth == 0 then
      out[#out + 1] = sub(s, start, i - 1)
      start = i + 1
    else
      if c == "{" then
        depth = depth + 1
      elseif c == "}" and depth > 0 then
        depth = depth - 1
      end
    end
    i = i + 1
  end

  out[#out + 1] = sub(s, start)
  return out
end

-- Find the first outer balanced `{...}` pair so patterns like
-- `x{a,{b,c}}y` use the outer `{a,{b,c}}` pair, not the inner `{b,c}`.
---@param pattern string
---@return integer? start
---@return integer? stop
local function find_first_brace_pair(pattern)
  local depth = 0
  local start
  local i = 1
  while i <= #pattern do
    local c = sub(pattern, i, i)
    if c == "\\" then
      i = i + 1
    elseif c == "{" then
      if depth == 0 then
        start = i
      end
      depth = depth + 1
    elseif c == "}" and depth > 0 then
      depth = depth - 1
      if depth == 0 then
        return start, i
      end
    end
    i = i + 1
  end
end

-- Recursively expand brace alternation like `{a,b}` or `{a,{b,c}}`.
local function expand_braces(pattern, out)
  local start, stop = find_first_brace_pair(pattern)
  if not start then
    out[#out + 1] = pattern
    return
  end

  local left = sub(pattern, 1, start - 1)
  local body = sub(pattern, start + 1, stop - 1)
  local right = sub(pattern, stop + 1)
  local choices = split_brace_alternatives(body)
  for i = 1, #choices do
    expand_braces(left .. choices[i] .. right, out)
  end
end

-- Cache brace expansion results for repeated segment matches.
local function get_brace_expansions(pattern, cache)
  local brace_expansions = cache.brace_expansions
  local expanded = brace_expansions[pattern]
  if expanded then
    return expanded
  end

  expanded = {}
  expand_braces(pattern, expanded)
  brace_expansions[pattern] = expanded
  return expanded
end

-- Match one path segment against one glob segment.
local function match_part_single(name, pattern, cache)
  return match(name, compile_part(pattern, cache)) ~= nil
end

-- Match one segment, expanding braces only when needed.
local function match_part(name, pattern, cache)
  if not find_first_brace_pair(pattern) then
    return match_part_single(name, pattern, cache)
  end

  local expanded = get_brace_expansions(pattern, cache)
  for i = 1, #expanded do
    if match_part_single(name, expanded[i], cache) then
      return true
    end
  end
  return false
end

-- Match path segments recursively, with special handling for `**`.
local function match_parts(path_parts, pattern_parts, path_i, pattern_i, cache)
  while true do
    local pattern_part = pattern_parts[pattern_i]
    if pattern_part == nil then
      return path_parts[path_i] == nil
    end

    if pattern_part == "**" then
      local is_last = pattern_parts[pattern_i + 1] == nil
      if is_last then
        return path_parts[path_i] ~= nil
      end
      local i = path_i
      while true do
        if match_parts(path_parts, pattern_parts, i, pattern_i + 1, cache) then
          return true
        end
        local path_part = path_parts[i]
        if path_part == nil then
          return false
        end
        i = i + 1
      end
    end

    local path_part = path_parts[path_i]
    if path_part == nil then
      return false
    end
    if not match_part(path_part, pattern_part, cache) then
      return false
    end

    path_i = path_i + 1
    pattern_i = pattern_i + 1
  end
end

function M.match(p, pattern, ignorecase)
  assert_arg(1, p, "string")
  assert_arg(2, pattern, "string")
  assert_arg(3, ignorecase, "boolean", true)

  local ignorecase_ = ignorecase == nil and is_windows or ignorecase
  local folded_path = fold_case(p, ignorecase_)
  local folded_pattern = fold_case(pattern, ignorecase_)
  return match_parts(split_parts(folded_path), split_parts(folded_pattern), 1, 1, new_match_cache())
end

function M.translate(pattern)
  assert_arg(1, pattern, "string")
  return compile_part(pattern, new_match_cache())
end

function M.has_magic(s)
  assert_arg(1, s, "string")

  local i = 1
  while i <= #s do
    local c = sub(s, i, i)
    if c == "\\" then
      i = i + 1
    elseif magic_chars[c] then
      return true
    end
    i = i + 1
  end

  return false
end

function M.escape(s)
  assert_arg(1, s, "string")
  return (gsub(s, "([%*%?%[%]{}!,\\])", "\\%1"))
end

local function prepare_glob(name, root, pattern, opts)
  opts = opts or {}

  if pattern == nil then
    pattern = root
    root = "."
  end

  validate(name .. ".opts.follow", opts.follow, "boolean", true)
  validate(name .. ".opts.hidden", opts.hidden, "boolean", true)
  validate(name .. ".opts.ignorecase", opts.ignorecase, "boolean", true)
  validate(name .. ".opts.recursive", opts.recursive, "boolean", true)

  if opts.recursive then
    pattern = join("**", pattern)
  end

  local ignorecase = opts.ignorecase == nil and is_windows or opts.ignorecase
  local posix_pattern = as_posix(pattern)
  local dir_only = posix_pattern ~= "" and sub(posix_pattern, -1) == "/"
  local match_pattern = dir_only and sub(pattern, 1, -2) or pattern
  local pattern_parts = split_parts(fold_case(match_pattern, ignorecase))
  local paths = isdir(root) and listdir(root, { follow = opts.follow, recursive = true }) or List()
  return {
    cache = new_match_cache(),
    dir_only = dir_only,
    hidden = opts.hidden ~= false,
    index = 1,
    pattern_parts = pattern_parts,
    paths = paths,
    root = root,
    ignorecase = ignorecase,
  }
end

local function iglob_iter(state)
  local paths = state.paths
  local root = state.root
  local ignorecase = state.ignorecase
  local hidden = state.hidden
  local cache = state.cache
  local pattern_parts = state.pattern_parts
  local dir_only = state.dir_only

  while true do
    local index = state.index
    local candidate = paths[index]
    if candidate == nil then
      return nil
    end
    state.index = index + 1

    local rel = relpath(candidate, root)
    if rel then
      local rel_parts = split_parts(fold_case(rel, ignorecase))
      -- Filter hidden-path exceptions first, then apply the glob and any directory-only suffix check.
      local hidden_ok = hidden or not has_hidden_parts(rel_parts)
      if hidden_ok or hidden_match_allowed(rel_parts, pattern_parts, 1, 1) then
        if match_parts(rel_parts, pattern_parts, 1, 1, cache) then
          if not dir_only or isdir(candidate) then
            return candidate
          end
        end
      end
    end
  end
end

function M.filter(names, pattern, ignorecase)
  assert_arg(1, names, "table")
  assert_arg(2, pattern, "string")
  assert_arg(3, ignorecase, "boolean", true)

  local matches = List()
  for i = 1, #names do
    local name = names[i]
    if M.match(name, pattern, ignorecase) then
      matches[#matches + 1] = name
    end
  end
  return matches
end

function M.iglob(p, pattern, opts)
  assert_arg(1, p, "string")
  assert_arg(2, pattern, "string", true)
  assert_arg(3, opts, "table", true)
  return iglob_iter, prepare_glob("iglob", p, pattern, opts), nil
end

function M.glob(p, pattern, opts)
  assert_arg(1, p, "string")
  assert_arg(2, pattern, "string", true)
  assert_arg(3, opts, "table", true)
  local ls = List()
  for item in iglob_iter, prepare_glob("glob", p, pattern, opts), nil do
    ls[#ls + 1] = item
  end
  return ls
end


-- stylua: ignore
if _TEST then
  ---@diagnostic disable: inject-field
  function M._set_posix_semantics()   is_windows = false end
  function M._set_windows_semantics() is_windows = true  end
end

return M
