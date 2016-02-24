% ビルド:
%   $ erlc hoshimeguri2.erl
%
% 実行:
%   $ erl -run hoshimeguri2 main --noshell -data ../data.txt

-module(hoshimeguri2).
-export([main/0]).

index(C) -> string:str("AHCJEBGDIF", [C]) - 1.

step(P0, $R) when P0 rem 2 =:= 1 -> (P0 + 2) rem 10;
step(P0, $W) when P0 rem 2 =:= 0 -> (P0 + 8) rem 10;
step(P0, _ ) -> (P0 + 1) rem 10.

solve([FirstPoint|Colors]) ->
  Indices = lists:foldl(
    fun(Color, Indices) ->
      lists:append(Indices, [step(lists:last(Indices), Color)])
    end,
    [index(FirstPoint)],
    Colors
  ),
  lists:map(fun(I) -> lists:nth(I + 1, "AHCJEBGDIF") end, Indices).

test(Input, Expected) ->
  Actual = solve(Input),
  if
    Actual == Expected -> io:put_chars(".");
    true               -> io:format("""

input:    ~s
expected: ~s
actual:   ~s
""", [Input, Expected, Actual])
  end.

test(Line) ->
  [Input, Expected] = string:tokens(Line, [$ , $\n]),
  test(Input, Expected).

read_lines(Handle) ->
  case file:read_line(Handle) of
    {ok, Line} -> [Line|read_lines(Handle)];
    _Otherwise -> []
  end.

main() ->
  {ok, [[Filename]]} = init:get_argument(data),
  {ok, Handle} = file:open(Filename, read),
  Lines = read_lines(Handle),
  file:close(Handle),
  lists:foreach(fun test/1, Lines),
  io:nl(),
  halt().
