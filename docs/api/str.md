---
title: "str"
description:
  "String operations for searching, splitting, trimming, and formatting text."
---

String operations for searching, splitting, trimming, and formatting text.

## Usage

```lua
str = mods.str

print(str.capitalize("hello world")) --> "Hello world"
```

## Functions

**Casing & Transform**:

| Function                                 | Description                                               |
| ---------------------------------------- | --------------------------------------------------------- |
| [`startswith(s, prefix, start?, stop?)`] | Return true if string starts with prefix.                 |
| [`swapcase(s)`]                          | Return a copy with case of alphabetic characters swapped. |
| [`title(s)`]                             | Return titlecased copy.                                   |
| [`translate(s, table_map)`]              | Translate characters using a mapping table.               |
| [`upper(s)`]                             | Return uppercased copy.                                   |
| [`zfill(s, width)`]                      | Pad numeric string on the left with zeros.                |

**Formatting**:

| Function                               | Description                                                           |
| -------------------------------------- | --------------------------------------------------------------------- |
| [`capitalize(s)`]                      | Return copy with first character capitalized and the rest lowercased. |
| [`center(s, width, fillchar?)`]        | Center string within width, padded with fill characters.              |
| [`count(s, sub, start?, stop?)`]       | Count non-overlapping occurrences of a substring.                     |
| [`endswith(s, suffix, start?, stop?)`] | Return true if string ends with suffix.                               |
| [`expandtabs(s, tabsize?)`]            | Expand tabs to spaces using given tabsize.                            |
| [`find(s, sub, start?, stop?)`]        | Return lowest index of substring or nil if not found.                 |
| [`format_map(s, mapping)`]             | Format string with mapping (key-based) replacement.                   |

**Layout**:

| Function                       | Description                                                         |
| ------------------------------ | ------------------------------------------------------------------- |
| [`join(sep, ls)`]              | Join an array-like table of strings using this string as separator. |
| [`ljust(s, width, fillchar?)`] | Left-justify string in a field of given width.                      |
| [`lower(s)`]                   | Return lowercased copy.                                             |
| [`lstrip(s, chars?)`]          | Remove leading characters (default: whitespace).                    |
| [`rstrip(s, chars?)`]          | Remove trailing characters (default: whitespace).                   |
| [`strip(s, chars?)`]           | Remove leading and trailing characters (default: whitespace).       |

**Predicates**:

| Function            | Description                                                                                  |
| ------------------- | -------------------------------------------------------------------------------------------- |
| [`isalnum(s)`]      | Return true if all characters are alphanumeric and string is non-empty.                      |
| [`isalpha(s)`]      | Return true if all characters are alphabetic and string is non-empty.                        |
| [`isascii(s)`]      | Return true if all characters are ASCII.                                                     |
| [`isdecimal(s)`]    | Return true if all characters are decimal characters and string is non-empty.                |
| [`isidentifier(s)`] | Return true if string is a valid identifier and not a reserved keyword.                      |
| [`islower(s)`]      | Return true if all cased characters are lowercase and there is at least one cased character. |
| [`isprintable(s)`]  | Return true if all characters are printable.                                                 |
| [`isspace(s)`]      | Return true if all characters are whitespace and string is non-empty.                        |
| [`istitle(s)`]      | Return true if string is titlecased.                                                         |
| [`isupper(s)`]      | Return true if all cased characters are uppercase and there is at least one cased character. |

**Split & Replace**:

| Function                         | Description                                                               |
| -------------------------------- | ------------------------------------------------------------------------- |
| [`partition(s, sep)`]            | Partition string into head, sep, tail from left.                          |
| [`removeprefix(s, prefix)`]      | Remove prefix if present.                                                 |
| [`removesuffix(s, suffix)`]      | Remove suffix if present.                                                 |
| [`replace(s, old, new, count?)`] | Return a copy of the string with all occurrences of a substring replaced. |
| [`rfind(s, sub, start?, stop?)`] | Return highest index of substring or nil if not found.                    |
| [`rjust(s, width, fillchar?)`]   | Right-justify string in a field of given width.                           |
| [`rpartition(s, sep)`]           | Partition string into head, sep, tail from right.                         |
| [`rsplit(s, sep?, maxsplit?)`]   | Split from the right by separator, up to maxsplit.                        |
| [`split(s, sep?, maxsplit?)`]    | Split by separator (or whitespace) up to maxsplit.                        |
| [`splitlines(s, keepends?)`]     | Split on line boundaries.                                                 |

### Casing & Transform

#### `startswith(s, prefix, start?, stop?)` {#startswith}

Return true if string starts with prefix.

**Parameters**:

- `s` (`string`): Input string.
- `prefix` (`string` | `string[]`): Prefix string.
- `start?` (`integer`): Optional start index (defaults to `1`).
- `stop?` (`integer`): Optional exclusive end index (defaults to `#s + 1`).

**Returns**:

- `hasPrefix` (`boolean`): True when `s` starts with `prefix`.

**Example**:

```lua
ok = startswith("hello.lua", "he") --> true
```

> [!NOTE]
>
> If prefix is a list, returns `true` when any prefix matches.

---

#### `swapcase(s)` {#swapcase}

Return a copy with case of alphabetic characters swapped.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `swappedCase` (`string`): String with alphabetic case swapped.

**Example**:

```lua
s = swapcase("AbC") --> "aBc"
```

---

#### `title(s)` {#title}

Return titlecased copy.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `titlecased` (`string`): Titlecased string.

**Example**:

```lua
s = title("hello world") --> "Hello World"
```

---

#### `translate(s, table_map)` {#translate}

Translate characters using a mapping table.

**Parameters**:

- `s` (`string`): Input string.
- `table_map` (`table`): Character translation map.

**Returns**:

- `translated` (`string`): Translated string.

**Example**:

```lua
map = { [string.byte("a")] = "b", ["c"] = false }
s = translate("abc", map) --> "bb"
```

---

#### `upper(s)` {#upper}

Return uppercased copy.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `uppercased` (`string`): Uppercased string.

**Example**:

```lua
s = upper("Hello") --> "HELLO"
```

---

#### `zfill(s, width)` {#zfill}

Pad numeric string on the left with zeros.

**Parameters**:

- `s` (`string`): Input string.
- `width` (`integer`): Target width.

**Returns**:

- `zeroFilled` (`string`): Zero-padded string.

**Example**:

```lua
s = zfill("42", 5) --> "00042"
```

---

### Formatting

#### `capitalize(s)` {#capitalize}

Return copy with first character capitalized and the rest lowercased.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `capitalized` (`string`): Capitalized string.

**Example**:

```lua
s = capitalize("hello WORLD") --> "Hello world"
```

---

#### `center(s, width, fillchar?)` {#center}

Center string within width, padded with fill characters.

**Parameters**:

- `s` (`string`): Input string.
- `width` (`integer`): Target width.
- `fillchar?` (`string`): Optional fill character.

**Returns**:

- `centered` (`string`): Centered string.

**Example**:

```lua
s = center("hi", 6, "-") --> "--hi--"
```

---

#### `count(s, sub, start?, stop?)` {#count}

Count non-overlapping occurrences of a substring.

**Parameters**:

- `s` (`string`): Input string.
- `sub` (`string`): Substring to search.
- `start?` (`integer`): Optional start index (defaults to `1`).
- `stop?` (`integer`): Optional exclusive end index (defaults to `#s + 1`).

**Returns**:

- `count` (`integer`): Number of non-overlapping matches.

**Example**:

```lua
n = count("aaaa", "aa")       --> 2
n = count("aaaa", "a", 2, -1) --> 2
n = count("abcd", "")         --> 5
```

---

#### `endswith(s, suffix, start?, stop?)` {#endswith}

Return true if string ends with suffix.

**Parameters**:

- `s` (`string`): Input string.
- `suffix` (`string` | `string[]`): Suffix string.
- `start?` (`integer`): Optional start index (defaults to `1`).
- `stop?` (`integer`): Optional exclusive end index (defaults to `#s + 1`).

**Returns**:

- `hasSuffix` (`boolean`): True when `s` ends with `suffix`.

**Example**:

```lua
ok = endswith("hello.lua", ".lua") --> true
```

> [!NOTE]
>
> If suffix is a list, returns `true` when any suffix matches.

---

#### `expandtabs(s, tabsize?)` {#expandtabs}

Expand tabs to spaces using given tabsize.

**Parameters**:

- `s` (`string`): Input string.
- `tabsize?` (`integer`): Optional tab width (defaults to `8`).

**Returns**:

- `expanded` (`string`): String with tabs expanded.

**Example**:

```lua
s = expandtabs("a\tb", 4) --> "a   b"
```

---

#### `find(s, sub, start?, stop?)` {#find}

Return lowest index of substring or nil if not found.

**Parameters**:

- `s` (`string`): Input string.
- `sub` (`string`): Substring to search.
- `start?` (`integer`): Optional start index (defaults to `1`).
- `stop?` (`integer`): Optional exclusive end index (defaults to `#s + 1`).

**Returns**:

- `index?` (`integer`): First match index, or `nil` when not found.

**Example**:

```lua
i = find("hello", "ll") --> 3
```

---

#### `format_map(s, mapping)` {#format-map}

Format string with mapping (key-based) replacement.

**Parameters**:

- `s` (`string`): Template string with `{key}` placeholders.
- `mapping` (`table`): Values used to replace placeholder keys.

**Returns**:

- `formatted` (`string`): Formatted string with placeholders replaced.

**Example**:

```lua
s = format_map("hi {name}", { name = "bob" }) --> "hi bob"
```

> [!NOTE]
>
> `format_map` is a lightweight `{key}` replacement helper. For richer
> templating, use [`mods.template`].

---

### Layout

#### `join(sep, ls)` {#join}

Join an array-like table of strings using this string as separator.

**Parameters**:

- `sep` (`string`): Separator value.
- `ls` (`string[]`): Table value.

**Returns**:

- `joined` (`string`): Joined string.

**Example**:

```lua
s = join(",", { "a", "b", "c" }) --> "a,b,c"
```

---

#### `ljust(s, width, fillchar?)` {#ljust}

Left-justify string in a field of given width.

**Parameters**:

- `s` (`string`): Input string.
- `width` (`integer`): Target width.
- `fillchar?` (`string`): Optional fill character.

**Returns**:

- `leftJustified` (`string`): Left-justified string.

**Example**:

```lua
s = ljust("hi", 5, ".") --> "hi..."
```

---

#### `lower(s)` {#lower}

Return lowercased copy.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `lowercased` (`string`): Lowercased string.

**Example**:

```lua
s = lower("HeLLo") --> "hello"
```

---

#### `lstrip(s, chars?)` {#lstrip}

Remove leading characters (default: whitespace).

**Parameters**:

- `s` (`string`): Input string.
- `chars?` (`string`): Optional character set.

**Returns**:

- `leadingStripped` (`string`): String with leading characters removed.

**Example**:

```lua
s = lstrip("  hello") --> "hello"
```

---

#### `rstrip(s, chars?)` {#rstrip}

Remove trailing characters (default: whitespace).

**Parameters**:

- `s` (`string`): Input string.
- `chars?` (`string`): Optional character set.

**Returns**:

- `trailingStripped` (`string`): String with trailing characters removed.

**Example**:

```lua
s = rstrip("hello  ") --> "hello"
```

---

#### `strip(s, chars?)` {#strip}

Remove leading and trailing characters (default: whitespace).

**Parameters**:

- `s` (`string`): Input string.
- `chars?` (`string`): Optional character set.

**Returns**:

- `stripped` (`string`): String with leading and trailing characters removed.

**Example**:

```lua
s = strip("  hello  ") --> "hello"
```

---

### Predicates

#### `isalnum(s)` {#isalnum}

Return true if all characters are alphanumeric and string is non-empty.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

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

---

#### `isalpha(s)` {#isalpha}

Return true if all characters are alphabetic and string is non-empty.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

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

---

#### `isascii(s)` {#isascii}

Return true if all characters are ASCII.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `isAscii` (`boolean`): True when all bytes in `s` are ASCII.

**Example**:

```lua
ok = isascii("hello") --> true
```

> [!NOTE]
>
> The empty string returns `true`.

---

#### `isdecimal(s)` {#isdecimal}

Return true if all characters are decimal characters and string is non-empty.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `isDecimal` (`boolean`): True when `s` is non-empty and all characters are
  decimal digits.

**Example**:

```lua
ok = isdecimal("123") --> true
```

---

#### `isidentifier(s)` {#isidentifier}

Return true if string is a valid identifier and not a reserved keyword.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `isIdentifier` (`boolean`): True when `s` is a valid identifier and not a
  keyword.

**Example**:

```lua
ok = isidentifier("foo_bar") --> true
ok = isidentifier("2var") --> false
ok = isidentifier("end") --> false (keyword)
```

---

#### `islower(s)` {#islower}

Return true if all cased characters are lowercase and there is at least one
cased character.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `isLower` (`boolean`): True when `s` has at least one cased character and all
  are lowercase.

**Example**:

```lua
ok = islower("hello") --> true
```

---

#### `isprintable(s)` {#isprintable}

Return true if all characters are printable.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `isPrintable` (`boolean`): True when all bytes in `s` are printable ASCII.

**Example**:

```lua
ok = isprintable("abc!") --> true
```

> [!NOTE]
>
> The empty string returns `true`.

---

#### `isspace(s)` {#isspace}

Return true if all characters are whitespace and string is non-empty.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `isSpace` (`boolean`): True when `s` is non-empty and all characters are
  whitespace.

**Example**:

```lua
ok = isspace(" \t") --> true
```

---

#### `istitle(s)` {#istitle}

Return true if string is titlecased.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `isTitle` (`boolean`): True when `s` is titlecased.

**Example**:

```lua
ok = istitle("Hello World") --> true
```

---

#### `isupper(s)` {#isupper}

Return true if all cased characters are uppercase and there is at least one
cased character.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `isUpper` (`boolean`): True when `s` has at least one cased character and all
  are uppercase.

**Example**:

```lua
ok = isupper("HELLO") --> true
```

---

### Split & Replace

#### `partition(s, sep)` {#partition}

Partition string into head, sep, tail from left.

**Parameters**:

- `s` (`string`): Input string.
- `sep` (`string`): Separator value.

**Returns**:

- `head` (`string`): Part before the separator.
- `separator` (`string`): Matched separator, or empty string when not found.
- `tail` (`string`): Part after the separator.

**Example**:

```lua
a, b, c = partition("a-b-c", "-") --> "a", "-", "b-c"
```

---

#### `removeprefix(s, prefix)` {#removeprefix}

Remove prefix if present.

**Parameters**:

- `s` (`string`): Input string.
- `prefix` (`string`): Prefix string.

**Returns**:

- `prefixRemoved` (`string`): String with prefix removed when present.

**Example**:

```lua
s = removeprefix("foobar", "foo") --> "bar"
```

---

#### `removesuffix(s, suffix)` {#removesuffix}

Remove suffix if present.

**Parameters**:

- `s` (`string`): Input string.
- `suffix` (`string`): Suffix string.

**Returns**:

- `suffixRemoved` (`string`): String with suffix removed when present.

**Example**:

```lua
s = removesuffix("foobar", "bar") --> "foo"
```

---

#### `replace(s, old, new, count?)` {#replace}

Return a copy of the string with all occurrences of a substring replaced.

**Parameters**:

- `s` (`string`): Input string.
- `old` (`string`): Substring to replace.
- `new` (`string`): Replacement string.
- `count?` (`integer`): Optional maximum replacement count.

**Returns**:

- `replaced` (`string`): String with replacements applied.

**Example**:

```lua
s = replace("a-b-c", "-", "_", 1) --> "a_b-c"
```

---

#### `rfind(s, sub, start?, stop?)` {#rfind}

Return highest index of substring or nil if not found.

**Parameters**:

- `s` (`string`): Input string.
- `sub` (`string`): Substring to search.
- `start?` (`integer`): Optional start index (defaults to `1`).
- `stop?` (`integer`): Optional inclusive end index (defaults to `#s`).

**Returns**:

- `index?` (`integer`): Last match index, or `nil` when not found.

**Example**:

```lua
i = rfind("ababa", "ba") --> 4
```

---

#### `rjust(s, width, fillchar?)` {#rjust}

Right-justify string in a field of given width.

**Parameters**:

- `s` (`string`): Input string.
- `width` (`integer`): Target width.
- `fillchar?` (`string`): Optional fill character.

**Returns**:

- `rightJustified` (`string`): Right-justified string.

**Example**:

```lua
s = rjust("hi", 5, ".") --> "...hi"
```

---

#### `rpartition(s, sep)` {#rpartition}

Partition string into head, sep, tail from right.

**Parameters**:

- `s` (`string`): Input string.
- `sep` (`string`): Separator value.

**Returns**:

- `head` (`string`): Part before the separator.
- `separator` (`string`): Matched separator, or empty string when not found.
- `tail` (`string`): Part after the separator.

**Example**:

```lua
a, b, c = rpartition("a-b-c", "-") --> "a-b", "-", "c"
```

---

#### `rsplit(s, sep?, maxsplit?)` {#rsplit}

Split from the right by separator, up to maxsplit.

**Parameters**:

- `s` (`string`): Input string.
- `sep?` (`string`): Optional separator value.
- `maxsplit?` (`integer`): Optional maximum number of splits.

**Returns**:

- `parts` ([`mods.List`]): Split parts.

**Example**:

```lua
parts = rsplit("a,b,c", ",", 1) --> { "a,b", "c" }
```

---

#### `split(s, sep?, maxsplit?)` {#split}

Split by separator (or whitespace) up to maxsplit.

**Parameters**:

- `s` (`string`): Input string.
- `sep?` (`string`): Optional separator value.
- `maxsplit?` (`integer`): Optional maximum number of splits.

**Returns**:

- `parts` ([`mods.List`]): Split parts.

**Example**:

```lua
parts = split("a,b,c", ",") --> { "a", "b", "c" }
```

---

#### `splitlines(s, keepends?)` {#splitlines}

Split on line boundaries.

**Parameters**:

- `s` (`string`): Input string.
- `keepends?` (`boolean`): Optional whether to keep line endings.

**Returns**:

- `lines` ([`mods.List`]): Split lines.

**Example**:

```lua
lines = splitlines("a\nb\r\nc") --> { "a", "b", "c" }
```

<!-- prettier-ignore-start -->
[`capitalize(s)`]: #capitalize
[`center(s, width, fillchar?)`]: #center
[`count(s, sub, start?, stop?)`]: #count
[`endswith(s, suffix, start?, stop?)`]: #endswith
[`expandtabs(s, tabsize?)`]: #expandtabs
[`find(s, sub, start?, stop?)`]: #find
[`format_map(s, mapping)`]: #format-map
[`isalnum(s)`]: #isalnum
[`isalpha(s)`]: #isalpha
[`isascii(s)`]: #isascii
[`isdecimal(s)`]: #isdecimal
[`isidentifier(s)`]: #isidentifier
[`islower(s)`]: #islower
[`isprintable(s)`]: #isprintable
[`isspace(s)`]: #isspace
[`istitle(s)`]: #istitle
[`isupper(s)`]: #isupper
[`join(sep, ls)`]: #join
[`ljust(s, width, fillchar?)`]: #ljust
[`lower(s)`]: #lower
[`lstrip(s, chars?)`]: #lstrip
[`mods.List`]: /mods/api/list
[`mods.template`]: /mods/api/template
[`partition(s, sep)`]: #partition
[`removeprefix(s, prefix)`]: #removeprefix
[`removesuffix(s, suffix)`]: #removesuffix
[`replace(s, old, new, count?)`]: #replace
[`rfind(s, sub, start?, stop?)`]: #rfind
[`rjust(s, width, fillchar?)`]: #rjust
[`rpartition(s, sep)`]: #rpartition
[`rsplit(s, sep?, maxsplit?)`]: #rsplit
[`rstrip(s, chars?)`]: #rstrip
[`split(s, sep?, maxsplit?)`]: #split
[`splitlines(s, keepends?)`]: #splitlines
[`startswith(s, prefix, start?, stop?)`]: #startswith
[`strip(s, chars?)`]: #strip
[`swapcase(s)`]: #swapcase
[`title(s)`]: #title
[`translate(s, table_map)`]: #translate
[`upper(s)`]: #upper
[`zfill(s, width)`]: #zfill
<!-- prettier-ignore-end -->
