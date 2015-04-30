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
(define colors:shadow ((current-palette) 'shadow))
(define colors:emph-dull ((current-palette) 'emph-dull))
(define colors:emph-bright ((current-palette) 'emph-bright))

;; fonts
(define font:base-font "Benton")
(define font:main-font 
  `(,colors:main-font-color . ,font:base-font))
