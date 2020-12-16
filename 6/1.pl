%

fixed_split(S, Sep, [S]):- \+ sub_string(S, _, _, _, Sep).

fixed_split(Contents, Sep, [Entry|R]):-
  % Always keep the first Sep occurence.
  sub_string(Contents, EntryLen, _, RestLen, Sep),!,
  sub_string(Contents, 0, EntryLen, _, Entry),

  sub_string(Contents, _, RestLen, 0, ContentsR),

fixed_split(ContentsR, Sep, R).

read_input(Contents):-
  open(input, read, Stream),
  read_string(Stream, _, Contents),
  close(Stream),
true.

main:-
  read_input(Contents),
  fixed_split(Contents, "\n\n", EntriesRaw),
  maplist(re_replace("\\W"/g, ""), EntriesRaw, EntriesStripped),
  maplist(string_codes, EntriesStripped, EntriesDup),
  maplist(list_to_ord_set, EntriesDup, Entries),
  maplist(length, Entries, Counts),
  sum_list(Counts, Sums),
  writeln(Sums),
halt.
