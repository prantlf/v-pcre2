module pcre2

fn test_exec_empty() {
	re := pcre2_compile('a', 0)!
	defer {
		re.free()
	}
	m := re.exec('', 0) or {
		assert err is NoMatch
		return
	}
	assert false
}

fn test_exec_miss() {
	re := pcre2_compile('a', 0)!
	defer {
		re.free()
	}
	re.exec('b', 0) or {
		assert err is NoMatch
		return
	}
	assert false
}

fn test_exec_match() {
	re := pcre2_compile('a', 0)!
	defer {
		re.free()
	}
	s := 'a'
	m := re.exec(s, 0)!
	defer {
		m.free()
	}
	start, end := m.group_bounds(0)
	assert start == 0
	assert end == 1
	assert m.group_text(s, 0)? == 'a'
	if _, _ := m.group_bounds(-1) {
		assert false
	}
	if _, _ := m.group_text(s, -1) {
		assert false
	}
	if _, _ := m.group_bounds(1) {
		assert false
	}
	if _, _ := m.group_text(s, 1) {
		assert false
	}
}

fn test_exec_group() {
	re := pcre2_compile('a(b)', 0)!
	defer {
		re.free()
	}
	s := 'abc'
	m := re.exec(s, 0)!
	defer {
		m.free()
	}
	mut start, mut end := m.group_bounds(0)
	assert start == 0
	assert end == 2
	assert m.group_text(s, 0)? == 'ab'
	start, end = m.group_bounds(1)
	assert start == 1
	assert end == 2
	assert m.group_text(s, 1)? == 'b'
}

fn test_exec_two_groups() {
	re := pcre2_compile('a(b)c(d)', 0)!
	defer {
		re.free()
	}
	s := 'abcd'
	m := re.exec(s, 0)!
	defer {
		m.free()
	}
	mut start, mut end := m.group_bounds(0)
	assert start == 0
	assert end == 4
	assert m.group_text(s, 0)? == 'abcd'
	start, end = m.group_bounds(1)
	assert start == 1
	assert end == 2
	assert m.group_text(s, 1)? == 'b'
	start, end = m.group_bounds(2)
	assert start == 3
	assert end == 4
	assert m.group_text(s, 2)? == 'd'
}

fn test_exec_named_group() {
	re := pcre2_compile('a(?<test>b)', 0)!
	defer {
		re.free()
	}
	s := 'abc'
	m := re.exec(s, 0)!
	defer {
		m.free()
	}
	mut start, mut end := m.group_bounds(0)
	assert start == 0
	assert end == 2
	assert m.group_text(s, 0)? == 'ab'
	start, end = m.group_bounds(1)
	assert start == 1
	assert end == 2
	assert m.group_text(s, 1)? == 'b'
}

fn test_exec_two_named_groups() {
	re := pcre2_compile('a(?<test>b)c(?<test2>d)', 0)!
	defer {
		re.free()
	}
	s := 'abcd'
	m := re.exec(s, 0)!
	defer {
		m.free()
	}
	mut start, mut end := m.group_bounds(0)
	assert start == 0
	assert end == 4
	assert m.group_text(s, 0)? == 'abcd'
	start, end = m.group_bounds(1)
	assert start == 1
	assert end == 2
	assert m.group_text(s, 1)? == 'b'
	start, end = m.group_bounds(2)
	assert start == 3
	assert end == 4
	assert m.group_text(s, 2)? == 'd'
}

fn test_exec_either_group() {
	re := pcre2_compile('a(b)|(d)', 0)!
	defer {
		re.free()
	}
	s := 'abcd'
	m := re.exec(s, 0)!
	defer {
		m.free()
	}
	mut start, mut end := m.group_bounds(0)
	assert start == 0
	assert end == 2
	assert m.group_text(s, 0)? == 'ab'
	start, end = m.group_bounds(1)
	assert start == 1
	assert end == 2
	assert m.group_text(s, 1)? == 'b'
	if _, _ := m.group_bounds(2) {
		assert false
	}
	if _, _ := m.group_text(s, 2) {
		assert false
	}
}
