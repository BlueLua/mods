---@diagnostic disable: duplicate-set-field

local mods = require "mods"

local utils = mods.utils
local Set = mods.set

local assert_arg = utils.assert_arg
local validate = utils.validate

local stderr = io.stderr
local concat = table.concat
local pack = table.pack

---@type mods.log
local M = {}

local function default_handler(record)
  stderr:write(record.line, "\n")
end

local ALLOWED_OPTS = Set({ "handler", "level", "name" })
local LEVELS = {
  debug = 10,
  info = 20,
  warn = 30,
  error = 40,
  off = math.huge,
}

---@class mods.log.logger
local Logger = {}
Logger.__index = Logger

local function levelno(level)
  local value = LEVELS[level]
  if value == nil then
    error("unknown log level: " .. tostring(level), 3)
  end
  return value
end

local function validate_opts(opts)
  for k in pairs(opts) do
    if not ALLOWED_OPTS[k] then
      error("unknown log option: " .. tostring(k), 3)
    end
  end
end

local function join_args(args)
  if args.n == 0 then
    return ""
  end

  local parts = {}
  for i = 1, args.n do
    parts[i] = tostring(args[i])
  end
  return concat(parts, " ")
end

---@param levelname modsLogLevel
---@param name string
---@param msg string
---@return string
local function format_line(levelname, name, msg)
  local prefix = "[" .. levelname:upper() .. "]"
  if name ~= nil then
    prefix = prefix .. " (" .. name .. ")"
  end
  return msg == "" and prefix or prefix .. ": " .. msg
end

function Logger:log(levelname, ...)
  assert_arg(1, levelname, "string")
  local current_level = levelno(levelname)
  if current_level < self._levelno then
    return
  end

  local args = pack(...)
  local msg = join_args(args)

  ---@type mods.log.record
  local record = {
    levelname = levelname,
    levelno = current_level,
    name = self.name,
    message = msg,
    args = args,
    line = format_line(levelname, self.name, msg),
  }

  return self.handler(record)
end

-- stylua: ignore start
function Logger:debug(...) return self:log("debug", ...) end
function Logger:info (...) return self:log("info" , ...) end
function Logger:warn (...) return self:log("warn" , ...) end
function Logger:error(...) return self:log("error", ...) end
-- stylua: ignore end

function M.new(opts)
  opts = opts or {}
  assert_arg(1, opts, "table")
  validate_opts(opts)
  validate("opts.handler", opts.handler, "function", true)
  validate("opts.level", opts.level, "string", true)
  validate("opts.name", opts.name, "string", true)

  local min_level = opts.level or "warn"
  local logger = {
    _levelno = levelno(min_level),
    name = opts.name,
    level = min_level,
    handler = opts.handler or default_handler,
  }

  return setmetatable(logger, Logger)
end

return setmetatable(M, {
  __call = function(_, opts)
    return M.new(opts)
  end,
})
