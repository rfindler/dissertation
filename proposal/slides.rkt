#lang slideshow

(require unstable/gui/pict
         "common.rkt"
         "settings.rkt"
         "venn.rkt"
         "table.rkt"
         "four-plot.rkt")

(slide #:title "Thesis"
       (s-frame (t/n thesis)))

(show-venn)

(do-quadrants)

(constructs-table)

(contents-table)
