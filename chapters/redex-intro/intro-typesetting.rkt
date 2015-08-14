#lang racket

(require "../../model/stlc.rkt"
         redex/reduction-semantics
         redex/pict
         pict)

;; Godel brackets on rhs of reduction

(provide (all-defined-out)
         eval-pict
         stlc-type-pict-horiz)

(define-syntax-rule (et t)
  (render-term STLC t))

(define (exp-pict)
  (with-rewriters
   (language->pict STLC-min #:nts '(e x o n))))

(define (full-exp-pict)
  (with-rewriters
   (language->pict STLC-min)))

(define (v-pict)
  (with-rewriters
   (language->pict STLC #:nts '(v))))

(define (plus-pict)
  (parameterize ([render-reduction-relation-rules '(δ)])
    (with-compound-rewriters
     (['o o-rewriter])
     (with-rewriters
      (reduction-relation->pict STLC-red-one)))))

(define (make-red-example t)
  (define t2 (car (apply-reduction-relation STLC-red-one t)))
  (with-rewriters
   (hbl-append 5
               (term->pict/pretty-write STLC t)
               (arrow->pict '-->)
               (term->pict/pretty-write STLC t2))))

(define (plus-example)
   (make-red-example (term (+ 1 2))))

(define (beta-pict)
  (parameterize ([render-reduction-relation-rules '(β)])
    (with-rewriters
     (reduction-relation->pict STLC-red-one))))

(define (beta-example)
  (make-red-example (term ((λ [x num] (+ 1 x)) 2))))

(define (red-one-pict)
  (with-compound-rewriters
   (['o o-rewriter])
   (with-rewriters
    (reduction-relation->pict STLC-red-one))))

(define (context-pict)
  (with-rewriters
   (language->pict STLC #:nts '(E))))

(define (context-closure-pict)
  (with-rewriters
   (judgment-form->pict ==>a)))

(define (subst-in-e-pict)
  (hbl-append 1
   (term->pict STLC e)
   (term->pict STLC |{|)
   (term->pict STLC x)
   (term->pict STLC | ← |)
   (term->pict STLC v)
   (term->pict STLC |}|)))

(define stuck1
  (term (7 11)))

(define (stuck1-pict)
  (term->pict STLC ,stuck1))

(define stuck2
  (term ((if0 (+ 0 0) 7 (λ [x num] 7))
         ((λ [x num] x) 11))))

(define (stuck2-pict)
  (term->pict STLC ,stuck2))

(define not-stuck
  (term ((if0 (+ 0 0) (λ [x num] 7) 7)
         ((λ [x num] x) 11))))

(define not-stuck-typed
  (term ((if0 (+ 0 0) (λ [x num] 7) (λ [x num] 8))
         ((λ [x num] x) 11))))

(define (not-stuck-pict)
  (term->pict STLC ,not-stuck))

(define (not-stuck-typed-pict)
  (term->pict STLC ,not-stuck-typed))

(define (std-red-arrow)
  (arrow->pict ':-->))

(define (std-refl-trans)
  (hbl-append (std-red-arrow)
              (parameterize ([literal-style (non-terminal-style)])
                (render-term STLC *))))

(define (τ-pict)
  (language->pict STLC-min #:nts '(τ)))

(define (binop-rule)
  (parameterize ([judgment-form-cases '(6)])
    (with-rewriters (judgment-form->pict tc))))

(define (Γ-pict)
  (language->pict STLC #:nts '(Γ)))

(define (abstraction-rule)
  (parameterize ([judgment-form-cases '(2)])
    (with-rewriters (judgment-form->pict tc))))

(define (is-typed-pict)
  (with-rewriters
   (term->pict STLC (tc • e τ))))