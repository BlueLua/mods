local helpers = require "tests.helpers"
local mods = require "mods"

local fs = mods.fs
local is = mods.is
local path = mods.path
local is_luajit = mods.runtime.is_luajit

local make_tmp_dir = helpers.make_tmp_dir
local tmpname = helpers.tmpname

-- stylua: ignore
describe("mods.is", function()
  local is_unix = not mods.runtime.is_windows
  local fn = function() end
  local co = coroutine.create(fn)
  local ct = setmetatable({}, { __call = fn })
  local nct = setmetatable({}, { __call = true })
  local ffi_cdata = is_luajit and require("ffi").new("int", 1) or nil

  -- each()

  each("is", is, {
    __call = {
      { assert = function() assert.Callable(is) end        },
      { expected = true , args = { nil      , "nil"      } },
      { expected = true , args = { nil      , "falsy"    } },
      { expected = false, args = { nil      , "integer"  } },
      { expected = false, args = { nil      , "truthy"   } },
      { expected = true , args = { false    , "boolean"  } },
      { expected = false, args = { 123      , "boolean"  } },
      { expected = true , args = { fn       , "function" } },
      { expected = false, args = { "abc"    , "function" } },
      { expected = true , args = { 123      , "number"   } },
      { expected = false, args = { "abc"    , "number"   } },
      { expected = true , args = { "abc"    , "string"   } },
      { expected = false, args = { true     , "string"   } },
      { expected = true , args = { {}       , "table"    } },
      { expected = false, args = { false    , "table"    } },
      { expected = true , args = { co       , "thread"   } },
      { expected = false, args = { fn       , "thread"   } },
      { expected = true , args = { ct       , "callable" } },
      { expected = false, args = { nct      , "callable" } },
      { expected = true , args = { false    , "false"    } },
      { expected = true , args = { false    , "falsy"    } },
      { expected = false, args = { true     , "false"    } },
      { expected = false, args = { true     , "falsy"    } },
      { expected = true , args = { false    , "defined"  } },
      { expected = false, args = { nil      , "defined"  } },
      { expected = true , args = { 123      , "integer"  } },
      { expected = false, args = { 13.4     , "integer"  } },
      { expected = true , args = { true     , "true"     } },
      { expected = false, args = { false    , "true"     } },
      { expected = true , args = { 123      , "truthy"   } },
      { expected = false, args = { false    , "truthy"   } },
      { expected = true , args = { io.stdout, "userdata" } },
      { expected = false, args = { {}       , "userdata" } },
      { expected = true , args = { 123      , "finite"   } },
      { expected = false, args = { math.huge, "finite"   } },
      { expected = true , args = { math.huge, "infinite" } },
      { expected = false, args = { 123      , "infinite" } },
      { expected = true , args = { 0/0      , "nan"      } },
      { expected = false, args = { 123      , "nan"      } },
      { expected = true , args = { 1.5      , "float"    } },
      { expected = false, args = { "abc"    , "float"    } },
      { expected = is_luajit, args = { ffi_cdata, "cdata" } },

      -- uppercase validator names should fail (fall back to type check)
      { expected = false, args = { nil      , "Nil"      } },
      { expected = false, args = { false    , "Boolean"  } },
      { expected = false, args = { "abc"    , "String"   } },
      { expected = false, args = { 123      , "Number"   } },
      { expected = false, args = { {}       , "Table"    } },
      { expected = false, args = { io.stdout, "Userdata" } },
    },
    Boolean = {
      { expected = true , args = { false } },
      { expected = false, args = { 123 } },
      { expected = false, args = { nil } },
    },
    Cdata = {
      { expected = false, args = { 123 } },
      { expected = false, args = { "abc" } },
      { expected = is_luajit, args = { ffi_cdata } },
    },
    Nil = {
      { expected = true , args = { nil   } },
      { expected = false, args = { false } },
      { expected = false, args = { 123   } },
    },
    Function = {
      { expected = true , args = { fn  } },
      { expected = false, args = { {}  } },
      { expected = false, args = { 123 } },
    },
    Defined = {
      { expected = true , args = { false } },
      { expected = true , args = { true  } },
      { expected = true , args = { 123   } },
      { expected = true , args = { "abc" } },
      { expected = true , args = { {}    } },
      { expected = false, args = { nil   } },
    },
    Falsy = {
      { expected = true , args = { false } },
      { expected = true , args = { nil   } },
      { expected = false, args = { 0     } },
      { expected = false, args = { ""    } },
      { expected = false, args = { 123   } },
      { expected = false, args = { "abc" } },
      { expected = false, args = { true  } },
    },
    Integer = {
      { expected = true , args = { 123   } },
      { expected = false, args = { 13.4  } },
      { expected = false, args = { "123" } },
      { expected = false, args = { nil   } },
    },
    Finite = {
      { expected = true , args = { 123        } },
      { expected = true , args = { -1.5       } },
      { expected = false, args = { math.huge  } },
      { expected = false, args = { -math.huge } },
      { expected = false, args = { 0/0        } },
      { expected = false, args = { "abc"      } },
      { expected = false, args = { nil        } },
    },
    Float = {
      { expected = true , args = { 1.5 } },
      { expected = mods.runtime.version >= 503, args = { 2.0 } },
      { expected = false, args = { math.huge } },
      { expected = false, args = { -math.huge } },
      { expected = false, args = { 0/0       } },
      { expected = false, args = { 1   } },
      { expected = false, args = { "abc" } },
      { expected = false, args = { nil } },
    },
    Infinite = {
      { expected = true , args = { math.huge  } },
      { expected = true , args = { -math.huge } },
      { expected = false, args = { 123        } },
      { expected = false, args = { 0/0        } },
      { expected = false, args = { "abc"      } },
      { expected = false, args = { nil        } },
    },
    Nan = {
      { expected = true , args = { 0/0   } },
      { expected = false, args = { 123   } },
      { expected = false, args = { "abc" } },
      { expected = false, args = { nil   } },
    },
    Truthy = {
      { expected = true , args = { 123   } },
      { expected = true , args = { "abc" } },
      { expected = true , args = { true  } },
      { expected = false, args = { false } },
      { expected = false, args = { nil   } },
    },
    False = {
      { expected = true , args = { false   } },
      { expected = false, args = { nil     } },
      { expected = false, args = { 0       } },
      { expected = false, args = { "false" } },
    },
    True = {
      { expected = true , args = { true   } },
      { expected = false, args = { 1      } },
      { expected = false, args = { "true" } },
      { expected = false, args = { false  } },
    },
    Callable = {
      { expected = true , args = { fn                                  } },
      { expected = true , args = { setmetatable({}, { __call = fn })   } },
      { expected = false, args = { setmetatable({}, { __call = true }) } },
      { expected = false, args = { {}                                  } },
      { expected = false, args = { 123                                 } },
    },
    Dir = {
      { expected = true , args = { "src"       } },
      { expected = false, args = { "README.md" } },
      { expected = false, args = { 123         } },
    },
    File = {
      { expected = true , args = { "README.md"  } },
      { expected = false, args = { "MISSING.md" } },
      { expected = false, args = { "src"        } },
      { expected = false, args = { false        } },
    },
    Path = {
      { expected = true , args = { "README.md"  } },
      { expected = false, args = { "MISSING.md" } },
      { expected = false, args = { false        } },
    },
    block_device = { { expected = false, args = { false } } },
    char_device = { { expected = false, args = { false } } },
    Fifo   = { { expected = false, args = { false       } } },
    Socket = { { expected = false, args = { false       } } },
    Device = { { expected = false, args = { false       } } },
    Symlink = { { expected = false, args = { "README.md" } } },
  })

  it("symlink detects symlink paths when supported", function()
    local root = make_tmp_dir()

    local target = path.join(root, "target.txt")
    local link = path.join(root, "link.txt")
    assert.is_true(fs.touch(target))

    local ok = fs.symlink(target, link)
    if ok then
      assert.is_true(is.symlink(link))
    end

    assert.is_true(fs.rm(root, true))
  end)

  if is_unix then
    it("path() returns true for a symlink to an existing file", function()
      local root = make_tmp_dir()

      local target = path.join(root, "target.txt")
      local link = path.join(root, "link.txt")
      assert.is_true(fs.touch(target))
      assert.is_true(fs.symlink(target, link))
      assert.is_true(is.path(link))
      assert.is_true(fs.rm(root, true))
    end)

    it("path() returns true for a broken symlink", function()
      local target = tmpname()
      local link = tmpname()
      assert.is_true(fs.symlink(target, link))
      assert.is_true(is.path(link))
      assert.is_true(fs.rm(link))
    end)
  end
end)
