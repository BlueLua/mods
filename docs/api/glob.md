---
description: "Glob-style matching and filesystem expansion helpers."
---

# `glob`

Glob-style matching and filesystem expansion helpers.

## Usage

```lua
glob = require "mods.glob"

print(glob.match("src/mods/fs.lua", "**/*.lua")) --> true
print(glob.match("DATA.TXT", "*.txt", true))     --> true
print(glob.filter({ "a.lua", "b.txt" }, "*.lua")[1]) --> "a.lua"
print(glob.glob("src", "*.lua")[1])
```

## Supported wildcards

- `*`: match zero or more characters within one path segment.

  ```lua
  match("main.lua", "*.lua")
  ```

- `?`: match exactly one character within one path segment.

  ```lua
  match("a1.lua", "a?.lua")
  ```

- `[]`: match one character from a bracket class like `[a-z]`.

  ```lua
  match("file7.lua", "file[0-9].lua")
  ```

- `[!]`: negate a bracket class, like `[!0-9]`.

  ```lua
  match("filex.lua", "file[!0-9].lua")
  ```

- `{a,b}`: match one of several brace alternatives.

  ```lua
  match("init.lua", "init.{lua,luac}")
  ```

- `**`: match across path segments recursively.

  ```lua
  match("src/mods/fs.lua", "**/*.lua")
  ```

## Functions

**Glob Operations**:

| Function                                            | Description                                                 |
| --------------------------------------------------- | ----------------------------------------------------------- |
| [`escape(s)`](#fn-escape)                           | Escape glob metacharacters in a literal string.             |
| [`filter(names, pattern, ignorecase?)`](#fn-filter) | Return the values from `names` that match the glob pattern. |
| [`glob(path, pattern?, opts?)`](#fn-glob)           | Return glob matches under `path`.                           |
| [`has_magic(s)`](#fn-has-magic)                     | Return whether a pattern contains glob metacharacters.      |
| [`iglob(path, pattern?, opts?)`](#fn-iglob)         | Iterator over glob matches under `path`.                    |
| [`match(path, pattern, ignorecase?)`](#fn-match)    | Match a path against a glob pattern.                        |
| [`translate(pattern)`](#fn-translate)               | Translate one glob segment into an equivalent Lua pattern.  |

### Glob Operations

<a id="fn-escape"></a>

#### `escape(s)`

Escape glob metacharacters in a literal string.

**Parameters**:

- `s` (`string`): Input literal string.

**Return**:

- `pattern` (`string`): Escaped glob pattern.

**Example**:

```lua
glob.escape("a*b") --> "a\\*b"
```

<a id="fn-filter"></a>

#### `filter(names, pattern, ignorecase?)`

Return the values from `names` that match the glob pattern.

**Parameters**:

- `names` (`string[]`): Input names.
- `pattern` (`string`): Input glob pattern.
- `ignorecase?` (`boolean`): Override platform-default case matching.

**Return**:

- `matches` (`mods.List<string>`): Matching values from `names`.

**Example**:

```lua
glob.filter({ "a.lua", "b.txt", "c.lua" }, "*.lua") --> { "a.lua", "c.lua" }
```

<a id="fn-glob"></a>

#### `glob(path, pattern?, opts?)`

Return glob matches under `path`.

**Options**:

- `hidden`: include hidden paths; defaults to `true`.
- `recursive`: recurse into subdirectories; defaults to `false`.
- `follow`: recurse into symlinked directories; defaults to `false`.
- `ignorecase`: use case-insensitive matching; defaults to platform semantics.

**Parameters**:

- `path` (`string`): Input path.
- `pattern?` (`string`): Optional pattern to match.
- `opts?`
  (`{hidden?:boolean, recursive?:boolean, follow?:boolean, ignorecase?:boolean}`):
  Optional glob options.

**Return**:

- `paths` (`mods.List<string>`): Matching paths under `path`.

**Example**:

```lua
glob.glob("src", "*.lua")
glob.glob("src", "*.lua", { recursive = true })
```

<a id="fn-has-magic"></a>

#### `has_magic(s)`

Return whether a pattern contains glob metacharacters.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `has_magic` (`boolean`): True when the string contains glob syntax.

**Example**:

```lua
glob.has_magic("foo.txt") --> false
glob.has_magic("*.txt")   --> true
```

<a id="fn-iglob"></a>

#### `iglob(path, pattern?, opts?)`

Iterator over glob matches under `path`.

**Options**:

- `hidden`: include hidden paths; defaults to `true`.
- `recursive`: recurse into subdirectories; defaults to `false`.
- `follow`: recurse into symlinked directories; defaults to `false`.
- `ignorecase`: use case-insensitive matching; defaults to platform semantics.

**Parameters**:

- `path` (`string`): Input path.
- `pattern?` (`string`): Optional pattern to match.
- `opts?`
  (`{hidden?:boolean, recursive?:boolean, follow?:boolean, ignorecase?:boolean}`):
  Optional glob options.

**Return**:

- `iterator` (`(fun(state:table, prev?:string): (path:string?))`): Iterator
  function.
- `state` (`table`): Iterator state table.
- `initial` (`nil`): Initial iterator value.

**Example**:

```lua
for path in glob.iglob("src", "*.lua") do
  print(path)
end
```

<a id="fn-match"></a>

#### `match(path, pattern, ignorecase?)`

Match a path against a glob pattern.

**Parameters**:

- `path` (`string`): Input path.
- `pattern` (`string`): Input glob pattern.
- `ignorecase?` (`boolean`): Override platform-default case matching.

**Return**:

- `matches` (`boolean`): True when the path matches the pattern.

**Example**:

```lua
glob.match("src/mods/fs.lua", "**/*.lua") --> true
```

<a id="fn-translate"></a>

#### `translate(pattern)`

Translate one glob segment into an equivalent Lua pattern.

**Parameters**:

- `pattern` (`string`): Input glob segment.

**Return**:

- `lua_pattern` (`string`): Lua pattern string.

**Example**:

```lua
local s = "init.lua"
local pattern = "*.lua"
local matches = glob.match(s, pattern)
local translated_matches = s:match(glob.translate(pattern)) ~= nil
print(matches == translated_matches) --> true
```

> [!NOTE]
>
> - `*` and `?` stay within a single path segment.
>
>   ```lua
>   local pattern = "*.txt"
>   print(glob.translate(pattern))            --> "^[^/]*%.txt$"
>   print(glob.match("foo/bar.txt", pattern)) --> false
>   ```
>
> - `**` and `{a,b}` need higher-level matching logic.
>
>   ```lua
>   pattern = "src/{x,y}.lua"
>   print(("src/x.lua"):match(glob.translate(pattern))) --> nil
>   print(glob.match("src/x.lua", pattern))             --> true
>   ```
