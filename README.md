# PCRE2 - Perl Compatible Regular Expressions - for V

The [PCRE] library is a [fast](bench/README.md) set of functions that implement regular expression pattern matching using the same syntax and semantics as Perl 5.

This package uses the current version, PCRE2, released in 2015, is now at version 10.42. If you are interested in older, but still widely deployed PCRE library, originally released in 1997 and now at version 8.45, see [prantlf.pcre].

## Synopsis

```v
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

## Usage

For the syntax of the regular expression patterns, see the [quick reference] or the [exhaustive documentation] from the web site with the [original documentation] for PCRE for C. Especially notable are pages about the [pattern limits] and the [compatibility with PERL5].

### Compile

A regular expression pattern has to be compiled at first. Both synonymous methods share the same functionality:

```v
import prantlf.pcre { pcre_compile }
pcre2_compile(source string, options u32) !&RegEx
```

```v
import prantlf.pcre
pcre2.compile(source string, options u32) !&RegEx
```

The following options can be applied. Combine multiple options together with the `|` (binary OR) operator:

    opt_anchored             Force pattern anchoring
    opt_allow_empty_class    Allow empty classes
    opt_alt_bsux             Alternative handling of \u, \U, and \x
    opt_alt_circumflex       Alternative handling of ^ in multiline mode
    opt_alt_verbnames        Process backslashes in verb names
    opt_auto_callout         Compile automatic callouts
    opt_caseless             Do caseless matching
    opt_dollar_endonly       $ not to match newline at end
    opt_dotall               . matches anything including NL
    opt_dupnames             Allow duplicate names for subpatterns
    opt_endanchored          Pattern can match only at end of subject
    opt_extended             Ignore white space and # comments
    opt_firstline            Force matching to be before newline
    opt_literal              Pattern characters are all literal
    opt_match_invalid_utf    Enable support for matching invalid UTF
    opt_match_unset_backref  Match unset backreferences
    opt_multiline            ^ and $ match newlines within data
    opt_never_backslash_c    Lock out the use of \C in patterns
    opt_never_ucp            Lock out opt_ucp, e.g. via (*UCP)
    opt_never_utf            Lock out opt_utf, e.g. via (*UTF)
    opt_no_auto_capture      Disable numbered capturing paren-
                             theses (named ones available)
    opt_no_auto_possess      Disable auto-possessification
    opt_no_dotstar_anchor    Disable automatic anchoring for .*
    opt_no_start_optimize    Disable match-time start optimizations
    opt_no_utf_check         Do not check the pattern for UTF validity
                             (only relevant if opt_utf is set)
    opt_ucp                  Use Unicode properties for \d, \w, etc.
    opt_ungreedy             Invert greediness of quantifiers
    opt_use_offset_limit     Enable offset limit for unanchored matching
    opt_utf                  Treat pattern and subjects as UTF strings


If the compilation fails, an error will be returned:

```v
struct CompileError {
  msg    string  // the error message
  code   int     // the error code
  offset int     // if >= 0, points to the pattern where the compilation failed
}
```

The following error codes may encounter and are exported as public constants:

```v
error_end_backslash                  = 101
error_end_backslash_c                = 102
error_unknown_escape                 = 103
error_quantifier_out_of_order        = 104
error_quantifier_too_big             = 105
error_missing_square_bracket         = 106
error_escape_invalid_in_class        = 107
error_class_range_order              = 108
error_quantifier_invalid             = 109
error_internal_unexpected_repeat     = 110
error_invalid_after_parens_query     = 111
error_missing_closing_parenthesis    = 114
error_bad_subpattern_reference       = 115
error_null_pattern                   = 116
error_bad_options                    = 117
error_missing_comment_closing        = 118
error_parentheses_nest_too_deep      = 119
error_pattern_too_large              = 120
error_heap_failed                    = 121
error_unmatched_closing_parenthesis  = 122
error_internal_code_overflow         = 123
error_missing_condition_closing      = 124
error_lookbehind_not_fixed_length    = 125
error_zero_relative_reference        = 126
error_too_many_condition_branches    = 127
error_condition_assertion_expected   = 128
error_bad_relative_reference         = 129
error_unknown_posix_class            = 130
error_internal_study_error           = 131
error_unicode_not_supported          = 132
error_parentheses_stack_check        = 133
error_code_point_too_big             = 134
error_lookbehind_too_complicated     = 135
error_lookbehind_invalid_backslash_c = 136
error_unsupported_escape_sequence    = 137
error_callout_number_too_big         = 138
error_missing_callout_closing        = 139
error_escape_invalid_in_verb         = 140
error_unrecognized_after_query_p     = 141
error_missing_name_terminator        = 142
error_duplicate_subpattern_name      = 143
error_invalid_subpattern_name        = 144
error_unicode_properties_unavailable = 145
error_malformed_unicode_property     = 146
error_unknown_unicode_property       = 147
error_subpattern_name_too_long       = 148
error_too_many_named_subpatterns     = 149
error_class_invalid_range            = 150
error_octal_byte_too_big             = 151
error_internal_overran_workspace     = 152
error_internal_missing_subpattern    = 153
error_define_too_many_branches       = 154
error_backslash_o_missing_brace      = 155
error_internal_unknown_newline       = 156
error_backslash_g_syntax             = 157
error_parens_query_r_missing_closing = 158
error_verb_unknown                   = 160
error_subpattern_number_too_big      = 161
error_subpattern_name_expected       = 162
error_internal_parsed_overflow       = 163
error_invalid_octal                  = 164
error_subpattern_names_mismatch      = 165
error_mark_missing_argument          = 166
error_invalid_hexadecimal            = 167
error_backslash_c_syntax             = 168
error_backslash_k_syntax             = 169
error_internal_bad_code_lookbehinds  = 170
error_backslash_n_in_class           = 171
error_callout_string_too_long        = 172
error_unicode_disallowed_code_point  = 173
error_utf_is_disabled                = 174
error_ucp_is_disabled                = 175
error_verb_name_too_long             = 176
error_backslash_u_code_point_too_big = 177
error_missing_octal_or_hex_digits    = 178
error_version_condition_syntax       = 179
error_internal_bad_code_auto_possess = 180
error_callout_no_string_delimiter    = 181
error_callout_bad_string_delimiter   = 182
error_backslash_c_caller_disabled    = 183
error_query_barjx_nest_too_deep      = 184
error_backslash_c_library_disabled   = 185
error_pattern_too_complicated        = 186
error_lookbehind_too_long            = 187
error_pattern_string_too_long        = 188
error_internal_bad_code              = 189
error_internal_bad_code_in_skip      = 190
error_bad_literal_options            = 192
error_supported_only_in_unicode      = 193
error_invalid_hyphen_in_options      = 194
error_alpha_assertion_unknown        = 195
error_script_run_not_available       = 196
error_too_many_captures              = 197
error_condition_atomic_assertion_expected  = 198
error_backslash_k_in_lookaround      = 199
```

Don't forget to free the regular expression object when you do not need it any more:

```v
(r &RegEx) free()
defer { re.free() }
```

Some characteristics of the regular expression, which are usually needed when executing it later, can be enquired right after compiling it:

```v
struct RegEx {
  captures int  // total count of the capturing groups
  names    int  // total count of the named capturing groups
}
```

```v
(r &RegEx) group_index_by_name(name string) int
(r &RegEx) group_name_by_index(idx int) string
```

See also the [original documentation for pcre_compile].

### Execute

After compiling, the regular expression can be executed with various subjects:

```v
(r &RegEx) exec(subject string, options u32) !Match
(r &RegEx) exec_within(subject string, start int, end int, options u32) !Match
(r &RegEx) exec_within_nochk(subject string, start int, end int, options u32) !Match
```

The following options can be applied. Combine multiple options together with the `|` (binary OR) operator:

    opt_anchored          Match only at the first position
    opt_endanchored       Pattern can match only at end of subject
    opt_notbol            Subject string is not the beginning of a line
    opt_noteol            Subject string is not the end of a line
    opt_notempty          An empty string is not a valid match
    opt_notempty_atstart  An empty string at the start of the subject
                          is not a valid match
    opt_no_utf_check      Do not check the subject for UTF validity
                          (only relevant if opt_UTF was set at compile time)
    opt_partial_hard      Return error_partial for a partial match
                          even if there is a full match
    opt_partial_soft      Return error_partial for a partial match
                          if no full matches are found

If the execution succeeds, an object with information about the match will be returned:

```v
struct Match {}
```

Capturing groups can be obtained by the following methods, which return `none`, if the group number is invalid. The group number `0` (zero) means the whole match:

```v
(m &Match) group_bounds(idx int) ?(int, int)
(m &Match) group_text(subject string, idx int) ?string
```

Don't forget to free the match object when you do not need it any more:

```v
(m &Match) free()
defer { m.free() }
```

If the execution cannot match the pattern, a special error will be returned:

```v
struct NoMatch {}
```

If the execution matches the pattern only partially - see options `opt_partial_hard` and `opt_partial_soft`, a special error will be returned:

```v
struct Partial {}
```

If the execution fails from other reasons, a general error will be returned:

```v
struct ExecuteError {
  msg  string
  code int
}
```

The following error codes may encounter and are exported as public constants:

```v
error_baddata           = -29
error_mixedtables       = -30
error_badmagic          = -31
error_badmode           = -32
error_badoffset         = -33
error_badoption         = -34
error_badreplacement    = -35
error_badutfoffset      = -36
error_internal          = -44
error_matchlimit        = -47
error_nomemory          = -48
error_nosubstring       = -49
error_nouniquesubstring = -50
error_null              = -51
error_recurseloop       = -52
error_depthlimit        = -53
error_unavailable       = -54
error_badoffsetlimit    = -56
error_badrepescape      = -57
error_repmissingbrace   = -58
error_badsubstitution   = -59
error_badsubspattern    = -60
error_toomanyreplace    = -61
error_badserializeddata = -62
error_heaplimit         = -63
error_convert_syntax    = -64
error_internal_dupmatch = -65
```

See also the [original documentation for pcre_match] and the description of the [partial matching].

## Others

The API consists of two parts - basic compilation and execution of a regular expression, corresponding with the [PCRE] C API described above and convenience functions for typical string checking, searching, splitting and replacing described below.

### Searching

```v
(r &RegEx) matches(s string, opt int) !bool
(r &RegEx) matches_within(s string, at int, end int, opt int) !bool
(r &RegEx) matches_within_nochk(s string, at int, stop int, opt int) !bool

(r &RegEx) contains(s string, opt int) !bool
(r &RegEx) contains_within(s string, at int, end int, opt int) !bool
(r &RegEx) contains_within_nochk(s string, at int, stop int, opt int) !bool

(r &RegEx) starts_with(s string, opt int) !bool
(r &RegEx) starts_with_within(s string, at int, end int, opt int) !bool
(r &RegEx) starts_with_within_nochk(s string, at int, stop int, opt int) !bool

(r &RegEx) index_of(s string, option int) !int
(r &RegEx) index_of_within(s string, start int, end int, opt int) !int
(r &RegEx) index_of_within_nochk(s string, start int, stop int, opt int) !int

(r &RegEx) index_range(s string, opt int) !(int, int)
(r &RegEx) index_range_within(s string, start int, end int, opt int) !(int, int)
(r &RegEx) index_range_within_nochk(s string, start int, stop int, opt int) !(int, int)

(r &RegEx) ends_with(s string, opt int) !bool
(r &RegEx) ends_with_within(s string, from int, to int, opt int) !bool
(r &RegEx) ends_with_within_nochk(s string, from int, to int, opt int) !bool

(r &RegEx) count_of(s string, opt int) !int
(r &RegEx) count_of_within(s string, start int, end int, opt int) !int
(r &RegEx) count_of_within_nochk(s string, start int, stop int, opt int) !int
```

### Replacing

Replace either all occurrences or only the first one matching the pattern of the regular expression:

```v
(r &RegEx) replace(s string, with string, opt int) !string
(r &RegEx) replace_first(s string, with string, opt int) !string
```

If the regular expression doesn't match the pattern, a special error will be returned:

```v
struct NoMatch {}
```

If the regular expression matches, but the replacement string is the same as the found string, so the replacing wouldn't change anything, a special error will be returned:

```v
struct NoReplace {}
```

### Splitting

Split the input string by the regular expression and return the remaining parts in a string array:

```v
(r &RegEx) split(s string, opt int) ![]string
(r &RegEx) split_first(s string, opt int) ![]string
```

Split the input string by the regular expression and return all parts, both remaining and splitting, in a string array:

```v
(r &RegEx) chop(s string, opt int) ![]string
(r &RegEx) chop_first(s string, opt int) ![]string
```

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Lint and test your code.

## License

Copyright (c) 2023-2024 Ferdinand Prantl

Licensed under the MIT license.

[VPM]: https://vpm.vlang.io/packages/prantlf.pcre
[PCRE]: https://www.pcre.org/
[original documentation]: https://www.pcre.org/current/doc/html/
[original documentation for pcre_compile]: https://www.pcre.org/current/doc/html/pcre2_compile.html
[original documentation for pcre_match]: https://www.pcre.org/current/doc/html/pcre2_match.html
[partial matching]: https://www.pcre.org/current/doc/html/pcre2partial.html
[quick reference]: https://www.pcre.org/current/doc/html/pcre2syntax.html
[exhaustive documentation]: https://www.pcre.org/current/doc/html/pcre2pattern.html
[pattern limits]: https://www.pcre.org/current/doc/html/pcre2limits.html
[compatibility with PERL5]: https://www.pcre.org/current/doc/html/pcre2compat.html
[prantlf.pcre]: https://github.com/prantlf/v-pcre
