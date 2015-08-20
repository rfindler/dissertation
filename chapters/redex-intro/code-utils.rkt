#lang racket

(require pict
         pict/code
         "../code-utils.rkt"
         "../common.rkt"
         "intro-typesetting.rkt")

(provide (all-defined-out))

(define stlc-rel-path-string
   (path->string
    (find-relative-path (current-directory)
                        (simplify-path (build-path common-path 'up "model" "stlc.rkt")))))

(define stlc-stxobjs (read-stxobjs (build-path common-path 'up "model" "stlc.rkt")))

(define lang-stxobj
   (extract-def stlc-stxobjs
                `(define-language STLC-min ,stuff ...)))

(define red-stxobj
   (extract-def stlc-stxobjs
                `(define STLC-red-one (reduction-relation ,stuff ...))))

(define type-stxobj
   (extract-def stlc-stxobjs
                `(define-judgment-form
                  STLC
                  #:mode (tc ,modes ...)
                  ,cases ...)))

(define lookup-stxobj
   (extract-def stlc-stxobjs
                `(define-metafunction
                  STLC
                  [(lookup ,rhs ...) ,lhs ...] ...)))

(define (grammar-side-by-side-pict)
  (hb-append 20
   (code #,lang-stxobj)
   (full-exp-pict)))

(define (reduction-types-pict)
  (ht-append 40
             (code #,red-stxobj)
             (code #,type-stxobj)))

(define eval-stxobj
  (extract-def stlc-stxobjs
                `(define-metafunction
                  STLC
                  Eval ,rest ...)))

(define sumto-stxobj
  (extract-def stlc-stxobjs
                `(define (sumto n) ,rest ...)))

(define check-pp-stxobj
  (extract-def stlc-stxobjs
               `(define (check-progress/preservation ,args ...)
                  ,body ...)))