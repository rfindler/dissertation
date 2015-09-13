#lang slideshow

(require slideshow/play
         pict/balloon
         "plot-lines.rkt"
         "fades.rkt"
         ;(only-in "redex-typeset.rkt" freeze)
         (only-in plot plot-font-face plot-font-family))

(provide do-eval)


(define (fade-out p)
  (cc-superimpose
   p
   (cellophane
    (colorize
     (filled-rectangle (pict-width p) (pict-height p))
     "white")
    0.6)))

(define lp-pict (scale-to-fit line-plot-pict
                               (- client-w margin margin)
                              (- client-h margin margin)))

(define enum-pict
  (scale-to-fit enum-plot-pict 
                       (- client-w margin margin)
                       (- client-h margin margin)))

(define lp-pict-2
  (pin-over
   ;(fade-out lp-pict)
   lp-pict
   (/ (pict-width lp-pict) 10)
   (/ (pict-height lp-pict) 3)
   (faded-fade
    (scale (hc-append 20
                      (arrow 50 pi)
                      (vl-append (t "7 Redex models")
                                 (t "43 bugs")))
           2)
    #:color "white"
    #:init 0.05
    #:delta 2
    #:grads 50)))


(define palka-pict (bitmap "palka-etal.png"))

(define (do-eval)
  
  (slide #:title "Grammar-based generation approaches"
         enum-pict)
  
  (slide #:title "Grammar-based generation approaches"
         (cb-superimpose
          enum-pict
          (faded-fade
           (vc-append
            (scale 
             (hc-append 10
                        (hbl-append
                         (t "10")
                         (parameterize ([current-main-font
                                         (cons 'superscript
                                               (current-main-font))])
                           (t "-1")))
                        (scale (hc-append (arrow 20 pi) (arrow 20 0)) 7 2)
                        (hbl-append
                         (t "10")
                         (parameterize ([current-main-font
                                         (cons 'superscript
                                               (current-main-font))])
                           (t "4")) ))
             2)
            (blank 0 (/ (pict-height enum-pict) 10)))
           #:color "white"
           #:init 0.05
           #:delta 2
           #:grads 50)))
  
  (define comp-title "All generators, testing performance")
         
  (slide #:title comp-title
         lp-pict)
  
  (for ([p (in-list line-plot-picts-with-intervals)])
    (slide #:title comp-title
           (scale-to-fit p
                         (- client-w margin margin)
                         (- client-h margin margin)))))
