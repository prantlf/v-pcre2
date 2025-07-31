module pcre2

import prantlf.strutil { compare_str_within_nochk, str_len_nochk }

struct Name {
	name_start int
	name_end   int
	group_idx  int
}

@[heap; noinit]
pub struct RegEx {
	re        &C.pcre2_code
	name_buf  string
	name_data []Name
pub:
	captures int
	names    int
}

// The following option bits can be passed to both compile() and exec().
// opt_no_utf_check affects only the function to which it is passed.

pub const opt_anchored = u32(0x80000000)
pub const opt_no_utf_check = u32(0x40000000)
pub const opt_endanchored = u32(0x20000000)

// The following option bits can be passed only to compile(). However,
// they may affect exec() too. The following tags indicate which:
//
// C   alters what is compiled by compile()
// E   is inspected during exec() execution

pub const opt_allow_empty_class = u32(0x00000001) // C

pub const opt_alt_bsux = u32(0x00000002) // C

pub const opt_auto_callout = u32(0x00000004) // C

pub const opt_caseless = u32(0x00000008) // C

pub const opt_dollar_endonly = u32(0x00000010) // E

pub const opt_dotall = u32(0x00000020) // C

pub const opt_dupnames = u32(0x00000040) // C

pub const opt_extended = u32(0x00000080) // C

pub const opt_firstline = u32(0x00000100) // E

pub const opt_match_unset_backref = u32(0x00000200) // C E

pub const opt_multiline = u32(0x00000400) // C

pub const opt_never_ucp = u32(0x00000800) // C

pub const opt_never_utf = u32(0x00001000) // C

pub const opt_no_auto_capture = u32(0x00002000) // C

pub const opt_no_auto_possess = u32(0x00004000) // C

pub const opt_no_dotstar_anchor = u32(0x00008000) // C

pub const opt_no_start_optimize = u32(0x00010000) // E

pub const opt_ucp = u32(0x00020000) // C E

pub const opt_ungreedy = u32(0x00040000) // C

pub const opt_utf = u32(0x00080000) // C E

pub const opt_never_backslash_c = u32(0x00100000) // C

pub const opt_alt_circumflex = u32(0x00200000) // E

pub const opt_alt_verbnames = u32(0x00400000) // C

pub const opt_use_offset_limit = u32(0x00800000) // E

pub const opt_extended_more = u32(0x01000000) // C

pub const opt_literal = u32(0x02000000) // C

pub const opt_match_invalid_utf = u32(0x04000000) // E

// These are for exec(). Note that opt_anchored, opt_endanchored and
// opt_no_utf_check can also be passed to this function.

pub const opt_notbol = u32(0x00000001) //

pub const opt_noteol = u32(0x00000002) //

pub const opt_notempty = u32(0x00000004) // These two must be kept

pub const opt_notempty_atstart = u32(0x00000008) // adjacent to each other.

pub const opt_partial_soft = u32(0x00000010) //

pub const opt_partial_hard = u32(0x00000020) //

// These are for replace().

pub const opt_replace_groups = u32(0x00020000) // C6

pub const error_end_backslash = 101
pub const error_end_backslash_c = 102
pub const error_unknown_escape = 103
pub const error_quantifier_out_of_order = 104
pub const error_quantifier_too_big = 105
pub const error_missing_square_bracket = 106
pub const error_escape_invalid_in_class = 107
pub const error_class_range_order = 108
pub const error_quantifier_invalid = 109
pub const error_internal_unexpected_repeat = 110
pub const error_invalid_after_parens_query = 111
pub const error_missing_closing_parenthesis = 114
pub const error_bad_subpattern_reference = 115
pub const error_null_pattern = 116
pub const error_bad_options = 117
pub const error_missing_comment_closing = 118
pub const error_parentheses_nest_too_deep = 119
pub const error_pattern_too_large = 120
pub const error_heap_failed = 121
pub const error_unmatched_closing_parenthesis = 122
pub const error_internal_code_overflow = 123
pub const error_missing_condition_closing = 124
pub const error_lookbehind_not_fixed_length = 125
pub const error_zero_relative_reference = 126
pub const error_too_many_condition_branches = 127
pub const error_condition_assertion_expected = 128
pub const error_bad_relative_reference = 129
pub const error_unknown_posix_class = 130
pub const error_internal_study_error = 131
pub const error_unicode_not_supported = 132
pub const error_parentheses_stack_check = 133
pub const error_code_point_too_big = 134
pub const error_lookbehind_too_complicated = 135
pub const error_lookbehind_invalid_backslash_c = 136
pub const error_unsupported_escape_sequence = 137
pub const error_callout_number_too_big = 138
pub const error_missing_callout_closing = 139
pub const error_escape_invalid_in_verb = 140
pub const error_unrecognized_after_query_p = 141
pub const error_missing_name_terminator = 142
pub const error_duplicate_subpattern_name = 143
pub const error_invalid_subpattern_name = 144
pub const error_unicode_properties_unavailable = 145
pub const error_malformed_unicode_property = 146
pub const error_unknown_unicode_property = 147
pub const error_subpattern_name_too_long = 148
pub const error_too_many_named_subpatterns = 149
pub const error_class_invalid_range = 150
pub const error_octal_byte_too_big = 151
pub const error_internal_overran_workspace = 152
pub const error_internal_missing_subpattern = 153
pub const error_define_too_many_branches = 154
pub const error_backslash_o_missing_brace = 155
pub const error_internal_unknown_newline = 156
pub const error_backslash_g_syntax = 157
pub const error_parens_query_r_missing_closing = 158
pub const error_verb_unknown = 160
pub const error_subpattern_number_too_big = 161
pub const error_subpattern_name_expected = 162
pub const error_internal_parsed_overflow = 163
pub const error_invalid_octal = 164
pub const error_subpattern_names_mismatch = 165
pub const error_mark_missing_argument = 166
pub const error_invalid_hexadecimal = 167
pub const error_backslash_c_syntax = 168
pub const error_backslash_k_syntax = 169
pub const error_internal_bad_code_lookbehinds = 170
pub const error_backslash_n_in_class = 171
pub const error_callout_string_too_long = 172
pub const error_unicode_disallowed_code_point = 173
pub const error_utf_is_disabled = 174
pub const error_ucp_is_disabled = 175
pub const error_verb_name_too_long = 176
pub const error_backslash_u_code_point_too_big = 177
pub const error_missing_octal_or_hex_digits = 178
pub const error_version_condition_syntax = 179
pub const error_internal_bad_code_auto_possess = 180
pub const error_callout_no_string_delimiter = 181
pub const error_callout_bad_string_delimiter = 182
pub const error_backslash_c_caller_disabled = 183
pub const error_query_barjx_nest_too_deep = 184
pub const error_backslash_c_library_disabled = 185
pub const error_pattern_too_complicated = 186
pub const error_lookbehind_too_long = 187
pub const error_pattern_string_too_long = 188
pub const error_internal_bad_code = 189
pub const error_internal_bad_code_in_skip = 190
pub const error_bad_literal_options = 192
pub const error_supported_only_in_unicode = 193
pub const error_invalid_hyphen_in_options = 194
pub const error_alpha_assertion_unknown = 195
pub const error_script_run_not_available = 196
pub const error_too_many_captures = 197
pub const error_condition_atomic_assertion_expected = 198
pub const error_backslash_k_in_lookaround = 199

@[inline]
pub fn pcre2_compile(source string, options u32) !&RegEx {
	return compile(source, options)!
}

pub fn compile(source string, options u32) !&RegEx {
	mut code := 0
	mut offset := usize(0)
	re := C.pcre2_compile(source.str, source.len, options, &code, &offset, unsafe { nil })
	if isnil(re) {
		buffer := [256]u8{}
		err := &u8(buffer[0])
		len := C.pcre2_get_error_message(code, err, sizeof(buffer))
		msg := if len > 0 {
			unsafe { err.vstring_with_len(len) }
		} else {
			'pcre2_compile failed (${code})'
		}
		return CompileError{
			msg:    msg
			code:   code
			offset: int(offset)
		}
	}

	captures := 0
	code = C.pcre2_pattern_info(re, C.PCRE2_INFO_CAPTURECOUNT, &captures)
	if code != 0 {
		C.pcre2_code_free(re)
		msg := 'getting the count of captures failed'
		return CompileError{
			msg:  msg
			code: code
		}
	}

	mut name_len := 0
	code = C.pcre2_pattern_info(re, C.PCRE2_INFO_NAMECOUNT, &name_len)
	if code != 0 {
		C.pcre2_code_free(re)
		msg := 'getting the count of named captures failed'
		return CompileError{
			msg:  msg
			code: code
		}
	}

	mut name_data := []Name{cap: name_len}
	mut name_buf := ''
	if name_len > 0 {
		mut name_table := unsafe { &u8(0) }
		code = C.pcre2_pattern_info(re, C.PCRE2_INFO_NAMETABLE, &name_table)
		if code != 0 {
			C.pcre2_code_free(re)
			msg := 'getting the table of named captures failed'
			return CompileError{
				msg:  msg
				code: code
			}
		}

		name_entry_size := 0
		code = C.pcre2_pattern_info(re, C.PCRE2_INFO_NAMEENTRYSIZE, &name_entry_size)
		if code != 0 {
			C.pcre2_code_free(re)
			msg := 'getting size of an entry in the table of named captures failed'
			return CompileError{
				msg:  msg
				code: code
			}
		}

		table_end := unsafe { name_table + (name_len * name_entry_size) }
		name_buf = unsafe { tos(name_table, table_end - name_table) }

		max_len := name_entry_size - 3
		mut table_entry := name_table
		for table_entry < table_end {
			idx := (u16(*table_entry) << 8) | unsafe { table_entry[1] }
			str := unsafe { table_entry + 2 }
			len := unsafe { str_len_nochk(str, max_len) }
			start := unsafe { str - name_table }
			name_data << Name{start, start + len, idx}
			unsafe {
				table_entry += name_entry_size
			}
		}
	}

	return &RegEx{re, name_buf, name_data, captures, name_len}
}

pub fn (r &RegEx) free() {
	C.pcre2_code_free(r.re)
}

pub fn (r &RegEx) group_index_by_name(name string) int {
	for i, data in r.name_data {
		if unsafe { compare_str_within_nochk(name, r.name_buf, data.name_start, data.name_end) } == 0 {
			return i + 1
		}
	}
	return -1
}

pub fn (r &RegEx) group_name_by_index(idx int) string {
	data := &r.name_data[idx - 1]
	return unsafe { tos(r.name_buf.str + data.name_start, data.name_end - data.name_start) }
}
