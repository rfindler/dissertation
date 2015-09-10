#lang racket

(require redex
         slideshow)

(provide Λ lambda-lang-pict
         e-pict)

(default-font-size (current-font-size))

;SNIP<LANG>
(define-language Λ
  (e ::= (e e)
         (λ (x) e)
         (if0 e e e)
         x n)
  (x ::= variable)
  (n ::= number))
;SNIP<LANG>

(define lambda-lang-pict (language->pict Λ))

(define e-pict (language->pict Λ #:nts '(e)))
