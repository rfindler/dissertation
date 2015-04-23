#lang racket/base

(require slideshow
         unstable/gui/pict
         "settings.rkt")

(provide thesis
         current-background
         default-background
         make-slide-assembler)

(define thesis
  "... automated testing ... lighweight semantics ... ")

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
