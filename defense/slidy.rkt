#lang racket/base
(require (except-in slideshow freeze)
         redex/reduction-semantics
         redex/pict
         images/logos
         "stlc.rkt"
         "stlc-picts.rkt"
         "redex-typeset.rkt"
         "sliding-terms.rkt"
         "overview-slides.rkt"
         "layout.rkt"
         "examples.rkt"
         "fades.rkt")

(provide do-slidy)

(define tree (bitmap "snowflakes.jpg"))
(define pltlogo (bitmap (plt-logo)))

(define background
  (cellophane (colorize
               (filled-rectangle client-w client-h)
               "teal")
              0.4))
   
(define (tw str)
  (colorize (t str) "white"))

(define (title)
  (define authors
    (vc-append 10
               (vc-append
               (hbl-append 30
                           (t "Burke Fetscher")
                           (t "Robby Findler"))
               (t "Northwestern University"))
               (vc-append
               (hbl-append 30
                           (t "Michał Pałka")
                           (t "Koen Claessen")
                           (t "John Hughes"))
               (t "Chalmers University"))))
  (define title 
    (vc-append
     (parameterize ([current-font-size
                      (* (current-font-size) 7/4)])
       (t "Making Random Judgments"))
     (parameterize ([current-font-size (* (current-font-size) 5/4)])
       (vc-append
        (t "Automatically Generating Well-Typed Terms from ")
        (t "the Definition of a Type-System")))))
  (define title-info
    (vc-append 40
               title
               authors))
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
                      #:init 0.025
                      #:circle? #t
                      #:grads 60
                      #:delta 2))
          (faded-fade (scale-to-fit pltlogo
                                    (pict-width nulogo)
                                    (pict-height nulogo))
                      #:color "white"
                      #:init 0.025
                      #:circle? #t
                      #:grads 60
                      #:delta 2))))

(define (title2)
  (define name
    (scale
     (vc-append
      (t "Burke Fetscher")
      (t "Northwestern University"))
     (/ 3 4)))
  (define title 
    (vc-append (scale (t "Generating Random Well-typed Terms") 1.25)
               (t "Push-button tests for operational semantics")))
  (define title-info
    (vc-append
     (vc-append 20 
                title
                (ghost name)
                (ghost name)
                name)))
  (define nulogo (scale (bitmap "nulogo3.png")
                             0.2))
  (slide (lb-superimpose
          (rb-superimpose
           (cc-superimpose
            title-info
            (ghost (rectangle client-w client-h)))
          nulogo)
          (scale-to-fit pltlogo
                        (pict-width nulogo)
                        (pict-height nulogo)))))

(define (do-slidy)
  (get-zoomy)
  
  (sliding-grammar)
  
  (grammar-overview)
  
  (get-zoomy-again)
  
  (sliding-jf)
  
  (jf-overview))

(printf "slidy done\n")
