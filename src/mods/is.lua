local mods = require "mods"

local List = mods.List
local lfs = mods.utils.lazy_module("lfs") ---@module 'lfs'

---@type mods.is
local M = {}

-------------------
--- Type checks ---
-------------------

-- stylua: ignore start
function M.boolean(v)  return type(v) == "boolean"  end
function M.number(v)   return type(v) == "number"   end
function M.string(v)   return type(v) == "string"   end
function M.table(v)    return type(v) == "table"    end
function M.thread(v)   return type(v) == "thread"   end
function M.userdata(v) return type(v) == "userdata" end

M["nil"]      = function (v) return type(v) == "nil"      end
M["function"] = function (v) return type(v) == "function" end
-- stylua: ignore end

--------------------
--- Value checks ---
--------------------

-- stylua: ignore start
function M.falsy(v)   return not v and true or false            end
function M.integer(v) return type(v) == "number" and v % 1 == 0 end
function M.truthy(v)  return v and true or false                end

M["false"] = function (v) return v == false end
M["true"]  = function (v) return v == true  end
-- stylua: ignore end

function M.callable(v)
  if type(v) == "function" then
    return true
  end
  local mt = getmetatable(v)
  return mt and type(mt.__call) == "function" or false
end

-------------------
--- Path checks ---
-------------------
M._path_validator_names = List({ "path", "block", "char", "dir", "fifo", "file", "link", "socket", "device" })

local function islink(p)
  return lfs.symlinkattributes(p, "mode") == "link"
end

function M.device(v)
  if type(v) ~= "string" then
    return false
  end
  local file_mode = lfs.attributes(v, "mode")
  return file_mode == "char device" or file_mode == "block device"
end

-- stylua: ignore start
function M.block(v)  return type(v) == "string" and lfs.attributes(v, "mode") == "block device"     end
function M.char(v)   return type(v) == "string" and lfs.attributes(v, "mode") == "char device"      end
function M.dir(v)    return type(v) == "string" and lfs.attributes(v, "mode") == "directory"        end
function M.fifo(v)   return type(v) == "string" and lfs.attributes(v, "mode") == "named pipe"       end
function M.file(v)   return type(v) == "string" and lfs.attributes(v, "mode") == "file"             end
function M.socket(v) return type(v) == "string" and lfs.attributes(v, "mode") == "socket"           end
function M.link(v)   return type(v) == "string" and islink(v)                                       end
function M.path(v)   return type(v) == "string" and (lfs.attributes(v, "mode") ~= nil or islink(v)) end
-- stylua: ignore end

--------------------------------
--- Alias setup and dispatch ---
--------------------------------

return setmetatable(M, {
  __index = function(t, k)
    if type(k) == "string" then
      return rawget(t, k:lower())
    end
  end,

  ---@param validator modsValidatorName
  __call = function(t, v, validator)
    local fn = rawget(t, validator)
    if fn then
      return fn(v)
    end
    return type(v) == validator
  end,
})
