module pcre2

[noinit]
pub struct CompileError {
	Error
pub:
	msg    string
	code   int
	offset int = -1
}

fn (e &CompileError) msg() string {
	return e.msg
}

[noinit]
pub struct ExecError {
	Error
pub:
	msg  string
	code int
}

fn (e &ExecError) msg() string {
	return e.msg
}

[noinit]
pub struct NoMatch {
	Error
}

fn (e &NoMatch) msg() string {
	return 'no match'
}

[noinit]
pub struct NoReplace {
	Error
}

fn (e &NoReplace) msg() string {
	return 'no replace'
}
