module pcre2

fn test_empty() {
	re := pcre2_compile('', 0)!
	defer {
		re.free()
	}
}

fn test_simple() {
	re := pcre2_compile('a', 0)!
	defer {
		re.free()
	}
	assert re.captures == 0
	assert re.names == 0
}

fn test_group() {
	re := pcre2_compile('(a)', 0)!
	defer {
		re.free()
	}
	assert re.captures == 1
	assert re.names == 0
}

fn test_named_group() {
	re := pcre2_compile('(?<test>a)', 0)!
	defer {
		re.free()
	}
	assert re.captures == 1
	assert re.names == 1
	assert re.group_index_by_name('dummy') == -1
	assert re.group_index_by_name('test') == 1
	assert re.group_name_by_index(1) == 'test'
}
