local helpers = require "tests.helpers"
local lfs = require "lfs"
local mods = require "mods"

local List = mods.list
local fs = mods.fs
local path = mods.path

local isdir = mods.is.dir
local make_tmp_dir = helpers.make_tmp_dir
local tmpname = helpers.tmpname
local join = path.join
local dirname = path.dirname

local fmt = string.format

describe("mods.fs", function()
  local is_unix = not mods.runtime.is_windows
  local cwd = path.cwd() --[[@as string]]
  local readme_file = join(cwd, "README.md")
  local spec_file = join(cwd, "tests", "_types.lua")

  after_each(function()
    fs.cd(cwd)
  end)

  for _, fname in ipairs({ "getsize", "getatime", "getmtime", "getctime" }) do
    it(fmt("%s() returns a number for an existing path", fname), function()
      assert.is_number(fs[fname](readme_file))
    end)

    it(fmt("%s() returns nil and an error for a missing path", fname), function()
      local value, errmsg, errcode = fs[fname]("__mods_missing_path__")
      assert.are_same({ "nil", "string", "number" }, { type(value), type(errmsg), type(errcode) })
    end)
  end

  describe("stat()", function()
    it("delegates to lfs.attributes", function()
      assert.are_equal(lfs.attributes, fs.stat)
    end)

    it("returns nil and an error for a missing path", function()
      local attrs, errmsg, errcode = fs.stat("__mods_missing_path__")
      assert.are_same({ "nil", "string", "number" }, { type(attrs), type(errmsg), type(errcode) })
    end)
  end)

  describe("lstat()", function()
    it("delegates to lfs.symlinkattributes", function()
      assert.are_equal(lfs.symlinkattributes, fs.lstat)
    end)

    it("returns nil and an error for a missing path", function()
      local attrs, errmsg, errcode = fs.lstat("__mods_missing_path__")
      assert.are_same({ "nil", "string", "number" }, { type(attrs), type(errmsg), type(errcode) })
    end)
  end)

  describe("rename()", function()
    it("delegates to os.rename", function()
      assert.are_equal(os.rename, fs.rename)
    end)

    it("renames a file", function()
      local from = tmpname()
      local to = tmpname()
      assert.is_true(fs.write_text(from, "abc"))
      assert.is_true(fs.rename(from, to))
      assert.is_false(fs.exists(from))
      assert.are_equal("abc", fs.read_text(to))
      assert.is_true(fs.rm(to))
    end)

    it("fails with an error for a missing path", function()
      local ok, errmsg, errcode = fs.rename("__mods_missing_path__", tmpname())
      assert.are_same({ "nil", "string", "number" }, { type(ok), type(errmsg), type(errcode) })
    end)
  end)

  describe("cd()", function()
    it("delegates to lfs.chdir", function()
      assert.are_equal(lfs.chdir, fs.cd)
    end)

    it("changes the current working directory", function()
      local root = make_tmp_dir()
      local canonical_root = root
      local tmp = lfs.currentdir()
      if tmp and lfs.chdir(root) then
        canonical_root = lfs.currentdir()
        lfs.chdir(tmp)
      end

      assert.is_true(fs.cd(root))
      assert.are_equal(canonical_root, path.cwd())
      assert.is_true(fs.cd(cwd))
      assert.is_true(fs.rm(root, true))
    end)

    it("fails with an error for a missing path", function()
      local root = make_tmp_dir()
      local missing = join(root, "missing")
      local ok, errmsg = fs.cd(missing)

      assert.is_nil(ok)
      assert.is_string(errmsg)
      assert.are_equal(cwd, path.cwd())
      assert.is_true(fs.rm(root, true))
    end)
  end)

  describe("cwd()", function()
    it("delegates to lfs.currentdir", function()
      assert.are_equal(lfs.currentdir, fs.cwd)
    end)

    it("returns the current working directory", function()
      assert.are_equal(cwd, fs.cwd())
    end)

    it("fails when the current directory no longer exists", function()
      local root = make_tmp_dir()
      assert.is_true(fs.cd(root))
      assert.is_true(fs.rm(root, true))

      local dir, errmsg, errcode = fs.cwd()
      assert.is_true(fs.cd(cwd))
      assert.are_same({ "nil", "string", "number" }, { type(dir), type(errmsg), type(errcode) })
    end)
  end)

  describe("write_bytes()", function()
    it("writes file contents", function()
      local target = tmpname()
      assert.is_true(fs.write_bytes(target, "abc"))
      assert.are_equal("abc", fs.read_bytes(target))
      assert.is_true(fs.rm(target))
    end)

    it("fails with an error when the parent directory does not exist", function()
      local target = join(tmpname(), "missing", "file.bin")
      local ok, errmsg, errcode = fs.write_bytes(target, "abc")
      assert.are_same({ "nil", "string", "number" }, { type(ok), type(errmsg), type(errcode) })
    end)
  end)

  describe("write_text()", function()
    it("writes file contents", function()
      local target = tmpname()
      assert.is_true(fs.write_text(target, "abc"))
      assert.are_equal("abc", fs.read_text(target))
      assert.is_true(fs.rm(target))
    end)

    it("fails with an error when the parent directory does not exist", function()
      local target = join(tmpname(), "missing", "file.txt")
      local ok, errmsg, errcode = fs.write_text(target, "abc")
      assert.are_same({ "nil", "string", "number" }, { type(ok), type(errmsg), type(errcode) })
    end)
  end)

  describe("read_bytes()", function()
    it("reads file contents", function()
      local target = tmpname()
      assert.is_true(fs.write_bytes(target, "abc"))
      assert.are_equal("abc", fs.read_bytes(target))
      assert.is_true(fs.rm(target))
    end)

    it("fails with an error for a missing path", function()
      local body, errmsg, errcode = fs.read_bytes("__mods_missing_path__")
      assert.are_same({ "nil", "string", "number" }, { type(body), type(errmsg), type(errcode) })
    end)
  end)

  describe("read_text()", function()
    it("reads file contents", function()
      local target = tmpname()
      assert.is_true(fs.write_text(target, "abc"))
      assert.are_equal("abc", fs.read_text(target))
      assert.is_true(fs.rm(target))
    end)

    it("fails with an error for a missing path", function()
      local body, errmsg, errcode = fs.read_text("__mods_missing_path__")
      assert.are_same({ "nil", "string", "number" }, { type(body), type(errmsg), type(errcode) })
    end)
  end)

  describe("touch()", function()
    it("creates a missing file", function()
      local target = tmpname()
      assert.is_true(fs.touch(target))
      assert.are_equal("", fs.read_bytes(target))
      assert.is_true(fs.rm(target))
    end)

    it("does not truncate an existing file", function()
      local target = tmpname()
      assert.is_true(fs.write_bytes(target, "abc"))
      assert.is_true(fs.touch(target))
      assert.are_equal("abc", fs.read_bytes(target))
      assert.is_true(fs.rm(target))
    end)

    it("updates timestamps for an existing file", function()
      local target = tmpname()
      assert.is_true(fs.write_bytes(target, "abc"))
      assert.is_true(lfs.touch(target, 1, 1))
      assert.is_true(fs.touch(target))
      assert.is_true(fs.getmtime(target) > 1)
      assert.is_true(fs.rm(target))
    end)

    it("fails when the parent directory does not exist", function()
      local root = tmpname()
      local target = join(root, "missing", "file.txt")
      local ok, errmsg, errcode = fs.touch(target)
      assert.is_nil(ok)
      assert.is_string(errmsg)
      assert.is_number(errcode)
    end)

    if is_unix then
      it("updates an existing file through a symlink", function()
        local target, link = tmpname(), tmpname()
        assert.is_true(fs.write_bytes(target, "abc"))
        assert.is_true(fs.symlink(target, link))
        assert.is_true(lfs.touch(target, 1, 1))
        assert.is_true(fs.touch(link))
        assert.is_true(fs.getmtime(target) > 1)
        assert.are_equal("abc", fs.read_bytes(target))
        assert.is_true(fs.rm(link))
        assert.is_true(fs.rm(target))
      end)

      it("heals a broken symlink by creating its target", function()
        local target, link = tmpname(), tmpname()
        assert.is_true(fs.symlink(target, link))
        assert.is_true(fs.touch(link))
        assert.is_true(fs.exists(link))
        assert.is_true(fs.exists(target))
        assert.is_true(fs.rm(link))
        assert.is_true(fs.rm(target))
      end)
    end
  end)

  if is_unix then
    describe("link()", function()
      it("creates a hard link", function()
        local root = make_tmp_dir()
        local target = join(root, "target.txt")
        local link = join(root, "hardlink.txt")

        assert.is_true(fs.write_text(target, "abc"))
        assert.is_true(fs.link(target, link))
        assert.are_equal("abc", fs.read_text(link))
        assert.is_true(fs.samefile(target, link))
        assert.is_true(fs.rm(root, true))
      end)

      it("fails with an error for a missing target", function()
        local root = make_tmp_dir()
        local target = join(root, "missing.txt")
        local link = join(root, "link.txt")
        local ok, errmsg, errcode = fs.link(target, link)

        assert.are_same({ "nil", "string", "number" }, { type(ok), type(errmsg), type(errcode) })
        assert.is_true(fs.rm(root, true))
      end)
    end)

    describe("symlink()", function()
      it("creates a symbolic link", function()
        local root = make_tmp_dir()
        local target = join(root, "target.txt")
        local link = join(root, "symlink.txt")

        assert.is_true(fs.write_text(target, "abc"))
        assert.is_true(fs.symlink(target, link))
        assert.are_equal("abc", fs.read_text(link))
        assert.is_true(fs.lexists(link))
        assert.is_true(fs.samefile(target, link))
        assert.is_true(fs.rm(root, true))
      end)

      it("creates a broken symbolic link when the target is missing", function()
        local root = make_tmp_dir()
        local target = join(root, "missing.txt")
        local link = join(root, "link.txt")
        assert.is_true(fs.symlink(target, link))
        assert.is_true(fs.lexists(link))
        assert.is_false(fs.exists(link))
        assert.is_true(fs.rm(root, true))
      end)
    end)
  end

  describe("listdir()", function()
    it("returns an empty list for an empty directory", function()
      local root = make_tmp_dir()
      assert.is_true(fs.listdir(root):isempty())
      assert.is_true(fs.rm(root, true))
    end)

    it("lists direct children by default", function()
      local root = make_tmp_dir()
      local subdir = join(root, "sub")
      local hidden_dir = join(root, ".hidden")
      local target = join(root, "data.txt")
      local hidden_target = join(root, ".secret")
      local nested = join(subdir, "nested.txt")
      local hidden_nested = join(hidden_dir, "nested.txt")

      assert.is_true(fs.mkdir(subdir))
      assert.is_true(fs.mkdir(hidden_dir))
      assert.is_true(fs.write_text(target, "abc"))
      assert.is_true(fs.write_text(hidden_target, "zzz"))
      assert.is_true(fs.write_text(nested, "xyz"))
      assert.is_true(fs.write_text(hidden_nested, "qqq"))

      assert.same({ hidden_dir, hidden_target, target, subdir }, fs.listdir(root):sort())

      assert.is_true(fs.rm(root, true))
    end)

    it("can return basenames instead of full paths", function()
      local root = make_tmp_dir()
      local subdir = join(root, "sub")
      local hidden_dir = join(root, ".hidden")
      local target = join(root, "data.txt")
      local hidden_target = join(root, ".secret")

      assert.is_true(fs.mkdir(subdir))
      assert.is_true(fs.mkdir(hidden_dir))
      assert.is_true(fs.write_text(target, "abc"))
      assert.is_true(fs.write_text(hidden_target, "zzz"))

      assert.same({ ".hidden", ".secret", "data.txt", "sub" }, fs.listdir(root, { names = true }):sort())

      assert.is_true(fs.rm(root, true))
    end)

    it("supports recursive listing", function()
      local root = make_tmp_dir()
      local subdir = join(root, "sub")
      local hidden_dir = join(root, ".hidden")
      local target = join(root, "data.txt")
      local hidden_target = join(root, ".secret")
      local nested = join(subdir, "nested.txt")
      local hidden_nested = join(hidden_dir, "nested.txt")

      assert.is_true(fs.mkdir(subdir))
      assert.is_true(fs.mkdir(hidden_dir))
      assert.is_true(fs.write_text(target, "abc"))
      assert.is_true(fs.write_text(hidden_target, "zzz"))
      assert.is_true(fs.write_text(nested, "xyz"))
      assert.is_true(fs.write_text(hidden_nested, "qqq"))

      assert.same(
        { hidden_dir, hidden_nested, hidden_target, target, subdir, nested },
        fs.listdir(root, { recursive = true }):sort()
      )

      assert.is_true(fs.rm(root, true))
    end)

    it("supports hidden filtering", function()
      local root = make_tmp_dir()
      local subdir = join(root, "sub")
      local hidden_dir = join(root, ".hidden")
      local target = join(root, "data.txt")
      local hidden_target = join(root, ".secret")
      local nested = join(subdir, "nested.txt")
      local hidden_nested = join(hidden_dir, "nested.txt")

      assert.is_true(fs.mkdir(subdir))
      assert.is_true(fs.mkdir(hidden_dir))
      assert.is_true(fs.write_text(target, "abc"))
      assert.is_true(fs.write_text(hidden_target, "zzz"))
      assert.is_true(fs.write_text(nested, "xyz"))
      assert.is_true(fs.write_text(hidden_nested, "qqq"))

      assert.same({ target, subdir }, fs.listdir(root, { hidden = false }):sort())
      assert.same({ target, subdir, nested }, fs.listdir(root, { hidden = false, recursive = true }):sort())

      assert.is_true(fs.rm(root, true))
    end)

    it("supports file type filtering", function()
      local root = make_tmp_dir()
      local subdir = join(root, "sub")
      local hidden_dir = join(root, ".hidden")
      local target = join(root, "data.txt")
      local hidden_target = join(root, ".secret")
      local nested = join(subdir, "nested.txt")
      local hidden_nested = join(hidden_dir, "nested.txt")

      assert.is_true(fs.mkdir(subdir))
      assert.is_true(fs.mkdir(hidden_dir))
      assert.is_true(fs.write_text(target, "abc"))
      assert.is_true(fs.write_text(hidden_target, "zzz"))
      assert.is_true(fs.write_text(nested, "xyz"))
      assert.is_true(fs.write_text(hidden_nested, "qqq"))

      assert.same({ hidden_target, target }, fs.listdir(root, { type = "file" }):sort())

      assert.is_true(fs.rm(root, true))
    end)

    it("supports directory type filtering", function()
      local root = make_tmp_dir()
      local subdir = join(root, "sub")
      local hidden_dir = join(root, ".hidden")
      local target = join(root, "data.txt")
      local hidden_target = join(root, ".secret")
      local nested = join(subdir, "nested.txt")
      local hidden_nested = join(hidden_dir, "nested.txt")

      assert.is_true(fs.mkdir(subdir))
      assert.is_true(fs.mkdir(hidden_dir))
      assert.is_true(fs.write_text(target, "abc"))
      assert.is_true(fs.write_text(hidden_target, "zzz"))
      assert.is_true(fs.write_text(nested, "xyz"))
      assert.is_true(fs.write_text(hidden_nested, "qqq"))

      assert.same({ hidden_dir, subdir }, fs.listdir(root, { type = "directory" }):sort())

      assert.is_true(fs.rm(root, true))
    end)

    it("fails for a non-directory path", function()
      local root = make_tmp_dir()
      local target = join(root, "data.txt")

      assert.is_true(fs.write_text(target, "abc"))

      local items, errmsg = fs.listdir(target)
      assert.is_nil(items)
      assert.is_string(errmsg)

      assert.is_true(fs.rm(root, true))
    end)

    it("fails for a missing path", function()
      local root = make_tmp_dir()
      local missing = join(root, "missing")

      local items, errmsg = fs.listdir(missing)
      assert.is_nil(items)
      assert.is_string(errmsg)

      assert.is_true(fs.rm(root, true))
    end)

    if is_unix then
      it("follows symlinked directories when requested", function()
        local root = make_tmp_dir()
        local target_dir = join(root, "target")
        local nested = join(target_dir, "nested.txt")
        local link_dir = join(root, "linked")

        assert.is_true(fs.mkdir(target_dir, true))
        assert.is_true(fs.touch(nested))

        local ok = fs.symlink(target_dir, link_dir)
        if not ok then
          assert.is_true(fs.rm(root, true))
          return
        end

        assert.same({ target_dir }, fs.listdir(root, { type = "directory" }):sort())
        assert.same({ link_dir }, fs.listdir(root, { type = "link" }):sort())
        assert.same(
          { link_dir, join(link_dir, "nested.txt"), target_dir, nested },
          fs.listdir(root, {
            recursive = true,
            follow = true,
          }):sort()
        )

        assert.is_true(fs.rm(root, true))
      end)

      it("includes broken symlinks and does not traverse them", function()
        local root = make_tmp_dir()
        local target = join(root, "missing")
        local link = join(root, "broken")

        assert.is_true(fs.symlink(target, link))

        assert.same({ link }, fs.listdir(root))
        assert.same({ link }, fs.listdir(root, { recursive = true }))
        assert.same({ link }, fs.listdir(root, { type = "link" }))

        assert.is_true(fs.rm(root, true))
      end)
    end

    it("labels option validation errors with the function name", function()
      assert.has_error(function()
        ---@diagnostic disable-next-line: assign-type-mismatch
        _ = fs.listdir(cwd, { recursive = "yes" })
      end, "listdir.opts.recursive: boolean expected, got string")
    end)
  end)

  describe("dir()", function()
    it("yields no items for an empty directory", function()
      local root = make_tmp_dir()
      local ls = List()

      for name, tp in fs.dir(root) do
        ls:append(name .. ":" .. tp)
      end

      assert.is_true(ls:isempty())
      assert.is_true(fs.rm(root, true))
    end)

    it("yields direct child names and types", function()
      local root = make_tmp_dir()
      local subdir = join(root, "sub")
      local nested_dir = join(subdir, "deep")
      local target = join(root, "data.txt")
      local nested = join(nested_dir, "nested.txt")
      local ls = List()

      assert.is_true(fs.mkdir(nested_dir, true))
      assert.is_true(fs.write_text(target, "abc"))
      assert.is_true(fs.write_text(nested, "xyz"))

      for name, tp in fs.dir(root) do
        ls:append(name .. ":" .. tp)
      end

      assert.same({ "data.txt:file", "sub:directory" }, ls:sort())
      assert.is_true(fs.rm(root, true))
    end)

    it("supports hidden filtering", function()
      local root = make_tmp_dir()
      local subdir = join(root, "sub")
      local hidden_dir = join(root, ".hidden")
      local nested = join(subdir, "nested.txt")
      local hidden_nested = join(hidden_dir, "nested.txt")
      local ls = List()

      assert.is_true(fs.mkdir(subdir))
      assert.is_true(fs.mkdir(hidden_dir))
      assert.is_true(fs.write_text(join(root, "data.txt"), "abc"))
      assert.is_true(fs.write_text(join(root, ".secret"), "zzz"))
      assert.is_true(fs.write_text(nested, "xyz"))
      assert.is_true(fs.write_text(hidden_nested, "qqq"))

      local opts = { hidden = false, recursive = true }
      for name, tp in fs.dir(root, opts) do
        ls:append(name .. ":" .. tp)
      end

      assert.same({ "data.txt:file", "nested.txt:file", "sub:directory" }, ls:sort())
      assert.is_true(fs.rm(root, true))
    end)

    it("supports file type filtering", function()
      local root = make_tmp_dir()
      local subdir = join(root, "sub")
      local nested_dir = join(subdir, "deep")
      local target = join(root, "data.txt")
      local nested = join(nested_dir, "nested.txt")
      local files = List()

      assert.is_true(fs.mkdir(nested_dir, true))
      assert.is_true(fs.write_text(target, "abc"))
      assert.is_true(fs.write_text(nested, "xyz"))

      local opts = { recursive = true, type = "file" }
      for name, tp in fs.dir(root, opts) do
        files:append(name .. ":" .. tp)
      end

      assert.same({ "data.txt:file", "nested.txt:file" }, files:sort())
      assert.is_true(fs.rm(root, true))
    end)

    it("supports directory type filtering", function()
      local root = make_tmp_dir()
      local subdir = join(root, "sub")
      local nested_dir = join(subdir, "deep")
      local target = join(root, "data.txt")
      local nested = join(nested_dir, "nested.txt")
      local dirs = List()

      assert.is_true(fs.mkdir(nested_dir, true))
      assert.is_true(fs.write_text(target, "abc"))
      assert.is_true(fs.write_text(nested, "xyz"))

      local opts = { recursive = true, type = "directory" }
      for name, tp in fs.dir(root, opts) do
        dirs:append(name .. ":" .. tp)
      end

      assert.same({ "deep:directory", "sub:directory" }, dirs:sort())
      assert.is_true(fs.rm(root, true))
    end)

    it("fails for a missing path", function()
      local root = make_tmp_dir()
      local missing = join(root, "missing")

      local iter, errmsg = fs.dir(missing)
      assert.is_nil(iter)
      assert.is_string(errmsg)
      assert.is_true(fs.rm(root, true))
    end)

    it("fails for a non-directory path", function()
      local root = make_tmp_dir()
      local target = join(root, "data.txt")

      assert.is_true(fs.write_text(target, "abc"))

      local iter, errmsg = fs.dir(target)
      assert.is_nil(iter)
      assert.is_string(errmsg)
      assert.is_true(fs.rm(root, true))
    end)

    if is_unix then
      it("supports link type filtering", function()
        local root = make_tmp_dir()
        local target = join(root, "target.txt")
        local link = join(root, "linked.txt")
        local links = List()

        assert.is_true(fs.touch(target))

        local ok = fs.symlink(target, link)
        if not ok then
          assert.is_true(fs.rm(root, true))
          return
        end

        local opts = { type = "link" }
        for name, tp in fs.dir(root, opts) do
          links:append(name .. ":" .. tp)
        end

        assert.same({ "linked.txt:link" }, links)
        assert.is_true(fs.rm(root, true))
      end)

      it("follows symlinked directories when requested", function()
        local root = make_tmp_dir()
        local target_dir = join(root, "target")
        local nested = join(target_dir, "nested.txt")
        local link_dir = join(root, "linked")
        local ls = List()

        assert.is_true(fs.mkdir(target_dir, true))
        assert.is_true(fs.touch(nested))

        local ok = fs.symlink(target_dir, link_dir)
        if not ok then
          assert.is_true(fs.rm(root, true))
          return
        end

        local opts = { recursive = true, follow = true }
        for name, tp in fs.dir(root, opts) do
          ls:append(name .. ":" .. tp)
        end

        local function contains(xs, value)
          for i = 1, #xs do
            if xs[i] == value then
              return true
            end
          end
          return false
        end

        assert.is_true(#ls >= 3)
        assert.is_true(contains(ls, "linked:link"))
        assert.is_true(contains(ls, "nested.txt:file"))
        assert.is_true(fs.rm(root, true))
      end)

      it("includes broken symlinks and does not traverse them", function()
        local root = make_tmp_dir()
        local target = join(root, "missing")
        local link = join(root, "broken")
        local ls = List()

        assert.is_true(fs.symlink(target, link))

        local opts = { recursive = true }
        for name, tp in fs.dir(root, opts) do
          ls:append(name .. ":" .. tp)
        end

        assert.same({ "broken:link" }, ls)
        assert.is_true(fs.rm(root, true))
      end)
    end

    it("labels option validation errors with the function name", function()
      assert.has_error(function()
        ---@diagnostic disable-next-line: assign-type-mismatch
        _ = fs.dir(cwd, { recursive = "yes" })
      end, "dir.opts.recursive: boolean expected, got string")
    end)
  end)

  describe("mkdir()", function()
    it("creates a directory without parent mode", function()
      local root = make_tmp_dir()
      local target = join(root, "single")

      assert.is_true(fs.mkdir(target))
      assert.is_true(fs.exists(target))
      assert.is_true(isdir(target))
      assert.is_true(fs.rm(root, true))
    end)

    it("creates missing parent directories when parent mode is enabled", function()
      local root = make_tmp_dir()
      local target = join(root, "deep", "child")

      assert.is_true(fs.mkdir(target, true))
      assert.is_true(fs.exists(dirname(target)))
      assert.is_true(fs.exists(target))
      assert.is_true(isdir(target))
      assert.is_true(fs.rm(root, true))
    end)

    it("succeeds when the target directory already exists", function()
      local root = make_tmp_dir()
      assert.is_true(fs.mkdir(root, true))
      assert.is_true(fs.exists(root))
      assert.is_true(isdir(root))
      assert.is_true(fs.rm(root, true))
    end)

    it("normalizes dot segments before creating parent directories", function()
      local root = make_tmp_dir()
      local target = join(root, "alpha", "..", "beta", ".", "child")
      local normalized = join(root, "beta", "child")

      assert.is_true(fs.mkdir(target, true))
      assert.is_false(fs.exists(join(root, "alpha")))
      assert.is_true(fs.exists(normalized))
      assert.is_true(isdir(normalized))
      assert.is_true(fs.rm(root, true))
    end)

    it("fails when parent directories are missing without parent mode", function()
      local target = join(tmpname(), "missing", "child")
      local ok, errmsg, errcode = fs.mkdir(target)
      assert.is_nil(ok)
      assert.is_string(errmsg)
      assert.is_number(errcode)
    end)

    it("fails when a parent path component is a file", function()
      local root = make_tmp_dir()
      local parent_file = join(root, "data.txt")
      local target = join(parent_file, "child")

      assert.is_true(fs.write_text(parent_file, "abc"))

      local ok, errmsg, errcode = fs.mkdir(target, true)
      assert.are_same({ "nil", "string", "number" }, { type(ok), type(errmsg), type(errcode) })
      assert.is_true(fs.rm(root, true))
    end)

    it("fails when the target path already exists as a file", function()
      local root = make_tmp_dir()
      local target = join(root, "data.txt")

      assert.is_true(fs.write_text(target, "abc"))

      local ok, errmsg, errcode = fs.mkdir(target, true)
      assert.are_same({ "nil", "string", "number" }, { type(ok), type(errmsg), type(errcode) })
      assert.is_true(fs.rm(root, true))
    end)
  end)

  describe("cp()", function()
    it("copies binary files", function()
      local root = make_tmp_dir()
      local src = join(root, "src.bin")
      local dst = join(root, "dst.bin")
      local body = "a\0b\1c\255z"

      assert.is_true(fs.write_bytes(src, body))
      assert.is_true(fs.cp(src, dst))
      assert.are_equal(body, fs.read_bytes(dst))

      assert.is_true(fs.rm(root, true))
    end)

    it("copies files", function()
      local root = make_tmp_dir()
      local src = join(root, "src.txt")
      local dst = join(root, "dst.txt")

      assert.is_true(fs.write_text(src, "abc"))
      assert.is_true(fs.cp(src, dst))
      assert.are_equal("abc", fs.read_text(dst))

      assert.is_true(fs.rm(root, true))
    end)

    it("overwrites an existing destination file", function()
      local root = make_tmp_dir()
      local src = join(root, "src.txt")
      local dst = join(root, "dst.txt")

      assert.is_true(fs.write_text(src, "new"))
      assert.is_true(fs.write_text(dst, "old"))

      assert.is_true(fs.cp(src, dst))
      assert.are_equal("new", fs.read_text(dst))

      assert.is_true(fs.rm(root, true))
    end)

    it("copies empty directories", function()
      local root = make_tmp_dir()
      local src = join(root, "src")
      local empty = join(src, "empty")
      local dst = join(root, "copy")

      assert.is_true(fs.mkdir(empty, true))

      assert.is_true(fs.cp(src, dst))
      assert.is_true(isdir(join(dst, "empty")))

      assert.is_true(fs.rm(root, true))
    end)

    it("copies directories recursively", function()
      local root = make_tmp_dir()
      local src = join(root, "src")
      local top_level = join(src, "top.txt")
      local nested_dir = join(src, "deep")
      local nested = join(nested_dir, "nested.txt")
      local dst = join(root, "copy")

      assert.is_true(fs.mkdir(nested_dir, true))
      assert.is_true(fs.write_text(top_level, "abc"))
      assert.is_true(fs.write_text(nested, "xyz"))

      assert.is_true(fs.cp(src, dst))
      assert.are_equal("abc", fs.read_text(join(dst, "top.txt")))
      assert.is_true(fs.exists(join(dst, "deep")))
      assert.are_equal("xyz", fs.read_text(join(dst, "deep", "nested.txt")))

      assert.is_true(fs.rm(root, true))
    end)

    it("merges into an existing destination directory", function()
      local root = make_tmp_dir()
      local src = join(root, "src")
      local nested_dir = join(src, "deep")
      local src_file = join(src, "top.txt")
      local nested = join(nested_dir, "nested.txt")
      local dst = join(root, "copy")
      local keep = join(dst, "keep.txt")

      assert.is_true(fs.mkdir(nested_dir, true))
      assert.is_true(fs.mkdir(dst, true))
      assert.is_true(fs.write_text(src_file, "abc"))
      assert.is_true(fs.write_text(nested, "xyz"))
      assert.is_true(fs.write_text(keep, "keep"))

      assert.is_true(fs.cp(src, dst))
      assert.are_equal("keep", fs.read_text(keep))
      assert.are_equal("abc", fs.read_text(join(dst, "top.txt")))
      assert.are_equal("xyz", fs.read_text(join(dst, "deep", "nested.txt")))

      assert.is_true(fs.rm(root, true))
    end)

    it("fails when the source is missing", function()
      local root = make_tmp_dir()
      local missing = join(root, "missing.txt")
      local dst = join(root, "dst.txt")

      local ok, errmsg, errcode = fs.cp(missing, dst)
      assert.are_same({ "nil", "string", "number" }, { type(ok), type(errmsg), type(errcode) })

      assert.is_true(fs.rm(root, true))
    end)

    it("fails when the destination parent is missing", function()
      local root = make_tmp_dir()
      local src = join(root, "src.txt")
      local dst = join(root, "missing", "dst.txt")

      assert.is_true(fs.write_text(src, "abc"))

      local ok, errmsg, errcode = fs.cp(src, dst)
      assert.are_same({ "nil", "string", "number" }, { type(ok), type(errmsg), type(errcode) })

      assert.is_true(fs.rm(root, true))
    end)

    it("fails when a nested destination path conflicts with a file", function()
      local root = make_tmp_dir()
      local src = join(root, "src")
      local nested_dir = join(src, "deep")
      local nested = join(nested_dir, "nested.txt")
      local dst = join(root, "copy")
      local conflicting = join(dst, "deep")

      assert.is_true(fs.mkdir(nested_dir, true))
      assert.is_true(fs.mkdir(dst, true))
      assert.is_true(fs.write_text(nested, "xyz"))
      assert.is_true(fs.write_text(conflicting, "not a dir"))

      local ok, errmsg, errcode = fs.cp(src, dst)
      assert.are_same({ "nil", "string", "number" }, { type(ok), type(errmsg), type(errcode) })

      assert.is_true(fs.rm(root, true))
    end)

    it("fails when copying a directory onto itself", function()
      local root = make_tmp_dir()
      local src = join(root, "src")
      local nested = join(src, "nested.txt")

      assert.is_true(fs.mkdir(src, true))
      assert.is_true(fs.write_text(nested, "xyz"))

      local ok, errmsg, errcode = fs.cp(src, src)
      local msg = "cannot copy a directory into itself or its descendant"
      assert.are_same({ "nil", msg, "nil" }, { type(ok), errmsg, type(errcode) })

      assert.are_equal("xyz", fs.read_text(nested))
      assert.is_true(fs.rm(root, true))
    end)

    it("fails when copying a directory into its descendant", function()
      local root = make_tmp_dir()
      local src = join(root, "src")
      local nested = join(src, "nested.txt")
      local dst = join(src, "child", "copy")

      assert.is_true(fs.mkdir(src, true))
      assert.is_true(fs.write_text(nested, "xyz"))

      local ok, errmsg, errcode = fs.cp(src, dst)
      local msg = "cannot copy a directory into itself or its descendant"
      assert.are_same({ "nil", msg, "nil" }, { type(ok), errmsg, type(errcode) })

      assert.is_false(fs.exists(dst))
      assert.are_equal("xyz", fs.read_text(nested))
      assert.is_true(fs.rm(root, true))
    end)
  end)

  describe("rm()", function()
    it("removes a file without recursive mode", function()
      local target = tmpname()
      assert.is_true(fs.write_text(target, "abc"))
      assert.is_true(fs.rm(target))
      assert.is_false(fs.exists(target))
    end)

    it("removes an empty directory without recursive mode", function()
      local root = make_tmp_dir()
      assert.is_true(fs.rm(root))
      assert.is_false(fs.exists(root))
    end)

    it("fails with an error for a non-empty directory without recursive mode", function()
      local root = make_tmp_dir()
      local target = join(root, "data.txt")

      assert.is_true(fs.write_text(target, "abc"))

      local ok, err = fs.rm(root)
      assert.is_nil(ok)
      assert.is_string(err)

      assert.is_true(fs.rm(root, true))
    end)

    it("fails with an error for a non-path", function()
      local ok, err = fs.rm("__mods_missing_path__")
      assert.is_nil(ok)
      assert.is_string(err)

      local ok, err = fs.rm("a/b/c", true)
      assert.is_nil(ok)
      assert.is_string(err)
    end)

    it("fails with an error when recursive mode is used with a file path", function()
      local target = tmpname()
      assert.is_true(fs.write_text(target, "abc"))

      local ok, err = fs.rm(target, true)
      assert.is_nil(ok)
      assert.is_string(err)
      assert.is_true(fs.rm(target))
    end)

    it("removes an empty directory tree recursively", function()
      local root = make_tmp_dir()
      assert.is_true(fs.rm(root, true))
      assert.is_false(fs.exists(root))
    end)

    it("removes a directory tree recursively", function()
      local root = make_tmp_dir()
      local subdir = join(root, "sub")
      local deep_dir = join(subdir, "deep")
      local target = join(root, "data.txt")
      local nested = join(deep_dir, "nested.txt")

      assert.is_true(fs.mkdir(deep_dir, true))
      assert.is_true(fs.write_text(target, "abc"))
      assert.is_true(fs.write_text(nested, "abc"))

      assert.is_true(fs.exists(root))
      assert.is_true(fs.exists(target))
      assert.is_true(fs.exists(nested))

      assert.is_true(fs.rm(root, true))

      assert.is_false(fs.exists(root))
      assert.is_false(fs.exists(target))
      assert.is_false(fs.exists(nested))
    end)

    if is_unix then
      it("removes a symlink root without deleting the target directory", function()
        local external = make_tmp_dir()
        local external_file = join(external, "nested.txt")
        local root = make_tmp_dir()
        local link_dir = join(root, "linked")

        assert.is_true(fs.write_text(external_file, "abc"))
        assert.is_true(fs.symlink(external, link_dir))

        assert.is_true(fs.lexists(link_dir))
        assert.is_true(fs.rm(link_dir, true))
        assert.is_false(fs.lexists(link_dir))

        assert.is_true(fs.exists(external))
        assert.are_equal("abc", fs.read_text(external_file))

        assert.is_true(fs.rm(root, true))
        assert.is_true(fs.rm(external, true))
      end)

      it("does not follow symlinked directories during recursive removal", function()
        local root = make_tmp_dir()
        local external = make_tmp_dir()
        local external_file = join(external, "nested.txt")
        local link_dir = join(root, "linked")

        assert.is_true(fs.write_text(external_file, "abc"))

        local ok = fs.symlink(external, link_dir)
        if not ok then
          assert.is_true(fs.rm(root, true))
          assert.is_true(fs.rm(external, true))
          return
        end

        assert.is_true(fs.rm(root, true))
        assert.is_true(fs.exists(external))
        assert.are_equal("abc", fs.read_text(external_file))
        assert.is_true(fs.rm(external, true))
      end)
    end
  end)

  describe("exists()", function()
    assert.is_true(fs.exists(readme_file))
    assert.is_false(fs.exists("__mods_missing_path__"))
    assert.is_true(fs.exists(cwd))

    if is_unix then
      it("returns false for a broken symlink", function()
        local target, link = tmpname(), tmpname()
        assert.is_true(fs.symlink(target, link))
        assert.is_false(fs.exists(link))
        assert.is_true(fs.rm(link))
      end)
    end
  end)

  describe("lexists()", function()
    assert.is_true(fs.lexists(readme_file))
    assert.is_false(fs.lexists("__mods_missing_path__"))
    assert.is_true(fs.lexists(cwd))

    if is_unix then
      it("returns true for a symlink path", function()
        local link = tmpname()
        assert.is_true(fs.symlink(readme_file, link))
        assert.is_true(fs.lexists(link))
        assert.is_true(fs.rm(link))
      end)

      it("returns true for a broken symlink", function()
        local target, link = tmpname(), tmpname()
        assert.is_true(fs.symlink(target, link))
        assert.is_true(fs.lexists(link))
        assert.is_true(fs.rm(link))
      end)
    end
  end)

  describe("samefile()", function()
    assert.are_same({ true }, { fs.samefile(readme_file, readme_file) })
    assert.are_same({ true }, { fs.samefile(readme_file, "README.md") })
    assert.are_same({ false }, { fs.samefile(readme_file, spec_file) })

    it("fails on missing path", function()
      local ok, errmsg, errcode = fs.samefile(readme_file, "__mods_missing_path__")
      assert.are_same({ "nil", "string", "number" }, { type(ok), type(errmsg), type(errcode) })

      ok, errmsg, errcode = fs.samefile("__mods_missing_path__", readme_file)
      assert.are_same({ "nil", "string", "number" }, { type(ok), type(errmsg), type(errcode) })
    end)

    if is_unix then
      it("returns true for a hard link to the same file", function()
        local root = make_tmp_dir()
        local target = join(root, "target.txt")
        local link = join(root, "hardlink.txt")

        assert.is_true(fs.touch(target))
        assert.is_true(fs.link(target, link))
        assert.is_true(fs.samefile(target, link))
        assert.is_true(fs.rm(root, true))
      end)

      it("returns true for a symlink to the same file", function()
        local link = tmpname()
        assert.is_true(fs.symlink(readme_file, link))
        assert.is_true(fs.samefile(readme_file, link))
        assert.is_true(fs.rm(link))
      end)
    end
  end)

  -- stylua: ignore
  ---@diagnostic disable: param-type-mismatch, discard-returns, missing-parameter
  it("errors on invalid argument types", function()
    -- Argument #1 validation.

    assert.has_error(function() fs.cp(false)       end, "bad argument #1 (string expected, got boolean)")
    assert.has_error(function() fs.dir(false)      end, "bad argument #1 (string expected, got boolean)")
    assert.has_error(function() fs.exists(true)    end, "bad argument #1 (string expected, got boolean)")
    assert.has_error(function() fs.getatime(false) end, "bad argument #1 (string expected, got boolean)")
    assert.has_error(function() fs.getctime(0)     end, "bad argument #1 (string expected, got number)")
    assert.has_error(function() fs.getmtime()      end, "bad argument #1 (string expected, got no value)")
    assert.has_error(function() fs.getsize()       end, "bad argument #1 (string expected, got no value)")
    assert.has_error(function() fs.lexists({})     end, "bad argument #1 (string expected, got table)")
    assert.has_error(function() fs.link(false)     end, "bad argument #1 (string expected, got boolean)")
    assert.has_error(function() fs.listdir(false)  end, "bad argument #1 (string expected, got boolean)")
    assert.has_error(function() fs.mkdir()         end, "bad argument #1 (string expected, got no value)")
    assert.has_error(function() fs.read_bytes({})  end, "bad argument #1 (string expected, got table)")
    assert.has_error(function() fs.read_text({})   end, "bad argument #1 (string expected, got table)")
    assert.has_error(function() fs.rm({})          end, "bad argument #1 (string expected, got table)")
    assert.has_error(function() fs.symlink(false)  end, "bad argument #1 (string expected, got boolean)")
    assert.has_error(function() fs.touch(false)    end, "bad argument #1 (string expected, got boolean)")
    assert.has_error(function() fs.write_bytes({}) end, "bad argument #1 (string expected, got table)")
    assert.has_error(function() fs.write_text({})  end, "bad argument #1 (string expected, got table)")

    -- Argument #2 validation.

    assert.has_error(function() fs.cp("a")                      end, "bad argument #2 (string expected, got no value)")
    assert.has_error(function() fs.dir("src", false)            end, "bad argument #2 (table expected, got boolean)")
    assert.has_error(function() fs.link("a", false)             end, "bad argument #2 (string expected, got boolean)")
    assert.has_error(function() fs.listdir("src", false)        end, "bad argument #2 (table expected, got boolean)")
    assert.has_error(function() fs.mkdir("tmp", 1)              end, "bad argument #2 (boolean expected, got number)")
    assert.has_error(function() fs.rm("tmp", 1)                 end, "bad argument #2 (boolean expected, got number)")
    assert.has_error(function() fs.samefile(readme_file, 123)   end, "bad argument #2 (string expected, got number)")
    assert.has_error(function() fs.symlink("a", false)          end, "bad argument #2 (string expected, got boolean)")
    assert.has_error(function() fs.write_bytes(readme_file, {}) end, "bad argument #2 (string expected, got table)")
    assert.has_error(function() fs.write_text(readme_file)      end, "bad argument #2 (string expected, got no value)")
  end)

  -- stylua: ignore
  ---@diagnostic disable: param-type-mismatch, discard-returns
  it("validates options", function()
    local hidden = { hidden = 1 }
    local names  = { names = 1 }
    local rec    = { recursive = 1 }
    local follow = { follow = 1 }
    local tp     = { type = 1 }

    assert.has_error(function() fs.dir("src", follow)     end, "dir.opts.follow: boolean expected, got number")
    assert.has_error(function() fs.dir("src", hidden)     end, "dir.opts.hidden: boolean expected, got number")
    assert.has_error(function() fs.dir("src", rec)        end, "dir.opts.recursive: boolean expected, got number")
    assert.has_error(function() fs.dir("src", tp)         end, "dir.opts.type: string expected, got number")
    assert.has_error(function() fs.listdir("src", follow) end, "listdir.opts.follow: boolean expected, got number")
    assert.has_error(function() fs.listdir("src", hidden) end, "listdir.opts.hidden: boolean expected, got number")
    assert.has_error(function() fs.listdir("src", names)  end, "listdir.opts.names: boolean expected, got number")
    assert.has_error(function() fs.listdir("src", rec)    end, "listdir.opts.recursive: boolean expected, got number")
    assert.has_error(function() fs.listdir("src", tp)     end, "listdir.opts.type: string expected, got number")
  end)
end)
