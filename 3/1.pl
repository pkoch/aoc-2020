% https://adventofcode.com/2020/day/3
:- use_module(library(dcg/basics)).

lines([]) --> [].
lines([[]|Rest]) --> "\n", lines(Rest).
lines([[0|Line]|Rest]) --> ".", lines([Line|Rest]).
lines([[1|Line]|Rest]) --> "#", lines([Line|Rest]).


count_trees([], 0, _).
count_trees([Line|R], Count, Pos):-
  nth0(Pos, Line, El),
  length(Line, Len),
  Pos1 is (Pos + 3) mod Len,
  count_trees(R, Count1, Pos1),
  Count is El + Count1,
true.

main:-
  phrase_from_file(lines(Map), 'input'),
  count_trees(Map, Count, 0),
  print(Count), nl,
halt.
