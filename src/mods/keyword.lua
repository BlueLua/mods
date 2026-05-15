local mods = require "mods"

local List = mods.list
local Set = mods.set
local runtime = mods.runtime

local ver = runtime.version

local gsub = string.gsub
local match = string.match

---@type mods.keyword
local M = {}

-- stylua: ignore
local kwlist = List({
  "and"   , "break" , "do"  , "else"    , "elseif",
  "end"   , "false" , "for" , "function", "if"    ,
  "in"    , "local" , "nil" , "not"     , "or"    ,
  "repeat", "return", "then", "true"    , "until" , "while",
})

if ver > 501 then
  kwlist:append("goto"):sort()
end

if ver > 504 then
  kwlist:append("global"):sort()
end

local kwset = kwlist:toset()

function M.iskeyword(s)
  return kwset:contains(s)
end

function M.isidentifier(s)
  return type(s) == "string" and not M.iskeyword(s) and match(s, "^[%a_][%w_]*$") ~= nil
end

function M.kwlist()
  return List(kwlist):copy()
end

function M.kwset()
  return Set(kwlist)
end

function M.normalize_identifier(s)
  if s == "" then
    return "_"
  end

  local out = s

  out = gsub(out, "^%s+", "") -- Trim leading whitespace.
  out = gsub(out, "%s+$", "") -- Trim trailing whitespace.
  out = gsub(out, "[^%w_]", "_") -- Replace non-identifier characters with underscores.

  if out == "" then
    return "_"
  elseif match(out, "^%d") then
    out = "_" .. out
  elseif M.iskeyword(out) then
    out = out .. "_"
  end

  return out
end

return M
