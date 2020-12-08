% https://adventofcode.com/2020/day/2
:- use_module(library(dcg/basics)).
:- use_module(library(clpfd)).

line([]) --> [].
line([[MinOccrN, MaxOccurN, CharC, PasswordC]|R]) -->
  digits(MinOccrC),
  "-",
  digits(MaxOccurC),
  white,
  string(CharsC),
  ":",
  white,
  string_without("\n", PasswordC),
  "\n",
  line(R),
  {
    maplist(
      string_codes,
      [MinOccrS, MaxOccurS],
      [MinOccrC, MaxOccurC]
    ),
    maplist(
      number_string,
      [MinOccrN, MaxOccurN],
      [MinOccrS, MaxOccurS]
    ),
    [CharC] = CharsC
  }.

valid_case([MinOccr, MaxOccur, Char, Password]):-
  delete(Password, Char, Others),
  length(Password, PasswordLen),
  length(Others, OthersLen),
  Occ #= PasswordLen - OthersLen,
  MinOccr #=< Occ,
  Occ #=< MaxOccur,
true.

main:-
  phrase_from_file(line(Cases), 'input'),
  include(valid_case, Cases, ValidCases),
  length(ValidCases, ValidCasesLen),
  print(ValidCasesLen), nl,
true.
