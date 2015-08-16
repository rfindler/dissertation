#lang racket

(require "../code-utils.rkt")

(define examples-stxobjs (read-stxobjs "examples.rkt"))

(define generate-arith-stxobj
  (extract-def examples-stxobjs
               `(define (generate-arith ,params ...)
                 ,rest ...)))

(define arith-enum-stxobj
  (extract-def examples-stxobjs
               `(define arith-e-enum
                 ,rest ...)))
