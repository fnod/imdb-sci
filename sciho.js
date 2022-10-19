#!/usr/bin/env node

const fs = require("fs")
const readline = require("readline")
const stream = require("stream")

const minVotes = 1000
const minRating = 7.5

let ratings = {}
readline.createInterface(
    fs.createReadStream("title.ratings.tsv"),
    new stream()
).on("line", l => {
    let r = l.split("\t")
    if (r[1] >= minRating && r[2] >= minVotes) { ratings[r[0]] = r[1] }
})

readline.createInterface(
    fs.createReadStream("title.basics.tsv"),
    new stream()
).on("line", l => {
    let line = l.split("\t")
    let tid = line[0]
    let type = line[1]
    let title = line[2]
    let year = line[5]
    let genres = line[8].split(",")
    let rating = ratings[tid]

    if (
        type === "movie"
        && genres.includes("Sci-Fi")
        && (genres.includes("Horror") || genres.includes("Thriller"))
        && Object.keys(ratings).includes(tid)
    ) { console.log(`${title} (${year}), ${rating}`) }
})

