#lang racket/base

(require slideshow
         unstable/gui/pict
         "settings.rkt")

(provide thesis
         current-background
         default-background
         make-slide-assembler
         t/n
         s-frame)

(define thesis
  "Automated property-based testing is
effective tool support for lightweight 
semantics engineering.")
(define current-background (make-parameter #f))

(define (default-background width height)
  (color colors:slide-background
         (filled-rectangle width height)))

(define (make-slide-assembler default-assembler)
  (lambda (title title-sep content)
    (define sld (default-assembler title title-sep content))
    (ct-superimpose ((current-background) (pict-width sld) (pict-height sld)) sld)))

(current-slide-assembler (make-slide-assembler (current-slide-assembler)))

(current-main-font font:main-font)

(current-background default-background)

(current-title-color colors:title-color)

(define (t/n str #:v-combine [v-comb vl-append])
  (apply v-comb
         (for/list ([s (in-list (string-split str "\n"))])
           (t s))))

(define-syntax-rule (s-frame p ...)
  (shadow-frame p ...
                #:background-color colors:note-color
                #:frame-color colors:shadow
                #:frame-line-width 2))

