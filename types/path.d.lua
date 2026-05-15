---@meta mods.path

---@module "mods.fs"
local fs

---
---Cross-platform path operations with host-platform semantics.
---
---## Usage
---
---```lua
---path = require "mods.path"
---
---print(path.join("src", "mods", "path.lua")) --> "src/mods/path.lua"
---print(path.normpath("a//b/./c"))            --> "a/b/c"
---print(path.splitext("archive.tar.gz"))      --> "archive.tar", ".gz"
---```
---
---@class mods.path
local M = {}

---
---Split extension from a path.
---
---@param path string
---@param sep string
---@param altsep? string
---@param extsep string
---@return string root
---@return string ext
---@private
function M._splitext(path, sep, altsep, extsep) end

---
---Normalize path case using the active path semantics.
---
---```lua
---path.normcase("ABC")  --> "abc"
---path.normcase("/A/B") --> "\\a\\b"
---```
---
---> [!NOTE]
--->
---> On POSIX semantics this returns the input unchanged. Use `mods.ntpath` to
---> force Windows-style case folding and separator normalization.
---
---@section Normalization
---@param s string Input path value.
---@return string normalizedPath Path after case normalization.
---@nodiscard
function M.normcase(s) end

---
---Join path components.
---
---```lua
---path.join("/usr", "bin")   --> "/usr/bin"
---path.join([[C:/a]], [[b]]) --> [[C:/a\b]]
---```
---
---> [!NOTE]
--->
---> Single input is returned as-is.
---
---@section Normalization
---@param path string Base path component.
---@param ... string Additional path components.
---@return string joinedPath Joined path.
---@nodiscard
function M.join(path, ...) end

---
---Normalize separators and dot segments.
---
---```lua
---path.normpath("/a//./b/..")   --> "/a"
---path.normpath([[A/foo/../B]]) --> [[A\B]]
---```
---
---@section Normalization
---@param path string Path to normalize.
---@return string normalizedPath Normalized path.
---@nodiscard
function M.normpath(path) end

---Return `true` when `path` is absolute.
---
---```lua
---path.isabs("/a/b") --> true
---```
---
---@section Normalization
---@param path string Input path.
---@return boolean isAbsolute True when `path` is absolute.
---@nodiscard
function M.isabs(path) end

---
---Split path into directory head and tail component.
---
---```lua
---path.split("/a/b.txt") --> "/a", "b.txt"
---```
---
---@section Decomposition
---@param path string Input path.
---@return string head Directory portion.
---@return string tail Final path component.
---@nodiscard
function M.split(path) end

---
---Split path into a root and extension.
---
---```lua
---path.splitext("archive.tar.gz") --> "archive.tar", ".gz"
---```
---
---@section Decomposition
---@param path string Input path.
---@return string root Path without the final extension.
---@return string ext Final extension including leading dot.
---@nodiscard
function M.splitext(path) end

---
---Split drive prefix from remainder.
---
---```lua
---path.splitdrive("/a/b") --> "", "/a/b"
---```
---
---> [!NOTE]
--->
---> On POSIX semantics the drive portion is always empty.
---
---@section Decomposition
---@param path string Input path.
---@return string drive Drive or share prefix when present.
---@return string rest Path remainder.
---@nodiscard
function M.splitdrive(path) end

---
---Split path into drive, root, and tail components.
---
---```lua
---path.splitroot("/a/b")     --> "", "/", "a/b"
---path.splitroot([[C:\a\b]]) --> "C:", [[\]], "a\\b"
---```
---
---@section Decomposition
---@param path string Path to split.
---@return string drive Drive or share prefix (empty on POSIX).
---@return string root Root separator segment.
---@return string tail Remaining path without leading root separator.
---@nodiscard
function M.splitroot(path) end

---
---Return final path component.
---
---```lua
---path.basename("/a/b.txt")     --> "b.txt"
---path.basename([[C:\a\b.txt]]) --> "b.txt"
---```
---
---@section Decomposition
---@param path string Path to inspect.
---@return string basename Final path component.
---@nodiscard
function M.basename(path) end

---
---Return directory portion of a path.
---
---```lua
---path.dirname("/a/b.txt")     --> "/a"
---path.dirname([[C:\a\b.txt]]) --> [[C:\a]]
---```
---
---@section Decomposition
---@param path string Path to inspect.
---@return string dirname Parent directory path.
---@nodiscard
function M.dirname(path) end

---
---Expand `~` home segment when available.
---
---```lua
---path.expanduser("~/tmp") --> "<HOME>/tmp" (when HOME is set)
---path.expanduser([[x\y]]) --> [[x\y]]
---```
---
---@section Environment
---@param path string Path that may begin with `~`.
---@return string? expandedPath Path with the home segment expanded when available.
---@return string? err Error message when `~` expansion cannot be resolved.
---@nodiscard
function M.expanduser(path) end

---
---Expand vars in a path (`$VAR`/`${VAR}` everywhere, `%VAR%` on Windows).
---
---```lua
---path.expandvars("$HOME/bin")               --> "/home/me/bin"
---path.expandvars("${XDG_CONFIG_HOME}/nvim") --> "/home/me/.config/nvim"
---path.expandvars("%USERPROFILE%\\bin")      --> "C:\\Users\\me\\bin"
---path.expandvars("$UNKNOWN/bin")            --> "$UNKNOWN/bin"
---```
---
---@section Environment
---@param path string Path containing variable placeholders.
---@return string expandedPath Path with variable values substituted.
---@nodiscard
function M.expandvars(path) end

---
---Return the current user's home directory path.
---
---```lua
---path.home()
---```
---
---@section Environment
---@return string? homePath Home directory path when available.
---@return string? err Error message when the home directory cannot be resolved.
---@nodiscard
function M.home() end

---Return the current working directory path.
---@section Environment
M.cwd = fs.cwd

---
---Return normalized absolute path.
---
---```lua
---path.abspath("/a/./b")      --> "/a/b"
---path.abspath([[C:\a\..\b]]) --> [[C:\b]]
---```
---
---@section Derived
---@param path string Path to absolutize.
---@return string absolutePath Absolute normalized path.
---@nodiscard
function M.abspath(path) end

---
---Return `path` relative to optional `start` path.
---
---```lua
---path.relpath("/a/b/c", "/a")         --> "b/c"
---path.relpath([[C:\a\b\c]], [[C:\a]]) --> [[b\c]]
---```
---
---@section Derived
---@param path string Input path.
---@param start? string Optional base path.
---@return string? relativePath Relative path from `start` to `path`.
---@return string? err Error message when the path cannot be made relative.
---@nodiscard
function M.relpath(path, start) end

---
---Return longest common sub-path from a path list.
---
---```lua
---path.commonpath({ "/a/b/c", "/a/b/d" })         --> "/a/b"
---path.commonpath({ [[C:\a\b\c]], [[c:/a/b/d]] }) --> [[C:\a\b]]
---```
---
---@section Derived
---@param paths string[] List of paths.
---@return string? commonPath Longest common sub-path.
---@return string? err Error message when inputs are incompatible.
---@nodiscard
function M.commonpath(paths) end

---
---Return longest common leading string prefix.
---
---```lua
---path.commonprefix({"abc", "abd"})                         --> "ab"
---path.commonprefix({"/home/swen/spam", "/home/swen/eggs"}) --> "/home/swen/"
---path.commonprefix({"abc", "xyz"})                         --> ""
---```
---
---@section Derived
---@param paths string[] List of paths.
---@return string commonPrefix Longest common string prefix.
---@nodiscard
function M.commonprefix(paths) end

---
---Return drive prefix when present.
---
---```lua
---path.drive("c:a/b") --> "c:"
---path.drive("a/b")   --> ""
---```
---
---@section Anchors
---@param path string Input path.
---@return string drivePrefix Drive prefix.
---@nodiscard
function M.drive(path) end

---
---Return root separator segment when present.
---
---```lua
---path.root("/tmp/a.txt") --> "/"
---path.root("c:/")        --> "\\"
---path.root("a/b")        --> ""
---```
---
---@section Anchors
---@param path string Input path.
---@return string rootSeparator Root separator segment.
---@nodiscard
function M.root(path) end

---
---Return drive and root combined.
---
---```lua
---path.anchor("c:\\") --> "c:\\"
---```
---
---@section Anchors
---@param path string Input path.
---@return string anchor Drive and root anchor.
---@nodiscard
function M.anchor(path) end

---
---Split path into logical parts, including anchor when present.
---
---```lua
---path.parts("a/b.txt") --> {"a", "b.txt"}
---path.parts("/a/b")    --> {"/", "a", "b"}
---path.parts("c:a\\b")  --> {"c:", "a", "b"}
---```
---
---@section Components
---@param path string Input path.
---@return mods.List<string> paths Path parts including anchor when present.
---@nodiscard
function M.parts(path) end

---
---Return filename without its final suffix.
---
---```lua
---path.stem("archive.tar.gz") --> "archive.tar"
---path.stem("c:a/b")          --> "b"
---```
---
---@section Components
---@param path string Input path.
---@return string stem Filename stem.
---@nodiscard
function M.stem(path) end

---
---Return all filename suffixes in order.
---
---```lua
---path.suffixes("archive.tar.gz") --> {".tar", ".gz"}
---path.suffixes("a/b")            --> {}
---```
---
---@section Components
---@param path string Input path.
---@return mods.List<string> suffixes Filename suffixes.
---@nodiscard
function M.suffixes(path) end

---
---Return logical parent paths from nearest to farthest.
---
---```lua
---path.parents("a/b/c") --> {"a/b", "a", "."}
---path.parents("c:a/b") --> {"c:a", "c:"}
---```
---
---@section Components
---@param path string Input path.
---@return mods.List<string> parents Ancestor paths from nearest to farthest.
---@nodiscard
function M.parents(path) end

---
---Return `path` relative to `other`, or `nil` with an error when it is not under `other`.
---
---When `walk_up` is `true`, allow `..` segments to walk up to a shared prefix.
---
---```lua
---path.relative_to("/a/b/c.txt", "/a")   --> "b/c.txt"
---path.relative_to("/a/b", "/a/c", true) --> "../b"
---path.relative_to("/a/b", "/a/x")       --> nil, "'/a/b' is not in the subpath of '/a/x'"
---```
---
---@section Relations
---@param path string Input path.
---@param other string Reference path.
---@param walk_up? boolean Allow walking up to a shared prefix.
---@return string? relativePath Path relative to `other`, or `nil` on error.
---@return string? err Error message when the path cannot be made relative.
---@nodiscard
function M.relative_to(path, other, walk_up) end

---
---Return `true` when `path` is under `other`.
---
---```lua
---path.is_relative_to("a/b/c", "a/b") --> true
---path.is_relative_to("C:A/B", "c:a") --> true
---path.is_relative_to("a/b", "a/b/c") --> false
---```
---
---@section Relations
---@param path string Input path.
---@param other string Reference path.
---@return boolean isRelative True when `path` is under `other`.
---@nodiscard
function M.is_relative_to(path, other) end

---
---Return a path with the final filename replaced.
---
---```lua
---path.with_name("a/b", "c.txt")     --> "a/c.txt"
---path.with_name("a/b.txt", "c.lua") --> "a/c.lua"
---path.with_name("a/b", "c/d")       --> nil, "invalid name 'c/d'"
---path.with_name("/", "d.xml")       --> nil, "'/' has an empty name"
---```
---
---@section Relations
---@param path string Input path.
---@param name string Replacement filename.
---@return string? updatedPath Path with replaced filename, or `nil` on error.
---@return string? err Error message when replacement fails.
---@nodiscard
function M.with_name(path, name) end

---
---Return a path with the final filename stem replaced.
---
---```lua
---path.with_stem("a/b", "d")     --> "/a/d"
---path.with_stem("a/b.lua", "d") --> "/a/d.lua"
---path.with_stem("/", "d")       --> "'/' has an empty name"
---path.with_stem("a/b", "d")     --> "invalid name ''."
---```
---
---@section Relations
---@param path string Input path.
---@param stem string Replacement filename stem.
---@return string? updatedPath Path with replaced filename stem, or `nil` on error.
---@return string? err Error message when replacement fails.
---@nodiscard
function M.with_stem(path, stem) end

---
---Return a path with the final filename suffix replaced.
---
---```lua
---path.with_suffix("a/b", ".gz")     --> "a/b/.gz"
---path.with_suffix("a/b.gz", ".lua") --> "a/b/.lua"
---path.with_suffix("a/b", "gz")      --> nil, "invalid suffix 'gz'"
---path.with_suffix("//a/b", "gz")    --> nil, "'//a/b' has an empty name"
---```
---
---@section Relations
---@param path string Input path.
---@param suffix string Replacement suffix.
---@return string? updatedPath Path with replaced suffix, or `nil` on error.
---@return string? err Error message when replacement fails.
---@nodiscard
function M.with_suffix(path, suffix) end

---
---Convert backslashes (`\`) to forward slashes (`/`).
---
---```lua
---path.as_posix("a\\b\\c") --> "a/b/c"
---```
---
---@section Conversions
---@param path string Input path.
---@return string posixPath POSIX-style path.
---@nodiscard
function M.as_posix(path) end

---
---Convert a local path to a `file://` URI.
---
---```lua
---path.as_uri("/home/user/report.txt") --> "file:///home/user/report.txt"
---path.as_uri("c:/a/b.c")              --> "file:///c:/a/b.c"
---path.as_uri("/a/b%#c")               --> "file:///a/b%25%23c"
---```
---
---@section Conversions
---@param path string Input path.
---@return string? fileUri File URI.
---@return string? err Error message when conversion fails.
---@nodiscard
function M.as_uri(path) end

---
---Convert a `file://` URI to a local absolute path.
---
---```lua
---path.from_uri("file://localhost/tmp/a.txt") --> "/tmp/a.txt"
---```
---
---@section Conversions
---@param uri string URI value.
---@return string? path Resolved absolute path.
---@return string? err Error message when conversion fails.
function M.from_uri(uri) end

return M
