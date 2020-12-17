%
:- use_module(library(pio)).
:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).

satom(Atom) --> string(Codes), {atom_codes(Atom, Codes)}.

input_phrase([Op, N]) --> satom(Op), white, number(N).

input_phrases([]) --> [].
input_phrases([H|T]) --> input_phrase(H), !,"\n", input_phrases(T).

run_([nop, _],
  (Cx0, Acc),
  (Cx1, Acc)
):-
  Cx1 #= Cx0 + 1.

run_([acc, N],
  (Cx0, Acc0),
  (Cx1, Acc1)
):-
  Acc1 #= Acc0 + N,
  Cx1 #= Cx0 + 1.

run_([jmp, N],
  (Cx0, Acc),
  (Cx1, Acc)
):-
  Cx1 #= Cx0 + N.

until_repeated(
  _,
  (Cx, Acc),
  Visited,
  Acc
):- member(Cx, Visited).

until_repeated(
  Insts,
  (Cx0, Acc0),
  Visited,
  FinalAcc
):-
  nth0(Cx0, Insts, Inst),
  run_(Inst, (Cx0, Acc0), (Cx1, Acc1)),
until_repeated(Insts, (Cx1, Acc1), [Cx0|Visited], FinalAcc).

main:-
  phrase_from_file(input_phrases(Insts), input),
  until_repeated(Insts, (0, 0), [], Acc),
  writeln(Acc),
halt.
