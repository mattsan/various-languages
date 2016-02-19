% $ gprolog --consult-file hoshimeguri2.prolog --entry-goal main -- ../data.txt

index_char(I, C) :- nth0(I, "AHCJEBGDIF", C).

step(P0, 0'R, P1) :- P0 mod 2 =:= 1, P1 is (P0 + 2) mod 10, !.
step(P0, 0'W, P1) :- P0 mod 2 =:= 0, P1 is (P0 - 2) mod 10, !.
step(P0, _,   P1) :- P1 is (P0 + 1) mod 10, !.

solve([FirstPoint|Colors], Points) :-
  index_char(FirstIndex, FirstPoint),
  append(PrevIndices, [_], NextIndices),
  maplist(step, [FirstIndex|PrevIndices], Colors, NextIndices),
  maplist(index_char, [FirstIndex|NextIndices], Points).

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
