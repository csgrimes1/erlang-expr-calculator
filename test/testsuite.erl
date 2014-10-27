%%%-------------------------------------------------------------------
%%% @author grimescs
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Oct 2014 3:40 PM
%%%-------------------------------------------------------------------
-module(testsuite).
-author("grimescs").

-include_lib("eunit/include/eunit.hrl").

tokenize_test() ->
   ?assertMatch(
     ["|","a","b","c","d;","e","|"],
     tokenizer:tokenize(" | a, b, c, d;e | ",
       fun(Werd, Char) ->
         case {Werd, [Char]} of
           {_, ";"} -> end_token;
           {_, ","} -> discard_token;
           {_, " "} -> discard_token;
           {_, "|"} -> own_token;
           _ -> not_token
         end
       end
     )
   ).


math_tokenize_test() ->
  ?assertMatch(
    [1, add, 3, multiply, 2],
    tokenizer:math_tokenize(" 1 + 3  * 2 ")
  ).

take_test() ->
  ?assertMatch([1,2,3], parseexpr:take(3, [1,2,3,4,5,7,7,7,7,7])).

math_parse_test() ->
  Mp = parseexpr:make_rpn("  10 + 5 * 3^2 -8 *4 - 1"),
  io:format("~p ", [Mp]),

  ?assertMatch([10,5,3,2,powerof,multiply,add,8,4,multiply,subtract,1,subtract], Mp).


math_eval_test() ->
  Result = calc:math_eval("  5*2 + 2^3*2 + 9 - 3 * 7 / 21 + 4"),
  io:format("~p ", [Result]),
  %%Note that the power of operator yields floats rather than ints
  ?assertEqual(38.0, Result),
  ?assertEqual(16, calc:math_eval("1 + 2 * 10 -5")),
  ?assertEqual(55.0, calc:math_eval("1 + 3^3 * 2")),
  ?assertException(error, badarith, calc:math_eval("2 + 10/0")).
