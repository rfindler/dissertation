#lang racket

(require pict
         pict/code
         "../common.rkt"
         "intro-typesetting.rkt")

(provide (all-defined-out))

(define stlc-rel-path-string
   (path->string
    (find-relative-path (current-directory)
                        (simplify-path (build-path common-path 'up "model" "stlc.rkt")))))

(define stlc-stxobjs
   (parameterize ([port-count-lines-enabled #t])
     (call-with-input-file (build-path common-path 'up "model" "stlc.rkt")
       (λ (in)
         (read-line in)
         (let loop ([ds '()])
           (define next (read-syntax in in))
           (if (eof-object? next)
               ds
               (loop (cons next ds))))))))

(define-syntax-rule (extract-def the-match)
  (findf (λ (stx)
           (match (syntax->datum stx)
             [the-match #t]
             [_ #f]))
         stlc-stxobjs))

(define lang-stxobj
   (extract-def `(define-language STLC-min ,stuff ...)))

(define red-stxobj
   (extract-def `(define STLC-red-one (reduction-relation ,stuff ...))))

(define type-stxobj
   (extract-def `(define-judgment-form
                  STLC
                  #:mode (tc ,modes ...)
                  ,cases ...)))

(define lookup-stxobj
   (extract-def `(define-metafunction
                  STLC
                  [(lookup ,rhs ...) ,lhs ...] ...)))

(define (grammar-side-by-side-pict)
  (hb-append 20
   (code #,lang-stxobj)
   (full-exp-pict)))