% $ gprolog --consult-file hoshimeguri1.prolog --entry-goal main -- ../data.txt

star(0'A, 0'W, 0'I).
star(0'A, 0'R, 0'H).
star(0'I, 0'W, 0'G).
star(0'I, 0'R, 0'F).
star(0'G, 0'W, 0'E).
star(0'G, 0'R, 0'D).
star(0'E, 0'W, 0'C).
star(0'E, 0'R, 0'B).
star(0'C, 0'W, 0'A).
star(0'C, 0'R, 0'J).
star(0'H, 0'W, 0'C).
star(0'H, 0'R, 0'J).
star(0'J, 0'W, 0'E).
star(0'J, 0'R, 0'B).
star(0'B, 0'W, 0'G).
star(0'B, 0'R, 0'D).
star(0'D, 0'W, 0'I).
star(0'D, 0'R, 0'F).
star(0'F, 0'W, 0'A).
star(0'F, 0'R, 0'H).

solve([FirstPoint|Colors], [FirstPoint|NextPoints]) :-
  append(PrevPoints, [_], NextPoints),
  maplist(star, [FirstPoint|PrevPoints], Colors, NextPoints).

judge(_, Expected, Expected) :- write('.').
judge(Input, Expected, Actual) :- format("~ninput:    ~s~nexpected: ~s~nactual:   ~s~n", [Input, Expected, Actual]).

test(Input, Expected) :-
  solve(Input, Actual),
  judge(Input, Expected, Actual).

test(end_of_file).
test(Line) :-
  append(Input, [0' |Expected], Line),
  test(Input, Expected),
  !.

read_line_to_code(_, -1, end_of_file).
read_line_to_code(_, 0'\n, []).
read_line_to_code(Stream, Code, [Code|Codes]) :-
  read_line_to_codes(Stream, Codes), !.

read_line_to_codes(Stream, Codes) :-
  get_code(Stream, Code),
  read_line_to_code(Stream, Code, Codes).

main :-
  current_prolog_flag(argv, [_,Filename|_]),
  open(Filename, read, Stream),
  repeat,
  read_line_to_codes(Stream, Line),
  test(Line),
  Line == end_of_file,
  close(Stream),
  nl,
  halt.
