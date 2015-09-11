#lang racket/base

(require "common.rkt"
         "settings.rkt"
         racket/runtime-path
         racket/contract
         slideshow)

;; re-run gen-examples.rkt to get new examples
;; (needed after changing the stlc model)
(define-runtime-path examples.rktd "examples.rktd")

(define-values (jf-based grammar-based)
  (call-with-input-file examples.rktd
    (λ (port)
      (apply values (read port)))))

(define line/c
  (list/c any/c       ;; example term
          boolean?    ;; did it type check?
          boolean?))  ;; did it find a bug?

(define examples/c (listof line/c))

(provide
 (contract-out
  [jf-based examples/c]
  [grammar-based examples/c])
 red-mark
 blu-mark
 grn-mark)

(define dots? (make-parameter #f))

(define (mk-dot shape color)
    (define letter (tt "x"))
    (colorize (shape (pict-width letter) (pict-height letter))
              color))
(define red-dot (mk-dot filled-ellipse "red"))
(define blu-dot (mk-dot filled-rectangle "blue"))
(define grn-dot (mk-dot filled-rectangle "forestgreen"))

(define the-void (ghost (tt "x")))


(define (mk-mark char color)
  (parameterize ([current-main-font font:base-font])
    (define letter (tt "x"))
    (define gletter (lbl-superimpose (ghost letter) 
                                     (blank (pict-height letter) 0)))
    (colorize (refocus (lbl-superimpose gletter (t char)) gletter)
              color)))

(define red-mark (mk-mark "✘" "red"))
(define blu-mark (mk-mark "✔" "blue"))
(define grn-mark (mk-mark "✔" "forestgreen"))


(define (blu-thing)
  (if (dots?) blu-dot blu-mark))

(define (red-thing)
  (if (dots?) red-dot red-mark))

(define (grn-thing)
  (if (dots?) grn-dot grn-mark))


(provide
 (contract-out 
  [line->dots (-> line/c exact-nonnegative-integer? pict?)])
 dots?)

(define (line->dots line spacing)
  (hc-append spacing
             (if (list-ref line 1) (blu-thing) (red-thing))
             (if (list-ref line 1)
                 (if (list-ref line 2) (red-thing) (grn-thing))
                 the-void)))
   