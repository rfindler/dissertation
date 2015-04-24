#lang racket/base

(require racket/class
         racket/draw
         racket/match
         (only-in pict colorize disk hc-append))

(provide (all-defined-out))

(struct palette (colors [mapping #:mutable])
        #:property
        prop:procedure
        (lambda (p map-from)
          (hash-ref (palette-colors p)
                    (hash-ref (palette-mapping p) map-from))))


(define (make-palette spec)
  (define hash-make
    (match-lambda
     [(list name red green blue rest ...)
      (hash-set (hash-make rest)
                name
                (make-object color% red green blue))]
     [(list) (hash "white"
                   (make-object color% 225 225 225 0))]))
  (define p-hash (hash-make spec))
  (palette p-hash (hash)))

(define (add-palette-mapping! p map-to color)
  (set-palette-mapping! p (hash-set (palette-mapping p) 
                                    map-to color)))

(define (show-palette p)
  (apply hc-append
         (for/list ([c (in-list (hash-values (palette-colors p)))])
           (colorize (disk 40) c))))

;; http://www.colourlovers.com/palette/765305/japan9
(define japan9
  (make-palette (list "open the shade" 227 223 227
                      "minty lusty dust" 200 214 191
                      "freshness" 147 204 198
                      "mabula" 108 189 181
                      "night sweat" 26 31 30)))

(add-palette-mapping! japan9 'background-color "open the shade")
(add-palette-mapping! japan9 'main-font-color "night sweat")
(add-palette-mapping! japan9 'note-color "minty lusty dust")

(define current-palette (make-parameter japan9))

(define inquiring-nature-iv
  (make-palette (list "cream" 240 237 228
                      "nuanced smile" 146 209 123
                      "me voy" 181 31 53
                      "printer's ink" 16 26 25
                      "plainspoken woman" 13 79 14)))

(add-palette-mapping! inquiring-nature-iv 'note-color "cream")
(add-palette-mapping! inquiring-nature-iv 'main-font-color "printer's ink")
(add-palette-mapping! inquiring-nature-iv 'background-color "nuanced smile")

(define milky-way
  (make-palette (list "cannibalism" 235 228 204
                      "pale skin" 204 197 171
                      "JII" 15 43 69
                      "artemis" 70 128 115
                      "teal green" 58 171 146)))

(add-palette-mapping! milky-way 'background-color "white")
(add-palette-mapping! milky-way 'main-font-color "JII")
(add-palette-mapping! milky-way 'note-color "cannibalism")
(add-palette-mapping! milky-way 'shadow "pale skin")
(add-palette-mapping! milky-way 'emph-dull "artemis")
(add-palette-mapping! milky-way 'emph-bright "teal green")
 
(current-palette milky-way)
        
