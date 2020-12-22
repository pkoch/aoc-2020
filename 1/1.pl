% https://adventofcode.com/2020/day/1
% swipl -g main 1.pl
:- use_module(library(clpfd)).
:- use_module(library(dcg/basics)).

find_solution(Numbers, Sol):-
  member(A, Numbers),
  member(B, Numbers),
  A + B #= 2020,
  Sol #= A * B,
true.

line([]) --> ("\n"|[]), eos.
line([N|R]) -->
  number(N),
  "\n",
line(R).

main:-
  phrase_from_file(line(Numbers), input),
  find_solution(Numbers, Sol),
  writeln(Sol),
halt.
