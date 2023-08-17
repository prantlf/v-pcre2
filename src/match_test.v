module pcre2

fn test_bounds_no_capture() {
	offsets := [usize(1), 3, 0]
	m := Match{
		data: unsafe { nil }
		offsets: offsets.data
	}
	if _, _ := m.group_bounds(-1) {
		assert false
	}
	start, end := m.group_bounds(0)?
	assert start == 1
	assert end == 3
	if _, _ := m.group_bounds(1) {
		assert false
	}
}

fn test_bounds_one_capture() {
	offsets := [usize(1), 3, 1, 2, 0, 0]
	m := Match{
		data: unsafe { nil }
		offsets: offsets.data
		captures: 1
	}
	start, end := m.group_bounds(1)?
	assert start == 1
	assert end == 2
	if _, _ := m.group_bounds(2) {
		assert false
	}
}

fn test_bounds_bad_capture() {
	offsets := [usize(1), 3, -1, -1, 0, 0]
	m := Match{
		data: unsafe { nil }
		offsets: offsets.data
		captures: 1
	}
	if _, _ := m.group_bounds(1) {
		assert false
	}
}

fn test_text() {
	offsets := [usize(1), 3, 1, 2, -1, -1, 0, 0]
	m := Match{
		data: unsafe { nil }
		offsets: offsets.data
		captures: 2
	}
	if _, _ := m.group_text('abc', -1) {
		assert false
	}
	assert m.group_text('abc', 0)? == 'bc'
	assert m.group_text('abc', 1)? == 'b'
	if _ := m.group_text('abc', 2) {
		assert false
	}
	if _ := m.group_text('abc', 3) {
		assert false
	}
}
