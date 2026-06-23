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

- Read the official [documentation].
- Check existing [issues].
- Check [discussions].
- Search the internet for existing answers.

If you still need help, open a [discussion] or a question [issue] with your
relevant context.

### I Want To Contribute

Contributions of all sizes are welcome. Keep changes focused and small. All
contributions are licensed under the [LICENSE].

Before opening a [PR]:

- For larger changes, start with an [issue] or [discussion] first.
- Prefer one clear purpose per [PR].
- Include related [tests/] updates when behavior changes.

### Reporting Bugs

Before submitting a bug report, read the official [documentation], check
[discussions] and existing [issues], and search the internet for similar reports
or fixes to avoid duplicates and continue existing threads.

When reporting a bug, include:

- Steps to reproduce.
- Expected result and actual result.
- Lua version and platform details.
- Minimal example when possible.

### Suggesting Enhancements

For enhancements, read the official [documentation], check [discussions] and
existing [issues] to avoid duplicate requests, then open an [issue] and include:

- The problem you want to solve.
- The proposed behavior.
- Why it helps most users.
- Any alternatives you considered.

### Your First Code Contribution

#### Testing

Tests live in [tests/] (named `<name>.test.lua`). Add or update tests there when
behavior changes.

Run tests with [Busted]:

```sh
# All tests
busted

# A specific test file
busted tests/<name>.test.lua
```

#### Linting

Run lint checks before opening a [PR]:

- **Linter** ([LuaCheck]):

  ```sh
  luacheck .
  ```

- **Formatter** ([StyLua]):

  ```sh
  stylua . --check
  ```

- **Static Analysis & Type Checking** ([Lua Language Server]):

  We use `lua-language-server` (LLS) for static type checking. You can keep
  standard definitions (like Busted, LuaAssert, and LuaFileSystem) in a
  shareable directory on your machine:

  ```sh
  mkdir -p ~/.local/share/lua/types
  cd ~/.local/share/lua/types
  git clone --depth 1 https://github.com/LuaCATS/busted.git
  git clone --depth 1 https://github.com/LuaCATS/luassert.git
  git clone --depth 1 https://github.com/LuaCATS/luafilesystem.git
  ```

  To run the analysis locally:

  ```sh
  lua-language-server --check .
  ```

## Improving The Documentation

- The documentation website code and guides live in the [bluelua.github.io]
  repository.
- For website updates, guides, or layout improvements, please open [pull
  requests] there.
- For inline API documentation changes, update the annotations under the
  [types/] directory. Do not write documentation directly in the source code
  under the [src/] directory.

## Styleguides

### Commit Messages

This project follows [Conventional Commits] 1.0.0.

[bluelua.github.io]: https://github.com/BlueLua/bluelua.github.io
[Busted]: https://github.com/lunarmodules/busted
[Conventional Commits]: https://www.conventionalcommits.org/en/v1.0.0/
[discussion]: https://github.com/BlueLua/mods/discussions
[discussions]: https://github.com/BlueLua/mods/discussions
[documentation]: https://bluelua.github.io/mods
[issue]: https://github.com/BlueLua/mods/issues
[issues]: https://github.com/BlueLua/mods/issues
[LICENSE]: LICENSE
[LuaCheck]: https://github.com/mpeterv/luacheck
[Lua Language Server]: https://github.com/LuaLS/lua-language-server
[PR]: https://github.com/BlueLua/mods/pulls
[pull requests]: https://github.com/BlueLua/bluelua.github.io/pulls
[StyLua]: https://github.com/JohnnyMorganz/StyLua
[tests/]: tests/
[types/]: types/
[src/]: src/
