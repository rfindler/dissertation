#lang racket

(require "../common.rkt"
         "../code-utils.rkt")

(provide (all-defined-out))

(define examples-rel-path-string
   (path->string
    (find-relative-path (current-directory)
                        (simplify-path (build-path common-path "grammar" "examples.rkt")))))

(define examples-stxobjs (read-stxobjs (build-path common-path "grammar" "examples.rkt")))

(define generate-arith-stxobj
  (extract-def examples-stxobjs
               `(define/contract (generate-arith ,params ...)
                 ,rest ...)))

(define arith-enum-stxobj
  (extract-def examples-stxobjs
               `(define arith-e-enum
                 ,rest ...)))
