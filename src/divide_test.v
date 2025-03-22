module pcre2

__global divide_test_re = &RegEx(unsafe { nil })

fn testsuite_begin() {
	divide_test_re = pcre2_compile('a', 0)!
}

fn testsuite_end() {
	divide_test_re.free()
}

fn test_split_empty_1() {
	assert divide_test_re.split('', 0)! == ['']
}

fn test_split_empty_2() {
	assert divide_test_re.split('a', 0)! == ['', '']
}

fn test_split_empty_3() {
	assert divide_test_re.split('aa', 0)! == ['', '', '']
}

fn test_split_1() {
	assert divide_test_re.split('b', 0)! == ['b']
}

fn test_split_2() {
	assert divide_test_re.split('bac', 0)! == ['b', 'c']
}

fn test_split_3() {
	assert divide_test_re.split('bacad', 0)! == ['b', 'c', 'd']
}

fn test_split_first_empty_1() {
	assert divide_test_re.split_first('', 0)! == ['']
}

fn test_split_first_empty_2() {
	assert divide_test_re.split_first('a', 0)! == ['', '']
}

fn test_split_first_empty_3() {
	assert divide_test_re.split_first('aa', 0)! == ['', 'a']
}

fn test_split_first_1() {
	assert divide_test_re.split_first('b', 0)! == ['b']
}

fn test_split_first_2() {
	assert divide_test_re.split_first('bac', 0)! == ['b', 'c']
}

fn test_split_first_3() {
	assert divide_test_re.split_first('bacad', 0)! == ['b', 'cad']
}

fn test_chop_empty_1() {
	assert divide_test_re.chop('', 0)! == ['']
}

fn test_chop_empty_2() {
	assert divide_test_re.chop('a', 0)! == ['', 'a', '']
}

fn test_chop_empty_3() {
	assert divide_test_re.chop('aa', 0)! == ['', 'a', '', 'a', '']
}

fn test_chop_1() {
	assert divide_test_re.chop('b', 0)! == ['b']
}

fn test_chop_2() {
	assert divide_test_re.chop('bac', 0)! == ['b', 'a', 'c']
}

fn test_chop_3() {
	assert divide_test_re.chop('bacad', 0)! == ['b', 'a', 'c', 'a', 'd']
}

fn test_chop_first_empty_1() {
	assert divide_test_re.chop_first('', 0)! == ['']
}

fn test_chop_first_empty_2() {
	assert divide_test_re.chop_first('a', 0)! == ['', 'a', '']
}

fn test_chop_first_empty_3() {
	assert divide_test_re.chop_first('aa', 0)! == ['', 'a', 'a']
}

fn test_chop_first_1() {
	assert divide_test_re.chop_first('b', 0)! == ['b']
}

fn test_chop_first_2() {
	assert divide_test_re.chop_first('bac', 0)! == ['b', 'a', 'c']
}

fn test_chop_first_3() {
	assert divide_test_re.chop_first('bacad', 0)! == ['b', 'a', 'cad']
}
