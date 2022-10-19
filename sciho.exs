#!/usr/bin/env elixir

min_votes = 1000
min_rating = 7.5

ratings = File.stream!("title.ratings.tsv")
|> Stream.drop(1)
|> Enum.reduce(%{}, fn x, acc -> 
  [t, r, v] = x |> String.trim() |> String.split("\t")
  if String.to_float(r) >= min_rating
  and String.to_integer(v) >= min_votes do
    Map.put(acc, t, String.to_float(r))
  else
    acc 
  end end)
    

File.stream!("title.basics.tsv")
|> Stream.drop(1)
|> Stream.map(&String.trim(&1))
|> Stream.map(&String.split(&1, "\t"))
|> Enum.each(fn l ->
  [tid, type, title, _, _, year, _, _, genres] = l
  if type === "movie"
  and genres =~ "Sci-Fi"
  and (genres =~ "Horror" or genres =~ "Thriller")
  and Map.has_key?(ratings, tid) do
    IO.puts("#{title} (#{year}), #{ratings[tid]}")
  end
end)
    
