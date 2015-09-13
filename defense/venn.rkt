#lang racket

(require pict
         slideshow
         slideshow/play
         unstable/gui/pict
         "common.rkt"
         "settings.rkt")

(provide show-venn)

(define title-pict (bitmap "title.png"))

(define (venn-2 rad c1 c2)
  (define dsk (disk rad))
  (panorama
   (pin-over
    (tag-pict (cellophane (colorize dsk c1) 0.75)
              'left-disk)
    (* rad 0.85) 0
    (tag-pict (cellophane (colorize dsk c2) 0.75)
              'right-disk))))

(define l-t (t/n #:v-combine vc-append
"automated
testing"))

(define r-t (t/n #:v-combine vc-append
"lightweight
semantics
tools"))

(define (focus-center p)
  (define f (blank 0 0))
  (refocus (cc-superimpose p f) f))

(define max-dim
  (apply max (list (pict-width l-t)
                   (pict-height l-t)
                   (pict-width r-t)
                   (pict-height r-t))))

(define v2 (venn-2 (* 2 max-dim) colors:shadow colors:emph-dull))

(define v2/text
  (scale-to
   (pin-over
    (pin-over v2
              (car (find-tag v2 'left-disk))
              cc-find
              (focus-center l-t))
    (car (find-tag v2 'right-disk))
    cc-find
    (focus-center r-t))
   (pict-width titleless-page)
   (pict-height titleless-page)))

(define arr-p
  (colorize (vr-append (scale (rotate (scale (arrow 15 0) 2 1) (* (/ 4 5) pi)) 2)
                       (parameterize ([current-main-font font:base-font])
                         (ghost (t "me"))))
            colors:note-color))

(define (v2/text/dot [show-dot? #f] [show-arr? #f])
  (cc-superimpose
   v2/text
   (hc-append
    #;(blank 20 0)
    (vc-append
     ((if show-dot? values ghost)
      (let* ([dsk-temp (ghost (colorize (disk 15) colors:note-color))]
             [dsk (refocus (cc-superimpose (scale-to-fit title-pict dsk-temp)
                                           dsk-temp)
                           dsk-temp)])
        (refocus
         (hc-append
          (vl-append dsk
                     (blank 0
                            (* (pict-height arr-p) 0.85)))
          ((if show-arr? values ghost) arr-p))
         dsk)))
     #;(blank 0 40)))))

(define (rect-shadow p
                     #:factor [f 0.1]
                     #:grads [g 10]
                     #:cel-factor [c-f 1]
                     #:background-color [bkg "white"])
  (define s-width (* (pict-width p) f))
  (define s-height (* (pict-width p) f))
  (define h-grads (for/list ([n (in-range 1 (add1 g))])
                    (cellophane
                     (colorize (filled-rectangle (/ s-width g)
                                                 (pict-height p)
                                                 #;(- (pict-height p) (* s-height 2 (/ (sub1 n) g)))
                                                 #:draw-border? #f)
                               bkg) (* c-f (/ (sub1 n) g)))))
  (define v-grads (for/list ([n (in-range 1 (add1 g))])
                    (cellophane
                     (colorize (filled-rectangle (pict-width p)
                                                 (/ s-height g)
                                                 #:draw-border? #f)
                               bkg) (* c-f (/ (sub1 n) g)))))
  (rc-superimpose
   (cb-superimpose
    (lc-superimpose
     (ct-superimpose
      p
      (apply vc-append (reverse v-grads)))
     (apply hc-append (reverse h-grads)))
    (apply vc-append v-grads))
   (apply hc-append h-grads)))
  

(define (zoom p factor)
  (define rf
    (let ([f (blank (/ (pict-width p) factor)
                    (/ (pict-height p) factor))])
      (refocus (cc-superimpose p f) f)))
  (clip (scale-to rf (pict-width p) (pict-height p))))


(define zoom-factor 25)

(define v-title "A very brief summary")

(define (show-venn)
  (play #:title "Thesis"
        (λ (n)
          (rect-shadow #:grads 6
                       #:factor 0.025
                       #:cel-factor n
                       (zoom (v2/text/dot (not (= n 0))) (+ 1 (* n (sub1 zoom-factor)))))))
  (slide #:title "Thesis"
         (rect-shadow #:grads 6
                       #:factor 0.025
                       #:cel-factor 1
                       (zoom (v2/text/dot #t) zoom-factor)))
  (play #:title "Thesis"
        (λ (n)
          (rect-shadow #:grads 6
                       #:factor 0.025
                       #:cel-factor (- 1 n)
                       (zoom (v2/text/dot #t #t) (+ 1 (* (- 1 n) (sub1 zoom-factor)))))))
  (slide #:title "Thesis"
         (v2/text/dot #t #t)))




