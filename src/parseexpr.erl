-module(parseexpr).
-export([make_rpn/1, take/2]).

oplevels() -> #{add=>5, subtract=>5, multiply=>10,divide=>10,powerof=>15,  identity=>0}.
take(N, List) -> lists:reverse(take(N, List, 0, [])).
take(N, _, Count, Result) when Count>=N -> Result;
take(N, [H|T], Count, Result) -> take(N, T, Count+1, [H|Result]).

%% Take a numeric expression and return a list in reverse Polish notation.
make_rpn(Expr) -> make_rpn(tokenizer:math_tokenize(Expr), [{identity,0}], []).
make_rpn([LastToken], OpStack, Result) -> lists:append(Result, [LastToken|lists:map(fun({Op,_}) -> Op end, take(length(OpStack)-1, OpStack))]);
make_rpn([H,Op|Tail], OpStack, Result) ->
  %%io:format("(~p ~p ~p) ", [H,Op, OpStack]),
  [{LastOp,LastPrecedence}|_] = OpStack,
  OpLevels = oplevels(),
  ThisPrecedence = maps:get(Op, OpLevels, identity),
  if  ThisPrecedence > LastPrecedence ->
    make_rpn(Tail, [{Op,ThisPrecedence}|OpStack], lists:append(Result, [H]))
  ; ThisPrecedence =< LastPrecedence ->
    StackDrop = count_ops_gt(OpStack,ThisPrecedence),
    PopOps = lists:map( fun({Op,_}) -> Op end,
      take(StackDrop, OpStack)),
    %%io:format(" Popping ~p >= ~p (~p) ", [StackDrop, Op, PopOps]),
    make_rpn(Tail, [{Op,ThisPrecedence}|lists:nthtail(StackDrop, OpStack)], lists:append(Result, [H|PopOps]) )
  end.

count_ops_gt(Stack, BasePrecedence) -> count_ops_gt(Stack, BasePrecedence, 0).
count_ops_gt([], _, Result) -> Result;
count_ops_gt([{TopOp,TopPrecedence}|Bottoms], BasePrecedence, Result) ->
  if  TopPrecedence >= BasePrecedence -> count_ops_gt(Bottoms, BasePrecedence, Result + 1)
  ; true -> Result
  end.

