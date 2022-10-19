#!/usr/bin/env Rscript

minVotes = 1000
minScore = 7.5

rawScores <- read.table(
    "title.ratings.tsv",
    sep = '\t',
    row.names = 1,
    header = T)
scores <- rawScores[rawScores$"numVotes" >= 1000 
                    & rawScores$"averageRating" >= 7.5, ]

rawBasics <- read.table(
    "title.basics.tsv",
    sep = '\t',
    row.names = 1,
    header = T,
    col.names = c("id","ty","ti","lt","ad","y0","yn","rt","gs"),
    quote = "",
    comment.char = "")

basics <- rawBasics[rownames(scores), ]
basics <- basics[
    basics$"ty" == "movie"
    & grepl("Sci-Fi", basics$"gs")
    & (grepl("Thriller", basics$"gs") 
        | grepl("Horror", basics$"gs"))
    , c("ti","y0")]

for (rn in rownames(basics)) {
    ti <- basics[rn, "ti"]; yr <- basics[rn,"y0"]
    score <- format(scores[rn,"averageRating"], nsmall=1)
    cat(sprintf("%s (%s), %s - https://imdb.com/title/%s\n",
                ti, yr, score, rn))
}
