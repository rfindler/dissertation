#lang racket/base

(require "stlc.rkt"
         redex
         racket/match
         slideshow/pict)

         
(define (tc-rewriter lws)
  (match lws
    [(list _ _ Γ e τ _)
     (list "" Γ " ⊢ " e " : " τ "")]))

(define (lookup-rewriter lws)
  (match lws
    [(list _ _ Γ x _)
     (list "" Γ "(" x ")" "")]))

(define (subst-rewriter lws)
  (match lws
    [(list _ _ e x v _)
     (list "" e "{" x " ← " v "}" "")]))

(define (different-rewriter lws)
  (match lws
    [(list _ _ a b _)
     (list "" a " ≠ " b "")]))

(define (sum-rewriter lws)
  (match lws
    [(list _ _ a b _)
     (list "" "\u2308" a " + " b "\u2309")]))

(define (refl-trans-rewriter lws)
  (match lws
    [(list _ _ e_1 e_2 _)
     (list "" e_1 (arrow->pict '-->) "* " e_2 "")]))


(define-syntax-rule (with-rewriters e)
  (with-compound-rewriters
   (['tc tc-rewriter]
    ;['lookup lookup-rewriter]
    ['subst subst-rewriter]
    ['different different-rewriter]
    ['sum sum-rewriter]
    ['refl-trans refl-trans-rewriter])
   e))

(define old-style (rule-pict-style))

(rule-pict-style 'horizontal-side-conditions-same-line)

(define base-lang-pict (render-language STLC-base #:nts '(e τ)))
(define stlc-lang-pict (vl-append base-lang-pict
                        (render-language STLC #:nts '(e v τ E Γ))))
(define stlc-red-pict (with-rewriters
                       (render-reduction-relation STLC-red)))
(define stlc-typing-pict (with-rewriters
                          (render-judgment-form tc)))
(define lookup-pict (with-rewriters
                     (render-metafunction lookup)))
(define eval-pict (parameterize ([metafunction-style 'script]
                                 [metafunction-pict-style
                                  'left-right/beside-side-conditions])
                    (with-rewriters
                     (render-metafunction Eval))))

(define (fade-out p)
  (cc-superimpose p
                  (cellophane 
                   (colorize (filled-rectangle (pict-width p)
                                               (pict-height p))
                             "white")
                   0.25)))

(define (maybe-fade p fade?)
  (if fade?
      (fade-out p)
      p))

(define (maybe-color p color?)
  (define color "forestgreen")
  (hc-append 
   10
   (ghost (disk 1))
   ((if color? values ghost)
    (colorize (disk (/ (pict-height p) 2))
              color))
   (if color?
       (colorize p color)
       p)))

(define (make-big-stlc-pict adj?)
  (vc-append 10
             (hc-append 25
                        (vl-append 10
                                   (maybe-color (text "Grammar" "Menlo, bold") adj?)
                                   (maybe-fade stlc-lang-pict adj?)
                                   (maybe-color (text "Reduction relation" "Menlo, bold") adj?)
                                   (maybe-fade stlc-red-pict adj?)
                                   (maybe-color (text "Metafunctions" "Menlo, bold") adj?)
                                   (maybe-fade lookup-pict adj?))
                        (vl-append 10
                                   (maybe-color (text "Type judgment" "Menlo, bold") adj?)
                                   (maybe-fade stlc-typing-pict adj?)))
             (maybe-color (text "Evaluation" "Menlo, bold") adj?)
             (maybe-fade eval-pict adj?)))

(define (λ-rule)
  (with-rewriters
   (parameterize ([judgment-form-cases '("λ")])
      (render-judgment-form tc))))

(define (app-rule)
  (with-rewriters
   (parameterize ([judgment-form-cases '("app")])
      (render-judgment-form tc))))

(define (types-horizontal)
  (with-rewriters
   (hc-append 40
    (parameterize ([judgment-form-cases '("app")])
      (render-judgment-form tc))
    (parameterize ([judgment-form-cases '("var" "λ")])
      (render-judgment-form tc))
    (render-metafunction lookup))))

(define f-ans-pict
  (let ()
    (define-metafunction L
      [(f 1) 1]
      [(f (1 2)) 2]
      [(f (1 2 3)) 1]
      [(f ((1 2) 3)) 2])
    (render-metafunction f)))

(define f-pict
  (render-metafunction f))
    
(rule-pict-style old-style)

(provide make-big-stlc-pict
         lookup-pict
         f-pict
         f-ans-pict
         types-horizontal
         λ-rule
         app-rule)