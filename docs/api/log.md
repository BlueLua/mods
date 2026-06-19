---
title: "log"
description:
  "Logger factory that emits normalized records through an optional custom
  handler."
---

Logger factory that emits normalized records through an optional custom handler.
When `opts.handler` is omitted, records are written to `io.stderr`.

## Usage

```lua
log = mods.log

local logger = log.new()
logger:warn("config missing") --> writes: [WARN]: config missing
```

## Functions

**Factory**:

| Function       | Description          |
| -------------- | -------------------- |
| [`new(opts?)`] | Create a new logger. |

**Logger Methods**:

| Function                | Description                                                 |
| ----------------------- | ----------------------------------------------------------- |
| [`debug(...)`]          | Emit a `debug` record.                                      |
| [`error(...)`]          | Emit an `error` record.                                     |
| [`info(...)`]           | Emit an `info` record.                                      |
| [`log(levelname, ...)`] | Emit a record for `level` when it passes the logger filter. |
| [`warn(...)`]           | Emit a `warn` record.                                       |

### Factory

#### `new(opts?)` {#new}

Create a new logger. **Parameters**:

- `opts?` ([`mods.log.new.opts`]): Logger configuration.

**Returns**:

- `logger` ([`mods.log.logger`]): Logger instance.

---

### Logger Methods

#### `debug(...)` {#debug}

Emit a `debug` record. **Parameters**:

- `...` (`any`): Additional values joined with spaces.

---

#### `error(...)` {#error}

Emit an `error` record. **Parameters**:

- `...` (`any`): Additional values joined with spaces.

---

#### `info(...)` {#info}

Emit an `info` record. **Parameters**:

- `...` (`any`): Additional values joined with spaces.

---

#### `log(levelname, ...)` {#log}

Emit a record for `level` when it passes the logger filter. **Parameters**:

- `levelname` ([`mods.LogLevel`]): Log level to emit.
- `...` (`any`): Additional values joined with spaces.

---

#### `warn(...)` {#warn}

Emit a `warn` record. **Parameters**:

- `...` (`any`): Additional values joined with spaces.

<!-- prettier-ignore-start -->
[`debug(...)`]: #debug
[`error(...)`]: #error
[`info(...)`]: #info
[`log(levelname, ...)`]: #log
[`mods.LogLevel`]: /mods/types#mods-loglevel
[`mods.log.logger`]: /mods/api/log
[`mods.log.new.opts`]: /mods/api/log
[`new(opts?)`]: #new
[`warn(...)`]: #warn
<!-- prettier-ignore-end -->
