%

split_segments(Line, [Key, Value]):-
  split_string(Line, ":", "", [SKey, Value]),
  atom_string(Key, SKey),
true.

string_entry_to_entry(SEntry, Entry):-
  split_string(SEntry, "\n ", "\n ", Segments),
  maplist(split_segments, Segments, Entry),
true.

contents_to_string_entries(S, [S]):- \+ sub_string(S, _, _, _, "\n\n").
contents_to_string_entries(Contents, [Entry|R]):-
  sub_string(Contents, EntryLen, 2, RestLen, "\n\n"),
  sub_string(Contents, 0, EntryLen, _, Entry),

  PrefixLen is EntryLen + 2,
  sub_string(Contents, PrefixLen, RestLen, 0, ContentsR),

  contents_to_string_entries(ContentsR, R),
true.

read_file(Contents):-
  open('input', read, Stream),
  read_string(Stream, _Length, Contents),
  close(Stream),!,
true.

valid_passport(Entry):-
  maplist(nth1(1), Entry, Keys),
  list_to_ord_set(Keys, OKeys),
  ord_subtract([
    % Keep ordered
    byr,
    ecl,
    eyr,
    hcl,
    hgt,
    iyr,
    pid
  ], OKeys, []),
true.

main:-
  read_file(Contents),
  contents_to_string_entries(Contents, SEntries),
  maplist(string_entry_to_entry, SEntries, Entries),
  include(valid_passport, Entries, ValidEntries),
  length(ValidEntries, Len),
  writeln(Len),
halt.
