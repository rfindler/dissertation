#lang racket

(require slideshow
         slideshow/code
         slideshow/play)

(provide gen-state
         code-e
         infer
         pin-box-ratio
         g-lines)

(define (infer #:max-line [ml #f] r . l)
  (vc-append
   (* 2 (current-line-sep))
   (apply hb-append
          (* 2 (current-font-size))
          l)
   (linewidth (ceiling (/ 2 (apply min (current-expected-text-scale))))
              (hline (cond 
                       [(or (= (length l) 2) ml)
                        (max (pict-width r)
                             (apply + (cons (* 2 (current-font-size))
                                            (map pict-width l))))]
                       [else (pict-width r)])
                     1))
   r))


(define (infer-n n)
  (if (= n 0)
      (code X)
      (infer (code X)
             (infer-n (sub1 n)))))

(define i-g (ghost (infer-n 7)))
(define (i-align p)
  (cbl-superimpose i-g p))

(define-syntax (show-deriv stx)
  (syntax-case stx ()
    [(_ nts n ((p ...) cs ...))
     (with-syntax ([(fixed-p ...) 
                    (append-step (syntax-e #'n)
                                 (syntax->datum #'nts)
                                 #'(p ...))]
                   [np (add1 (syntax-e #'n))])
       #'(infer (code fixed-p ...)
                (show-deriv nts np cs) ...))]
    [(_ nts n (p ...))
     (with-syntax ([(fixed-p ...) 
                    (append-step (syntax-e #'n)
                                 (syntax->datum #'nts)
                                 #'(p ...))])
       #'(code fixed-p ...))]))

(define-for-syntax (append-step n nts estx)
  (let loop 
    ([exp-stx estx])
    (syntax-case exp-stx ()
      [(exps0 ...)
       (with-syntax ([(exps ...)
                      (map loop (syntax->list #'(exps0 ...)))])
         (syntax/loc exp-stx
           (exps ...)))]
      [maybe-nt
       (and (identifier? #'maybe-nt)
            (if (before-underscore? #'maybe-nt)
                (member 
                 (before-underscore? #'maybe-nt)
                 nts)
                (member (syntax-e #'maybe-nt) nts)))
       (datum->syntax #'maybe-nt
                      (string->symbol 
                       (format "~a^~a" (drop-prev-super (syntax-e #'maybe-nt)) n))
                      #'maybe-nt
                      #'maybe-nt)]
      [_
       exp-stx])))

(define-for-syntax (before-underscore? iden)
  (define mtch1 (regexp-match #rx"^(.*)_(.*)$"
                              (symbol->string
                               (syntax-e iden))))
  (define mtch2 (regexp-match #rx"^(.*)\\^(.*)$"
                              (symbol->string
                               (syntax-e iden))))
  (or (and mtch1
           (string->symbol (cadr mtch1)))
      (and mtch2
           (string->symbol (cadr mtch2)))))

(define-for-syntax (drop-prev-super iden)
  (define prev-super (regexp-match #rx"^(.*)\\^.*"
                                   (symbol->string
                                    iden)))
  (if prev-super
      (cadr prev-super)
      iden))

(define-syntax (code^ stx)
  (syntax-case stx ()
    [(_ nts n p ...)
     (with-syntax ([(fixed-p ...) (append-step (syntax-e #'n)
                                               (syntax->datum #'nts)
                                               #'(p ...))])
       #'(code fixed-p ...))]))

(define-syntax-rule (code-e n p ...)
  (code^ (Γ e x τ) n p ...))

(define g-line (ghost (code^ (X) 8 X_q)))

(define (g-infer-n n)
  (if (= n 0)
      g-line
      (infer g-line
             (infer-n (sub1 n)))))

(define (gi-lines n)
  (ghost (g-infer-n n)))

 (define (g-lines n)
  (ghost (apply vc-append 
                (append (list (current-font-size))
                        (for/list ([_ (in-range n)])
                          g-line)))))

(define (gen-state solution 
                   #:goals [goals #f] 
                   #:eqs [eqs #f] 
                   #:clause [clause #f]
                   #:dq [dq #f])
  (define clause-g (gi-lines 3))
  (define eqs-g g-line)
  (define dqs-box
    (lt-superimpose
     (colorize (scale (tt " disequations:") 0.75) "Firebrick")
     (frame (ghost (rectangle client-w
                              (pict-height (scale g-line 1.1))))
            #:color "Firebrick"
            #:line-width 3)))
  (define dqs-g (ghost dqs-box))
  (define goals-g 
    (lt-superimpose
     (colorize (scale (tt " goals:") 0.75) "RoyalBlue")
     (frame (ghost (rectangle client-w
                              (pict-height (scale (g-lines 2) 1.1))))
            #:color "RoyalBlue"
            #:line-width 3)))
  (define solution-g 
    (lt-superimpose
     (colorize (scale (tt " solution:") 0.75) "forestgreen")
     (frame (ghost (rectangle client-w
                              (pict-height (scale (g-lines 2) 1.1))))
            #:color "forestgreen"
            #:line-width 3)))
  (define eq-pict (if eqs
                 (ct-superimpose
                  (apply hbl-append 
                         (append (list (current-font-size))
                                 (map frame eqs)))
                  eqs-g)
                 eqs-g))
  (vc-append 20
             (if clause
                 (cb-superimpose clause clause-g)
                 clause-g)
             eq-pict
             (if goals 
                 (cb-superimpose
                  (apply vc-append goals)
                  goals-g)
                 goals-g)
             (if dq
                 (cb-superimpose dqs-box 
                                 (apply hbl-append dq))
                 dqs-g)
             (cb-superimpose solution solution-g)))

(define canvas (ghost (rectangle client-w client-h)))

(define (place-on-circle c d angle pict)
  (define rad (/ d 2))
  (define dx (/ (pict-width pict) 2))
  (define dy (/ (pict-height pict) 2))
  (define p-rad (sqrt (+ (* dx dx) (* dy dy))))
  (pin-over c
            (+ (/ (pict-width c) 2) (- dx) (* (- rad p-rad) (cos angle)))
            (+ (/ (pict-height c) 2) (- dy) (* (- rad p-rad) (sin angle)))
            pict))

(define syms '("λ" "App" "If0" "Plus" "Var" "Num"))

(define circ (ghost (circle 600)))

(define (refix rot-c d theta)
  (define (delta d) (* (/ d 2) (+ (abs (sin theta)) (abs (cos theta)) (- 1))))
  (refocus (pin-over rot-c 
                     (delta d) 
                     (delta d)
                     circ) circ))

(define (pin-box-ratio pict xr yr xlenr ylenr 
                       #:color (color "Yellow")
                       #:lwidth (lwidth 4))
  (define x (* xr (pict-width pict)))
  (define y (* yr (pict-height pict)))
  (define x-len (* xlenr (pict-width pict)))
  (define y-len (* ylenr (pict-height pict)))
  (pin-over pict
            x y (colorize
                 (linewidth lwidth (rectangle x-len y-len))
                 color)))