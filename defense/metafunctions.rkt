#lang slideshow

(require "metafunc-example.rkt"
         "common.rkt"
         "settings.rkt"
         "related-work.rkt"
         redex/pict
         (only-in "../model/pats.rkt" pats base-pats)
         (only-in "redex-typeset.rkt" add-white))

(provide eq-pict
         dq-pict
         do-mf-slides)

(define p-pict
  (with-atomic-rewriter
   'number "Constant"
   (with-atomic-rewriter
    'variable-not-otherwise-mentioned "Variable"
    (language->pict base-pats
                    #:nts '(p m x)))))

(define eq-pict (hbl-append (term->pict pats p)
                            (term->pict pats | = |)
                            (term->pict pats p)))

(define dq-pict (hbl-append (term->pict pats ∀)
                            (term->pict pats x)
                            (term->pict pats |..., |)
                            (term->pict pats p)
                            (term->pict pats | ≠ |)
                            (term->pict pats p)))

(define p-ghost (ghost p-pict))



(define cl-refs
  (vr-append 
   (t "Simplify/solve:")
   (t "[Colmerauer 1984]")
   (t "[Comon & Lescanne 1989]")))

(define (cl-pict [show-dq? #f])
  (define dq-mod (if show-dq? identity ghost))
  (vc-append 10 (vc-append (scale eq-pict (* 3 1.25))
                           (dq-mod (scale dq-pict (* 3 1.25))))
             (hbl-append 40 (scale p-pict 3)
                        (dq-mod cl-refs))))

(define cl0-pict (cl-pict))
(define cl1-pict (cl-pict #t))


(define (cstr-title p)
  (vc-append 20
             (scale (t "Constraints:") 1.5)
             p))

(define gcl (ghost cl-refs))

(define example-seq
  (list
   (layout-func-example (add-anchor (blank 1 1)))
   (layout-func-example (make-f-jdg))
   (layout-func-example (make-f-jdg #:mark 'red))
   (layout-func-example (add-sandwich f-bad-1 (make-f-jdg #:mark 'red)))
   (layout-func-example (make-f-jdg #t))
   (layout-func-example (make-f-jdg #t #:mark 'red))
   (layout-func-example (add-sandwich f-bad-2 (make-f-jdg #t #:mark 'red)))
   (layout-func-example (make-f-jdg #f #t))
   (layout-func-example (make-f-jdg #f #t #:mark 'blue))))

(define (do-mf-slides)
  
  (slide
   (cstr-title
    cl0-pict))
  
  (slide
   (cstr-title
    (pin-over
     (cl-pict)
     cl-refs
     lt-find
     (refocus (lt-superimpose
               gcl (add-white
                    (parameterize ([current-main-font font:base-font])
                      (colorize (scale
                                 (vl-append
                                  (t "Not enough to")
                                  (t "handle functions..."))
                                 1.5)
                                "red"))
                    1))
              gcl))))

  (map slide example-seq)
  
  (slide
   (cstr-title
    cl1-pict)))

