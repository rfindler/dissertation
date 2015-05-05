#lang slideshow

(require unstable/gui/pict
         "common.rkt"
         "settings.rkt"
         "venn.rkt"
         "table.rkt"
         "four-plot.rkt"
         "misc.rkt"
         "explain-sem.rkt"
         "related-work.rkt")

(slide #:title "Thesis"
       (s-frame (t/n thesis)))

(show-venn)

(do-lse-tree)

(do-quadrants)

(constructs-table)

(do-related-work)

(contents-table)

(do-my-work)
