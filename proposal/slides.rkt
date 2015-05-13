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
         "intro.rkt")


(define (thesis-slide)
  (slide #:title "Thesis"
         (s-frame (t/n thesis))))

(title)

(thesis-slide)

(do-lse-tree)

(show-venn)

(do-quadrants)

(do-related-work)

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
