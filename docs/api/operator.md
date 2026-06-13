---
description: "Lua operators exposed as functions."
---

# `operator`

Lua operators exposed as functions.

## Usage

```lua
operator = require "mods.operator"

print(operator.add(1, 2)) --> 3
```

## Functions

**Arithmetic**:

| Function                 | Description                                               |
| ------------------------ | --------------------------------------------------------- |
| [`add(a, b)`](#fn-add)   | Add two numbers.                                          |
| [`div(a, b)`](#fn-div)   | Divide `a` by `b` using Lua's floating-point division.    |
| [`idiv(a, b)`](#fn-idiv) | Divide `a` by `b` and return the floor-division quotient. |
| [`mod(a, b)`](#fn-mod)   | Return the modulo remainder of `a` divided by `b`.        |
| [`mul(a, b)`](#fn-mul)   | Multiply two numbers.                                     |
| [`pow(a, b)`](#fn-pow)   | Raise `a` to the power of `b`.                            |
| [`sub(a, b)`](#fn-sub)   | Subtract `b` from `a`.                                    |
| [`unm(a)`](#fn-unm)      | Negate a number.                                          |

**Comparison**:

| Function               | Description                                        |
| ---------------------- | -------------------------------------------------- |
| [`eq(a, b)`](#fn-eq)   | Check whether two values are equal.                |
| [`ge(a, b)`](#fn-ge)   | Check whether `a` is greater than or equal to `b`. |
| [`gt(a, b)`](#fn-gt)   | Check whether `a` is strictly greater than `b`.    |
| [`le(a, b)`](#fn-le)   | Check whether `a` is less than or equal to `b`.    |
| [`lt(a, b)`](#fn-lt)   | Check whether `a` is strictly less than `b`.       |
| [`neq(a, b)`](#fn-neq) | Check whether two values are not equal.            |

**Logical**:

| Function                 | Description                                          |
| ------------------------ | ---------------------------------------------------- |
| [`land(a, b)`](#fn-land) | Evaluate `a and b` with Lua short-circuit semantics. |
| [`lnot(a)`](#fn-lnot)    | Return the boolean negation of `a`.                  |
| [`lor(a, b)`](#fn-lor)   | Evaluate `a or b` with Lua short-circuit semantics.  |

**String & Length**:

| Function                     | Description                                                      |
| ---------------------------- | ---------------------------------------------------------------- |
| [`concat(a, b)`](#fn-concat) | Concatenate two strings.                                         |
| [`len(a)`](#fn-len)          | Return the length of a string or table using Lua's `#` operator. |

**Tables & Calls**:

| Function                            | Description                                                    |
| ----------------------------------- | -------------------------------------------------------------- |
| [`call(f, ...)`](#fn-call)          | Call a function with variadic arguments and return its result. |
| [`index(t, k)`](#fn-index)          | Return the value at key/index `k` in table `t`.                |
| [`setindex(t, k, v)`](#fn-setindex) | Set `t[k] = v` and return the assigned value.                  |

### Arithmetic

<a id="fn-add"></a>

#### `add(a, b)`

Add two numbers.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Return**:

- `sum` (`number`): Sum of `a` and `b`.

**Example**:

```lua
add(1, 2) --> 3
```

<a id="fn-div"></a>

#### `div(a, b)`

Divide `a` by `b` using Lua's floating-point division.

**Parameters**:

- `a` (`number`): Dividend value.
- `b` (`number`): Divisor value.

**Return**:

- `quotient` (`number`): Quotient `a / b`.

**Example**:

```lua
div(10, 4) --> 2.5
```

<a id="fn-idiv"></a>

#### `idiv(a, b)`

Divide `a` by `b` and return the floor-division quotient.

**Parameters**:

- `a` (`number`): Dividend value.
- `b` (`number`): Divisor value.

**Return**:

- `quotient` (`integer`): Floor-division result.

**Example**:

```lua
idiv(5, 2) --> 2
```

<a id="fn-mod"></a>

#### `mod(a, b)`

Return the modulo remainder of `a` divided by `b`.

**Parameters**:

- `a` (`number`): Dividend value.
- `b` (`number`): Divisor value.

**Return**:

- `remainder` (`number`): Remainder of `a % b`.

**Example**:

```lua
mod(5, 2) --> 1
```

<a id="fn-mul"></a>

#### `mul(a, b)`

Multiply two numbers.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Return**:

- `product` (`number`): Product `a * b`.

**Example**:

```lua
mul(3, 4) --> 12
```

<a id="fn-pow"></a>

#### `pow(a, b)`

Raise `a` to the power of `b`.

**Parameters**:

- `a` (`number`): Base value.
- `b` (`number`): Exponent value.

**Return**:

- `power` (`number`): Result of `a ^ b`.

**Example**:

```lua
pow(2, 4) --> 16
```

<a id="fn-sub"></a>

#### `sub(a, b)`

Subtract `b` from `a`.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Return**:

- `difference` (`number`): Difference `a - b`.

**Example**:

```lua
sub(5, 3) --> 2
```

<a id="fn-unm"></a>

#### `unm(a)`

Negate a number.

**Parameters**:

- `a` (`number`): Input numeric value.

**Return**:

- `negated` (`number`): Result of `-a`.

**Example**:

```lua
unm(3) --> -3
```

### Comparison

<a id="fn-eq"></a>

#### `eq(a, b)`

Check whether two values are equal.

**Parameters**:

- `a` (`any`): Left value.
- `b` (`any`): Right value.

**Return**:

- `isEqual` (`boolean`): True when `a == b`.

**Example**:

```lua
eq(1, 1) --> true
```

<a id="fn-ge"></a>

#### `ge(a, b)`

Check whether `a` is greater than or equal to `b`.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Return**:

- `isGreaterOrEqual` (`boolean`): True when `a >= b`.

**Example**:

```lua
ge(2, 2) --> true
```

<a id="fn-gt"></a>

#### `gt(a, b)`

Check whether `a` is strictly greater than `b`.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Return**:

- `isGreater` (`boolean`): True when `a > b`.

**Example**:

```lua
gt(3, 2) --> true
```

<a id="fn-le"></a>

#### `le(a, b)`

Check whether `a` is less than or equal to `b`.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Return**:

- `isLessOrEqual` (`boolean`): True when `a <= b`.

**Example**:

```lua
le(2, 2) --> true
```

<a id="fn-lt"></a>

#### `lt(a, b)`

Check whether `a` is strictly less than `b`.

**Parameters**:

- `a` (`number`): Left numeric value.
- `b` (`number`): Right numeric value.

**Return**:

- `isLess` (`boolean`): True when `a < b`.

**Example**:

```lua
lt(1, 2) --> true
```

<a id="fn-neq"></a>

#### `neq(a, b)`

Check whether two values are not equal.

**Parameters**:

- `a` (`any`): Left value.
- `b` (`any`): Right value.

**Return**:

- `isNotEqual` (`boolean`): True when `a ~= b`.

**Example**:

```lua
neq(1, 2) --> true
```

### Logical

<a id="fn-land"></a>

#### `land(a, b)`

Evaluate `a and b` with Lua short-circuit semantics.

**Parameters**:

- `a` (`T1`): First operand.
- `b` (`T2`): Second operand.

**Return**:

- `andValue` (`T1|T2`): Result of `a and b`.

**Example**:

```lua
land(true, false) --> false
```

<a id="fn-lnot"></a>

#### `lnot(a)`

Return the boolean negation of `a`.

**Parameters**:

- `a` (`any`): Input value.

**Return**:

- `isNot` (`boolean`): Result of `not a`.

**Example**:

```lua
lnot(true) --> false
```

<a id="fn-lor"></a>

#### `lor(a, b)`

Evaluate `a or b` with Lua short-circuit semantics.

**Parameters**:

- `a` (`T1`): First operand.
- `b` (`T2`): Second operand.

**Return**:

- `orValue` (`T1|T2`): Result of `a or b`.

**Example**:

```lua
lor(false, true) --> true
```

### String & Length

<a id="fn-concat"></a>

#### `concat(a, b)`

Concatenate two strings.

**Parameters**:

- `a` (`string`): Left string.
- `b` (`string`): Right string.

**Return**:

- `concatenated` (`string`): Concatenated result `a .. b`.

**Example**:

```lua
concat("a", "b") --> "ab"
```

<a id="fn-len"></a>

#### `len(a)`

Return the length of a string or table using Lua's `#` operator.

**Parameters**:

- `a` (`string|table`): Value supporting Lua's `#` operator.

**Return**:

- `length` (`integer`): Length computed by `#a`.

**Example**:

```lua
len("abc") --> 3
```

### Tables & Calls

<a id="fn-call"></a>

#### `call(f, ...)`

Call a function with variadic arguments and return its result.

**Parameters**:

- `f` (`fun(...:T1):T2`): Function to call.
- `...` (`T1`): Additional arguments.

**Return**:

- `callResult` (`T2`): Return value(s) from `f(...)`.

**Example**:

```lua
call(math.max, 1, 2) --> 2
```

<a id="fn-index"></a>

#### `index(t, k)`

Return the value at key/index `k` in table `t`.

**Parameters**:

- `t` (`table`): Source table.
- `k` (`T`): Key/index value.

**Return**:

- `indexedValue` (`T`): Value stored at `t[k]`.

**Example**:

```lua
index({ a = 1 }, "a") --> 1
```

<a id="fn-setindex"></a>

#### `setindex(t, k, v)`

Set `t[k] = v` and return the assigned value.

**Parameters**:

- `t` (`table`): Target table.
- `k` (`any`): Key/index value.
- `v` (`T`): Value to set.

**Return**:

- `assignedValue` (`T`): Assigned value `v`.

**Example**:

```lua
setindex({}, "a", 1) --> 1
```
