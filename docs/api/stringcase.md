---
title: "stringcase"
description: "String case conversion and word splitting."
---

String case conversion and word splitting.

## Usage

```lua
stringcase = mods.stringcase

print(stringcase.snake("FooBar")) --> "foo_bar"
```

## Functions

**Basic**:

| Function     | Description                      |
| ------------ | -------------------------------- |
| [`lower(s)`] | Convert string to all lowercase. |
| [`upper(s)`] | Convert string to all uppercase. |

**Letter Case**:

| Function          | Description                                                               |
| ----------------- | ------------------------------------------------------------------------- |
| [`capitalize(s)`] | Capitalize the first letter and lowercase the rest.                       |
| [`sentence(s)`]   | Convert string to sentence case (first letter uppercase, rest unchanged). |
| [`swapcase(s)`]   | Swap case of each letter.                                                 |

**Word Case**:

| Function             | Description                                                           |
| -------------------- | --------------------------------------------------------------------- |
| [`acronym(s)`]       | Get acronym of words in string (first letters only).                  |
| [`camel(s)`]         | Convert string to camelCase.                                          |
| [`constant(s)`]      | Convert string to CONSTANT_CASE (uppercase snake_case).               |
| [`delimit(s, sep?)`] | Normalize to snake_case, then delimit words with a separator.         |
| [`dot(s)`]           | Convert string to dot.case.                                           |
| [`kebab(s)`]         | Convert string to kebab-case.                                         |
| [`pascal(s)`]        | Convert string to PascalCase.                                         |
| [`path(s)`]          | Convert string to path/case (slashes between words).                  |
| [`snake(s)`]         | Convert string to snake_case.                                         |
| [`space(s)`]         | Convert string to space case (spaces between words).                  |
| [`title(s)`]         | Convert string to Title Case (first letter of each word capitalized). |

### Basic

#### `lower(s)` {#lower}

Convert string to all lowercase.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `lowercased` (`string`): Lowercased string.

**Example**:

```lua
lower("foo_bar-baz") --> "foo_bar-baz"
lower("FooBar baz")  --> "foobar baz"
```

---

#### `upper(s)` {#upper}

Convert string to all uppercase.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `uppercased` (`string`): Uppercased string.

**Example**:

```lua
upper("foo_bar-baz") --> "FOO_BAR-BAZ"
upper("FooBar baz")  --> "FOOBAR BAZ"
```

---

### Letter Case

#### `capitalize(s)` {#capitalize}

Capitalize the first letter and lowercase the rest.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `capitalized` (`string`): Capitalized string.

**Example**:

```lua
capitalize("foo_bar-baz") --> "Foo_bar-baz"
capitalize("FooBar baz")  --> "Foobar baz"
```

---

#### `sentence(s)` {#sentence}

Convert string to sentence case (first letter uppercase, rest unchanged).

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `sentenceCased` (`string`): Sentence-cased string.

**Example**:

```lua
sentence("foo_bar-baz") --> "Foo_bar-baz"
sentence("FooBar baz")  --> "FooBar baz"
```

---

#### `swapcase(s)` {#swapcase}

Swap case of each letter.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `swapCased` (`string`): Swap-cased string.

**Example**:

```lua
swapcase("foo_bar-baz") --> "FOO_BAR-BAZ"
swapcase("FooBar baz")  --> "fOObAR BAZ"
```

---

### Word Case

#### `acronym(s)` {#acronym}

Get acronym of words in string (first letters only).

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `acronym` (`string`): Acronym string.

**Example**:

```lua
acronym("foo_bar-baz") --> "FBB"
acronym("FooBar baz")  --> "FBB"
```

---

#### `camel(s)` {#camel}

Convert string to camelCase.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `camelCased` (`string`): Camel-cased string.

**Example**:

```lua
camel("foo_bar-baz") --> "fooBarBaz"
camel("FooBar baz")  --> "fooBarBaz"
```

---

#### `constant(s)` {#constant}

Convert string to CONSTANT_CASE (uppercase snake_case).

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `constantCased` (`string`): Constant-cased string.

**Example**:

```lua
constant("foo_bar-baz") --> "FOO_BAR_BAZ"
constant("FooBar baz")  --> "FOO_BAR_BAZ"
```

---

#### `delimit(s, sep?)` {#delimit}

Normalize to snake_case, then delimit words with a separator.

**Parameters**:

- `s` (`string`): Input string.
- `sep?` (`string`): Optional separator value (defaults to `""`).

**Returns**:

- `delimited` (`string`): String with normalized words separated by `sep`.

**Example**:

```lua
delimit("foo_bar-baz", "-") --> "foo-bar-baz"
delimit("FooBar baz", "-")  --> "foo-bar-baz"
```

---

#### `dot(s)` {#dot}

Convert string to dot.case.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `dotCased` (`string`): Dot-cased string.

**Example**:

```lua
dot("foo_bar-baz") --> "foo.bar.baz"
dot("FooBar baz")  --> "foo.bar.baz"
```

---

#### `kebab(s)` {#kebab}

Convert string to kebab-case.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `kebabCased` (`string`): Kebab-cased string.

**Example**:

```lua
kebab("foo_bar-baz") --> "foo-bar-baz"
kebab("FooBar baz")  --> "foo-bar-baz"
```

---

#### `pascal(s)` {#pascal}

Convert string to PascalCase.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `pascalCased` (`string`): Pascal-cased string.

**Example**:

```lua
pascal("foo_bar-baz") --> "FooBarBaz"
pascal("FooBar baz")  --> "FooBarBaz"
```

---

#### `path(s)` {#path}

Convert string to path/case (slashes between words).

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `pathCased` (`string`): Path-cased string.

**Example**:

```lua
path("foo_bar-baz") --> "foo/bar/baz"
path("FooBar baz")  --> "foo/bar/baz"
```

---

#### `snake(s)` {#snake}

Convert string to snake_case.

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `snakeCased` (`string`): Snake-cased string.

**Example**:

```lua
snake("foo_bar-baz") --> "foo_bar_baz"
snake("FooBar baz")  --> "foo_bar_baz"
```

---

#### `space(s)` {#space}

Convert string to space case (spaces between words).

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `spaceCased` (`string`): Space-cased string.

**Example**:

```lua
space("foo_bar-baz") --> "foo bar baz"
space("FooBar baz")  --> "foo bar baz"
```

---

#### `title(s)` {#title}

Convert string to Title Case (first letter of each word capitalized).

**Parameters**:

- `s` (`string`): Input string.

**Returns**:

- `titleCased` (`string`): Title-cased string.

**Example**:

```lua
title("foo_bar-baz") --> "Foo Bar Baz"
title("FooBar baz")  --> "Foo Bar Baz"
```

<!-- prettier-ignore-start -->
[`acronym(s)`]: #acronym
[`camel(s)`]: #camel
[`capitalize(s)`]: #capitalize
[`constant(s)`]: #constant
[`delimit(s, sep?)`]: #delimit
[`dot(s)`]: #dot
[`kebab(s)`]: #kebab
[`lower(s)`]: #lower
[`pascal(s)`]: #pascal
[`path(s)`]: #path
[`sentence(s)`]: #sentence
[`snake(s)`]: #snake
[`space(s)`]: #space
[`swapcase(s)`]: #swapcase
[`title(s)`]: #title
[`upper(s)`]: #upper
<!-- prettier-ignore-end -->
