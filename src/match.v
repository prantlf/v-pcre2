module pcre2

[noinit]
pub struct Match {
	data &C.pcre2_match_data
}

[direct_array_access]
pub fn (m &Match) group_bounds(idx int) ?(int, int) {
	oveccount := C.pcre2_get_ovector_count(m.data)
	if idx < 0 || idx >= oveccount {
		return none
	}
	offsets := C.pcre2_get_ovector_pointer(m.data)
	offset := idx * 2
	start := unsafe { int(offsets[offset]) }
	if start < 0 {
		return none
	}
	end := unsafe { int(offsets[offset + 1]) }
	return start, end
}

[direct_array_access]
pub fn (m &Match) group_text(subject string, idx int) ?string {
	return if start, end := m.group_bounds(idx) {
		subject[start..end]
	} else {
		none
	}
}

pub fn (m &Match) free() {
	C.pcre2_match_data_free(m.data)
}
