#lang racket

(require (except-in slideshow freeze)
         (only-in "cmp-eval.rkt" make-eval-pict)
         (only-in "plot-lines.rkt" line-plot-pict)
         (only-in "redex-typeset.rkt" my-freeze)
         "fades.rkt")

(provide do-conc-slides)

(define ep (make-eval-pict (t "Much better")
                           (t "Worse")
                           #:with-title? #f))

(define f-ep (my-freeze ep 0 0 0 0))

(define (with-vline p)
  (hc-append
   (colorize (linewidth 3 (vline 30 (- (pict-height p) 10)))
             "lightgray")
             p))


(define (do-conc-slides)
  (slide #:title "Derivation Generator Performance"
         (scale-to-fit ep titleless-page))

  (slide (scale-to-fit
          (vc-append 20
           (cc-superimpose
            line-plot-pict
            (ghost (faded-fade (scale (t "Thanks!") 1.5)
                        #:color "white"
                        #:init 0.125
                        #:delta 2
                        #:grads 75)))
           (t "Automated testing for semantics works"))
          titleless-page))

  (slide (scale-to-fit
          (vc-append 20
           (cc-superimpose
            line-plot-pict
            (faded-fade (scale (t "Thanks!") 1.5)
                        #:color "white"
                        #:init 0.125
                        #:delta 2
                        #:grads 75))
           (t "Automated testing for semantics works"))
          titleless-page)))