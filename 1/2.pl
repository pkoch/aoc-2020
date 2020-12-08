% https://adventofcode.com/2020/day/1
% swipl -g main -g halt 2.pl
use_module(library(readutil)).
use_module(library(clpfd)).

read_file(Stream,[]) :- at_end_of_stream(Stream).

read_file(Stream,[H|T]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream,H),
    read_file(Stream,T),
true.

read_input_numbers(Numbers):-
  open("input", read, Fd),
  read_file(Fd, Lines),
  maplist(number_string, Numbers, Lines),
true.

find_solution(Sol):-
  read_input_numbers(Numbers),
  member(A, Numbers),
  member(B, Numbers),
  member(C, Numbers),
  A + B + C #= 2020,
  Sol is A * B * C,
true.

main:-
  find_solution(Sol),
  print(Sol), nl,
true.
