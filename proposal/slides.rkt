#lang slideshow

(require unstable/gui/pict
         "common.rkt"
         "settings.rkt")

(slide #:title "Thesis"
       (shadow-frame (t/n thesis)
                     #:background-color colors:note-color
                     #:frame-color colors:shadow
                     #:frame-line-width 2))
