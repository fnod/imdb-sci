#!/usr/bin/env -S scheme --script

(define min-score 7.5)
(define min-votes 1000)

(define raw-scores (open-input-file "title.ratings.tsv"))
(define raw-basics (open-input-file "title.basics.tsv"))
(define scores (make-hashtable equal-hash string=? 25000))

(define (l-r ls i) (list-ref ls i))
(define (str-split str ch)
  (let ((len (string-length str)))
    (letrec
      ((split
        (lambda (a b)
          (cond
            ((>= b len) (if (= a b) '() (cons (substring str a b) '())))
              ((char=? ch (string-ref str b)) (if (= a b)
                (split (+ 1 a) (+ 1 b))
                  (cons (substring str a b) (split b b))))
                (else (split a (+ 1 b)))))))
                  (split 0 0))))

(get-line raw-scores) ; skip headers
(do ((line (get-line raw-scores) (get-line raw-scores))) ((eof-object? line))
  (let ((sp (str-split line #\tab)))
    (let-values (
      [(id score votes)
      (values (l-r sp 0) (l-r sp 1) (l-r sp 2))])
      (and 
        (>= (string->number votes) min-votes)
        (>= (string->number score) min-score)
        (hashtable-set! scores id score)))))

(get-line raw-basics) ; skip headers
(do ((line (get-line raw-basics) (get-line raw-basics))) ((eof-object? line))
  (let ((sp (str-split line #\tab)))
    (let-values (
      [(id ty ti yr gs)
        (values (l-r sp 0) (l-r sp 1) (l-r sp 2) (l-r sp 5)
        (str-split (l-r sp 8) #\,))])
      (and 
        (member "Sci-Fi" gs)
        (or (member "Thriller" gs) (member "Horror" gs))
        (string=? ty "movie")
        (hashtable-contains? scores id)
        (printf "~a (~a), ~a - http://imdb.com/title/~a\n" 
                  ti yr (hashtable-ref scores id #f) id)
                  ))))

