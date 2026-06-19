---
title: "tbl"
description:
  "Table operations for querying, copying, merging, and transforming tables."
---

Table operations for querying, copying, merging, and transforming tables.

## Usage

```lua
tbl = mods.tbl

print(tbl.count({ a = 1, b = 2 })) --> 2
```

## Functions

**Copies**:

| Function        | Description                         |
| --------------- | ----------------------------------- |
| [`copy(t)`]     | Create a shallow copy of the table. |
| [`deepcopy(v)`] | Create a deep copy of a value.      |

**Core Utilities**:

| Function     | Description                             |
| ------------ | --------------------------------------- |
| [`clear(t)`] | Remove all entries from the table.      |
| [`count(t)`] | Return the number of keys in the table. |

**Iterators**:

| Function           | Description                                  |
| ------------------ | -------------------------------------------- |
| [`foreach(t, fn)`] | Call a function for each value in the table. |
| [`spairs(t)`]      | Iterate key-value pairs in sorted key order. |

**Queries**:

| Function             | Description                                                      |
| -------------------- | ---------------------------------------------------------------- |
| [`deep_equal(a, b)`] | Return `true` if two tables are deeply equal.                    |
| [`filter(t, pred)`]  | Filter entries by a value predicate.                             |
| [`find(t, v)`]       | Find the first key whose value equals the given value.           |
| [`find_if(t, pred)`] | Find first value and key matching predicate.                     |
| [`get(t, ...)`]      | Safely get nested value by keys.                                 |
| [`is_same(a, b)`]    | Return `true` if two tables have the same keys and equal values. |

**Transforms**:

| Function           | Description                                        |
| ------------------ | -------------------------------------------------- |
| [`invert(t)`]      | Invert keys/values into new table.                 |
| [`isempty(t)`]     | Return true if table has no entries.               |
| [`keys(t)`]        | Return a list of all keys in the table.            |
| [`map(t, fn)`]     | Return a new table by mapping each key-value pair. |
| [`update(t1, t2)`] | Merge entries from `t2` into `t1` and return `t1`. |
| [`values(t)`]      | Return a list of all values in the table.          |

### Copies

#### `copy(t)` {#copy}

Create a shallow copy of the table.

**Parameters**:

- `t` (`T`): Source table.

**Returns**:

- `copy` (`T`): Shallow-copied table.

**Example**:

```lua
t = copy({ a = 1, b = 2 }) --> { a = 1, b = 2 }
```

---

#### `deepcopy(v)` {#deepcopy}

Create a deep copy of a value.

**Parameters**:

- `v` (`T`): Input value.

**Returns**:

- `copiedValue` (`T`): Deep-copied value.

**Example**:

```lua
t = deepcopy({ a = { b = 1 } }) --> { a = { b = 1 } }
n = deepcopy(42) --> 42
```

> [!NOTE]
>
> If `v` is a table, all nested tables are copied recursively; other types are
> returned as-is.

---

### Core Utilities

#### `clear(t)` {#clear}

Remove all entries from the table.

**Parameters**:

- `t` (`table`): Target table.

**Returns**:

- `none` (`nil`)

**Example**:

```lua
t = { a = 1, b = 2 }
clear(t) --> t = {}
```

---

#### `count(t)` {#count}

Return the number of keys in the table.

**Parameters**:

- `t` (`table`): Input table.

**Returns**:

- `count` (`integer`): Number of keys in `t`.

**Example**:

```lua
n = count({ a = 1, b = 2 }) --> 2
```

---

### Iterators

#### `foreach(t, fn)` {#foreach}

Call a function for each value in the table.

**Parameters**:

- `t` (`table<K,V>`): Input table.
- `fn` (`fun(value:V, key:K)`): Function invoked for each entry.

**Returns**:

- `none` (`nil`)

**Example**:

```lua
foreach({ a = 1, b = 2 }, function(v, k)
  print(k, v)
end)
```

---

#### `spairs(t)` {#spairs}

Iterate key-value pairs in sorted key order.

**Parameters**:

- `t` (`T`): Input table.

**Returns**:

- `iterator` (`fun(table: table<K, V>, index?: K):(K, V)`): Sorted pairs
  iterator.
- **value** (`T`)

**Example**:

```lua
for k, v in spairs({ b = 2, a = 1 }) do
  print(k, v)
end
```

---

### Queries

#### `deep_equal(a, b)` {#deep-equal}

Return `true` if two tables are deeply equal.

**Parameters**:

- `a` (`table`): Left table.
- `b` (`table`): Right table.

**Returns**:

- `isDeepEqual` (`boolean`): True when both tables are recursively equal.

**Example**:

```lua
ok = deep_equal({ a = { b = 1 } }, { a = { b = 1 } }) --> true
ok = deep_equal({ a = { b = 1 } }, { a = { b = 2 } }) --> false
```

---

#### `filter(t, pred)` {#filter}

Filter entries by a value predicate.

**Parameters**:

- `t` (`table<K,V>`): Input table.
- `pred` (`fun(value:V):boolean`): Value predicate.

**Returns**:

- `filtered` (`table`): Table containing entries where `pred(v)` is true.

**Example**:

```lua
even = filter({ a = 1, b = 2, c = 3 }, function(v)
  return v % 2 == 0
end) --> { b = 2 }
```

---

#### `find(t, v)` {#find}

Find the first key whose value equals the given value.

**Parameters**:

- `t` (`table<K,V>`): Input table.
- `v` (`V`): Value to find.

**Returns**:

- `key?` (`K`): First matching key, or `nil` when not found.

**Example**:

```lua
key = find({ a = 1, b = 2, c = 2 }, 2) --> "b" or "c"
```

---

#### `find_if(t, pred)` {#find-if}

Find first value and key matching predicate.

**Parameters**:

- `t` (`table`): Input table.
- `pred` (`fun(key:K,value:V):boolean`): Predicate function.

**Returns**:

- `value?` (`V`): First matching value, or `nil` when not found.
- `key?` (`K`): Key for the first matching value, or `nil` when not found.

**Example**:

```lua
v, k = find_if({ a = 1, b = 2 }, function(v, k)
  return k == "b" and v == 2
end) --> 2, "b"
```

---

#### `get(t, ...)` {#get}

Safely get nested value by keys.

**Parameters**:

- `t` (`table`): Root table.
- `...` (`any`): Additional arguments.

**Returns**:

- `nestedValue` (`any`): Nested value, or `nil` when any key is missing.

**Example**:

```lua
t = { a = { b = { c = 1 } } }
v1 = get(t, "a", "b", "c") --> 1
v2 = get(t)                --> { a = { b = { c = 1 } } }
```

> [!NOTE]
>
> If no keys are provided, returns the input table.

---

#### `is_same(a, b)` {#is-same}

Return `true` if two tables have the same keys and equal values.

**Parameters**:

- `a` (`table`): Left table.
- `b` (`table`): Right table.

**Returns**:

- `isSame` (`boolean`): True when both tables have the same keys and values.

**Example**:

```lua
ok = is_same({ a = 1, b = 2 }, { b = 2, a = 1 }) --> true
ok = is_same({ a = {} }, { a = {} })             --> false
```

---

### Transforms

#### `invert(t)` {#invert}

Invert keys/values into new table.

**Parameters**:

- `t` (`table<K,V>`): Input table.

**Returns**:

- `inverted` (`table<V,K>`): Inverted table (`value -> key`).

**Example**:

```lua
t = invert({ a = 1, b = 2 }) --> { [1] = "a", [2] = "b" }
```

---

#### `isempty(t)` {#isempty}

Return true if table has no entries.

**Parameters**:

- `t` (`table`): Input table.

**Returns**:

- `isEmpty` (`boolean`): True when `t` has no entries.

**Example**:

```lua
empty = isempty({}) --> true
```

---

#### `keys(t)` {#keys}

Return a list of all keys in the table.

**Parameters**:

- `t` (`table<K,V>`): Input table.

**Returns**:

- `keys` ([`mods.List`]`<V>`): List of keys in `t`.

**Example**:

```lua
keys = keys({ a = 1, b = 2 }) --> { "a", "b" }
```

---

#### `map(t, fn)` {#map}

Return a new table by mapping each key-value pair.

**Parameters**:

- `t` (`table<K,V>`): Input table.
- `fn` (`fun(key:K, value:V):T`): Key-value mapping function.

**Returns**:

- `mapped` (`table<K,T>`): New table with mapped values.

**Example**:

```lua
t = map({ a = 1, b = 2 }, function(k, v)
  return k .. v
end) --> { a = "a1", b = "b2" }
```

> [!NOTE]
>
> Output keeps original keys; only values are transformed by `fn`.

---

#### `update(t1, t2)` {#update}

Merge entries from `t2` into `t1` and return `t1`.

**Parameters**:

- `t1` (`T`): Target table.
- `t2` (`table`): Source table.

**Returns**:

- `table` (`T`): Updated `t1` table.

**Example**:

```lua
t1 = { a = 1, b = 2 }
update(t1, { b = 3, c = 4 }) --> t1 is { a = 1, b = 3, c = 4 }
```

---

#### `values(t)` {#values}

Return a list of all values in the table.

**Parameters**:

- `t` (`table<K,V>`): Input table.

**Returns**:

- `values` ([`mods.List`]`<V>`): List of values in `t`.

**Example**:

```lua
vals = values({ a = 1, b = 2 }) --> { 1, 2 }
```

<!-- prettier-ignore-start -->
[`clear(t)`]: #clear
[`copy(t)`]: #copy
[`count(t)`]: #count
[`deep_equal(a, b)`]: #deep-equal
[`deepcopy(v)`]: #deepcopy
[`filter(t, pred)`]: #filter
[`find(t, v)`]: #find
[`find_if(t, pred)`]: #find-if
[`foreach(t, fn)`]: #foreach
[`get(t, ...)`]: #get
[`invert(t)`]: #invert
[`is_same(a, b)`]: #is-same
[`isempty(t)`]: #isempty
[`keys(t)`]: #keys
[`map(t, fn)`]: #map
[`mods.List`]: /mods/api/list
[`spairs(t)`]: #spairs
[`update(t1, t2)`]: #update
[`values(t)`]: #values
<!-- prettier-ignore-end -->
