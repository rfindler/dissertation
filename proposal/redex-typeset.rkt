#lang racket
(require ;"util.rkt" 
         "examples/stlc.rkt"
         redex
         slideshow
         slideshow/play
         racket/gui/base)

(provide introduce-calculus
         zoom-grammar-then-bug
         zoom-types
         type-soundness-pict
         grammar-left
         e-strategy
         types-left
         zoom-grammar-then-bug-then-left
         get-zoomy
         get-zoomy-again
         with-rewriters
         freeze
         add-white
         tc-jdg-pict
         e-pict
         t-pict)

(literal-style '(bold . modern))
(paren-style '(bold . modern))
(default-style 'modern) ;; just to space things out a bit more
;(non-terminal-style '(italic . modern))

(define freeze
  (case-lambda
    [(p l t r b)
     (define insetted (inset p l t r b))
     (define bmp (make-bitmap (inexact->exact (ceiling (pict-width insetted)))
                              (inexact->exact (ceiling (pict-height insetted)))))
     (define bdc (make-object bitmap-dc% bmp))
     (send bdc set-smoothing 'aligned)
     (draw-pict insetted bdc 0 0)
     (send bdc set-bitmap #f)
     (inset (bitmap bmp) (- l) (- t) (- r) (- b))]
    [(p) (freeze p 0 0 0 0)]))

(define (tc-rewriter lws)
  (match lws
    [(list _ _ Γ e τ _)
     (list "" Γ " ⊢ " e " : " τ "")]))

(define (lookup-rewriter lws)
  (match lws
    [(list _ _ Γ x _)
     (list (text "lookup" (metafunction-style)
                 (metafunction-font-size))
           (default-white-square-bracket #t)
           Γ "," x
           (default-white-square-bracket #f) "")]))

(define (e-cons-rewriter lws)
  (match lws
    [(list _ _ x τ Γ _)
     (list "{" x ":" τ ", " Γ "}")]))

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

(define bomb-pict
  (let ([x (ghost (term->pict STLC X))]
        [xp (scale (term->pict STLC X) 2)]
        [1p (term->pict STLC 1)])
    1p
    #;
    (refocus
     (cc-superimpose
      x
      1p
      (scale-to-fit
       (bitmap "bomb-256x256.png")
       xp))
     x)))

(define-syntax-rule (with-rewriters e)
  (with-compound-rewriters
   (['tc tc-rewriter]
    ['lookup lookup-rewriter]
    ['subst subst-rewriter]
    ['different different-rewriter]
    ['sum sum-rewriter]
    ['refl-trans refl-trans-rewriter]
    ['e-cons e-cons-rewriter])
   (with-atomic-rewriter 'BOMB
                         (λ () bomb-pict)
                         e)))

(define (render-label str)
  (define normal ((current-text) str (current-main-font) (default-font-size)))
  (define g (ghost normal))
  (refocus (cb-superimpose (vc-append normal (blank 0 6)) g) g))

(define (extract-var x)
  (define s (lw-e x))
  (unless (symbol? s) 
    (error 'extract-var 
           "mon appears to be used with something other than a variable in the label position, got ~s"
           s))
  (symbol->string s))

(define picts-to-zoom (make-hash))

(define-syntax-rule (add-zoomy name pict)
  (let ([p pict])
    (hash-set! picts-to-zoom name p)
    p))

(define old-style (rule-pict-style))

(rule-pict-style 'horizontal-side-conditions-same-line)

(define base-lang-pict 
  (add-zoomy 'base
             (language->pict STLC-base #:nts '(e τ))))
(define stlc-lang-pict
  (vl-append base-lang-pict
             (with-rewriters (language->pict STLC-2 #:nts '(e v τ E Γ)))))
(define stlc-red-pict (with-rewriters
                       (lt-superimpose
                        (ghost
                         (add-zoomy 
                          'beta
                          (parameterize ([render-reduction-relation-rules '(βv)])
                            (reduction-relation->pict STLC-red))))
                        (reduction-relation->pict STLC-red))))
(define stlc-typing-pict 
  (add-zoomy 
   'types
   (with-rewriters
    (judgment-form->pict tc))))

(define tc-jdg-pict (with-rewriters (term->pict STLC (tc • e τ))))
(define e-pict (with-rewriters (term->pict STLC e)))
(define t-pict (with-rewriters (term->pict STLC τ)))

(define lookup-pict (with-rewriters
                     (metafunction->pict lookup)))
(define eval-pict (parameterize ([metafunction-style 'script]
                                 [metafunction-pict-style
                                  'left-right/beside-side-conditions])
                    (with-rewriters
                     (metafunction->pict Eval))))

(define type-soundness-pict
  (let ([space (ghost (term->pict STLC i))])
    (with-rewriters
     (vc-append
      (term->pict STLC (tc • e τ))
      (term->pict STLC ⇒)
      (hbl-append (term->pict STLC e)
                  space
                  (arrow->pict '-->)
                  (text "*" (non-terminal-style))
                  space
                  (term->pict STLC v))))))

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

(define background
  (make-big-stlc-pict #f))

(define (white-bkg p)
  (refocus (cc-superimpose
            (colorize (filled-rectangle (+ (pict-width p) 20)
                                        (+ (pict-height p) 20)
                                        #:draw-border? #f)
                      "white")
            p)
           p))

(define scale-factors 
  (for/hash ([(n i) (in-hash picts-to-zoom)])
    (values n
            (min (/ (- 1024 margin margin)
                    (pict-width i))
                 (/ (- 768 margin margin)
                    (pict-height i))))))

(define half-scale-factors 
  (for/hash ([(n i) (in-hash picts-to-zoom)])
    (values n
            (min
             (/ (- 512 margin margin)
                (pict-width i))
             (/ (- 768 margin margin)
                    (pict-height i))))))

(define (make-dest n sf)
  (scale (ghost (launder (hash-ref picts-to-zoom n)))
         sf))

(define dests (for/hash ([(n i) (in-hash picts-to-zoom)])
                (values n (make-dest n
                                     (hash-ref scale-factors n)))))

(define left-dests (for/hash ([(n i) (in-hash picts-to-zoom)])
                     (values n (make-dest n
                                          (hash-ref half-scale-factors n)))))

(define scaled-bkg
  (scale-to-fit
   background
   (- 1024 margin margin)
   (- 768 margin margin)))

(define frozen-bkg (freeze scaled-bkg 0 0 0 0))
(define base
  (apply 
   lc-superimpose
   (append
    (list
     (apply
      cc-superimpose
      (append
      (list (ghost scaled-bkg))
      (hash-values dests))))
    (hash-values left-dests))))
   
(define (bring-out-and-put-back name n1 _n2)
  (define n2 (fast-end _n2))
  (define rule (hash-ref picts-to-zoom name))
  (define scale-factor (hash-ref scale-factors name))
  (define dest (hash-ref dests name))
  (refocus (cond
             [(or (and (= n1 0) (= n2 0))
                  (and (= n1 1) (= n2 1)))
              (ghost base)]
             [(zero? n2)
              (slide-pict
               (ghost base)
               (add-white (scale rule (+ 1 (* n1 (- scale-factor 1)))) n1)
               rule 
               dest
               n1)]
             [else
              (slide-pict
               (ghost base)
               (add-white (scale rule (+ 1 (* (- 1 n2) (- scale-factor 1)))) 
                          (- 1 n2))
               dest
               rule
               n2)])
           base))

(define (bring-out-and-dont-put-back name n1)
  (define rule (hash-ref picts-to-zoom name))
  (define scale-factor (hash-ref scale-factors name))
  (define dest (hash-ref dests name))
  (refocus (cond
             [(= n1 0)
              (ghost base)]
             [else
              (slide-pict
               (ghost base)
               (add-white 
                (scale rule (+ 1 (* n1 (- scale-factor 1)))) n1)
               rule 
               dest
               n1)])
           base))

(define (bring-out-left name n1)
  (define rule (hash-ref picts-to-zoom name))
  (define scale-factor (hash-ref half-scale-factors name))
  (define dest (hash-ref left-dests name))
  (refocus (cond
             [(= n1 0)
              (ghost base)]
             [else
              (slide-pict
               (ghost base)
               (add-white 
                (scale rule (+ 1 (* n1 (- scale-factor 1)))) n1)
               rule 
               dest
               n1)])
           base))
  
  

(define (slide-left name n1)
  (define rule (hash-ref picts-to-zoom name))
  (define dest (hash-ref dests name))
  (define scale-factor (hash-ref scale-factors name))
  (define half-scale-factor (hash-ref half-scale-factors name))
  (define left-dest (hash-ref left-dests name))
  (refocus (slide-pict
            (ghost base)
            (add-white (scale rule (+ half-scale-factor
                                      (* (- scale-factor half-scale-factor)
                                         (- 1 n1)))) 1)
            dest 
            left-dest
            n1)
           base))

(define (add-white p n)
  (refocus
   (cc-superimpose (cellophane 
                    (colorize (filled-rounded-rectangle
                               (+ (pict-width p) 20)
                               (+ (pict-height p) 20)
                               (+ (* n 8) 8)
                               #:draw-border? #f)
                              "gray")
                    n)
                   p)
   p))

(define (introduce-calculus)
  (define proc
    (λ (n1 n23 n45 n67)
      (define-values (n2 n3) (split-phase n23))
      (define-values (n4 n5) (split-phase n45))
      (define-values (n6 n7) (split-phase n67))
      (cc-superimpose
       frozen-bkg
       (bring-out-and-put-back 'base n1 n2)
       (bring-out-and-put-back 'beta n3 n4)
       (bring-out-and-put-back 'base n5 n6)
       (bring-out-and-dont-put-back 'types n7))))
  (play-n proc
          #:steps
          (for/list ([i (in-range (procedure-arity proc))])
            (cond
              [(= i 0)
               10]
              [else 
               30]))))

(define (zoom-grammar)
  (play-n
   (λ (n)
     (cc-superimpose
      frozen-bkg
      (bring-out-and-dont-put-back 'base n)))))

(define (zoom-types)
  (play-n
   (λ (n)
     (cc-superimpose
      frozen-bkg
      (bring-out-and-dont-put-back 'types n)))))

(define (zoom-grammar-then-bug)
  (play-n
   (λ (n1 n23)
     (define-values (n2 n3) (split-phase n23))
     (cc-superimpose
      frozen-bkg
      (bring-out-and-put-back 'base n1 n2)
      (bring-out-and-dont-put-back 'beta n3)))))

(define (zoom-grammar-then-bug-then-left)
  (play-n
   (λ (n1 n23 n45)
     (define-values (n2 n3) (split-phase n23))
     (define-values (n4 n5) (split-phase n45))
     (cc-superimpose
      (fade-pict n5 frozen-bkg (ghost base))
      (bring-out-and-put-back 'base n1 n2)
      (bring-out-and-put-back 'beta n3 n4)
      (bring-out-left 'base n5)))))

(define (grammar-left)
  (define g
    (add-white (scale (hash-ref picts-to-zoom 'base)
                      (hash-ref half-scale-factors 'base))
               1))
  (define r-side
    (hc-append 40
               g
               (scale-to-fit
                (vc-append
                 (text "Testing strategy:")
                 (hbl-append (text "Generate random ")
                             (term->pict STLC e)
                             (text "'s"))
                 (text "Check:")
                 type-soundness-pict)
                (ghost g))))
  (play-n
   (λ (n)
     (cc-superimpose
      (fade-pict n frozen-bkg
                 (rc-superimpose
                  (ghost base)
                  r-side))
      (slide-left 'base n)))))

(define (get-zoomy)
  (define g
    (add-white (scale (hash-ref picts-to-zoom 'base)
                      (hash-ref half-scale-factors 'base))
               1))
  (define r-side
    (hc-append 40
               (ghost g)
               (scale-to-fit
                (vc-append 10
                 (text "Testing strategy:")
                 (hbl-append (text "Generate random ")
                             (term->pict STLC e)
                             (text "'s"))
                 (text "Check:")
                 type-soundness-pict)
                (ghost g))))
  (play-n
   (λ (n1 n23 n45 n6)
     (define-values (n2 n3) (split-phase n23))
     (define-values (n4 n5) (split-phase n45))
     (define (ghost-n<6 i)
       (if (= n6 0)
           (ghost i) i))
     (define (ghost-n6 i)
       (if (= n6 0)
           i (ghost i)))
     (cc-superimpose
      (fade-pict n6 frozen-bkg
                 (rc-superimpose
                  (ghost frozen-bkg)
                  r-side))
      (bring-out-and-put-back 'base n1 n2)
      (bring-out-and-put-back 'beta n3 n4)
      (ghost-n6 (bring-out-and-dont-put-back 'base n5))
      (ghost-n<6 (slide-left 'base n6))))))

(define (get-zoomy-again)
  (define g
    (add-white (scale (hash-ref picts-to-zoom 'types)
                      (hash-ref half-scale-factors 'types))
               1))
  (define r-side
    (hc-append 40
               (ghost g)
               (scale-to-fit
                (vc-append 10
                 (text "Testing strategy:")
                 (text "Generate random ")
                 (with-rewriters
                  (term->pict STLC (tc • e τ)))
                 (text "Check:")
                 type-soundness-pict)
                (ghost g))))
  (play-n
   (λ (n1 n2)
     (define (ghost-n<2 i)
       (if (= n2 0)
           (ghost i) i))
     (define (ghost-n2 i)
       (if (= n2 0)
           i (ghost i)))
     (cc-superimpose
      (fade-pict n2 frozen-bkg
                 (rc-superimpose
                  (ghost frozen-bkg)
                  r-side))
      (ghost-n2 (bring-out-and-dont-put-back 'types n1))
      (ghost-n<2 (slide-left 'types n2))))))

(define (grammar-left2)
  (play-n
   (λ (n)
     (cc-superimpose
      (fade-pict n frozen-bkg
                 (ghost base))
      (bring-out-left 'base n)))))

(define (e-strategy)
  (define g
    (add-white (scale (hash-ref picts-to-zoom 'base)
                      (hash-ref half-scale-factors 'base))
               1))
  (slide
   (lc-superimpose
    (ghost base)
    (hc-append 40
     g
     (scale-to-fit
      (vc-append
       (text "Testing strategy:")
       (hbl-append (text "Generate random ")
                   (term->pict STLC e)
                   (text "'s"))
       (text "Check:")
       type-soundness-pict)
      (ghost g))))))

(define (types-left)
  (play-n
   (λ (n)
     (cc-superimpose
      (fade-pict n frozen-bkg
                 (ghost base))
      (slide-left 'types n)))))


(module+ slideshow (introduce-calculus))
