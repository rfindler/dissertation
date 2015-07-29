#lang scribble/base

@(require "../common.rkt"
          "../util.rkt"
          "../benchmark/bug-info.rkt"
          scribble/core
          racket/match)

@title[#:tag "sec:bench-table"]{Detailed Listing of Benchmark Bugs}

@(define last-col-width 50)
@(define (break-last-cols rows)
   (let recur ([rows rows])
     (match rows
       ['() '()]
       [(cons (list a b c d (? (λ (e)
                                 ((string-length (car e)) . > . last-col-width)) e))
              rest)
        (define str (car e))
        (let loop ([n last-col-width])
          (cond
            [(= (add1 n) (string-length str))
             (cons (list a b c d e) (recur rest))]
            [(equal? #\space (string-ref str n))
             (cons (list a b c d (list (substring str 0 n)))
                   (cons (list "" "" "" "" (list (substring str (add1 n))))
                         (recur rest)))]
            [else (loop (add1 n))]))]
       [(cons this rest)
        (cons this (recur rest))])))

@(element (style "begin" '(exact-chars))
         "singlespace")

@tabular[#:sep 
           @hspace[1]
           #:column-properties '(left)
           #:row-properties '((baseline bottom-border) (baseline))
           (cons
            (list @bold{Model}
                  @bold{Bug#}
                  @bold{S/M/D/U}
                  @bold{Size}
                  @bold{Description of Bug})
            (break-last-cols
            (let ([last-type #f])
              (for/list ([t/n (in-list all-types/nums)])
                (define type (list-ref t/n 0))
                (define num (list-ref t/n 1))
                (begin0
                  (list (if (equal? last-type type)
                            ""
                            @seclink[(format "sec:b:~a" type)]{@(symbol->string type)})
                        (number->string num)
                        (symbol->string (get-category type num))
                        (number->string (get-counterexample-size type num))
                        (list (get-error type num)))
                  (set! last-type type))))))]

@(element (style "end"  '(exact-chars))
         "singlespace")