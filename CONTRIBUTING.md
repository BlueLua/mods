# Contributing

First off, thanks for taking the time to contribute! ❤️

All contribution types are welcome: bug reports, feature ideas, docs updates,
tests, and code improvements. 🎉

## Table of Contents

- [I Have a Question](#i-have-a-question)
  - [I Want To Contribute](#i-want-to-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Your First Code Contribution](#your-first-code-contribution)
  - [Improving The Documentation](#improving-the-documentation)
- [Styleguides](#styleguides)
  - [Commit Messages](#commit-messages)

## I Have a Question

Before asking a question:

- Read the [documentation](https://luamod.github.io/mods/).
- Check existing [issues](https://github.com/luamod/mods/issues).
- Check [discussions](https://github.com/luamod/mods/discussions).
- Search the internet for existing answers.

If you still need help, use
[GitHub Discussions](https://github.com/luamod/mods/discussions/new?category=q-a)
or open a new
[question issue](https://github.com/luamod/mods/issues/new?template=question.yml)
with your relevant context.

### I Want To Contribute

Contributions of all sizes are welcome. Keep changes focused and small. By
contributing, you agree your contributions are provided under this repository's
[LICENSE](LICENSE).

Before opening a PR:

- For larger changes, start with an
  [issue](https://github.com/luamod/mods/issues) or
  [discussion](https://github.com/luamod/mods/discussions) first.
- Prefer one clear purpose per PR.
- Include related [`spec/`](spec/) and [`docs/`](docs/) updates when behavior
  changes.

### Reporting Bugs

Before submitting a bug report, read the
[documentation](https://luamod.github.io/mods/), check
[discussions](https://github.com/luamod/mods/discussions) and existing
[issues](https://github.com/luamod/mods/issues), and search the internet for
similar reports or fixes to avoid duplicates and continue existing threads.

When reporting a bug, include:

- Steps to reproduce.
- Expected result and actual result.
- Lua version and platform details.
- Minimal example when possible.

### Suggesting Enhancements

For enhancements, read the [documentation](https://luamod.github.io/mods/),
check [discussions](https://github.com/luamod/mods/discussions) and existing
[issues](https://github.com/luamod/mods/issues) to avoid duplicate requests,
then open an issue and include:

- The problem you want to solve.
- The proposed behavior.
- Why it helps most users.
- Any alternatives you considered.

### Your First Code Contribution

#### Testing

Tests live in [`spec/`](spec/). Add or update specs there when behavior changes.

Run tests with [Busted](https://github.com/lunarmodules/busted):

```sh
# All tests
busted

# One spec file while iterating
busted spec/<module>_spec.lua
```

#### Linting

Run lint checks before opening a PR:

- Run Lua lint with [LuaCheck](https://github.com/mpeterv/luacheck):

  ```sh
  luacheck .
  ```

- Run Markdown lint for docs with
  [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2):

  ```sh
  # If markdownlint-cli2 is installed globally
  markdownlint-cli2 'docs/**/*.md' '!docs/.vitepress/**'

  # If you want to run it through npx
  npx --yes markdownlint-cli2 'docs/**/*.md' '!docs/.vitepress/**'
  ```

#### Formatting

Run formatters before opening a PR:

- Format `.md`, `.json`, `.yml`, `.ts`, and `.mts` files with
  [Prettier](https://prettier.io/):

  ```sh
  # If Prettier is installed globally
  prettier --write .

  # If you want to run it through npx
  npx --yes prettier --write .
  ```

- Format `.lua` files with [StyLua](https://github.com/JohnnyMorganz/StyLua):

  ```sh
  stylua .
  ```

#### Module Additions

If adding a module under [`src/mods/`](src/mods/), also update:
[`src/mods/init.lua`](src/mods/init.lua), [`types/mods.lua`](types/mods.lua),
[`README.md`](README.md#modules),
[`docs/modules/index.md`](docs/modules/index.md), and
[`mods-0.1.0-1.rockspec`](mods-0.1.0-1.rockspec).

## Improving The Documentation

- Docs are built with [VitePress](https://vitepress.dev/) and live in
  [`docs/`](docs/).
- The module reference pages under [`docs/src/modules/`](docs/src/modules/) are
  generated. Do not edit those `.md` files directly.
- For API documentation changes, update the source annotations in
  [`types/`](types/) instead of editing generated module pages directly.
- Module reference pages under [`docs/src/modules/`](docs/src/modules/) are
  generated automatically from those annotations.
- For docs setup, build, preview, and local development commands, see
  [`docs/README.md`](docs/README.md).

## Styleguides

### Commit Messages

This project follows
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) 1.0.0.
