#lang racket

(require plot/pict 
         pict
         redex/benchmark/private/graph-data
         racket/runtime-path)

(provide line-plot-pict
         line-plot-picts-with-intervals
         enum-plot-pict)

(define-runtime-path res-dir "../results/24-hr")
(define-runtime-path enum-dir "../results/24-hr-enum")

(define (line-plot/directory dir-path
                             #:interval-line [i-line #f])
  (define-values (d-stats _)
    (process-data
     (extract-data/log-directory dir-path)
     (extract-names/log-directory dir-path)))
  (parameterize ([plot-x-transform log-transform]
                 [plot-x-label "Time in Seconds"]
                 [plot-y-label "Number of Bugs Found"]
                 [plot-width 435] 
                 [plot-height 200]
                 [plot-x-ticks (log-ticks #:number 20 #:base 10)]
                 [type-symbols type->sym]
                 [type-names type->name]
                 [type-colors type->color])
    (plot-pict (make-renderers d-stats #:interval-line i-line)
               #:x-min 0.05)))

(define (type->sym t)
  (hash-ref (hash 'search 'diamond
                  'grammar 'circle
                  'enum 'square
                  'ordered 'plus)
            t))

(define (type->color t)
  (hash-ref (hash 'search 1
                  'grammar 2
                  'enum 3
                  'ordered 4)
            t))

(define (type->name t)
  (hash-ref (hash 'search "Derivation Generation"
                  'grammar "Ad Hoc Generation"
                  'enum "Random index"
                  'ordered "Enumerated")
            t))

(define line-styles
  (list 'solid 'dot 'long-dash
        'short-dash 'dot-dash))

(define (make-renderers stats)
  
  (parameterize ([plot-x-transform log-transform]
                 [plot-x-label "Time in Seconds"]
                 [plot-y-label "Number of Bugs Found"]
                 [plot-width 435] 
                 [plot-height 200]
                 [plot-x-ticks (log-ticks #:number 20 #:base 10)]
                 [type-symbols type->sym]
                 [type-names type->name]
                 [type-colors type->color])
    (define max-t (apply max (map third stats)))
    
    ;; (listof (list/c type data))
    (define types+datas
      (for/list ([(type avgs) (in-hash (sort-stats stats))]
                 [n (in-naturals)])
        (define pts 
          (for/fold ([l '()]) 
                    ([a (sort avgs <)]
                     [c (in-naturals)])
            (cons (list a (add1 c))
                  (cons 
                   (list a c) 
                   l))))
        (list type (reverse (cons (list max-t (/ (length pts) 2)) pts)))))
    
    (define (crossover-points)
      (unless (= 3 (length types+datas)) 
          (error 'plot-lines.rkt "ack: assuming that there are only two competitors"))
      (define-values (_ cps)
        (for/fold ([last-winner #f]
                   [crossover-points '()])
                  ([grammar-pr (in-list (list-ref (assoc 'grammar types+datas) 1))]
                   [enum-pr (in-list (list-ref (assoc 'enum types+datas) 1))]
                   [ordered-pr (in-list (list-ref (assoc 'ordered types+datas) 1))])
          (unless (and (= (list-ref grammar-pr 1)
                          (list-ref enum-pr 1))
                       (= (list-ref grammar-pr 1)
                          (list-ref ordered-pr 1)))
            (error 'plot-lines.rkt "ack: expected points to match up ~s ~s ~s"
                   grammar-pr
                   enum-pr
                   ordered-pr))
          (define y-position (list-ref grammar-pr 1))
          (define grammar-time (list-ref grammar-pr 0))
          (define enum-time (list-ref enum-pr 0))
          (define ordered-time (list-ref ordered-pr 0))
          (define best (min grammar-time enum-time ordered-time))
          (define current-winner
            (cond
             [(= grammar-time best) 'grammar]
             [(= ordered-time best) 'ordered]
             [(= enum-time best) 'enum]))
          (values current-winner
                  (cond
                   [(and last-winner (not (equal? last-winner current-winner)))
                    (cons (point-label (vector best y-position)
                                       (format "~a, ~a"
                                               (number+unit/s y-position "bug")
                                               (format-time best))
                                       #:anchor 'bottom-right)
                          crossover-points)]
                   [else
                    crossover-points]))))
      cps)
    (define (interval-line num-bugs)
      (define (find-envelope data)
        (let loop ([d data])
          (define bot (first d))
          (define top (second d))
          (if (and (equal? (second bot) num-bugs)
                   ((second top) . > . num-bugs)
                   (equal? (first bot) (first top)))
              (first top)
              (loop (cdr d)))))
      (define y (+ num-bugs 0.5))
      (define pts (for/list ([td (in-list types+datas)])
                    (list (find-envelope (second td))
                          y)))
      (lines pts
             #:color "blue"
             #:width 2
             #:label (format "Ratio at ~a: ~a"
                             num-bugs
                             (format-interval (first (first pts))
                                              (first (second pts))))))
    (define (line-renderers)
      (for/list ([type+pts (in-list types+datas)]
                 [n (in-naturals)])
        (define type (list-ref type+pts 0))
        (define pts (list-ref type+pts 1))
        (lines
         (reverse pts)
         ;#:width 2
         #:color (type->color type)
         #:style (list-ref line-styles n)
         #:label (type->name type))))
    (match-lambda
      ['lines (line-renderers)]
      ['lines+xover (append (line-renderers) (crossover-points))]
      [(? number? i-line)
       (list (interval-line i-line))])))

(define (format-time number)
  (cond
    [(<= number 60) (number+unit/s number "second")]
    [(<= number (* 60 60)) (number+unit/s (/ number 60) "minute")]
    [(<= number (* 60 60 24)) (number+unit/s (/ number 60 60) "hour")]
    [else (number+unit/s (/ number 60 60 24) "day")]))

(define (format-interval num1 num2)
  (define ratio (if (num1 . > . num2)
                    (/ num1 num2)
                    (/ num2 num1)))
  (define pow (/ (log ratio) (log 10)))
  (format "10^~a" (real->decimal-string pow 1)))

(define (number+unit/s raw-n unit) 
  (define n (round raw-n))
  (format "~a ~a~a" n unit (if (= n 1) "" "s")))

(module+ test
  (require rackunit)
  (check-equal? (format-time 0) "0 seconds")
  (check-equal? (format-time 1) "1 second")
  (check-equal? (format-time 59) "59 seconds")
  (check-equal? (format-time 70) "1 minute")
  (check-equal? (format-time 110) "2 minutes")
  (check-equal? (format-time (* 60 60 2)) "2 hours")
  (check-equal? (format-time (* 60 60 #e2.2)) "2 hours")
  (check-equal? (format-time (* 60 60 #e8.2)) "8 hours")
  (check-equal? (format-time (* 60 60 24 3)) "3 days"))

(define (sort-stats stats)
  (for/fold ([h (hash)])
            ([s (in-list stats)])
    (hash-set h (second s)
              (cons (third s)
                    (hash-ref h (second s) '())))))

(define/contract (type+num+method->average d-stats base num method)
  (-> any/c
      (or/c 'stlc 'poly-stlc 'stlc-sub 'let-poly 'list-machine 'rbtrees 'delim-cont 'verification) 
      any/c
      (or/c 'grammar 'ordered 'enum)
      (or/c #f (and/c real? positive?)))
  (define fn (format "~a-~a.rkt" base num))
  (for/or ([ele (in-list d-stats)])
    (define filename (list-ref ele 0))
    (define-values (base name dir) (split-path filename))
    (and (equal? (path->string name) fn)
         (equal? method (list-ref ele 1))
         (list-ref ele 2))))

(define (line-plot/renderers renderers)
  (parameterize ([plot-x-transform log-transform]
                 [plot-x-label "Time in Seconds"]
                 [plot-y-label "Number of Bugs Found"]
                 [plot-width 435] 
                 [plot-height 200]
                 [plot-x-ticks (log-ticks #:number 20 #:base 10)]
                 [type-symbols type->sym]
                 [type-names type->name]
                 [type-colors type->color])
    (plot-pict renderers
               #:x-min 0.05)))

(define-values (d-stats _)
  (process-data
   (extract-data/log-directory res-dir)
   (extract-names/log-directory res-dir)))

(define get-renderers (make-renderers d-stats))

(define line-rs (get-renderers 'lines))

(define line-plot-pict (line-plot/renderers line-rs))

(define line-plot-picts-with-intervals
  (for/list ([int (in-list '(5 10 15 20 25 30))])
    (line-plot/renderers (append line-rs (get-renderers int)))))

(define enum-plot-pict
  (let-values ([(d-stats _)
                (process-data
                 (extract-data/log-directory enum-dir)
                 (extract-names/log-directory enum-dir))])0
    (line-plot/renderers ((make-renderers d-stats) 'lines+xover))))