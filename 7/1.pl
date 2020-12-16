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

main:-
  phrase_from_file(bag_phrases(DB), input),
  setof(Er, bag_contains(Er, shiny-gold, DB), Ls),
  length(Ls, N),
  writeln(N),
halt.
