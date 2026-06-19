---
title: "set"
description: "A set class for creating, combining, and querying unique values."
---

A set class for creating, combining, and querying unique values.

## Usage

```lua
Set = mods.set

s = Set({ "a" })
print(s:contains("a")) --> true
```

## Functions

**Mutation**:

| Function                             | Description                                                 |
| ------------------------------------ | ----------------------------------------------------------- |
| [`add(v)`]                           | Add an element to the set.                                  |
| [`clear()`]                          | Remove all elements from the set.                           |
| [`difference_update(set)`]           | Remove elements found in another set (in place).            |
| [`intersection_update(set)`]         | Keep only elements common to both sets (in place).          |
| [`pop()`]                            | Remove and return an arbitrary element.                     |
| [`symmetric_difference_update(set)`] | Update the set with elements not shared by both (in place). |
| [`update(set)`]                      | Add all elements from another set (in place).               |

**Predicates**:

| Function            | Description                                                      |
| ------------------- | ---------------------------------------------------------------- |
| [`equals(t)`]       | Return true when both sets contain exactly the same members.     |
| [`isdisjoint(set)`] | Return true if sets have no elements in common.                  |
| [`isempty()`]       | Return true if the set has no elements.                          |
| [`issubset(t)`]     | Return true if all elements of this set are also in another set. |
| [`issuperset(t)`]   | Return true if this set contains all elements of another set.    |

**Queries**:

| Function        | Description                               |
| --------------- | ----------------------------------------- |
| [`contains(v)`] | Return true if the set contains `v`.      |
| [`len()`]       | Return the number of elements in the set. |

**Set Operations**:

| Function                    | Description                                                                  |
| --------------------------- | ---------------------------------------------------------------------------- |
| [`copy()`]                  | Return a shallow copy of the set.                                            |
| [`difference(t)`]           | Return elements in this set but not in another.                              |
| [`has(v)`]                  | Check whether a value is present in the set without following the metatable. |
| [`intersection(t)`]         | Return elements common to both sets.                                         |
| [`remove(v)`]               | Remove an element if present, do nothing otherwise.                          |
| [`symmetric_difference(t)`] | Return elements not shared by both sets.                                     |
| [`union(t)`]                | Return a new set with all elements from both.                                |

**Transforms**:

| Function                | Description                                             |
| ----------------------- | ------------------------------------------------------- |
| [`join(sep?, quoted?)`] | Join set values into a string.                          |
| [`map(fn)`]             | Return a new set by mapping each value.                 |
| [`mirror()`]            | Mirror values into a new table as both keys and values. |
| [`tostring()`]          | Render the set as a string.                             |
| [`values()`]            | Return a list of all values in the set.                 |

**Metamethods**:

| Function         | Description                                                                |
| ---------------- | -------------------------------------------------------------------------- |
| [`__add(t)`]     | Return the union of two sets using `+`.                                    |
| [`__band(t)`]    | Return the intersection of two sets using `&`.                             |
| [`__bor(t)`]     | Return the union of two sets using `\|`.                                   |
| [`__bxor(t)`]    | Return elements present in exactly one set using `^`.                      |
| [`__eq(t)`]      | Return true if both sets contain exactly the same members using `==`.      |
| [`__le(t)`]      | Return true if the left set is a subset of the right set using `<=`.       |
| [`__lt(set)`]    | Return true if the left set is a proper subset of the right set using `<`. |
| [`__sub(set)`]   | Return the difference of two sets using `-`.                               |
| [`__tostring()`] | Render the set via `tostring(set)`.                                        |

### Mutation

#### `add(v)` {#add}

Add an element to the set.

**Parameters**:

- `v` (`any`): Value to add.

**Returns**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a" }):add("b") --> s contains "a", "b"
```

---

#### `clear()` {#clear}

Remove all elements from the set.

**Returns**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a", "b" }):clear() --> s is empty
```

---

#### `difference_update(set)` {#difference-update}

Remove elements found in another set (in place).

**Parameters**:

- `set` (`T` | [`mods.List`]): Other set/list.

**Returns**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a", "b" }):difference_update(Set({ "b" })) --> s contains "a"
```

---

#### `intersection_update(set)` {#intersection-update}

Keep only elements common to both sets (in place).

**Parameters**:

- `set` (`T` | [`mods.List`]): Other set/list.

**Returns**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a", "b" }):intersection_update(Set({ "b", "c" }))
--> s contains "b"
```

---

#### `pop()` {#pop}

Remove and return an arbitrary element.

**Returns**:

- `removedValue` (`any`): Removed value, or `nil` when the set is empty.

**Example**:

```lua
v = Set({ "a", "b" }):pop() --> v is either "a" or "b"
```

---

#### `symmetric_difference_update(set)` {#symmetric-difference-update}

Update the set with elements not shared by both (in place).

**Parameters**:

- `set` (`T` | [`mods.List`]): Other set/list.

**Returns**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a", "b" }):symmetric_difference_update(Set({ "b", "c" }))
--> s contains "a", "c"
```

---

#### `update(set)` {#update}

Add all elements from another set (in place).

**Parameters**:

- `set` (`T` | [`mods.List`]): Other set/list.

**Returns**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a" }):update(Set({ "b" })) --> s contains "a", "b"
```

---

### Predicates

#### `equals(t)` {#equals}

Return true when both sets contain exactly the same members.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

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

---

#### `isdisjoint(set)` {#isdisjoint}

Return true if sets have no elements in common.

**Parameters**:

- `set` (`T` | [`mods.List`]): Other set/list.

**Returns**:

- `isDisjoint` (`boolean`): True when sets have no elements in common.

**Example**:

```lua
ok = Set({ "a" }):isdisjoint(Set({ "b" })) --> true
```

---

#### `isempty()` {#isempty}

Return true if the set has no elements.

**Returns**:

- `isEmpty` (`boolean`): True when the set has no elements.

**Example**:

```lua
empty = Set({}):isempty() --> true
```

---

#### `issubset(t)` {#issubset}

Return true if all elements of this set are also in another set.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

- `isSubset` (`boolean`): True when every element of `self` exists in `set`.

**Example**:

```lua
ok = Set({ "a" }):issubset(Set({ "a", "b" })) --> true
```

> [!NOTE]
>
> `issubset` is also available as the `__le` (`<=`) operator. `a:issubset(b)` is
> equivalent to `a <= b`.

---

#### `issuperset(t)` {#issuperset}

Return true if this set contains all elements of another set.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

- `isSuperset` (`boolean`): True when `self` contains every element of `set`.

**Example**:

```lua
ok = Set({ "a", "b" }):issuperset(Set({ "a" })) --> true
```

---

### Queries

#### `contains(v)` {#contains}

Return true if the set contains `v`.

**Parameters**:

- `v` (`any`): Value to check.

**Returns**:

- `isPresent` (`boolean`): True when `v` is present in the set.

**Example**:

```lua
ok = Set({ "a", "b" }):contains("a") --> true
ok = Set({ "a", "b" }):contains("z") --> false
```

---

#### `len()` {#len}

Return the number of elements in the set.

**Returns**:

- `count` (`integer`): Element count.

**Example**:

```lua
n = Set({ "a", "b" }):len() --> 2
```

---

### Set Operations

#### `copy()` {#copy}

Return a shallow copy of the set.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
c = Set({ "a" }):copy() --> c is a new set with "a"
```

---

#### `difference(t)` {#difference}

Return elements in this set but not in another.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
d = Set({ "a", "b" }):difference(Set({ "b" })) --> d contains "a"
```

> [!NOTE]
>
> `difference` is also available as the `__sub` (`-`) operator.
> `a:difference(b)` is equivalent to `a - b`.

---

#### `has(v)` {#has}

Check whether a value is present in the set without following the metatable.

**Parameters**:

- `v` (`any`): Value to look up.

**Returns**:

- `present` (`boolean`): Whether the value is present.

**Example**:

```lua
s = Set({ "a", "b", "c" })
print(s:has("a"))       --> true
print(s:has("__index")) --> false
```

---

#### `intersection(t)` {#intersection}

Return elements common to both sets.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
i = Set({ "a", "b" }):intersection(Set({ "b", "c" })) --> i contains "b"
```

> [!NOTE]
>
> `intersection` is also available as `__band` (`&`) on Lua 5.3+.

---

#### `remove(v)` {#remove}

Remove an element if present, do nothing otherwise.

**Parameters**:

- `v` (`any`): Value to remove.

**Returns**:

- `self` (`T`): Current set.

**Example**:

```lua
s = Set({ "a", "b" }):remove("b") --> s contains "a"
```

---

#### `symmetric_difference(t)` {#symmetric-difference}

Return elements not shared by both sets.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
d = Set({ "a", "b" }):symmetric_difference(Set({ "b", "c" }))
--> d contains "a", "c"
```

> [!NOTE]
>
> `symmetric_difference` is also available as `__bxor` (`^`) on Lua 5.3+.

---

#### `union(t)` {#union}

Return a new set with all elements from both.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
s = Set({ "a" }):union(Set({ "b" })) --> s contains "a", "b"
```

> [!NOTE]
>
> `union` is available as `__add` (`+`) and `__bor` (`|`) on Lua 5.3+.
> `a:union(b)` is equivalent to `a + b` and `a | b`.

---

### Transforms

#### `join(sep?, quoted?)` {#join}

Join set values into a string.

**Parameters**:

- `sep?` (`string`): Optional separator value (defaults to `""`).
- `quoted?` (`boolean`): Optional boolean flag (defaults to `false`).

**Returns**:

- `joined` (`string`): Joined string.

**Example**:

```lua
s = Set({ "b", "a" }):join(", ")       --> "a, b"
s = Set({ "b", "a" }):join(", ", true) --> '"a", "b"'
```

> [!NOTE]
>
> Join order is not guaranteed.

---

#### `map(fn)` {#map}

Return a new set by mapping each value.

**Parameters**:

- `fn` (`fun(v:any):any`): Mapping function.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
s = Set({ 1, 2 }):map(function(v) return v * 10 end) --> s contains 10, 20
```

---

#### `mirror()` {#mirror}

Mirror values into a new table as both keys and values.

**Returns**:

- `mirroredValues` (`table<K,K>`): Table mapping each value to itself.

**Example**:

```lua
mirrored = Set({ "a", "b" }):mirror() --> { a = "a", b = "b" }
```

---

#### `tostring()` {#tostring}

Render the set as a string.

**Returns**:

- `renderedSet` (`string`): Rendered set string.

**Example**:

```lua
s = Set({ "b", "a", 1 }):tostring() --> '{ 1, "a", "b" }'
```

---

#### `values()` {#values}

Return a list of all values in the set.

**Returns**:

- `values` ([`mods.List`]): List of set values.

**Example**:

```lua
values = Set({ "a", "b" }):values() --> { "a", "b" }
```

---

### Metamethods

#### `__add(t)` {#add-1}

Return the union of two sets using `+`.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
a = Set({ "a", "b" })
b = Set({ "b", "c" })
u = a + b --> { a = true, b = true, c = true }
```

> [!NOTE]
>
> `__add` is the operator form of `:union(set)`.

---

#### `__band(t)` {#band}

Return the intersection of two sets using `&`.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
a = Set({ "a", "b" })
b = Set({ "b", "c" })
i = a & b --> { b = true }
```

> [!NOTE]
>
> `__band` is the operator form of `:intersection(set)` on Lua 5.3+.

---

#### `__bor(t)` {#bor}

Return the union of two sets using `|`.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
a = Set({ "a", "b" })
b = Set({ "b", "c" })
u = a | b --> { a = true, b = true, c = true }
```

> [!NOTE]
>
> `__bor` is the operator form of `:union(set)` on Lua 5.3+.

---

#### `__bxor(t)` {#bxor}

Return elements present in exactly one set using `^`.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
a = Set({ "a", "b" })
b = Set({ "b", "c" })
d = a ^ b --> { a = true, c = true }
```

> [!NOTE]
>
> `__bxor` is the operator form of `:symmetric_difference(set)` on Lua 5.3+.

---

#### `__eq(t)` {#eq}

Return true if both sets contain exactly the same members using `==`.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

- `isEqual` (`boolean`): True when both sets contain the same members.

**Example**:

```lua
ok = Set({ "a", "b" }) == Set({ "b", "a" }) --> true
```

> [!NOTE]
>
> `__eq` is the operator form of `:equals(set)`.

---

#### `__le(t)` {#le}

Return true if the left set is a subset of the right set using `<=`.

**Parameters**:

- `t` ([`mods.Set`] | [`mods.List`] | `table<any,true>`): Other set/list.

**Returns**:

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

---

#### `__lt(set)` {#lt}

Return true if the left set is a proper subset of the right set using `<`.

**Parameters**:

- `set` ([`mods.Set`] | `table<any,true>`): Other set.

**Returns**:

- `isProperSubset` (`boolean`): True when `self` is a proper subset of `set`.

**Example**:

```lua
a = Set({ "a" })
b = Set({ "a", "b" })
ok = a < b --> true
```

---

#### `__sub(set)` {#sub}

Return the difference of two sets using `-`.

**Parameters**:

- `set` ([`mods.Set`] | `table<any,true>`): Other set.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
a = Set({ "a", "b" })
b = Set({ "b", "c" })
d = a - b --> { a = true }
```

> [!NOTE]
>
> `__sub` is the operator form of `:difference(set)`.

---

#### `__tostring()` {#tostring-1}

Render the set via `tostring(set)`.

**Returns**:

- `renderedSet` (`string`): Rendered set string.

**Example**:

```lua
s = tostring(Set({ "b", "a", 1 })) --> '{ 1, "a", "b" }'
```

<!-- prettier-ignore-start -->
[`__add(t)`]: #add-1
[`__band(t)`]: #band
[`__bor(t)`]: #bor
[`__bxor(t)`]: #bxor
[`__eq(t)`]: #eq
[`__le(t)`]: #le
[`__lt(set)`]: #lt
[`__sub(set)`]: #sub
[`__tostring()`]: #tostring-1
[`add(v)`]: #add
[`clear()`]: #clear
[`contains(v)`]: #contains
[`copy()`]: #copy
[`difference(t)`]: #difference
[`difference_update(set)`]: #difference-update
[`equals(t)`]: #equals
[`has(v)`]: #has
[`intersection(t)`]: #intersection
[`intersection_update(set)`]: #intersection-update
[`isdisjoint(set)`]: #isdisjoint
[`isempty()`]: #isempty
[`issubset(t)`]: #issubset
[`issuperset(t)`]: #issuperset
[`join(sep?, quoted?)`]: #join
[`len()`]: #len
[`map(fn)`]: #map
[`mirror()`]: #mirror
[`mods.List`]: /mods/api/list
[`mods.Set`]: /mods/api/set
[`pop()`]: #pop
[`remove(v)`]: #remove
[`symmetric_difference(t)`]: #symmetric-difference
[`symmetric_difference_update(set)`]: #symmetric-difference-update
[`tostring()`]: #tostring
[`union(t)`]: #union
[`update(set)`]: #update
[`values()`]: #values
<!-- prettier-ignore-end -->
