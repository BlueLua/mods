---@meta mods

local stringify ---@module "mods.stringify"
local template ---@module "mods.template"

---
---Entry point that exposes all modules under one 💤 lazily loaded table.
---
---@class mods
---@field calendar mods.calendar
---@field fs mods.fs
---@field glob mods.glob
---@field is mods.is
---@field json mods.json
---@field keyword mods.keyword
---@field list mods.List
---@field log mods.log
---@field ntpath mods.ntpath
---@field operator mods.operator
---@field path mods.path
---@field posixpath mods.posixpath
---@field runtime mods.runtime
---@field set mods.Set
---@field str mods.str
---@field stringcase mods.stringcase
---@field tbl mods.tbl
---@field utils mods.utils
---@field validate mods.validate
---@field date mods.Date
---@field duration mods.Duration
local M = {
  stringify = stringify,
  template = template,
}

return M
