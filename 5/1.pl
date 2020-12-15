%
use_module(library(clpfd)).

bin_enc([], _, _, 0).
bin_enc([Z|T], Z, I, N):- bin_enc(T, Z, I, N0), N #= N0 * 2.
bin_enc([I|T], Z, I, N):- bin_enc(T, Z, I, N0), N #= N0 * 2 + 1.

id_pass(Id, Pass):-
  sub_string(Pass, 0, 7, 3, RowS),
  sub_string(Pass, 7, 3, 0, ColS),
  string_codes(RowS, RowC),
  string_codes(ColS, ColC),
  reverse(RowR, RowC),
  reverse(ColR, ColC),
  bin_enc(RowR, 0'F, 0'B, Row),
  bin_enc(ColR, 0'L, 0'R, Col),
  Id #= Row * 8 + Col,
true.

read_ids(Ids):-
  open(input, read, Stream),
  read_string(Stream, _, Contents),
  close(Stream),
  split_string(Contents, "", "\n", [Trimmed]),
  split_string(Trimmed, "\n", "", Passes),
  maplist(id_pass, Ids, Passes),
true.

main:-
  read_ids(Ids),
  max_member(Max, Ids),
  writeln(Max),
halt.
