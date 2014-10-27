erlang-expr-calculator
======================

My first *Erlang* application - reads math expressions into reverse Polish notation and evaluates the result.

My manager at CDK instructed me to learn Erlang so I could support and contribute to a project that used an open source
Erlang core. I was inspired by Learn Me Some Erlang to write me some Reverse Polish Notation calculator
(http://learnyousomeerlang.com/functionally-solving-problems#rpn-calculator). I kept it very simple, supporting nothing
but addition, subtraction, multiplication, division, and powers of. It can evaluate an expression such as the following:

`
calc:math_eval("  5*2 + 2^3*2 + 9 - 3 * 7 / 21 + 4")
`

This expression will yield 38.0.