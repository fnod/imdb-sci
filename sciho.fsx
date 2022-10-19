#!/usr/bin/env -S dotnet fsi -O
#nowarn "25"

open System.IO
open System.Collections

let min_score = 7.5
let min_votes = 1000

let scores = Hashtable 25_000

let raw_scores = File.ReadLines "title.ratings.tsv" |> Seq.skip 1
let raw_basics = File.ReadLines "title.basics.tsv" |> Seq.skip 1

Seq.iter (fun (x:string) -> 
    let [|ident; score; votes|] = x.Split('\t')
    if int(votes) >= min_votes && float(score) >= min_score then
        scores.Add(ident, score)
) raw_scores

Seq.iter (fun (x:string) ->
    let [|i; ty; ti; _; _; yr; _; _; _g|] = x.Split('\t')
    let gs = _g.Split(',')
    if Seq.contains "Sci-Fi" gs
    && (Seq.contains"Thriller" gs || Seq.contains"Horror" gs)
    && ty.Equals "movie"
    && scores.ContainsKey(i) then
        let sc = scores.[i] :?> string
        printfn "%s (%s), %s - https://imdb.com/title/%s" ti yr sc i
) raw_basics

