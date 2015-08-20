#lang racket

(require redex/benchmark/private/graph-data
         redex/benchmark/private/plot-lines
         plot)

(define d "/Users/burke/dev/dissertation/results/24-hr")


(define (line-plot dir [output #f])
  (parameterize ([plot-x-transform log-transform]
                 [plot-x-label "Time in Seconds"]
                 [plot-y-label "Number of Bugs Found"]
                 [plot-width 600] 
                 [plot-height 300]
                 [plot-x-ticks (log-ticks #:number 20 #:base 10)])
    (if output
        (plot-file (line-plot-renderer/log-directory dir)
                   output
                   #:x-min 0.05)
        (plot-pict (line-plot-renderer/log-directory dir)
                   #:x-min 0.05))))

(define (line-plot-renderer/log-directory dir)
  (define-values (data _)
    (process-data (extract-data/log-directory dir)
                  (extract-names/log-directory dir)))
  (make-renderers data))

(define (line-plot-renderer log-data)
  (define-values (data _)
    (process-data (extract-log-data log-data)
                  (extract-log-names log-data)))
  (make-renderers data))
                    
(define line-styles
  (list 'solid 'dot 'long-dash
        'short-dash 'dot-dash))

(define (make-renderers stats)
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
  
  (append 
   (for/list ([type+pts (in-list types+datas)]
              [n (in-naturals)])
     (define type (list-ref type+pts 0))
     (define pts (list-ref type+pts 1))
     (lines
      (reverse pts)
      ;#:width 2
      #:color ((type-colors) type)
      #:style (list-ref line-styles n)
      #:label ((type-names) type)))))


(define (sort-stats stats)
  (for/fold ([h (hash)])
    ([s (in-list stats)])
    (hash-set h (second s)
              (cons (third s)
                    (hash-ref h (second s) '())))))