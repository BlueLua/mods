#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

interpreters=()
for bin in lua5.1 lua5.2 lua5.3 lua5.4 luajit lua; do
  if command -v "$bin" >/dev/null 2>&1; then
    case " ${interpreters[*]} " in
      *" $(command -v "$bin") "*) ;;
      *) interpreters+=("$(command -v "$bin")") ;;
    esac
  fi
done

if [ "${#interpreters[@]}" -eq 0 ]; then
  echo "No Lua interpreters found in PATH." >&2
  exit 1
fi

status=0
for lua_bin in "${interpreters[@]}"; do
  printf '\n==> busted --lua=%s\n' "$lua_bin"
  if ! busted --lua="$lua_bin" "$@"; then
    status=1
  fi
done

exit "$status"
