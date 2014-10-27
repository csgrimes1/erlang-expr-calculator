-module(tokenizer).
-author("grimescs").

%% API
-export([tokenize/2, math_tokenize/1]).



tokenize(S, Breaker) -> tokenize(S, Breaker, {"",[]}).
tokenize([], _, {Current, Collection}) ->
  case Current of
    [] -> Collection;
    _ -> lists:append(Collection, [Current])
  end;

tokenize([H|T], Breaker, {Current, Collection}) ->
  case {Current,Breaker(Current, H)} of
    {_,end_token} -> tokenize(T, Breaker, {"", lists:append(Collection, [lists:append(Current, [H])])});
    {[],discard_token} -> tokenize(T, Breaker, {"", Collection});
    {_,discard_token} -> tokenize(T, Breaker, {"", lists:append(Collection, [Current])});
    {[],own_token} -> tokenize(T, Breaker, {"", lists:append(Collection, [[H]])});
    {_,own_token} -> tokenize(T, Breaker, {"", lists:append(Collection, [Current, [H]])});
    {_,not_token} -> tokenize(T, Breaker, {lists:append(Current, [H]), Collection})
  end.

getops() -> #{"+"=>add, "-"=>subtract, "*"=>multiply, "/"=>divide, "^"=>powerof}.

math_tokenize_raw(Expr) ->
  tokenize(Expr, fun(Word, Char) ->
    case {Word, [Char], maps:is_key([Char], getops())} of
        {_, _, true} -> own_token;
        {_, " ", _} -> discard_token;
        {_, _, IsKey} -> not_token
      end
    end
  ).


%% string_to_number(String()) -> Int() | Float()
string_to_number(N) ->
  case string:to_float(N) of
    {error,no_float} -> list_to_integer(N);
    {F,_} -> F
  end.


math_tokenize(Expr) ->
  OpsMap = getops(),
  RawMap = math_tokenize_raw(Expr),
  lists:map(fun(Token) ->
%%       io:format("~s ", [Token]),
      case {Token, maps:is_key(Token, OpsMap)} of
        {_, true} -> maps:get(Token, OpsMap);
        {Word, _} -> string_to_number(Word)
      end
    end, RawMap
  ).

