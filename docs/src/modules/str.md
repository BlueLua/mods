---
description:
  "String operations for searching, splitting, trimming, and formatting text."
---

# `str`

String operations for searching, splitting, trimming, and formatting text.

## Usage

```lua
str = require "mods.str"

print(str.capitalize("hello world")) --> "Hello world"
```

## Functions

**Casing & Transform**:

| Function                                                 | Description                                               |
| -------------------------------------------------------- | --------------------------------------------------------- |
| [`startswith(s, prefix, start?, stop?)`](#fn-startswith) | Return true if string starts with prefix.                 |
| [`swapcase(s)`](#fn-swapcase)                            | Return a copy with case of alphabetic characters swapped. |
| [`title(s)`](#fn-title)                                  | Return titlecased copy.                                   |
| [`translate(s, table_map)`](#fn-translate)               | Translate characters using a mapping table.               |
| [`upper(s)`](#fn-upper)                                  | Return uppercased copy.                                   |
| [`zfill(s, width)`](#fn-zfill)                           | Pad numeric string on the left with zeros.                |

**Formatting**:

| Function                                             | Description                                                           |
| ---------------------------------------------------- | --------------------------------------------------------------------- |
| [`capitalize(s)`](#fn-capitalize)                    | Return copy with first character capitalized and the rest lowercased. |
| [`center(s, width, fillchar?)`](#fn-center)          | Center string within width, padded with fill characters.              |
| [`count(s, sub, start?, stop?)`](#fn-count)          | Count non-overlapping occurrences of a substring.                     |
| [`endswith(s, suffix, start?, stop?)`](#fn-endswith) | Return true if string ends with suffix.                               |
| [`expandtabs(s, tabsize?)`](#fn-expandtabs)          | Expand tabs to spaces using given tabsize.                            |
| [`find(s, sub, start?, stop?)`](#fn-find)            | Return lowest index of substring or nil if not found.                 |
| [`format_map(s, mapping)`](#fn-format-map)           | Format string with mapping (key-based) replacement.                   |

**Layout**:

| Function                                  | Description                                                         |
| ----------------------------------------- | ------------------------------------------------------------------- |
| [`join(sep, ls)`](#fn-join)               | Join an array-like table of strings using this string as separator. |
| [`ljust(s, width, fillchar?)`](#fn-ljust) | Left-justify string in a field of given width.                      |
| [`lower(s)`](#fn-lower)                   | Return lowercased copy.                                             |
| [`lstrip(s, chars?)`](#fn-lstrip)         | Remove leading characters (default: whitespace).                    |
| [`rstrip(s, chars?)`](#fn-rstrip)         | Remove trailing characters (default: whitespace).                   |
| [`strip(s, chars?)`](#fn-strip)           | Remove leading and trailing characters (default: whitespace).       |

**Predicates**:

| Function                              | Description                                                                                  |
| ------------------------------------- | -------------------------------------------------------------------------------------------- |
| [`isalnum(s)`](#fn-isalnum)           | Return true if all characters are alphanumeric and string is non-empty.                      |
| [`isalpha(s)`](#fn-isalpha)           | Return true if all characters are alphabetic and string is non-empty.                        |
| [`isascii(s)`](#fn-isascii)           | Return true if all characters are ASCII.                                                     |
| [`isdecimal(s)`](#fn-isdecimal)       | Return true if all characters are decimal characters and string is non-empty.                |
| [`isidentifier(s)`](#fn-isidentifier) | Return true if string is a valid identifier and not a reserved keyword.                      |
| [`islower(s)`](#fn-islower)           | Return true if all cased characters are lowercase and there is at least one cased character. |
| [`isprintable(s)`](#fn-isprintable)   | Return true if all characters are printable.                                                 |
| [`isspace(s)`](#fn-isspace)           | Return true if all characters are whitespace and string is non-empty.                        |
| [`istitle(s)`](#fn-istitle)           | Return true if string is titlecased.                                                         |
| [`isupper(s)`](#fn-isupper)           | Return true if all cased characters are uppercase and there is at least one cased character. |

**Split & Replace**:

| Function                                      | Description                                                               |
| --------------------------------------------- | ------------------------------------------------------------------------- |
| [`partition(s, sep)`](#fn-partition)          | Partition string into head, sep, tail from left.                          |
| [`removeprefix(s, prefix)`](#fn-removeprefix) | Remove prefix if present.                                                 |
| [`removesuffix(s, suffix)`](#fn-removesuffix) | Remove suffix if present.                                                 |
| [`replace(s, old, new, count?)`](#fn-replace) | Return a copy of the string with all occurrences of a substring replaced. |
| [`rfind(s, sub, start?, stop?)`](#fn-rfind)   | Return highest index of substring or nil if not found.                    |
| [`rindex(s, sub, start?, stop?)`](#fn-rindex) | Like `rfind` but raises an error when the substring is not found.         |
| [`rjust(s, width, fillchar?)`](#fn-rjust)     | Right-justify string in a field of given width.                           |
| [`rpartition(s, sep)`](#fn-rpartition)        | Partition string into head, sep, tail from right.                         |
| [`rsplit(s, sep?, maxsplit?)`](#fn-rsplit)    | Split from the right by separator, up to maxsplit.                        |
| [`split(s, sep?, maxsplit?)`](#fn-split)      | Split by separator (or whitespace) up to maxsplit.                        |
| [`splitlines(s, keepends?)`](#fn-splitlines)  | Split on line boundaries.                                                 |

### Casing & Transform

<a id="fn-startswith"></a>

#### `startswith(s, prefix, start?, stop?)`

Return true if string starts with prefix.

**Parameters**:

- `s` (`string`): Input string.
- `prefix` (`string|string[]`): Prefix string.
- `start?` (`integer`): Optional start index (defaults to `1`).
- `stop?` (`integer`): Optional exclusive end index (defaults to `#s + 1`).

**Return**:

- `hasPrefix` (`boolean`): True when `s` starts with `prefix`.

**Example**:

```lua
ok = startswith("hello.lua", "he") --> true
```

> [!NOTE]
>
> If prefix is a list, returns `true` when any prefix matches.

<a id="fn-swapcase"></a>

#### `swapcase(s)`

Return a copy with case of alphabetic characters swapped.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `swappedCase` (`string`): String with alphabetic case swapped.

**Example**:

```lua
s = swapcase("AbC") --> "aBc"
```

<a id="fn-title"></a>

#### `title(s)`

Return titlecased copy.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `titlecased` (`string`): Titlecased string.

**Example**:

```lua
s = title("hello world") --> "Hello World"
```

<a id="fn-translate"></a>

#### `translate(s, table_map)`

Translate characters using a mapping table.

**Parameters**:

- `s` (`string`): Input string.
- `table_map` (`table`): Character translation map.

**Return**:

- `translated` (`string`): Translated string.

**Example**:

```lua
map = { [string.byte("a")] = "b", ["c"] = false }
s = translate("abc", map) --> "bb"
```

<a id="fn-upper"></a>

#### `upper(s)`

Return uppercased copy.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `uppercased` (`string`): Uppercased string.

**Example**:

```lua
s = upper("Hello") --> "HELLO"
```

<a id="fn-zfill"></a>

#### `zfill(s, width)`

Pad numeric string on the left with zeros.

**Parameters**:

- `s` (`string`): Input string.
- `width` (`integer`): Target width.

**Return**:

- `zeroFilled` (`string`): Zero-padded string.

**Example**:

```lua
s = zfill("42", 5) --> "00042"
```

### Formatting

<a id="fn-capitalize"></a>

#### `capitalize(s)`

Return copy with first character capitalized and the rest lowercased.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `capitalized` (`string`): Capitalized string.

**Example**:

```lua
s = capitalize("hello WORLD") --> "Hello world"
```

<a id="fn-center"></a>

#### `center(s, width, fillchar?)`

Center string within width, padded with fill characters.

**Parameters**:

- `s` (`string`): Input string.
- `width` (`integer`): Target width.
- `fillchar?` (`string`): Optional fill character.

**Return**:

- `centered` (`string`): Centered string.

**Example**:

```lua
s = center("hi", 6, "-") --> "--hi--"
```

<a id="fn-count"></a>

#### `count(s, sub, start?, stop?)`

Count non-overlapping occurrences of a substring.

**Parameters**:

- `s` (`string`): Input string.
- `sub` (`string`): Substring to search.
- `start?` (`integer`): Optional start index (defaults to `1`).
- `stop?` (`integer`): Optional exclusive end index (defaults to `#s + 1`).

**Return**:

- `count` (`integer`): Number of non-overlapping matches.

**Example**:

```lua
n = count("aaaa", "aa")       --> 2
n = count("aaaa", "a", 2, -1) --> 2
n = count("abcd", "")         --> 5
```

<a id="fn-endswith"></a>

#### `endswith(s, suffix, start?, stop?)`

Return true if string ends with suffix.

**Parameters**:

- `s` (`string`): Input string.
- `suffix` (`string|string[]`): Suffix string.
- `start?` (`integer`): Optional start index (defaults to `1`).
- `stop?` (`integer`): Optional exclusive end index (defaults to `#s + 1`).

**Return**:

- `hasSuffix` (`boolean`): True when `s` ends with `suffix`.

**Example**:

```lua
ok = endswith("hello.lua", ".lua") --> true
```

> [!NOTE]
>
> If suffix is a list, returns `true` when any suffix matches.

<a id="fn-expandtabs"></a>

#### `expandtabs(s, tabsize?)`

Expand tabs to spaces using given tabsize.

**Parameters**:

- `s` (`string`): Input string.
- `tabsize?` (`integer`): Optional tab width (defaults to `8`).

**Return**:

- `expanded` (`string`): String with tabs expanded.

**Example**:

```lua
s = expandtabs("a\tb", 4) --> "a   b"
```

<a id="fn-find"></a>

#### `find(s, sub, start?, stop?)`

Return lowest index of substring or nil if not found.

**Parameters**:

- `s` (`string`): Input string.
- `sub` (`string`): Substring to search.
- `start?` (`integer`): Optional start index (defaults to `1`).
- `stop?` (`integer`): Optional exclusive end index (defaults to `#s + 1`).

**Return**:

- `index` (`integer?`): First match index, or `nil` when not found.

**Example**:

```lua
i = find("hello", "ll") --> 3
```

<a id="fn-format-map"></a>

#### `format_map(s, mapping)`

Format string with mapping (key-based) replacement.

**Parameters**:

- `s` (`string`): Template string with `{key}` placeholders.
- `mapping` (`table`): Values used to replace placeholder keys.

**Return**:

- `formatted` (`string`): Formatted string with placeholders replaced.

**Example**:

```lua
s = format_map("hi {name}", { name = "bob" }) --> "hi bob"
```

> [!NOTE]
>
> `format_map` is a lightweight `{key}` replacement helper. For richer
> templating, use [`mods.template`](/modules/template).

### Layout

<a id="fn-join"></a>

#### `join(sep, ls)`

Join an array-like table of strings using this string as separator.

**Parameters**:

- `sep` (`string`): Separator value.
- `ls` (`string[]`): Table value.

**Return**:

- `joined` (`string`): Joined string.

**Example**:

```lua
s = join(",", { "a", "b", "c" }) --> "a,b,c"
```

<a id="fn-ljust"></a>

#### `ljust(s, width, fillchar?)`

Left-justify string in a field of given width.

**Parameters**:

- `s` (`string`): Input string.
- `width` (`integer`): Target width.
- `fillchar?` (`string`): Optional fill character.

**Return**:

- `leftJustified` (`string`): Left-justified string.

**Example**:

```lua
s = ljust("hi", 5, ".") --> "hi..."
```

<a id="fn-lower"></a>

#### `lower(s)`

Return lowercased copy.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `lowercased` (`string`): Lowercased string.

**Example**:

```lua
s = lower("HeLLo") --> "hello"
```

<a id="fn-lstrip"></a>

#### `lstrip(s, chars?)`

Remove leading characters (default: whitespace).

**Parameters**:

- `s` (`string`): Input string.
- `chars?` (`string`): Optional character set.

**Return**:

- `leadingStripped` (`string`): String with leading characters removed.

**Example**:

```lua
s = lstrip("  hello") --> "hello"
```

<a id="fn-rstrip"></a>

#### `rstrip(s, chars?)`

Remove trailing characters (default: whitespace).

**Parameters**:

- `s` (`string`): Input string.
- `chars?` (`string`): Optional character set.

**Return**:

- `trailingStripped` (`string`): String with trailing characters removed.

**Example**:

```lua
s = rstrip("hello  ") --> "hello"
```

<a id="fn-strip"></a>

#### `strip(s, chars?)`

Remove leading and trailing characters (default: whitespace).

**Parameters**:

- `s` (`string`): Input string.
- `chars?` (`string`): Optional character set.

**Return**:

- `stripped` (`string`): String with leading and trailing characters removed.

**Example**:

```lua
s = strip("  hello  ") --> "hello"
```

### Predicates

<a id="fn-isalnum"></a>

#### `isalnum(s)`

Return true if all characters are alphanumeric and string is non-empty.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `isAlnum` (`boolean`): True when `s` is non-empty and all characters are
  alphanumeric.

**Example**:

```lua
ok = isalnum("abc123") --> true
```

> [!NOTE]
>
> Lua letters are ASCII by default, so non-ASCII letters are not alphanumeric.
>
> ```lua
> isalnum("á1") --> false
> ```

<a id="fn-isalpha"></a>

#### `isalpha(s)`

Return true if all characters are alphabetic and string is non-empty.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `isAlpha` (`boolean`): True when `s` is non-empty and all characters are
  alphabetic.

**Example**:

```lua
ok = isalpha("abc") --> true
```

> [!NOTE]
>
> Lua letters are ASCII by default, so non-ASCII letters are not alphabetic.
>
> ```lua
> isalpha("á") --> false
> ```

<a id="fn-isascii"></a>

#### `isascii(s)`

Return true if all characters are ASCII.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `isAscii` (`boolean`): True when all bytes in `s` are ASCII.

**Example**:

```lua
ok = isascii("hello") --> true
```

> [!NOTE]
>
> The empty string returns `true`.

<a id="fn-isdecimal"></a>

#### `isdecimal(s)`

Return true if all characters are decimal characters and string is non-empty.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `isDecimal` (`boolean`): True when `s` is non-empty and all characters are
  decimal digits.

**Example**:

```lua
ok = isdecimal("123") --> true
```

<a id="fn-isidentifier"></a>

#### `isidentifier(s)`

Return true if string is a valid identifier and not a reserved keyword.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `isIdentifier` (`boolean`): True when `s` is a valid identifier and not a
  keyword.

**Example**:

```lua
ok = isidentifier("foo_bar") --> true
ok = isidentifier("2var") --> false
ok = isidentifier("end") --> false (keyword)
```

<a id="fn-islower"></a>

#### `islower(s)`

Return true if all cased characters are lowercase and there is at least one
cased character.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `isLower` (`boolean`): True when `s` has at least one cased character and all
  are lowercase.

**Example**:

```lua
ok = islower("hello") --> true
```

<a id="fn-isprintable"></a>

#### `isprintable(s)`

Return true if all characters are printable.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `isPrintable` (`boolean`): True when all bytes in `s` are printable ASCII.

**Example**:

```lua
ok = isprintable("abc!") --> true
```

> [!NOTE]
>
> The empty string returns `true`.

<a id="fn-isspace"></a>

#### `isspace(s)`

Return true if all characters are whitespace and string is non-empty.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `isSpace` (`boolean`): True when `s` is non-empty and all characters are
  whitespace.

**Example**:

```lua
ok = isspace(" \t") --> true
```

<a id="fn-istitle"></a>

#### `istitle(s)`

Return true if string is titlecased.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `isTitle` (`boolean`): True when `s` is titlecased.

**Example**:

```lua
ok = istitle("Hello World") --> true
```

<a id="fn-isupper"></a>

#### `isupper(s)`

Return true if all cased characters are uppercase and there is at least one
cased character.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `isUpper` (`boolean`): True when `s` has at least one cased character and all
  are uppercase.

**Example**:

```lua
ok = isupper("HELLO") --> true
```

### Split & Replace

<a id="fn-partition"></a>

#### `partition(s, sep)`

Partition string into head, sep, tail from left.

**Parameters**:

- `s` (`string`): Input string.
- `sep` (`string`): Separator value.

**Return**:

- `head` (`string`): Part before the separator.
- `separator` (`string`): Matched separator, or empty string when not found.
- `tail` (`string`): Part after the separator.

**Example**:

```lua
a, b, c = partition("a-b-c", "-") --> "a", "-", "b-c"
```

<a id="fn-removeprefix"></a>

#### `removeprefix(s, prefix)`

Remove prefix if present.

**Parameters**:

- `s` (`string`): Input string.
- `prefix` (`string`): Prefix string.

**Return**:

- `prefixRemoved` (`string`): String with prefix removed when present.

**Example**:

```lua
s = removeprefix("foobar", "foo") --> "bar"
```

<a id="fn-removesuffix"></a>

#### `removesuffix(s, suffix)`

Remove suffix if present.

**Parameters**:

- `s` (`string`): Input string.
- `suffix` (`string`): Suffix string.

**Return**:

- `suffixRemoved` (`string`): String with suffix removed when present.

**Example**:

```lua
s = removesuffix("foobar", "bar") --> "foo"
```

<a id="fn-replace"></a>

#### `replace(s, old, new, count?)`

Return a copy of the string with all occurrences of a substring replaced.

**Parameters**:

- `s` (`string`): Input string.
- `old` (`string`): Substring to replace.
- `new` (`string`): Replacement string.
- `count?` (`integer`): Optional maximum replacement count.

**Return**:

- `replaced` (`string`): String with replacements applied.

**Example**:

```lua
s = replace("a-b-c", "-", "_", 1) --> "a_b-c"
```

<a id="fn-rfind"></a>

#### `rfind(s, sub, start?, stop?)`

Return highest index of substring or nil if not found.

**Parameters**:

- `s` (`string`): Input string.
- `sub` (`string`): Substring to search.
- `start?` (`integer`): Optional start index (defaults to `1`).
- `stop?` (`integer`): Optional inclusive end index (defaults to `#s`).

**Return**:

- `index` (`integer?`): Last match index, or `nil` when not found.

**Example**:

```lua
i = rfind("ababa", "ba") --> 4
```

<a id="fn-rindex"></a>

#### `rindex(s, sub, start?, stop?)`

Like `rfind` but raises an error when the substring is not found.

**Parameters**:

- `s` (`string`): Input string.
- `sub` (`string`): Substring to search.
- `start?` (`integer`): Optional start index (defaults to `1`).
- `stop?` (`integer`): Optional inclusive end index (defaults to `#s`).

**Return**:

- `index` (`integer`): Last match index.

**Example**:

```lua
i = rindex("ababa", "ba") --> 4
```

<a id="fn-rjust"></a>

#### `rjust(s, width, fillchar?)`

Right-justify string in a field of given width.

**Parameters**:

- `s` (`string`): Input string.
- `width` (`integer`): Target width.
- `fillchar?` (`string`): Optional fill character.

**Return**:

- `rightJustified` (`string`): Right-justified string.

**Example**:

```lua
s = rjust("hi", 5, ".") --> "...hi"
```

<a id="fn-rpartition"></a>

#### `rpartition(s, sep)`

Partition string into head, sep, tail from right.

**Parameters**:

- `s` (`string`): Input string.
- `sep` (`string`): Separator value.

**Return**:

- `head` (`string`): Part before the separator.
- `separator` (`string`): Matched separator, or empty string when not found.
- `tail` (`string`): Part after the separator.

**Example**:

```lua
a, b, c = rpartition("a-b-c", "-") --> "a-b", "-", "c"
```

<a id="fn-rsplit"></a>

#### `rsplit(s, sep?, maxsplit?)`

Split from the right by separator, up to maxsplit.

**Parameters**:

- `s` (`string`): Input string.
- `sep?` (`string`): Optional separator value.
- `maxsplit?` (`integer`): Optional maximum number of splits.

**Return**:

- `parts` (`mods.List`): Split parts.

**Example**:

```lua
parts = rsplit("a,b,c", ",", 1) --> { "a,b", "c" }
```

<a id="fn-split"></a>

#### `split(s, sep?, maxsplit?)`

Split by separator (or whitespace) up to maxsplit.

**Parameters**:

- `s` (`string`): Input string.
- `sep?` (`string`): Optional separator value.
- `maxsplit?` (`integer`): Optional maximum number of splits.

**Return**:

- `parts` (`mods.List`): Split parts.

**Example**:

```lua
parts = split("a,b,c", ",") --> { "a", "b", "c" }
```

<a id="fn-splitlines"></a>

#### `splitlines(s, keepends?)`

Split on line boundaries.

**Parameters**:

- `s` (`string`): Input string.
- `keepends?` (`boolean`): Optional whether to keep line endings.

**Return**:

- `lines` (`mods.List`): Split lines.

**Example**:

```lua
lines = splitlines("a\nb\r\nc") --> { "a", "b", "c" }
```
