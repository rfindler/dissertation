#lang racket

(require pict
         slideshow
         "common.rkt"
         "settings.rkt")

(provide constructs-table
         contents-table)

(define (mk-mark char color)
  (define letter (tt "X"))
  (define gletter (lbl-superimpose (ghost letter) 
                                   (blank (pict-height letter) 0)))
  (colorize (refocus (lbl-superimpose gletter
                                      (parameterize ([current-main-font font:base-font])
                                        (t char))) gletter)
            color))

(define x-mark (mk-mark "✘" colors:shadow))
(define check-mark (mk-mark "✔" colors:emph-bright))

(define l-col
  '("Redex Construct"
    "language"
    "reduction relation"
    "judgment form"
    "metafunction"))

(define col1 '("2011" check x x x))
(define col2 '("Now" double-check x check check))

(define (make-col col)
  (map (λ (el)
         (match el
           [(? string?) (t el)]
           ['check check-mark]
           ['x x-mark]
           ['double-check (hbl-append check-mark
                                      check-mark)]))
       col))

(define l-col-picts (make-col l-col))
(define col1-picts (make-col col1))
(define col2-picts (make-col col2))

(define l-col-width (apply max (map pict-width l-col-picts)))
(define col1-width (apply max (map pict-width col1-picts)))
(define col2-width (apply max (map pict-width col2-picts)))

(define row-heights
  (for/list ([lp (in-list l-col-picts)]
             [1p (in-list col1-picts)]
             [2p (in-list col2-picts)])
    (apply max (map pict-height (list lp 1p 2p)))))

(define (adjust-height col)
  (for/list ([p (in-list col)]
             [h (in-list row-heights)])
    (cc-superimpose p (blank 0 (* 1.1 h)))))

(define (pad-width col)
  (for/list ([p (in-list col)])
    (cc-superimpose p (blank (+ col2-width
                                (pict-width p)) 0))))

(define lw 4)

(define cols-raw
  (ht-append
   (apply vl-append (adjust-height l-col-picts))
   (apply vc-append (pad-width (adjust-height col1-picts)))
   (apply vc-append (adjust-height col2-picts))))

(define cols
  (lt-superimpose
   cols-raw
   (vl-append (blank 0 (pict-height (car l-col-picts)))
              (colorize
               (linewidth lw
                          (hline (pict-width cols-raw) 0))
               colors:emph-dull))))

(define (constructs-table)
  (slide #:title "Test Generation Coverage"
         (scale cols 1.5)))

(define contents 
  (map t (list  "Component" "Work" "Writing"
                "Ad-hoc generator"  "-"    "0%"
               "Enumeration"       "100%" "50%"
               "Derivation gen."   "100%" "50%"
               "Benchmark"         "85%"  "50%"
               "Benchmark results" "85%"  "50%"
               "Typed comparison"  "100%" "75%")))

(define (table/line ncols picts
                    col-aligns row-aligns
                    col-seps row-seps
                    #:final-line? [fline? #f])
  (define tab-pict (table ncols picts
                         col-aligns row-aligns
                         col-seps row-seps))
  (define line-pict (colorize
                     (linewidth lw
                                (hline (pict-width tab-pict) 0))
                     colors:emph-dull))
  (lb-superimpose
   (lt-superimpose
    tab-pict
    (vc-append
     (blank 0 (+ 5 (apply max (map pict-height
                                   (take picts ncols)))))
     line-pict))
   ((if fline? values ghost)
    (vc-append line-pict
               (blank 0 (+ 5 (apply max (map pict-height
                                             (take (reverse picts)
                                                   ncols)))))))))

(define cont-table (table/line 3 contents
                               lc-superimpose cc-superimpose
                               50 10))

(define todo-picts
  (map t/n (list "Task" "Estimated\ntime (weeks)"
               "Related work" "3"
               "Writing" "6"
               "Reduction lhs as input" "1"
               "Generation from reduction" "2"
               "Benchmark extensions (CESK)" "1"
               "Generate new results" "1"
               "Match compilation" "2"
               "Total" "13")))

(define (contents-table)
  (slide #:title "Dissertation Contents"
         (scale cont-table 1.5)))

(define todo-tbl (table/line 2 todo-picts
                               lc-superimpose cbl-superimpose
                               50 10
                               #:final-line? #t))

(define (todo-table)
  (slide #:title "Remaining Work"
         (scale-to-fit todo-tbl (inset titleless-page -20))))


