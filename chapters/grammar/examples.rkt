#lang racket

(require redex/reduction-semantics
         redex/pict
         data/enumerate
         data/enumerate/lib)

(define-language arith
  (e ::= (o e e)
        n)
  (o ::= + - * /)
  (n ::= number))

(define (arith-pict)
  (language->pict arith))

(define (generate-arith non-terminal fuel)
  (define next-fuel (- fuel 1))
  (case non-terminal
    [(e)
     ;; only choose the recursive production if
     ;; there is fuel
     (define choice (if (> fuel 0) (random 2) 1))
     (if (= choice 0)
         (list (generate-arith 'o next-fuel)
               (generate-arith 'e next-fuel)
               (generate-arith 'e next-fuel))
         (generate-arith 'n next-fuel))]
    [(o)
     (list-ref '(+ - * /) (random 4))]
    [(n)
     (random 100)]))

(define arith-e-enum
  (letrec ([e/e (delay/e 
                 (or/e n/e
                       (list/e o/e e/e e/e)))]
           [o/e (fin/e '+ '- '* '/)]
           [n/e (below/e 100)])
    e/e))
