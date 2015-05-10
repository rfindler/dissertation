#lang racket

(require (only-in "examples/stlc.rkt" random-typed-term)
         redex/private/search
         redex/private/generate-term)

(provide the-trace
         the-term
         get-trace
         make-shuffler)
#;
(define the-trace
  (begin
    (enable-gen-trace!)
    (random-seed 0)
    (random-typed-term 2)
    (get-most-recent-trace)))

(define (make-shuffler refs)
  (lambda (clauses depth bound)
    ;(printf "~a ~a ~a\n" depth bound refs)
    (cond
     [(empty? refs) (shuffle clauses)]
     [else
      (define choices 
        (if (list? (car refs))
            (let ([good-refs (filter ((curry <) (length clauses)) (car refs))])
              (map (lambda (r)
                     (list-ref clauses r))
                   good-refs))
            (list (list-ref clauses (car refs)))))
      (begin0
        (append choices
                (shuffle (filter (lambda (c) (not (member c choices)))
                                 clauses)))
        (set! refs (cdr refs)))])))

(define (get-trace shuffler [depth 5])
  (parameterize ([clause-shuffle shuffler])
    (enable-gen-trace!)
    (values (random-typed-term depth)
            (get-most-recent-trace))))

(define (get-term shuffler [depth 5])
  (parameterize ([clause-shuffle shuffler])
    (random-typed-term depth)))

(define-values (the-term the-trace)
  (get-trace (make-shuffler '(2 3 2 4 0 3 2))
             4))

#|
0 : num
1 : var
2 : lam
3 : app
4 : if0
5 : plus
|#

