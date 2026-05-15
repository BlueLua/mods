--[[
  Most test cases were ported from CPython's posixpath tests.
  Adapted and ported to Lua/Busted for this project's API and conventions.
  Source: https://github.com/python/cpython/blob/main/Lib/test/test_posixpath.py
  License: Python Software Foundation License Version 2 (PSF-2.0).
  Copyright (c) 2001 Python Software Foundation; All Rights Reserved.
]]

local lfs = require "lfs"
local mods = require "mods"

mods.runtime.is_windows = false -- Make mods.path use mods.posixpath.

local helpers = require "spec.helpers"

local posixpath = mods.posixpath
local path = mods.path
local tbl = mods.tbl

local args_repr = mods.utils.args_repr
local with_env = helpers.with_env
local fmt = string.format

describe("mods.posixpath", function()
  local cwd = lfs.currentdir()

  for k, v in tbl.spairs(path) do
    it(fmt("posixpath.%s is a function and equals path.%s", k, k), function()
      assert.is_function(posixpath[k])
      assert.are_equal(posixpath[k], v)
    end)
  end

  -- stylua: ignore
  local tests = {
    abspath = {
      {{ "a"                 }, { posixpath.normpath(cwd .. "/a")      }},
      {{ "."                 }, { posixpath.normpath(cwd)              }},
      {{ ".."                }, { posixpath.normpath(cwd .. "/..")     }},
      {{ "a/./b"             }, { posixpath.normpath(cwd .. "/a/./b")  }},
      {{ "a/../b"            }, { posixpath.normpath(cwd .. "/a/../b") }},
      {{ "/a"                }, { "/a"                                 }},
      {{ "/a/./b"            }, { "/a/b"                               }},
      {{ "/a/../b"           }, { "/b"                                 }},
      {{ "//foo//bar/../baz" }, { "//foo/baz"                          }},
    },
    basename = {
      {{ "/foo/bar"   }, { "bar" }},
      {{ "/"          }, { ""    }},
      {{ "foo"        }, { "foo" }},
      {{ "////foo"    }, { "foo" }},
      {{ "//foo//bar" }, { "bar" }},
      {{ "/foo"       }, { "foo" }},
      {{ "foo/"       }, { ""    }},
    },
    commonpath = {
      {{{ "/a/b/c"    , "/a/b/d"         }}, { "/a/b"                                       }},
      {{{ "a/b"       , "a/c"            }}, { "a"                                          }},
      {{{ "//a/x"     , "/a/y"           }}, { "/a"                                         }},
      {{{ "/foo/bar"                     }}, { "/foo/bar"                                   }},
      {{{ "/foo/bar/" , "/foo/bar"       }}, { "/foo/bar"                                   }},
      {{{ "/foo/bar/" , "/foo/bar/"      }}, { "/foo/bar"                                   }},
      {{{ "/foo/./bar", "/./foo/bar"     }}, { "/foo/bar"                                   }},
      {{{ "/"         , "/foo"           }}, { "/"                                          }},
      {{{ "/foo"      , "/bar"           }}, { "/"                                          }},
      {{{ "/foo/bar/" , "/foo/bar/baz"   }}, { "/foo/bar"                                   }},
      {{{ "/foo/bar/" , "/foo/baz/"      }}, { "/foo"                                       }},
      {{{ "/foo/bar"  , "/foo/baz"       }}, { "/foo"                                       }},
      {{{ "/foo/bar/" , "/foo/baz"       }}, { "/foo"                                       }},
      {{{ "foo"                          }}, { "foo"                                        }},
      {{{ "foo"       , "foo"            }}, { "foo"                                        }},
      {{{ "foo/bar"   , "foo/baz"        }}, { "foo"                                        }},
      {{{ "foo//bar"  , "foo/baz//"      }}, { "foo"                                        }},
      {{{ "foo/./bar" , "./foo/baz"      }}, { "foo"                                        }},
      {{{ "foo/bar"   , "foo/baz", "foo" }}, { "foo"                                        }},
      {{{ ""                             }}, { ""                                           }},
      {{{ ""          , "foo/bar"        }}, { ""                                           }},
      {{{                                }}, { nil, "paths list is empty"                   }},
      {{{ "/a", "b"                      }}, { nil, "can't mix absolute and relative paths" }},
    },
    dirname = {
      {{ "/"          }, { "/"     }},
      {{ "a"          }, { ""      }},
      {{ "/foo/bar"   }, { "/foo"  }},
      {{ "////foo"    }, { "////"  }},
      {{ "//foo//bar" }, { "//foo" }},
    },
    isabs = {
      {{ ""         }, { false }},
      {{ "/"        }, { true  }},
      {{ "/a"       }, { true  }},
      {{ "/foo/bar" }, { true  }},
      {{ "a/b"      }, { false }},
    },
    join = {
      {{ "/foo" , "bar" , "/bar", "baz" }, { "/bar/baz"      }},
      {{ "/foo" , "bar" , "baz"         }, { "/foo/bar/baz"  }},
      {{ "/foo/", "bar/", "baz/"        }, { "/foo/bar/baz/" }},
      {{ "a"    , ""                    }, { "a/"            }},
      {{ "a"    , ""    , ""            }, { "a/"            }},
      {{ "a"    , "b"                   }, { "a/b"           }},
      {{ "a"    , "b/"                  }, { "a/b/"          }},
      {{ "a/"   , "b"                   }, { "a/b"           }},
      {{ "a/"   , "b/"                  }, { "a/b/"          }},
      {{ "a"    , "b/c" , "d"           }, { "a/b/c/d"       }},
      {{ "a"    , "b//c", "d"           }, { "a/b//c/d"      }},
      {{ "a"    , "b/c/", "d"           }, { "a/b/c/d"       }},
      {{ "/a"   , "b"                   }, { "/a/b"          }},
      {{ "/a/"  , "b"                   }, { "/a/b"          }},
      {{ "a"    , "/b"  , "c"           }, { "/b/c"          }},
      {{ "a"    , "/b"  , "/c"          }, { "/c"            }},
      {{ ""     , "a"                   }, { "a"             }},
      {{ "a/"   , "b/"  , "c"           }, { "a/b/c"         }},
      {{ "/a"   , "b"   , "c"           }, { "/a/b/c"        }},
    },
    normcase = {
      {{ "A/B" }, { "A/B" }},
    },
    normpath = {
      {{ ""                                }, { "."              }},
      {{ "/"                               }, { "/"              }},
      {{ "/."                              }, { "/"              }},
      {{ "/./"                             }, { "/"              }},
      {{ "/.//."                           }, { "/"              }},
      {{ "/./foo/bar"                      }, { "/foo/bar"       }},
      {{ "/foo"                            }, { "/foo"           }},
      {{ "/foo/bar"                        }, { "/foo/bar"       }},
      {{ "//"                              }, { "//"             }},
      {{ "///"                             }, { "/"              }},
      {{ "///foo/.//bar//"                 }, { "/foo/bar"       }},
      {{ "///foo/.//bar//.//..//.//baz///" }, { "/foo/baz"       }},
      {{ "///..//./foo/.//bar"             }, { "/foo/bar"       }},
      {{ "."                               }, { "."              }},
      {{ ".//."                            }, { "."              }},
      {{ "./foo/bar"                       }, { "foo/bar"        }},
      {{ ".."                              }, { ".."             }},
      {{ "../"                             }, { ".."             }},
      {{ "../foo"                          }, { "../foo"         }},
      {{ "../../foo"                       }, { "../../foo"      }},
      {{ "../foo/../bar"                   }, { "../bar"         }},
      {{ "../../foo/../bar/./baz/boom/.."  }, { "../../bar/baz"  }},
      {{ "/.."                             }, { "/"              }},
      {{ "/.."                             }, { "/"              }},
      {{ "/../"                            }, { "/"              }},
      {{ "/..//"                           }, { "/"              }},
      {{ "//."                             }, { "//"             }},
      {{ "//.."                            }, { "//"             }},
      {{ "//..."                           }, { "//..."          }},
      {{ "//../foo"                        }, { "//foo"          }},
      {{ "//../../foo"                     }, { "//foo"          }},
      {{ "/../foo"                         }, { "/foo"           }},
      {{ "/../../foo"                      }, { "/foo"           }},
      {{ "/../foo/../"                     }, { "/"              }},
      {{ "/../foo/../bar"                  }, { "/bar"           }},
      {{ "/../../foo/../bar/./baz/boom/.." }, { "/bar/baz"       }},
      {{ "/../../foo/../bar/./baz/boom/."  }, { "/bar/baz/boom"  }},
      {{ "foo/../bar/baz"                  }, { "bar/baz"        }},
      {{ "foo/../../bar/baz"               }, { "../bar/baz"     }},
      {{ "foo/../../../bar/baz"            }, { "../../bar/baz"  }},
      {{ "foo///../bar/.././../baz/boom"   }, { "../baz/boom"    }},
      {{ "foo/bar/../..///../../baz/boom"  }, { "../../baz/boom" }},
      {{ "/foo/.."                         }, { "/"              }},
      {{ "/foo/../.."                      }, { "/"              }},
      {{ "//foo/.."                        }, { "//"             }},
      {{ "//foo/../.."                     }, { "//"             }},
      {{ "///foo/.."                       }, { "/"              }},
      {{ "///foo/../.."                    }, { "/"              }},
      {{ "////foo/.."                      }, { "/"              }},
      {{ "/////foo/.."                     }, { "/"              }},
    },
    relpath = {
      {{ "/a/b/c"      , "/a"       }, { "b/c"                    }},
      {{ "/a"          , "/a"       }, { "."                      }},
      {{ "/a/b"        , "/a/b/c"   }, { ".."                     }},
      {{ "/foo/bar/baz", "/foo/bar" }, { "baz"                    }},
      {{ "/foo/bar/baz", "/"        }, { "foo/bar/baz"            }},
      {{ "/"           , "/foo/bar" }, { "../.."                  }},
      {{ "/foo/bar/baz", "/x/y/z"   }, { "../../../foo/bar/baz"   }},
      {{ "a/b"         , "a"        }, { "b"                      }},
      {{ "a"           , "a/b"      }, { ".."                     }},
      {{ "a"           , "a"        }, { "."                      }},
      {{ "foo/bar"     , "foo/baz"  }, { "../bar"                 }},
      {{ "foo"         , "."        }, { "foo"                    }},
      {{ "."           , "foo/bar"  }, { "../.."                  }},
      {{ ""                         }, { nil, "no path specified" }},
    },
    split = {
      {{ "/a/b/c.txt" }, { "/a/b" , "c.txt" }},
      {{ "/"          }, { "/"    , ""      }},
      {{ "a"          }, { ""     , "a"     }},
      {{ "a/"         }, { "a"    , ""      }},
      {{ "////foo"    }, { "////" , "foo"   }},
      {{ "//foo//bar" }, { "//foo", "bar"   }},
    },
    splitdrive = {
      {{"/a/b"}, {"", "/a/b"}},
    },
    splitext = {
      {{ "foo.bar"          }, { "foo"              , ".bar" }},
      {{ "foo.boo.bar"      }, { "foo.boo"          , ".bar" }},
      {{ "foo.boo.biff.bar" }, { "foo.boo.biff"     , ".bar" }},
      {{ ".csh.rc"          }, { ".csh"             , ".rc"  }},
      {{ "nodots"           }, { "nodots"           , ""     }},
      {{ ".cshrc"           }, { ".cshrc"           , ""     }},
      {{ "...manydots.ext"  }, { "...manydots"      , ".ext" }},
      {{ "."                }, { "."                , ""     }},
      {{ ".."               }, { ".."               , ""     }},
      {{ "..."              }, { "..."              , ""     }},
      {{ "...."             }, { "...."             , ""     }},
      {{ ""                 }, { ""                 , ""     }},
      {{ "archive.tar.gz"   }, { "archive.tar"      , ".gz"  }},
      {{ ".bashrc"          }, { ".bashrc"          , ""     }},
      {{ "a/b/c.txt"        }, { "a/b/c"            , ".txt" }},
      {{ "noext"            }, { "noext"            , ""     }},
      {{ "abc.def/path.txt/"}, { "abc.def/path.txt/", ""     }},
    },
    splitroot = {
      {{ ""        }, { "", ""  , ""       }},
      {{ "a"       }, { "", ""  , "a"      }},
      {{ "a/b"     }, { "", ""  , "a/b"    }},
      {{ "a/b/"    }, { "", ""  , "a/b/"   }},
      {{ "/a"      }, { "", "/" , "a"      }},
      {{ "/a/b"    }, { "", "/" , "a/b"    }},
      {{ "/a/b/"   }, { "", "/" , "a/b/"   }},
      {{ "//a"     }, { "", "//", "a"      }},
      {{ "///a"    }, { "", "/" , "//a"    }},
      {{ "///a/b"  }, { "", "/" , "//a/b"  }},
      {{ "c:/a/b"  }, { "", ""  , "c:/a/b" }},
      {{ "\\/a/b"  }, { "", ""  , "\\/a/b" }},
      {{ "\\a\\b"  }, { "", ""  , "\\a\\b" }},
    },
    from_uri = {
      {{ "file:///foo/bar"           }, { "/foo/bar"                            }},
      {{ "file:////foo/bar"          }, { "//foo/bar"                           }},
      {{ "file:///foo/My%20File.txt" }, { "/foo/My File.txt"                    }},
      {{ "file://localhost/foo/bar"  }, { "/foo/bar"                            }},
      {{ "file://localhost"          }, { nil, "uri is not absolute"            }},
      {{ "file:/foo/bar"             }, { nil, "invalid file uri"               }},
      {{ "file://foo/bar"            }, { nil, "unsupported file uri authority" }},
      {{ "foo/bar"                   }, { nil, "invalid file uri"               }},
      {{ "/foo/bar"                  }, { nil, "invalid file uri"               }},
      {{ "//foo/bar"                 }, { nil, "invalid file uri"               }},
      {{ "file:foo/bar"              }, { nil, "invalid file uri"               }},
      {{ "http://foo/bar"            }, { nil, "invalid file uri"               }},
    },
  }

  for fname, cases in tbl.spairs(tests) do
    for i = 1, #cases do
      local params, expected = unpack(cases[i] --[[@as {[1]:string[], [2]:any[]}]], 1, 2)

      it(fmt("%s(%s)", fname, args_repr(params)), function()
        assert.are_same(expected, { posixpath[fname](unpack(params)) })
      end)
    end
  end

  -- stylua: ignore
  local tests = {
    home = {
      {
        env = {},
        { nil, { nil, "home directory is not set" }},
      },
      {
        env = { HOME = "/home/eric" },
        { nil, { "/home/eric" }},
      },
    },
    expanduser = {
      {
        env = {},
        { "test", { "test" }},
      },
      {
        env = { HOME = "/home/eric" },
        { "~/test", { "/home/eric/test" }},
      },
    }
  }

  for fname, entry in tbl.spairs(tests) do
    for _, e in ipairs(entry) do
      local env = e.env
      for _, v in ipairs(e) do
        local input, expected = v[1], v[2]
        local input_repr = (input and ("'" .. input .. "'") or "")
        it(fmt("%s(%s) with env %s", fname, input_repr, inspect(env)), function()
          with_env(env, function()
            assert.are_same(expected, { posixpath[fname](input) })
          end)
        end)
      end
    end
  end
end)
