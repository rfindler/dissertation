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
         "testing.rkt")

(slide #:title "Thesis"
       (s-frame (t/n thesis)))

(do-lse-tree)

(show-venn)

(do-quadrants)

(do-redex-comp)

(do-automated-testing)

(constructs-table)

(do-related-work)

(contents-table)

(todo-table)

(do-my-work)
