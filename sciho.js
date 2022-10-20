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
    let [tid, r, v] = l.split("\t")
    if (r >= minRating && v >= minVotes) { ratings[tid] = r }
})

readline.createInterface(
    fs.createReadStream("title.basics.tsv"),
    new stream()
).on("line", l => {
    var [tid, type, title, _, _, year, _, _, genre] = l.split("\t")
    let genres = genre.split(",")
    let rating = ratings[tid]

    if (
        type === "movie"
        && genres.includes("Sci-Fi")
        && (genres.includes("Horror") || genres.includes("Thriller"))
        && Object.keys(ratings).includes(tid)
    ) { console.log(`${title} (${year}), ${rating}`) }
})

