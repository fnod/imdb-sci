#!/usr/bin/env runrs
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::collections::HashMap;

static MIN_SCORE: f64 = 7.5;
static MIN_VOTES: i32 = 1000;

fn main() {
    assert_eq!("hello".to_owned(), "hello".to_owned());

    let reader = BufReader::new(File::open("title.ratings.tsv").unwrap());
    let lines = reader.lines().skip(1);

    let mut ratings: HashMap<String, f64> = HashMap::new();

    for line in lines {
        let uline = line.unwrap();
        let ps = uline.split('\t').collect::<Vec<&str>>();
        
        let (id, score, votes): (String, f64, i32) = (
            ps[0].to_owned(), 
            ps[1].parse().unwrap(), 
            ps[2].parse().unwrap());
        if votes >= MIN_VOTES && score >= MIN_SCORE {
            ratings.insert(id, score);
        };
    };

    let reader = BufReader::new(File::open("title.basics.tsv").unwrap());
    let lines = reader.lines().skip(1);

    for line in lines {
        let uline = line.unwrap();
        let bs = uline.split('\t').collect::<Vec<&str>>();

        let (id, ty, ti, yr, gs) = 
            (bs[0],bs[1],bs[2],bs[5],bs[8].split(',').collect::<Vec<&str>>());
        let r = ratings.get(id);

        if gs.clone().into_iter().find(|&x| &x == &"Sci-Fi").is_some()
        && gs.clone().into_iter().find(|&x| {
            &x == &"Horror" 
            || &x == &"Thriller"
            /*|| &x == &"Mystery"*/}).is_some()
        &&ty == "movie"
        &&r.is_some() {
            println!("{} ({}), {} - https://imdb.com/title/{}",
                ti, yr, r.unwrap(), id)
        } else { () };
    }
}

