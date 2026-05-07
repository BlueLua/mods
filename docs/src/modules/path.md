---
description: "Cross-platform path operations with host-platform semantics."
---

# `path`

Cross-platform path operations with host-platform semantics.

## Usage

```lua
path = require "mods.path"

print(path.join("src", "mods", "path.lua")) --> "src/mods/path.lua"
print(path.normpath("a//b/./c"))            --> "a/b/c"
print(path.splitext("archive.tar.gz"))      --> "archive.tar", ".gz"
```

## Functions

| Function                                                | Description                  |
| ------------------------------------------------------- | ---------------------------- |
| [`_splitext(path, sep, altsep?, extsep)`](#fn-splitext) | Split extension from a path. |

**Anchors**:

| Function                     | Description                                 |
| ---------------------------- | ------------------------------------------- |
| [`anchor(path)`](#fn-anchor) | Return drive and root combined.             |
| [`drive(path)`](#fn-drive)   | Return drive prefix when present.           |
| [`root(path)`](#fn-root)     | Return root separator segment when present. |

**Components**:

| Function                         | Description                                                   |
| -------------------------------- | ------------------------------------------------------------- |
| [`parents(path)`](#fn-parents)   | Return logical parent paths from nearest to farthest.         |
| [`parts(path)`](#fn-parts)       | Split path into logical parts, including anchor when present. |
| [`stem(path)`](#fn-stem)         | Return filename without its final suffix.                     |
| [`suffixes(path)`](#fn-suffixes) | Return all filename suffixes in order.                        |

**Conversions**:

| Function                         | Description                                         |
| -------------------------------- | --------------------------------------------------- |
| [`as_posix(path)`](#fn-as-posix) | Convert backslashes (`\`) to forward slashes (`/`). |
| [`as_uri(path)`](#fn-as-uri)     | Convert a local path to a `file://` URI.            |
| [`from_uri(uri)`](#fn-from-uri)  | Convert a `file://` URI to a local absolute path.   |

**Decomposition**:

| Function                             | Description                                        |
| ------------------------------------ | -------------------------------------------------- |
| [`basename(path)`](#fn-basename)     | Return final path component.                       |
| [`dirname(path)`](#fn-dirname)       | Return directory portion of a path.                |
| [`split(path)`](#fn-split)           | Split path into directory head and tail component. |
| [`splitdrive(path)`](#fn-splitdrive) | Split drive prefix from remainder.                 |
| [`splitext(path)`](#fn-splitext)     | Split path into a root and extension.              |
| [`splitroot(path)`](#fn-splitroot)   | Split path into drive, root, and tail components.  |

**Derived**:

| Function                                  | Description                                      |
| ----------------------------------------- | ------------------------------------------------ |
| [`abspath(path)`](#fn-abspath)            | Return normalized absolute path.                 |
| [`commonpath(paths)`](#fn-commonpath)     | Return longest common sub-path from a path list. |
| [`commonprefix(paths)`](#fn-commonprefix) | Return longest common leading string prefix.     |
| [`relpath(path, start?)`](#fn-relpath)    | Return `path` relative to optional `start` path. |

**Environment**:

| Function                             | Description                                                             |
| ------------------------------------ | ----------------------------------------------------------------------- |
| `cwd`                                | Return the current working directory path.                              |
| [`expanduser(path)`](#fn-expanduser) | Expand `~` home segment when available.                                 |
| [`expandvars(path)`](#fn-expandvars) | Expand vars in a path (`$VAR`/`${VAR}` everywhere, `%VAR%` on Windows). |
| [`home()`](#fn-home)                 | Return the current user's home directory path.                          |

**Normalization**:

| Function                         | Description                                          |
| -------------------------------- | ---------------------------------------------------- |
| [`isabs(path)`](#fn-isabs)       | Return `true` when `path` is absolute.               |
| [`join(path, ...)`](#fn-join)    | Join path components.                                |
| [`normcase(s)`](#fn-normcase)    | Normalize path case using the active path semantics. |
| [`normpath(path)`](#fn-normpath) | Normalize separators and dot segments.               |

**Relations**:

| Function                                                | Description                                                                             |
| ------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| [`is_relative_to(path, other)`](#fn-is-relative-to)     | Return `true` when `path` is under `other`.                                             |
| [`relative_to(path, other, walk_up?)`](#fn-relative-to) | Return `path` relative to `other`, or `nil` with an error when it is not under `other`. |
| [`with_name(path, name)`](#fn-with-name)                | Return a path with the final filename replaced.                                         |
| [`with_stem(path, stem)`](#fn-with-stem)                | Return a path with the final filename stem replaced.                                    |
| [`with_suffix(path, suffix)`](#fn-with-suffix)          | Return a path with the final filename suffix replaced.                                  |

<a id="fn-splitext"></a>

### `_splitext(path, sep, altsep?, extsep)`

Split extension from a path. **Parameters**:

- `path` (`string`)
- `sep` (`string`)
- `altsep?` (`string`)
- `extsep` (`string`)

**Return**:

- `root` (`string`)
- `ext` (`string`)

### Anchors

<a id="fn-anchor"></a>

#### `anchor(path)`

Return drive and root combined.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `anchor` (`string`): Drive and root anchor.

**Example**:

```lua
path.anchor("c:\\") --> "c:\\"
```

<a id="fn-drive"></a>

#### `drive(path)`

Return drive prefix when present.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `drivePrefix` (`string`): Drive prefix.

**Example**:

```lua
path.drive("c:a/b") --> "c:"
path.drive("a/b")   --> ""
```

<a id="fn-root"></a>

#### `root(path)`

Return root separator segment when present.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `rootSeparator` (`string`): Root separator segment.

**Example**:

```lua
path.root("/tmp/a.txt") --> "/"
path.root("c:/")        --> "\\"
path.root("a/b")        --> ""
```

### Components

<a id="fn-parents"></a>

#### `parents(path)`

Return logical parent paths from nearest to farthest.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `parents` (`mods.List<string>`): Ancestor paths from nearest to farthest.

**Example**:

```lua
path.parents("a/b/c") --> {"a/b", "a", "."}
path.parents("c:a/b") --> {"c:a", "c:"}
```

<a id="fn-parts"></a>

#### `parts(path)`

Split path into logical parts, including anchor when present.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `paths` (`mods.List<string>`): Path parts including anchor when present.

**Example**:

```lua
path.parts("a/b.txt") --> {"a", "b.txt"}
path.parts("/a/b")    --> {"/", "a", "b"}
path.parts("c:a\\b")  --> {"c:", "a", "b"}
```

<a id="fn-stem"></a>

#### `stem(path)`

Return filename without its final suffix.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `stem` (`string`): Filename stem.

**Example**:

```lua
path.stem("archive.tar.gz") --> "archive.tar"
path.stem("c:a/b")          --> "b"
```

<a id="fn-suffixes"></a>

#### `suffixes(path)`

Return all filename suffixes in order.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `suffixes` (`mods.List<string>`): Filename suffixes.

**Example**:

```lua
path.suffixes("archive.tar.gz") --> {".tar", ".gz"}
path.suffixes("a/b")            --> {}
```

### Conversions

<a id="fn-as-posix"></a>

#### `as_posix(path)`

Convert backslashes (`\`) to forward slashes (`/`).

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `posixPath` (`string`): POSIX-style path.

**Example**:

```lua
path.as_posix("a\\b\\c") --> "a/b/c"
```

<a id="fn-as-uri"></a>

#### `as_uri(path)`

Convert a local path to a `file://` URI.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `fileUri` (`string?`): File URI.
- `err` (`string?`): Error message when conversion fails.

**Example**:

```lua
path.as_uri("/home/user/report.txt") --> "file:///home/user/report.txt"
path.as_uri("c:/a/b.c")              --> "file:///c:/a/b.c"
path.as_uri("/a/b%#c")               --> "file:///a/b%25%23c"
```

<a id="fn-from-uri"></a>

#### `from_uri(uri)`

Convert a `file://` URI to a local absolute path.

**Parameters**:

- `uri` (`string`): URI value.

**Return**:

- `path` (`string?`): Resolved absolute path.
- `err` (`string?`): Error message when conversion fails.

**Example**:

```lua
path.from_uri("file://localhost/tmp/a.txt") --> "/tmp/a.txt"
```

### Decomposition

<a id="fn-basename"></a>

#### `basename(path)`

Return final path component.

**Parameters**:

- `path` (`string`): Path to inspect.

**Return**:

- `basename` (`string`): Final path component.

**Example**:

```lua
path.basename("/a/b.txt")     --> "b.txt"
path.basename([[C:\a\b.txt]]) --> "b.txt"
```

<a id="fn-dirname"></a>

#### `dirname(path)`

Return directory portion of a path.

**Parameters**:

- `path` (`string`): Path to inspect.

**Return**:

- `dirname` (`string`): Parent directory path.

**Example**:

```lua
path.dirname("/a/b.txt")     --> "/a"
path.dirname([[C:\a\b.txt]]) --> [[C:\a]]
```

<a id="fn-split"></a>

#### `split(path)`

Split path into directory head and tail component.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `head` (`string`): Directory portion.
- `tail` (`string`): Final path component.

**Example**:

```lua
path.split("/a/b.txt") --> "/a", "b.txt"
```

<a id="fn-splitdrive"></a>

#### `splitdrive(path)`

Split drive prefix from remainder.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `drive` (`string`): Drive or share prefix when present.
- `rest` (`string`): Path remainder.

**Example**:

```lua
path.splitdrive("/a/b") --> "", "/a/b"
```

> [!NOTE]
>
> On POSIX semantics the drive portion is always empty.

<a id="fn-splitext"></a>

#### `splitext(path)`

Split path into a root and extension.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `root` (`string`): Path without the final extension.
- `ext` (`string`): Final extension including leading dot.

**Example**:

```lua
path.splitext("archive.tar.gz") --> "archive.tar", ".gz"
```

<a id="fn-splitroot"></a>

#### `splitroot(path)`

Split path into drive, root, and tail components.

**Parameters**:

- `path` (`string`): Path to split.

**Return**:

- `drive` (`string`): Drive or share prefix (empty on POSIX).
- `root` (`string`): Root separator segment.
- `tail` (`string`): Remaining path without leading root separator.

**Example**:

```lua
path.splitroot("/a/b")     --> "", "/", "a/b"
path.splitroot([[C:\a\b]]) --> "C:", [[\]], "a\\b"
```

### Derived

<a id="fn-abspath"></a>

#### `abspath(path)`

Return normalized absolute path.

**Parameters**:

- `path` (`string`): Path to absolutize.

**Return**:

- `absolutePath` (`string`): Absolute normalized path.

**Example**:

```lua
path.abspath("/a/./b")      --> "/a/b"
path.abspath([[C:\a\..\b]]) --> [[C:\b]]
```

<a id="fn-commonpath"></a>

#### `commonpath(paths)`

Return longest common sub-path from a path list.

**Parameters**:

- `paths` (`string[]`): List of paths.

**Return**:

- `commonPath` (`string?`): Longest common sub-path.
- `err` (`string?`): Error message when inputs are incompatible.

**Example**:

```lua
path.commonpath({ "/a/b/c", "/a/b/d" })         --> "/a/b"
path.commonpath({ [[C:\a\b\c]], [[c:/a/b/d]] }) --> [[C:\a\b]]
```

<a id="fn-commonprefix"></a>

#### `commonprefix(paths)`

Return longest common leading string prefix.

**Parameters**:

- `paths` (`string[]`): List of paths.

**Return**:

- `commonPrefix` (`string`): Longest common string prefix.

**Example**:

```lua
path.commonprefix({"abc", "abd"})                         --> "ab"
path.commonprefix({"/home/swen/spam", "/home/swen/eggs"}) --> "/home/swen/"
path.commonprefix({"abc", "xyz"})                         --> ""
```

<a id="fn-relpath"></a>

#### `relpath(path, start?)`

Return `path` relative to optional `start` path.

**Parameters**:

- `path` (`string`): Input path.
- `start?` (`string`): Optional base path.

**Return**:

- `relativePath` (`string?`): Relative path from `start` to `path`.
- `err` (`string?`): Error message when the path cannot be made relative.

**Example**:

```lua
path.relpath("/a/b/c", "/a")         --> "b/c"
path.relpath([[C:\a\b\c]], [[C:\a]]) --> [[b\c]]
```

### Environment

<a id="fn-cwd"></a>

#### `cwd`

Return the current working directory path. <a id="fn-expanduser"></a>

#### `expanduser(path)`

Expand `~` home segment when available.

**Parameters**:

- `path` (`string`): Path that may begin with `~`.

**Return**:

- `expandedPath` (`string?`): Path with the home segment expanded when
  available.
- `err` (`string?`): Error message when `~` expansion cannot be resolved.

**Example**:

```lua
path.expanduser("~/tmp") --> "<HOME>/tmp" (when HOME is set)
path.expanduser([[x\y]]) --> [[x\y]]
```

<a id="fn-expandvars"></a>

#### `expandvars(path)`

Expand vars in a path (`$VAR`/`${VAR}` everywhere, `%VAR%` on Windows).

**Parameters**:

- `path` (`string`): Path containing variable placeholders.

**Return**:

- `expandedPath` (`string`): Path with variable values substituted.

**Example**:

```lua
path.expandvars("$HOME/bin")               --> "/home/me/bin"
path.expandvars("${XDG_CONFIG_HOME}/nvim") --> "/home/me/.config/nvim"
path.expandvars("%USERPROFILE%\\bin")      --> "C:\\Users\\me\\bin"
path.expandvars("$UNKNOWN/bin")            --> "$UNKNOWN/bin"
```

<a id="fn-home"></a>

#### `home()`

Return the current user's home directory path.

**Return**:

- `homePath` (`string?`): Home directory path when available.
- `err` (`string?`): Error message when the home directory cannot be resolved.

**Example**:

```lua
path.home()
```

### Normalization

<a id="fn-isabs"></a>

#### `isabs(path)`

Return `true` when `path` is absolute.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `isAbsolute` (`boolean`): True when `path` is absolute.

**Example**:

```lua
path.isabs("/a/b") --> true
```

<a id="fn-join"></a>

#### `join(path, ...)`

Join path components.

**Parameters**:

- `path` (`string`): Base path component.
- `...` (`string`): Additional path components.

**Return**:

- `joinedPath` (`string`): Joined path.

**Example**:

```lua
path.join("/usr", "bin")   --> "/usr/bin"
path.join([[C:/a]], [[b]]) --> [[C:/a\b]]
```

> [!NOTE]
>
> Single input is returned as-is.

<a id="fn-normcase"></a>

#### `normcase(s)`

Normalize path case using the active path semantics.

**Parameters**:

- `s` (`string`): Input path value.

**Return**:

- `normalizedPath` (`string`): Path after case normalization.

**Example**:

```lua
path.normcase("ABC")  --> "abc"
path.normcase("/A/B") --> "\\a\\b"
```

> [!NOTE]
>
> On POSIX semantics this returns the input unchanged. Use
> [`mods.ntpath`](/modules/ntpath) to force Windows-style case folding and
> separator normalization.

<a id="fn-normpath"></a>

#### `normpath(path)`

Normalize separators and dot segments.

**Parameters**:

- `path` (`string`): Path to normalize.

**Return**:

- `normalizedPath` (`string`): Normalized path.

**Example**:

```lua
path.normpath("/a//./b/..")   --> "/a"
path.normpath([[A/foo/../B]]) --> [[A\B]]
```

### Relations

<a id="fn-is-relative-to"></a>

#### `is_relative_to(path, other)`

Return `true` when `path` is under `other`.

**Parameters**:

- `path` (`string`): Input path.
- `other` (`string`): Reference path.

**Return**:

- `isRelative` (`boolean`): True when `path` is under `other`.

**Example**:

```lua
path.is_relative_to("a/b/c", "a/b") --> true
path.is_relative_to("C:A/B", "c:a") --> true
path.is_relative_to("a/b", "a/b/c") --> false
```

<a id="fn-relative-to"></a>

#### `relative_to(path, other, walk_up?)`

Return `path` relative to `other`, or `nil` with an error when it is not under
`other`.

When `walk_up` is `true`, allow `..` segments to walk up to a shared prefix.

**Parameters**:

- `path` (`string`): Input path.
- `other` (`string`): Reference path.
- `walk_up?` (`boolean`): Allow walking up to a shared prefix.

**Return**:

- `relativePath` (`string?`): Path relative to `other`, or `nil` on error.
- `err` (`string?`): Error message when the path cannot be made relative.

**Example**:

```lua
path.relative_to("/a/b/c.txt", "/a")   --> "b/c.txt"
path.relative_to("/a/b", "/a/c", true) --> "../b"
path.relative_to("/a/b", "/a/x")       --> nil, "'/a/b' is not in the subpath of '/a/x'"
```

<a id="fn-with-name"></a>

#### `with_name(path, name)`

Return a path with the final filename replaced.

**Parameters**:

- `path` (`string`): Input path.
- `name` (`string`): Replacement filename.

**Return**:

- `updatedPath` (`string?`): Path with replaced filename, or `nil` on error.
- `err` (`string?`): Error message when replacement fails.

**Example**:

```lua
path.with_name("a/b", "c.txt")     --> "a/c.txt"
path.with_name("a/b.txt", "c.lua") --> "a/c.lua"
path.with_name("a/b", "c/d")       --> nil, "invalid name 'c/d'"
path.with_name("/", "d.xml")       --> nil, "'/' has an empty name"
```

<a id="fn-with-stem"></a>

#### `with_stem(path, stem)`

Return a path with the final filename stem replaced.

**Parameters**:

- `path` (`string`): Input path.
- `stem` (`string`): Replacement filename stem.

**Return**:

- `updatedPath` (`string?`): Path with replaced filename stem, or `nil` on
  error.
- `err` (`string?`): Error message when replacement fails.

**Example**:

```lua
path.with_stem("a/b", "d")     --> "/a/d"
path.with_stem("a/b.lua", "d") --> "/a/d.lua"
path.with_stem("/", "d")       --> "'/' has an empty name"
path.with_stem("a/b", "d")     --> "invalid name ''."
```

<a id="fn-with-suffix"></a>

#### `with_suffix(path, suffix)`

Return a path with the final filename suffix replaced.

**Parameters**:

- `path` (`string`): Input path.
- `suffix` (`string`): Replacement suffix.

**Return**:

- `updatedPath` (`string?`): Path with replaced suffix, or `nil` on error.
- `err` (`string?`): Error message when replacement fails.

**Example**:

```lua
path.with_suffix("a/b", ".gz")     --> "a/b/.gz"
path.with_suffix("a/b.gz", ".lua") --> "a/b/.lua"
path.with_suffix("a/b", "gz")      --> nil, "invalid suffix 'gz'"
path.with_suffix("//a/b", "gz")    --> nil, "'//a/b' has an empty name"
```
