module pcre2

#flag -I @VROOT/libpcre2
#flag @VROOT/libpcre2/pcre2_auto_possess.c
#flag @VROOT/libpcre2/pcre2_compile.c
#flag @VROOT/libpcre2/pcre2_config.c
#flag @VROOT/libpcre2/pcre2_context.c
#flag @VROOT/libpcre2/pcre2_convert.c
#flag @VROOT/libpcre2/pcre2_dfa_match.c
#flag @VROOT/libpcre2/pcre2_error.c
#flag @VROOT/libpcre2/pcre2_extuni.c
#flag @VROOT/libpcre2/pcre2_find_bracket.c
#flag @VROOT/libpcre2/pcre2_maketables.c
#flag @VROOT/libpcre2/pcre2_match.c
#flag @VROOT/libpcre2/pcre2_match_data.c
#flag @VROOT/libpcre2/pcre2_newline.c
#flag @VROOT/libpcre2/pcre2_ord2utf.c
#flag @VROOT/libpcre2/pcre2_pattern_info.c
#flag @VROOT/libpcre2/pcre2_script_run.c
#flag @VROOT/libpcre2/pcre2_serialize.c
#flag @VROOT/libpcre2/pcre2_string_utils.c
#flag @VROOT/libpcre2/pcre2_study.c
#flag @VROOT/libpcre2/pcre2_substitute.c
#flag @VROOT/libpcre2/pcre2_substring.c
#flag @VROOT/libpcre2/pcre2_tables.c
#flag @VROOT/libpcre2/pcre2_ucd.c
#flag @VROOT/libpcre2/pcre2_valid_utf.c
#flag @VROOT/libpcre2/pcre2_xclass.c
#flag @VROOT/libpcre2/pcre2_chartables.c
#include "pcre2.h"

[typedef]
struct C.pcre2_memctl {
	malloc      voidptr
	free        voidptr
	memory_data voidptr
}

[typedef]
struct C.pcre2_code {
	memctl             C.pcre2_memctl
	tables             &u8
	executable_jit     voidptr
	start_bitmap       [32]u8
	blocksize          usize
	magic_number       u32
	compile_options    u32
	overall_options    u32
	extra_options      u32
	flags              u32
	limit_heap         u32
	limit_match        u32
	limit_depth        u32
	first_codeunit     u32
	last_codeunit      u32
	bsr_convention     u16
	newline_convention u16
	max_lookbehind     u16
	minlength          u16
	top_bracket        u16
	top_backref        u16
	name_entry_size    u16
	name_count         u16
}

[typedef]
struct C.heapframe {
	ecode             &u8
	temp_sptr         &u8
	length            usize
	back_frame        usize
	temp_size         usize
	rdepth            u32
	group_frame_type  u32
	temp_32           [4]u32
	return_id         u8
	op                u8
	occu              [6]u8
	eptr              &u8
	start_match       &u8
	mark              &u8
	current_recurse   u32
	capture_last      u32
	last_group_offset usize
	offset_top        usize
	ovector           [131072]usize
}

[typedef]
struct C.pcre2_match_data {
	memctl          C.pcre2_memctl
	code            &C.pcre2_code
	subject         &u8
	mark            &u8
	heapframes      &C.heapframe
	heapframes_size usize
	leftchar        usize
	rightchar       usize
	startchar       usize
	matchedby       u8
	flags           u8
	oveccount       u16
	rc              int
	ovector         [131072]usize
}

[typedef]
struct C.pcre2_match_context {
	memctl                  C.pcre2_memctl
	callout                 voidptr
	callout_data            voidptr
	substitute_callout      voidptr
	substitute_callout_data voidptr
	offset_limit            usize
	heap_limit              u32
	match_limit             u32
	depth_limit             u32
}

[typedef]
struct C.pcre2_compile_context {
	memctl             C.pcre2_memctl
	stack_guard        voidptr
	stack_guard_data   voidptr
	tables             &u8
	max_pattern_length usize
	bsr_convention     u16
	newline_convention u16
	parens_nest_limit  u32
	extra_options      u32
}

[typedef]
struct C.pcre2_general_context {
	memctl C.pcre2_memctl
}

fn C.pcre2_compile(pattern &u8, patlen usize, options u32, errorptr &int, erroroffset &usize, pcre2_compile_contex &ccontext) &C.pcre2_code
fn C.pcre2_get_error_message(enumber int, buffer &u8, size usize) int
fn C.pcre2_pattern_info(code &C.pcre2_code, what u32, where voidptr) int

fn C.pcre2_match(code &C.pcre2_code, subject &u8, length usize, start_offset usize, options u32, match_data &C.pcre2_match_data, mcontext &C.pcre2_match_context) int
fn C.pcre2_match_data_create_from_pattern(code &C.pcre2_code, pcre2_general_context &gcontext) &C.pcre2_match_data
fn C.pcre2_get_ovector_pointer(match_data &C.pcre2_match_data) &usize
fn C.pcre2_get_ovector_count(match_data &C.pcre2_match_data) usize

fn C.pcre2_code_free(code &C.pcre2_code)
fn C.pcre2_match_data_free(match_data &C.pcre2_match_data)
