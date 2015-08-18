#lang racket
(require redex
         pict
         "clp.rkt"
         "pats.rkt"
         "program.rkt")

(provide awkward-e-or-o
         awkward-e-or-o-rw
         state->C
         state->a
         awk-P-pict
         lang-mf-pict
         eo-jdg-pict
         lt)

;; This is the Redex code for the example below:
(define-language L
  (n ::= (s n)
         z)
  (b ::= even odd))

(define-syntax-rule (lt t)
  (render-term L t))

(define-metafunction L
  e/o : n -> even or odd
  [(e/o z) even]
  [(e/o (s (s n))) (e/o n)]
  [(e/o n) odd])

(define (L-pict)
  (language->pict L))

(define (e/o-pict)
  (metafunction->pict e/o))

(define (lang-mf-pict)
  (ht-append 60
             (L-pict)
             (e/o-pict)))

(module+ test
  (test-equal (term (e/o z)) (term even))
  (test-equal (term (e/o (s z))) (term odd))
  (test-equal (term (e/o (s (s z)))) (term even))
  (test-equal (term (e/o (s (s (s z))))) (term odd)))

(define-judgment-form L
  #:mode (odd? I)
  [(where odd (e/o n))
   --------
   (odd? n)])

(module+ test
  (test-equal (judgment-holds (odd? z)) #f)
  (test-equal (judgment-holds (odd? (s z))) #t)
  (test-equal (judgment-holds (odd? (s (s z)))) #f)
  (test-equal (judgment-holds (odd? (s (s (s z))))) #t))

(define (to-nat n)
  (match n
    [`z 0]
    [`(s ,n) (+ 1 (to-nat n))]))

(module+ test
  (define ht (make-hash))
  (for ([x (in-range 100)])
    (define candidate (generate-term L #:satisfying (odd? n) 5))
    (define n (and candidate (to-nat (cadr candidate))))
    (hash-set! ht n (+ 1 (hash-ref ht n 0))))
  
  #;
  (printf "found: ~s\n" ht))

;; where we use this to translate into the model:
;;   0 = z
;;   1 = s
;;   2 = even
;;   3 = odd
;;   (even (lst <bool> <nat>)) is the shape of 'even'

; We can translate the above metafunction (e/o) into the model as follows:
; (compile-M in models/program.rkt has the formal definiton of the translation)
(define awkward-e-or-o
  (term (((e-or-o (lst 2 0)) ←)
         ((e-or-o (lst b (lst 1 (lst 1 n)))) ← (e-or-o (lst b n)))
         ((e-or-o (lst 3 n))
          ← 
          (∀ (n_1) (∨ (n ≠ (lst 1 (lst 1 n_1)))))
          (∀ () (∨ (n ≠ 0)))))))

(define awkward-e-or-o-P
  (term (,awkward-e-or-o)))

(define (awk-P-pict)
  (parameterize ([pretty-print-columns 65])
    (term->pict/pretty-write pats/mf
                             (term (rewrite-P ,awkward-e-or-o)))))

(define-union-language pml pats/mf L)

;;just for typesetting
(define-judgment-form pml
  #:mode (eo I I)
  [---------------
   (eo even z)]
  [(eo b n)
   --------------------
   (eo b (s (s n)))]
  [(where/hidden n_1 n)
   (A n ≠ z) (A ∀ (n_1) (n ≠ (s (s n_1))))
   ---------------------------------------
   (eo odd n)])

(define-judgment-form pml
  #:mode (A I I I)
  [(A any any any)])

(define (eo-jdg-pict)
  (with-compound-rewriters
   (['A (match-lambda
          [(list l _ a b c r)
           (list l "" a b c r)])]
    ['eo (match-lambda
           [(list l _ a b r)
            (list l "e-or-o " a b r)])])
   (apply hb-append
          (cons 30
                (for/list ([n 3])
                          (parameterize ([judgment-form-cases (list n)])
                            (judgment-form->pict eo)))))))

; necessary for because some operations in the model, 
; i.e. freshening, are stateful
(caching-enabled? #f)

; initial state, corresponds to the call: (e/o (s (s (s z))))
(define state0
  (term 
   (,awkward-e-or-o-P
    ⊢
    ((e-or-o (lst 3 (lst 1 (lst 1 (lst 1 0))))))
    ∥
    (∧ (∧) (∧)))))

(define-metafunction pats/mf
  rewrite-pattern : p -> any
  [(rewrite-pattern (lst p_1 p_2)) 
   (lst (rewrite-pattern p_1) (rewrite-pattern p_2))]
  [(rewrite-pattern 1) s]
  [(rewrite-pattern 0) z]
  [(rewrite-pattern 2) even]
  [(rewrite-pattern 3) odd]
  [(rewrite-pattern x) x])

(define-metafunction pats/mf
  rewrite-eqn : e -> any
  [(rewrite-eqn (p_1 = p_2))
   ((rewrite-pattern p_1) = (rewrite-pattern p_2))])

(define-metafunction pats/mf
  rewrite-diseqn : δ -> any
  [(rewrite-diseqn (∀ () (∨ (p_1 ≠ p_2))))
   ((rewrite-pattern p_1) ≠ (rewrite-pattern p_2))]
  [(rewrite-diseqn (∀ (x ...) (∨ (p_1 ≠ p_2))))
   (∀ (x ...) ((rewrite-pattern p_1) ≠ (rewrite-pattern p_2)))]
  [(rewrite-diseqn (∀ (x ...) (∨ (p_1 ≠ p_2) ...)))
   (∀ (x ...) (∨ ((rewrite-pattern p_1) ≠ (rewrite-pattern p_2)) ...))])

(define-metafunction pats/mf
  rewrite-C : C -> any
  [(rewrite-C (∧ (∧ e) (∧)))
   (rewrite-eqn e)]
  [(rewrite-C (∧ (∧) (∧ δ)))
   (rewrite-diseqn δ)]
  [(rewrite-C (∧ (∧ e ...) (∧ δ ...)))
   (∧ (rewrite-eqn e) ... (rewrite-diseqn δ) ...)])

(define-metafunction pats/mf
  rewrite-as : (a ...) -> any
  [(rewrite-as ()) ()]
  [(rewrite-as ((d p) a ...))
   ((d (rewrite-pattern p)) any_2 ...)
   (where (any_2 ...) (rewrite-as (a ...)))]
  [(rewrite-as (δ a ...))
   ((rewrite-diseqn δ) any_2 ...)
   (where (any_2 ...) (rewrite-as (a ...)))])

(define-metafunction pats/mf
  rewrite-r : r -> any
  [(rewrite-r ((d p) ← a ...))
   ((d (rewrite-pattern p)) ← any_r ...)
   (where (any_r ...) (rewrite-as (a ...)))])

(define-metafunction pats/mf
  rewrite-P : ((a_0 ← a_1 ...) ...) -> any
  [(rewrite-P ((a_0 ← a_1 ...) ...))
   ((any_2 ← any_3 ...) ...)
   (where (any_2 ...) (rewrite-as (a_0 ...)))
   (where ((any_3 ...) ...) ((rewrite-as (a_1 ...)) ...))])
  
(define (state->C state) (term (rewrite-C ,(list-ref state 4))))
(define (state->a state) (term (rewrite-as ,(list-ref state 2))))

(define awkward-e-or-o-rw
  (redex-let pats/mf 
             ([(r ...) awkward-e-or-o])
             (term ((rewrite-r r) ...))))


(define (reduction-pretty-printer v port width text)
  (default-pretty-printer
    (match v
      [`(,program ⊢ ,gs ∥ ,cstrs)
       `(P ⊢ ,(term (rewrite-as ,gs)) ∥ ,(term (rewrite-C ,cstrs)))]
      [else (error 'reduction-pretty-printer "bad reductions state: ~s" v)])
    port width text))

(module+ main
  ; build a reduction graph for state0
  (parameterize ([pretty-print-parameters
                  (λ (p)
                    (parameterize ([pretty-print-columns 45])
                      (p)))])
    (traces R state0
            #:pp reduction-pretty-printer)))

