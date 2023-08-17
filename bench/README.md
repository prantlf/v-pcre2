# Benchmarks

When only a match of a regex is needed, Oniguruma, PCRE, PCRE2 and RE2 are significantly faster than the built-in regex. When the unnamed groups are needed, the times become more similar, with PCRE having an edge. When named groups are needed, PCRE has a clear edge:

    ❯ ./bench/bench-all-regexes.vsh
     SPENT    15.573 ms in regex test
     SPENT    17.506 ms in regex unamed
     SPENT   125.259 ms in regex named
     SPENT    57.654 ms in regex miss
     SPENT     6.067 ms in prantlf.onig test
     SPENT    10.059 ms in prantlf.onig unnamed
     SPENT   109.134 ms in prantlf.onig named
     SPENT    32.217 ms in prantlf.onig miss
     SPENT     5.571 ms in prantlf.pcre test
     SPENT     6.803 ms in prantlf.pcre unnamed
     SPENT    43.443 ms in prantlf.pcre named
     SPENT     7.618 ms in prantlf.pcre miss
     SPENT     8.185 ms in prantlf.pcre2 test
     SPENT    27.665 ms in prantlf.pcre2 unnamed
     SPENT   244.560 ms in prantlf.pcre2 named
     SPENT    16.888 ms in prantlf.pcre2 miss
     SPENT     3.285 ms in prantlf.re2 test
     SPENT    19.092 ms in prantlf.re2 unnamed
     SPENT   131.686 ms in prantlf.re2 named
     SPENT    77.562 ms in prantlf.re2 miss
