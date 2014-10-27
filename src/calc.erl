-module(calc).
-export([math_eval/1, math_eval_rpn/1]).


math_eval(Expr) -> math_eval_rpn(parseexpr:make_rpn(Expr)).

math_eval_rpn(Rpnlist) -> math_eval_rpn(Rpnlist, []).
math_eval_rpn([], [Result]) -> Result;
math_eval_rpn([First|Tail], []) -> math_eval_rpn(Tail, [First]);
math_eval_rpn([powerof|Tail], [B,A|SubStack]) ->
  math_eval_rpn(Tail, [math:pow(A,B)|SubStack]);
math_eval_rpn([multiply|Tail], [B,A|SubStack]) ->
  math_eval_rpn(Tail, [A*B|SubStack]);
math_eval_rpn([divide|Tail], [B,A|SubStack]) ->
  math_eval_rpn(Tail, [A/B|SubStack]);
math_eval_rpn([add|Tail], [B,A|SubStack]) ->
  math_eval_rpn(Tail, [A+B|SubStack]);
math_eval_rpn([subtract|Tail], [B,A|SubStack]) ->
  math_eval_rpn(Tail, [A-B|SubStack]);
math_eval_rpn([X|Tail], Stack) ->
  math_eval_rpn(Tail, [X|Stack]).


