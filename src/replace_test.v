module pcre2

__global (
	replace_test_re     = &RegEx(unsafe { nil })
	replace_test_re_grp = &RegEx(unsafe { nil })
)

fn testsuite_begin() {
	replace_test_re = pcre2_compile('a', 0)!
	replace_test_re_grp = pcre2_compile('a(\\w)', 0)!
}

fn testsuite_end() {
	replace_test_re.free()
	replace_test_re_grp.free()
}

fn test_replace_empty() {
	replace_test_re.replace('', 'c', 0) or {
		assert err is NoMatch
		return
	}
	assert false
}

fn test_replace_no() {
	replace_test_re.replace('b', 'c', 0) or {
		assert err is NoMatch
		return
	}
	assert false
}

fn test_replace_same() {
	replace_test_re.replace('a', 'a', 0) or {
		assert err is NoReplace
		return
	}
	assert false
}

fn test_replace_only_one_same() {
	re_w := pcre2_compile('(\\w)', 0)!
	defer {
		re_w.free()
	}
	assert re_w.replace('ab', 'a', 0)! == 'aa'
}

fn test_replace_yes() {
	assert replace_test_re.replace('a', 'c', 0)! == 'c'
}

fn test_replace_after() {
	assert replace_test_re.replace('ba', 'c', 0)! == 'bc'
}

fn test_replace_before() {
	assert replace_test_re.replace('ab', 'c', 0)! == 'cb'
}

fn test_replace_two() {
	assert replace_test_re.replace('aa', 'c', 0)! == 'cc'
}

fn test_replace_between() {
	assert replace_test_re.replace('babab', 'c', 0)! == 'bcbcb'
}

fn test_replace_first_empty() {
	replace_test_re.replace_first('', 'c', 0) or {
		assert err is NoMatch
		return
	}
	assert false
}

fn test_replace_first_no() {
	replace_test_re.replace_first('b', 'c', 0) or {
		assert err is NoMatch
		return
	}
	assert false
}

fn test_replace_first_same() {
	replace_test_re.replace_first('a', 'a', 0) or {
		assert err is NoReplace
		return
	}
	assert false
}

fn test_replace_first_yes() {
	assert replace_test_re.replace_first('a', 'c', 0)! == 'c'
}

fn test_replace_first_after() {
	assert replace_test_re.replace_first('ba', 'c', 0)! == 'bc'
}

fn test_replace_first_before() {
	assert replace_test_re.replace_first('ab', 'c', 0)! == 'cb'
}

fn test_replace_first_only() {
	assert replace_test_re.replace_first('aa', 'c', 0)! == 'ca'
}

fn test_replace_plain() {
	assert replace_test_re_grp.replace('ab', 'c', opt_replace_groups)! == 'c'
}

fn test_replace_group() {
	assert replace_test_re_grp.replace('ab', '$1', opt_replace_groups)! == 'b'
}

fn test_replace_group_within() {
	assert replace_test_re_grp.replace('ab', 'c$1d', opt_replace_groups)! == 'cbd'
}

fn test_replace_whole() {
	assert replace_test_re_grp.replace('ab', '$0c', opt_replace_groups)! == 'abc'
}

fn test_replace_group_same() {
	re_w := pcre2_compile('(\\w)', 0)!
	defer {
		re_w.free()
	}
	re_w.replace('ab', '$1', opt_replace_groups) or {
		assert err is NoReplace
		return
	}
	assert false
}

fn test_replace_group_out() {
	assert replace_test_re_grp.replace('ab', '$2', opt_replace_groups)! == ''
}

fn test_replace_escaped_group() {
	assert replace_test_re_grp.replace('ab', '\\$1', opt_replace_groups)! == '$1'
}

fn test_replace_escaped_group_within() {
	assert replace_test_re_grp.replace('ab', 'c\\$1d', opt_replace_groups)! == 'c$1d'
}

fn test_replace_no_group() {
	assert replace_test_re_grp.replace('ab', r'$c', opt_replace_groups)! == r'$c'
}

fn test_replace_escape() {
	assert replace_test_re_grp.replace('ab', '\\', opt_replace_groups)! == '\\'
}

fn test_replace_two_escapes() {
	assert replace_test_re_grp.replace('ab', '\\\\', opt_replace_groups)! == '\\\\'
}

fn test_replace_disabled_groups() {
	assert replace_test_re_grp.replace('ab', '$1', 0)! == '$1'
}
