#lang racket/base

(require slideshow
         redex/reduction-semantics
         redex/pict
         images/logos
         "common.rkt"
         "settings.rkt"
         "fades.rkt")

(provide title)

(define pltlogo (bitmap (plt-logo)))

(define background
  (cellophane (colorize
               (filled-rectangle client-w client-h)
               colors:note-color)
              0.4))
   
(define (tw str)
  (colorize (t str) "white"))

(define (title)
  (define title 
    (vc-append 15
     (parameterize ([current-font-size
                      (* (current-font-size) 7/4)])
       (t/n "Automated Testing\nfor Lightweight Semantics" #:v-combine vc-append))))
  (define title-info
    (vc-append 40
               title
               (vc-append 5 
                          (t "Burke Fetscher")
                          (t "Northwestern University EECS"))))
  (define nulogo (scale (bitmap "nulogo3.png")
                             0.2))
  (slide (lb-superimpose
          (rb-superimpose
          (cc-superimpose (scale-to-fit background
                                        client-w
                                        client-h)
                          title-info)
          (faded-fade nulogo
                      #:color "white"
                      #:init 0.01
                      #:circle? #t
                      #:grads 120
                      #:delta 2))
          (faded-fade (scale-to-fit pltlogo
                                    (pict-width nulogo)
                                    (pict-height nulogo))
                      #:color "white"
                      #:init 0.01
                      #:circle? #t
                      #:grads 120
                      #:delta 2))))

