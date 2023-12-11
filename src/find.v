module pcre2

import prantlf.strutil { check_bounds_incl }

@[inline]
pub fn (r &RegEx) matches(s string, opt u32) !bool {
	return unsafe { r.matches_within_nochk(s, 0, s.len, opt)! }
}

pub fn (r &RegEx) matches_within(s string, at int, end int, opt u32) !bool {
	stop := check_bounds_incl(s, at, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.matches_within_nochk(s, at, stop, opt)! }
}

@[unsafe]
pub fn (r &RegEx) matches_within_nochk(s string, at int, stop int, opt u32) !bool {
	if at == stop {
		return false
	}
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	code := C.pcre2_match(r.re, s.str, stop, at, opt, match_data, unsafe { nil })
	return if code == C.PCRE2_ERROR_NOMATCH {
		false
	} else if code <= 0 {
		fail_exec(code)
	} else {
		offsets := C.pcre2_get_ovector_pointer(match_data)
		unsafe { int(offsets[0]) == at && int(offsets[1]) == stop }
	}
}

@[inline]
pub fn (r &RegEx) contains(s string, opt u32) !bool {
	return unsafe { r.contains_within_nochk(s, 0, s.len, opt)! }
}

pub fn (r &RegEx) contains_within(s string, start int, end int, opt u32) !bool {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.contains_within_nochk(s, start, stop, opt)! }
}

@[unsafe]
pub fn (r &RegEx) contains_within_nochk(s string, start int, stop int, opt u32) !bool {
	if start == stop {
		return false
	}
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	code := C.pcre2_match(r.re, s.str, stop, start, opt, match_data, unsafe { nil })
	return if code == C.PCRE2_ERROR_NOMATCH {
		false
	} else if code <= 0 {
		fail_exec(code)
	} else {
		true
	}
}

@[inline]
pub fn (r &RegEx) starts_with(s string, opt u32) !bool {
	return unsafe { r.starts_with_within_nochk(s, 0, s.len, opt)! }
}

pub fn (r &RegEx) starts_with_within(s string, at int, end int, opt u32) !bool {
	stop := check_bounds_incl(s, at, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.starts_with_within_nochk(s, at, stop, opt)! }
}

@[unsafe]
pub fn (r &RegEx) starts_with_within_nochk(s string, at int, stop int, opt u32) !bool {
	if at == stop {
		return false
	}
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	code := C.pcre2_match(r.re, s.str, stop, at, opt, match_data, unsafe { nil })
	return if code == C.PCRE2_ERROR_NOMATCH {
		false
	} else if code <= 0 {
		fail_exec(code)
	} else {
		offsets := C.pcre2_get_ovector_pointer(match_data)
		unsafe { int(offsets[0]) } == at
	}
}

@[inline]
pub fn (r &RegEx) index_of(s string, option u32) !int {
	return unsafe { r.index_of_within_nochk(s, 0, s.len, option)! }
}

pub fn (r &RegEx) index_of_within(s string, start int, end int, opt u32) !int {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return -1
	}
	return unsafe { r.index_of_within_nochk(s, start, stop, opt)! }
}

@[unsafe]
pub fn (r &RegEx) index_of_within_nochk(s string, start int, stop int, opt u32) !int {
	if start == stop {
		return -1
	}
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	code := C.pcre2_match(r.re, s.str, stop, start, opt, match_data, unsafe { nil })
	return if code == C.PCRE2_ERROR_NOMATCH {
		-1
	} else if code <= 0 {
		fail_exec(code)
	} else {
		offsets := C.pcre2_get_ovector_pointer(match_data)
		unsafe { int(offsets[0]) }
	}
}

@[inline]
pub fn (r &RegEx) index_range(s string, opt u32) !(int, int) {
	unsafe {
		return r.index_range_within_nochk(s, 0, s.len, opt)!
	}
}

pub fn (r &RegEx) index_range_within(s string, start int, end int, opt u32) !(int, int) {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return -1, -1
	}
	unsafe {
		return r.index_range_within_nochk(s, start, stop, opt)!
	}
}

@[unsafe]
pub fn (r &RegEx) index_range_within_nochk(s string, start int, stop int, opt u32) !(int, int) {
	if start == stop {
		return -1, -1
	}
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	code := C.pcre2_match(r.re, s.str, stop, start, opt, match_data, unsafe { nil })
	return if code == C.PCRE2_ERROR_NOMATCH {
		-1, -1
	} else if code <= 0 {
		fail_exec(code)
	} else {
		offsets := C.pcre2_get_ovector_pointer(match_data)
		unsafe { int(offsets[0]), int(offsets[1]) }
	}
}

@[inline]
pub fn (r &RegEx) ends_with(s string, opt u32) !bool {
	return unsafe { r.ends_with_within_nochk(s, 0, s.len, opt)! }
}

pub fn (r &RegEx) ends_with_within(s string, start int, end int, opt u32) !bool {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return false
	}
	return unsafe { r.ends_with_within_nochk(s, start, stop, opt)! }
}

@[unsafe]
pub fn (r &RegEx) ends_with_within_nochk(s string, start int, end int, opt u32) !bool {
	if start == end {
		return false
	}
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	code := C.pcre2_match(r.re, s.str, end, start, opt, match_data, unsafe { nil })
	return if code == C.PCRE2_ERROR_NOMATCH {
		false
	} else if code <= 0 {
		fail_exec(code)
	} else {
		offsets := C.pcre2_get_ovector_pointer(match_data)
		unsafe { int(offsets[1]) } == end
	}
}

@[inline]
pub fn (r &RegEx) count_of(s string, option u32) !int {
	return unsafe { r.count_of_within_nochk(s, 0, s.len, option)! }
}

pub fn (r &RegEx) count_of_within(s string, start int, end int, opt u32) !int {
	stop := check_bounds_incl(s, start, end)
	if stop < 0 {
		return 0
	}
	return unsafe { r.count_of_within_nochk(s, start, stop, opt)! }
}

@[unsafe]
pub fn (r &RegEx) count_of_within_nochk(s string, start int, end int, opt u32) !int {
	if start == end {
		return 0
	}
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	mut cnt := 0
	mut pos := start
	for {
		code := C.pcre2_match(r.re, s.str, end, pos, opt, match_data, unsafe { nil })
		if code == C.PCRE2_ERROR_NOMATCH {
			break
		} else if code <= 0 {
			return fail_exec(code)
		} else {
			cnt++
			offsets := C.pcre2_get_ovector_pointer(match_data)
			pos = unsafe { int(offsets[1]) }
			if pos == end {
				break
			}
		}
	}
	return cnt
}
