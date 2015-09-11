#lang racket

(require "common.rkt"
         "settings.rkt"
         redex/reduction-semantics
         redex/pict
         pict
         slideshow
         (only-in "redex-typeset.rkt" add-white))

(provide make-f-jdg
         layout-func-example
         f-bad-1
         f-bad-2
         add-sandwich
         add-anchor)

(define-language FexL
  (p any))

(define-metafunction FexL
  [(f (lst p_1 p_2)) true]
  [(f p) false])

(define f-pict
  (metafunction->pict f))

(define (vc-append-with-line p1 p2)
  (vc-append p1
             (hline (max (pict-width p1)
                         (pict-width p2))
                    5)
             p2))

(define f-ex-0
  (hbl-append (term->pict FexL (f (lst 1)))
              (term->pict FexL | = false|)))

(define f-ex-1
  (hbl-append (term->pict FexL (f (lst 1 2)))
              (term->pict FexL | = true|)))

(define f-ex-2
  (hbl-append (term->pict FexL (f (lst 1 2 3)))
              (term->pict FexL | = false|)))

(define f-ex-pict (vl-append f-ex-0
                             f-ex-1
                             f-ex-2))

(define bad-top
  (hbl-append (hbl-append
               (term->pict FexL (lst 3 4))
               (term->pict FexL | ≠ |)
               (term->pict FexL (lst 1 2)))))

(define bad-bot
  (hbl-append (term->pict FexL (f (lst 1 2)))
              (term->pict FexL | = false|)))

(define f-bad-1
  (add-white (vc-append-with-line (ghost bad-top) bad-bot)
             1))

(define f-bad-2
  (add-white (vc-append-with-line bad-top bad-bot)
             1))

(define lc-anchor (blank 10 10))

(define (add-anchor p)
  (cc-superimpose p
                  lc-anchor))

(define red-mark
  (parameterize ([current-main-font font:base-font])
    (colorize (t "✘") "red")))

(define blue-mark
  (parameterize ([current-main-font font:base-font])
    (colorize (t "✔") "blue")))

(define ex-anchor (ghost f-bad-2))

(define (make-f-jdg [show-dq? #f] [show-∀? #f]
                    #:mark [mark #f])
  (define f-dq (hbl-append 5 (term->pict FexL (lst p_1 p_2))
                           (term->pict FexL ≠)
                           (term->pict FexL p)))
  (define f-∀-dq (hbl-append 5 (term->pict FexL ∀)
                             (hbl-append
                              (term->pict FexL p_1)
                              (term->pict FexL |,|)
                              (term->pict FexL p_2)
                              (term->pict FexL |,|))
                             f-dq))
  (define (add-mark p)
    (refocus
     (cc-superimpose
      (scale
       (scale-to-fit
        (cond
          [(not mark) (blank 1 1)]
          [(eq? mark 'red) red-mark]
          [else blue-mark])
        p) 1.5) p) p))
  (define-values (mark-center mark-right)
    (cond [(eq? mark 'red) (values identity add-mark)]
          [else (values add-mark identity)]))
  (vc-append 15
   (mark-center
    (hc-append
     40
     (vc-append-with-line
      (ghost f-∀-dq)
      (parameterize ([metafunction-cases '(0)])
        (metafunction->pict f)))
     (mark-right
      (vc-append-with-line
       (cc-superimpose ((if show-∀? values ghost) f-∀-dq)
                       ((if show-dq? values ghost) f-dq))
       (parameterize ([metafunction-cases '(1)])
         (metafunction->pict f))))))
   ex-anchor))

(define (add-rr-border p)
  (cc-superimpose p
                  (linewidth 4
                              (rounded-rectangle (pict-width p)
                                     (pict-height p)
                                     20))))

(define (layout-func-example bottom [bottom-super (blank 1 1)])
  (define (tscale p) (scale p 2.5))
  (define w (- client-w margin margin))
  (define h (- client-h margin margin))
  (define w/2 (/ w 2))
  (define h/2 (/ h 2))
  (define rec/4 (add-rr-border (ghost (rectangle w/2 h/2))))
  (define rech/2 (add-rr-border (ghost (rectangle w h/2))))
  (define ul
    (lt-superimpose (t " Function Definition")
                    (cc-superimpose rec/4 (tscale f-pict))))
  (define ur
    (lt-superimpose (t " Examples")
                    (cc-superimpose rec/4 (tscale f-ex-pict))))
  (define bot (refocus
               (cc-superimpose
                (tscale bottom)
                rech/2)
               rech/2))
  (vc-append
   (ht-append ul ur)
   bot))

(define (add-sandwich topbot mid)
  (pin-over
   mid
   ex-anchor
   lt-find
   topbot))
               