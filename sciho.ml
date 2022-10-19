(*#!/usr/bin/env ocaml*)

let min_sc = 7.5;;
let min_vs = 1000;;

let line_stream filename =
    let channel = open_in filename in
    Stream.from (fun _ ->
        try Some (input_line channel) with End_of_file -> None);;

let add_good x hash =
    let sp = String.split_on_char '\t' x in
    let (id, sc, vs) = (List.nth sp 0, List.nth sp 1, List.nth sp 2) in
    if (int_of_string vs) >= min_vs && (float_of_string sc) >= min_sc then
        Hashtbl.add hash id sc;;

let print_match x hash =
    let sp = String.split_on_char '\t' x in
    let (i, ty, ti, y)
        = (List.nth sp 0, List.nth sp 1, List.nth sp 2,List.nth sp 5) in
    let gs = String.split_on_char ',' (List.nth sp 8) in
    if List.mem "Sci-Fi" gs
    && (List.mem "Thriller" gs || List.mem "Horror" gs)
    && String.equal ty "movie" then
        try
            let r = Hashtbl.find hash i in
            Printf.printf "%s (%s), %s - https://imdb.com/title/%s\n" ti y r i
        with Not_found -> ();;

let scores =
    let result = ref (Hashtbl.create 25_000) in
    let raw_scores = line_stream "title.ratings.tsv" in
    let () = Stream.junk raw_scores in
    Stream.iter
        (fun x -> add_good x !result)
        raw_scores;
    !result;;

let raw_basics = line_stream "title.basics.tsv";;
let () = Stream.junk raw_basics;;
let () = Stream.iter (fun x -> print_match x scores) raw_basics;;

