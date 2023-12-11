module pcre2

import prantlf.strutil { check_bounds_strict }

pub const error_baddata = -29
pub const error_mixedtables = -30
pub const error_badmagic = -31
pub const error_badmode = -32
pub const error_badoffset = -33
pub const error_badoption = -34
pub const error_badreplacement = -35
pub const error_badutfoffset = -36
pub const error_internal = -44
pub const error_matchlimit = -47
pub const error_nomemory = -48
pub const error_nosubstring = -49
pub const error_nouniquesubstring = -50
pub const error_null = -51
pub const error_recurseloop = -52
pub const error_depthlimit = -53
pub const error_unavailable = -54
pub const error_badoffsetlimit = -56
pub const error_badrepescape = -57
pub const error_repmissingbrace = -58
pub const error_badsubstitution = -59
pub const error_badsubspattern = -60
pub const error_toomanyreplace = -61
pub const error_badserializeddata = -62
pub const error_heaplimit = -63
pub const error_convert_syntax = -64
pub const error_internal_dupmatch = -65

@[inline]
pub fn (r &RegEx) exec(subject string, options u32) !Match {
	return unsafe { r.exec_within_nochk(subject, 0, subject.len, options)! }
}

pub fn (r &RegEx) exec_within(subject string, start int, end int, options u32) !Match {
	stop := check_bounds_strict(subject, start, end)!
	return unsafe { r.exec_within_nochk(subject, start, stop, options)! }
}

@[unsafe]
pub fn (r &RegEx) exec_within_nochk(subject string, start int, end int, options u32) !Match {
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	code := C.pcre2_match(r.re, subject.str, end, start, options, match_data, unsafe { nil })
	return if code == C.PCRE2_ERROR_NOMATCH {
		C.pcre2_match_data_free(match_data)
		NoMatch{}
	} else if code == C.PCRE2_ERROR_PARTIAL {
		C.pcre2_match_data_free(match_data)
		Partial{}
	} else if code <= 0 {
		C.pcre2_match_data_free(match_data)
		fail_exec(code)
	} else {
		Match{match_data}
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
