#lang at-exp racket/base

(require slideshow
         pict
         slideshow/code
         unstable/gui/pict
         "settings.rkt")

(provide thesis
         current-background
         default-background
         make-slide-assembler
         t/n
         s-frame
         bubble
         code-snip-pict
         sexp->pict
         cite
         prod-p
         nats-p
         emph-line
         item-frame)

(define thesis @string-append{Lighweight mechanization and 
                              automated property-based testing are 
                              effective for semantics engineering.})

(define current-background (make-parameter #f))

(define (default-background width height)
  (color colors:slide-background
         (filled-rectangle width height)))

(current-main-font font:main-font)

(current-background default-background)

(current-title-color colors:title-color)

(define (make-slide-assembler default-assembler)
  (lambda (title title-sep content)
    (define sld (default-assembler title title-sep content))
    (ct-superimpose ((current-background) (pict-width sld) (pict-height sld)) sld)))

(current-slide-assembler (make-slide-assembler (current-slide-assembler)))


(define prod-p (t "\u2a2f"))
(define nats-p (t "\u2115"))

(define (t/n str #:v-combine [v-comb vl-append])
  (apply v-comb
         (for/list ([s (in-list (string-split str "\n"))])
           (t s))))

(define-syntax-rule (s-frame p ...)
  (shadow-frame p ...
                #:background-color colors:note-color
                #:frame-color colors:shadow
                #:frame-line-width 2))

(define-syntax-rule (item-frame p ...)
  (let* ([pps (list (t p) ...)]
         [maxw (apply max (map pict-width pps))])
    (s-frame (item (t p) #:width (* 1.25 maxw)) ...)))
     
(define (bubble str)
  (define txt-p (t str))
  (tag-pict
   (cc-superimpose
    (colorize
     (filled-ellipse (* (pict-width txt-p) 1.25)
                     (/ (+ (pict-width txt-p)
                           (pict-height txt-p))
                        2))
     colors:emph-dull)
    txt-p)
   (string->symbol str)))

(define (code-snip-pict filepath snip-name)
  (define snip-strings
    (call-with-input-file filepath
      (lambda (in)
        (define lines (let loop ([lns '()])
                        (define line (read-line in))
                        (if (eof-object? line)
                            (reverse lns)
                            (loop (cons line lns)))))
        (reverse
         (rest (member (format ";SNIP<~a>" snip-name)
                       (reverse (rest (member (format ";SNIP<~a>" snip-name) lines)))))))))
  (define the-port (open-input-string (apply string-append (add-between snip-strings "\n"))))
  (port-count-lines! the-port)
  (typeset-code (read-syntax snip-name the-port)))

(define (sexp->pict sexp)
  (define out-string (open-output-string))
  (pretty-write sexp out-string)
  (define the-port (open-input-string (get-output-string out-string)))
  (port-count-lines! the-port)
  (typeset-code (read-syntax "sexp->pict" the-port)))

(define (cite title authors)
  (vl-append
   (parameterize ([current-main-font (cons 'italic (current-main-font))])
     (item title))
   ;(item (it title))
   (hbl-append (ghost (t "XXX"))
               (t authors))))

(define (emph-line txt)
  (hc-append (colorize
              (let ([sp (ghost (t "XXXXXX"))])
               (cc-superimpose (linewidth 5 (hline (* (pict-width sp) 0.75) 0))
                               sp))
              colors:emph-dull)
             (t txt)))
