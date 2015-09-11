#lang slideshow

(require slideshow/play
         pict/balloon
         "plot-lines.rkt"
         "fades.rkt"
         "../results/ghc-data.rkt"
         (only-in "redex-typeset.rkt" my-freeze)
         (only-in plot plot-font-face plot-font-family))

(provide make-eval-pict
         do-handwritten-eval)

(define h-pict
  (parameterize ([hists-cmp (for/list ([hc (in-list (hists-cmp))]
                                       [lab (in-list '("Handwritten"
                                                       "Redex poly"
                                                       "Redex non-poly"))])
                              (list lab (second hc)))]
                 [plot-font-face "Gill Sans"]
                 [plot-font-family 'swiss])
    (hists-pict (- 768 margin margin)
                (- 1024 margin margin)
                (current-font-size) 'solid)))

(define frozen-h (my-freeze h-pict 0 0 0 0))


(define (fade-out p)
  (cc-superimpose
   p
   (cellophane
    (colorize
     (filled-rectangle (pict-width p) (pict-height p))
     "white")
    0.6)))

(define (make-eval-pict lp-pict h-pict #:with-title? [show-title? #t])
  (vc-append 35
             (if show-title? (scale (t "Evaluation") 1.5) (blank 10 10))
             (vl-append 10
                        (hc-append 20
                                   line-plot-pict
                                   lp-pict)
                        (hc-append 20
                                   (cc-superimpose
                                    (scale-to-fit frozen-h line-plot-pict)
                                    (ghost line-plot-pict))
                                   h-pict))))

(define eval-pict
  (make-eval-pict (vl-append
                   (t "Comparison with")
                   (t "Automatic"))
                  (vl-append
                   (t "Comparison with")
                   (t "Handwritten"))))

(define lp-pict (scale-to-fit line-plot-pict
                              (- client-w margin margin)
                              (- client-h margin margin)))


(define lp-pict-2
  (pin-over
   ;(fade-out lp-pict)
   lp-pict
   (/ (pict-width lp-pict) 10)
   (/ (pict-height lp-pict) 3)
   (faded-fade
    (scale (hc-append 20
                      (arrow 50 pi)
                      (vl-append (t "7 Redex models")
                                 (t "43 bugs")))
           2)
    #:color "white"
    #:init 0.05
    #:delta 2
    #:grads 50)))


(define (make-prop-pict times ptext
                        [comment-on #f]
                        [comment ""]
                        [find rc-find]
                        #:prop-color [prop-color "black"]
                        #:show-non-poly [show-np? #t])
  (define (maybe-ghost-last lop)
    (define rlop (reverse lop))
    (reverse
     (cons ((if show-np? identity ghost) (first rlop))
           (rest rlop))))
  (define back (scale titleless-page
                      0.9))
  (define rtext
    (vc-append (t "seconds")
               (linewidth 4
                          (hline (pict-width (t "counterexample")) 5))
               (t "counterexample")))
  (define num-ps (maybe-ghost-last
                  (map (λ (p)
                         (define xp (ghost (t "X")))
                         (refocus (lbl-superimpose xp p) xp))
                       (map t times))))
  (define types (maybe-ghost-last
                 (map t (list "handwritten"
                              "redex poly"
                              "redex non-poly"))))
  (define (pin-comment p)
    (if comment-on
        (pin-balloon (wrap-balloon (t comment) 'sw -5 5)
                     p
                     (list-ref num-ps comment-on)
                     find)
        p))
  (pin-comment
   (cc-superimpose
    (colorize
     (filled-rounded-rectangle
      (pict-width back)
      (pict-height back))
     "light blue")
    (rt-superimpose
     rtext
     (lt-superimpose
      (cc-superimpose (colorize (t ptext) prop-color)
                      (ghost rtext))
      (cc-superimpose
       (scale back 0.9)
       (let* ([lside (apply vr-append
                            (map (λ (p)
                                   (cbl-superimpose
                                    p (ghost (scale p 1 2))))
                                 types))]
              [rside (apply vl-append
                            (map (λ (p) (scale p 2))
                                 num-ps))]
              [mid (blank 10 (pict-height rside))])
         (scale (refocus (hc-append lside
                                    mid
                                    rside)
                         mid)
                1.5))))))))

(define palka-pict (bitmap "palka-etal.png"))

(define (do-handwritten-eval)
  
  (slide
   #:title "Hand-written generator comparison"
   (hc-append
    (scale-to-fit palka-pict
                  (/ (- client-w margin margin) 2)
                  (- client-h margin margin))
    (scale-to-fit
     (t "[Pałka, Claessen, Russo, Hughes 2011]")
     (/ (- client-w margin margin) 2)
     (- client-h margin margin))))
  
  (slide
   #:title "Hand-written generator comparison"
   (make-prop-pict
    (list "260"
          "2,500,000"
          "27")
    "Property 1: Optimization/Strictness"
    #:show-non-poly #f))
  
  (slide
   #:title "Hand-written generator comparison"
   (make-prop-pict
    (list "260"
          "2,500,000"
          "27")
    "Property 1: Optimization/Strictness"))
  
  (slide
   #:title "Hand-written generator comparison"
   (make-prop-pict
    (list "1,000"
          "∞"
          "823,000")
    "Property 2: Optimization/Order of Eval."))
  
  (slide
   #:title "Distribution of typed terms"
   (item "Closed terms: [Grygiel and Lescanne 2013]")
   (item "This work (what we know):")
   (scale-to-fit
    (vc-append
     h-pict
     (t "term size"))
    (pict-width titleless-page)
    (* (pict-height titleless-page) 0.7)))

  #;
  (slide
   (scale-to-fit
    (make-eval-pict (t "Much better")
                    (t "Worse"))
    (- client-w margin margin)
    (- client-h margin margin))))