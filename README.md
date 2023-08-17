# PCRE2 - Perl Compatible Regular Expressions - for V

The [PCRE] library is a [fast](bench/README.md) set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5.

This package uses the current version, PCRE2, released in 2015, is now at version 10.42.

## Synopsis

```go
import prantlf.pcre2 { pcre2_compile }

pattern := r'answer (?<answer>\d+)'
text := 'Is the answer 42?'

re := pcre2_compile(pattern, 0)!
defer { re.free() }

assert re.contains(text, 0)!
idx := re.index_of(text, 0)!
assert idx == 14
start, end := re.index_range(text, 0)!
assert start == 14
assert end == 16

m := re.exec(text, 0)!
defer { m.free() }
assert re.captures == 1
assert re.names == 1
start, end := m.group_bounds(1)?
assert start == 14
assert end == 16
assert m.group_text(text, 1)? == '42'
assert re.group_index_by_name('answer') == 1

text2 := re.replace(text, 'question known', 0)!
assert text2 == 'Is the question known?'
assert !re.contains(text2, 0)
```

## Installation

You can install this package either from [VPM] or from GitHub:

```txt
v install prantlf.pcre2
v install --git https://github.com/prantlf/v-pcre2
```

## API

The following types, constants, functions and methods are exported:

### Types

    struct RegEx {}

    struct Match {}

    struct NoMatch {}

    struct NoReplace {}

    struct CompileError {
      msg    string
      code   int
      offset int
    }

    struct ExecuteError {
      msg  string
      code int
    }

### Constants

    // The following option bits can be passed to both compile() and exec().
    // opt_no_utf_check affects only the function to which it is passed.

    pub const opt_anchored = u32(0x80000000) /*  */
    pub const opt_no_utf_check = u32(0x40000000) /*  */
    pub const opt_endanchored = u32(0x20000000) /*  */

    // The following option bits can be passed only to compile(). However,
    // they may affect exec() too. The following tags indicate which:
    //
    // C   alters what is compiled by compile()
    // E   is inspected during exec() execution

    pub const opt_allow_empty_class = u32(0x00000001) /* C */
    pub const opt_alt_bsux = u32(0x00000002) /* C */
    pub const opt_auto_callout = u32(0x00000004) /* C */
    pub const opt_caseless = u32(0x00000008) /* C */
    pub const opt_dollar_endonly = u32(0x00000010) /* E */
    pub const opt_dotall = u32(0x00000020) /* C */
    pub const opt_dupnames = u32(0x00000040) /* C */
    pub const opt_extended = u32(0x00000080) /* C */
    pub const opt_firstline = u32(0x00000100) /* E */
    pub const opt_match_unset_backref = u32(0x00000200) /* C E */
    pub const opt_multiline = u32(0x00000400) /* C */
    pub const opt_never_ucp = u32(0x00000800) /* C */
    pub const opt_never_utf = u32(0x00001000) /* C */
    pub const opt_no_auto_capture = u32(0x00002000) /* C */
    pub const opt_no_auto_possess = u32(0x00004000) /* C */
    pub const opt_no_dotstar_anchor = u32(0x00008000) /* C */
    pub const opt_no_start_optimize = u32(0x00010000) /* E */
    pub const opt_ucp = u32(0x00020000) /* C E */
    pub const opt_ungreedy = u32(0x00040000) /* C */
    pub const opt_utf = u32(0x00080000) /* C E */
    pub const opt_never_backslash_c = u32(0x00100000) /* C */
    pub const opt_alt_circumflex = u32(0x00200000) /* E */
    pub const opt_alt_verbnames = u32(0x00400000) /* C */
    pub const opt_use_offset_limit = u32(0x00800000) /* E */
    pub const opt_extended_more = u32(0x01000000) /* C */
    pub const opt_literal = u32(0x02000000) /* C */
    pub const opt_match_invalid_utf = u32(0x04000000) /* E */

    // These are for exec(). Note that opt_anchored, opt_endanchored and
    // opt_no_utf_check can also be passed to this function.

    pub const opt_notbol = u32(0x00000001) /*  */
    pub const opt_noteol = u32(0x00000002) /*  */
    pub const opt_notempty = u32(0x00000004) /* These two must be kept */
    pub const opt_notempty_atstart = u32(0x00000008) /* adjacent to each other. */
    pub const opt_partial_soft = u32(0x00000010) /*  */
    pub const opt_partial_hard = u32(0x00000020) /*  */

    // These are for replace().

    pub const opt_replace_groups = u32(0x00020000) /* C6 */

### Functions

    pcre2_compile(source string, options u32) !&RegEx

### Methods

    (r &RegEx) free()

    (r &RegEx) group_index_by_name(name string) int
    (r &RegEx) group_name_by_index(idx int) string

    (r &RegEx) exec(subject string, options u32) !Match
    (r &RegEx) exec_within(subject string, start int, end int, options u32) !Match
    (r &RegEx) exec_within_nochk(subject string, start int, end int, options u32) !Match

    (r &RegEx) matches(s string, opt u32) !bool
    (r &RegEx) matches_within(s string, at int, end int, opt u32) !bool
    (r &RegEx) matches_within_nochk(s string, at int, stop int, opt u32) !bool

    (r &RegEx) contains(s string, opt u32) !bool
    (r &RegEx) contains_within(s string, at int, end int, opt u32) !bool
    (r &RegEx) contains_within_nochk(s string, at int, stop int, opt u32) !bool

    (r &RegEx) starts_with(s string, opt u32) !bool
    (r &RegEx) starts_with_within(s string, at int, end int, opt u32) !bool
    (r &RegEx) starts_with_within_nochk(s string, at int, stop int, opt u32) !bool

    (r &RegEx) index_of(s string, option u32) !int
    (r &RegEx) index_of_within(s string, start int, end int, opt u32) !int
    (r &RegEx) index_of_within_nochk(s string, start int, stop int, opt u32) !int

    (r &RegEx) index_range(s string, opt u32) !(int, int)
    (r &RegEx) index_range_within(s string, start int, end int, opt u32) !(int, int)
    (r &RegEx) index_range_within_nochk(s string, start int, stop int, opt u32) !(int, int)

    (r &RegEx) ends_with(s string, opt u32) !bool
    (r &RegEx) ends_with_within(s string, from int, to int, opt u32) !bool
    (r &RegEx) ends_with_within_nochk(s string, from int, to int, opt u32) !bool

    (r &RegEx) count_of(s string, opt u32) !int
    (r &RegEx) count_of_within(s string, start int, end int, opt u32) !int
    (r &RegEx) count_of_within_nochk(s string, start int, stop int, opt u32) !int

    (r &RegEx) split(s string, opt u32) ![]string
    (r &RegEx) split_first(s string, opt u32) ![]string

    (r &RegEx) chop(s string, opt u32) ![]string
    (r &RegEx) chop_first(s string, opt u32) ![]string

    (r &RegEx) replace(s string, with string, opt u32) !string
    (r &RegEx) replace_first(s string, with string, opt u32) !string

    (r &Match) free()

    (m &Match) group_bounds(idx int) ?(int, int)
    (m &Match) group_text(subject string, idx int) ?string

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Lint and test your code.

## License

Copyright (c) 2023 Ferdinand Prantl

Licensed under the MIT license.

[VPM]: https://vpm.vlang.io/packages/prantlf.pcre
[PCRE]: https://www.pcre.org/
