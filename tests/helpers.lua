local assert = require "luassert"
local busted = require "busted"
local lfs = require "lfs"
local mods = require "mods"

local it = busted.it ---@type fun(name:string, block:fun())
local assert_same = assert.same

local args_repr = mods.utils.args_repr
local spairs = mods.tbl.spairs
local fmt = string.format

local M = {}

function M.tmpname()
  local p = os.tmpname()
  os.remove(p)
  return p
end

function M.make_tmp_dir()
  local root = M.tmpname()
  assert(lfs.mkdir(root))
  return root
end

function M.with_env(env, fn)
  local getenv = os.getenv
  rawset(os, "getenv", function(name)
    return env[name]
  end)
  fn()
  rawset(os, "getenv", getenv)
end

---
---Define table-driven function tests from `{{expected}, {args}}` cases.
---
---```lua
---helpers.test_functions(module, {
---  function_name = {
---    {{ expected_result }, { args }},
---    {{ other_result    }, { args }},
---  },
---  other_function_name = {
---    {{ ... }, { ... }},
---  },
---})
---```
---
---@param module table
---@param tests table<string, {[1]: any[], [2]: any[]}[]>
function M.test_functions(module, tests)
  for fname, t in spairs(tests) do
    for i = 1, #t do
      local expected, args = unpack(t[i] --[[@as {[1]:any[], [2]:any[]}]])
      it(fmt("%s(%s)", fname, args_repr(args)), function()
        assert_same(expected, { module[fname](unpack(args)) })
      end)
    end
  end
end

return M
