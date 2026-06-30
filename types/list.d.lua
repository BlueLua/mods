---@meta _

---
---A list class for creating, transforming, and querying sequences of values.
---
---## Usage
---
---```lua
---List = mods.list
---
---ls = List({ "a" }):append("b")
---print(ls:contains("b")) --> true
---print(ls:index("b"))    --> 2
---```
---
---> [!NOTE]
--->
---> `List(t)` wraps `t` with the `List` metatable in place. It does not copy or
---> filter table values. `List(t):copy()` or `List.copy(t)` both copy only
---> `1..#t` and wrap `t` as a List.
---
---@class mods.List<T>:table<integer,T>
---@operator add(mods.List):mods.List
---@operator mul(integer):mods.List
---@operator sub(mods.List):mods.List
---@overload fun(t?:{}):mods.List
local List = {}
List.__index = List

---
---Return `true` if all values match the predicate.
---
---```lua
---is_even = function(v) return v % 2 == 0 end
---ok = List({ 2, 4 }):all(is_even) --> true
---```
---
---> [!NOTE]
--->
---> Empty lists return `true`.
---
---@section Predicates
---@param self mods.List|any[] Current list.
---@param pred fun(v:any):boolean Predicate function.
---@return boolean allMatch Whether the condition is met.
---@nodiscard
function List:all(pred) end

---
---Return `true` if any value matches the predicate.
---
---```lua
---has_len_2 = function(v) return #v == 2 end
---ok = List({ "a", "bb" }):any(has_len_2) --> true
---```
---
---@section Predicates
---@param self mods.List|any[] Current list.
---@param pred fun(v:any):boolean Predicate function.
---@return boolean anyMatch Whether the condition is met.
---@nodiscard
function List:any(pred) end

---
---Compare two lists using shallow element equality.
---
---```lua
---a = List({ "x", "y" })
---b = List({ "x", "y" })
---ok = a:equals(b) --> true
---```
---
---> [!NOTE]
--->
---> * `equals` is also available through the `==` operator when both
--->   operands are `List`.
--->
--->   ```lua
--->   a = List({ "a", 1 })
--->   b = List({ "a", 1 })
--->   ok = (a == b) --> true
--->   ```
--->
---> * Unlike `==`, this method also works when `ls` is a plain array table.
--->
--->   ```lua
--->   a = List({ "a", 1 })
--->   b = { "a", 1 }
--->   ok = a:equals(b) --> true
--->   ```
--->
---> * `equals` checks only array positions (`1..#list`), so extra non-array
--->   keys are ignored:
--->
--->   ```lua
--->   t = {}
--->   a = List({ "a", t })
--->   b = { "a", t, a = 1 }
--->   ok = a:equals(b) --> true
--->   ```
---
---@section Predicates
---@param self mods.List|any[] Current list.
---@param ls mods.List|any[] Other list value.
---@return boolean isEqual Whether the condition is met.
---@nodiscard
function List:equals(ls) end

---
---Compare two lists lexicographically.
---
---```lua
---ok = List({ 1, 2 }):lt({ 1, 3 })    --> true
---ok = List({ 1, 2 }):lt({ 1, 2, 0 }) --> true
---```
---
---> [!NOTE]
--->
---> `lt` is also available through the `<` operator.
---
---@section Predicates
---@param self mods.List|any[] Current list.
---@param ls mods.List|any[] Other list value.
---@return boolean isLess Whether the condition is met.
---@nodiscard
function List:lt(ls) end

---
---Compare two lists lexicographically.
---
---```lua
---ok = List({ 1, 2 }):le({ 1, 2 })  --> true
---ok = List({ 1, 2 }):le({ 1, 1 })  --> false
---```
---
---> [!NOTE]
--->
---> `le` is also available through the `<=` operator.
---
---@section Predicates
---@param self mods.List|any[] Current list.
---@param ls mods.List|any[] Other list value.
---@return boolean isLessOrEqual Whether the condition is met.
---@nodiscard
function List:le(ls) end

---
---Append a value to the end of the list.
---
---```lua
---ls = List({ "a" }):append("b") --> { "a", "b" }
---```
---
---@section Mutation
---@generic T:mods.List|any[]
---@param self T Current list.
---@return T self Current list.
function List:append(v) end

---
---Remove all elements from the list.
---
---```lua
---ls = List({ "a", "b" }):clear() --> { }
---```
---
---@section Mutation
---@generic T:mods.List|any[]
---@param self T Current list.
---@return T self Current list.
function List:clear() end

---
---Extend the list with another list or set.
---
---```lua
---ls = List({ "a" }):extend({ "b", "c" })      --> { "a", "b", "c" }
---ls = List({ "a" }):extend(Set({ "b", "c" })) --> { "a", "b", "c" }
---```
---
---> [!NOTE]
--->
---> `extend` is also available through the `+` operator.
---
---@section Mutation
---@generic T:mods.List|any[]
---@param self T Current list.
---@param t mods.List|mods.Set|any[] Values to append.
---@return T self Current list.
function List:extend(t) end

---
---Extract values matching the predicate and remove them from the list.
---
---```lua
---ls = List({ "a", "bb", "c" })
---is_len_1 = function(v) return #v == 1 end
---ex = ls:extract(is_len_1) --> ex = { "a", "c" }, ls = { "bb" }
---```
---
---@section Mutation
---@generic T:mods.List|any[]
---@param self T Current list.
---@param pred fun(v:any):boolean Predicate function.
---@return mods.List ls Extracted values.
---@nodiscard
function List:extract(pred) end

---
---Insert a value at the given position.
---
---```lua
---ls = List({ "a", "c" }):insert(2, "b") --> { "a", "b", "c" }
---```
---
---@section Mutation
---@generic T:mods.List|any[]
---@param self T Current list.
---@param pos integer Insert position.
---@param v any Value to insert.
---@return T self Current list.
function List:insert(pos, v) end

---
---Append a value to the end of the list.
---
---```lua
---ls = List({ "a", "b" }):insert("c") --> { "a", "b", "c" }
---```
---
---@section Mutation
---@generic T:mods.List|any[]
---@param self T Current list.
---@param v any Value to append.
---@return T self Current list.
function List:insert(v) end

---
---Remove and return the last element.
---
---```lua
---ls = List({ "a", "b" })
---v = ls:pop() --> v == "b"; ls is { "a" }
---```
---
---@section Mutation
---@param self mods.List|any[] Current list.
---@return any removedValue Removed value.
function List:pop() end

---
---Remove and return the element at the given position.
---
---```lua
---ls = List({ "a", "b", "c" })
---v = ls:pop(2) --> v == "b"; ls is { "a", "c" }
---```
---
---@section Mutation
---@param self mods.List|any[] Current list.
---@param pos integer Numeric value.
---@return any removedValue Removed value.
function List:pop(pos) end

---
---Insert a value at the start of the list.
---
---```lua
---ls = List({ "b", "c" })
---ls:prepend("a") --> { "a", "b", "c" }
---```
---
---@section Mutation
---@generic T:mods.List|any[]
---@param self T Current list.
---@param v any Value to validate.
---@return T self Current list.
function List:prepend(v) end

---
---Remove the first matching value.
---
---```lua
---ls = List({ "a", "b", "b" })
---ls:remove("b") --> { "a", "b" }
---```
---
---@section Mutation
---@generic T:mods.List|any[]
---@param self T Current list.
---@param v any Value to validate.
---@return T self Current list.
function List:remove(v) end

---
---Sort the list in place.
---
---```lua
---ls = List({ 3, 1, 2 })
---ls:sort() --> { 1, 2, 3 }
---
---words = List({ "ccc", "a", "bb" })
---words:sort(function(a, b)
---  return #a < #b
---end) --> { "a", "bb", "ccc" }
---```
---
---@section Mutation
---@generic T:mods.List|any[]
---@param self T Current list.
---@param comp? fun(a:any, b:any):boolean Optional comparison function (defaults to `nil`).
---@return T self Current list.
function List:sort(comp) end

---
---Shuffle the list in place.
---
---```lua
---ls = List({ "a", "b", "c" }):shuffle() --> { "b", "c", "a" } -- order varies
---```
---
---@section Mutation
---@generic T:mods.List|any[]
---@param self T Current list.
---@param rng? fun(lo:integer, hi:integer):integer Optional random index picker; defaults to `math.random`.
---@return T self Current list.
function List:shuffle(rng) end

---
---Return a shallow copy of the list.
---
---```lua
---c = List({ "a", "b" }):copy() --> { "a", "b" }
---```
---
---@section Copies
---@param self mods.List|any[] Current list.
---@return mods.List ls New list.
---@nodiscard
function List:copy() end

---
---Return `true` if the list contains the value.
---
---```lua
---ok = List({ "a", "b" }):contains("b") --> true
---```
---
---@section Queries
---@param self mods.List|any[] Current list.
---@param v any Value to validate.
---@return boolean isPresent True when `v` is present in the list.
---@nodiscard
function List:contains(v) end

---
---Count how many times a value appears.
---
---```lua
---n = List({ "a", "b", "b" }):count("b") --> 2
---```
---
---@section Queries
---@param self mods.List|any[] Current list.
---@param v any Value to validate.
---@return integer res Result count.
---@nodiscard
function List:count(v) end

---
---Return the index of the first matching value.
---
---```lua
---i = List({ "a", "b", "c", "b" }):index("b") --> 2
---```
---
---@section Queries
---@param self mods.List|any[] Current list.
---@param v any Value to validate.
---@return integer? index Result index, or nil when not found.
---@nodiscard
function List:index(v) end

---
---Return the index of the first value matching the predicate.
---
---```lua
---gt_1 = function(x) return x > 1 end
---i = List({ 1, 2, 3 }):index_if(gt_1) --> 2
---```
---
---@section Queries
---@param self mods.List|any[] Current list.
---@param pred fun(v:any):boolean Predicate function.
---@return integer? index Result index, or nil when no value matches.
---@nodiscard
function List:index_if(pred) end

---
---Return the length of the list, defined by its maximum positive integer index.
---
---```lua
---n = List({ "a", nil, "c" }):len() --> 3
---```
---
---@section Queries
---@param self mods.List|any[] Current list.
---@return integer length List length.
---@nodiscard
function List:len() end

---
---Return whether the list has no elements.
---
---```lua
---ok = List():isempty() --> true
---```
---
---@section Queries
---@param self mods.List|any[] Current list.
---@return boolean empty `true` when the list has no elements.
---@nodiscard
function List:isempty() end

---
---Return the first element or `nil` if empty.
---
---```lua
---v = List({ "a", "b" }):first() --> "a"
---```
---
---@section Access
---@param self mods.List|any[] Current list.
---@return any firstValue First value, or `nil` if empty.
---@nodiscard
function List:first() end

---
---Return the last element or `nil` if empty.
---
---```lua
---v = List({ "a", "b" }):last() --> "b"
---```
---
---@section Access
---@param self mods.List|any[] Current list.
---@return any lastValue Last value, or `nil` if empty.
---@nodiscard
function List:last() end

---
---Return a new list with values not in the given list or set.
---
---```lua
---d = List({ "a", "b", "c" }):difference({ "b" }) --> { "a", "c" }
---```
---
---> [!NOTE]
--->
---> `difference` is also available through the `-` operator.
---
---@section Transforms
---@generic T:mods.List|any[]
---@param self T Current list.
---@param t mods.List|mods.Set|any[] Values to remove.
---@return T ls New list.
---@nodiscard
function List:difference(t) end

---
---Return a new list without the first n elements.
---
---```lua
---t = List({ "a", "b", "c" }):drop(1) --> { "b", "c" }
---```
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param n integer Numeric value.
---@return mods.List ls New list.
---@nodiscard
function List:drop(n) end

---
---Return a new list with values matching the predicate.
---
---```lua
---is_len_1 = function(v) return #v == 1 end
---f = List({ "a", "bb", "c" }):filter(is_len_1) --> { "a", "c" }
---```
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param pred fun(v:any):boolean Predicate function.
---@return mods.List ls New list.
---@nodiscard
function List:filter(pred) end

---
---Flatten one level of nested lists.
---
---```lua
---f = List({ { "a", "b" }, { "c" } }):flatten() --> { "a", "b", "c" }
---```
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@return mods.List ls New list.
---@nodiscard
function List:flatten() end

---
---Apply a function to each element (for side effects).
---
---```lua
---List({ "a", "b" }):foreach(print)
-----> prints -> a
-----> prints -> b
---```
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param fn fun(v:any) Callback function.
---@return nil none
function List:foreach(fn) end

---
---Group list values by a computed key.
---
---```lua
---words = { "aa", "b", "ccc", "dd" }
---g = List(words):group_by(string.len) --> { {"b"}, { "aa", "dd" }, { "ccc" } }
---```
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param fn fun(v:any):any Callback function.
---@return table groups Groups keyed by the callback result.
---@nodiscard
function List:group_by(fn) end

---
---Return values that are also present in the given list or set.
---
---```lua
---i = List({ "a", "b", "a", "c" }):intersection({ "a", "c" })
-----> { "a", "a", "c" }
---```
---
---> [!NOTE]
--->
---> Order is preserved from the original list.
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param t mods.List|mods.Set|any[] Other list/set.
---@return mods.List ls New list.
---@nodiscard
function List:intersection(t) end

---
---Invert values to indices in a new table.
---
---```lua
---t = List({ "a", "b", "c" }):invert() --> { a = 1, b = 2, c = 3 }
---```
---
---@section Transforms
---@generic K, V
---@param self mods.List|any[] Current list.
---@return table<V,K> idxByValue Table mapping each value to its last index.
---@nodiscard
function List:invert() end

---
---Mirror values into a new table as both keys and values.
---
---```lua
---t = List({ "a", "b", "c" }):mirror() --> { a = "a", b = "b", c = "c" }
---```
---
---@section Transforms
---@generic T
---@param self mods.List|T[] Current list.
---@return table<T,T> mirroredValues Table mapping each value to itself.
---@nodiscard
function List:mirror() end

---
---Concatenate list values using Lua's native `table.concat` behavior.
---
---```lua
---s = List({ "a", "b", "c" }):concat(",") --> "a,b,c"
---```
---
---> [!NOTE]
--->
---> This method forwards to `table.concat` directly and keeps its strict
---> element rules.
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param sep? string Optional separator value (defaults to `""`).
---@param i? integer Optional start index (defaults to `1`).
---@param j? integer Optional end index (defaults to `#self`).
---@return string concatenated Concatenated string.
---@nodiscard
function List:concat(sep, i, j) end

---
---Join list values into a string.
---
---```lua
---s = List({ "a", "b", "c" }):join(",")        --> "a,b,c"
---s = List({ "a", "b", "c" }):join(", ", true) --> '"a", "b", "c"'
---```
---
---> [!NOTE]
--->
---> Values are converted with `tostring` before joining.
---> Set `quoted = true` to quote string values.
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param sep? string Optional separator value (defaults to `""`).
---@param quoted? boolean Optional boolean flag (defaults to `false`).
---@return string joined Joined string.
---@nodiscard
function List:join(sep, quoted) end

---
---Render the list to a string via the regular method form.
---
---```lua
---s = List({ "a", "b", 1 }):tostring() --> '{ "a", "b", 1 }'
---```
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@return string renderedList Rendered list string.
---@nodiscard
function List:tostring() end

---
---Render list items as a table-access key path.
---
---```lua
---p = List({ "ctx", "users", 1, "name" }):keypath() --> "ctx.users[1].name"
---```
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@return string keyPath Key-path string.
---@nodiscard
function List:keypath() end

---
---Return a new list by mapping each value.
---
---```lua
---to_upper = function(v) return v:upper() end
---m = List({ "a", "b" }):map(to_upper) --> { "A", "B" }
---```
---
---@section Transforms
---@generic T
---@param self mods.List<T>|T[] Current list.
---@param fn fun(value:T):any Callback function.
---@return mods.List ls New list.
---@nodiscard
function List:map(fn) end

---
---Return a new list repeated `n` times (list multiplication behavior).
---
---```lua
---ls = List({ "a", "b" }):mul(3) --> { "a", "b", "a", "b", "a", "b" }
---```
---
---> [!NOTE]
--->
---> `mul` is also available through the `*` operator.
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param n integer Numeric value.
---@return mods.List ls New list.
---@nodiscard
function List:mul(n) end

---
---Reduce the list to a single value using an accumulator.
---
---```lua
---add = function(acc, v) return acc + v end
---sum = List({ 1, 2, 3 }):reduce(add, 0) --> 6
---sum = List({ 1, 2, 3 }):reduce(add, 10) --> 16
---```
---
---> [!NOTE]
--->
---> For empty lists, returns `init` unchanged (or `nil` when omitted).
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param fn fun(acc:any, v:any):any Reducer function.
---@param init? any Optional initial accumulator; for non-empty lists, `nil` or omitted uses the first item.
---@return any reducedValue Reduced value.
---@nodiscard
function List:reduce(fn, init) end

---
---Reverse the list in place.
---
---```lua
---r = List({ "a", "b", "c" }):reverse() --> { "c", "b", "a" }
---```
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@return mods.List ls Same list, reversed in place.
function List:reverse() end

---
---Convert the list to a set.
---
---```lua
---s = List({ "a", "b", "a" }):toset() --> { a = true, b = true }
---```
---
---> [!NOTE]
--->
---> Order is preserved from the original list.
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@return mods.Set set New set.
---@nodiscard
function List:toset() end

---
---Return a new list containing items from i to j (inclusive).
---
---```lua
---t = List({ "a", "b", "c", "d" }):slice(2, 3) --> { "b", "c" }
---```
---
---> [!NOTE]
--->
---> Supports negative indices (-1 is last element).
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param i? integer Optional start index (defaults to `1`).
---@param j? integer Optional end index (defaults to `#self`).
---@return mods.List ls New list.
---@nodiscard
function List:slice(i, j) end

---
---Return the first n elements as a new list.
---
---```lua
---t = List({ "a", "b", "c" }):take(2) --> { "a", "b" }
---```
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param n integer Numeric value.
---@return mods.List ls New list.
---@nodiscard
function List:take(n) end

---
---Return a new list with duplicates removed (first occurrence kept).
---
---```lua
---u = List({ "a", "b", "a", "c" }):uniq() --> { "a", "b", "c" }
---```
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@return mods.List ls New list.
---@nodiscard
function List:uniq() end

---
---Zip two collections into a list of 2-element tables.
---
---```lua
---z = List({ "a", "b" }):zip({ 1, 2 })      --> { {"a",1}, {"b",2} }
---z = List({ "a", "b" }):zip(Set({ 1, 2 })) --> { {"a",1}, {"b",2} }
---```
---
---> [!NOTE]
--->
---> Length is the minimum of both tables' lengths.
---
---@section Transforms
---@param self mods.List|any[] Current list.
---@param t mods.List|mods.Set|any[] Values to pair with.
---@return mods.List ls New list.
---@nodiscard
function List:zip(t) end

---Compare two lists using shallow element equality (`==`).
---
---```lua
---a = List({ "a", { 1 } })
---b = List({ "a", { 1 } })
---ok = a == b --> false (different nested table references)
---
---t = { 1 }
---a = List({ "a", t })
---b = List({ "a", t })
---ok = a == b --> true (same nested table reference)
---```
---
---> [!NOTE]
--->
---> * `==` returns `false` for `List` vs plain-table comparisons.
--->   Use `:equals(ls)` for `List` vs plain-table comparisons.
--->
--->   ```lua
--->   t = { "a", 1 }
--->   a = List(t)
--->   b = { "a", 1 }
--->   ok = (a == b)     --> false
--->   ok = a:equals(b) --> true
--->   ```
--->
---> * Like `:equals(ls)`, `==` compares only array positions (`1..#list`), so
--->   extra non-array keys are ignored when both operands are `List`.
--->
--->   ```lua
--->   a = List({ "a", t })
--->   b = List({ "a", t, extra = 1 })
--->   ok = (a == b) --> true
--->   ```
---
---@section Metamethods
---@param self mods.List Current list.
---@param ls mods.List|any[] Other list value.
---@return boolean isEqual Whether the condition is met.
function List.__eq(self, ls) end

---
---Compare two lists lexicographically (`<`).
---
---```lua
---ok = List({ 1, 2 }) < List({ 1, 3 }) --> true
---```
---
---> [!NOTE]
--->
---> `<` is equivalent to `:lt(ls)`.
---
---@section Metamethods
---@param self mods.List Current list.
---@param ls mods.List|any[] Other list value.
---@return boolean isLess Whether the condition is met.
function List.__lt(self, ls) end

---
---Compare two lists lexicographically (`<=`).
---
---```lua
---ok = List({ 1, 2 }) <= List({ 1, 2 }) --> true
---```
---
---> [!NOTE]
--->
---> `<=` is equivalent to `:le(ls)`.
---
---@section Metamethods
---@param self mods.List Current list.
---@param ls mods.List|any[] Other list value.
---@return boolean isLessOrEqual Whether the condition is met.
function List.__le(self, ls) end

---
---Repeat a list `n` times (`*`).
---
---```lua
---l1 = List({ "a", "b" }) * 3 --> { "a", "b", "a", "b", "a", "b" }
---l2 = 3 * List({ "a", "b" }) --> { "a", "b", "a", "b", "a", "b" }
---```
---
---> [!NOTE]
--->
---> `*` is equivalent to `:mul(n)`.
---
---@section Metamethods
---@param self integer|mods.List Left operand.
---@param n integer|mods.List Right operand.
---@return mods.List ls New list.
function List.__mul(self, n) end

---
---Extend the left-hand list in place with right-hand values, then return the
---same left-hand list reference (`+`).
---
---```lua
---a = List({ "a", "b" })
---b = { "c", "d" }
---c = a + b --> c and a are the same reference: { "a", "b", "c", "d" }
---```
---
---> [!NOTE]
--->
---> `+` operator is equivalent to `:extend(ls)`.
---
---@section Metamethods
---@param self mods.List Current list.
---@param ls mods.List|any[] Other list value.
---@return mods.List|any[] self Current list.
function List.__add(self, ls) end

---
---Return values from the left list that are not present in the right list (`-`).
---
---```lua
---a = List({ "a", "b", "c" })
---b = { "b" }
---d = a - b --> { "a", "c" }
---```
---
---> [!NOTE]
--->
---> `-` operator is equivalent to `:difference(ls)`.
---
---@section Metamethods
---@param self mods.List Current list.
---@param ls mods.List|any[] Other list value.
---@return mods.List ls New list.
function List.__sub(self, ls) end

---
---Render the list to a string like `{ "a", "b", 1 }`.
---
---```lua
---s = tostring(List({ "a", "b", 1 })) --> '{ "a", "b", 1 }'
---```
---
---@section Metamethods
---@param self mods.List Current list.
---@return string renderedList Rendered list string.
function List.__tostring(self) end

return List
