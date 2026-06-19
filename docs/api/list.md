---
title: "List"
description:
  "A list class for creating, transforming, and querying sequences of values."
---

A list class for creating, transforming, and querying sequences of values.

## Usage

```lua
List = mods.list

ls = List({ "a" }):append("b")
print(ls:contains("b")) --> true
print(ls:index("b"))    --> 2
```

> [!NOTE]
>
> `List(t)` wraps `t` with the `List` metatable in place. It does not copy or
> filter table values. `List(t):copy()` or `List.copy(t)` both copy only `1..#t`
> and wrap `t` as a List.

## Functions

**Access**:

| Function    | Description                                 |
| ----------- | ------------------------------------------- |
| [`first()`] | Return the first element or `nil` if empty. |
| [`last()`]  | Return the last element or `nil` if empty.  |

**Copies**:

| Function   | Description                        |
| ---------- | ---------------------------------- |
| [`copy()`] | Return a shallow copy of the list. |

**Mutation**:

| Function           | Description                                                          |
| ------------------ | -------------------------------------------------------------------- |
| [`append()`]       | Append a value to the end of the list.                               |
| [`clear()`]        | Remove all elements from the list.                                   |
| [`extend(t)`]      | Extend the list with another list or set.                            |
| [`extract(pred)`]  | Extract values matching the predicate and remove them from the list. |
| [`insert(pos, v)`] | Insert a value at the given position.                                |
| [`insert(v)`]      | Append a value to the end of the list.                               |
| [`pop()`]          | Remove and return the last element.                                  |
| [`pop(pos)`]       | Remove and return the element at the given position.                 |
| [`prepend(v)`]     | Insert a value at the start of the list.                             |
| [`remove(v)`]      | Remove the first matching value.                                     |
| [`shuffle(rng?)`]  | Shuffle the list in place.                                           |
| [`sort(comp?)`]    | Sort the list in place.                                              |

**Predicates**:

| Function       | Description                                       |
| -------------- | ------------------------------------------------- |
| [`all(pred)`]  | Return `true` if all values match the predicate.  |
| [`any(pred)`]  | Return `true` if any value matches the predicate. |
| [`equals(ls)`] | Compare two lists using shallow element equality. |
| [`le(ls)`]     | Compare two lists lexicographically.              |
| [`lt(ls)`]     | Compare two lists lexicographically.              |

**Queries**:

| Function           | Description                                                 |
| ------------------ | ----------------------------------------------------------- |
| [`contains(v)`]    | Return `true` if the list contains the value.               |
| [`count(v)`]       | Count how many times a value appears.                       |
| [`index(v)`]       | Return the index of the first matching value.               |
| [`index_if(pred)`] | Return the index of the first value matching the predicate. |
| [`isempty()`]      | Return whether the list has no elements.                    |
| [`len()`]          | Return the number of elements in the list.                  |

**Transforms**:

| Function                 | Description                                                          |
| ------------------------ | -------------------------------------------------------------------- |
| [`concat(sep?, i?, j?)`] | Concatenate list values using Lua's native `table.concat` behavior.  |
| [`difference(t)`]        | Return a new list with values not in the given list or set.          |
| [`drop(n)`]              | Return a new list without the first n elements.                      |
| [`filter(pred)`]         | Return a new list with values matching the predicate.                |
| [`flatten()`]            | Flatten one level of nested lists.                                   |
| [`foreach(fn)`]          | Apply a function to each element (for side effects).                 |
| [`group_by(fn)`]         | Group list values by a computed key.                                 |
| [`intersection(t)`]      | Return values that are also present in the given list or set.        |
| [`invert()`]             | Invert values to indices in a new table.                             |
| [`join(sep?, quoted?)`]  | Join list values into a string.                                      |
| [`keypath()`]            | Render list items as a table-access key path.                        |
| [`map(fn)`]              | Return a new list by mapping each value.                             |
| [`mirror()`]             | Mirror values into a new table as both keys and values.              |
| [`mul(n)`]               | Return a new list repeated `n` times (list multiplication behavior). |
| [`reduce(fn, init?)`]    | Reduce the list to a single value using an accumulator.              |
| [`reverse()`]            | Reverse the list in place.                                           |
| [`slice(i?, j?)`]        | Return a new list containing items from i to j (inclusive).          |
| [`take(n)`]              | Return the first n elements as a new list.                           |
| [`toset()`]              | Convert the list to a set.                                           |
| [`tostring()`]           | Render the list to a string via the regular method form.             |
| [`uniq()`]               | Return a new list with duplicates removed (first occurrence kept).   |
| [`zip(t)`]               | Zip two collections into a list of 2-element tables.                 |

**Metamethods**:

| Function         | Description                                                                                                     |
| ---------------- | --------------------------------------------------------------------------------------------------------------- |
| [`__add(ls)`]    | Extend the left-hand list in place with right-hand values, then return the same left-hand list reference (`+`). |
| [`__eq(ls)`]     | Compare two lists using shallow element equality (`==`).                                                        |
| [`__le(ls)`]     | Compare two lists lexicographically (`<=`).                                                                     |
| [`__lt(ls)`]     | Compare two lists lexicographically (`<`).                                                                      |
| [`__mul(n)`]     | Repeat a list `n` times (`*`).                                                                                  |
| [`__sub(ls)`]    | Return values from the left list that are not present in the right list (`-`).                                  |
| [`__tostring()`] | Render the list to a string like `{ "a", "b", 1 }`.                                                             |

### Access

#### `first()` {#first}

Return the first element or `nil` if empty.

**Returns**:

- `firstValue` (`any`): First value, or `nil` if empty.

**Example**:

```lua
v = List({ "a", "b" }):first() --> "a"
```

---

#### `last()` {#last}

Return the last element or `nil` if empty.

**Returns**:

- `lastValue` (`any`): Last value, or `nil` if empty.

**Example**:

```lua
v = List({ "a", "b" }):last() --> "b"
```

---

### Copies

#### `copy()` {#copy}

Return a shallow copy of the list.

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
c = List({ "a", "b" }):copy() --> { "a", "b" }
```

---

### Mutation

#### `append()` {#append}

Append a value to the end of the list.

**Returns**:

- `self` (`T`): Current list.

**Example**:

```lua
ls = List({ "a" }):append("b") --> { "a", "b" }
```

---

#### `clear()` {#clear}

Remove all elements from the list.

**Returns**:

- `self` (`T`): Current list.

**Example**:

```lua
ls = List({ "a", "b" }):clear() --> { }
```

---

#### `extend(t)` {#extend}

Extend the list with another list or set.

**Parameters**:

- `t` ([`mods.List`] | [`mods.Set`] | `any[]`): Values to append.

**Returns**:

- `self` (`T`): Current list.

**Example**:

```lua
ls = List({ "a" }):extend({ "b", "c" })      --> { "a", "b", "c" }
ls = List({ "a" }):extend(Set({ "b", "c" })) --> { "a", "b", "c" }
```

> [!NOTE]
>
> `extend` is also available through the `+` operator.

---

#### `extract(pred)` {#extract}

Extract values matching the predicate and remove them from the list.

**Parameters**:

- `pred` (`fun(v:any):boolean`): Predicate function.

**Returns**:

- `ls` ([`mods.List`]): Extracted values.

**Example**:

```lua
ls = List({ "a", "bb", "c" })
is_len_1 = function(v) return #v == 1 end
ex = ls:extract(is_len_1) --> ex = { "a", "c" }, ls = { "bb" }
```

---

#### `insert(pos, v)` {#insert}

Insert a value at the given position.

**Parameters**:

- `pos` (`integer`): Insert position.
- `v` (`any`): Value to insert.

**Returns**:

- `self` (`T`): Current list.

**Example**:

```lua
ls = List({ "a", "c" }):insert(2, "b") --> { "a", "b", "c" }
```

---

#### `insert(v)` {#insert-1}

Append a value to the end of the list.

**Parameters**:

- `v` (`any`): Value to append.

**Returns**:

- `self` (`T`): Current list.

**Example**:

```lua
ls = List({ "a", "b" }):insert("c") --> { "a", "b", "c" }
```

---

#### `pop()` {#pop}

Remove and return the last element.

**Returns**:

- `removedValue` (`any`): Removed value.

**Example**:

```lua
ls = List({ "a", "b" })
v = ls:pop() --> v == "b"; ls is { "a" }
```

---

#### `pop(pos)` {#pop-1}

Remove and return the element at the given position.

**Parameters**:

- `pos` (`integer`): Numeric value.

**Returns**:

- `removedValue` (`any`): Removed value.

**Example**:

```lua
ls = List({ "a", "b", "c" })
v = ls:pop(2) --> v == "b"; ls is { "a", "c" }
```

---

#### `prepend(v)` {#prepend}

Insert a value at the start of the list.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `self` (`T`): Current list.

**Example**:

```lua
ls = List({ "b", "c" })
ls:prepend("a") --> { "a", "b", "c" }
```

---

#### `remove(v)` {#remove}

Remove the first matching value.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `self` (`T`): Current list.

**Example**:

```lua
ls = List({ "a", "b", "b" })
ls:remove("b") --> { "a", "b" }
```

---

#### `shuffle(rng?)` {#shuffle}

Shuffle the list in place.

**Parameters**:

- `rng?` (`fun(lo:integer, hi:integer):integer`): Optional random index picker;
  defaults to `math.random`.

**Returns**:

- `self` (`T`): Current list.

**Example**:

```lua
ls = List({ "a", "b", "c" }):shuffle() --> { "b", "c", "a" } -- order varies
```

---

#### `sort(comp?)` {#sort}

Sort the list in place.

**Parameters**:

- `comp?` (`fun(a:any, b:any):boolean`): Optional comparison function (defaults
  to `nil`).

**Returns**:

- `self` (`T`): Current list.

**Example**:

```lua
ls = List({ 3, 1, 2 })
ls:sort() --> { 1, 2, 3 }

words = List({ "ccc", "a", "bb" })
words:sort(function(a, b)
  return #a < #b
end) --> { "a", "bb", "ccc" }
```

---

### Predicates

#### `all(pred)` {#all}

Return `true` if all values match the predicate.

**Parameters**:

- `pred` (`fun(v:any):boolean`): Predicate function.

**Returns**:

- `allMatch` (`boolean`): Whether the condition is met.

**Example**:

```lua
is_even = function(v) return v % 2 == 0 end
ok = List({ 2, 4 }):all(is_even) --> true
```

> [!NOTE]
>
> Empty lists return `true`.

---

#### `any(pred)` {#any}

Return `true` if any value matches the predicate.

**Parameters**:

- `pred` (`fun(v:any):boolean`): Predicate function.

**Returns**:

- `anyMatch` (`boolean`): Whether the condition is met.

**Example**:

```lua
has_len_2 = function(v) return #v == 2 end
ok = List({ "a", "bb" }):any(has_len_2) --> true
```

---

#### `equals(ls)` {#equals}

Compare two lists using shallow element equality.

**Parameters**:

- `ls` ([`mods.List`] | `any[]`): Other list value.

**Returns**:

- `isEqual` (`boolean`): Whether the condition is met.

**Example**:

```lua
a = List({ "x", "y" })
b = List({ "x", "y" })
ok = a:equals(b) --> true
```

> [!NOTE]
>
> - `equals` is also available through the `==` operator when both operands are
>   `List`.
>
>   ```lua
>   a = List({ "a", 1 })
>   b = List({ "a", 1 })
>   ok = (a == b) --> true
>   ```
>
> - Unlike `==`, this method also works when `ls` is a plain array table.
>
>   ```lua
>   a = List({ "a", 1 })
>   b = { "a", 1 }
>   ok = a:equals(b) --> true
>   ```
>
> - `equals` checks only array positions (`1..#list`), so extra non-array keys
>   are ignored:
>
>   ```lua
>   t = {}
>   a = List({ "a", t })
>   b = { "a", t, a = 1 }
>   ok = a:equals(b) --> true
>   ```

---

#### `le(ls)` {#le}

Compare two lists lexicographically.

**Parameters**:

- `ls` ([`mods.List`] | `any[]`): Other list value.

**Returns**:

- `isLessOrEqual` (`boolean`): Whether the condition is met.

**Example**:

```lua
ok = List({ 1, 2 }):le({ 1, 2 })  --> true
ok = List({ 1, 2 }):le({ 1, 1 })  --> false
```

> [!NOTE]
>
> `le` is also available through the `<=` operator.

---

#### `lt(ls)` {#lt}

Compare two lists lexicographically.

**Parameters**:

- `ls` ([`mods.List`] | `any[]`): Other list value.

**Returns**:

- `isLess` (`boolean`): Whether the condition is met.

**Example**:

```lua
ok = List({ 1, 2 }):lt({ 1, 3 })    --> true
ok = List({ 1, 2 }):lt({ 1, 2, 0 }) --> true
```

> [!NOTE]
>
> `lt` is also available through the `<` operator.

---

### Queries

#### `contains(v)` {#contains}

Return `true` if the list contains the value.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `isPresent` (`boolean`): True when `v` is present in the list.

**Example**:

```lua
ok = List({ "a", "b" }):contains("b") --> true
```

---

#### `count(v)` {#count}

Count how many times a value appears.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `res` (`integer`): Result count.

**Example**:

```lua
n = List({ "a", "b", "b" }):count("b") --> 2
```

---

#### `index(v)` {#index}

Return the index of the first matching value.

**Parameters**:

- `v` (`any`): Value to validate.

**Returns**:

- `index?` (`integer`): Result index, or nil when not found.

**Example**:

```lua
i = List({ "a", "b", "c", "b" }):index("b") --> 2
```

---

#### `index_if(pred)` {#index-if}

Return the index of the first value matching the predicate.

**Parameters**:

- `pred` (`fun(v:any):boolean`): Predicate function.

**Returns**:

- `index?` (`integer`): Result index, or nil when no value matches.

**Example**:

```lua
gt_1 = function(x) return x > 1 end
i = List({ 1, 2, 3 }):index_if(gt_1) --> 2
```

---

#### `isempty()` {#isempty}

Return whether the list has no elements.

**Returns**:

- `empty` (`boolean`): `true` when the list has no elements.

**Example**:

```lua
ok = List():isempty() --> true
```

---

#### `len()` {#len}

Return the number of elements in the list.

**Returns**:

- `count` (`integer`): Element count.

**Example**:

```lua
n = List({ "a", "b", "c" }):len() --> 3
```

> [!NOTE]
>
> Uses Lua's `#` operator.

---

### Transforms

#### `concat(sep?, i?, j?)` {#concat}

Concatenate list values using Lua's native `table.concat` behavior.

**Parameters**:

- `sep?` (`string`): Optional separator value (defaults to `""`).
- `i?` (`integer`): Optional start index (defaults to `1`).
- `j?` (`integer`): Optional end index (defaults to `#self`).

**Returns**:

- `concatenated` (`string`): Concatenated string.

**Example**:

```lua
s = List({ "a", "b", "c" }):concat(",") --> "a,b,c"
```

> [!NOTE]
>
> This method forwards to `table.concat` directly and keeps its strict element
> rules.

---

#### `difference(t)` {#difference}

Return a new list with values not in the given list or set.

**Parameters**:

- `t` ([`mods.List`] | [`mods.Set`] | `any[]`): Values to remove.

**Returns**:

- `ls` (`T`): New list.

**Example**:

```lua
d = List({ "a", "b", "c" }):difference({ "b" }) --> { "a", "c" }
```

> [!NOTE]
>
> `difference` is also available through the `-` operator.

---

#### `drop(n)` {#drop}

Return a new list without the first n elements.

**Parameters**:

- `n` (`integer`): Numeric value.

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
t = List({ "a", "b", "c" }):drop(1) --> { "b", "c" }
```

---

#### `filter(pred)` {#filter}

Return a new list with values matching the predicate.

**Parameters**:

- `pred` (`fun(v:any):boolean`): Predicate function.

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
is_len_1 = function(v) return #v == 1 end
f = List({ "a", "bb", "c" }):filter(is_len_1) --> { "a", "c" }
```

---

#### `flatten()` {#flatten}

Flatten one level of nested lists.

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
f = List({ { "a", "b" }, { "c" } }):flatten() --> { "a", "b", "c" }
```

---

#### `foreach(fn)` {#foreach}

Apply a function to each element (for side effects).

**Parameters**:

- `fn` (`fun(v:any)`): Callback function.

**Returns**:

- `none` (`nil`)

**Example**:

```lua
List({ "a", "b" }):foreach(print)
--> prints -> a
--> prints -> b
```

---

#### `group_by(fn)` {#group-by}

Group list values by a computed key.

**Parameters**:

- `fn` (`fun(v:any):any`): Callback function.

**Returns**:

- `groups` (`table`): Groups keyed by the callback result.

**Example**:

```lua
words = { "aa", "b", "ccc", "dd" }
g = List(words):group_by(string.len) --> { {"b"}, { "aa", "dd" }, { "ccc" } }
```

---

#### `intersection(t)` {#intersection}

Return values that are also present in the given list or set.

**Parameters**:

- `t` ([`mods.List`] | [`mods.Set`] | `any[]`): Other list/set.

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
i = List({ "a", "b", "a", "c" }):intersection({ "a", "c" })
--> { "a", "a", "c" }
```

> [!NOTE]
>
> Order is preserved from the original list.

---

#### `invert()` {#invert}

Invert values to indices in a new table.

**Returns**:

- `idxByValue` (`table<V,K>`): Table mapping each value to its last index.

**Example**:

```lua
t = List({ "a", "b", "c" }):invert() --> { a = 1, b = 2, c = 3 }
```

---

#### `join(sep?, quoted?)` {#join}

Join list values into a string.

**Parameters**:

- `sep?` (`string`): Optional separator value (defaults to `""`).
- `quoted?` (`boolean`): Optional boolean flag (defaults to `false`).

**Returns**:

- `joined` (`string`): Joined string.

**Example**:

```lua
s = List({ "a", "b", "c" }):join(",")        --> "a,b,c"
s = List({ "a", "b", "c" }):join(", ", true) --> '"a", "b", "c"'
```

> [!NOTE]
>
> Values are converted with `tostring` before joining. Set `quoted = true` to
> quote string values.

---

#### `keypath()` {#keypath}

Render list items as a table-access key path.

**Returns**:

- `keyPath` (`string`): Key-path string.

**Example**:

```lua
p = List({ "ctx", "users", 1, "name" }):keypath() --> "ctx.users[1].name"
```

---

#### `map(fn)` {#map}

Return a new list by mapping each value.

**Parameters**:

- `fn` (`fun(value:T):any`): Callback function.

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
to_upper = function(v) return v:upper() end
m = List({ "a", "b" }):map(to_upper) --> { "A", "B" }
```

---

#### `mirror()` {#mirror}

Mirror values into a new table as both keys and values.

**Returns**:

- `mirroredValues` (`table<T,T>`): Table mapping each value to itself.

**Example**:

```lua
t = List({ "a", "b", "c" }):mirror() --> { a = "a", b = "b", c = "c" }
```

---

#### `mul(n)` {#mul}

Return a new list repeated `n` times (list multiplication behavior).

**Parameters**:

- `n` (`integer`): Numeric value.

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
ls = List({ "a", "b" }):mul(3) --> { "a", "b", "a", "b", "a", "b" }
```

> [!NOTE]
>
> `mul` is also available through the `*` operator.

---

#### `reduce(fn, init?)` {#reduce}

Reduce the list to a single value using an accumulator.

**Parameters**:

- `fn` (`fun(acc:any, v:any):any`): Reducer function.
- `init?` (`any`): Optional initial accumulator; for non-empty lists, `nil` or
  omitted uses the first item.

**Returns**:

- `reducedValue` (`any`): Reduced value.

**Example**:

```lua
add = function(acc, v) return acc + v end
sum = List({ 1, 2, 3 }):reduce(add, 0) --> 6
sum = List({ 1, 2, 3 }):reduce(add, 10) --> 16
```

> [!NOTE]
>
> For empty lists, returns `init` unchanged (or `nil` when omitted).

---

#### `reverse()` {#reverse}

Reverse the list in place.

**Returns**:

- `ls` ([`mods.List`]): Same list, reversed in place.

**Example**:

```lua
r = List({ "a", "b", "c" }):reverse() --> { "c", "b", "a" }
```

---

#### `slice(i?, j?)` {#slice}

Return a new list containing items from i to j (inclusive).

**Parameters**:

- `i?` (`integer`): Optional start index (defaults to `1`).
- `j?` (`integer`): Optional end index (defaults to `#self`).

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
t = List({ "a", "b", "c", "d" }):slice(2, 3) --> { "b", "c" }
```

> [!NOTE]
>
> Supports negative indices (-1 is last element).

---

#### `take(n)` {#take}

Return the first n elements as a new list.

**Parameters**:

- `n` (`integer`): Numeric value.

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
t = List({ "a", "b", "c" }):take(2) --> { "a", "b" }
```

---

#### `toset()` {#toset}

Convert the list to a set.

**Returns**:

- `set` ([`mods.Set`]): New set.

**Example**:

```lua
s = List({ "a", "b", "a" }):toset() --> { a = true, b = true }
```

> [!NOTE]
>
> Order is preserved from the original list.

---

#### `tostring()` {#tostring}

Render the list to a string via the regular method form.

**Returns**:

- `renderedList` (`string`): Rendered list string.

**Example**:

```lua
s = List({ "a", "b", 1 }):tostring() --> '{ "a", "b", 1 }'
```

---

#### `uniq()` {#uniq}

Return a new list with duplicates removed (first occurrence kept).

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
u = List({ "a", "b", "a", "c" }):uniq() --> { "a", "b", "c" }
```

---

#### `zip(t)` {#zip}

Zip two collections into a list of 2-element tables.

**Parameters**:

- `t` ([`mods.List`] | [`mods.Set`] | `any[]`): Values to pair with.

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
z = List({ "a", "b" }):zip({ 1, 2 })      --> { {"a",1}, {"b",2} }
z = List({ "a", "b" }):zip(Set({ 1, 2 })) --> { {"a",1}, {"b",2} }
```

> [!NOTE]
>
> Length is the minimum of both tables' lengths.

---

### Metamethods

#### `__add(ls)` {#add}

Extend the left-hand list in place with right-hand values, then return the same
left-hand list reference (`+`).

**Parameters**:

- `ls` ([`mods.List`] | `any[]`): Other list value.

**Returns**:

- `self` ([`mods.List`] | `any[]`): Current list.

**Example**:

```lua
a = List({ "a", "b" })
b = { "c", "d" }
c = a + b --> c and a are the same reference: { "a", "b", "c", "d" }
```

> [!NOTE]
>
> `+` operator is equivalent to `:extend(ls)`.

---

#### `__eq(ls)` {#eq}

Compare two lists using shallow element equality (`==`).

**Parameters**:

- `ls` ([`mods.List`] | `any[]`): Other list value.

**Returns**:

- `isEqual` (`boolean`): Whether the condition is met.

**Example**:

```lua
a = List({ "a", { 1 } })
b = List({ "a", { 1 } })
ok = a == b --> false (different nested table references)

t = { 1 }
a = List({ "a", t })
b = List({ "a", t })
ok = a == b --> true (same nested table reference)
```

> [!NOTE]
>
> - `==` returns `false` for `List` vs plain-table comparisons. Use
>   `:equals(ls)` for `List` vs plain-table comparisons.
>
>   ```lua
>   t = { "a", 1 }
>   a = List(t)
>   b = { "a", 1 }
>   ok = (a == b)     --> false
>   ok = a:equals(b) --> true
>   ```
>
> - Like `:equals(ls)`, `==` compares only array positions (`1..#list`), so
>   extra non-array keys are ignored when both operands are `List`.
>
>   ```lua
>   a = List({ "a", t })
>   b = List({ "a", t, extra = 1 })
>   ok = (a == b) --> true
>   ```

---

#### `__le(ls)` {#le-1}

Compare two lists lexicographically (`<=`).

**Parameters**:

- `ls` ([`mods.List`] | `any[]`): Other list value.

**Returns**:

- `isLessOrEqual` (`boolean`): Whether the condition is met.

**Example**:

```lua
ok = List({ 1, 2 }) <= List({ 1, 2 }) --> true
```

> [!NOTE]
>
> `<=` is equivalent to `:le(ls)`.

---

#### `__lt(ls)` {#lt-1}

Compare two lists lexicographically (`<`).

**Parameters**:

- `ls` ([`mods.List`] | `any[]`): Other list value.

**Returns**:

- `isLess` (`boolean`): Whether the condition is met.

**Example**:

```lua
ok = List({ 1, 2 }) < List({ 1, 3 }) --> true
```

> [!NOTE]
>
> `<` is equivalent to `:lt(ls)`.

---

#### `__mul(n)` {#mul-1}

Repeat a list `n` times (`*`).

**Parameters**:

- `n` (`integer` | [`mods.List`]): Right operand.

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
l1 = List({ "a", "b" }) * 3 --> { "a", "b", "a", "b", "a", "b" }
l2 = 3 * List({ "a", "b" }) --> { "a", "b", "a", "b", "a", "b" }
```

> [!NOTE]
>
> `*` is equivalent to `:mul(n)`.

---

#### `__sub(ls)` {#sub}

Return values from the left list that are not present in the right list (`-`).

**Parameters**:

- `ls` ([`mods.List`] | `any[]`): Other list value.

**Returns**:

- `ls` ([`mods.List`]): New list.

**Example**:

```lua
a = List({ "a", "b", "c" })
b = { "b" }
d = a - b --> { "a", "c" }
```

> [!NOTE]
>
> `-` operator is equivalent to `:difference(ls)`.

---

#### `__tostring()` {#tostring-1}

Render the list to a string like `{ "a", "b", 1 }`.

**Returns**:

- `renderedList` (`string`): Rendered list string.

**Example**:

```lua
s = tostring(List({ "a", "b", 1 })) --> '{ "a", "b", 1 }'
```

<!-- prettier-ignore-start -->
[`__add(ls)`]: #add
[`__eq(ls)`]: #eq
[`__le(ls)`]: #le-1
[`__lt(ls)`]: #lt-1
[`__mul(n)`]: #mul-1
[`__sub(ls)`]: #sub
[`__tostring()`]: #tostring-1
[`all(pred)`]: #all
[`any(pred)`]: #any
[`append()`]: #append
[`clear()`]: #clear
[`concat(sep?, i?, j?)`]: #concat
[`contains(v)`]: #contains
[`copy()`]: #copy
[`count(v)`]: #count
[`difference(t)`]: #difference
[`drop(n)`]: #drop
[`equals(ls)`]: #equals
[`extend(t)`]: #extend
[`extract(pred)`]: #extract
[`filter(pred)`]: #filter
[`first()`]: #first
[`flatten()`]: #flatten
[`foreach(fn)`]: #foreach
[`group_by(fn)`]: #group-by
[`index(v)`]: #index
[`index_if(pred)`]: #index-if
[`insert(pos, v)`]: #insert
[`insert(v)`]: #insert-1
[`intersection(t)`]: #intersection
[`invert()`]: #invert
[`isempty()`]: #isempty
[`join(sep?, quoted?)`]: #join
[`keypath()`]: #keypath
[`last()`]: #last
[`le(ls)`]: #le
[`len()`]: #len
[`lt(ls)`]: #lt
[`map(fn)`]: #map
[`mirror()`]: #mirror
[`mods.List`]: /mods/api/list
[`mods.Set`]: /mods/api/set
[`mul(n)`]: #mul
[`pop()`]: #pop
[`pop(pos)`]: #pop-1
[`prepend(v)`]: #prepend
[`reduce(fn, init?)`]: #reduce
[`remove(v)`]: #remove
[`reverse()`]: #reverse
[`shuffle(rng?)`]: #shuffle
[`slice(i?, j?)`]: #slice
[`sort(comp?)`]: #sort
[`take(n)`]: #take
[`toset()`]: #toset
[`tostring()`]: #tostring
[`uniq()`]: #uniq
[`zip(t)`]: #zip
<!-- prettier-ignore-end -->
