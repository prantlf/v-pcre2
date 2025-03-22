module pcre2

__global find_test_re = &RegEx(unsafe { nil })

fn testsuite_begin() {
	find_test_re = pcre2_compile('a', 0)!
}

fn testsuite_end() {
	find_test_re.free()
}

fn test_matches_yes() {
	assert find_test_re.matches('a', 0)!
	assert find_test_re.matches_within(' a', 1, -1, 0)!
	assert find_test_re.matches_within('a ', 0, 1, 0)!
}

fn test_matches_no() {
	assert !find_test_re.matches('b', 0)!
	assert !find_test_re.matches('a ', 0)!
	assert !find_test_re.matches(' a', 0)!
	assert !find_test_re.matches_within('a', 0, 0, 0)!
	assert !find_test_re.matches_within(' a', 0, -1, 0)!
	assert !find_test_re.matches_within('a ', 1, -1, 0)!
}

fn test_contains_yes() {
	assert find_test_re.contains('aa', 0)!
	assert find_test_re.contains(' aa', 0)!
	assert find_test_re.contains_within('aa ', 1, -1, 0)!
}

fn test_contains_no() {
	assert !find_test_re.contains('b', 0)!
	assert !find_test_re.contains_within('a ', 0, 0, 0)!
	assert !find_test_re.contains_within('a ', 1, -1, 0)!
}

fn test_starts_with_yes() {
	assert find_test_re.starts_with('a ', 0)!
	assert find_test_re.starts_with_within(' a ', 1, -1, 0)!
}

fn test_starts_with_no() {
	assert !find_test_re.starts_with('b', 0)!
	assert !find_test_re.starts_with(' a ', 0)!
	assert !find_test_re.starts_with_within('a ', 0, 0, 0)!
	assert !find_test_re.starts_with_within('a ', 1, -1, 0)!
}

fn test_index_of_yes() {
	assert find_test_re.index_of('aa', 0)! == 0
	assert find_test_re.index_of(' aa', 0)! == 1
	assert find_test_re.index_of_within('aa ', 1, -1, 0)! == 1
}

fn test_index_of_no() {
	assert find_test_re.index_of('b', 0)! == -1
	assert find_test_re.index_of_within('a ', 0, 0, 0)! == -1
	assert find_test_re.index_of_within('a ', 1, -1, 0)! == -1
}

fn test_index_range_yes() {
	mut start, mut end := find_test_re.index_range('aa', 0)!
	assert start == 0
	assert end == 1
	start, end = find_test_re.index_range(' aa', 0)!
	assert start == 1
	assert end == 2
	start, end = find_test_re.index_range_within('aa ', 1, -1, 0)!
	assert start == 1
	assert end == 2
}

fn test_index_range_no() {
	mut start, mut end := find_test_re.index_range('b', 0)!
	assert start == -1
	assert end == -1
	start, end = find_test_re.index_range_within('a ', 0, 0, 0)!
	assert start == -1
	assert end == -1
	start, end = find_test_re.index_range_within('a ', 1, -1, 0)!
	assert start == -1
	assert end == -1
}

fn test_ends_with_yes() {
	assert find_test_re.ends_with(' a', 0)!
	assert find_test_re.ends_with_within('  a', 1, -1, 0)!
}

fn test_ends_with_no() {
	assert !find_test_re.ends_with('b', 0)!
	assert !find_test_re.ends_with(' a ', 0)!
	assert !find_test_re.ends_with_within(' a', 0, 0, 0)!
	assert !find_test_re.ends_with_within(' a ', 1, -1, 0)!
}

fn test_count_of_yes() {
	assert find_test_re.count_of('aa', 0)! == 2
	assert find_test_re.count_of(' aa', 0)! == 2
	assert find_test_re.count_of_within('aa ', 1, -1, 0)! == 1
}

fn test_count_of_no() {
	assert find_test_re.count_of('b', 0)! == 0
	assert find_test_re.count_of_within('a ', 0, 0, 0)! == 0
	assert find_test_re.count_of_within('a ', 1, -1, 0)! == 0
}
