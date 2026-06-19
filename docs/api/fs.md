---
title: "fs"
description: "Filesystem I/O, metadata, and filesystem path operations."
---

Filesystem I/O, metadata, and filesystem path operations.

> [!NOTE]
>
> This module requires [LuaFileSystem (`lfs`)].

## Usage

```lua
fs = mods.fs

fs.mkdir("tmp/cache/app", true)
fs.write_text("tmp/cache/app/data.txt", "hello")
print(fs.read_text("tmp/cache/app/data.txt")) --> "hello"
```

## Functions

**Existence Checks**:

| Function          | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| [`exists(path)`]  | Return `true` when a path exists.                            |
| [`lexists(path)`] | Return `true` when a path exists without following symlinks. |

**Filesystem Mutations**:

| Function                     | Description                                                                   |
| ---------------------------- | ----------------------------------------------------------------------------- |
| [`cd(path)`]                 | Change the current working directory.                                         |
| [`cp(src, dst)`]             | Copy a file or directory tree.                                                |
| [`cwd()`]                    | Return the current working directory.                                         |
| [`link(path, linkpath)`]     | Create a hard link.                                                           |
| [`mkdir(path, parents?)`]    | Create a directory.                                                           |
| [`rename(oldname, newname)`] | Rename or move a filesystem entry.                                            |
| [`rm(path, recursive?)`]     | Remove a filesystem entry, or a directory tree when `recursive` is `true`.    |
| [`symlink(path, linkpath)`]  | Create a symbolic link.                                                       |
| [`touch(path)`]              | Create file if missing without truncating, or update timestamps if it exists. |
| [`write_bytes(path, data)`]  | Write full file in binary mode.                                               |
| [`write_text(path, data)`]   | Write full file in text mode.                                                 |

**Metadata**:

| Function           | Description                                                                        |
| ------------------ | ---------------------------------------------------------------------------------- |
| [`getatime(path)`] | Return last access time.                                                           |
| [`getctime(path)`] | Return metadata change time.                                                       |
| [`getmtime(path)`] | Return last modification time.                                                     |
| [`getsize(path)`]  | Return file size in bytes.                                                         |
| [`lstat(path)`]    | Return symlink-aware file attributes.                                              |
| [`samefile(a, b)`] | Return whether two paths refer to the same file, or `nil` and an error on failure. |
| [`stat(path)`]     | Return file attributes.                                                            |

**Reading**:

| Function                 | Description                            |
| ------------------------ | -------------------------------------- |
| [`dir(path, opts?)`]     | Iterator over items in `path`.         |
| [`listdir(path, opts?)`] | Return direct children of a directory. |
| [`read_bytes(path)`]     | Read full file in binary mode.         |
| [`read_text(path)`]      | Read full file in text mode.           |

### Existence Checks

#### `exists(path)` {#exists}

Return `true` when a path exists.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `exists` (`boolean`): True when the path exists.

**Example**:

```lua
fs.exists("README.md") --> true
```

> [!NOTE]
>
> Broken symlinks return `false`.

---

#### `lexists(path)` {#lexists}

Return `true` when a path exists without following symlinks.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `exists` (`boolean`): True when the path or symlink entry exists.

**Example**:

```lua
fs.lexists("README.md") --> true
```

> [!NOTE]
>
> Broken symlinks return `true`.

---

### Filesystem Mutations

#### `cd(path)` {#cd}

Change the current working directory.

**Parameters**:

- `path` (`string`): Directory path to switch into.

**Returns**:

- `changed?` (`true`): `true` when the directory change succeeds, or `nil` on
  failure.
- `errmsg?` (`string`): Error message when the change fails.

**Example**:

```lua
fs.cd("src")
```

---

#### `cp(src, dst)` {#cp}

Copy a file or directory tree.

**Parameters**:

- `src` (`string`): Source path.
- `dst` (`string`): Destination path.

**Returns**:

- `copied?` (`true`): `true` when copying succeeds, or `nil` on failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.cp("a.txt", "b.txt")
fs.cp("src", "backup/src")
```

---

#### `cwd()` {#cwd}

Return the current working directory.

**Returns**:

- `cwd?` (`string`): Current working directory, or `nil` on failure.
- `errmsg?` (`string`): Error message when the lookup fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.cwd()
```

---

#### `link(path, linkpath)` {#link}

Create a hard link.

**Parameters**:

- `path` (`string`): Existing path to link to.
- `linkpath` (`string`): New link path to create.

**Returns**:

- `linked?` (`true`): `true` when link creation succeeds, or `nil` on failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.link("target.txt", "hardlink.txt")
```

---

#### `mkdir(path, parents?)` {#mkdir}

Create a directory.

**Parameters**:

- `path` (`string`): Input path.
- `parents?` (`boolean`): Create missing parent directories when `true`.

**Returns**:

- `created?` (`true`): `true` when directory creation succeeds, or `nil` on
  failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.mkdir("tmp/a/b", true)
```

---

#### `rename(oldname, newname)` {#rename}

Rename or move a filesystem entry.

**Parameters**:

- `oldname` (`string`): Existing path.
- `newname` (`string`): Replacement path.

**Returns**:

- `renamed?` (`true`): `true` when the rename succeeds, or `nil` on failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.rename("old.txt", "new.txt")
```

> [!NOTE]
>
> This is an alias for `os.rename`.

---

#### `rm(path, recursive?)` {#rm}

Remove a filesystem entry, or a directory tree when `recursive` is `true`.

**Parameters**:

- `path` (`string`): Input path.
- `recursive?` (`boolean`): Remove a directory tree recursively when `true`.

**Returns**:

- `removed?` (`true`): `true` when removal succeeds, or `nil` on failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.rm("tmp.txt") --> true, nil
fs.rm("tmp/cache", true) --> true, nil
```

---

#### `symlink(path, linkpath)` {#symlink}

Create a symbolic link.

**Parameters**:

- `path` (`string`): Path to reference from the new symlink.
- `linkpath` (`string`): New symlink path to create.

**Returns**:

- `linked?` (`true`): `true` when link creation succeeds, or `nil` on failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.symlink("target.txt", "symlink.txt")
```

---

#### `touch(path)` {#touch}

Create file if missing without truncating, or update timestamps if it exists.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `touched?` (`true`): `true` when the file exists after touch, or `nil` on
  failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.touch("tmp.txt") --> true, nil
```

---

#### `write_bytes(path, data)` {#write-bytes}

Write full file in binary mode.

**Parameters**:

- `path` (`string`): Input path.
- `data` (`string`): Input data.

**Returns**:

- `written?` (`true`): `true` when writing succeeds, or `nil` on failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.write_bytes("tmp.bin", "abc") --> true, nil
```

---

#### `write_text(path, data)` {#write-text}

Write full file in text mode.

**Parameters**:

- `path` (`string`): Input path.
- `data` (`string`): Input data.

**Returns**:

- `written?` (`true`): `true` when writing succeeds, or `nil` on failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.write_text("tmp.txt", "abc") --> true, nil
```

---

### Metadata

#### `getatime(path)` {#getatime}

Return last access time.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `timestamp?` (`number`): Access time (seconds since epoch).
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.getatime("README.md") --> 1712345678
```

---

#### `getctime(path)` {#getctime}

Return metadata change time.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `timestamp?` (`number`): Change time (seconds since epoch).
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.getctime("README.md") --> 1712345678
```

---

#### `getmtime(path)` {#getmtime}

Return last modification time.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `timestamp?` (`number`): Modification time (seconds since epoch).
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.getmtime("README.md") --> 1712345678
```

---

#### `getsize(path)` {#getsize}

Return file size in bytes.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `size?` (`integer`): File size in bytes.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.getsize("README.md") --> 1234
```

---

#### `lstat(path)` {#lstat}

Return symlink-aware file attributes.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `attrs?` (`LuaFileSystem.Attributes`): Symlink-aware attributes, or `nil` on
  failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.lstat("README.md")
```

---

#### `samefile(a, b)` {#samefile}

Return whether two paths refer to the same file, or `nil` and an error on
failure.

**Parameters**:

- `a` (`string`): Input path.
- `b` (`string`): Input path.

**Returns**:

- `isSameFile?` (`boolean`): True when both paths refer to the same file.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.samefile("README.md", "README.md") --> true
```

---

#### `stat(path)` {#stat}

Return file attributes.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `attrs?` (`string` | `integer` | `LuaFileSystem.AttributeMode` |
  `LuaFileSystem.Attributes`): File attributes, or `nil` on failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.stat("README.md")
```

---

### Reading

#### `dir(path, opts?)` {#dir}

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
  (`{hidden?:boolean, recursive?:boolean, follow?:boolean, type?:`[`mods.FsEntryType`]`}`):
  Optional traversal options.

**Returns**:

- `iterator?`
  (`(fun(state:table, prev?:string):basename?: string, type?: `[`mods.FsEntryType`]`)`):
  Iterator, or `nil` on failure.
- `state` (`table` | `string`): Iterator state on success, or error message on
  failure.

**Example**:

```lua
for name, type in fs.dir(path.cwd(), { recursive = true }) do
  print(name, type)
end
```

---

#### `listdir(path, opts?)` {#listdir}

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
  (`{hidden?:boolean, recursive?:boolean, follow?:boolean, type?:`[`mods.FsEntryType`]`, names?:boolean}`):
  Optional traversal options.

**Returns**:

- `paths?` ([`mods.List`]`<string>`): Direct child paths, or basenames when
  `opts.names` is `true`.
- `err?` (`string`): Error message when traversal setup fails.

**Example**:

```lua
fs.listdir("src")
fs.listdir("src", { names = true })
```

---

#### `read_bytes(path)` {#read-bytes}

Read full file in binary mode.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `body?` (`string`): File contents read in binary mode, or `nil` on failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.read_bytes("README.md")
```

---

#### `read_text(path)` {#read-text}

Read full file in text mode.

**Parameters**:

- `path` (`string`): Input path.

**Returns**:

- `body?` (`string`): File contents read in text mode, or `nil` on failure.
- `errmsg?` (`string`): Error message when the check fails.
- `errcode?` (`integer`): OS error code when available.

**Example**:

```lua
fs.read_text("README.md")
```

<!-- prettier-ignore-start -->
[LuaFileSystem (`lfs`)]: https://github.com/lunarmodules/luafilesystem
[`cd(path)`]: #cd
[`cp(src, dst)`]: #cp
[`cwd()`]: #cwd
[`dir(path, opts?)`]: #dir
[`exists(path)`]: #exists
[`getatime(path)`]: #getatime
[`getctime(path)`]: #getctime
[`getmtime(path)`]: #getmtime
[`getsize(path)`]: #getsize
[`lexists(path)`]: #lexists
[`link(path, linkpath)`]: #link
[`listdir(path, opts?)`]: #listdir
[`lstat(path)`]: #lstat
[`mkdir(path, parents?)`]: #mkdir
[`mods.FsEntryType`]: /mods/types#mods-fsentrytype
[`mods.List`]: /mods/api/list
[`read_bytes(path)`]: #read-bytes
[`read_text(path)`]: #read-text
[`rename(oldname, newname)`]: #rename
[`rm(path, recursive?)`]: #rm
[`samefile(a, b)`]: #samefile
[`stat(path)`]: #stat
[`symlink(path, linkpath)`]: #symlink
[`touch(path)`]: #touch
[`write_bytes(path, data)`]: #write-bytes
[`write_text(path, data)`]: #write-text
<!-- prettier-ignore-end -->
