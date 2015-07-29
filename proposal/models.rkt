#lang racket

(require pict
         slideshow
         "common.rkt"
         "settings.rkt"
         "table.rkt")

(provide models-table
         mod-data)


(define mod-data
  '(("Model" "synthesized" "artifact" "loc" "# of bugs")
    ("delim-cont" #f #t 928 3)
    ("let-poly" #t #f 742 7)
    ("list-machine" #f #t 276 3)
    ("poly-stlc" #t #t 309 9)
    ("rbtrees" #t #f 209 3)
    ("rvm" #f #t 1069 7)
    ("stlc+lists" #t #f 213 9)
    ("stlc-subst" #t #f 275 9)))


(define models-list
  (map
   (match-lambda
    [(? string? str) (t str)]
    [(? number? n) (t (number->string n))]
    [#f (blank 0 0)]
    [#t (colorize (disk 15) colors:emph-dull)])
   (flatten mod-data)))

(define mod-table
  (table/line 5 models-list
              cbl-superimpose cc-superimpose
              50 10))

(define (models-table)
  (slide #:title "Benchmark models"
         (scale-to-fit (s-frame mod-table)
                       (inset titleless-page -20))))
