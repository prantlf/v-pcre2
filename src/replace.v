module pcre2

import strings { Builder, new_builder }
import prantlf.strutil { compare_str_within_nochk }

pub fn (r &RegEx) replace(s string, with string, opt u32) !string {
	repl_grps := opt & opt_replace_groups != 0
	exec_opt := opt & ~opt_replace_groups
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	offsets := C.pcre2_get_ovector_pointer(match_data)
	mut builder := unsafe { &Builder(nil) }
	mut replaced := false
	mut pos := 0
	mut last := 0
	stop := s.len
	for {
		code := C.pcre2_match(r.re, s.str, stop, pos, exec_opt, match_data, unsafe { nil })
		if code == C.PCRE2_ERROR_NOMATCH {
			if pos == 0 {
				return NoMatch{}
			}
			break
		} else if code <= 0 {
			return fail_exec(code)
		} else {
			if isnil(builder) {
				mut b := new_builder(s.len + with.len)
				builder = &b
			}
			start_m := unsafe { int(offsets[0]) }
			pos = unsafe { int(offsets[1]) }
			unsafe { builder.write_ptr(s.str + last, start_m - last) }
			if repl_grps {
				start_r := builder.len
				replace_with(mut builder, s, with, offsets, r.captures)
				if !replaced {
					rep := unsafe { tos(&u8(builder.data) + start_r, builder.len - start_r) }
					if unsafe { compare_str_within_nochk(rep, s, start_m, pos) } != 0 {
						replaced = true
					}
				}
			} else {
				if !replaced && unsafe { compare_str_within_nochk(with, s, start_m, pos) } != 0 {
					replaced = true
				}
				builder.write_string(with)
			}
			last = pos
			if pos == stop {
				break
			}
		}
	}
	if !replaced {
		return NoReplace{}
	}
	if last < stop {
		unsafe { builder.write_ptr(s.str + last, stop - last) }
	}
	return builder.str()
}

pub fn (r &RegEx) replace_first(s string, with string, opt u32) !string {
	repl_grps := opt & opt_replace_groups != 0
	exec_opt := opt & ~opt_replace_groups
	match_data := C.pcre2_match_data_create_from_pattern(r.re, unsafe { nil })
	defer {
		C.pcre2_match_data_free(match_data)
	}
	stop := s.len
	code := C.pcre2_match(r.re, s.str, stop, 0, exec_opt, match_data, unsafe { nil })
	if code == C.PCRE2_ERROR_NOMATCH {
		return NoMatch{}
	} else if code <= 0 {
		return fail_exec(code)
	} else {
		mut builder := new_builder(s.len + with.len)
		offsets := C.pcre2_get_ovector_pointer(match_data)
		start_m := unsafe { int(offsets[0]) }
		pos := unsafe { int(offsets[1]) }
		unsafe { builder.write_ptr(s.str, start_m) }
		if repl_grps {
			start_r := builder.len
			replace_with(mut builder, s, with, offsets, r.captures)
			rep := unsafe { tos(&u8(builder.data) + start_r, builder.len - start_r) }
			if unsafe { compare_str_within_nochk(rep, s, start_m, pos) } == 0 {
				return NoReplace{}
			}
		} else {
			if unsafe { compare_str_within_nochk(with, s, start_m, pos) } == 0 {
				return NoReplace{}
			}
			builder.write_string(with)
		}
		len := stop - pos
		if len > 0 {
			unsafe { builder.write_ptr(s.str + pos, len) }
		}
		return builder.str()
	}
}

[direct_array_access]
fn replace_with(mut builder Builder, s string, with string, offsets &usize, captures int) {
	mut from := with.index_u8(`$`)
	if from < 0 {
		builder.write_string(with)
		return
	}

	mut prev := if from > 0 {
		if with[from - 1] != `\\` {
			unsafe { builder.write_ptr(with.str, from) }
			`\0`
		} else {
			if from - 1 > 0 {
				unsafe { builder.write_ptr(with.str, from - 1) }
			}
			`\\`
		}
	} else {
		`\0`
	}

	for from < with.len {
		cur := with[from]
		if prev == `\\` {
			builder.write_u8(cur)
			from++
			prev = `\0`
		} else if cur == `$` && prev != `\\` {
			if from + 1 < with.len {
				digit := with[from + 1]
				if digit >= `0` && digit <= `9` {
					idx := digit - `0`
					if idx <= captures {
						unsafe {
							start := offsets[idx * 2]
							stop := offsets[idx * 2 + 1]
							builder.write_ptr(s.str + start, int(stop - start))
						}
					}
				} else {
					builder.write_u8(`$`)
					builder.write_u8(digit)
				}
				from += 2
				prev = `\0`
			} else {
				break
			}
		} else if cur == `\\` {
			from++
			prev = cur
		} else {
			builder.write_u8(cur)
			from++
			prev = cur
		}
	}

	if from < with.len {
		unsafe { builder.write_ptr(with.str + from, with.len - from) }
	}
}
