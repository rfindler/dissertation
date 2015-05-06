#lang racket/base

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
         code-snip-pict)

(define thesis
"Automated property-based testing is effective 
for semantics engineering and <lightweightness good>.")

(define current-background (make-parameter #f))

(define (default-background width height)
  (color colors:slide-background
         (filled-rectangle width height)))

(define (make-slide-assembler default-assembler)
  (lambda (title title-sep content)
    (define sld (default-assembler title title-sep content))
    (ct-superimpose ((current-background) (pict-width sld) (pict-height sld)) sld)))

(current-slide-assembler (make-slide-assembler (current-slide-assembler)))

(current-main-font font:main-font)

(current-background default-background)

(current-title-color colors:title-color)

(define (t/n str #:v-combine [v-comb vl-append])
  (apply v-comb
         (for/list ([s (in-list (string-split str "\n"))])
           (t s))))

(define-syntax-rule (s-frame p ...)
  (shadow-frame p ...
                #:background-color colors:note-color
                #:frame-color colors:shadow
                #:frame-line-width 2))


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

