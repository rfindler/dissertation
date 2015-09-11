#lang racket/base
(require racket/pretty
         redex/reduction-semantics
         racket/runtime-path
         "stlc.rkt")

(define-runtime-path examples.rktd "examples.rktd")

(define howmany-examples 1000)
(define examples-size 4)

(define (gen-some f . args)
  (for/list ([i (in-range howmany-examples)])
    (when (zero? (modulo i 100))
      (printf ".") (flush-output))
    (define an-e (apply f args))
    (list an-e 
          (and an-e (typeof an-e) #t)
          (and an-e (type-preserved? an-e)))))

(define jf-based
  (gen-some (compose (λ (x) (and x (list-ref x 2)))
                     (generate-term STLC #:satisfying (tc • e τ)))
            examples-size))
(newline)
(define grammar-based
  (gen-some (generate-term STLC e) examples-size))
(newline)

(call-with-output-file examples.rktd
  (λ (port)
    (pretty-write (list jf-based grammar-based) port))
  #:exists 'truncate)
