%
:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).

satom(Atom) --> string(Codes), {atom_codes(Atom, Codes)}.

bag_spec((Adjective, Color)) -->
  satom(Adjective),
  white,
  satom(Color),
  white,
  "bag",
  ("s" | []).

counted_bag_spec((Count, BagSpec)) -->
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

bag_phrases(Ls) --> sequence(bag_phrase, "\n", Ls).
