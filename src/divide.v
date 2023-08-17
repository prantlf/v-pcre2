module pcre2

pub fn (r &RegEx) split(s string, opt u32) ![]string {
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	offsets := C.pcre2_get_ovector_pointer(match_data)
	mut parts := []string{}
	mut pos := 0
	mut last := 0
	stop := s.len
	for {
		code := C.pcre2_match(r.re, s.str, stop, pos, opt, match_data, unsafe { nil })
		if code == C.PCRE2_ERROR_NOMATCH {
			break
		} else if code <= 0 {
			return fail_exec(code)
		} else {
			pos = unsafe { int(offsets[1]) }
			end := unsafe { int(offsets[0]) }
			parts << s[last..end]
			last = pos
			if pos == stop {
				break
			}
		}
	}
	if last < stop {
		parts << s[last..stop]
	} else {
		parts << ''
	}
	return parts
}

pub fn (r &RegEx) split_first(s string, opt u32) ![]string {
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	mut parts := []string{}
	stop := s.len
	code := C.pcre2_match(r.re, s.str, stop, 0, opt, match_data, unsafe { nil })
	if code == C.PCRE2_ERROR_NOMATCH {
		parts << s
	} else if code <= 0 {
		return fail_exec(code)
	} else {
		offsets := C.pcre2_get_ovector_pointer(match_data)
		end := unsafe { int(offsets[0]) }
		parts << s[0..end]
		pos := unsafe { int(offsets[1]) }
		parts << s[pos..stop]
	}
	return parts
}

pub fn (r &RegEx) chop(s string, opt u32) ![]string {
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	offsets := C.pcre2_get_ovector_pointer(match_data)
	mut parts := []string{}
	mut pos := 0
	mut last := 0
	stop := s.len
	for {
		code := C.pcre2_match(r.re, s.str, stop, pos, opt, match_data, unsafe { nil })
		if code == C.PCRE2_ERROR_NOMATCH {
			break
		} else if code <= 0 {
			return fail_exec(code)
		} else {
			pos = unsafe { int(offsets[1]) }
			end := unsafe { int(offsets[0]) }
			parts << s[last..end]
			parts << s[end..pos]
			last = pos
			if pos == stop {
				break
			}
		}
	}
	if last < stop {
		parts << s[last..stop]
	} else {
		parts << ''
	}
	return parts
}

pub fn (r &RegEx) chop_first(s string, opt u32) ![]string {
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	mut parts := []string{}
	stop := s.len
	code := C.pcre2_match(r.re, s.str, stop, 0, opt, match_data, unsafe { nil })
	if code == C.PCRE2_ERROR_NOMATCH {
		parts << s
	} else if code <= 0 {
		return fail_exec(code)
	} else {
		offsets := C.pcre2_get_ovector_pointer(match_data)
		end := unsafe { int(offsets[0]) }
		parts << s[0..end]
		pos := unsafe { int(offsets[1]) }
		parts << s[end..pos]
		parts << s[pos..stop]
	}
	return parts
}
