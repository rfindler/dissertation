#lang racket

(require redex/pict
         scribble/core
         scribble/decode)

(provide with-font-params
         text-scale
         abstract)

(define (text-scale p)
  (with-font-params p))

(define-syntax-rule
  (with-font-params e1 e2 ...)
  (parameterize (#;[default-font-size 12]
                 #;[metafunction-font-size 12]
                 #;[default-font-size 12]
                 #;[label-font-size 12]
                 #;[metafunction-up/down-indent 10])
    e1 e2 ...))

[default-font-size 15]
[metafunction-font-size 15]
[default-font-size 15]
[label-font-size 15]
[metafunction-up/down-indent 10]

(define (abstract . text)
  (make-element "abstract" (decode-content text)))

