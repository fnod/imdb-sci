#!/usr/bin/env python3

min_rating=7.5
min_votes=1000

ratings={
    t: float(r) for (t,r,v)
    in map(lambda x: x.split("\t"), open("title.ratings.tsv").readlines()[1:])
    if float(r) >= min_rating
    if int(v) >= min_votes
}

for t in open("title.basics.tsv").readlines()[1:]:
    (tid,ty,ti,og,ad,y0,y1,rt,gs) = t.split("\t")

    if "Sci-Fi" in gs \
    and ("Horror" in gs or "Thriller" in gs) \
    and ty == "movie" \
    and tid in ratings.keys():
        print(f"{ti} ({y0}), {ratings[tid]}")
