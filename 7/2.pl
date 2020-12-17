%
:- use_module(library(pio)).
:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).

satom(Atom) --> string(Codes), {atom_codes(Atom, Codes)}.

bag_spec(Adjective-Color) -->
  satom(Adjective),
  white,
  satom(Color),
  white,
  "bag",
  ("s" | []).

counted_bag_spec(Count:BagSpec) -->
  number(Count),
  white,
  bag_spec(BagSpec).

bag_phrase((Container, Containees)) -->
  bag_spec(Container),
  " contain ",
  (
    sequence(counted_bag_spec, ", ", Containees)
    | ("no other bags", { Containees = []})
  ),
  ".".

bag_phrases([]) --> [].
bag_phrases([H|T]) --> bag_phrase(H), !,"\n", bag_phrases(T).

bag_houses(BSer, BSee, DB):-
  member((BSer, BSees), DB),
  member(_:BSee, BSees).

bag_contains(BSer, BSee, DB):-
  bag_houses(BSer, BSee, DB)
  ;(
    bag_houses(BSer, Middle, DB),
    bag_contains(Middle, BSee, DB)
  ).


herp(DB, N:Bee, N*Nee):- bag_count(Bee, Nee, DB).
bag_count(B, 1, DB):- member((B, []), DB).
bag_count(B, N, DB):-
  member((B, Bees), DB),
  maplist(
    herp(DB),
    Bees,
    Segs
  ),
  foldl(+, Segs, 1, Formula),
  N #= Formula.

+(A,B,A+B).

main:-
  phrase_from_file(bag_phrases(DB), input),!,
  bag_count(shiny-gold, N0, DB),
  N is N0 - 1,
  writeln(N),
halt.
