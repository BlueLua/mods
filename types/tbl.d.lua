---@meta mods.tbl

---
---Table operations for querying, copying, merging, and transforming tables.
---
---## Usage
---
---```lua
---tbl = require "mods.tbl"
---
---print(tbl.count({ a = 1, b = 2 })) --> 2
---```
---
---@class mods.tbl
local M = {}

---
---Remove all entries from the table.
---
---```lua
---t = { a = 1, b = 2 }
---clear(t) --> t = {}
---```
---
---@section Core Utilities
---@param t table Target table.
---@return nil none
function M.clear(t) end

---
---Return the number of keys in the table.
---
---```lua
---n = count({ a = 1, b = 2 }) --> 2
---```
---
---@section Core Utilities
---@param t table Input table.
---@return integer count Number of keys in `t`.
---@nodiscard
function M.count(t) end

---
---Create a shallow copy of the table.
---
---```lua
---t = copy({ a = 1, b = 2 }) --> { a = 1, b = 2 }
---```
---
---@section Copies
---@generic T:table
---@param t T Source table.
---@return T copy Shallow-copied table.
---@nodiscard
function M.copy(t) end

---
---Create a deep copy of a value.
---
---```lua
---t = deepcopy({ a = { b = 1 } }) --> { a = { b = 1 } }
---n = deepcopy(42) --> 42
---```
---
---> [!NOTE]
--->
---> If `v` is a table, all nested tables are copied recursively; other types
---> are returned as-is.
---
---@section Copies
---@generic T
---@param v T Input value.
---@return T copiedValue Deep-copied value.
---@nodiscard
function M.deepcopy(v) end

---
---Filter entries by a value predicate.
---
---```lua
---even = filter({ a = 1, b = 2, c = 3 }, function(v)
---  return v % 2 == 0
---end) --> { b = 2 }
---```
---
---@section Queries
---@generic K,V
---@param t table<K,V> Input table.
---@param pred fun(value:V):boolean Value predicate.
---@return table filtered Table containing entries where `pred(v)` is true.
---@nodiscard
function M.filter(t, pred) end

---
---Find the first key whose value equals the given value.
---
---```lua
---key = find({ a = 1, b = 2, c = 2 }, 2) --> "b" or "c"
---```
---
---@section Queries
---@generic K,V
---@param t table<K,V> Input table.
---@param v V Value to find.
---@return K? key First matching key, or `nil` when not found.
---@nodiscard
function M.find(t, v) end

---
---Return `true` if two tables have the same keys and equal values.
---
---```lua
---ok = is_same({ a = 1, b = 2 }, { b = 2, a = 1 }) --> true
---ok = is_same({ a = {} }, { a = {} })             --> false
---```
---
---@section Queries
---@param a table Left table.
---@param b table Right table.
---@return boolean isSame True when both tables have the same keys and values.
---@nodiscard
function M.is_same(a, b) end

---
---Return `true` if two tables are deeply equal.
---
---```lua
---ok = deep_equal({ a = { b = 1 } }, { a = { b = 1 } }) --> true
---ok = deep_equal({ a = { b = 1 } }, { a = { b = 2 } }) --> false
---```
---
---@section Queries
---@param a table Left table.
---@param b table Right table.
---@return boolean isDeepEqual True when both tables are recursively equal.
---@nodiscard
function M.deep_equal(a, b) end

---
---Find first value and key matching predicate.
---
---```lua
---v, k = find_if({ a = 1, b = 2 }, function(v, k)
---  return k == "b" and v == 2
---end) --> 2, "b"
---```
---
---@section Queries
---@generic K,V
---@param t table Input table.
---@param pred fun(key:K,value:V):boolean Predicate function.
---@return V? value First matching value, or `nil` when not found.
---@return K? key Key for the first matching value, or `nil` when not found.
---@nodiscard
function M.find_if(t, pred) end

---
---Safely get nested value by keys.
---
---```lua
---t = { a = { b = { c = 1 } } }
---v1 = get(t, "a", "b", "c") --> 1
---v2 = get(t)                --> { a = { b = { c = 1 } } }
---```
---
---> [!NOTE]
--->
---> If no keys are provided, returns the input table.
---
---@section Queries
---@param t table Root table.
---@param ... any Additional arguments.
---@return any nestedValue Nested value, or `nil` when any key is missing.
---@nodiscard
function M.get(t, ...) end

---
---Invert keys/values into new table.
---
---```lua
---t = invert({ a = 1, b = 2 }) --> { [1] = "a", [2] = "b" }
---```
---
---@section Transforms
---@generic K,V
---@param t table<K,V> Input table.
---@return table<V,K> inverted Inverted table (`value -> key`).
---@nodiscard
function M.invert(t) end

---
---Return true if table has no entries.
---
---```lua
---empty = isempty({}) --> true
---```
---
---@section Transforms
---@param t table Input table.
---@return boolean isEmpty True when `t` has no entries.
---@nodiscard
function M.isempty(t) end

---
---Return a list of all keys in the table.
---
---```lua
---keys = keys({ a = 1, b = 2 }) --> { "a", "b" }
---```
---
---@section Transforms
---@generic K,V
---@param t table<K,V> Input table.
---@return mods.List<V> keys List of keys in `t`.
---@nodiscard
function M.keys(t) end

---
---Return a new table by mapping each value (keys preserved).
---
---```lua
---t = map({ a = 1, b = 2 }, function(v)
---  return v * 10
---end) --> { a = 10, b = 20 }
---```
---
---@section Transforms
---@generic T,K,V
---@param t table<K,V> Input table.
---@param fn fun(value:V):T Mapping function.
---@return table<K,T> mapped New table with mapped values.
---@nodiscard
function M.map(t, fn) end

---
---Return a new table by mapping each key-value pair.
---
---```lua
---t = pairmap({ a = 1, b = 2 }, function(k, v)
---  return k .. v
---end) --> { a = "a1", b = "b2" }
---```
---
---> [!NOTE]
--->
---> Output keeps original keys; only values are transformed by `fn`.
---
---@section Transforms
---@generic T,K,V
---@param t table<K,V> Input table.
---@param fn fun(key:K, value:V):T Key-value mapping function.
---@return table<K,T> mapped New table with mapped values.
---@nodiscard
function M.pairmap(t, fn) end

---
---Merge entries from `t2` into `t1` and return `t1`.
---
---```lua
---t1 = { a = 1, b = 2 }
---update(t1, { b = 3, c = 4 }) --> t1 is { a = 1, b = 3, c = 4 }
---```
---
---@section Transforms
---@generic T:table
---@param t1 T Target table.
---@param t2 table Source table.
---@return T table Updated `t1` table.
function M.update(t1, t2) end

---
---Return a list of all values in the table.
---
---```lua
---vals = values({ a = 1, b = 2 }) --> { 1, 2 }
---```
---
---@section Transforms
---@generic K,V
---@param t table<K,V> Input table.
---@return mods.List<V> values List of values in `t`.
---@nodiscard
function M.values(t) end

---
---Call a function for each value in the table.
---
---```lua
---foreach({ a = 1, b = 2 }, function(v, k)
---  print(k, v)
---end)
---```
---
---@section Iterators
---@generic K,V
---@param t table<K,V> Input table.
---@param fn fun(value:V, key:K) Function invoked for each entry.
---@return nil none
function M.foreach(t, fn) end

---
---Iterate key-value pairs in sorted key order.
---
---```lua
---for k, v in spairs({ b = 2, a = 1 }) do
---  print(k, v)
---end
---```
---
---@section Iterators
---@generic T:table, K, V
---@param t T Input table.
---@return fun(table: table<K, V>, index?: K):(K, V) iterator Sorted pairs iterator.
---@return T
function M.spairs(t) end

return M
