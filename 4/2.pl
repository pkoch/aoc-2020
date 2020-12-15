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
  maplist(=.., Calls, Entry),
  maplist(call, Calls),
true.

number_string_between(YearS, Low, High):-
  number_string(Year, YearS),
  Low =< Year,
  Year =< High,
true.

byr(YearS):- number_string_between(YearS, 1920, 2002).

ecl(ColorS):- member(ColorS, [
  "amb",
  "blu",
  "brn",
  "gry",
  "grn",
  "hzl",
  "oth"
]).

eyr(YearS):- number_string_between(YearS, 2020, 2030).

hcl(ColorS):- re_match("^#[0-9a-f]{6,6}$", ColorS).

hgt_case(S, Suf, Low, High):-
  string_concat(N, Suf, S),
  number_string_between(N, Low, High),
true.

hgt(HeightS):- hgt_case(HeightS, "in", 59, 76).
hgt(HeightS):- hgt_case(HeightS, "cm", 150, 193).

iyr(Y):- number_string_between(Y, 2010, 2020).

pid(Id):- re_match("^[0-9]{9,9}$", Id).

cid(_).

main:-
  read_file(Contents),
  contents_to_string_entries(Contents, SEntries),
  maplist(string_entry_to_entry, SEntries, Entries),
  include(valid_passport, Entries, ValidEntries),
  length(ValidEntries, Len),
  writeln(Len),
halt.
