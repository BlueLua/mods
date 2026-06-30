---@diagnostic disable: need-check-nil

local mods = require "mods"

local runtime = mods.runtime
local is_lua51 = runtime.version == 501
local is_luajit = runtime.is_luajit

local source = debug.getinfo(1, "S").source
local source_file = source:sub(1, 1) == "@" and source:sub(2) or source

describe("mods internal compat", function()
  it("table.pack()", function()
    assert.Same({ "a", [3] = "c", n = 3 }, table.pack("a", nil, "c"))
    assert.Same({ n = 0 }, table.pack())
    assert.Same({ "a", n = 3 }, table.pack("a", nil, nil))
  end)

  it("table.unpack()", function()
    local packed = { "a", [3] = "c", n = 3 }
    assert.Same({ "a", [3] = "c" }, { table.unpack(packed, 1, packed.n) })
    assert.Same({ "a", "b", "c" }, { table.unpack({ "a", "b", "c" }) })
  end)

  it("table.move()", function()
    local move = table.move

    local dst = { "x" }
    assert.Equals(dst, move({ "a", "b", "c" }, 1, 3, 2, dst))
    assert.Same({ "x", "a", "b", "c" }, dst)

    local same = { 1, 2, 3 }
    assert.Equals(same, move(same, 1, 3, 1))
    assert.Same({ 1, 2, 3 }, same)

    local overlap = { 1, 2, 3, 4 }
    assert.Equals(overlap, move(overlap, 1, 3, 2))
    assert.Same({ 1, 1, 2, 3 }, overlap)

    local left = { 1, 2, 3, 4 }
    assert.Equals(left, move(left, 2, 4, 1))
    assert.Same({ 2, 3, 4, 4 }, left)

    local boundary_same = { 1, 2, 3, 4 }
    assert.Equals(boundary_same, move(boundary_same, 2, 4, 2))
    assert.Same({ 1, 2, 3, 4 }, boundary_same)

    local boundary_next = { 1, 2, 3, 4 }
    assert.Equals(boundary_next, move(boundary_next, 1, 3, 4))
    assert.Same({ 1, 2, 3, 1, 2, 3 }, boundary_next)

    local empty = { "x" }
    assert.Equals(empty, move({}, 2, 1, 1, empty))
    assert.Same({ "x" }, empty)

    local sparse = {}
    assert.Equals(sparse, move({ [1] = "a", [3] = "c" }, 1, 3, 1, sparse))
    assert.Same({ "a", [3] = "c" }, sparse)

    local negative = { 1, 2 }
    assert.Equals(negative, move(negative, 1, 2, -1))
    assert.Equals(1, negative[-1])
    assert.Equals(2, negative[0])

    local large = {}
    assert.Equals(large, move({ 1 }, 1, 1, 2147483648, large))
    assert.Equals(1, large[2147483648])

    -- stylua: ignore start
    assert.Error(function() move(false, 1, 1, 1)       end, "bad argument #1 to 'move' (table expected, got boolean)")
    assert.Error(function() move({}, "a", 1, 1)        end, "bad argument #2 to 'move' (number expected, got string)")
    assert.Error(function() move({}, 1.5, 1, 1)        end, "bad argument #2 to 'move' (number has no integer representation)")
    assert.Error(function() move({}, 1, "a", 1)        end, "bad argument #3 to 'move' (number expected, got string)")
    assert.Error(function() move({}, 1, 1.5, 1)        end, "bad argument #3 to 'move' (number has no integer representation)")
    assert.Error(function() move({}, 1, 1, "a")        end, "bad argument #4 to 'move' (number expected, got string)")
    assert.Error(function() move({}, 1, 1, 1.5)        end, "bad argument #4 to 'move' (number has no integer representation)")
    assert.Error(function() move({}, 0 / 0, 1, 1)      end, "bad argument #2 to 'move' (number has no integer representation)")
    assert.Error(function() move({}, math.huge, 1, 1)  end, "bad argument #2 to 'move' (number has no integer representation)")
    assert.Error(function() move({}, 1, math.huge, 1)  end, "bad argument #3 to 'move' (number has no integer representation)")
    assert.Error(function() move({}, 1, 1, -math.huge) end, "bad argument #4 to 'move' (number has no integer representation)")
    assert.Error(function() move({}, 1, 1, 1, false)   end, "bad argument #5 to 'move' (table expected, got boolean)")
  end)

  it("math.type() negative numbers", function()
    assert.Equals("integer", math.type(1))
    assert.Equals("float", math.type(1.5))
    assert.Equals("integer", math.type(-1))
    assert.Equals("float", math.type(-1.5))
    assert.Nil(math.type("1"))
    assert.Nil(math.type(nil))
    assert.Nil(math.type({}))

    -- Lua 5.1/5.2 have no integer/float subtype, so the fallback can only inspect the value.
    assert.Equals(runtime.version < 503 and "integer" or "float", math.type(2.0))
  end)

  it("utf8.char", function()
    assert.Equals("A", utf8.char(0x41))
    assert.Equals("AB", utf8.char(0x41, 0x42))
    assert.Equals("é", utf8.char(0xE9))
    assert.Equals("中", utf8.char(0x4E2D))
    assert.Equals("𝄞", utf8.char(0x1D11E))
    assert.Equals(string.char(0xF8, 0x88, 0x80, 0x80, 0x80), utf8.char(0x200000))
    assert.Equals(string.char(0xFD, 0xBF, 0xBF, 0xBF, 0xBF, 0xBF), utf8.char(0x7FFFFFFF))
    assert.Equals("Aé中𝄞", utf8.char(0x41, 0xE9, 0x4E2D, 0x1D11E))
    assert.Equals("Hello", utf8.char(72, 101, 108, 108, 111))
    assert.Equals("A", utf8.char("65")) ---@diagnostic disable-line: param-type-mismatch

    -- stylua: ignore start
    assert.Error(function() _ = utf8.char(0x80000000) end)
    assert.Error(function() _ = utf8.char(-1)         end)
    assert.Error(function() _ = utf8.char(1.5)        end)
  end)

  describe("xpcall()", function()
    it("passes arguments through to the protected function", function()
      assert.Not.Error(function()
        local results = table.pack(xpcall(function(...)
          return select("#", ...), ...
        end, function(err)
          return err
        end, "a", nil, "c"))

        assert.Equals(5, results.n)
        assert.Equals(true, results[1])
        assert.Equals(3, results[2])
        assert.Equals("a", results[3])
        assert.Nil(results[4])
        assert.Equals("c", results[5])
      end)
    end)

    it("uses the message handler when a call with arguments fails", function()
      assert.Not.Error(function()
        local ok, err = xpcall(function(prefix, message)
          error(prefix .. message, 0)
        end, function(err)
          return "handled: " .. err
        end, "boom: ", "bad")

        assert.False(ok)
        assert.Equals("handled: boom: bad", err)
      end)
    end)
  end)

  describe("load()", function()
    it("compiles string chunks with env", function()
      assert.Not.Error(function()
        local fn = load("return v", "compat_chunk", "t", { v = 7 })
        assert.Equals(7, fn())
      end)
    end)

    it("defaults mode to 'bt'", function()
      assert.Not.Error(function()
        assert.Equals(2, load("return 2")())
      end)
    end)

    it("allows binary chunks with the default mode", function()
      assert.Not.Error(function()
        local fn = load(
          string.dump(function()
            return v ---@diagnostic disable-line: undefined-global
          end),
          "compat_binary",
          nil,
          { v = 8 }
        )
        assert.Equals(8, fn())
      end)
    end)

    it("accepts text chunks in mode 'bt'", function()
      assert.Not.Error(function()
        local fn = load("return 3", "compat_chunk", "bt")
        assert.Equals(3, fn())
      end)
    end)

    it("accepts text chunks in mode 'tb'", function()
      assert.Not.Error(function()
        local fn = load("return 3", "compat_chunk", "tb")
        assert.Equals(3, fn())
      end)
    end)

    it("accepts binary chunks in mode 'tb'", function()
      assert.Not.Error(function()
        local fn = load(
          string.dump(function()
            return v ---@diagnostic disable-line: undefined-global
          end),
          "compat_binary",
          "tb",
          { v = 4 }
        )
        assert.Equals(4, fn())
      end)
    end)

    it("compiles reader chunks with env", function()
      assert.Not.Error(function()
        local chunks = { "return ", "v" }
        local i = 0
        local fn = load(function()
          i = i + 1
          return chunks[i]
        end, "compat_reader", "t", { v = 9 })
        assert.Equals(9, fn())
      end)
    end)

    it("accepts reader chunks in mode 'bt'", function()
      assert.Not.Error(function()
        local chunks = { "return ", "4" }
        local i = 0
        local fn = load(function()
          i = i + 1
          return chunks[i]
        end, "compat_reader", "bt")
        assert.Equals(4, fn())
      end)
    end)

    it("stops reading when a reader returns an empty string", function()
      assert.Not.Error(function()
        local chunks = { "return 1", "", " + 2" }
        local i = 0
        local fn = load(function()
          i = i + 1
          return chunks[i]
        end, "compat_reader", "t")
        assert.Equals(1, fn())
      end)
    end)

    it("accepts binary chunks in mode 'b'", function()
      assert.Not.Error(function()
        local fn = load(
          string.dump(function()
            return 5
          end),
          "compat_binary",
          "b"
        )
        assert.Equals(5, fn())
      end)
    end)

    it("accepts binary reader chunks in mode 'b'", function()
      assert.Not.Error(function()
        local binary = string.dump(function()
          return 6
        end)
        local chunks = { binary:sub(1, 8), binary:sub(9) }
        local i = 0
        local fn = load(function()
          i = i + 1
          return chunks[i]
        end, "compat_reader_binary", "b")
        assert.Equals(6, fn())
      end)
    end)

    it("returns nil and an error for invalid chunks", function()
      assert.Not.Error(function()
        local fn, err = load("return )", "bad_chunk", "t")
        assert.Nil(fn)
        assert.Equals([[[string "bad_chunk"]:1: unexpected symbol near ')']], err)
      end)
    end)

    it("uses '(load)' for unnamed reader chunk errors", function()
      assert.Not.Error(function()
        local done = false
        local fn, err = load(function()
          if done then
            return nil
          end
          done = true
          return "return )"
        end, nil, "t")
        assert.Nil(fn)
        assert.Equals(
          is_lua51 and not is_luajit and [[[string "(load)"]:1: unexpected symbol near ')']]
            or "(load):1: unexpected symbol near ')'",
          err
        )
      end)
    end)

    it("rejects non-string reader values", function()
      assert.Not.Error(function()
        -- stylua: ignore start
        local line = debug.getinfo(1, "l").currentline + 1
        local fn, err = load(function() return true end, "bad_reader", "t")
        -- stylua: ignore end
        assert.Nil(fn)
        assert.Equals(
          is_lua51 and not is_luajit and "reader function must return a string"
            or ("%s:%d: reader function must return a string"):format(source_file, line),
          err
        )
      end)
    end)

    it("coerces numeric modes before checking flags", function()
      assert.Not.Error(function()
        local fn, err = load("return 1", "compat_chunk", 1)
        assert.Nil(fn)
        assert.Equals(
          is_luajit and "attempt to load chunk with wrong mode" or "attempt to load a text chunk (mode is '1')",
          err
        )
      end)
    end)

    it("coerces numeric chunks before compiling", function()
      assert.Not.Error(function()
        local fn, err = load(123, "compat_chunk", "t")
        assert.Nil(fn)
        assert.Equals([[[string "compat_chunk"]:1: unexpected symbol near '123']], err)
      end)
    end)

    it("raises for bad chunk types", function()
      assert.Error(function()
        load({}, "bad_chunk", "t")
      end, "bad argument #1 to 'load' (function expected, got table)")
    end)

    it("raises for bad mode types", function()
      assert.Error(function()
        load("return 1", "bad_mode", {})
      end, "bad argument #3 to 'load' (string expected, got table)")
    end)

    it("rejects text chunks in mode 'b'", function()
      assert.Not.Error(function()
        local fn, err = load("return 1", "bad_mode", "b")
        assert.Nil(fn)
        assert.Equals(
          is_luajit and "attempt to load chunk with wrong mode" or "attempt to load a text chunk (mode is 'b')",
          err
        )
      end)
    end)

    it("rejects reader text chunks in mode 'b'", function()
      assert.Not.Error(function()
        local chunks = { "return ", "1" }
        local i = 0
        local fn, err = load(function()
          i = i + 1
          return chunks[i]
        end, "bad_reader_mode", "b")
        assert.Nil(fn)
        assert.Equals(
          is_luajit and "attempt to load chunk with wrong mode" or "attempt to load a text chunk (mode is 'b')",
          err
        )
      end)
    end)

    it("rejects binary chunks in mode 't'", function()
      assert.Not.Error(function()
        local fn, err = load(
          string.dump(function()
            return 1
          end),
          "bad_binary_mode",
          "t"
        )
        assert.Nil(fn)
        assert.Equals(
          is_luajit and "attempt to load chunk with wrong mode" or "attempt to load a binary chunk (mode is 't')",
          err
        )
      end)
    end)

    it("rejects invalid modes", function()
      assert.Not.Error(function()
        local fn, err = load("return 1", "bad_mode", "x")
        assert.Nil(fn)
        assert.Equals(
          is_luajit and "attempt to load chunk with wrong mode" or "attempt to load a text chunk (mode is 'x')",
          err
        )
      end)
    end)

    it("returns nil when the reader raises", function()
      assert.Not.Error(function()
        -- stylua: ignore start
        local line = debug.getinfo(1, "l").currentline + 1
        local fn, err = load(function() error("boom") end, "bad_reader", "t")
        -- stylua: ignore end
        assert.Nil(fn)
        assert.Equals(("%s:%d: boom"):format(source_file, line), err)
      end)
    end)
  end)

  describe("loadfile()", function()
    local function with_chunk_file(chunk, fn)
      local path = os.tmpname()
      local fh = assert(io.open(path, "wb"))
      fh:write(chunk)
      fh:close()

      local results = table.pack(pcall(fn, path))
      os.remove(path)
      if not results[1] then
        error(results[2], 0)
      end
      return table.unpack(results, 2, results.n)
    end

    it("loads file chunks with the default mode", function()
      assert.Not.Error(function()
        with_chunk_file("return 10", function(path)
          local fn = loadfile(path)
          assert.Equals(10, fn())
        end)
      end)
    end)

    it("applies env to file chunks", function()
      assert.Not.Error(function()
        with_chunk_file("return v", function(path)
          local fn = loadfile(path, nil, { v = 11 })
          assert.Equals(11, fn())
        end)
      end)
    end)

    it("accepts text chunks in mode 't'", function()
      assert.Not.Error(function()
        with_chunk_file("return 12", function(path)
          local fn = loadfile(path, "t")
          assert.Equals(12, fn())
        end)
      end)
    end)

    it("accepts binary chunks in mode 'b'", function()
      assert.Not.Error(function()
        with_chunk_file(
          string.dump(function()
            return 13
          end),
          function(path)
            local fn = loadfile(path, "b")
            assert.Equals(13, fn())
          end
        )
      end)
    end)

    it("rejects text chunks in mode 'b'", function()
      assert.Not.Error(function()
        with_chunk_file("return 1", function(path)
          local fn, err = loadfile(path, "b")
          assert.Nil(fn)
          assert.Not.Nil(err)
        end)
      end)
    end)

    it("rejects binary chunks in mode 't'", function()
      assert.Not.Error(function()
        with_chunk_file(
          string.dump(function()
            return 1
          end),
          function(path)
            local fn, err = loadfile(path, "t")
            assert.Nil(fn)
            assert.Not.Nil(err)
          end
        )
      end)
    end)

    it("returns nil and an error for invalid file chunks", function()
      assert.Not.Error(function()
        with_chunk_file("return )", function(path)
          local fn, err = loadfile(path, "t")
          assert.Nil(fn)
          assert.Not.Nil(err)
          assert.Not.Nil(err:find(path, 1, true))
        end)
      end)
    end)

    it("returns nil and an error for missing files", function()
      assert.Not.Error(function()
        local fn, err = loadfile("mods-compat-missing-file.lua")
        assert.Nil(fn)
        assert.Not.Nil(err)
      end)
    end)

    it("raises for bad filename types", function()
      assert.Error(function()
        loadfile({})
      end)
    end)

    it("raises for bad mode types", function()
      assert.Error(function()
        loadfile("mods-compat-missing-file.lua", {})
      end)
    end)
  end)
end)
