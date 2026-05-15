local helpers = require "spec.helpers"
local mods = require "mods"

local str = mods.str

local test_functions = helpers.test_functions
local args_repr = mods.utils.args_repr

local byte = string.byte
local fmt = string.format

describe("mods.str", function()
  test_functions(str, {
    -- stylua: ignore start
    --{{expected_results}, {args}}

    capitalize = {
      {{ ""      }, { ""      }},
      {{ "1abc"  }, { "1abc"  }},
      {{ "A"     }, { "a"     }},
      {{ "Hello" }, { "hello" }},
      {{ "Hello" }, { "hELLO" }},
    },
    center = {
      {{ "hi"     }, { "hi", -6      }},
      {{ "hi"     }, { "hi", 2       }},
      {{ "ahia"   }, { "hi", 4, "ab" }},
      {{ "  hi  " }, { "hi", 6       }},
      {{ "__hi__" }, { "hi", 6, "_"  }},
    },
    count = {
      {{ 4 }, { "aaaa"  , "a" ,       }},
      {{ 2 }, { "aaaa"  , "a" , 2, -1 }},
      {{ 2 }, { "aaaa"  , "aa",       }},
      {{ 2 }, { "aaaaaa", "a" , 2, 4  }},
      {{ 5 }, { "abcd"  , ""  ,       }},
      {{ 2 }, { "abcd"  , ""  , 2, 3  }},
      {{ 0 }, { "abcd"  , "a" , 3, 2  }},
    },
    endswith = {
      {{ true  }, { "hello.lua", ".lua"             }},
      {{ false }, { "hello.lua", ".lua", 1, 6       }},
      {{ false }, { "hello.lua", ".txt"             }},
      {{ true  }, { "hello.lua", ""                 }},
      {{ true  }, { "hello.lua", { ".txt", ".lua" } }},
    },
    expandtabs = {
      {{ "A       B" }, { "A\tB"         ,   }},
      {{ "A       B" }, { "A\tB"         , 8 }},
      {{ "AB C"      }, { "AB\tC"        , 1 }},
      {{ "AB  C"     }, { "AB\tC"        , 2 }},
      {{ "Hello"     }, { "H\te\tl\tl\to", 0 }},
      {{ "H e l l o" }, { "H\te\tl\tl\to", 1 }},
      {{ "H e l l o" }, { "H\te\tl\tl\to", 2 }},
    },
    find = {
      {{ 1   }, { "banana", ""  ,       }},
      {{ nil }, { "banana", ""  , 3, 2  }},
      {{ 4   }, { "banana", ""  , 4     }},
      {{ 3   }, { "banana", "na",       }},
      {{ 5   }, { "banana", "na", -2    }},
      {{ 5   }, { "banana", "na", -3    }},
      {{ 3   }, { "banana", "na", 2, -2 }},
      {{ nil }, { "banana", "na", 3, -3 }},
      {{ 5   }, { "banana", "na", 4     }},
      {{ nil }, { "banana", "na", 4, 4  }},
      {{ nil }, { "banana", "na", 4, 5  }},
      {{ nil }, { "banana", "zz",       }},
    },
    format_map = {
      {{ "1-true"    }, { "{a}-{b}"    , { a = 1, b = true } }},
      {{ "a y b y"   }, { "a {x} b {x}", { x = "y" }         }},
      {{ "hi nil"    }, { "hi {name}"  , {}                  }},
      {{ "hi bob"    }, { "hi {name}"  , { name = "bob" }    }},
      {{ "hi nil"    }, { "hi {name}"  , {}                  }},
      {{ "no braces" }, { "no braces"  , { a = 1 }           }},
      {{ "xZy"       }, { "x{}y"       , { [""] = "Z" }      }},
    },
    isalnum = {
      {{ false }, { ""        }},
      {{ true  }, { "123"     }},
      {{ false }, { "a-1"     }},
      {{ false }, { "a1 "     }},
      {{ false }, { "á1"      }},
      {{ false }, { "abc_123" }},
      {{ true  }, { "abc"     }},
      {{ true  }, { "abc123"  }},
    },
    isalpha = {
      {{ false  }, { ""     }},
      {{ false  }, { "a b"  }},
      {{ false  }, { "á"    }},
      {{ true   }, { "A"    }},
      {{ true   }, { "abc"  }},
      {{ false  }, { "abc1" }},
    },
    isascii = {
      {{ true  }, { ""    }},
      {{ true  }, { "\n"  }},
      {{ true  }, { "~"   }},
      {{ false }, { "á"   }},
      {{ true  }, { "abc" }},
    },
    isdecimal = {
      {{ false }, { " 1"  }},
      {{ false }, { ""    }},
      {{ true  }, { "01"  }},
      {{ false }, { "١٢٣" }},
      {{ true  }, { "123" }},
      {{ false }, { "12a" }},
    },
    isidentifier = {
      {{ true  }, { "_"        }},
      {{ false }, { "[var"     }},
      {{ false }, { "2var"     }},
      {{ false }, { "end"      }},
      {{ false }, { "function" }},
      {{ false }, { "local"    }},
      {{ false }, { "nil"      }},
      {{ true  }, { "var"      }},
      {{ false }, { "var)"     }},
    },
    islower = {
      {{ false }, { ""       }},
      {{ false }, { "123"    }},
      {{ true  }, { "a c"    }},
      {{ false }, { "abC"    }},
      {{ true  }, { "abc"    }},
      {{ true  }, { "abc123" }},
    },
    isprintable = {
      {{ true  }, { " "    }},
      {{ true  }, { ""     }},
      {{ false }, { "\t"   }},
      {{ false }, { "á"    }},
      {{ false }, { "a\n"  }},
      {{ true  }, { "abc!" }},
    },
    isspace = {
      {{ true  }, { " \t"  }},
      {{ false }, { " a"   }},
      {{ false }, { ""     }},
      {{ true  }, { "\n\r" }},
      {{ true  }, { "\v"   }},
    },
    istitle = {
      {{ false }, { "_"           }},
      {{ false }, { "..."         }},
      {{ false }, { ""            }},
      {{ false }, { "123"         }},
      {{ false }, { "hello World" }},
      {{ false }, { "Hello world" }},
      {{ false }, { "HELLO World" }},
      {{ true  }, { "Hello World" }},
      {{ true  }, { "Hello-World" }},
    },
    isupper = {
      {{ false }, { ""        }},
      {{ false }, { "123"     }},
      {{ true  }, { "ABC 123" }},
      {{ false }, { "AbC"     }},
      {{ true  }, { "ABC123"  }},
    },
    join = {
      {{ "a"   }, { "-", { "a" }      }},
      {{ "a,b" }, { ",", { "a", "b" } }},
      {{ ""    }, { ",", {}           }},
      {{ "ab"  }, { "" , { "a", "b" } }},
    },
    ljust = {
      {{ "hi"    }, { "hi", 2,     }},
      {{ "hi  "  }, { "hi", 4,     }},
      {{ "hi..." }, { "hi", 5, "." }},
    },
    lower = {
      {{ ""            }, { ""            }},
      {{ "123"         }, { "123"         }},
      {{ "hello world" }, { "HELLO WORLD" }},
      {{ "hello"       }, { "HeLLo"       }},
    },
    lstrip = {
      {{ "hello" }, { "  hello",       }},
      {{ "hello" }, { "--hello", "-"   }},
      {{ ""      }, { ""       ,       }},
      {{ "abc"   }, { "abc"    , ""    }},
      {{ "bcabc" }, { "abcabc" , "ac"  }},
      {{ "abc"   }, { "]^-abc" , "]^-" }},
      {{ "abc"   }, { "xxabc"  , "xy"  }},
    },
    partition = {
      {{ ""   , "-", "abc" }, { "-abc" , "-" }},
      {{ "a"  , "-", "b-c" }, { "a-b-c", "-" }},
      {{ "abc", "-", ""    }, { "abc-" , "-" }},
      {{ "abc", "" , ""    }, { "abc"  , "-" }},
    },
    removeprefix = {
      {{ "foo"    }, { "foo"   , ""    }},
      {{ ""       }, { "foo"   , "foo" }},
      {{ "foobar" }, { "foobar", "baz" }},
      {{ "bar"    }, { "foobar", "foo" }},
    },
    removesuffix = {
      {{ "bar"    }, { "bar"   , ""    }},
      {{ ""       }, { "bar"   , "bar" }},
      {{ "foo"    }, { "foobar", "bar" }},
      {{ "foobar" }, { "foobar", "baz" }},
    },
    replace = {
      {{ "a_b_c" }, { "a-b-c", "-", "_"    }},
      {{ "a_b-c" }, { "a-b-c", "-", "_", 1 }},
      {{ "-a-bc" }, { "abc"  , "" , "-", 2 }},
      {{ "abc"   }, { "abc"  , "a", "b", 0 }},
    },
    rfind = {
      {{ 5 }, { "ababa", ""          }},
      {{ 4 }, { "ababa", "ba"        }},
      {{ 2 }, { "ababa", "ba", 1, 4  }},
      {{ 4 }, { "ababa", "ba", 2, -1 }},
      {{   }, { "ababa", "zz"        }},
    },
    rjust = {
      {{ "  hi" }, { "hi", 4,     }},
      {{ "..hi" }, { "hi", 4, "." }},
    },
    rpartition = {
      {{ ""   , "-", "abc" }, { "-abc" , "-" }},
      {{ "a-b", "-", "c"   }, { "a-b-c", "-" }},
      {{ "abc", "-", ""    }, { "abc-" , "-" }},
      {{ ""   , "" , "abc" }, { "abc"  , "-" }},
    },
    rsplit = {
      {{ { "a,b", "c" } }, { "a,b,c", ",", 1 }},
      {{ { "a,b" }      }, { "a,b"  , ",", 0 }},
    },
    rstrip = {
      {{ "--hello" }, { "--hello--", "-"   }},
      {{ "abc"     }, { "abc-^]"   , "]^-" }},
      {{ "abc"     }, { "abc"      , ""    }},
      {{ "hello"   }, { "hello  "  ,       }},
    },
    split = {
      {{ { "a", "b", "c" } }, { " a  b\tc ",        }},
      {{ { "" }            }, { ""         , ",",   }},
      {{ { "a", "b", "c" } }, { "a b  c"   ,        }},
      {{ { "a", "", "b" }  }, { "a,,b"     , ",",   }},
      {{ { "a", "b", "c" } }, { "a,b,c"    , ",",   }},
      {{ { "a", "b,c" }    }, { "a,b,c"    , ",", 1 }},
      {{ { "a,b" }         }, { "a,b"      , ",", 0 }},
    },
    splitlines = {
      {{ {}                      }, { ""         ,      }},
      {{ { "a", "b", "c" }       }, { "a\nb\r\nc",      }},
      {{ { "a\n", "b\r\n", "c" } }, { "a\nb\r\nc", true }},
    },
    startswith = {
      {{ true  }, { "hello.lua", ""            ,   }},
      {{ true  }, { "hello.lua", "he"          ,   }},
      {{ false }, { "hello.lua", "he"          , 2 }},
      {{ false }, { "hello.lua", "lo"          ,   }},
      {{ true  }, { "hello.lua", { "lo", "he" },   }},
    },
    strip = {
      {{ "hello" }, { "  hello  "  ,       }},
      {{ "hello" }, { "..hello.."  , "."   }},
      {{ "hello" }, { "]^-hello-^]", "]^-" }},
      {{ "abc"   }, { "abc"        , ""    }},
    },
    swapcase = {
      {{ ""    }, { ""    }},
      {{ "123" }, { "123" }},
      {{ "A1b" }, { "a1B" }},
      {{ "aBc" }, { "AbC" }},
    },
    title = {
      {{ ""            }, { ""            }},
      {{ "123Abc"      }, { "123abc"      }},
      {{ "Hello World" }, { "hello world" }},
      {{ "Hello World" }, { "HELLO WORLD" }},
      {{ "Hello-World" }, { "hello-world" }},
      {{ "Hello"       }, { "heLLo"       }},
    },
    translate = {
      {{ "cb" }, { "ab" , { [byte("a")] = byte("c") }                                   }},
      {{ "xc" }, { "abc", { [byte("a")] = "x", ["b"] = false }                          }},
      {{ "be" }, { "acd", { [byte("a")] = "b", ["c"] = false, [byte("d")] = byte("e") } }},
    },
    upper = {
      {{ ""       }, { ""       }},
      {{ "123"    }, { "123"    }},
      {{ "HELLO!" }, { "HeLLo!" }},
      {{ "HELLO"  }, { "HeLLo"  }},
    },
    zfill = {
      {{ "-0042" }, { "-42", 5 }},
      {{ "+0042" }, { "+42", 5 }},
      {{ "123"   }, { "123", 2 }},
      {{ "00042" }, { "42" , 5 }},
    },
  })

  -- stylua: ignore
  local tests = {
    -----fname----|-------params-------
    { "split"     , { "a b" ,        }},
    { "split"     , { "a,b" , ","    }},
    { "split"     , { "a,b" , ",", 0 }},
    { "rsplit"    , { "a b" ,        }},
    { "rsplit"    , { "a,b" , ","    }},
    { "rsplit"    , { "a,b" , ",", 0 }},
    { "splitlines", { ""    ,        }},
    { "splitlines", { "a\nb",        }},
    { "splitlines", { "a\nb", true   }},
  }

  for i = 1, #tests do
    local fname, params = unpack(tests[i] --[[@as {[1]:string, [2]:any[]}]])
    it(fmt("%s(%s) returns mods.List", fname, args_repr(params)), function()
      local res = str[fname](unpack(params))
      assert.is_list(res)
    end)
  end
end)
