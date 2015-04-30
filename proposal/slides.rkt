#lang slideshow

(require unstable/gui/pict
         "common.rkt"
         "settings.rkt"
         "venn.rkt"
         "table.rkt")

(slide #:title "Thesis"
       (s-frame (t/n thesis)))

(show-venn)

(constructs-table)

(contents-table)
