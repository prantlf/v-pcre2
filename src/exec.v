module pcre2

import prantlf.strutil { check_bounds_strict }

pub const (
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
)

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
