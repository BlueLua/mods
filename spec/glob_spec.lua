local helpers = require "spec.helpers"
local mods = require "mods"

local List = mods.list
local Set = mods.Set
local fs = mods.fs
local glob = mods.glob

local args_repr = mods.utils.args_repr
local spairs = mods.tbl.spairs
local make_tmp_dir = helpers.make_tmp_dir
local join = mods.path.join

local fmt = string.format

describe("mods.glob", function()
  local set_windows_semantics = glob._set_windows_semantics --[[@as fun()]]
  local set_posix_semantics = glob._set_posix_semantics --[[@as fun()]]
  local restore_semantics = mods.runtime.is_windows and set_windows_semantics or set_posix_semantics
  local cwd = fs.cwd() --[[@as string]]
  local modes = Set({ "common", "posix", "windows" })

  local function make_recursive_txt_fixture()
    local root = make_tmp_dir()
    local subdir = join(root, "sub")
    local nested_dir = join(subdir, "deep")
    local target = join(root, "data.txt")
    local nested = join(nested_dir, "nested.txt")

    assert.is_true(fs.mkdir(nested_dir, true))
    assert.is_true(fs.touch(target))
    assert.is_true(fs.touch(nested))

    return root, target, nested
  end

  -- stylua: ignore
  local tests = {
    escape = {
      "common",
      -------expected-------|---------args--------
      { [[a\*b]]            , { "a*b"           }},
      { [[a\?b]]            , { "a?b"           }},
      { [[\[abc\].txt]]     , { "[abc].txt"     }},
      { [[a\[\!0-9\]b]]     , { "a[!0-9]b"      }},
      { [[foo.\{lua\,txt\}]], { "foo.{lua,txt}" }},
      { [[\*\*]]            , { "**"            }},

      "windows",
      { [[a\\b]]            , { [[a\b]]         }},
    },
    translate = {
      "common",
      -- literal and single-segment wildcard translation
      { "^$"           , { ""         }},
      { "^foo$"        , { "foo"      }},
      { "^[^/]*%.txt$" , { "*.txt"    }},
      { "^a[^/]b$"     , { "a?b"      }},
      { "^a[0-9]b$"    , { "a[0-9]b"  }},
      { "^a[^/]*c$"    , { "a*c"      }},
      { "^[^/][^/]$"   , { "??"       }},
      { "^file[^/]*$"  , { "file*"    }},
      { "^file%.[^/]*$", { "file.*"   }},
      { "^a%*b$"       , { "a\\*b"    }},
      { "^a%[b$"       , { "a\\[b"    }},
      { "^foo%.$"      , { "foo."     }},
      { "^f[^a-z]o$"   , { "f[!a-z]o" }},

      -- translation stays segment-local and excludes path separators
      { "^foo/bar$"       , { "foo/bar"   }},
      { "^foo/[^/]*$"     , { "foo/*"     }},
      { "^foo/[^/]$"      , { "foo/?"     }},
      { "^foo/[^/]*%.txt$", { "foo/*.txt" }},

      -- limits: brace expansion and `**` are not encoded as full path-aware Lua patterns
      { "^foo%.{bar}$"           , { "foo.{bar}"     }},
      { "^foo%.{lua,txt}$"       , { "foo.{lua,txt}" }},
      { "^[^/]*[^/]*$"           , { "**"            }},
      { "^[^/]*[^/]*/[^/]*%.lua$", { "**/*.lua"      }},

      "windows",
      { "^foobar$"               , { [[foo\bar]]     }},
      { "^foo%*bar$"             , { [[foo\*bar]]    }},
    },
    has_magic = {
      "common",
      { true , { "*.txt"            }},
      { true , { "file?.txt"        }},
      { true , { "a[0-9].txt"       }},
      { true , { "foo.{lua,txt}"    }},
      { true , { "**/*.txt"         }},
      { false, { "foo.txt"          }},
      { false, { "foo\\*.txt"       }},
      { false, { "foo\\?.txt"       }},
      { false, { "foo\\{bar\\}.txt" }},
      { false, { "foo\\[bar\\].txt" }},
    },
    match = {
      "windows",
      { true , { [[foo\bar.txt]], "foo/*.txt"           }},
      { true , { "foo*bar"      , [[foo\*bar]]          }},
      { false, { [[foo\bar.txt]], [[foo\*.txt]]         }},
      { false, { "a\\b"         , "a\\\\b"              }},
      { false, { "a\\b"         , glob.escape("a\\b")   }},
      { true , { "FOO"          , "foo"                 }},
      { true , { "foo/BAR"      , "foo/[a-z][a-z][a-z]" }},
      { true , { "DATA.TXT"     , "*.txt"               }},
      { true , { "DATA.TXT"     , "*.txt"     , true    }},
      { false, { "DATA.TXT"     , "*.txt"     , false   }},

      "posix",
      { false, { [[foo\bar.txt]], "foo/*.txt"           }},
      { true , { [[foo\bar.txt]], [[foo\\bar.txt]]      }},
      { true , { "a\\b"         , "a\\\\b"              }},
      { true , { "a\\b"         , glob.escape("a\\b")   }},
      { false, { "FOO"          , "foo"                 }},
      { false, { "foo/BAR"      , "foo/[a-z][a-z][a-z]" }},
      { false, { "DATA.TXT"     , "*.txt"               }},
      { true , { "DATA.TXT"     , "*.txt"     , true    }},

      "common",
      -- literal strings
      { true , { "/tmp/example.txt"    , "/tmp/example.txt"     }},
      { true , { "alpha/beta/gamma.txt", "alpha/beta/gamma.txt" }},
      { true , { "foo"                 , "foo"                  }},
      { true , { "foo/bar"             , "foo/bar"              }},
      { false, { "/tmp/example.txt"    , "/tmp/other.txt"       }},
      { false, { "alpha/beta/gamma.txt", "alpha/beta/delta.txt" }},
      { false, { "foo"                 , "bar"                  }},
      { false, { "foo/bar"             , "foo/baz"              }},

      -- wildcard: *
      { true , { "a.b.c"      , "*.*"       }},
      { true , { "foo.txt"    , "*.txt"     }},
      { true , { ".env"       , "*"         }},
      { true , { ""           , "*"         }},
      { true , { "foo"        , "*"         }},
      { true , { "abc"        , "*c"        }},
      { true , { "abc"        , "a*"        }},
      { true , { "abbbc"      , "a*c"       }},
      { true , { "foo/bar-baz", "foo/*-*"   }},
      { true , { "foo/bar.txt", "foo/*.txt" }},
      { true , { "foo/bar"    , "foo/*"     }},
      { false, { "foo.lua"    , "*.txt"     }},
      { false, { "/"          , "*"         }},
      { false, { "/a"         , "*"         }},
      { false, { "a/"         , "*"         }},
      { false, { "foo/bar"    , "*"         }},
      { false, { "acb"        , "a*c"       }},
      { false, { "abc"        , "abc/*"     }},
      { false, { "foo/bar/baz", "foo/*-*"   }},
      { false, { "foo/bar/baz", "foo/*"     }},

      -- wildcard: **
      { true , { "a"                , "**"             }},
      { true , { "a/b"              , "**"             }},
      { true , { "src/mods/fs.lua"  , "**/*.lua"       }},
      { true , { "foo/bar/baz.txt"  , "foo/**/baz.txt" }},
      { true , { "foo/baz.txt"      , "foo/**/baz.txt" }},
      { true , { "a/b/c"            , "a/**/c"         }},
      { true , { "foo"              , "**/foo"         }},
      { true , { "a/b/c"            , "**/**/c"        }},
      { true , { "foo/bar/baz"      , "**/bar/**"      }},
      { false, { "src/mods/fs.txt"  , "**/*.lua"       }},
      { false, { "x/foo/bar/baz.txt", "foo/**/baz.txt" }},
      { false, { "a/b/c/d"          , "a/**/c"         }},
      { false, { "a"                , "a/**"           }},
      { false, { "foo/bar/baz"      , "**/qux/**"      }},

      -- wildcard: ?
      { true , { "a"      , "?"         }},
      { true , { "ab"     , "?b"        }},
      { true , { "ab"     , "a?"        }},
      { true , { "foo/bar", "foo/???"   }},
      { true , { "foo/x"  , "foo/?"     }},
      { true , { "x9z"    , "?9?"       }},
      { false, { ""       , "?"         }},
      { false, { "ab"     , "?"         }},
      { false, { "foo/bar", "foo/??"    }},
      { false, { "foo/bar", "foo/?/?/?" }},
      { false, { "foo/xy" , "foo/?"     }},
      { false, { "xy"     , "x??"       }},

      -- wildcard: []
      { true , { "a1.txt" , "a[0-9].txt"          }},
      { true , { "ab.txt" , "a[bc].txt"           }},
      { true , { "f-"     , "f[-]"                }},
      { true , { "fA"     , "f[A-Z]"              }},
      { true , { "foo/bar", "foo/[a-z][a-z][a-z]" }},
      { false, { "aa.txt" , "a[0-9].txt"          }},
      { false, { "ad.txt" , "a[bc].txt"           }},
      { false, { "f_"     , "f[0-9A-Z]"           }},
      { false, { "fz"     , "f[A-Y]"              }},

      -- wildcard: [!]
      { true , { "!"      , "[\\!]"        }},
      { true , { "11z"    , "[!a-z]1z"     }},
      { true , { "9ab"    , "[!a-z]ab"     }},
      { true , { "axa.txt", "a[!0-9]a.txt" }},
      { true , { "f_"     , "f[!a-z]"      }},
      { false, { "a1a.txt", "a[!0-9]a.txt" }},
      { false, { "a1z"    , "[!a-z]1z"     }},
      { false, { "fab"    , "[!a-z]ab"     }},
      { false, { "fZ"     , "f[!A-Z]"      }},

      -- wildcard: {}
      { true , { "foo.lua"        , "foo.{lua,txt}"               }},
      { true , { "foo-a.txt"      , "foo-{a,b}.{txt,md}"          }},
      { true , { "foo-b.md"       , "foo-{a,b}.{txt,md}"          }},
      { true , { "foo.tar.gz"     , "foo.{tar.{gz,bz2},zip}"      }},
      { true , { "foo.tar.gz"     , "foo.{tar.{xz,{bz2,gz}},zip}" }},
      { true , { "foo.txt"        , "foo.{lua,txt}"               }},
      { true , { "ac"             , "a{,b}c"                      }},
      { true , { "abc"            , "a{,b}c"                      }},
      { true , { "foo.lua,txt"    , "foo.{lua\\,txt,md}"          }},
      { true , { "src/mods/fs.lua", "src/{mods,spec}/fs.lua"      }},
      { true , { "x/a/end"        , "x/{a,b}/end"                 }},
      { true , { "x/c/end"        , "x/{a,{b,c}}/end"             }},
      { true , { "}ab"            , "}a{b,c}"                     }},
      { true , { "}ac"            , "}a{b,c}"                     }},
      { false, { "foo.md"         , "foo.{lua,txt}"               }},
      { false, { "foo-c.txt"      , "foo-{a,b}.{txt,md}"          }},
      { false, { "foo-a.log"      , "foo-{a,b}.{txt,md}"          }},
      { false, { "foo.tar.xz"     , "foo.{tar.{gz,bz2},zip}"      }},
      { false, { "foo.tar.zst"    , "foo.{tar.{gz,{bz2,xz}},zip}" }},
      { false, { "adc"            , "a{,b}c"                      }},
      { false, { "src/bin/fs.lua" , "src/{mods,spec}/fs.lua"      }},
      { false, { "x/d/end"        , "x/{a,{b,c}}/end"             }},
      { false, { "}ad"            , "}a{b,c}"                     }},

      -- escaped literals
      { true , { "a*b" , "a\\*b" }},
      { true , { "a?b" , "a\\?b" }},
      { true , { "a[b" , "a\\[b" }},
      { true , { "a{b" , "a\\{b" }},
      { true , { "[abc" , "[abc" }},
      { true , { "a{b"  , "a{b"  }},
      { false, { "ab"  , "a\\*b" }},
      { false, { "acb" , "a\\?b" }},
      { false, { "axb" , "a\\[b" }},

      -- combined wildcard patterns
      { true , { "src/mods/fs.lua"  , "src/*/f?.[l]ua"               }},
      { true , { "src/mods/fs.lua"  , "src/**/f[!0-9].lua"           }},
      { true , { "a/b/file-7.txt"   , "a/**/file-[0-9].t?t"          }},
      { true , { "docs/v1/readme.md", "docs/*[0-9]/**/r*.md"         }},
      { true , { "x/y/z9.log"       , "x/**/z[!a-z].l?g"             }},
      { true , { "src/mods/fs.lua"  , "src/{mods,spec}/f?.{lua,txt}" }},
      { true , { "a/b/file-7.txt"   , "a/**/{file,doc}-[0-9].t?t"    }},
      { true , { "a*b"              , glob.escape("a*b")             }},
      { true , { "a?b"              , glob.escape("a?b")             }},
      { true , { "[abc].txt"        , glob.escape("[abc].txt")       }},
      { true , { "a[!0-9]b"         , glob.escape("a[!0-9]b")        }},
      { true , { "foo.{lua,txt}"    , glob.escape("foo.{lua,txt}")   }},
      { true , { "**"               , glob.escape("**")              }},
      { false, { "src/mods/fs.lua"  , "src/*/f?.[0-9]ua"             }},
      { false, { "a/b/file-x.txt"   , "a/**/file-[0-9].t?t"          }},
      { false, { "docs/vx/readme.md", "docs/*[0-9]/**/r*.md"         }},
      { false, { "x/y/za.log"       , "x/**/z[!a-z].l?g"             }},
      { false, { "src/bin/fs.lua"   , "src/{mods,spec}/f?.{lua,txt}" }},
      { false, { "ab"               , glob.escape("a*b")             }},
      { false, { "acb"              , glob.escape("a?b")             }},
      { false, { "a1b"              , glob.escape("a[!0-9]b")        }},
      { false, { "foo.lua"          , glob.escape("foo.{lua,txt}")   }},
      { false, { "x/y"              , glob.escape("**")              }},
    },
  }

  for fname, t in spairs(tests) do
    local mode = "common"
    for i = 1, #t do
      local entry = t[i]
      if modes[entry] then
        mode = entry --[[@as string]]
      else
        local expected, args = unpack(entry --[[@as {[1]:boolean, [2]:string[]}]])
        local case_modes = mode == "common" and { "posix", "windows" } or { mode }
        for _, case_mode in ipairs(case_modes) do
          it(fmt("%s(%s) [%s]", fname, args_repr(args), case_mode), function()
            local set_semantics = case_mode == "posix" and set_posix_semantics or set_windows_semantics
            set_semantics()
            local res = glob[fname](unpack(args))
            restore_semantics()
            assert.are_equal(expected, res)
          end)
        end
      end
    end
  end

  it("translate() produces Lua patterns usable with string.match", function()
    -- stylua: ignore
    local cases = {
      { "file-7.txt", "file-[0-9].t?t" },
      { "z9.log"    , "z[!a-z].l?g"    },
      { "a*b"       , "a\\*b"          },
      { "file-x.txt", "file-[0-9].t?t" },
      { "za.log"    , "z[!a-z].l?g"    },
      { "aXb"       , "a\\*b"          },
    }

    for i = 1, #cases do
      local s, pattern = unpack(cases[i])
      assert.are_equal(glob.match(s, pattern), s:match(glob.translate(pattern)) ~= nil)
    end
  end)

  describe("glob()", function()
    it("matches filesystem entries", function()
      local root, target, nested = make_recursive_txt_fixture()
      assert.same({ target }, glob.glob(root, "*.txt"))
      assert.same({ target, nested }, glob.glob(root, "*.txt", { recursive = true }):sort())
      assert.same({ target }, glob.glob(root, "data.txt"))
      assert.same({ nested }, glob.glob(root, "sub/deep/*.txt"))
      assert.is_true(fs.rm(root, true))
    end)

    it("accepts a pattern without an explicit root", function()
      local root = make_tmp_dir()
      local nested_dir = join(root, "nested")
      local target = join(root, "data.txt")
      local nested = join(nested_dir, "info.md")

      assert.is_true(fs.mkdir(nested_dir, true))
      assert.is_true(fs.touch(target))
      assert.is_true(fs.touch(nested))
      assert.is_true(fs.cd(root))

      local matches = glob.glob("*.txt")
      assert.is_true(fs.cd(cwd))
      assert.is_true(fs.rm(root, true))
      assert.same({ "./data.txt" }, matches)
    end)

    it("supports hidden", function()
      local root = make_tmp_dir()
      local hidden = join(root, ".hidden.txt")
      local hidden_dir = join(root, ".cache")
      local nested = join(hidden_dir, "deep.txt")

      assert.is_true(fs.mkdir(hidden_dir, true))
      assert.is_true(fs.touch(hidden))
      assert.is_true(fs.touch(nested))

      assert.same({ hidden }, glob.glob(root, "*.txt"))
      assert.same({}, glob.glob(root, "*.txt", { hidden = false }))
      assert.same({ hidden }, glob.glob(root, ".*.txt", { hidden = false }))
      assert.same({}, glob.glob(root, "**/*.txt", { hidden = false }))
      assert.same({ nested, hidden }, glob.glob(root, "**/*.txt", { hidden = true }):sort())

      assert.is_true(fs.rm(root, true))
    end)

    it("supports ignorecase", function()
      local root = make_tmp_dir()
      local mixed = join(root, "Data.TXT")

      assert.is_true(fs.touch(mixed))

      assert.same({}, glob.glob(root, "*.txt"))
      assert.same({ mixed }, glob.glob(root, "*.txt", { ignorecase = true }))

      assert.is_true(fs.rm(root, true))
    end)

    it("defaults ignorecase to true under windows semantics", function()
      local root = make_tmp_dir()
      local mixed = join(root, "Data.TXT")

      assert.is_true(fs.touch(mixed))
      set_windows_semantics()
      assert.same({ mixed }, glob.glob(root, "*.txt"))
      restore_semantics()

      assert.is_true(fs.rm(root, true))
    end)

    it("supports representative wildcard forms end-to-end", function()
      local root = make_tmp_dir()
      local file1 = join(root, "file1.txt")
      local file2 = join(root, "file2.txt")
      local note = join(root, "file1.md")
      local literal = join(root, "a*b.txt")

      assert.is_true(fs.touch(file1))
      assert.is_true(fs.touch(file2))
      assert.is_true(fs.touch(note))
      assert.is_true(fs.touch(literal))

      assert.same({ file1, file2 }, glob.glob(root, "file?.txt"):sort())
      assert.same({ file1, file2 }, glob.glob(root, "file[1-2].txt"):sort())
      assert.same({ note, file1 }, glob.glob(root, "file1.{txt,md}"):sort())
      assert.same({ literal }, glob.glob(root, glob.escape("a*b.txt")))

      assert.is_true(fs.rm(root, true))
    end)

    it("supports directory-only patterns", function()
      local root = make_tmp_dir()
      local top_dir = join(root, "logs")
      local nested_dir = join(top_dir, "archive")
      local file = join(root, "logs.txt")

      assert.is_true(fs.mkdir(nested_dir, true))
      assert.is_true(fs.touch(file))

      assert.same({ top_dir }, glob.glob(root, "*/"))
      assert.same({ top_dir, nested_dir }, glob.glob(root, "**/", { hidden = true }):sort())
      assert.is_true(fs.rm(root, true))
    end)

    it("can match explicit hidden directories when hidden is false", function()
      local root = make_tmp_dir()
      local hidden_dir = join(root, ".cache")
      local hidden_file = join(hidden_dir, "deep.txt")

      assert.is_true(fs.mkdir(hidden_dir, true))
      assert.is_true(fs.touch(hidden_file))

      assert.same({ hidden_file }, glob.glob(root, ".cache/*.txt", { hidden = false }))
      assert.same({ hidden_file }, glob.glob(root, "**/.cache/*.txt", { hidden = false }))

      assert.is_true(fs.rm(root, true))
    end)

    it("returns an empty list for a non-directory root", function()
      local root = make_tmp_dir()
      local file = join(root, "data.txt")

      assert.is_true(fs.touch(file))
      assert.same({}, glob.glob(file, "*.txt"))
      assert.is_true(fs.rm(root, true))
    end)

    it("can follow symlinked directories", function()
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

      assert.same({}, glob.glob(root, "linked/*.txt"))
      assert.same({ join(link_dir, "nested.txt") }, glob.glob(root, "linked/*.txt", { follow = true }))
      assert.is_true(fs.rm(root, true))
    end)
  end)

  describe("filter()", function()
    it("returns matching values from a list", function()
      local names = { "a.lua", "b.txt", "c.lua" }
      assert.same({ "a.lua", "c.lua" }, glob.filter(names, "*.lua"))
    end)

    it("supports ignorecase", function()
      local names = { "A.LUA", "b.txt", "c.lua" }
      assert.same({ "A.LUA", "c.lua" }, glob.filter(names, "*.lua", true))
      assert.same({ "c.lua" }, glob.filter(names, "*.lua", false))
    end)

    it("defaults ignorecase to true under windows semantics", function()
      local names = { "A.LUA", "b.txt", "c.lua" }
      set_windows_semantics()
      assert.same({ "A.LUA", "c.lua" }, glob.filter(names, "*.lua"))
      restore_semantics()
    end)
  end)

  describe("iglob()", function()
    it("iterates over the same matches as glob()", function()
      local root, target, nested = make_recursive_txt_fixture()
      local ls = List()
      for p in glob.iglob(root, "*.txt", { recursive = true }) do
        ls:append(p)
      end

      assert.same({ target, nested }, ls:sort())
      assert.is_true(fs.rm(root, true))
    end)

    it("accepts a pattern without an explicit root", function()
      local root = make_tmp_dir()
      local nested_dir = join(root, "nested")
      local target = join(root, "data.txt")
      local nested = join(nested_dir, "info.md")

      assert.is_true(fs.mkdir(nested_dir, true))
      assert.is_true(fs.touch(target))
      assert.is_true(fs.touch(nested))
      assert.is_true(fs.cd(root))

      local ls = List()
      for p in glob.iglob("*.txt") do
        ls:append(p)
      end

      assert.is_true(fs.cd(cwd))
      assert.is_true(fs.rm(root, true))
      assert.same({ "./data.txt" }, ls)
    end)

    it("supports ignorecase and directory-only patterns", function()
      local root = make_tmp_dir()
      local mixed = join(root, "Data.TXT")
      local subdir = join(root, "cache")

      assert.is_true(fs.touch(mixed))
      assert.is_true(fs.mkdir(subdir))

      local opts = { ignorecase = true }
      local ls = List()
      for p in glob.iglob(root, "*.txt", opts) do
        ls:append(p)
      end
      assert.same({ mixed }, ls)

      ls = List()
      for p in glob.iglob(root, "*/") do
        ls:append(p)
      end

      assert.same({ subdir }, ls)
      assert.is_true(fs.rm(root, true))
    end)

    it("returns no results for a non-directory root", function()
      local root = make_tmp_dir()
      local file = join(root, "data.txt")
      assert.is_true(fs.touch(file))

      local ls = List()
      for p in glob.iglob(file, "*.txt") do
        ls:append(p)
      end

      assert.is_true(ls:isempty())
      assert.is_true(fs.rm(root, true))
    end)
  end)

  ---@diagnostic disable: param-type-mismatch, missing-parameter, discard-returns

  -- stylua: ignore
  it("errors on invalid argument types", function()
    -- Argument #1 validation.

    assert.has_error(function() glob.escape()     end, "bad argument #1 (string expected, got no value)")
    assert.has_error(function() glob.filter()     end, "bad argument #1 (table expected, got no value)")
    assert.has_error(function() glob.glob(false)  end, "bad argument #1 (string expected, got boolean)")
    assert.has_error(function() glob.has_magic()  end, "bad argument #1 (string expected, got no value)")
    assert.has_error(function() glob.iglob(false) end, "bad argument #1 (string expected, got boolean)")
    assert.has_error(function() glob.match(false) end, "bad argument #1 (string expected, got boolean)")
    assert.has_error(function() glob.translate()  end, "bad argument #1 (string expected, got no value)")

    -- Argument #2 validation.

    assert.has_error(function() glob.filter({}, false) end, "bad argument #2 (string expected, got boolean)")
    assert.has_error(function() glob.glob("a", false)  end, "bad argument #2 (string expected, got boolean)")
    assert.has_error(function() glob.iglob("a", false) end, "bad argument #2 (string expected, got boolean)")
    assert.has_error(function() glob.match("a", false) end, "bad argument #2 (string expected, got boolean)")

    -- Argument #3 validation.

    assert.has_error(function() glob.filter({}, "*.txt", 1)     end, "bad argument #3 (boolean expected, got number)")
    assert.has_error(function() glob.glob("a", "*.txt", false)  end, "bad argument #3 (table expected, got boolean)")
    assert.has_error(function() glob.iglob("a", "*.txt", false) end, "bad argument #3 (table expected, got boolean)")
    assert.has_error(function() glob.match("a", "*.txt", 1)     end, "bad argument #3 (boolean expected, got number)")
  end)

  -- stylua: ignore
  it("validates options", function()
    local hidden     = { hidden = 1 }
    local recursive  = { recursive = 1 }
    local follow     = { follow = 1 }
    local ignorecase = { ignorecase = 1 }

    assert.has_error(function() glob.glob("a", "*.txt", hidden)      end, "glob.opts.hidden: boolean expected, got number")
    assert.has_error(function() glob.glob("a", "*.txt", recursive)   end, "glob.opts.recursive: boolean expected, got number")
    assert.has_error(function() glob.glob("a", "*.txt", follow)      end, "glob.opts.follow: boolean expected, got number")
    assert.has_error(function() glob.glob("a", "*.txt", ignorecase)  end, "glob.opts.ignorecase: boolean expected, got number")
    assert.has_error(function() glob.iglob("a", "*.txt", hidden)     end, "iglob.opts.hidden: boolean expected, got number")
    assert.has_error(function() glob.iglob("a", "*.txt", recursive)  end, "iglob.opts.recursive: boolean expected, got number")
    assert.has_error(function() glob.iglob("a", "*.txt", follow)     end, "iglob.opts.follow: boolean expected, got number")
    assert.has_error(function() glob.iglob("a", "*.txt", ignorecase) end, "iglob.opts.ignorecase: boolean expected, got number")
  end)
end)
