#lang slideshow

(require unstable/gui/pict
         "common.rkt"
         "settings.rkt"
         "venn.rkt"
         "table.rkt"
         "four-plot.rkt"
         "misc.rkt"
         "explain-sem.rkt"
         "related-work.rkt"
         "slidy.rkt" ;; putting slidy after testing makes fonts sad
         "metafunctions.rkt"
         "cmp-eval.rkt"
         "evaluation.rkt"
         "bench.rkt"
         "trace-picts.rkt"
         "intro.rkt"
         "testing.rkt")


(define (thesis-slide)
  (slide #:title "Thesis"
         (s-frame (t/n thesis))))

(title)

(show-venn)

(thesis-slide)

#;
(slide #:title "Outline"
       (item-frame "What is lightweight mechanized semantics?"
                   "Related Work"
                   "Work/Results"
                   "Dissertation Plan"))


(do-quadrants)

(do-related-work)

(do-slidy)

(do-automated-testing)

(explain-methods)

(do-trace)

(do-mf-slides)

(do-benchmark)

(do-eval)

(do-handwritten-eval)

(thesis-slide)
