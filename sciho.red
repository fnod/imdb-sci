#!/usr/bin/env redl
Red []

min-votes: 1000
min-score: 7.5

raw-scores: read/lines %title.ratings.tsv
raw-basics: read/lines %title.basics.tsv


ratings: #()

foreach line (skip raw-scores 1) [
    s: split line #"^-"
    all [
        (to-integer s/3) >= min-votes
        (to-float s/2) >= min-score
        put ratings s/1 s/2 ] ]

foreach line (skip raw-basics 1) [
    s: split line #"^-"
    all [
        find s/9 "Sci-Fi"
        any [find s/9 "Thriller" find s/9 "Horror"]
        s/2 == "movie"
        r: select ratings s/1
        print [s/3 "(" s/6 ")," r "http://imdb.com/title/" s/1] ] ]

