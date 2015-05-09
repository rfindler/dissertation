#lang racket

(require slideshow
         pict/code
         "settings.rkt"
         "common.rkt")

(provide do-benchmark)

(define ok
  (s-frame
  (code (define-metafunction poly-stlc 
          const-type : c -> Σ
          ...
          [(const-type cons)
           (∀ a (a → ((list a) → (list a))))]
          ...))))

(define buggy
  (s-frame
  (code (define-metafunction poly-stlc 
          const-type : c -> Σ
          ...
          [(const-type cons)
           (∀ a (a → ((list a) → a)))]
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
                        (E M)
                        (v E)))
                   )))

(define ok-3
  (s-frame
   (code (define-metafunction stlc
          subst : M x M -> M
          ...
          [(subst (M N) x M_x)
           ((subst M x M_x) (subst N x M_x))]
          ...))))

(define buggy-3
  (s-frame
  (code (define-metafunction stlc
          subst : M x M -> M
          ...
          [(subst (M N) x M_x)
           ((subst M x M_x) (subst N x M))]
          ...))))

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
                                (t"How long per counterexample?")) 1.25)])
     (cc-superimpose
      (colorize
       (filled-rounded-rectangle (* (pict-width txt) 1.25) (* (pict-height txt) 1.25)
                                 -1)
       colors:emph-bright)
      txt)))
  
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
   (t "Example of a bug used for mutation testing")
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
   (t "Another bug used for mutation testing")
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
   (t "Another bug used for mutation testing")
   (t "(stlc-7.rkt)")))
