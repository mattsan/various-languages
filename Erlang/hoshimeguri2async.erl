% ビルド:
%   $ erlc hoshimeguri2async.erl
%
% 実行: 二つのコンソールを開いて、まず solver ノードを起動し、次に tester ノードを実行する
%   $ erl -sname solver
%   $ erl -run hoshimeguri2async main --noshell -sname tester -node solver@<hostname> -data ../data.txt

-module(hoshimeguri2async).
-export([main/0, solver/0]).

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

loop() ->
  receive
    {From, Input, Expected} ->
      Actual = solve(Input),
      From ! {Input, Expected, Actual},
      loop()
  end.

solver() ->
  case whereis(solver) of
    undefined -> Pid = spawn(node(), fun loop/0), register(solver, Pid), Pid;
    Pid       -> Pid
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

test(Solver, Lines) ->
  lists:map(
    fun(Line) ->
      [Input, Expected] = string:tokens(Line, " \n"),
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
  {ok, [[Node]]} = init:get_argument(node),
  {ok, [[Filename]]} = init:get_argument(data),
  {ok, Handle} = file:open(Filename, read),
  Lines = read_lines(Handle),
  file:close(Handle),
  case rpc:call(list_to_atom(Node), module_info(module), solver, [], 1000) of
    {badrpc, Reason} -> io:format("~p~n", [Reason]);
    Solver -> test(Solver, Lines)
  end,
  io:nl(),
  halt().
