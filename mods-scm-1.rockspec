package = "mods"
version = "scm-1"

source = {
  url = "git+https://github.com/BlueLua/mods.git",
}

description = {
  license = "MIT",
}

dependencies = {
  "lua >= 5.1",
}

build = {
  type = "builtin",
  modules = {
    ["mods._compat"] = "src/mods/_compat.lua",
    ["mods._date_duration"] = "src/mods/_date_duration.lua",
    ["mods.assert"] = "src/mods/assert.lua",
    ["mods.calendar"] = "src/mods/calendar.lua",
    ["mods.date"] = "src/mods/date.lua",
    ["mods.duration"] = "src/mods/duration.lua",
    ["mods.fs"] = "src/mods/fs.lua",
    ["mods.glob"] = "src/mods/glob.lua",
    ["mods"] = "src/mods/init.lua",
    ["mods.is"] = "src/mods/is.lua",
    ["mods.json"] = "src/mods/json.lua",
    ["mods.keyword"] = "src/mods/keyword.lua",
    ["mods.list"] = "src/mods/list.lua",
    ["mods.log"] = "src/mods/log.lua",
    ["mods.ntpath"] = "src/mods/ntpath.lua",
    ["mods.operator"] = "src/mods/operator.lua",
    ["mods.path"] = "src/mods/path.lua",
    ["mods.posixpath"] = "src/mods/posixpath.lua",
    ["mods.runtime"] = "src/mods/runtime.lua",
    ["mods.set"] = "src/mods/set.lua",
    ["mods.str"] = "src/mods/str.lua",
    ["mods.stringcase"] = "src/mods/stringcase.lua",
    ["mods.stringify"] = "src/mods/stringify.lua",
    ["mods.tbl"] = "src/mods/tbl.lua",
    ["mods.template"] = "src/mods/template.lua",
    ["mods.utils"] = "src/mods/utils.lua",
    ["mods.validate"] = "src/mods/validate.lua",
    ["mods.types/assert"] = "types/assert.d.lua",
    ["mods.types/calendar"] = "types/calendar.d.lua",
    ["mods.types/date"] = "types/date.d.lua",
    ["mods.types/duration"] = "types/duration.d.lua",
    ["mods.types/fs"] = "types/fs.d.lua",
    ["mods.types/glob"] = "types/glob.d.lua",
    ["mods.types/is"] = "types/is.d.lua",
    ["mods.types/json"] = "types/json.d.lua",
    ["mods.types/keyword"] = "types/keyword.d.lua",
    ["mods.types/list"] = "types/list.d.lua",
    ["mods.types/log"] = "types/log.d.lua",
    ["mods.types/mods"] = "types/mods.d.lua",
    ["mods.types/ntpath"] = "types/ntpath.d.lua",
    ["mods.types/operator"] = "types/operator.d.lua",
    ["mods.types/path"] = "types/path.d.lua",
    ["mods.types/posixpath"] = "types/posixpath.d.lua",
    ["mods.types/runtime"] = "types/runtime.d.lua",
    ["mods.types/set"] = "types/set.d.lua",
    ["mods.types/str"] = "types/str.d.lua",
    ["mods.types/stringcase"] = "types/stringcase.d.lua",
    ["mods.types/stringify"] = "types/stringify.d.lua",
    ["mods.types/tbl"] = "types/tbl.d.lua",
    ["mods.types/template"] = "types/template.d.lua",
    ["mods.types/utils"] = "types/utils.d.lua",
    ["mods.types/validate"] = "types/validate.d.lua",
  },
}
