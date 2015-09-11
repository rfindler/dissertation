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
         "testing.rkt"
         "evaluation.rkt"
         "bench.rkt"
         "trace-picts.rkt"
         "intro.rkt"
         "slidy.rkt")


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

(do-redex-comp)

(do-automated-testing)

(constructs-table)

(explain-methods)

(do-trace)

(do-benchmark)

(do-eval)

(contents-table)

(todo-table)

(do-my-work)

(thesis-slide)
