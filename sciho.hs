#!/usr/bin/env runghc

import qualified Data.List as List
import qualified Data.List.Split as Split
import qualified Data.Map.Strict as Map

minRating = 7.5 :: Float 
minVotes = 1000 :: Int

tabSplit = map (\l -> Split.splitOn "\t" l)
nTuple = map (\[i,r,v] -> (i, (read r::Float), (read v :: Int))) 
fStr t y r = (t ++ " (" ++ y ++ "), " ++ show r)

main = do
  rawRatings <- readFile "title.ratings.tsv"
  let ts = tabSplit . drop 1 . lines $ rawRatings
  let rs = Map.fromList [ (i, read r :: Float) | [i,r,v] <- ts,
                                                 r >= show minRating,
                                                 let vi = read v :: Int,
                                                 vi >= minVotes ]
  
  rawBasics <- readFile "title.basics.tsv"
  let bs = tabSplit . drop 1 . lines $ rawBasics
  let bs' = [ (i,ty,ti,y,Split.splitOn "," gs) | [i,ty,ti,_,_,y,_,_,gs] <- bs ]
  let bo = [ fStr ti y r | (i,ty,ti,y,gs) <-  bs',
                             Map.member i rs,
                             "Sci-Fi" `elem` gs,
                             "Horror" `elem` gs || "Thriller" `elem` gs,
                             ty == "movie",
                             let r = (rs Map.! i) ]

  mapM_ putStrLn bo

