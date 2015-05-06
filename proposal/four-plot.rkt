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
  (define to-pin (s-frame ((if (pict? text) values t/n) text)))
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
       (make-pin-seq (quad/labels 400
                                  "software\nengineering" "semantics\nengineering"
                                  "proof" "test")
                     (list (list "TDD" 'lower-left 15 100)
                           (list (hc-append
                                  (vc-append (t "testers")
                                             (colorize
                                              (linewidth 4
                                                         (hline (pict-width (t "developers")) 0))
                                              colors:main-font-color)
                                             (t "developers"))
                                  (t " \u2248 1"))
                                 'lower-left 25 225)
                           (list "Quickcheck" 'lower-left 150 25)
                           (list "everything..." 'lower-left 150 125)
                           (list "Coq" 'upper-right 50 25)
                           (list "ACL2" 'upper-right 200 75)
                           (list "Many More" 'upper-right 100 200)
                           (list "Hoare's\nGrand\nChallenge" 'upper-left 100 100)
                           (list "Redex" 'lower-right 50 50)
                           (list "K" 'lower-right 25 200)
                           (list "Ott/Lem" 'lower-right 150 175)))))
    




