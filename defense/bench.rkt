#lang racket

(require slideshow
         pict
         pict/code
         "settings.rkt"
         "common.rkt"
         "models.rkt")

(provide do-benchmark)

(define-syntax-rule (code-emph cd)
  (let ([cd-pict (code cd)])
    (refocus
     (cc-superimpose
      (cellophane
       (colorize
        (filled-rounded-rectangle
         (pict-width cd-pict)
         (pict-height cd-pict)
         -0.2)
        colors:emph-dull)
       0.5)
      cd-pict)
     cd-pict)))
   

(define ok
  (s-frame
  (code (define-metafunction poly-stlc 
          const-type : c -> Σ
          ...
          [(const-type cons)
           (∀ a (a → ((list a) → #,(code-emph (list a)))))]
          ...))))

(define buggy
  (s-frame
  (code (define-metafunction poly-stlc 
          const-type : c -> Σ
          ...
          [(const-type cons)
           (∀ a (a → ((list a) → #,(code-emph a))))]
          ...))))

(define buggy-2 
  (s-frame
   (code (define-language stlc
           (M N ::= 
              (λ (x σ) M)
              ...)
           ...
           (v (λ (x τ) M)
              ...)
           (E hole
              (E M))))))

(define ok-2 
  (s-frame
   (code (define-language stlc
           (M N ::= 
              (λ (x σ) M)
              ...)
           ...
           (v (λ (x τ) M)
              ...)
           (E hole
              #,(code-emph (E M))
              (v E)))
         )))

(define ok-3
  (s-frame
   (code (define-metafunction stlc
           subst : M x M -> M
           ...
           [(subst (M N) x M_x)
            ((subst M x M_x) (subst N x #,(code-emph M_x)))]
           ...))))

(define buggy-3
  (s-frame
   (code (define-metafunction stlc
           subst : M x M -> M
           ...
           [(subst (M N) x M_x)
            ((subst M x M_x) (subst N x #,(code-emph M)))]
           ...))))

(define ok-4
  (s-frame
   (code (define-judgment-form let-poly
           ...
           [(where N_2 (subst N x #,(code-emph v)))
            (code:comment "y is a fresh variable")
            (tc-down Γ ((λ y N_2) v) κ σ_2)
            ---------------------------------
            (tc-down Γ (let ([x v]) N) κ σ_2)]
           ...
           #,(code-emph [(where #t (not-v? M))
            (tc-down Γ ((λ x N) M) κ σ_2)
            ---------------------------------
            (tc-down Γ (let ([x M]) N) κ σ_2)])
           ...))))

(define buggy-4
  (s-frame
   (code (define-judgment-form let-poly
           [(where N_2 (subst N x #,(code-emph M)))
            (code:comment "y is a fresh variable")
            (tc-down Γ ((λ y N_2) M) κ σ_2)
            ---------------------------------
            (tc-down Γ (let ([x M]) N) κ σ_2)]))))
         
(define bench-title "Automated testing benchmark")

(define (do-benchmark)
  
  (slide 
   #:title bench-title 
   (item-frame
    "8 Redex models"
    "50 bugs"
    "4 generation strategies"
    "193 bug/strategy instances")
   (let ([txt (scale (vc-append (t "Metric:")
                                (t"Seconds per counterexample")) 1.25)])
     (cc-superimpose
      (colorize
       (filled-rounded-rectangle (* (pict-width txt) 1.25) (* (pict-height txt) 1.25)
                                 -1)
       colors:note-color)
      txt)))

  (models-table)
  
  (slide
   #:title bench-title
   (scale-to-fit
    (hc-append 40
            ok
            (hc-append
             (arrow 30 pi)
             (arrow 30 0))
            buggy)
    client-w client-h)
   (t "")
   (t "Example of a bug")
   (t "(poly-stlc-4.rkt)"))
  
  
  (slide
   #:title bench-title
   (scale-to-fit
    (hc-append 40
               ok-3
               (hc-append
                (arrow 30 pi)
                (arrow 30 0))
               buggy-3)
    client-w client-h)
   (t "")
   (t "Another bug")
   (t "(stlc-sub-3.rkt)"))

  
  (slide
   #:title bench-title
   (scale-to-fit
    (hc-append 40
               ok-2
               (hc-append
                (arrow 30 pi)
                (arrow 30 0))
               buggy-2)
    client-w client-h)
   (t "")
   (t "Yet another bug")
   (t "(stlc-7.rkt)"))

  (slide
   #:title bench-title
   (scale-to-fit
    (hc-append 40
               ok-4
               (hc-append
                (arrow 30 pi)
                (arrow 30 0))
               buggy-4)
    client-w client-h)
   (t "")
   (t "A deep bug")
   (t "(let-poly-2.rkt)")))
