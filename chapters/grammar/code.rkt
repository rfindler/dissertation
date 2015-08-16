#lang racket

(require "../common.rkt"
         "../code-utils.rkt")

(provide (all-defined-out))

(define examples-stxobjs (read-stxobjs (build-path common-path "grammar" "examples.rkt")))

(define generate-arith-stxobj
  (extract-def examples-stxobjs
               `(define (generate-arith ,params ...)
                 ,rest ...)))

(define arith-enum-stxobj
  (extract-def examples-stxobjs
               `(define arith-e-enum
                 ,rest ...)))
