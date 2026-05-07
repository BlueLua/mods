---
description:
  "Logger factory that emits normalized records through an optional custom
  handler."
---

# `log`

Logger factory that emits normalized records through an optional custom handler.
When `opts.handler` is omitted, records are written to `io.stderr`.

## Usage

```lua
log = require "mods.log"

local logger = log.new()
logger:warn("config missing") --> writes: [WARN]: config missing
```

## Functions

**Factory**:

| Function                | Description          |
| ----------------------- | -------------------- |
| [`new(opts?)`](#fn-new) | Create a new logger. |

**Logger Methods**:

| Function                         | Description                                                 |
| -------------------------------- | ----------------------------------------------------------- |
| [`debug(...)`](#fn-debug)        | Emit a `debug` record.                                      |
| [`error(...)`](#fn-error)        | Emit an `error` record.                                     |
| [`info(...)`](#fn-info)          | Emit an `info` record.                                      |
| [`log(levelname, ...)`](#fn-log) | Emit a record for `level` when it passes the logger filter. |
| [`warn(...)`](#fn-warn)          | Emit a `warn` record.                                       |

### Factory

<a id="fn-new"></a>

#### `new(opts?)`

Create a new logger. **Parameters**:

- `opts?` (`mods.log.new.opts`): Logger configuration.

**Return**:

- `logger` (`mods.log.logger`): Logger instance.

### Logger Methods

<a id="fn-debug"></a>

#### `debug(...)`

Emit a `debug` record. **Parameters**:

- `...` (`any`): Additional values joined with spaces.

<a id="fn-error"></a>

#### `error(...)`

Emit an `error` record. **Parameters**:

- `...` (`any`): Additional values joined with spaces.

<a id="fn-info"></a>

#### `info(...)`

Emit an `info` record. **Parameters**:

- `...` (`any`): Additional values joined with spaces.

<a id="fn-log"></a>

#### `log(levelname, ...)`

Emit a record for `level` when it passes the logger filter. **Parameters**:

- `levelname` (`string|"debug"|"info"|"warn"|"error"|"off"`): Log level to emit.
- `...` (`any`): Additional values joined with spaces.

<a id="fn-warn"></a>

#### `warn(...)`

Emit a `warn` record. **Parameters**:

- `...` (`any`): Additional values joined with spaces.
