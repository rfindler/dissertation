#lang racket

(require redex)

;SNIP<LANG>
(define-language arithmetic
  (e     ::= (e binop e)
              number)
  (binop ::= + - *))
;SNIP<LANG>

(define a-reduction
  (reduction-relation
   arithmetic
   (--> (in-hole E (number_1 binop number_2))
        (in-hole E
         ,((λ (n1 n2)
            (case (term binop)
              [(+) (+ n1 n2)]
              ;[(-) (- n1 n2)]
              [(*) (* n1 n2)]))
          (term number_1) (term number_1))))))

(define (red-to-number exp)
  (implies (redex-match arithmetic e exp)
           (let ([ress (apply-reduction-relation* a-reduction exp)])
             (and (= (length ress) 1)
                  (redex-match arithmetic number (car ress))))))

(redex-check arithmetic e (red-to-number (term e)))

                      
