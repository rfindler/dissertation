#lang racket

(require redex/reduction-semantics)

(define-language STLC-base
  (e ::= (λ (x τ) e) 
         (e e) 
         (if0 e e e) 
         (+ e e) 
         x 
         n)
  (τ ::= num 
         (τ → τ))
  (n ::= number)
  (x ::= variable-not-otherwise-mentioned))

(define-extended-language STLC-2 STLC-base
  (v ::= (λ (x τ) e) n)
  (E ::= (E e) (v E) (+ E e) (+ v E) 
         (if0 E e e) hole)
  (Γ ::= (e-cons x τ Γ) •))

(define-extended-language STLC STLC-2
  (v ::= .... BOMB))

(define-judgment-form STLC
  #:mode (tc I I O)
  
  [-------------- num
   (tc Γ n num)]
  
  [(where τ (lookup Γ x))
   ---------------------- var
   (tc Γ x τ)]
  
  [(tc (e-cons x τ_x Γ) e τ_e)
   --------------------------------- λ
   (tc Γ (λ (x τ_x) e) (τ_x → τ_e))]
  
  [(tc Γ e_a (τ_2 → τ)) (tc Γ e_b τ_2)
   ------------------- app
   (tc Γ (e_a e_b) τ)]
  
  [(tc Γ e_a num) (tc Γ e_b τ) (tc Γ e_c τ)
   --------------------------- if0
   (tc Γ (if0 e_a e_b e_c) τ)]
  
  [(tc Γ e_a num) (tc Γ e_b num)
   ----------------------------- plus
   (tc Γ (+ e_a e_b) num)])

(define-metafunction STLC
  lookup : Γ x -> τ or #f
  [(lookup (e-cons x τ Γ) x) τ]
  [(lookup (e-cons x_1 τ Γ) x_2) (lookup Γ x_2)]
  [(lookup • x)  #f])

(define (typeof e)
  (define typ? (judgment-holds (tc • ,e τ) τ))
  (and typ?
       (equal? (length typ?) 1)
       (car typ?)))

(define STLC-red
  (reduction-relation STLC
   (--> (in-hole E ((λ (x τ) e) v))
        (in-hole E (subst e x BOMB))
        βv)
   (--> (in-hole E (if0 0 e_a e_b))
        (in-hole E e_a)
        if-0)
   (--> (in-hole E (if0 n e_a e_b))
        (in-hole E e_b)
        (side-condition (term (different n 0)))
        if-n)
   (--> (in-hole E (+ n_1 n_2))
        (in-hole E (Σ n_1 n_2))
        plus)))

(define-metafunction STLC
  [(Σ n_1 n_2)
   ,(+ (term n_1) (term n_2))])

(define-metafunction STLC
  [(different v v) #f]
  [(different v_1 v_2) #t])

(define-metafunction STLC
  subst : e x v -> e
  [(subst number x v)
   number]
  [(subst (λ (x τ) e) x v)
   (λ (x τ) e)]
  [(subst (λ (x_1 τ) e) x_2 v)
   (λ (x_new τ) (subst (replace e x_1 x_new) x_2 v))
   (where x_new ,(variable-not-in (term (x_1 e x_2))
                                  (term x_1)))]
  [(subst (e_a e_b) x v)
   ((subst e_a x v) (subst e_b x v))]
  [(subst (+ e_a e_b) x v)
   (+ (subst e_a x v) (subst e_b x v))]
  [(subst (if0 e_a e_b e_c) x v)
   (if0 (subst e_a x v) (subst e_b x v) (subst e_c x v))]
  [(subst x x v)
   v]
  [(subst x_1 x_2 v)
   x_1])

(define-metafunction STLC
  [(replace (any_1 ...) x_1 x_new)
   ((replace any_1 x_1 x_new) ...)]
  [(replace x_1 x_1 x_new)
   x_new]
  [(replace any_1 x_1 x_new)
   any_1])

(define-metafunction STLC
  [(Eval e)
   n
   (judgment-holds (refl-trans e n))]
  [(Eval e)
   function
   (judgment-holds (refl-trans e e_2))
   (where (λ (x τ) e_3) e_2)])

(define-judgment-form STLC
  #:mode (refl-trans I O)
  [(refl-trans e_1 e_2)
   (where e_2 ,(car (apply-reduction-relation* 
                     STLC-red
                     (term e_1))))])

(define v? (redex-match? STLC v))

(define (type-preserved? e)
  (define t? (typeof e))
  (or (not t?)
      (let ([res (apply-reduction-relation*  STLC-red e)])
        (and (equal? (length res) 1)
             (v? (car res))
             (equal? t?
                     (typeof (car res)))))))



(define (random-typed-term [depth 5])
  (match
      (generate-term STLC
                     #:satisfying (tc • e τ)
                     depth)
    [#f #f]
    [`(tc • ,e ,τ) e]))




















; traces:
; 0 302 552













(define-language L)

(define-metafunction L
  [(f (any_1 any_2))
   2]
  [(f any)
   1])














(random-seed 7)

(provide (all-defined-out))
