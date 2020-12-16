%

fixed_split(Sep, S, [S]):- \+ sub_string(S, _, _, _, Sep).

fixed_split(Sep, Contents, [Entry|R]):-
  % Always keep the first Sep occurence.
  sub_string(Contents, EntryLen, _, RestLen, Sep),!,
  sub_string(Contents, 0, EntryLen, _, Entry),

  sub_string(Contents, _, RestLen, 0, ContentsR),

fixed_split(Sep, ContentsR, R).

read_input(Contents):-
  open(input, read, Stream),
  read_string(Stream, _, Contents),
  close(Stream),
true.

foldl1(_, [], _):- error(foldl1_on_empty).
foldl1(Goal, [H|T], V):- foldl(Goal, T, H, V).

process_group(WholeGroup, Count):-
  split_string(WholeGroup, "\n", "\n ", Strings),
  maplist(string_codes, Strings, CodesesDup),
  maplist(list_to_ord_set, CodesesDup, Codeses),
  foldl1(ord_intersection, Codeses, Common),
  length(Common, Count),
true.

main:-
  read_input(Contents),
  fixed_split("\n\n", Contents, WholeGroups),
  maplist(process_group, WholeGroups, Counts),
  sum_list(Counts, Sums),
  writeln(Sums),
halt.
