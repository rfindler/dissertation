#lang racket

(require pict
         slideshow
         unstable/gui/pict
         "common.rkt"
         "settings.rkt")

(provide do-quadrants)

(define (make-quad qsize)
  (define quad (blank qsize qsize))
  (define lw 4)
  (define hl (colorize (linewidth 4 (hline qsize 0)) colors:emph-dull))
  (define qd-pict
    (hc-append (vc-append (tag-pict quad 'upper-left)
                        hl
                        (tag-pict quad 'lower-left))
             (colorize (linewidth 4 (vline 0 (* 2 qsize))) colors:emph-dull)
             (vc-append (tag-pict quad 'upper-right)
                        hl
                        (tag-pict quad 'lower-right))))
  (cc-superimpose
   (colorize
    (filled-rounded-rectangle (pict-width qd-pict)
                             (pict-height qd-pict)
                             -0.05)
    colors:note-color)
   qd-pict))

(define (quad/labels qsize top-l top-r right-t right-b)
  (define (qt string [vertical? #f])
    (cc-superimpose (t/n string #:v-combine vc-append)
                    (if vertical?
                        (blank 0 qsize)
                        (blank qsize 0))))
  (hb-append 5
   (vr-append (qt right-t #t) (qt right-b #t))
   (vr-append 5
    (hbl-append (qt top-l) (qt top-r))
    (make-quad qsize))))

(define (quad-pin quad
                  quadrant x y
                  text)
  (define qdrnt-p (car (find-tag quad quadrant)))
  (define to-pin (s-frame ((if (pict? text)
                               values
                               (λ (txt)
                                 (t/n txt #:v-combine vc-append)))
                           text)))
  (pin-over quad
            qdrnt-p
            lt-find
            (pin-over (blank (pict-width qdrnt-p)
                             (pict-width qdrnt-p))
                      x y
                      to-pin)))

(define (make-pin-seq base pins)
  (reverse
   (for/fold ([pin-picts (list base)])
             ([pin-data (in-list pins)])
     (match-define
       (list text qdrt x y) pin-data)
     (cons (quad-pin (car pin-picts)
                     qdrt x y text)
           pin-picts))))

(define (do-quadrants)
  (map (λ (p)
         (slide
          (scale-to-fit p titleless-page)))
       (make-pin-seq (quad/labels 475
                                  "software\nengineering" "semantics\nengineering"
                                  "proof" "test")
                     (list (list "unit testing" 'lower-left 75 25)
                           (list "Quickcheck\n[Claessen & Hughes 2000]" 'lower-left 12 150)
                           (list "Hoare's Grand\nChallenge\n[Hoare 2003]" 'upper-left 100 125)
                           (list "Coq" 'upper-right 50 25)
                           (list "ACL2" 'upper-right 200 75)
                           (list "Isabelle/HOL\n[Nipkow et al 2011]" 'upper-right 50 375)
                           (list "large % of\nPL community" 'upper-right 100 200)
                           (list "Redex" 'lower-right 50 50)
                           (list "K [Rosu & Serbanuta 2014]" 'lower-right 12 350)
                           (list "Ott/Lem\n[Sewell et al 2010]" 'lower-right 125 175)))))
    




