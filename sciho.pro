#!/usr/bin/env -S swipl -s

:- use_module(library(readutil)).
:- initialization main.

enough_votes(S) :- atom_number(S, N), N >= 1000.
good_rating(S) :- atom_number(S, N), N >= 7.5.
is_scifi(GS) :- member("Sci-Fi", GS).
is_also(GS) :- (member("Horror", GS); member("Thriller", GS) -> true ; false).

push_lines(_, -1, _{}).
push_lines(Stream, _, Dict) :-
    read_string(Stream, "\n", "", End, String),
    (   End is -1
    ->  push_lines(Stream, End, Last),
        put_dict([], Last, Dict)
    ;   split_string(String, "\t", "", L),
        nth0(0, L, I),
        nth0(1, L, R),
        nth0(2, L, V),
        string_to_atom(I, ID),
        (   enough_votes(V),
            good_rating(R)
        ->  push_lines(Stream, End, Next),
            put_dict([ID=R], Next, Dict)
        ;   push_lines(Stream, End, Next),
            put_dict([], Next, Dict))).

print_matches(_, _, -1).
print_matches(Stream, Ratings, _) :-
    read_string(Stream, "\n", "", End, String),
    (   End is -1
    ->  print_matches(Stream, Ratings, End)
    ;   split_string(String, "\t", "", L),
        nth0(0, L, I),
        nth0(1, L, Ty),
        nth0(2, L, Ti),
        nth0(5, L, Y),
        nth0(8, L, G),
        string_to_atom(I, ID),
        split_string(G, ",", "", GS),
        (   is_scifi(GS),
            is_also(GS),
            Ty = "movie",
            get_dict(ID, Ratings, R)
        ->  writef("%w (%w), %w - https://imdb.com/title/%w", [Ti,Y,R,ID]), nl
        ;   true),
        print_matches(Stream, Ratings, End)).

main :-
    open("title.ratings.tsv", read, RawRatings),
    read_string(RawRatings, "\n", "", End, _),
    push_lines(RawRatings, End, Ratings),
    open("title.basics.tsv", read, RawBasics),
    read_string(RawBasics, "\n", "", End, _),
    print_matches(RawBasics, Ratings, End),
    halt(0).
