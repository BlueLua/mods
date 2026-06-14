---
title: "template"
description: "String template rendering with {{."
---

String template rendering with <code v-pre>{{...}}</code> placeholders.

## Usage

```lua
template = require "mods.template"

view = {
  user = { name = "Ada" },
}

out = template("Hello {{user.name}}!", view) --> "Hello Ada!"
```

<a id="fn-template"></a>

## `template(tmpl, view)`

Render string templates with <code v-pre>{{...}}</code> placeholders.

**Parameters**:

- `tmpl` (`string`): Template string with placeholders.
- `view` (`table`): Input data used to resolve placeholders.

**Return**:

- `out` (`string`): Rendered output string.

**Example**:

```lua
view = { subject = "World" }
template("Hello {{subject}}", view) --> "Hello World"
```

> [!NOTE]
>
> Whitespace inside placeholders is ignored.
>
> ```lua
> template("Hi {{ name }}", { name = "Ada" }) --> "Hi Ada"
> ```

## Dot Paths

Use dot notation to access nested values in `view`.

```lua
view = { user = { meta = { role = "Engineer" } } }
template("Role: {{user.meta.role}}", view) --> "Role: Engineer"
```

> [!NOTE]
>
> <code v-pre>{{.}}</code> renders the entire root `view` table, not a nested
> field.
>
> ```lua
> template("View: {{.}}", { value = 123 })
> --> View: {
> --    value = 123
> --  }
> ```

## Function Values

If a placeholder resolves to a function, that function is called and its result
is rendered.

```lua
view = { name_func = function() return "Ada" end }
template("Hi {{name_func}}", view) --> "Hi Ada"
```

> [!NOTE]
>
> If the function returns `nil`, the placeholder renders as an empty string.

## Table Values

Table placeholders are rendered using `mods.stringify`.

```lua
view = { data = { a = 1, b = true } }
template("Data: {{data}}", view)
--> Data: {
--    a = 1,
--    b = true
--  }
```

## Missing and Invalid Placeholders

Missing keys render as an empty string.

```lua
view = {}
template("Missing: {{unknown}}", view) --> "Missing: "
```

Invalid placeholder names render as an empty string (for example:
<code v-pre>{{..}}</code>, <code v-pre>{{.name}}</code>,
<code v-pre>{{user.}}</code>, <code v-pre>{{user..name}}</code>).

```lua
view = { user = { name = "Ada" } }
template("Bad: {{user..name}}", view) --> "Bad: "
```

If a placeholder is not closed (<code v-pre>{{unclosed</code>), it is emitted
as-is.

```lua
view = { name = "Ada" }
template("Hi {{name", view) --> "Hi {{name"
```
