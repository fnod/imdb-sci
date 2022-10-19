#!/usr/bin/env racket
#lang racket

(define min-score 7.5)
(define min-votes 1000)
(define scores (make-hash))

(define (store-good path)
  (define (next-rating file)
    (let ((line (read-line file 'any)))
      (unless (eof-object? line)
        (match (string-split line "\t")
          [(list id score votes) (and 
              (>= (string->number votes) min-votes)
              (>= (string->number score) min-score)
              (hash-set! scores id score))])
        (next-rating file))))
  (call-with-input-file path (lambda (f)
    (read-line f 'any) ;skip headers
    (next-rating f))))

(define (print-matches path)
  (define (next-basics file)
    (let ((line (read-line file 'any)))
      (unless (eof-object? line)
        (match (string-split line "\t")
        [(list id ty ti _ _ yr _ _ gs)
          (let ((gl (string-split gs ",")))
            (and 
              (hash-has-key? scores id)
              (member "Sci-Fi" gl)
              (or (member "Thriller" gl) (member "Horror" gl))
              (string=? ty "movie")
              (printf 
                "~a (~a), ~a - http://imdb.com/title/~a~%"
                ti yr (hash-ref scores id) id)))])
        (next-basics file))))
  (call-with-input-file path (lambda (f)
    (read-line f 'any)
    (next-basics f))))

(store-good "title.ratings.tsv")
(print-matches "title.basics.tsv")

