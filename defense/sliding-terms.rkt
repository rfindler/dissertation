#lang racket/base
(require slideshow
         slideshow/play
         "examples.rkt")


;; should be less than the number of examples available
(define number-of-examples-to-use 20)

(define (mk-lines full-examples)
  (define examples (take full-examples number-of-examples-to-use))
  (apply
   append
   (for/list ([example (in-list examples)])
     (define sp (open-output-string))
     (parameterize ([pretty-print-columns 40])
       (pretty-write (list-ref example 0) sp))
     (for/list ([l (in-list (regexp-split #rx"\n" (get-output-string sp)))])
       (hc-append
        4
        (if (equal? l "") (ghost (line->dots example 4)) (line->dots example 4))
        (tt l))))))

(define jf-lines (mk-lines jf-based))
(define grammar-lines (mk-lines grammar-based))

(define spacer-line 
  (ghost (launder (argmax pict-width (append jf-lines grammar-lines)))))

(define (sliding-examples lines number-on-screen)
  (play
   #:steps (* (length lines) 9)
   (apply
    sequence-animations
    (for/list ([i (in-range 0
                            (- (length lines) number-on-screen))])
      (λ (n)
        (define padding-count (abs (min 0 i)))
        (define strings
          (append
           (build-list padding-count (λ (x) (blank)))
           (take (drop lines (max 0 i))
                 (- number-on-screen padding-count))))
        (vc-append
         (blank 0 (* (- 1 n) (pict-height spacer-line)))
         (apply vl-append 
                (for/list ([s (in-list strings)])
                  (lc-superimpose s spacer-line)))
         (blank 0 (* n (pict-height spacer-line))))))))
  (void))

(define (sliding-grammar)
  (sliding-examples 
   grammar-lines
   16))

(define (sliding-jf)
  (sliding-examples 
   jf-lines
   16))

(provide sliding-grammar sliding-jf)