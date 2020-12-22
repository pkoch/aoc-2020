% https://adventofcode.com/2020/day/1
% swipl -g main 2.pl
:- use_module(library(clpfd)).
:- use_module(library(dcg/basics)).

find_solution(Numbers, Sol):-
  member(A, Numbers),
  member(B, Numbers),
  member(C, Numbers),
  A + B + C #= 2020,
  Sol #= A * B * C,
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
