#!/usr/bin/env -S sbcl --script

(require :asdf)

; HASH
(defparameter ratingshash (make-hash-table))

(let ((in (open "title.ratings.tsv" :if-does-not-exist nil)))
  (read-line in nil) ;skip headers
  (when in (loop for x = (read-line in nil)
    while x do (destructuring-bind (i r v) 
      (uiop:split-string x :separator (string #\tab))
        (and
          (>= (read-from-string r) 7.5)
          (>= (parse-integer v) 1000)
          (setf (gethash (intern i) ratingshash) r)))) (close in)))

; COMMON
(let ((in (open "title.basics.tsv" :if-does-not-exist nil)))
  (when in (loop for line = (read-line in nil)
    while line do
      (destructuring-bind
        (id ty ti og ad y0 y1 rt gs)
        (uiop:split-string line :separator (string #\tab))
        (and
          (search "Sci-Fi" gs)
          (or (search "Horror" gs) (search "Thriller" gs))
          (equal "movie" ty)
          (gethash (intern id) ratingshash)
          (let ((r (gethash (intern id) ratingshash)))
            (write-line (format nil "~a (~a), ~a" ti y0 r)))))) (close in)))
