#lang racket/base

(require pict
         slideshow)

(provide fade-behind
         faded-fade)


(define (fade-behind str)
  (define p (tt str))
  (define delta 20)
  (refocus (cc-superimpose
            (cellophane
             (colorize (filled-rectangle (+ (pict-width p) delta)
                                         (+ (pict-height p) delta))
                       "white")
             .8)
            p)
           p))

(define (faded-fade p 
                    #:color (color "mediumblue")
                    #:init (init-op 0.0075)
                    #:circle? (circle? #f)
                    #:delta (delta 2)
                    #:grads (grads 300))
  ;(define p (colorize (t str) "white"))
  (define op-delt (/ init-op grads))
  (refocus
   (for/fold ([p p])
     ([i (in-range grads)])
     (cc-superimpose
      (cellophane
       (colorize (if circle?
                     (disk (+ (pict-height p) delta)
                                   #:draw-border? #f)
                     (filled-ellipse (+ (pict-width p) delta)
                                     (+ (pict-height p) delta)
                                   #:draw-border? #f))
                 color)
       (- init-op (* op-delt i)))
      p))
   p))