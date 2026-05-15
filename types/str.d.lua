---@meta mods.str

---
---String operations for searching, splitting, trimming, and formatting text.
---
---## Usage
---
---```lua
---str = require "mods.str"
---
---print(str.capitalize("hello world")) --> "Hello world"
---```
---
---@class mods.str
local M = {}

---
---Return copy with first character capitalized and the rest lowercased.
---
---```lua
---s = capitalize("hello WORLD") --> "Hello world"
---```
---
---@section Formatting
---@param s string Input string.
---@return string capitalized Capitalized string.
---@nodiscard
function M.capitalize(s) end

---
---Center string within width, padded with fill characters.
---
---```lua
---s = center("hi", 6, "-") --> "--hi--"
---```
---
---@section Formatting
---@param s string Input string.
---@param width integer Target width.
---@param fillchar? string Optional fill character.
---@return string centered Centered string.
---@nodiscard
function M.center(s, width, fillchar) end

---
---Count non-overlapping occurrences of a substring.
---
---```lua
---n = count("aaaa", "aa")       --> 2
---n = count("aaaa", "a", 2, -1) --> 2
---n = count("abcd", "")         --> 5
---```
---
---@section Formatting
---@param s string Input string.
---@param sub string Substring to search.
---@param start? integer Optional start index (defaults to `1`).
---@param stop? integer Optional exclusive end index (defaults to `#s + 1`).
---@return integer count Number of non-overlapping matches.
---@nodiscard
function M.count(s, sub, start, stop) end

---
---Return true if string ends with suffix.
---
---```lua
---ok = endswith("hello.lua", ".lua") --> true
---```
---
---> [!NOTE]
--->
---> If suffix is a list, returns `true` when any suffix matches.
---
---@section Formatting
---@param s string Input string.
---@param suffix string|string[] Suffix string.
---@param start? integer Optional start index (defaults to `1`).
---@param stop? integer Optional exclusive end index (defaults to `#s + 1`).
---@return boolean hasSuffix True when `s` ends with `suffix`.
---@nodiscard
function M.endswith(s, suffix, start, stop) end

---
---Expand tabs to spaces using given tabsize.
---
---```lua
---s = expandtabs("a\tb", 4) --> "a   b"
---```
---
---@section Formatting
---@param s string Input string.
---@param tabsize? integer Optional tab width (defaults to `8`).
---@return string expanded String with tabs expanded.
---@nodiscard
function M.expandtabs(s, tabsize) end

---
---Return lowest index of substring or nil if not found.
---
---```lua
---i = find("hello", "ll") --> 3
---```
---
---@section Formatting
---@param s string Input string.
---@param sub string Substring to search.
---@param start? integer Optional start index (defaults to `1`).
---@param stop? integer Optional exclusive end index (defaults to `#s + 1`).
---@return integer? index First match index, or `nil` when not found.
---@nodiscard
function M.find(s, sub, start, stop) end

---
---Format string with mapping (key-based) replacement.
---
---```lua
---s = format_map("hi {name}", { name = "bob" }) --> "hi bob"
---```
---
---> [!NOTE]
--->
---> `format_map` is a lightweight `{key}` replacement helper.
---> For richer templating, use `mods.template`.
---
---@section Formatting
---@param s string Template string with `{key}` placeholders.
---@param mapping table Values used to replace placeholder keys.
---@return string formatted Formatted string with placeholders replaced.
---@nodiscard
function M.format_map(s, mapping) end

--------------------------------------------------------------------------------
---------------------------------- Predicates ----------------------------------
--------------------------------------------------------------------------------

---
---Return true if all characters are alphanumeric and string is non-empty.
---
---```lua
---ok = isalnum("abc123") --> true
---```
---
---> [!NOTE]
--->
---> Lua letters are ASCII by default, so non-ASCII letters are not alphanumeric.
--->
---> ```lua
---> isalnum("á1") --> false
---> ```
---@section Predicates
---@param s string Input string.
---@return boolean isAlnum True when `s` is non-empty and all characters are alphanumeric.
---@nodiscard
function M.isalnum(s) end

---
---Return true if all characters are alphabetic and string is non-empty.
---
---```lua
---ok = isalpha("abc") --> true
---```
---
---> [!NOTE]
--->
---> Lua letters are ASCII by default, so non-ASCII letters are not alphabetic.
--->
---> ```lua
---> isalpha("á") --> false
---> ```
---@section Predicates
---@param s string Input string.
---@return boolean isAlpha True when `s` is non-empty and all characters are alphabetic.
---@nodiscard
function M.isalpha(s) end

---
---Return true if all characters are ASCII.
---
---```lua
---ok = isascii("hello") --> true
---```
---
---> [!NOTE]
--->
---> The empty string returns `true`.
---@section Predicates
---@param s string Input string.
---@return boolean isAscii True when all bytes in `s` are ASCII.
---@nodiscard
function M.isascii(s) end

---
---Return true if all characters are decimal characters and string is non-empty.
---
---```lua
---ok = isdecimal("123") --> true
---```
---
---@section Predicates
---@param s string Input string.
---@return boolean isDecimal True when `s` is non-empty and all characters are decimal digits.
---@nodiscard
function M.isdecimal(s) end

---Return true if string is a valid identifier and not a reserved keyword.
---
---```lua
---ok = isidentifier("foo_bar") --> true
---ok = isidentifier("2var") --> false
---ok = isidentifier("end") --> false (keyword)
---```
---
---@section Predicates
---@param s string Input string.
---@return boolean isIdentifier True when `s` is a valid identifier and not a keyword.
---@nodiscard
function M.isidentifier(s) end

---
---Return true if all cased characters are lowercase and there is at least one cased character.
---
---```lua
---ok = islower("hello") --> true
---```
---
---@section Predicates
---@param s string Input string.
---@return boolean isLower True when `s` has at least one cased character and all are lowercase.
---@nodiscard
function M.islower(s) end

---Return true if all characters are printable.
---
---```lua
---ok = isprintable("abc!") --> true
---```
---
---> [!NOTE]
--->
---> The empty string returns `true`.
---@section Predicates
---@param s string Input string.
---@return boolean isPrintable True when all bytes in `s` are printable ASCII.
---@nodiscard
function M.isprintable(s) end

---
---Return true if all characters are whitespace and string is non-empty.
---
---```lua
---ok = isspace(" \t") --> true
---```
---
---@section Predicates
---@param s string Input string.
---@return boolean isSpace True when `s` is non-empty and all characters are whitespace.
---@nodiscard
function M.isspace(s) end

---
---Return true if string is titlecased.
---
---```lua
---ok = istitle("Hello World") --> true
---```
---
---@section Predicates
---@param s string Input string.
---@return boolean isTitle True when `s` is titlecased.
---@nodiscard
function M.istitle(s) end

---
---Return true if all cased characters are uppercase and there is at least one cased character.
---
---```lua
---ok = isupper("HELLO") --> true
---```
---
---@section Predicates
---@param s string Input string.
---@return boolean isUpper True when `s` has at least one cased character and all are uppercase.
---@nodiscard
function M.isupper(s) end

---
---Join an array-like table of strings using this string as separator.
---
---```lua
---s = join(",", { "a", "b", "c" }) --> "a,b,c"
---```
---
---@section Layout
---@param sep string Separator value.
---@param ls string[] Table value.
---@return string joined Joined string.
---@nodiscard
function M.join(sep, ls) end

---
---Left-justify string in a field of given width.
---
---```lua
---s = ljust("hi", 5, ".") --> "hi..."
---```
---
---@section Layout
---@param s string Input string.
---@param width integer Target width.
---@param fillchar? string Optional fill character.
---@return string leftJustified Left-justified string.
---@nodiscard
function M.ljust(s, width, fillchar) end

---
---Return lowercased copy.
---
---```lua
---s = lower("HeLLo") --> "hello"
---```
---
---@section Layout
---@param s string Input string.
---@return string lowercased Lowercased string.
---@nodiscard
function M.lower(s) end

---
---Remove leading characters (default: whitespace).
---
---```lua
---s = lstrip("  hello") --> "hello"
---```
---
---@section Layout
---@param s string Input string.
---@param chars? string Optional character set.
---@return string leadingStripped String with leading characters removed.
---@nodiscard
function M.lstrip(s, chars) end

---
---Remove trailing characters (default: whitespace).
---
---```lua
---s = rstrip("hello  ") --> "hello"
---```
---
---@section Layout
---@param s string Input string.
---@param chars? string Optional character set.
---@return string trailingStripped String with trailing characters removed.
---@nodiscard
function M.rstrip(s, chars) end

---
---Remove leading and trailing characters (default: whitespace).
---
---```lua
---s = strip("  hello  ") --> "hello"
---```
---
---@section Layout
---@param s string Input string.
---@param chars? string Optional character set.
---@return string stripped String with leading and trailing characters removed.
---@nodiscard
function M.strip(s, chars) end

---
---Partition string into head, sep, tail from left.
---
---```lua
---a, b, c = partition("a-b-c", "-") --> "a", "-", "b-c"
---```
---
---@section Split & Replace
---@param s string Input string.
---@param sep string Separator value.
---@return string head Part before the separator.
---@return string separator Matched separator, or empty string when not found.
---@return string tail Part after the separator.
---@nodiscard
function M.partition(s, sep) end

---
---Remove prefix if present.
---
---```lua
---s = removeprefix("foobar", "foo") --> "bar"
---```
---
---@section Split & Replace
---@param s string Input string.
---@param prefix string Prefix string.
---@return string prefixRemoved String with prefix removed when present.
---@nodiscard
function M.removeprefix(s, prefix) end

---
---Remove suffix if present.
---
---```lua
---s = removesuffix("foobar", "bar") --> "foo"
---```
---
---@section Split & Replace
---@param s string Input string.
---@param suffix string Suffix string.
---@return string suffixRemoved String with suffix removed when present.
---@nodiscard
function M.removesuffix(s, suffix) end

---
---Return a copy of the string with all occurrences of a substring replaced.
---
---```lua
---s = replace("a-b-c", "-", "_", 1) --> "a_b-c"
---```
---
---@section Split & Replace
---@param s string Input string.
---@param old string Substring to replace.
---@param new string Replacement string.
---@param count? integer Optional maximum replacement count.
---@return string replaced String with replacements applied.
---@nodiscard
function M.replace(s, old, new, count) end

---
---Return highest index of substring or nil if not found.
---
---```lua
---i = rfind("ababa", "ba") --> 4
---```
---
---@section Split & Replace
---@param s string Input string.
---@param sub string Substring to search.
---@param start? integer Optional start index (defaults to `1`).
---@param stop? integer Optional inclusive end index (defaults to `#s`).
---@return integer? index Last match index, or `nil` when not found.
---@nodiscard
function M.rfind(s, sub, start, stop) end

---
---Like `rfind` but raises an error when the substring is not found.
---
---```lua
---i = rindex("ababa", "ba") --> 4
---```
---
---@section Split & Replace
---@param s string Input string.
---@param sub string Substring to search.
---@param start? integer Optional start index (defaults to `1`).
---@param stop? integer Optional inclusive end index (defaults to `#s`).
---@return integer index Last match index.
---@nodiscard
function M.rindex(s, sub, start, stop) end

---
---Right-justify string in a field of given width.
---
---```lua
---s = rjust("hi", 5, ".") --> "...hi"
---```
---
---@section Split & Replace
---@param s string Input string.
---@param width integer Target width.
---@param fillchar? string Optional fill character.
---@return string rightJustified Right-justified string.
---@nodiscard
function M.rjust(s, width, fillchar) end

---
---Partition string into head, sep, tail from right.
---
---```lua
---a, b, c = rpartition("a-b-c", "-") --> "a-b", "-", "c"
---```
---
---@section Split & Replace
---@param s string Input string.
---@param sep string Separator value.
---@return string head Part before the separator.
---@return string separator Matched separator, or empty string when not found.
---@return string tail Part after the separator.
---@nodiscard
function M.rpartition(s, sep) end

---
---Split from the right by separator, up to maxsplit.
---
---```lua
---parts = rsplit("a,b,c", ",", 1) --> { "a,b", "c" }
---```
---
---@section Split & Replace
---@param s string Input string.
---@param sep? string Optional separator value.
---@param maxsplit? integer Optional maximum number of splits.
---@return mods.List parts Split parts.
---@nodiscard
function M.rsplit(s, sep, maxsplit) end

---
---Split by separator (or whitespace) up to maxsplit.
---
---```lua
---parts = split("a,b,c", ",") --> { "a", "b", "c" }
---```
---
---@section Split & Replace
---@param s string Input string.
---@param sep? string Optional separator value.
---@param maxsplit? integer Optional maximum number of splits.
---@return mods.List parts Split parts.
---@nodiscard
function M.split(s, sep, maxsplit) end

---
---Split on line boundaries.
---
---```lua
---lines = splitlines("a\nb\r\nc") --> { "a", "b", "c" }
---```
---
---@section Split & Replace
---@param s string Input string.
---@param keepends? boolean Optional whether to keep line endings.
---@return mods.List lines Split lines.
---@nodiscard
function M.splitlines(s, keepends) end

---
---Return a copy with case of alphabetic characters swapped.
---
---```lua
---s = swapcase("AbC") --> "aBc"
---```
---
---@section Casing & Transform
---@param s string Input string.
---@return string swappedCase String with alphabetic case swapped.
---@nodiscard
function M.swapcase(s) end

---
---Return true if string starts with prefix.
---
---```lua
---ok = startswith("hello.lua", "he") --> true
---```
---
---> [!NOTE]
--->
---> If prefix is a list, returns `true` when any prefix matches.
---
---@section Casing & Transform
---@param s string Input string.
---@param prefix string|string[] Prefix string.
---@param start? integer Optional start index (defaults to `1`).
---@param stop? integer Optional exclusive end index (defaults to `#s + 1`).
---@return boolean hasPrefix True when `s` starts with `prefix`.
---@nodiscard
function M.startswith(s, prefix, start, stop) end

---
---Return titlecased copy.
---
---```lua
---s = title("hello world") --> "Hello World"
---```
---
---@section Casing & Transform
---@param s string Input string.
---@return string titlecased Titlecased string.
---@nodiscard
function M.title(s) end

---
---Translate characters using a mapping table.
---
---```lua
---map = { [string.byte("a")] = "b", ["c"] = false }
---s = translate("abc", map) --> "bb"
---```
---
---@section Casing & Transform
---@param s string Input string.
---@param table_map table Character translation map.
---@return string translated Translated string.
---@nodiscard
function M.translate(s, table_map) end

---
---Return uppercased copy.
---
---```lua
---s = upper("Hello") --> "HELLO"
---```
---
---@section Casing & Transform
---@param s string Input string.
---@return string uppercased Uppercased string.
---@nodiscard
function M.upper(s) end

---
---Pad numeric string on the left with zeros.
---
---```lua
---s = zfill("42", 5) --> "00042"
---```
---
---@section Casing & Transform
---@param s string Input string.
---@param width integer Target width.
---@return string zeroFilled Zero-padded string.
---@nodiscard
function M.zfill(s, width) end

return M
