---
title: "Date Tokens"
description: "Supported tokens for parsing and formatting dates."
---

# Date Tokens

Supported tokens for parsing and formatting dates, used by the
[`date`](../api/date.md) module.

| Token  | Example            | Meaning                            |
| ------ | ------------------ | ---------------------------------- |
| `YY`   | `26`               | 2-digit year                       |
| `YYYY` | `2026`             | 4-digit year                       |
| `Q`    | `1-4`              | Quarter                            |
| `Qo`   | `1st..4th`         | Ordinal quarter                    |
| `M`    | `1-12`             | Month                              |
| `MM`   | `03-12`            | Month, zero-padded                 |
| `MMM`  | `Jan-Dec`          | Short month name                   |
| `MMMM` | `January-December` | Full month name                    |
| `D`    | `1-31`             | Day of month                       |
| `DD`   | `01-31`            | Day of month, zero-padded          |
| `DDD`  | `1-366`            | Day of year                        |
| `DDDD` | `001-366`          | Day of year, zero-padded           |
| `d`    | `0-6`              | Weekday number where Sunday is `0` |
| `e`    | `0-6`              | Weekday number where Sunday is `0` |
| `E`    | `1-7`              | ISO weekday number                 |
| `dd`   | `Su-Sa`            | Minimal weekday name               |
| `ddd`  | `Sun-Sat`          | Short weekday name                 |
| `dddd` | `Sunday-Saturday`  | Full weekday name                  |
| `Do`   | `1st..31th`        | Ordinal day of month               |
| `H`    | `0-23`             | 24-hour                            |
| `HH`   | `00-23`            | 24-hour, zero-padded               |
| `h`    | `1-12`             | 12-hour                            |
| `hh`   | `01-12`            | 12-hour, zero-padded               |
| `k`    | `1-24`             | 1-24 hour                          |
| `kk`   | `01-24`            | 1-24 hour, zero-padded             |
| `m`    | `0-59`             | Minute                             |
| `mm`   | `00-59`            | Minute, zero-padded                |
| `s`    | `0-59`             | Second                             |
| `ss`   | `00-59`            | Second, zero-padded                |
| `S`    | `0-9`              | Hundreds digit of milliseconds     |
| `SS`   | `00-99`            | First two digits of milliseconds   |
| `SSS`  | `000-999`          | Millisecond, zero-padded           |
| `w`    | `1-53`             | Week of year                       |
| `ww`   | `01-53`            | Week of year, zero-padded          |
| `wo`   | `1st..53rd`        | Ordinal week of year               |
| `W`    | `1-53`             | ISO week of year                   |
| `WW`   | `01-53`            | ISO week of year, zero-padded      |
| `GG`   | `26`               | 2-digit ISO week-year              |
| `GGGG` | `2026`             | ISO week-year                      |
| `gggg` | `2026`             | Week-year                          |
| `a`    | `am pm`            | Meridiem lowercase                 |
| `A`    | `AM PM`            | Meridiem uppercase                 |
| `x`    | `1523520536123`    | Unix timestamp in milliseconds     |
| `X`    | `1523520536`       | Unix timestamp in seconds          |
