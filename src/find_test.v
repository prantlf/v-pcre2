module pcre2

__global re = &RegEx(unsafe { nil })

fn testsuite_begin() {
	re = pcre2_compile('a', 0)!
}

fn testsuite_end() {
	re.free()
}

fn test_matches_yes() {
	assert re.matches('a', 0)!
	assert re.matches_within(' a', 1, -1, 0)!
	assert re.matches_within('a ', 0, 1, 0)!
}

fn test_matches_no() {
	assert !re.matches('b', 0)!
	assert !re.matches('a ', 0)!
	assert !re.matches(' a', 0)!
	assert !re.matches_within('a', 0, 0, 0)!
	assert !re.matches_within(' a', 0, -1, 0)!
	assert !re.matches_within('a ', 1, -1, 0)!
}

fn test_contains_yes() {
	assert re.contains('aa', 0)!
	assert re.contains(' aa', 0)!
	assert re.contains_within('aa ', 1, -1, 0)!
}

fn test_contains_no() {
	assert !re.contains('b', 0)!
	assert !re.contains_within('a ', 0, 0, 0)!
	assert !re.contains_within('a ', 1, -1, 0)!
}

fn test_starts_with_yes() {
	assert re.starts_with('a ', 0)!
	assert re.starts_with_within(' a ', 1, -1, 0)!
}

fn test_starts_with_no() {
	assert !re.starts_with('b', 0)!
	assert !re.starts_with(' a ', 0)!
	assert !re.starts_with_within('a ', 0, 0, 0)!
	assert !re.starts_with_within('a ', 1, -1, 0)!
}

fn test_index_of_yes() {
	assert re.index_of('aa', 0)! == 0
	assert re.index_of(' aa', 0)! == 1
	assert re.index_of_within('aa ', 1, -1, 0)! == 1
}

fn test_index_of_no() {
	assert re.index_of('b', 0)! == -1
	assert re.index_of_within('a ', 0, 0, 0)! == -1
	assert re.index_of_within('a ', 1, -1, 0)! == -1
}

fn test_index_range_yes() {
	mut start, mut end := re.index_range('aa', 0)!
	assert start == 0
	assert end == 1
	start, end = re.index_range(' aa', 0)!
	assert start == 1
	assert end == 2
	start, end = re.index_range_within('aa ', 1, -1, 0)!
	assert start == 1
	assert end == 2
}

fn test_index_range_no() {
	mut start, mut end := re.index_range('b', 0)!
	assert start == -1
	assert end == -1
	start, end = re.index_range_within('a ', 0, 0, 0)!
	assert start == -1
	assert end == -1
	start, end = re.index_range_within('a ', 1, -1, 0)!
	assert start == -1
	assert end == -1
}

fn test_ends_with_yes() {
	assert re.ends_with(' a', 0)!
	assert re.ends_with_within('  a', 1, -1, 0)!
}

fn test_ends_with_no() {
	assert !re.ends_with('b', 0)!
	assert !re.ends_with(' a ', 0)!
	assert !re.ends_with_within(' a', 0, 0, 0)!
	assert !re.ends_with_within(' a ', 1, -1, 0)!
}

fn test_count_of_yes() {
	assert re.count_of('aa', 0)! == 2
	assert re.count_of(' aa', 0)! == 2
	assert re.count_of_within('aa ', 1, -1, 0)! == 1
}

fn test_count_of_no() {
	assert re.count_of('b', 0)! == 0
	assert re.count_of_within('a ', 0, 0, 0)! == 0
	assert re.count_of_within('a ', 1, -1, 0)! == 0
}
