module pcre2

import prantlf.strutil { check_bounds_strict }

[inline]
pub fn (r &RegEx) exec(subject string, options u32) !Match {
	return unsafe { r.exec_within_nochk(subject, 0, subject.len, options)! }
}

pub fn (r &RegEx) exec_within(subject string, start int, end int, options u32) !Match {
	stop := check_bounds_strict(subject, start, end)!
	return unsafe { r.exec_within_nochk(subject, start, stop, options)! }
}

[unsafe]
pub fn (r &RegEx) exec_within_nochk(subject string, start int, end int, options u32) !Match {
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	code := C.pcre2_match(r.re, subject.str, end, start, options, match_data, unsafe { nil })
	return if code == C.PCRE2_ERROR_NOMATCH {
		C.pcre2_match_data_free(match_data)
		NoMatch{}
	} else if code <= 0 {
		C.pcre2_match_data_free(match_data)
		fail_exec(code)
	} else {
		offsets := C.pcre2_get_ovector_pointer(match_data)
		Match{match_data, offsets, r.captures}
	}
}

fn fail_exec(code int) ExecError {
	return if code < 0 {
		ExecError{
			msg: 'executing the regular expression failed'
			code: code
		}
	} else {
		ExecError{
			msg: 'insufficient space for captures'
		}
	}
}
