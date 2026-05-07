---
description: "Filesystem I/O, metadata, and filesystem path operations."
---

# `fs`

Filesystem I/O, metadata, and filesystem path operations.

> [!NOTE]
>
> This module requires
> [LuaFileSystem (`lfs`)](https://github.com/lunarmodules/luafilesystem).

## Usage

```lua
fs = require "mods.fs"

fs.mkdir("tmp/cache/app", true)
fs.write_text("tmp/cache/app/data.txt", "hello")
print(fs.read_text("tmp/cache/app/data.txt")) --> "hello"
```

## Functions

**Existence Checks**:

| Function                       | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| [`exists(path)`](#fn-exists)   | Return `true` when a path exists.                            |
| [`lexists(path)`](#fn-lexists) | Return `true` when a path exists without following symlinks. |

**Filesystem Mutations**:

| Function                                     | Description                                                                   |
| -------------------------------------------- | ----------------------------------------------------------------------------- |
| [`cd(path)`](#fn-cd)                         | Change the current working directory.                                         |
| [`cp(src, dst)`](#fn-cp)                     | Copy a file or directory tree.                                                |
| [`cwd()`](#fn-cwd)                           | Return the current working directory.                                         |
| [`link(path, linkpath)`](#fn-link)           | Create a hard link.                                                           |
| [`mkdir(path, parents?)`](#fn-mkdir)         | Create a directory.                                                           |
| [`rename(oldname, newname)`](#fn-rename)     | Rename or move a filesystem entry.                                            |
| [`rm(path, recursive?)`](#fn-rm)             | Remove a filesystem entry, or a directory tree when `recursive` is `true`.    |
| [`symlink(path, linkpath)`](#fn-symlink)     | Create a symbolic link.                                                       |
| [`touch(path)`](#fn-touch)                   | Create file if missing without truncating, or update timestamps if it exists. |
| [`write_bytes(path, data)`](#fn-write-bytes) | Write full file in binary mode.                                               |
| [`write_text(path, data)`](#fn-write-text)   | Write full file in text mode.                                                 |

**Metadata**:

| Function                         | Description                                                                        |
| -------------------------------- | ---------------------------------------------------------------------------------- |
| [`getatime(path)`](#fn-getatime) | Return last access time.                                                           |
| [`getctime(path)`](#fn-getctime) | Return metadata change time.                                                       |
| [`getmtime(path)`](#fn-getmtime) | Return last modification time.                                                     |
| [`getsize(path)`](#fn-getsize)   | Return file size in bytes.                                                         |
| [`lstat(path)`](#fn-lstat)       | Return symlink-aware file attributes.                                              |
| [`samefile(a, b)`](#fn-samefile) | Return whether two paths refer to the same file, or `nil` and an error on failure. |
| [`stat(path)`](#fn-stat)         | Return file attributes.                                                            |

**Reading**:

| Function                              | Description                            |
| ------------------------------------- | -------------------------------------- |
| [`dir(path, opts?)`](#fn-dir)         | Iterator over items in `path`.         |
| [`listdir(path, opts?)`](#fn-listdir) | Return direct children of a directory. |
| [`read_bytes(path)`](#fn-read-bytes)  | Read full file in binary mode.         |
| [`read_text(path)`](#fn-read-text)    | Read full file in text mode.           |

### Existence Checks

<a id="fn-exists"></a>

#### `exists(path)`

Return `true` when a path exists.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `exists` (`boolean`): True when the path exists.

**Example**:

```lua
fs.exists("README.md") --> true
```

> [!NOTE]
>
> Broken symlinks return `false`.

<a id="fn-lexists"></a>

#### `lexists(path)`

Return `true` when a path exists without following symlinks.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `exists` (`boolean`): True when the path or symlink entry exists.

**Example**:

```lua
fs.lexists("README.md") --> true
```

> [!NOTE]
>
> Broken symlinks return `true`.

### Filesystem Mutations

<a id="fn-cd"></a>

#### `cd(path)`

Change the current working directory.

**Parameters**:

- `path` (`string`): Directory path to switch into.

**Return**:

- `changed` (`true?`): `true` when the directory change succeeds, or `nil` on
  failure.
- `errmsg` (`string?`): Error message when the change fails.

**Example**:

```lua
fs.cd("src")
```

<a id="fn-cp"></a>

#### `cp(src, dst)`

Copy a file or directory tree.

**Parameters**:

- `src` (`string`): Source path.
- `dst` (`string`): Destination path.

**Return**:

- `copied` (`true?`): `true` when copying succeeds, or `nil` on failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.cp("a.txt", "b.txt")
fs.cp("src", "backup/src")
```

<a id="fn-cwd"></a>

#### `cwd()`

Return the current working directory.

**Return**:

- `cwd` (`string?`): Current working directory, or `nil` on failure.
- `errmsg` (`string?`): Error message when the lookup fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.cwd()
```

<a id="fn-link"></a>

#### `link(path, linkpath)`

Create a hard link.

**Parameters**:

- `path` (`string`): Existing path to link to.
- `linkpath` (`string`): New link path to create.

**Return**:

- `linked` (`true?`): `true` when link creation succeeds, or `nil` on failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.link("target.txt", "hardlink.txt")
```

<a id="fn-mkdir"></a>

#### `mkdir(path, parents?)`

Create a directory.

**Parameters**:

- `path` (`string`): Input path.
- `parents?` (`boolean`): Create missing parent directories when `true`.

**Return**:

- `created` (`true?`): `true` when directory creation succeeds, or `nil` on
  failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.mkdir("tmp/a/b", true)
```

<a id="fn-rename"></a>

#### `rename(oldname, newname)`

Rename or move a filesystem entry.

**Parameters**:

- `oldname` (`string`): Existing path.
- `newname` (`string`): Replacement path.

**Return**:

- `renamed` (`true?`): `true` when the rename succeeds, or `nil` on failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.rename("old.txt", "new.txt")
```

> [!NOTE]
>
> This is an alias for `os.rename`.

<a id="fn-rm"></a>

#### `rm(path, recursive?)`

Remove a filesystem entry, or a directory tree when `recursive` is `true`.

**Parameters**:

- `path` (`string`): Input path.
- `recursive?` (`boolean`): Remove a directory tree recursively when `true`.

**Return**:

- `removed` (`true?`): `true` when removal succeeds, or `nil` on failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.rm("tmp.txt") --> true, nil
fs.rm("tmp/cache", true) --> true, nil
```

<a id="fn-symlink"></a>

#### `symlink(path, linkpath)`

Create a symbolic link.

**Parameters**:

- `path` (`string`): Path to reference from the new symlink.
- `linkpath` (`string`): New symlink path to create.

**Return**:

- `linked` (`true?`): `true` when link creation succeeds, or `nil` on failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.symlink("target.txt", "symlink.txt")
```

<a id="fn-touch"></a>

#### `touch(path)`

Create file if missing without truncating, or update timestamps if it exists.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `touched` (`true?`): `true` when the file exists after touch, or `nil` on
  failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.touch("tmp.txt") --> true, nil
```

<a id="fn-write-bytes"></a>

#### `write_bytes(path, data)`

Write full file in binary mode.

**Parameters**:

- `path` (`string`): Input path.
- `data` (`string`): Input data.

**Return**:

- `written` (`true?`): `true` when writing succeeds, or `nil` on failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.write_bytes("tmp.bin", "abc") --> true, nil
```

<a id="fn-write-text"></a>

#### `write_text(path, data)`

Write full file in text mode.

**Parameters**:

- `path` (`string`): Input path.
- `data` (`string`): Input data.

**Return**:

- `written` (`true?`): `true` when writing succeeds, or `nil` on failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.write_text("tmp.txt", "abc") --> true, nil
```

### Metadata

<a id="fn-getatime"></a>

#### `getatime(path)`

Return last access time.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `timestamp` (`number?`): Access time (seconds since epoch).
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.getatime("README.md") --> 1712345678
```

<a id="fn-getctime"></a>

#### `getctime(path)`

Return metadata change time.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `timestamp` (`number?`): Change time (seconds since epoch).
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.getctime("README.md") --> 1712345678
```

<a id="fn-getmtime"></a>

#### `getmtime(path)`

Return last modification time.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `timestamp` (`number?`): Modification time (seconds since epoch).
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.getmtime("README.md") --> 1712345678
```

<a id="fn-getsize"></a>

#### `getsize(path)`

Return file size in bytes.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `size` (`integer?`): File size in bytes.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.getsize("README.md") --> 1234
```

<a id="fn-lstat"></a>

#### `lstat(path)`

Return symlink-aware file attributes.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `attrs` (`LuaFileSystem.Attributes?`): Symlink-aware attributes, or `nil` on
  failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.lstat("README.md")
```

<a id="fn-samefile"></a>

#### `samefile(a, b)`

Return whether two paths refer to the same file, or `nil` and an error on
failure.

**Parameters**:

- `a` (`string`): Input path.
- `b` (`string`): Input path.

**Return**:

- `isSameFile` (`boolean?`): True when both paths refer to the same file.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.samefile("README.md", "README.md") --> true
```

<a id="fn-stat"></a>

#### `stat(path)`

Return file attributes.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `attrs`
  (`string|integer|LuaFileSystem.AttributeMode|LuaFileSystem.Attributes?`): File
  attributes, or `nil` on failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.stat("README.md")
```

### Reading

<a id="fn-dir"></a>

#### `dir(path, opts?)`

Iterator over items in `path`.

**Options**:

- `recursive`: recurse into subdirectories; defaults to `false`.
- `hidden`: include hidden entries; defaults to `true`.
- `follow`: recurse into symlinked directories; defaults to `false`.
- `type`: filter by entry type, such as `"file"` or `"directory"`; defaults to
  `nil`.

**Parameters**:

- `path` (`string`): Input path.
- `opts?`
  (`{hidden?:boolean, recursive?:boolean, follow?:boolean, type?:modsFsEntryType}`):
  Optional traversal options.

**Return**:

- `iterator`
  (`(fun(state:table, prev?:string):basename:string?, type:modsFsEntryType?)?`):
  Iterator, or `nil` on failure.
- `state` (`table|string`): Iterator state on success, or error message on
  failure.

**Example**:

```lua
for name, type in fs.dir(path.cwd(), { recursive = true }) do
  print(name, type)
end
```

<a id="fn-listdir"></a>

#### `listdir(path, opts?)`

Return direct children of a directory.

**Options**:

- `recursive`: recurse into subdirectories; defaults to `false`.
- `hidden`: include hidden entries; defaults to `true`.
- `follow`: recurse into symlinked directories; defaults to `false`.
- `type`: filter by entry type, such as `"file"` or `"directory"`; defaults to
  `nil`.
- `names`: return basenames; defaults to `false`.

**Parameters**:

- `path` (`string`): Input path.
- `opts?`
  (`{hidden?:boolean, recursive?:boolean, follow?:boolean, type?:modsFsEntryType, names?:boolean}`):
  Optional traversal options.

**Return**:

- `paths` (`mods.List<string>?`): Direct child paths, or basenames when
  `opts.names` is `true`.
- `err` (`string?`): Error message when traversal setup fails.

**Example**:

```lua
fs.listdir("src")
fs.listdir("src", { names = true })
```

<a id="fn-read-bytes"></a>

#### `read_bytes(path)`

Read full file in binary mode.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `body` (`string?`): File contents read in binary mode, or `nil` on failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.read_bytes("README.md")
```

<a id="fn-read-text"></a>

#### `read_text(path)`

Read full file in text mode.

**Parameters**:

- `path` (`string`): Input path.

**Return**:

- `body` (`string?`): File contents read in text mode, or `nil` on failure.
- `errmsg` (`string?`): Error message when the check fails.
- `errcode` (`integer?`): OS error code when available.

**Example**:

```lua
fs.read_text("README.md")
```
