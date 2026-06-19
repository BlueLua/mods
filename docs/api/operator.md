---
title: "operator"
description: "Lua operators exposed as functions."
---

Lua operators exposed as functions.

## Usage

```lua
operator = mods.operator

print(operator.add(1, 2)) --> 3
```

## Functions

**Arithmetic**:

| Function       | Description                                               |
| -------------- | --------------------------------------------------------- |
| [`add(a, b)`]  | Add two numbers.                                          |
| [`div(a, b)`]  | Divide `a` by `b` using Lua's floating-point division.    |
| [`idiv(a, b)`] | Divide `a` by `b` and return the floor-division quotient. |
| [`mod(a, b)`]  | Return the modulo remainder of `a` divided by `b`.        |
| [`mul(a, b)`]  | Multiply two numbers.                                     |
| [`pow(a, b)`]  | Raise `a` to the power of `b`.                            |
| [`sub(a, b)`]  | Subtract `b` from `a`.                                    |
| [`unm(a)`]     | Negate a number.                                          |

**Comparison**:

| Function      | Description                                        |
| ------------- | -------------------------------------------------- |
| [`eq(a, b)`]  | Check whether two values are equal.                |
| [`ge(a, b)`]  | Check whether `a` is greater than or equal to `b`. |
| [`gt(a, b)`]  | Check whether `a` is strictly greater than `b`.    |
| [`le(a, b)`]  | Check whether `a` is less than or equal to `b`.    |
| [`lt(a, b)`]  | Check whether `a` is strictly less than `b`.       |
| [`neq(a, b)`] | Check whether two values are not equal.            |

**Logical**:

| Function       | Description                                          |
| -------------- | ---------------------------------------------------- |
| [`land(a, b)`] | Evaluate `a and b` with Lua short-circuit semantics. |
| [`lnot(a)`]    | Return the boolean negation of `a`.                  |
| [`lor(a, b)`]  | Evaluate `a or b` with Lua short-circuit semantics.  |

**String & Length**:

| Function         | Description                                                      |
| ---------------- | ---------------------------------------------------------------- |
| [`concat(a, b)`] | Concatenate two strings.                                         |
| [`len(a)`]       | Return the length of a string or table using Lua's `#` operator. |

**Tables & Calls**:

| Function              | Description                                                    |
| --------------------- | -------------------------------------------------------------- |
| [`call(f, ...)`]      | Call a function with variadic arguments and return its result. |
| [`index(t, k)`]       | Return the value at key/index `k` in table `t`.                |
| [`setindex(t, k, v)`] | Set `t[k] = v` and return the assigned value.                  |

### Arithmetic

#### `add(a, b)` {#add}

Add two numbers.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Returns**:

- `sum` (`number`): Sum of `a` and `b`.

**Example**:

```lua
add(1, 2) --> 3
```

---

#### `div(a, b)` {#div}

Divide `a` by `b` using Lua's floating-point division.

**Parameters**:

- `a` (`number`): Dividend value.
- `b` (`number`): Divisor value.

**Returns**:

- `quotient` (`number`): Quotient `a / b`.

**Example**:

```lua
div(10, 4) --> 2.5
```

---

#### `idiv(a, b)` {#idiv}

Divide `a` by `b` and return the floor-division quotient.

**Parameters**:

- `a` (`number`): Dividend value.
- `b` (`number`): Divisor value.

**Returns**:

- `quotient` (`integer`): Floor-division result.

**Example**:

```lua
idiv(5, 2) --> 2
```

---

#### `mod(a, b)` {#mod}

Return the modulo remainder of `a` divided by `b`.

**Parameters**:

- `a` (`number`): Dividend value.
- `b` (`number`): Divisor value.

**Returns**:

- `remainder` (`number`): Remainder of `a % b`.

**Example**:

```lua
mod(5, 2) --> 1
```

---

#### `mul(a, b)` {#mul}

Multiply two numbers.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Returns**:

- `product` (`number`): Product `a * b`.

**Example**:

```lua
mul(3, 4) --> 12
```

---

#### `pow(a, b)` {#pow}

Raise `a` to the power of `b`.

**Parameters**:

- `a` (`number`): Base value.
- `b` (`number`): Exponent value.

**Returns**:

- `power` (`number`): Result of `a ^ b`.

**Example**:

```lua
pow(2, 4) --> 16
```

---

#### `sub(a, b)` {#sub}

Subtract `b` from `a`.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Returns**:

- `difference` (`number`): Difference `a - b`.

**Example**:

```lua
sub(5, 3) --> 2
```

---

#### `unm(a)` {#unm}

Negate a number.

**Parameters**:

- `a` (`number`): Input numeric value.

**Returns**:

- `negated` (`number`): Result of `-a`.

**Example**:

```lua
unm(3) --> -3
```

---

### Comparison

#### `eq(a, b)` {#eq}

Check whether two values are equal.

**Parameters**:

- `a` (`any`): Left value.
- `b` (`any`): Right value.

**Returns**:

- `isEqual` (`boolean`): True when `a == b`.

**Example**:

```lua
eq(1, 1) --> true
```

---

#### `ge(a, b)` {#ge}

Check whether `a` is greater than or equal to `b`.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Returns**:

- `isGreaterOrEqual` (`boolean`): True when `a >= b`.

**Example**:

```lua
ge(2, 2) --> true
```

---

#### `gt(a, b)` {#gt}

Check whether `a` is strictly greater than `b`.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Returns**:

- `isGreater` (`boolean`): True when `a > b`.

**Example**:

```lua
gt(3, 2) --> true
```

---

#### `le(a, b)` {#le}

Check whether `a` is less than or equal to `b`.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Returns**:

- `isLessOrEqual` (`boolean`): True when `a <= b`.

**Example**:

```lua
le(2, 2) --> true
```

---

#### `lt(a, b)` {#lt}

Check whether `a` is strictly less than `b`.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Returns**:

- `isLess` (`boolean`): True when `a < b`.

**Example**:

```lua
lt(1, 2) --> true
```

---

#### `neq(a, b)` {#neq}

Check whether two values are not equal.

**Parameters**:

- `a` (`any`): Left value.
- `b` (`any`): Right value.

**Returns**:

- `isNotEqual` (`boolean`): True when `a ~= b`.

**Example**:

```lua
neq(1, 2) --> true
```

---

### Logical

#### `land(a, b)` {#land}

Evaluate `a and b` with Lua short-circuit semantics.

**Parameters**:

- `a` (`T1`): First operand.
- `b` (`T2`): Second operand.

**Returns**:

- `andValue` (`T1` | `T2`): Result of `a and b`.

**Example**:

```lua
land(true, false) --> false
```

---

#### `lnot(a)` {#lnot}

Return the boolean negation of `a`.

**Parameters**:

- `a` (`any`): Input value.

**Returns**:

- `isNot` (`boolean`): Result of `not a`.

**Example**:

```lua
lnot(true) --> false
```

---

#### `lor(a, b)` {#lor}

Evaluate `a or b` with Lua short-circuit semantics.

**Parameters**:

- `a` (`T1`): First operand.
- `b` (`T2`): Second operand.

**Returns**:

- `orValue` (`T1` | `T2`): Result of `a or b`.

**Example**:

```lua
lor(false, true) --> true
```

---

### String & Length

#### `concat(a, b)` {#concat}

Concatenate two strings.

**Parameters**:

- `a` (`string`): Left string.
- `b` (`string`): Right string.

**Returns**:

- `concatenated` (`string`): Concatenated result `a .. b`.

**Example**:

```lua
concat("a", "b") --> "ab"
```

---

#### `len(a)` {#len}

Return the length of a string or table using Lua's `#` operator.

**Parameters**:

- `a` (`string` | `table`): Value supporting Lua's `#` operator.

**Returns**:

- `length` (`integer`): Length computed by `#a`.

**Example**:

```lua
len("abc") --> 3
```

---

### Tables & Calls

#### `call(f, ...)` {#call}

Call a function with variadic arguments and return its result.

**Parameters**:

- `f` (`fun(...:T1):T2`): Function to call.
- `...` (`T1`): Additional arguments.

**Returns**:

- `callResult` (`T2`): Return value(s) from `f(...)`.

**Example**:

```lua
call(math.max, 1, 2) --> 2
```

---

#### `index(t, k)` {#index}

Return the value at key/index `k` in table `t`.

**Parameters**:

- `t` (`table`): Source table.
- `k` (`T`): Key/index value.

**Returns**:

- `indexedValue` (`T`): Value stored at `t[k]`.

**Example**:

```lua
index({ a = 1 }, "a") --> 1
```

---

#### `setindex(t, k, v)` {#setindex}

Set `t[k] = v` and return the assigned value.

**Parameters**:

- `t` (`table`): Target table.
- `k` (`any`): Key/index value.
- `v` (`T`): Value to set.

**Returns**:

- `assignedValue` (`T`): Assigned value `v`.

**Example**:

```lua
setindex({}, "a", 1) --> 1
```

<!-- prettier-ignore-start -->
[`add(a, b)`]: #add
[`call(f, ...)`]: #call
[`concat(a, b)`]: #concat
[`div(a, b)`]: #div
[`eq(a, b)`]: #eq
[`ge(a, b)`]: #ge
[`gt(a, b)`]: #gt
[`idiv(a, b)`]: #idiv
[`index(t, k)`]: #index
[`land(a, b)`]: #land
[`le(a, b)`]: #le
[`len(a)`]: #len
[`lnot(a)`]: #lnot
[`lor(a, b)`]: #lor
[`lt(a, b)`]: #lt
[`mod(a, b)`]: #mod
[`mul(a, b)`]: #mul
[`neq(a, b)`]: #neq
[`pow(a, b)`]: #pow
[`setindex(t, k, v)`]: #setindex
[`sub(a, b)`]: #sub
[`unm(a)`]: #unm
<!-- prettier-ignore-end -->
