#lang racket/base

(require racket/class
         (only-in racket/draw 
                  the-color-database
                  color%)
         "palettes.rkt")

(provide (all-defined-out))

;; colors
(define colors:slide-background ((current-palette) 'background-color))
(define colors:title-color ((current-palette) 'main-font-color))
(define colors:main-font-color ((current-palette) 'main-font-color))
(define colors:note-color ((current-palette) 'note-color))

;; fonts
(define font:main-font 
  `(,colors:main-font-color . "Benton"))
