#lang racket/base
(require slideshow
         racket/gui/base
         racket/runtime-path
         "examples.rkt")

(dots? #t)

(define (slide-columns num-columns lst)
  (define one-nth-ish (quotient (length lst) num-columns))
  (define first-columns
    (for/list ([i (in-range (- num-columns 1))])
      (take (drop lst (* one-nth-ish i))
            one-nth-ish)))
  (define columns (append first-columns
                          (list 
                           (drop lst (apply + (map length first-columns))))))
  (slide
   (to-bitmap
    (scale-to-fit
     (apply ht-append
            40
            (for/list ([column (in-list columns)])
                (apply vl-append 4 column)))
     client-w client-h))))

(define (to-bitmap pict)
  (define bmp (make-bitmap (inexact->exact (ceiling (pict-width pict)))
                           (inexact->exact (ceiling (pict-height pict)))))
  (define bdc (make-object bitmap-dc% bmp))
  (draw-pict pict bdc 0 0)
  (send bdc set-bitmap #f)
  (bitmap bmp))

(define (line->pict line factor)
  (define dots (line->dots line 20))
  (hc-append
   20
   dots
   (filled-rectangle (* (string-length (format "~s" (list-ref line 0)))
                        factor)
                     (/ (pict-height dots) 2))))

(define (sort-em l) 
  (sort l < 
        #:cache-keys? #t
        #:key (λ (x) 
                (if (list-ref x 0)
                    (string-length (format "~s" (list-ref x 0)))
                    -1))))

(define (grammar-overview)
  (slide-columns
   10
   (for/list ([i (in-list (sort-em grammar-based))])
     (line->pict i 8))))

(define (jf-overview)
  (slide-columns
   10
   (for/list ([i (in-list (sort-em jf-based))])
     (line->pict i 2))))

(provide grammar-overview jf-overview)