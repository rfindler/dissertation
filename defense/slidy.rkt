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
         "fades.rkt"
         "pb-pict.rkt")

(provide do-slidy)

(define (do-slidy)
  
  (get-zoomy)
  
  (sliding-grammar)
  
  (grammar-overview)
  
  (get-zoomy-again)
  
  (sliding-jf)
  
  (jf-overview))

(printf "slidy done\n")
