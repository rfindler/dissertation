#lang racket

(require racket/runtime-path
         redex/pict
         scribble/core
         scribble/decode
         "related-work/citations.rkt")

(provide abstract
         common-path
         (all-from-out "related-work/citations.rkt"))

(define-runtime-path common-path ".")

;; redex font params
(default-font-size 15)
(metafunction-font-size 15)
(default-font-size 15)
(label-font-size 15)
(metafunction-up/down-indent 10)

(define (abstract . text)
  (make-element "abstract" (decode-content text)))

