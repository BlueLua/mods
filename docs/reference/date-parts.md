---
title: "Date Parts"
description: "Structure and fields of the DateParts table used by mods.date."
---

# Date Parts

Components of a date and time, used by the [`date`] module.

| Field   | Type       | Description                                                        |
| :------ | :--------- | :----------------------------------------------------------------- |
| `year`  | `integer`  | The 4-digit year (e.g., `2026`).                                   |
| `month` | `integer?` | The month of the year (`1` to `12`).                               |
| `day`   | `integer?` | The day of the month (`1` to `31`).                                |
| `hour`  | `integer?` | The hour of the day (`0` to `23`).                                 |
| `min`   | `integer?` | The minute of the hour (`0` to `59`).                              |
| `sec`   | `integer?` | The second of the minute (`0` to `59`).                            |
| `ms`    | `integer?` | The millisecond of the second (`0` to `999`).                      |
| `wday`  | `integer?` | The weekday number (typically `1` to `7` where Sunday is `1`).     |
| `yday`  | `integer?` | The day of the year (`1` to `366`).                                |
| `isdst` | `boolean?` | `true` if Daylight Saving Time (DST) is active, `false` otherwise. |

[`date`]: ../api/date.md
