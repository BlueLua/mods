---
description: "String case conversion and word splitting."
---

# `stringcase`

String case conversion and word splitting.

## Usage

```lua
stringcase = require "mods.stringcase"

print(stringcase.snake("FooBar")) --> "foo_bar"
```

## Functions

**Basic**:

| Function                | Description                      |
| ----------------------- | -------------------------------- |
| [`lower(s)`](#fn-lower) | Convert string to all lowercase. |
| [`upper(s)`](#fn-upper) | Convert string to all uppercase. |

**Letter Case**:

| Function                      | Description                                                               |
| ----------------------------- | ------------------------------------------------------------------------- |
| [`capital(s)`](#fn-capital)   | Capitalize the first letter and lowercase the rest.                       |
| [`sentence(s)`](#fn-sentence) | Convert string to sentence case (first letter uppercase, rest unchanged). |
| [`swap(s)`](#fn-swap)         | Swap case of each letter.                                                 |

**Word Case**:

| Function                          | Description                                                           |
| --------------------------------- | --------------------------------------------------------------------- |
| [`acronym(s)`](#fn-acronym)       | Get acronym of words in string (first letters only).                  |
| [`camel(s)`](#fn-camel)           | Convert string to camelCase.                                          |
| [`constant(s)`](#fn-constant)     | Convert string to CONSTANT_CASE (uppercase snake_case).               |
| [`dot(s)`](#fn-dot)               | Convert string to dot.case.                                           |
| [`kebab(s)`](#fn-kebab)           | Convert string to kebab-case.                                         |
| [`pascal(s)`](#fn-pascal)         | Convert string to PascalCase.                                         |
| [`path(s)`](#fn-path)             | Convert string to path/case (slashes between words).                  |
| [`replace(s, sep?)`](#fn-replace) | Normalize to snake_case, then replace underscores with a separator.   |
| [`snake(s)`](#fn-snake)           | Convert string to snake_case.                                         |
| [`space(s)`](#fn-space)           | Convert string to space case (spaces between words).                  |
| [`title(s)`](#fn-title)           | Convert string to Title Case (first letter of each word capitalized). |

### Basic

<a id="fn-lower"></a>

#### `lower(s)`

Convert string to all lowercase.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `lowercased` (`string`): Lowercased string.

**Example**:

```lua
lower("foo_bar-baz") --> "foo_bar-baz"
lower("FooBar baz")  --> "foobar baz"
```

<a id="fn-upper"></a>

#### `upper(s)`

Convert string to all uppercase.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `uppercased` (`string`): Uppercased string.

**Example**:

```lua
upper("foo_bar-baz") --> "FOO_BAR-BAZ"
upper("FooBar baz")  --> "FOOBAR BAZ"
```

### Letter Case

<a id="fn-capital"></a>

#### `capital(s)`

Capitalize the first letter and lowercase the rest.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `capitalized` (`string`): Capitalized string.

**Example**:

```lua
capital("foo_bar-baz") --> "Foo_bar-baz"
capital("FooBar baz")  --> "Foobar baz"
```

<a id="fn-sentence"></a>

#### `sentence(s)`

Convert string to sentence case (first letter uppercase, rest unchanged).

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `sentenceCased` (`string`): Sentence-cased string.

**Example**:

```lua
sentence("foo_bar-baz") --> "Foo_bar-baz"
sentence("FooBar baz")  --> "FooBar baz"
```

<a id="fn-swap"></a>

#### `swap(s)`

Swap case of each letter.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `swapCased` (`string`): Swap-cased string.

**Example**:

```lua
swap("foo_bar-baz") --> "FOO_BAR-BAZ"
swap("FooBar baz")  --> "fOObAR BAZ"
```

### Word Case

<a id="fn-acronym"></a>

#### `acronym(s)`

Get acronym of words in string (first letters only).

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `acronym` (`string`): Acronym string.

**Example**:

```lua
acronym("foo_bar-baz") --> "FBB"
acronym("FooBar baz")  --> "FBB"
```

<a id="fn-camel"></a>

#### `camel(s)`

Convert string to camelCase.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `camelCased` (`string`): Camel-cased string.

**Example**:

```lua
camel("foo_bar-baz") --> "fooBarBaz"
camel("FooBar baz")  --> "fooBarBaz"
```

<a id="fn-constant"></a>

#### `constant(s)`

Convert string to CONSTANT_CASE (uppercase snake_case).

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `constantCased` (`string`): Constant-cased string.

**Example**:

```lua
constant("foo_bar-baz") --> "FOO_BAR_BAZ"
constant("FooBar baz")  --> "FOO_BAR_BAZ"
```

<a id="fn-dot"></a>

#### `dot(s)`

Convert string to dot.case.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `dotCased` (`string`): Dot-cased string.

**Example**:

```lua
dot("foo_bar-baz") --> "foo.bar.baz"
dot("FooBar baz")  --> "foo.bar.baz"
```

<a id="fn-kebab"></a>

#### `kebab(s)`

Convert string to kebab-case.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `kebabCased` (`string`): Kebab-cased string.

**Example**:

```lua
kebab("foo_bar-baz") --> "foo-bar-baz"
kebab("FooBar baz")  --> "foo-bar-baz"
```

<a id="fn-pascal"></a>

#### `pascal(s)`

Convert string to PascalCase.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `pascalCased` (`string`): Pascal-cased string.

**Example**:

```lua
pascal("foo_bar-baz") --> "FooBarBaz"
pascal("FooBar baz")  --> "FooBarBaz"
```

<a id="fn-path"></a>

#### `path(s)`

Convert string to path/case (slashes between words).

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `pathCased` (`string`): Path-cased string.

**Example**:

```lua
path("foo_bar-baz") --> "foo/bar/baz"
path("FooBar baz")  --> "foo/bar/baz"
```

<a id="fn-replace"></a>

#### `replace(s, sep?)`

Normalize to snake_case, then replace underscores with a separator.

**Parameters**:

- `s` (`string`): Input string.
- `sep?` (`string`): Optional separator value (defaults to `""`).

**Return**:

- `replaced` (`string`): String with underscores replaced by `sep`.

**Example**:

```lua
replace("foo_bar-baz", "-") --> "foo-bar-baz"
replace("FooBar baz", "-")  --> "foo-bar-baz"
```

<a id="fn-snake"></a>

#### `snake(s)`

Convert string to snake_case.

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `snakeCased` (`string`): Snake-cased string.

**Example**:

```lua
snake("foo_bar-baz") --> "foo_bar_baz"
snake("FooBar baz")  --> "foo_bar_baz"
```

<a id="fn-space"></a>

#### `space(s)`

Convert string to space case (spaces between words).

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `spaceCased` (`string`): Space-cased string.

**Example**:

```lua
space("foo_bar-baz") --> "foo bar baz"
space("FooBar baz")  --> "foo bar baz"
```

<a id="fn-title"></a>

#### `title(s)`

Convert string to Title Case (first letter of each word capitalized).

**Parameters**:

- `s` (`string`): Input string.

**Return**:

- `titleCased` (`string`): Title-cased string.

**Example**:

```lua
title("foo_bar-baz") --> "Foo Bar Baz"
title("FooBar baz")  --> "Foo Bar Baz"
```
