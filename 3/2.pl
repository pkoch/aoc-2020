% https://adventofcode.com/2020/day/3
:- use_module(library(dcg/basics)).

lines([]) --> [].
lines([[]|Rest]) --> "\n", lines(Rest).
lines([[0|Line]|Rest]) --> ".", lines([Line|Rest]).
lines([[1|Line]|Rest]) --> "#", lines([Line|Rest]).

count_trees(Map, (_, Y), _, 0):-
  length(Map, MaxY),
  Y >= MaxY,
true.

count_trees(Map, (X, Y), (DX, DY), Count):-
  nth0(Y, Map, Line),
  nth0(X, Line, El),
  length(Line, Len),
  X1 is (X + DX) mod Len,
  Y1 is Y + DY,
  count_trees(Map, (X1, Y1), (DX, DY), Count1),
  Count is El + Count1,
true.

*(A,B,A*B). % For foldl

main:-
  phrase_from_file(lines(Map), 'input'),
  maplist(
    count_trees(Map, (0, 0)),
    [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)],
    Counts
  ),
  foldl(*, Counts, 1, ResultEq),
  Result is ResultEq,
  print(Result), nl,
halt.
