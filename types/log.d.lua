---@meta mods.log

---Log level name or severity threshold.
---@alias mods.logLevel
---| string  Any custom log level name.
---| "debug" Debug messages.
---| "info"  Informational messages.
---| "warn"  Warning messages.
---| "error" Error messages.
---| "off"   Logging disabled.

---Callback function for handling log records.
---@alias mods.logHandler fun(record: mods.log.record)

---Numeric severity levels used for log message filtering.
---@enum mods.log.levelno
-- stylua: ignore
local LEVELS = {
  debug = 10,        -- Debug messages.
  info  = 20,        -- Informational messages.
  warn  = 30,        -- Warning messages.
  error = 40,        -- Error messages.
  off   = math.huge, -- Logging disabled.
}

---A single log entry containing metadata and the formatted message.
---@class mods.log.record
---@field levelname mods.logLevel Log level name.
---@field levelno   integer Numeric severity used for filtering.
---@field name      string? Optional logger name.
---@field message   string Joined message string.
---@field args      {[integer]:any, n:integer} Original variadic arguments.
---@field line      string Formatted plain-text log line.

---Configuration options for creating a new logger instance.
---@class mods.log.new.opts
---@field handler? mods.logHandler Optional handler function that receives each emitted record.
---@field level?   mods.logLevel Minimum enabled level; use `"off"` to disable logging. Defaults to `"warn"`.
---@field name?    string Optional logger name included in emitted records.

---
---Logger factory that emits normalized records through an optional custom handler.
---When `opts.handler` is omitted, records are written to `io.stderr`.
---
---## Usage
---
---```lua
---log = mods.log
---
---local logger = log.new()
---logger:warn("config missing") --> writes: [WARN]: config missing
---```
---
---@class mods.log
---@overload fun(opts?:mods.log.new.opts):mods.log.logger
local M = {}

---
---Create a new logger.
---
---@section Factory
---@param opts? mods.log.new.opts Logger configuration.
---@return mods.log.logger logger Logger instance.
---@nodiscard
function M.new(opts) end

---@class mods.log.logger:mods.log.new.opts
---@field private _levelno mods.log.levelno
local Logger = {}

---
---Emit a record for `level` when it passes the logger filter.
---
---@section Logger Methods
---@param levelname mods.logLevel Log level to emit.
---@param ... any Additional values joined with spaces.
function Logger:log(levelname, ...) end

---
---Emit a `debug` record.
---
---@section Logger Methods
---@param ... any Additional values joined with spaces.
function Logger:debug(...) end

---
---Emit an `info` record.
---
---@section Logger Methods
---@param ... any Additional values joined with spaces.
function Logger:info(...) end

---
---Emit a `warn` record.
---
---@section Logger Methods
---@param ... any Additional values joined with spaces.
function Logger:warn(...) end

---
---Emit an `error` record.
---
---@section Logger Methods
---@param ... any Additional values joined with spaces.
function Logger:error(...) end

return M
