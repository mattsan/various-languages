% ビルド:
%   $ erlc hoshimeguri1async.erl
%
% 実行:
%   $ erl -run hoshimeguri1async main --noshell -data ../data.txt

-module(hoshimeguri1async).
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

solve() ->
  receive
    {From, Input, Expected} ->
      From ! {Input, Expected, lists:reverse(lists:foldl(fun(C, A) -> [star(hd(A), C)|A] end, [hd(Input)], tl(Input)))}
  end.

judge(_, Expected, Actual) when Expected == Actual ->
  io:put_chars(".");
judge(Input, Expected, Actual) ->
  io:format("""

input:    ~s
expected: ~s
actual:   ~s
""",
    [Input, Expected, Actual]
  ).

judge(0) -> ok;
judge(N) ->
  receive
    {Input, Expected, Actual} ->
      judge(Input, Expected, Actual),
      judge(N - 1)
  end.

test(Lines) ->
  lists:map(
    fun(Line) ->
      [Input, Expected] = string:tokens(Line, [$ , $\n]),
      Solver = spawn(fun solve/0),
      Solver ! {self(), Input, Expected}
    end,
    Lines
  ),
  judge(length(Lines)).

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
  test(Lines),
  io:nl(),
  halt().
