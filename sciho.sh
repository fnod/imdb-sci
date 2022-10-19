#!/bin/sh

min_rating=7.5
min_votes=1000

filtered_ratings=$(
    awk -v mr="$min_rating" -v mv="$min_votes" \
    '$2 >= mr && $3 >= mv' \
    title.ratings.tsv
)

grep -P 'Sci-Fi[^\t]*$' title.basics.tsv \
| grep -P 'Thriller[^\t]*$|Horror[^\t]*$' \
| grep -P '\tmovie\t' \
| while read line; do 
    tid=`echo $line | grep -oP 'tt\d+'`
    if echo "$filtered_ratings" | fgrep -m 1 -q "$tid" ; then
        title=`echo "$line" | awk -F'\t' '{print $3}'`
        year=`echo "$line" | awk -F'\t' '{print $6}'`
        rating=`echo "$filtered_ratings" | fgrep "$tid" | awk '{print $2}'`
        echo "$title ($year), $rating"
    fi
done

exit 0
 
