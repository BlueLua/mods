---
description: "A set class for creating, combining, and querying unique values."
---

# `Set`

A set class for creating, combining, and querying unique values.

## Usage

```lua
Set = require "mods.Set"

s = Set({ "a" })
print(s:contains("a")) --> true
```

## Functions

**Mutation**:

| Function                                                              | Description                                                 |
| --------------------------------------------------------------------- | ----------------------------------------------------------- |
| [`add(v)`](#fn-add)                                                   | Add an element to the set.                                  |
| [`clear()`](#fn-clear)                                                | Remove all elements from the set.                           |
| [`difference_update(set)`](#fn-difference-update)                     | Remove elements found in another set (in place).            |
| [`intersection_update(set)`](#fn-intersection-update)                 | Keep only elements common to both sets (in place).          |
| [`pop()`](#fn-pop)                                                    | Remove and return an arbitrary element.                     |
| [`symmetric_difference_update(set)`](#fn-symmetric-difference-update) | Update the set with elements not shared by both (in place). |
| [`update(set)`](#fn-update)                                           | Add all elements from another set (in place).               |

**Predicates**:

| Function                            | Description                                                      |
| ----------------------------------- | ---------------------------------------------------------------- |
| [`equals(t)`](#fn-equals)           | Return true when both sets contain exactly the same members.     |
| [`isdisjoint(set)`](#fn-isdisjoint) | Return true if sets have no elements in common.                  |
| [`isempty()`](#fn-isempty)          | Return true if the set has no elements.                          |
| [`issubset(t)`](#fn-issubset)       | Return true if all elements of this set are also in another set. |
| [`issuperset(t)`](#fn-issuperset)   | Return true if this set contains all elements of another set.    |

**Queries**:

| Function                      | Description                               |
| ----------------------------- | ----------------------------------------- |
| [`contains(v)`](#fn-contains) | Return true if the set contains `v`.      |
| [`len()`](#fn-len)            | Return the number of elements in the set. |

**Set Operations**:

| Function                                              | Description                                         |
| ----------------------------------------------------- | --------------------------------------------------- |
| [`copy()`](#fn-copy)                                  | Return a shallow copy of the set.                   |
| [`difference(t)`](#fn-difference)                     | Return elements in this set but not in another.     |
| [`intersection(t)`](#fn-intersection)                 | Return elements common to both sets.                |
| [`remove(v)`](#fn-remove)                             | Remove an element if present, do nothing otherwise. |
| [`symmetric_difference(t)`](#fn-symmetric-difference) | Return elements not shared by both sets.            |
| [`union(t)`](#fn-union)                               | Return a new set with all elements from both.       |

**Transforms**:

| Function                          | Description                                             |
| --------------------------------- | ------------------------------------------------------- |
| [`join(sep?, quoted?)`](#fn-join) | Join set values into a string.                          |
| [`map(fn)`](#fn-map)              | Return a new set by mapping each value.                 |
| [`mirror()`](#fn-mirror)          | Mirror values into a new table as both keys and values. |
| [`tostring()`](#fn-tostring)      | Render the set as a string.                             |
| [`values()`](#fn-values)          | Return a list of all values in the set.                 |

**Metamethods**:

| Function                       | Description                                                                |
| ------------------------------ | -------------------------------------------------------------------------- |
| [`__add(t)`](#fn-add)          | Return the union of two sets using `+`.                                    |
| [`__band(t)`](#fn-band)        | Return the intersection of two sets using `&`.                             |
| [`__bor(t)`](#fn-bor)          | Return the union of two sets using `\|`.                                   |
| [`__bxor(t)`](#fn-bxor)        | Return elements present in exactly one set using `^`.                      |
| [`__eq(t)`](#fn-eq)            | Return true if both sets contain exactly the same members using `==`.      |
| [`__le(t)`](#fn-le)            | Return true if the left set is a subset of the right set using `<=`.       |
| [`__lt(set)`](#fn-lt)          | Return true if the left set is a proper subset of the right set using `<`. |
| [`__sub(set)`](#fn-sub)        | Return the difference of two sets using `-`.                               |
| [`__tostring()`](#fn-tostring) | Render the set via `tostring(set)`.                                        |

### Mutation

<a id="fn-add"></a>

#### `add(v)`

Add an element to the set.

**Parameters**:

- `v` (`any`): Value to add.

**Return**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a" }):add("b") --> s contains "a", "b"
```

<a id="fn-clear"></a>

#### `clear()`

Remove all elements from the set.

**Return**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a", "b" }):clear() --> s is empty
```

<a id="fn-difference-update"></a>

#### `difference_update(set)`

Remove elements found in another set (in place).

**Parameters**:

- `set` (`T|mods.List`): Other set/list.

**Return**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a", "b" }):difference_update(Set({ "b" })) --> s contains "a"
```

<a id="fn-intersection-update"></a>

#### `intersection_update(set)`

Keep only elements common to both sets (in place).

**Parameters**:

- `set` (`T|mods.List`): Other set/list.

**Return**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a", "b" }):intersection_update(Set({ "b", "c" }))
--> s contains "b"
```

<a id="fn-pop"></a>

#### `pop()`

Remove and return an arbitrary element.

**Return**:

- `removedValue` (`any`): Removed value, or `nil` when the set is empty.

**Example**:

```lua
v = Set({ "a", "b" }):pop() --> v is either "a" or "b"
```

<a id="fn-symmetric-difference-update"></a>

#### `symmetric_difference_update(set)`

Update the set with elements not shared by both (in place).

**Parameters**:

- `set` (`T|mods.List`): Other set/list.

**Return**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a", "b" }):symmetric_difference_update(Set({ "b", "c" }))
--> s contains "a", "c"
```

<a id="fn-update"></a>

#### `update(set)`

Add all elements from another set (in place).

**Parameters**:

- `set` (`T|mods.List`): Other set/list.

**Return**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a" }):update(Set({ "b" })) --> s contains "a", "b"
```

### Predicates

<a id="fn-equals"></a>

#### `equals(t)`

Return true when both sets contain exactly the same members.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `isEqual` (`boolean`): True when both sets contain the same members.

**Example**:

```lua
a = Set({ "a", "b" })
b = Set({ "b", "a" })
ok = a:equals(b) --> true
```

> [!NOTE]
>
> `equals` is also available as the `__eq` (`==`) operator. `a:equals(b)` is
> equivalent to `a == b`.

<a id="fn-isdisjoint"></a>

#### `isdisjoint(set)`

Return true if sets have no elements in common.

**Parameters**:

- `set` (`T|mods.List`): Other set/list.

**Return**:

- `isDisjoint` (`boolean`): True when sets have no elements in common.

**Example**:

```lua
ok = Set({ "a" }):isdisjoint(Set({ "b" })) --> true
```

<a id="fn-isempty"></a>

#### `isempty()`

Return true if the set has no elements.

**Return**:

- `isEmpty` (`boolean`): True when the set has no elements.

**Example**:

```lua
empty = Set({}):isempty() --> true
```

<a id="fn-issubset"></a>

#### `issubset(t)`

Return true if all elements of this set are also in another set.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `isSubset` (`boolean`): True when every element of `self` exists in `set`.

**Example**:

```lua
ok = Set({ "a" }):issubset(Set({ "a", "b" })) --> true
```

> [!NOTE]
>
> `issubset` is also available as the `__le` (`<=`) operator. `a:issubset(b)` is
> equivalent to `a <= b`.

<a id="fn-issuperset"></a>

#### `issuperset(t)`

Return true if this set contains all elements of another set.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `isSuperset` (`boolean`): True when `self` contains every element of `set`.

**Example**:

```lua
ok = Set({ "a", "b" }):issuperset(Set({ "a" })) --> true
```

### Queries

<a id="fn-contains"></a>

#### `contains(v)`

Return true if the set contains `v`.

**Parameters**:

- `v` (`any`): Value to check.

**Return**:

- `isPresent` (`boolean`): True when `v` is present in the set.

**Example**:

```lua
ok = Set({ "a", "b" }):contains("a") --> true
ok = Set({ "a", "b" }):contains("z") --> false
```

<a id="fn-len"></a>

#### `len()`

Return the number of elements in the set.

**Return**:

- `count` (`integer`): Element count.

**Example**:

```lua
n = Set({ "a", "b" }):len() --> 2
```

### Set Operations

<a id="fn-copy"></a>

#### `copy()`

Return a shallow copy of the set.

**Return**:

- `set` (`mods.Set`): New set.

**Example**:

```lua
c = Set({ "a" }):copy() --> c is a new set with "a"
```

<a id="fn-difference"></a>

#### `difference(t)`

Return elements in this set but not in another.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `set` (`mods.Set`): New set.

**Example**:

```lua
d = Set({ "a", "b" }):difference(Set({ "b" })) --> d contains "a"
```

> [!NOTE]
>
> `difference` is also available as the `__sub` (`-`) operator.
> `a:difference(b)` is equivalent to `a - b`.

<a id="fn-intersection"></a>

#### `intersection(t)`

Return elements common to both sets.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `set` (`mods.Set`): New set.

**Example**:

```lua
i = Set({ "a", "b" }):intersection(Set({ "b", "c" })) --> i contains "b"
```

> [!NOTE]
>
> `intersection` is also available as `__band` (`&`) on Lua 5.3+.

<a id="fn-remove"></a>

#### `remove(v)`

Remove an element if present, do nothing otherwise.

**Parameters**:

- `v` (`any`): Value to remove.

**Return**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a", "b" }):remove("b") --> s contains "a"
```

<a id="fn-symmetric-difference"></a>

#### `symmetric_difference(t)`

Return elements not shared by both sets.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `set` (`mods.Set`): New set.

**Example**:

```lua
d = Set({ "a", "b" }):symmetric_difference(Set({ "b", "c" }))
--> d contains "a", "c"
```

> [!NOTE]
>
> `symmetric_difference` is also available as `__bxor` (`^`) on Lua 5.3+.

<a id="fn-union"></a>

#### `union(t)`

Return a new set with all elements from both.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `set` (`mods.Set`): New set.

**Example**:

```lua
s = Set({ "a" }):union(Set({ "b" })) --> s contains "a", "b"
```

> [!NOTE]
>
> `union` is available as `__add` (`+`) and `__bor` (`|`) on Lua 5.3+.
> `a:union(b)` is equivalent to `a + b` and `a | b`.

### Transforms

<a id="fn-join"></a>

#### `join(sep?, quoted?)`

Join set values into a string.

**Parameters**:

- `sep?` (`string`): Optional separator value (defaults to `""`).
- `quoted?` (`boolean`): Optional boolean flag (defaults to `false`).

**Return**:

- `joined` (`string`): Joined string.

**Example**:

```lua
s = Set({ "b", "a" }):join(", ")       --> "a, b"
s = Set({ "b", "a" }):join(", ", true) --> '"a", "b"'
```

> [!NOTE]
>
> Join order is not guaranteed.

<a id="fn-map"></a>

#### `map(fn)`

Return a new set by mapping each value.

**Parameters**:

- `fn` (`fun(v:any):any`): Mapping function.

**Return**:

- `set` (`mods.Set`): New set.

**Example**:

```lua
s = Set({ 1, 2 }):map(function(v) return v * 10 end) --> s contains 10, 20
```

<a id="fn-mirror"></a>

#### `mirror()`

Mirror values into a new table as both keys and values.

**Return**:

- `mirroredValues` (`table<K,K>`): Table mapping each value to itself.

**Example**:

```lua
mirrored = Set({ "a", "b" }):mirror() --> { a = "a", b = "b" }
```

<a id="fn-tostring"></a>

#### `tostring()`

Render the set as a string.

**Return**:

- `renderedSet` (`string`): Rendered set string.

**Example**:

```lua
s = Set({ "b", "a", 1 }):tostring() --> '{ 1, "a", "b" }'
```

<a id="fn-values"></a>

#### `values()`

Return a list of all values in the set.

**Return**:

- `values` (`mods.List`): List of set values.

**Example**:

```lua
values = Set({ "a", "b" }):values() --> { "a", "b" }
```

### Metamethods

<a id="fn-add"></a>

#### `__add(t)`

Return the union of two sets using `+`.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `set` (`mods.Set`): New set.

**Example**:

```lua
a = Set({ "a", "b" })
b = Set({ "b", "c" })
u = a + b --> { a = true, b = true, c = true }
```

> [!NOTE]
>
> `__add` is the operator form of `:union(set)`.

<a id="fn-band"></a>

#### `__band(t)`

Return the intersection of two sets using `&`.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `set` (`mods.Set`): New set.

**Example**:

```lua
a = Set({ "a", "b" })
b = Set({ "b", "c" })
i = a & b --> { b = true }
```

> [!NOTE]
>
> `__band` is the operator form of `:intersection(set)` on Lua 5.3+.

<a id="fn-bor"></a>

#### `__bor(t)`

Return the union of two sets using `|`.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `set` (`mods.Set`): New set.

**Example**:

```lua
a = Set({ "a", "b" })
b = Set({ "b", "c" })
u = a | b --> { a = true, b = true, c = true }
```

> [!NOTE]
>
> `__bor` is the operator form of `:union(set)` on Lua 5.3+.

<a id="fn-bxor"></a>

#### `__bxor(t)`

Return elements present in exactly one set using `^`.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `set` (`mods.Set`): New set.

**Example**:

```lua
a = Set({ "a", "b" })
b = Set({ "b", "c" })
d = a ^ b --> { a = true, c = true }
```

> [!NOTE]
>
> `__bxor` is the operator form of `:symmetric_difference(set)` on Lua 5.3+.

<a id="fn-eq"></a>

#### `__eq(t)`

Return true if both sets contain exactly the same members using `==`.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `isEqual` (`boolean`): True when both sets contain the same members.

**Example**:

```lua
ok = Set({ "a", "b" }) == Set({ "b", "a" }) --> true
```

> [!NOTE]
>
> `__eq` is the operator form of `:equals(set)`.

<a id="fn-le"></a>

#### `__le(t)`

Return true if the left set is a subset of the right set using `<=`.

**Parameters**:

- `t` (`mods.Set|mods.List|table<any,true>`): Other set/list.

**Return**:

- `isSubset` (`boolean`): True when `self` is a subset of `set`.

**Example**:

```lua
a = Set({ "a" })
b = Set({ "a", "b" })
ok = a <= b --> true
```

> [!NOTE]
>
> `__le` is the operator form of `:issubset(set)`.

<a id="fn-lt"></a>

#### `__lt(set)`

Return true if the left set is a proper subset of the right set using `<`.

**Parameters**:

- `set` (`mods.Set|table<any,true>`): Other set.

**Return**:

- `isProperSubset` (`boolean`): True when `self` is a proper subset of `set`.

**Example**:

```lua
a = Set({ "a" })
b = Set({ "a", "b" })
ok = a < b --> true
```

<a id="fn-sub"></a>

#### `__sub(set)`

Return the difference of two sets using `-`.

**Parameters**:

- `set` (`mods.Set|table<any,true>`): Other set.

**Return**:

- `set` (`mods.Set`): New set.

**Example**:

```lua
a = Set({ "a", "b" })
b = Set({ "b", "c" })
d = a - b --> { a = true }
```

> [!NOTE]
>
> `__sub` is the operator form of `:difference(set)`.

<a id="fn-tostring"></a>

#### `__tostring()`

Render the set via `tostring(set)`.

**Return**:

- `renderedSet` (`string`): Rendered set string.

**Example**:

```lua
s = tostring(Set({ "b", "a", 1 })) --> '{ 1, "a", "b" }'
```
