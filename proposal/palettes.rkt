#lang racket/base

(require racket/class
         racket/draw
         racket/match)

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
     [(list) (hash)]))
  (define p-hash (hash-make spec))
  (palette p-hash (hash)))

(define (add-palette-mapping! p map-to color)
  (set-palette-mapping! p (hash-set (palette-mapping p) 
                                    map-to color)))

;; http://www.colourlovers.com/palette/765305/japan9
(define japan9
  (make-palette (list "open the shade" 227 223 186
                      "minty lusty dust" 200 214 191
                      "freshness" 147 204 198
                      "mabula" 108 189 181
                      "night sweat" 26 31 30)))

(add-palette-mapping! japan9 'background-color "open the shade")
(add-palette-mapping! japan9 'main-font-color "night sweat")
(add-palette-mapping! japan9 'note-color "minty lusty dust")

(define current-palette (make-parameter japan9))

        
