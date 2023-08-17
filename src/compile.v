module pcre2

import prantlf.strutil { compare_str_within_nochk, str_len_nochk }

struct Name {
	name_start int
	name_end   int
	group_idx  int
}

[heap; noinit]
struct RegEx {
	re        &C.pcre2_code
	name_buf  string
	name_data []Name
pub:
	captures int
	names    int
}

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

[inline]
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
			msg: msg
			code: code
			offset: int(offset)
		}
	}

	captures := 0
	code = C.pcre2_pattern_info(re, C.PCRE2_INFO_CAPTURECOUNT, &captures)
	if code != 0 {
		C.pcre2_code_free(re)
		msg := 'getting the count of captures failed'
		return CompileError{
			msg: msg
			code: code
		}
	}

	mut name_len := 0
	code = C.pcre2_pattern_info(re, C.PCRE2_INFO_NAMECOUNT, &name_len)
	if code != 0 {
		C.pcre2_code_free(re)
		msg := 'getting the count of named captures failed'
		return CompileError{
			msg: msg
			code: code
		}
	}

	mut name_data := []Name{cap: name_len}
	mut name_buf := ''
	if name_len > 0 {
		mut name_table := &u8(0)
		code = C.pcre2_pattern_info(re, C.PCRE2_INFO_NAMETABLE, &name_table)
		if code != 0 {
			C.pcre2_code_free(re)
			msg := 'getting the table of named captures failed'
			return CompileError{
				msg: msg
				code: code
			}
		}

		name_entry_size := 0
		code = C.pcre2_pattern_info(re, C.PCRE2_INFO_NAMEENTRYSIZE, &name_entry_size)
		if code != 0 {
			C.pcre2_code_free(re)
			msg := 'getting size of an entry in the table of named captures failed'
			return CompileError{
				msg: msg
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
