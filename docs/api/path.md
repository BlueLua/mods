---
title: "path"
description: "Cross-platform path operations with host-platform semantics."
---

Cross-platform path operations with host-platform semantics.

## Usage

```lua
path = mods.path

print(path.join("src", "mods", "path.lua")) --> "src/mods/path.lua"
print(path.normpath("a//b/./c"))            --> "a/b/c"
print(path.splitext("archive.tar.gz"))      --> "archive.tar", ".gz"
```

## Functions

| Function                                  | Description                  |
| ----------------------------------------- | ---------------------------- |
| [`_splitext(path, sep, altsep?, extsep)`] | Split extension from a path. |

**Anchors**:

| Function         | Description                                 |
| ---------------- | ------------------------------------------- |
| [`anchor(path)`] | Return drive and root combined.             |
| [`drive(path)`]  | Return drive prefix when present.           |
| [`root(path)`]   | Return root separator segment when present. |

**Components**:

| Function           | Description                                                   |
| ------------------ | ------------------------------------------------------------- |
| [`parents(path)`]  | Return logical parent paths from nearest to farthest.         |
| [`parts(path)`]    | Split path into logical parts, including anchor when present. |
| [`stem(path)`]     | Return filename without its final suffix.                     |
| [`suffixes(path)`] | Return all filename suffixes in order.                        |

**Conversions**:

| Function           | Description                                         |
| ------------------ | --------------------------------------------------- |
| [`as_posix(path)`] | Convert backslashes (`\`) to forward slashes (`/`). |
| [`as_uri(path)`]   | Convert a local path to a `file://` URI.            |
| [`from_uri(uri)`]  | Convert a `file://` URI to a local absolute path.   |

**Decomposition**:

| Function             | Description                                        |
| -------------------- | -------------------------------------------------- |
| [`basename(path)`]   | Return final path component.                       |
| [`dirname(path)`]    | Return directory portion of a path.                |
| [`split(path)`]      | Split path into directory head and tail component. |
| [`splitdrive(path)`] | Split drive prefix from remainder.                 |
| [`splitext(path)`]   | Split path into a root and extension.              |
| [`splitroot(path)`]  | Split path into drive, root, and tail components.  |

**Derived**:

| Function                  | Description                                      |
| ------------------------- | ------------------------------------------------ |
| [`abspath(path)`]         | Return normalized absolute path.                 |
| [`commonpath(paths)`]     | Return longest common sub-path from a path list. |
| [`commonprefix(paths)`]   | Return longest common leading string prefix.     |
| [`relpath(path, start?)`] | Return `path` relative to optional `start` path. |

**Environment**:

| Function             | Description                                                             |
| -------------------- | ----------------------------------------------------------------------- |
| `cwd`                | Return the current working directory path.                              |
| [`expanduser(path)`] | Expand `~` home segment when available.                                 |
| [`expandvars(path)`] | Expand vars in a path (`$VAR`/`${VAR}` everywhere, `%VAR%` on Windows). |
| [`home()`]           | Return the current user's home directory path.                          |

**Normalization**:

| Function            | Description                                          |
| ------------------- | ---------------------------------------------------- |
| [`isabs(path)`]     | Return `true` when `path` is absolute.               |
| [`join(path, ...)`] | Join path components.                                |
| [`normcase(s)`]     | Normalize path case using the active path semantics. |
| [`normpath(path)`]  | Normalize separators and dot segments.               |

**Relations**:

| Function                               | Description                                                                             |
| -------------------------------------- | --------------------------------------------------------------------------------------- |
| [`is_relative_to(path, other)`]        | Return `true` when `path` is under `other`.                                             |
| [`relative_to(path, other, walk_up?)`] | Return `path` relative to `other`, or `nil` with an error when it is not under `other`. |
| [`with_name(path, name)`]              | Return a path with the final filename replaced.                                         |
| [`with_stem(path, stem)`]              | Return a path with the final filename stem replaced.                                    |
| [`with_suffix(path, suffix)`]          | Return a path with the final filename suffix replaced.                                  |

### `_splitext(path, sep, altsep?, extsep)` {#splitext}

Split extension from a path. **Parameters**:

- `path` (`string`)
- `sep` (`string`)
- `altsep?` (`string`)
- `extsep` (`string`)

**Returns**:

- `root` (`string`)
- `ext` (`string`)

---

### Anchors

#### `anchor(path)` {#anchor}

Return drive and root combined.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `anchor` (`string`): Drive and root anchor.

**Example**:

```lua
path.anchor("c:\\") --> "c:\\"
```

---

#### `drive(path)` {#drive}

Return drive prefix when present.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `drivePrefix` (`string`): Drive prefix.

**Example**:

```lua
path.drive("c:a/b") --> "c:"
path.drive("a/b")   --> ""
```

---

#### `root(path)` {#root}

Return root separator segment when present.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `rootSeparator` (`string`): Root separator segment.

**Example**:

```lua
path.root("/tmp/a.txt") --> "/"
path.root("c:/")        --> "\\"
path.root("a/b")        --> ""
```

---

### Components

#### `parents(path)` {#parents}

Return logical parent paths from nearest to farthest.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `parents` ([`mods.List`]`<string>`): Ancestor paths from nearest to farthest.

**Example**:

```lua
path.parents("a/b/c") --> {"a/b", "a", "."}
path.parents("c:a/b") --> {"c:a", "c:"}
```

---

#### `parts(path)` {#parts}

Split path into logical parts, including anchor when present.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `paths` ([`mods.List`]`<string>`): Path parts including anchor when present.

**Example**:

```lua
path.parts("a/b.txt") --> {"a", "b.txt"}
path.parts("/a/b")    --> {"/", "a", "b"}
path.parts("c:a\\b")  --> {"c:", "a", "b"}
```

---

#### `stem(path)` {#stem}

Return filename without its final suffix.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `stem` (`string`): Filename stem.

**Example**:

```lua
path.stem("archive.tar.gz") --> "archive.tar"
path.stem("c:a/b")          --> "b"
```

---

#### `suffixes(path)` {#suffixes}

Return all filename suffixes in order.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `suffixes` ([`mods.List`]`<string>`): Filename suffixes.

**Example**:

```lua
path.suffixes("archive.tar.gz") --> {".tar", ".gz"}
path.suffixes("a/b")            --> {}
```

---

### Conversions

#### `as_posix(path)` {#as-posix}

Convert backslashes (`\`) to forward slashes (`/`).

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `posixPath` (`string`): POSIX-style path.

**Example**:

```lua
path.as_posix("a\\b\\c") --> "a/b/c"
```

---

#### `as_uri(path)` {#as-uri}

Convert a local path to a `file://` URI.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `fileUri?` (`string`): File URI.
- `err?` (`string`): Error message when conversion fails.

**Example**:

```lua
path.as_uri("/home/user/report.txt") --> "file:///home/user/report.txt"
path.as_uri("c:/a/b.c")              --> "file:///c:/a/b.c"
path.as_uri("/a/b%#c")               --> "file:///a/b%25%23c"
```

---

#### `from_uri(uri)` {#from-uri}

Convert a `file://` URI to a local absolute path.

**Parameters**:

- `uri` (`string`): URI value.

**Returns**:

- `path?` (`string`): Resolved absolute path.
- `err?` (`string`): Error message when conversion fails.

**Example**:

```lua
path.from_uri("file://localhost/tmp/a.txt") --> "/tmp/a.txt"
```

---

### Decomposition

#### `basename(path)` {#basename}

Return final path component.

**Parameters**:

- `path` (`string`): Path to inspect.

**Returns**:

- `basename` (`string`): Final path component.

**Example**:

```lua
path.basename("/a/b.txt")     --> "b.txt"
path.basename([[C:\a\b.txt]]) --> "b.txt"
```

---

#### `dirname(path)` {#dirname}

Return directory portion of a path.

**Parameters**:

- `path` (`string`): Path to inspect.

**Returns**:

- `dirname` (`string`): Parent directory path.

**Example**:

```lua
path.dirname("/a/b.txt")     --> "/a"
path.dirname([[C:\a\b.txt]]) --> [[C:\a]]
```

---

#### `split(path)` {#split}

Split path into directory head and tail component.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `head` (`string`): Directory portion.
- `tail` (`string`): Final path component.

**Example**:

```lua
path.split("/a/b.txt") --> "/a", "b.txt"
```

---

#### `splitdrive(path)` {#splitdrive}

Split drive prefix from remainder.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `drive` (`string`): Drive or share prefix when present.
- `rest` (`string`): Path remainder.

**Example**:

```lua
path.splitdrive("/a/b") --> "", "/a/b"
```

> [!NOTE]
>
> On POSIX semantics the drive portion is always empty.

---

#### `splitext(path)` {#splitext-1}

Split path into a root and extension.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `root` (`string`): Path without the final extension.
- `ext` (`string`): Final extension including leading dot.

**Example**:

```lua
path.splitext("archive.tar.gz") --> "archive.tar", ".gz"
```

---

#### `splitroot(path)` {#splitroot}

Split path into drive, root, and tail components.

**Parameters**:

- `path` (`string`): Path to split.

**Returns**:

- `drive` (`string`): Drive or share prefix (empty on POSIX).
- `root` (`string`): Root separator segment.
- `tail` (`string`): Remaining path without leading root separator.

**Example**:

```lua
path.splitroot("/a/b")     --> "", "/", "a/b"
path.splitroot([[C:\a\b]]) --> "C:", [[\]], "a\\b"
```

---

### Derived

#### `abspath(path)` {#abspath}

Return normalized absolute path.

**Parameters**:

- `path` (`string`): Path to absolutize.

**Returns**:

- `absolutePath` (`string`): Absolute normalized path.

**Example**:

```lua
path.abspath("/a/./b")      --> "/a/b"
path.abspath([[C:\a\..\b]]) --> [[C:\b]]
```

---

#### `commonpath(paths)` {#commonpath}

Return longest common sub-path from a path list.

**Parameters**:

- `paths` (`string[]`): List of paths.

**Returns**:

- `commonPath?` (`string`): Longest common sub-path.
- `err?` (`string`): Error message when inputs are incompatible.

**Example**:

```lua
path.commonpath({ "/a/b/c", "/a/b/d" })         --> "/a/b"
path.commonpath({ [[C:\a\b\c]], [[c:/a/b/d]] }) --> [[C:\a\b]]
```

---

#### `commonprefix(paths)` {#commonprefix}

Return longest common leading string prefix.

**Parameters**:

- `paths` (`string[]`): List of paths.

**Returns**:

- `commonPrefix` (`string`): Longest common string prefix.

**Example**:

```lua
path.commonprefix({"abc", "abd"})                         --> "ab"
path.commonprefix({"/home/swen/spam", "/home/swen/eggs"}) --> "/home/swen/"
path.commonprefix({"abc", "xyz"})                         --> ""
```

---

#### `relpath(path, start?)` {#relpath}

Return `path` relative to optional `start` path.

**Parameters**:

- `path` (`string`): Input path.
- `start?` (`string`): Optional base path.

**Returns**:

- `relativePath?` (`string`): Relative path from `start` to `path`.
- `err?` (`string`): Error message when the path cannot be made relative.

**Example**:

```lua
path.relpath("/a/b/c", "/a")         --> "b/c"
path.relpath([[C:\a\b\c]], [[C:\a]]) --> [[b\c]]
```

---

### Environment

#### `cwd` {#cwd}

## Return the current working directory path.

#### `expanduser(path)` {#expanduser}

Expand `~` home segment when available.

**Parameters**:

- `path` (`string`): Path that may begin with `~`.

**Returns**:

- `expandedPath?` (`string`): Path with the home segment expanded when
  available.
- `err?` (`string`): Error message when `~` expansion cannot be resolved.

**Example**:

```lua
path.expanduser("~/tmp") --> "<HOME>/tmp" (when HOME is set)
path.expanduser([[x\y]]) --> [[x\y]]
```

---

#### `expandvars(path)` {#expandvars}

Expand vars in a path (`$VAR`/`${VAR}` everywhere, `%VAR%` on Windows).

**Parameters**:

- `path` (`string`): Path containing variable placeholders.

**Returns**:

- `expandedPath` (`string`): Path with variable values substituted.

**Example**:

```lua
path.expandvars("$HOME/bin")               --> "/home/me/bin"
path.expandvars("${XDG_CONFIG_HOME}/nvim") --> "/home/me/.config/nvim"
path.expandvars("%USERPROFILE%\\bin")      --> "C:\\Users\\me\\bin"
path.expandvars("$UNKNOWN/bin")            --> "$UNKNOWN/bin"
```

---

#### `home()` {#home}

Return the current user's home directory path.

**Returns**:

- `homePath?` (`string`): Home directory path when available.
- `err?` (`string`): Error message when the home directory cannot be resolved.

**Example**:

```lua
path.home()
```

---

### Normalization

#### `isabs(path)` {#isabs}

Return `true` when `path` is absolute.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `isAbsolute` (`boolean`): True when `path` is absolute.

**Example**:

```lua
path.isabs("/a/b") --> true
```

---

#### `join(path, ...)` {#join}

Join path components.

**Parameters**:

- `path` (`string`): Base path component.
- `...` (`string`): Additional path components.

**Returns**:

- `joinedPath` (`string`): Joined path.

**Example**:

```lua
path.join("/usr", "bin")   --> "/usr/bin"
path.join([[C:/a]], [[b]]) --> [[C:/a\b]]
```

> [!NOTE]
>
> Single input is returned as-is.

---

#### `normcase(s)` {#normcase}

Normalize path case using the active path semantics.

**Parameters**:

- `s` (`string`): Input path value.

**Returns**:

- `normalizedPath` (`string`): Path after case normalization.

**Example**:

```lua
path.normcase("ABC")  --> "abc"
path.normcase("/A/B") --> "\\a\\b"
```

> [!NOTE]
>
> On POSIX semantics this returns the input unchanged. Use [`mods.ntpath`] to
> force Windows-style case folding and separator normalization.

---

#### `normpath(path)` {#normpath}

Normalize separators and dot segments.

**Parameters**:

- `path` (`string`): Path to normalize.

**Returns**:

- `normalizedPath` (`string`): Normalized path.

**Example**:

```lua
path.normpath("/a//./b/..")   --> "/a"
path.normpath([[A/foo/../B]]) --> [[A\B]]
```

---

### Relations

#### `is_relative_to(path, other)` {#is-relative-to}

Return `true` when `path` is under `other`.

**Parameters**:

- `path` (`string`): Input path.
- `other` (`string`): Reference path.

**Returns**:

- `isRelative` (`boolean`): True when `path` is under `other`.

**Example**:

```lua
path.is_relative_to("a/b/c", "a/b") --> true
path.is_relative_to("C:A/B", "c:a") --> true
path.is_relative_to("a/b", "a/b/c") --> false
```

---

#### `relative_to(path, other, walk_up?)` {#relative-to}

Return `path` relative to `other`, or `nil` with an error when it is not under
`other`.

When `walk_up` is `true`, allow `..` segments to walk up to a shared prefix.

**Parameters**:

- `path` (`string`): Input path.
- `other` (`string`): Reference path.
- `walk_up?` (`boolean`): Allow walking up to a shared prefix.

**Returns**:

- `relativePath?` (`string`): Path relative to `other`, or `nil` on error.
- `err?` (`string`): Error message when the path cannot be made relative.

**Example**:

```lua
path.relative_to("/a/b/c.txt", "/a")   --> "b/c.txt"
path.relative_to("/a/b", "/a/c", true) --> "../b"
path.relative_to("/a/b", "/a/x")       --> nil, "'/a/b' is not in the subpath of '/a/x'"
```

---

#### `with_name(path, name)` {#with-name}

Return a path with the final filename replaced.

**Parameters**:

- `path` (`string`): Input path.
- `name` (`string`): Replacement filename.

**Returns**:

- `updatedPath?` (`string`): Path with replaced filename, or `nil` on error.
- `err?` (`string`): Error message when replacement fails.

**Example**:

```lua
path.with_name("a/b", "c.txt")     --> "a/c.txt"
path.with_name("a/b.txt", "c.lua") --> "a/c.lua"
path.with_name("a/b", "c/d")       --> nil, "invalid name 'c/d'"
path.with_name("/", "d.xml")       --> nil, "'/' has an empty name"
```

---

#### `with_stem(path, stem)` {#with-stem}

Return a path with the final filename stem replaced.

**Parameters**:

- `path` (`string`): Input path.
- `stem` (`string`): Replacement filename stem.

**Returns**:

- `updatedPath?` (`string`): Path with replaced filename stem, or `nil` on
  error.
- `err?` (`string`): Error message when replacement fails.

**Example**:

```lua
path.with_stem("a/b", "d")     --> "/a/d"
path.with_stem("a/b.lua", "d") --> "/a/d.lua"
path.with_stem("/", "d")       --> "'/' has an empty name"
path.with_stem("a/b", "d")     --> "invalid name ''."
```

---

#### `with_suffix(path, suffix)` {#with-suffix}

Return a path with the final filename suffix replaced.

**Parameters**:

- `path` (`string`): Input path.
- `suffix` (`string`): Replacement suffix.

**Returns**:

- `updatedPath?` (`string`): Path with replaced suffix, or `nil` on error.
- `err?` (`string`): Error message when replacement fails.

**Example**:

```lua
path.with_suffix("a/b", ".gz")     --> "a/b/.gz"
path.with_suffix("a/b.gz", ".lua") --> "a/b/.lua"
path.with_suffix("a/b", "gz")      --> nil, "invalid suffix 'gz'"
path.with_suffix("//a/b", "gz")    --> nil, "'//a/b' has an empty name"
```

<!-- prettier-ignore-start -->
[`_splitext(path, sep, altsep?, extsep)`]: #splitext
[`abspath(path)`]: #abspath
[`anchor(path)`]: #anchor
[`as_posix(path)`]: #as-posix
[`as_uri(path)`]: #as-uri
[`basename(path)`]: #basename
[`commonpath(paths)`]: #commonpath
[`commonprefix(paths)`]: #commonprefix
[`dirname(path)`]: #dirname
[`drive(path)`]: #drive
[`expanduser(path)`]: #expanduser
[`expandvars(path)`]: #expandvars
[`from_uri(uri)`]: #from-uri
[`home()`]: #home
[`is_relative_to(path, other)`]: #is-relative-to
[`isabs(path)`]: #isabs
[`join(path, ...)`]: #join
[`mods.List`]: /mods/api/list
[`mods.ntpath`]: /mods/api/ntpath
[`normcase(s)`]: #normcase
[`normpath(path)`]: #normpath
[`parents(path)`]: #parents
[`parts(path)`]: #parts
[`relative_to(path, other, walk_up?)`]: #relative-to
[`relpath(path, start?)`]: #relpath
[`root(path)`]: #root
[`split(path)`]: #split
[`splitdrive(path)`]: #splitdrive
[`splitext(path)`]: #splitext-1
[`splitroot(path)`]: #splitroot
[`stem(path)`]: #stem
[`suffixes(path)`]: #suffixes
[`with_name(path, name)`]: #with-name
[`with_stem(path, stem)`]: #with-stem
[`with_suffix(path, suffix)`]: #with-suffix
<!-- prettier-ignore-end -->
