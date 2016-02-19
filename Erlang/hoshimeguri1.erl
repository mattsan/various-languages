% $ erlc hoshimeguri1.erl
% $ erl -run hoshimeguri1 main --noshell -data ../data.txt 

-module(hoshimeguri1).
-export([main/0]).

star($A, $W) -> $I;
star($A, $R) -> $H;
star($I, $W) -> $G;
star($I, $R) -> $F;
star($G, $W) -> $E;
star($G, $R) -> $D;
star($E, $W) -> $C;
star($E, $R) -> $B;
star($C, $W) -> $A;
star($C, $R) -> $J;
star($H, $W) -> $C;
star($H, $R) -> $J;
star($J, $W) -> $E;
star($J, $R) -> $B;
star($B, $W) -> $G;
star($B, $R) -> $D;
star($D, $W) -> $I;
star($D, $R) -> $F;
star($F, $W) -> $A;
star($F, $R) -> $H.

solve(Input) ->
  lists:reverse(lists:foldl(fun(C, A) -> [star(hd(A), C)|A] end, [hd(Input)], tl(Input))).

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
  lists:map(fun test/1, Lines),
  io:nl(),
  halt().
