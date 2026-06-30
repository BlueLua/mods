---@meta _

---
---A set class for creating, combining, and querying unique values.
---
---## Usage
---
---```lua
---Set = mods.set
---
---s = Set({ "a" })
---print(s:contains("a")) --> true
---```
---
---@class mods.Set<T>:table<T,true>
---@operator add(mods.Set):mods.Set
---@operator band(mods.Set):mods.Set
---@operator bor(mods.Set):mods.Set
---@operator bxor(mods.Set):mods.Set
---@operator sub(mods.Set):mods.Set
---@overload fun(t?:any[]|mods.List):mods.Set
local Set = {}
Set.__index = Set

---
---Add an element to the set.
---
---```lua
---s = Set({ "a" }):add("b") --> s contains "a", "b"
---```
---
---@section Mutation
---@generic T:mods.Set|table<any,true>
---@param self T Current set.
---@param v any Value to add.
---@return T self Current set.
function Set:add(v) end

---
---Remove all elements from the set.
---
---```lua
---s = Set({ "a", "b" }):clear() --> s is empty
---```
---
---@section Mutation
---@generic T:mods.Set|table<any,true>
---@param self T Current set.
---@return T self Current set.
function Set:clear() end

---
---Remove elements found in another set (in place).
---
---```lua
---s = Set({ "a", "b" }):difference_update(Set({ "b" })) --> s contains "a"
---```
---
---@section Mutation
---@generic T:mods.Set|table<any,true>
---@param self T Current set.
---@param set T|mods.List Other set/list.
---@return T self Current set.
function Set:difference_update(set) end

---
---Keep only elements common to both sets (in place).
---
---```lua
---s = Set({ "a", "b" }):intersection_update(Set({ "b", "c" }))
-----> s contains "b"
---```
---
---@section Mutation
---@generic T:mods.Set|table<any,true>
---@param self T Current set.
---@param set T|mods.List Other set/list.
---@return T self Current set.
function Set:intersection_update(set) end

---
---Remove and return an arbitrary element.
---
---```lua
---v = Set({ "a", "b" }):pop() --> v is either "a" or "b"
---```
---
---@section Mutation
---@param self mods.Set|table<any,true> Current set.
---@return any removedValue Removed value, or `nil` when the set is empty.
function Set:pop() end

---
---Update the set with elements not shared by both (in place).
---
---```lua
---s = Set({ "a", "b" }):symmetric_difference_update(Set({ "b", "c" }))
-----> s contains "a", "c"
---```
---
---@section Mutation
---@generic T:mods.Set|table<any,true>
---@param self T Current set.
---@param set T|mods.List Other set/list.
---@return T self Current set.
function Set:symmetric_difference_update(set) end

---
---Add all elements from another set (in place).
---
---```lua
---s = Set({ "a" }):update(Set({ "b" })) --> s contains "a", "b"
---```
---
---@section Mutation
---@generic T:mods.Set|table<any,true>
---@param self T Current set.
---@param set T|mods.List Other set/list.
---@return T self Current set.
function Set:update(set) end

---
---Return a shallow copy of the set.
---
---```lua
---c = Set({ "a" }):copy() --> c is a new set with "a"
---```
---
---@section Set Operations
---@param self mods.Set|table<any,true> Current set.
---@return mods.Set set New set.
---@nodiscard
function Set:copy() end

---
---Check whether a value is present in the set without following the metatable.
---
---```lua
---s = Set({ "a", "b", "c" })
---print(s:has("a"))       --> true
---print(s:has("__index")) --> false
---```
---
---@section Set Operations
---@param self mods.Set|table<any,true> Current set.
---@param v any Value to look up.
---@return boolean present Whether the value is present.
---@nodiscard
function Set:has(v) end

---
---Return elements in this set but not in another.
---
---```lua
---d = Set({ "a", "b" }):difference(Set({ "b" })) --> d contains "a"
---```
---
---> [!NOTE]
--->
---> `difference` is also available as the `__sub` (`-`) operator.
---> `a:difference(b)` is equivalent to `a - b`.
---
---@section Set Operations
---@param self mods.Set|table<any,true> Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return mods.Set set New set.
---@nodiscard
function Set:difference(t) end

---
---Return elements common to both sets.
---
---```lua
---i = Set({ "a", "b" }):intersection(Set({ "b", "c" })) --> i contains "b"
---```
---
---> [!NOTE]
--->
---> `intersection` is also available as `__band` (`&`) on Lua 5.3+.
---
---@section Set Operations
---@param self mods.Set|table<any,true> Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return mods.Set set New set.
---@nodiscard
function Set:intersection(t) end

---
---Remove an element if present, do nothing otherwise.
---
---```lua
---s = Set({ "a", "b" }):remove("b") --> s contains "a"
---```
---
---@section Set Operations
---@generic T:mods.Set|table<any,true>
---@param self T Current set.
---@param v any Value to remove.
---@return T self Current set.
function Set:remove(v) end

---
---Return elements not shared by both sets.
---
---```lua
---d = Set({ "a", "b" }):symmetric_difference(Set({ "b", "c" }))
-----> d contains "a", "c"
---```
---
---> [!NOTE]
--->
---> `symmetric_difference` is also available as `__bxor` (`^`) on Lua 5.3+.
---
---@section Set Operations
---@param self mods.Set|table<any,true> Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return mods.Set set New set.
---@nodiscard
function Set:symmetric_difference(t) end

---
---Return a new set with all elements from both.
---
---```lua
---s = Set({ "a" }):union(Set({ "b" })) --> s contains "a", "b"
---```
---
---> [!NOTE]
--->
---> `union` is available as `__add` (`+`) and `__bor` (`|`) on Lua 5.3+.
---> `a:union(b)` is equivalent to `a + b` and `a | b`.
---
---@section Set Operations
---@param self mods.Set|table<any,true> Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return mods.Set set New set.
---@nodiscard
function Set:union(t) end

---
---Return true if sets have no elements in common.
---
---```lua
---ok = Set({ "a" }):isdisjoint(Set({ "b" })) --> true
---```
---
---@section Predicates
---@generic T:mods.Set|table<any,true>
---@param self T Current set.
---@param set T|mods.List Other set/list.
---@return boolean isDisjoint True when sets have no elements in common.
---@nodiscard
function Set:isdisjoint(set) end

---
---Return true when both sets contain exactly the same members.
---
---```lua
---a = Set({ "a", "b" })
---b = Set({ "b", "a" })
---ok = a:equals(b) --> true
---```
---
---> [!NOTE]
--->
---> `equals` is also available as the `__eq` (`==`) operator.
---> `a:equals(b)` is equivalent to `a == b`.
---
---@section Predicates
---@param self mods.Set|table<any,true> Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return boolean isEqual True when both sets contain the same members.
---@nodiscard
function Set:equals(t) end

---
---Return true if the set has no elements.
---
---```lua
---empty = Set({}):isempty() --> true
---```
---
---@section Predicates
---@param self mods.Set|table<any,true> Current set.
---@return boolean isEmpty True when the set has no elements.
---@nodiscard
function Set:isempty() end

---
---Return true if all elements of this set are also in another set.
---
---```lua
---ok = Set({ "a" }):issubset(Set({ "a", "b" })) --> true
---```
---
---> [!NOTE]
--->
---> `issubset` is also available as the `__le` (`<=`) operator.
---> `a:issubset(b)` is equivalent to `a <= b`.
---
---@section Predicates
---@param self mods.Set|table<any,true> Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return boolean isSubset True when every element of `self` exists in `set`.
---@nodiscard
function Set:issubset(t) end

---
---Return true if this set contains all elements of another set.
---
---```lua
---ok = Set({ "a", "b" }):issuperset(Set({ "a" })) --> true
---```
---
---@section Predicates
---@param self mods.Set|table<any,true> Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return boolean isSuperset True when `self` contains every element of `set`.
---@nodiscard
function Set:issuperset(t) end

---
---Return true if the set contains `v`.
---
---```lua
---ok = Set({ "a", "b" }):contains("a") --> true
---ok = Set({ "a", "b" }):contains("z") --> false
---```
---
---@section Queries
---@param self mods.Set|table<any,true> Current set.
---@param v any Value to check.
---@return boolean isPresent True when `v` is present in the set.
---@nodiscard
function Set:contains(v) end

---
---Return the number of elements in the set.
---
---```lua
---n = Set({ "a", "b" }):len() --> 2
---```
---
---@section Queries
---@param self mods.Set|table<any,true> Current set.
---@return integer count Element count.
---@nodiscard
function Set:len() end

---
---Return a new set by mapping each value.
---
---```lua
---s = Set({ 1, 2 }):map(function(v) return v * 10 end) --> s contains 10, 20
---```
---
---@section Transforms
---@param self mods.Set|table<any,true> Current set.
---@param fn fun(v:any):any Mapping function.
---@return mods.Set set New set.
---@nodiscard
function Set:map(fn) end

---
---Mirror values into a new table as both keys and values.
---
---```lua
---mirrored = Set({ "a", "b" }):mirror() --> { a = "a", b = "b" }
---```
---
---@section Transforms
---@generic K
---@param self table<K,true> Current set.
---@return table<K,K> mirroredValues Table mapping each value to itself.
---@nodiscard
function Set:mirror() end

---
---Return a list of all values in the set.
---
---```lua
---values = Set({ "a", "b" }):values() --> { "a", "b" }
---```
---
---@section Transforms
---@param self mods.Set|table<any,true> Current set.
---@return mods.List values List of set values.
---@nodiscard
function Set:values() end

---
---Render the set as a string.
---
---```lua
---s = Set({ "b", "a", 1 }):tostring() --> '{ 1, "a", "b" }'
---```
---
---@section Transforms
---@param self mods.Set|table<any,true> Current set.
---@return string renderedSet Rendered set string.
---@nodiscard
function Set:tostring() end

---
---Join set values into a string.
---
---```lua
---s = Set({ "b", "a" }):join(", ")       --> "a, b"
---s = Set({ "b", "a" }):join(", ", true) --> '"a", "b"'
---```
---
---> [!NOTE]
--->
---Join order is not guaranteed.
---
---@section Transforms
---@param self mods.Set|table<any,true> Current set.
---@param sep? string Optional separator value (defaults to `""`).
---@param quoted? boolean Optional boolean flag (defaults to `false`).
---@return string joined Joined string.
---@nodiscard
function Set:join(sep, quoted) end

---
---Return the union of two sets using `+`.
---
---```lua
---a = Set({ "a", "b" })
---b = Set({ "b", "c" })
---u = a + b --> { a = true, b = true, c = true }
---```
---
---> [!NOTE]
--->
---> `__add` is the operator form of `:union(set)`.
---
---@section Metamethods
---@param self mods.Set Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return mods.Set set New set.
function Set.__add(self, t) end

---
---Return the union of two sets using `|`.
---
---```lua
---a = Set({ "a", "b" })
---b = Set({ "b", "c" })
---u = a | b --> { a = true, b = true, c = true }
---```
---
---> [!NOTE]
--->
---> `__bor` is the operator form of `:union(set)` on Lua 5.3+.
---
---@section Metamethods
---@param self mods.Set Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return mods.Set set New set.
function Set.__bor(self, t) end

---
---Return the intersection of two sets using `&`.
---
---```lua
---a = Set({ "a", "b" })
---b = Set({ "b", "c" })
---i = a & b --> { b = true }
---```
---
---> [!NOTE]
--->
---> `__band` is the operator form of `:intersection(set)` on Lua 5.3+.
---
---@section Metamethods
---@param self mods.Set Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return mods.Set set New set.
function Set.__band(self, t) end

---
---Return elements present in exactly one set using `^`.
---
---```lua
---a = Set({ "a", "b" })
---b = Set({ "b", "c" })
---d = a ^ b --> { a = true, c = true }
---```
---
---> [!NOTE]
--->
---> `__bxor` is the operator form of `:symmetric_difference(set)` on Lua 5.3+.
---
---@section Metamethods
---@param self mods.Set Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return mods.Set set New set.
function Set.__bxor(self, t) end

---
---Return true if both sets contain exactly the same members using `==`.
---
---```lua
---ok = Set({ "a", "b" }) == Set({ "b", "a" }) --> true
---```
---
---> [!NOTE]
--->
---> `__eq` is the operator form of `:equals(set)`.
---
---@section Metamethods
---@param self mods.Set Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return boolean isEqual True when both sets contain the same members.
function Set.__eq(self, t) end

---
---Return true if the left set is a subset of the right set using `<=`.
---
---```lua
---a = Set({ "a" })
---b = Set({ "a", "b" })
---ok = a <= b --> true
---```
---
---> [!NOTE]
--->
---> `__le` is the operator form of `:issubset(set)`.
---
---@section Metamethods
---@param self mods.Set Current set.
---@param t mods.Set|mods.List|table<any,true> Other set/list.
---@return boolean isSubset True when `self` is a subset of `set`.
function Set.__le(self, t) end

---
---Return true if the left set is a proper subset of the right set using `<`.
---
---```lua
---a = Set({ "a" })
---b = Set({ "a", "b" })
---ok = a < b --> true
---```
---
---@section Metamethods
---@param self mods.Set Current set.
---@param set mods.Set|table<any,true> Other set.
---@return boolean isProperSubset True when `self` is a proper subset of `set`.
function Set.__lt(self, set) end

---
---Return the difference of two sets using `-`.
---
---```lua
---a = Set({ "a", "b" })
---b = Set({ "b", "c" })
---d = a - b --> { a = true }
---```
---
---> [!NOTE]
--->
---> `__sub` is the operator form of `:difference(set)`.
---
---@section Metamethods
---@param self mods.Set Current set.
---@param set mods.Set|table<any,true> Other set.
---@return mods.Set set New set.
function Set.__sub(self, set) end

---
---Render the set via `tostring(set)`.
---
---```lua
---s = tostring(Set({ "b", "a", 1 })) --> '{ 1, "a", "b" }'
---```
---
---@section Metamethods
---@param self mods.Set Current set.
---@return string renderedSet Rendered set string.
function Set.__tostring(self) end

return Set
