#lang racket

(require (only-in "examples/stlc.rkt" random-typed-term)
         redex/private/search
         redex/private/generate-term
         redex/private/pat-unify)

(provide the-trace
         the-term)


#|
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

|#

(define bogus-lang 'bogus-lang)
(define bogus-proc:...udgment-form.rkt:757:79 'bogus-proc:...udgment-form.rkt:757:79)
(define bogus-proc:...on-semantics.rkt:1550:4 'bogus-proc:...on-semantics.rkt:1550:4)

(define the-term
  '(λ (y num)
     (if0
      (+ (+ ((λ (k num) 0) 1) ((λ (Lv num) 0) 0)) y)
      (((λ (x num) (λ (SR num) 3)) y) y)
      (((λ (p ((num → num) → num)) (λ (n num) 1)) (λ (M (num → num)) 1))
       (+ y (+ 0 0))))))
(define the-trace
(list
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '()
   (clause
    '(list
      (name Γ_2 (nt Γ))
      (list λ (list (name x_3 (nt x)) (name τ_x_4 (nt τ))) (name e_5 (nt e)))
      (list (name τ_x_4 any) → (name τ_e_6 any)))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (list e-cons (name x_3 any) (name τ_x_4 any) (name Γ_2 any))
        (name e_5 any)
        (name τ_e_6 (nt τ)))))
    bogus-lang
    'tc)
   '(list • (name e_0 (nt e)) (name τ_1 (nt τ)))
   #t
   4
   (env '#hash() '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0)
   (clause
    '(list
      (name Γ_7 (nt Γ))
      (list if0 (name e_a_8 (nt e)) (name e_b_9 (nt e)) (name e_c_10 (nt e)))
      (name τ_11 any))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_7 any) (name e_a_8 any) num))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_7 any) (name e_b_9 any) (name τ_11 (nt τ))))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_7 any) (name e_c_10 any) (name τ_11 (nt τ)))))
    bogus-lang
    'tc)
   '(list
     (list e-cons (name x_3 any) (name τ_x_4 any) (name Γ_2 any))
     (name e_5 any)
     (name τ_e_6 (nt τ)))
   #t
   3
   (env
    '#hash((#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar x_3) . (nt x))
           (#s(lvar τ_e_6) . any)
           (#s(lvar e_5) . (nt e))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound))))))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0)
   (clause
    '(list
      (name Γ_12 (nt Γ))
      (list + (name e_a_13 (nt e)) (name e_b_14 (nt e)))
      num)
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_12 any) (name e_a_13 any) num))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_12 any) (name e_b_14 any) num)))
    bogus-lang
    'tc)
   '(list (name Γ_7 any) (name e_a_8 any) num)
   #t
   2
   (env
    '#hash((#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar e_a_8) . (nt e))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0 0)
   (clause
    '(list
      (name Γ_15 (nt Γ))
      (list + (name e_a_16 (nt e)) (name e_b_17 (nt e)))
      num)
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_15 any) (name e_a_16 any) num))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_15 any) (name e_b_17 any) num)))
    bogus-lang
    'tc)
   '(list (name Γ_12 any) (name e_a_13 any) num)
   #t
   1
   (env
    '#hash((#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar e_a_13) . (nt e))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "tc"
  (gen-trace
   '(0 0 0 0)
   (clause
    '(list
      (name Γ_18 (nt Γ))
      (list
       λ
       (list (name x_19 (nt x)) (name τ_x_20 (nt τ)))
       (name e_21 (nt e)))
      (list (name τ_x_20 any) → (name τ_e_22 any)))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (list e-cons (name x_19 any) (name τ_x_20 any) (name Γ_18 any))
        (name e_21 any)
        (name τ_e_22 (nt τ)))))
    bogus-lang
    'tc)
   '(list (name Γ_15 any) (name e_a_16 any) num)
   #f
   0
   (env
    '#hash((#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17) . (nt e))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16) . (nt e))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0 0 0)
   (clause
    '(list
      (name Γ_23 (nt Γ))
      (list (name e_a_24 (nt e)) (name e_b_25 (nt e)))
      (name τ_26 any))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (name Γ_23 any)
        (name e_a_24 any)
        (list (name τ_2_27 (nt τ)) → (name τ_26 (nt τ)))))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_23 any) (name e_b_25 any) (name τ_2_27 (nt τ)))))
    bogus-lang
    'tc)
   '(list (name Γ_15 any) (name e_a_16 any) num)
   #t
   0
   (env
    '#hash((#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17) . (nt e))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16) . (nt e))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "tc"
  (gen-trace
   '(0 0 0 0 0)
   (clause
    '(list (name Γ_28 (nt Γ)) (name n_29 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list
     (name Γ_23 any)
     (name e_a_24 any)
     (list (name τ_2_27 (nt τ)) → (name τ_26 (nt τ))))
   #f
   -1
   (env
    '#hash((#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . num)
           (#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17) . (nt e))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24) . (nt e))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (nt e))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0 0 0 0)
   (clause
    '(list
      (name Γ_30 (nt Γ))
      (list
       λ
       (list (name x_31 (nt x)) (name τ_x_32 (nt τ)))
       (name e_33 (nt e)))
      (list (name τ_x_32 any) → (name τ_e_34 any)))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (list e-cons (name x_31 any) (name τ_x_32 any) (name Γ_30 any))
        (name e_33 any)
        (name τ_e_34 (nt τ)))))
    bogus-lang
    'tc)
   '(list
     (name Γ_23 any)
     (name e_a_24 any)
     (list (name τ_2_27 (nt τ)) → (name τ_26 (nt τ))))
   #t
   -1
   (env
    '#hash((#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . num)
           (#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17) . (nt e))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24) . (nt e))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (nt e))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0 0 0 0 0)
   (clause
    '(list (name Γ_35 (nt Γ)) (name n_36 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list
     (list e-cons (name x_31 any) (name τ_x_32 any) (name Γ_30 any))
     (name e_33 any)
     (name τ_e_34 (nt τ)))
   #t
   -2
   (env
    '#hash((#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar τ_2_27) . (cstr (τ) any))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar e_33) . (nt e))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17) . (nt e))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar x_31) . (nt x))
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (nt e))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(1 0 0 0 0)
   (clause
    '(list (name Γ_37 (nt Γ)) (name n_38 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list (name Γ_23 any) (name e_b_25 any) (name τ_2_27 (nt τ)))
   #t
   -1
   (env
    '#hash((#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar τ_2_27) . (cstr (τ) any))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17) . (nt e))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (nt e))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "tc"
  (gen-trace
   '(1 0 0 0)
   (clause
    '(list
      (name Γ_39 (nt Γ))
      (list
       λ
       (list (name x_40 (nt x)) (name τ_x_41 (nt τ)))
       (name e_42 (nt e)))
      (list (name τ_x_41 any) → (name τ_e_43 any)))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (list e-cons (name x_40 any) (name τ_x_41 any) (name Γ_39 any))
        (name e_42 any)
        (name τ_e_43 (nt τ)))))
    bogus-lang
    'tc)
   '(list (name Γ_15 any) (name e_b_17 any) num)
   #f
   0
   (env
    '#hash((#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17) . (nt e))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(1 0 0 0)
   (clause
    '(list
      (name Γ_44 (nt Γ))
      (list (name e_a_45 (nt e)) (name e_b_46 (nt e)))
      (name τ_47 any))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (name Γ_44 any)
        (name e_a_45 any)
        (list (name τ_2_48 (nt τ)) → (name τ_47 (nt τ)))))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_44 any) (name e_b_46 any) (name τ_2_48 (nt τ)))))
    bogus-lang
    'tc)
   '(list (name Γ_15 any) (name e_b_17 any) num)
   #t
   0
   (env
    '#hash((#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17) . (nt e))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "tc"
  (gen-trace
   '(0 1 0 0 0)
   (clause
    '(list (name Γ_49 (nt Γ)) (name n_50 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list
     (name Γ_44 any)
     (name e_a_45 any)
     (list (name τ_2_48 (nt τ)) → (name τ_47 (nt τ))))
   #f
   -1
   (env
    '#hash((#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45) . (nt e))
           (#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_47) . num)
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar e_b_46) . (nt e))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 1 0 0 0)
   (clause
    '(list
      (name Γ_51 (nt Γ))
      (list
       λ
       (list (name x_52 (nt x)) (name τ_x_53 (nt τ)))
       (name e_54 (nt e)))
      (list (name τ_x_53 any) → (name τ_e_55 any)))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (list e-cons (name x_52 any) (name τ_x_53 any) (name Γ_51 any))
        (name e_54 any)
        (name τ_e_55 (nt τ)))))
    bogus-lang
    'tc)
   '(list
     (name Γ_44 any)
     (name e_a_45 any)
     (list (name τ_2_48 (nt τ)) → (name τ_47 (nt τ))))
   #t
   -1
   (env
    '#hash((#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45) . (nt e))
           (#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_47) . num)
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar e_b_46) . (nt e))
           (#s(lvar τ_11) . #s(lvar τ_e_6)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0 1 0 0 0)
   (clause
    '(list (name Γ_56 (nt Γ)) (name n_57 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list
     (list e-cons (name x_52 any) (name τ_x_53 any) (name Γ_51 any))
     (name e_54 any)
     (name τ_e_55 (nt τ)))
   #t
   -2
   (env
    '#hash((#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . (nt x))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (nt e))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar e_b_46) . (nt e))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar τ_2_48) . (cstr (τ) any))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(1 1 0 0 0)
   (clause
    '(list (name Γ_58 (nt Γ)) (name n_59 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list (name Γ_44 any) (name e_b_46 any) (name τ_2_48 (nt τ)))
   #t
   -1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar e_b_46) . (nt e))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar τ_2_48) . (cstr (τ) any))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(1 0 0)
   (clause
    '(list (name Γ_60 (nt Γ)) (name x_61 (nt x)) (name τ_62 any))
    (list (eqn '(name τ_62 (nt τ)) '(name f-results64_63 any)))
    (list
     (prem
      bogus-proc:...on-semantics.rkt:1550:4
      '(list
        (list (name Γ_60 any) (name x_61 any))
        (name f-results64_63 any))))
    bogus-lang
    'tc)
   '(list (name Γ_12 any) (name e_b_14 any) num)
   #t
   1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar e_b_14) . (nt e))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: lookup"
  (gen-trace
   '(0 1 0 0)
   (clause
    '(list
      (list
       (list e-cons (name x_64 (nt x)) (name τ_65 (nt τ)) (name Γ_66 (nt Γ)))
       (name x_64 (nt x)))
      (name τ_65 any))
    '()
    '()
    bogus-lang
    'lookup)
   '(list (list (name Γ_60 any) (name x_61 any)) (name f-results64_63 any))
   #t
   0
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . (cstr (τ) any))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_62) . (cstr (τ) num))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(1 0)
   (clause
    '(list
      (name Γ_67 (nt Γ))
      (list (name e_a_68 (nt e)) (name e_b_69 (nt e)))
      (name τ_70 any))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (name Γ_67 any)
        (name e_a_68 any)
        (list (name τ_2_71 (nt τ)) → (name τ_70 (nt τ)))))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_67 any) (name e_b_69 any) (name τ_2_71 (nt τ)))))
    bogus-lang
    'tc)
   '(list (name Γ_7 any) (name e_b_9 any) (name τ_11 (nt τ)))
   #t
   2
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9) . (nt e))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_62) . (cstr (τ) num))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 1 0)
   (clause
    '(list
      (name Γ_72 (nt Γ))
      (list (name e_a_73 (nt e)) (name e_b_74 (nt e)))
      (name τ_75 any))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (name Γ_72 any)
        (name e_a_73 any)
        (list (name τ_2_76 (nt τ)) → (name τ_75 (nt τ)))))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_72 any) (name e_b_74 any) (name τ_2_76 (nt τ)))))
    bogus-lang
    'tc)
   '(list
     (name Γ_67 any)
     (name e_a_68 any)
     (list (name τ_2_71 (nt τ)) → (name τ_70 (nt τ))))
   #t
   1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68) . (nt e))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . (cstr (τ) num))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_69) . (nt e))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0 1 0)
   (clause
    '(list
      (name Γ_77 (nt Γ))
      (list
       λ
       (list (name x_78 (nt x)) (name τ_x_79 (nt τ)))
       (name e_80 (nt e)))
      (list (name τ_x_79 any) → (name τ_e_81 any)))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (list e-cons (name x_78 any) (name τ_x_79 any) (name Γ_77 any))
        (name e_80 any)
        (name τ_e_81 (nt τ)))))
    bogus-lang
    'tc)
   '(list
     (name Γ_72 any)
     (name e_a_73 any)
     (list (name τ_2_76 (nt τ)) → (name τ_75 (nt τ))))
   #t
   0
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . (nt e))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (nt τ))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . (cstr (τ) num))
           (#s(lvar e_a_73) . (nt e))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_69) . (nt e))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "tc"
  (gen-trace
   '(0 0 0 1 0)
   (clause
    '(list (name Γ_82 (nt Γ)) (name n_83 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list
     (list e-cons (name x_78 any) (name τ_x_79 any) (name Γ_77 any))
     (name e_80 any)
     (name τ_e_81 (nt τ)))
   #f
   -1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . (nt e))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (nt τ))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80) . (nt e))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar x_78) . (nt x))
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . (cstr (τ) num))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_69) . (nt e))
           (#s(lvar τ_2_76) . (cstr (τ) any))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0 0 1 0)
   (clause
    '(list
      (name Γ_84 (nt Γ))
      (list
       λ
       (list (name x_85 (nt x)) (name τ_x_86 (nt τ)))
       (name e_87 (nt e)))
      (list (name τ_x_86 any) → (name τ_e_88 any)))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (list e-cons (name x_85 any) (name τ_x_86 any) (name Γ_84 any))
        (name e_87 any)
        (name τ_e_88 (nt τ)))))
    bogus-lang
    'tc)
   '(list
     (list e-cons (name x_78 any) (name τ_x_79 any) (name Γ_77 any))
     (name e_80 any)
     (name τ_e_81 (nt τ)))
   #t
   -1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . (nt e))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (nt τ))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80) . (nt e))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar x_78) . (nt x))
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . (cstr (τ) num))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_69) . (nt e))
           (#s(lvar τ_2_76) . (cstr (τ) any))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0 0 0 1 0)
   (clause
    '(list (name Γ_89 (nt Γ)) (name n_90 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list
     (list e-cons (name x_85 any) (name τ_x_86 any) (name Γ_84 any))
     (name e_87 any)
     (name τ_e_88 (nt τ)))
   #t
   -2
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . (nt e))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) any))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_87) . (nt e))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) any))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . (cstr (τ) num))
           (#s(lvar x_85) . (nt x))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_69) . (nt e))
           (#s(lvar τ_2_76) . (cstr (τ) any))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(1 0 1 0)
   (clause
    '(list (name Γ_91 (nt Γ)) (name x_92 (nt x)) (name τ_93 any))
    (list (eqn '(name τ_93 (nt τ)) '(name f-results64_94 any)))
    (list
     (prem
      bogus-proc:...on-semantics.rkt:1550:4
      '(list
        (list (name Γ_91 any) (name x_92 any))
        (name f-results64_94 any))))
    bogus-lang
    'tc)
   '(list (name Γ_72 any) (name e_b_74 any) (name τ_2_76 (nt τ)))
   #t
   0
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . (nt e))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) any))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . (cstr (τ) num))
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_69) . (nt e))
           (#s(lvar τ_2_76) . (cstr (τ) any))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: lookup"
  (gen-trace
   '(0 1 0 1 0)
   (clause
    '(list
      (list
       (list e-cons (name x_95 (nt x)) (name τ_96 (nt τ)) (name Γ_97 (nt Γ)))
       (name x_95 (nt x)))
      (name τ_96 any))
    '()
    '()
    bogus-lang
    'lookup)
   '(list (list (name Γ_91 any) (name x_92 any)) (name f-results64_94 any))
   #t
   -1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) any))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_3 #s(bound))
              (name τ_x_4 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . (cstr (τ) num))
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar e_b_69) . (nt e))
           (#s(lvar τ_2_76) . (cstr (τ) any))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(1 1 0)
   (clause
    '(list (name Γ_98 (nt Γ)) (name x_99 (nt x)) (name τ_100 any))
    (list (eqn '(name τ_100 (nt τ)) '(name f-results64_101 any)))
    (list
     (prem
      bogus-proc:...on-semantics.rkt:1550:4
      '(list
        (list (name Γ_98 any) (name x_99 any))
        (name f-results64_101 any))))
    bogus-lang
    'tc)
   '(list (name Γ_67 any) (name e_b_69 any) (name τ_2_71 (nt τ)))
   #t
   1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) any))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_14 #s(bound))
              (name τ_62 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar e_b_69) . (nt e))
           (#s(lvar τ_2_76) . (cstr (τ) num))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: lookup"
  (gen-trace
   '(0 1 1 0)
   (clause
    '(list
      (list
       (list
        e-cons
        (name x_102 (nt x))
        (name τ_103 (nt τ))
        (name Γ_104 (nt Γ)))
       (name x_102 (nt x)))
      (name τ_103 any))
    '()
    '()
    bogus-lang
    'lookup)
   '(list (list (name Γ_98 any) (name x_99 any)) (name f-results64_101 any))
   #t
   0
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) any))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_14 #s(bound))
              (name τ_62 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_2_76) . (cstr (τ) num))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(2 0)
   (clause
    '(list
      (name Γ_105 (nt Γ))
      (list (name e_a_106 (nt e)) (name e_b_107 (nt e)))
      (name τ_108 any))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (name Γ_105 any)
        (name e_a_106 any)
        (list (name τ_2_109 (nt τ)) → (name τ_108 (nt τ)))))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_105 any) (name e_b_107 any) (name τ_2_109 (nt τ)))))
    bogus-lang
    'tc)
   '(list (name Γ_7 any) (name e_c_10 any) (name τ_11 (nt τ)))
   #t
   2
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_c_10) . (nt e))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_74 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 2 0)
   (clause
    '(list
      (name Γ_110 (nt Γ))
      (list (name e_a_111 (nt e)) (name e_b_112 (nt e)))
      (name τ_113 any))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (name Γ_110 any)
        (name e_a_111 any)
        (list (name τ_2_114 (nt τ)) → (name τ_113 (nt τ)))))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_110 any) (name e_b_112 any) (name τ_2_114 (nt τ)))))
    bogus-lang
    'tc)
   '(list
     (name Γ_105 any)
     (name e_a_106 any)
     (list (name τ_2_109 (nt τ)) → (name τ_108 (nt τ))))
   #t
   1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106) . (nt e))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_74 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107) . (nt e))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0 2 0)
   (clause
    '(list
      (name Γ_115 (nt Γ))
      (list
       λ
       (list (name x_116 (nt x)) (name τ_x_117 (nt τ)))
       (name e_118 (nt e)))
      (list (name τ_x_117 any) → (name τ_e_119 any)))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (list e-cons (name x_116 any) (name τ_x_117 any) (name Γ_115 any))
        (name e_118 any)
        (name τ_e_119 (nt τ)))))
    bogus-lang
    'tc)
   '(list
     (name Γ_110 any)
     (name e_a_111 any)
     (list (name τ_2_114 (nt τ)) → (name τ_113 (nt τ))))
   #t
   0
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111) . (nt e))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_74 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107) . (nt e))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (nt τ))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112) . (nt e))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "tc"
  (gen-trace
   '(0 0 0 2 0)
   (clause
    '(list (name Γ_120 (nt Γ)) (name n_121 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list
     (list e-cons (name x_116 any) (name τ_x_117 any) (name Γ_115 any))
     (name e_118 any)
     (name τ_e_119 (nt τ)))
   #f
   -1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114) . (cstr (τ) any))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118) . (nt e))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . (nt x))
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_74 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107) . (nt e))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (nt τ))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112) . (nt e))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0 0 2 0)
   (clause
    '(list
      (name Γ_122 (nt Γ))
      (list
       λ
       (list (name x_123 (nt x)) (name τ_x_124 (nt τ)))
       (name e_125 (nt e)))
      (list (name τ_x_124 any) → (name τ_e_126 any)))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (list e-cons (name x_123 any) (name τ_x_124 any) (name Γ_122 any))
        (name e_125 any)
        (name τ_e_126 (nt τ)))))
    bogus-lang
    'tc)
   '(list
     (list e-cons (name x_116 any) (name τ_x_117 any) (name Γ_115 any))
     (name e_118 any)
     (name τ_e_119 (nt τ)))
   #t
   -1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114) . (cstr (τ) any))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118) . (nt e))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . (nt x))
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_74 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107) . (nt e))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (nt τ))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112) . (nt e))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 0 0 0 2 0)
   (clause
    '(list (name Γ_127 (nt Γ)) (name n_128 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list
     (list e-cons (name x_123 any) (name τ_x_124 any) (name Γ_122 any))
     (name e_125 any)
     (name τ_e_126 (nt τ)))
   #t
   -2
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_122)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_116 #s(bound))
              (name τ_2_114 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_125) . (nt e))
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114) . (cstr (τ) any))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_x_124) . #s(lvar τ_2_109))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_123 #s(bound)) (name τ_x_124 #s(bound)))
              (name e_125 #s(bound)))))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar τ_e_126) . #s(lvar τ_e_6))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_74 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107) . (nt e))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (cstr (τ) any))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar x_123) . (nt x))
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112) . (nt e))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(1 0 2 0)
   (clause
    '(list
      (name Γ_129 (nt Γ))
      (list
       λ
       (list (name x_130 (nt x)) (name τ_x_131 (nt τ)))
       (name e_132 (nt e)))
      (list (name τ_x_131 any) → (name τ_e_133 any)))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (list e-cons (name x_130 any) (name τ_x_131 any) (name Γ_129 any))
        (name e_132 any)
        (name τ_e_133 (nt τ)))))
    bogus-lang
    'tc)
   '(list (name Γ_110 any) (name e_b_112 any) (name τ_2_114 (nt τ)))
   #t
   0
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_122)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_116 #s(bound))
              (name τ_2_114 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_125) . (cstr (e) number))
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar Γ_127)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_123 #s(bound))
              (name τ_2_109 #s(bound))
              (name Γ_122 #s(bound)))))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114) . (cstr (τ) any))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_x_124) . #s(lvar τ_2_109))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_123 #s(bound)) (name τ_x_124 #s(bound)))
              (name e_125 #s(bound)))))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar τ_e_126) . #s(lvar τ_e_6))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_74 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107) . (nt e))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (cstr (τ) any))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar x_123) . variable-not-otherwise-mentioned)
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112) . (nt e))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar n_128) . #s(lvar e_125))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 1 0 2 0)
   (clause
    '(list (name Γ_134 (nt Γ)) (name n_135 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list
     (list e-cons (name x_130 any) (name τ_x_131 any) (name Γ_129 any))
     (name e_132 any)
     (name τ_e_133 (nt τ)))
   #t
   -1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_e_133) . any)
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar x_130) . (nt x))
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_122)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_116 #s(bound))
              (name τ_2_114 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar e_132) . (nt e))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_125) . (cstr (e) number))
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar Γ_127)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_123 #s(bound))
              (name τ_2_109 #s(bound))
              (name Γ_122 #s(bound)))))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114)
            .
            (cstr
             (τ)
             (list (name τ_x_131 #s(bound)) → (name τ_e_133 #s(bound)))))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_x_124) . #s(lvar τ_2_109))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_123 #s(bound)) (name τ_x_124 #s(bound)))
              (name e_125 #s(bound)))))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar τ_e_126) . #s(lvar τ_e_6))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_74 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107) . (nt e))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (cstr (τ) any))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar Γ_129) . #s(lvar Γ_7))
           (#s(lvar x_123) . variable-not-otherwise-mentioned)
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_130 #s(bound)) (name τ_x_131 #s(bound)))
              (name e_132 #s(bound)))))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar n_128) . #s(lvar e_125))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_x_131) . (cstr (τ) any))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(1 2 0)
   (clause
    '(list
      (name Γ_136 (nt Γ))
      (list + (name e_a_137 (nt e)) (name e_b_138 (nt e)))
      num)
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_136 any) (name e_a_137 any) num))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_136 any) (name e_b_138 any) num)))
    bogus-lang
    'tc)
   '(list (name Γ_105 any) (name e_b_107 any) (name τ_2_109 (nt τ)))
   #t
   1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_e_133) . (cstr (τ) num))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar x_130) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_122)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_116 #s(bound))
              (name τ_2_114 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar e_132) . (cstr (e) number))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_125) . (cstr (e) number))
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar Γ_127)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_123 #s(bound))
              (name τ_2_109 #s(bound))
              (name Γ_122 #s(bound)))))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114)
            .
            (cstr
             (τ)
             (list (name τ_x_131 #s(bound)) → (name τ_e_133 #s(bound)))))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_x_124) . #s(lvar τ_2_109))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_123 #s(bound)) (name τ_x_124 #s(bound)))
              (name e_125 #s(bound)))))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar τ_e_126) . #s(lvar τ_e_6))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_74 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107) . (nt e))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar n_135) . #s(lvar e_132))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (cstr (τ) any))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar Γ_129) . #s(lvar Γ_7))
           (#s(lvar x_123) . variable-not-otherwise-mentioned)
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar Γ_134)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_130 #s(bound))
              (name τ_x_131 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_130 #s(bound)) (name τ_x_131 #s(bound)))
              (name e_132 #s(bound)))))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar n_128) . #s(lvar e_125))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_x_131) . (cstr (τ) any))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 1 2 0)
   (clause
    '(list (name Γ_139 (nt Γ)) (name x_140 (nt x)) (name τ_141 any))
    (list (eqn '(name τ_141 (nt τ)) '(name f-results64_142 any)))
    (list
     (prem
      bogus-proc:...on-semantics.rkt:1550:4
      '(list
        (list (name Γ_139 any) (name x_140 any))
        (name f-results64_142 any))))
    bogus-lang
    'tc)
   '(list (name Γ_136 any) (name e_a_137 any) num)
   #t
   0
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_e_133) . (cstr (τ) num))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar x_130) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar e_b_138) . (nt e))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_122)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_116 #s(bound))
              (name τ_2_114 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar e_132) . (cstr (e) number))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_125) . (cstr (e) number))
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar Γ_127)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_123 #s(bound))
              (name τ_2_109 #s(bound))
              (name Γ_122 #s(bound)))))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114)
            .
            (cstr
             (τ)
             (list (name τ_x_131 #s(bound)) → (name τ_e_133 #s(bound)))))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_x_124) . #s(lvar τ_2_109))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_123 #s(bound)) (name τ_x_124 #s(bound)))
              (name e_125 #s(bound)))))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar τ_e_126) . #s(lvar τ_e_6))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_74 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107)
            .
            (cstr
             (e)
             (list + (name e_a_137 #s(bound)) (name e_b_138 #s(bound)))))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar n_135) . #s(lvar e_132))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar Γ_136) . #s(lvar Γ_7))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (cstr (τ) num))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar Γ_129) . #s(lvar Γ_7))
           (#s(lvar x_123) . variable-not-otherwise-mentioned)
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar e_a_137) . (nt e))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar Γ_134)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_130 #s(bound))
              (name τ_x_131 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_130 #s(bound)) (name τ_x_131 #s(bound)))
              (name e_132 #s(bound)))))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar n_128) . #s(lvar e_125))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_x_131) . (cstr (τ) any))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: lookup"
  (gen-trace
   '(0 0 1 2 0)
   (clause
    '(list
      (list
       (list
        e-cons
        (name x_143 (nt x))
        (name τ_144 (nt τ))
        (name Γ_145 (nt Γ)))
       (name x_143 (nt x)))
      (name τ_144 any))
    '()
    '()
    bogus-lang
    'lookup)
   '(list (list (name Γ_139 any) (name x_140 any)) (name f-results64_142 any))
   #t
   -1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_e_133) . (cstr (τ) num))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar x_130) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar e_b_138) . (nt e))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_122)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_116 #s(bound))
              (name τ_2_114 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar e_132) . (cstr (e) number))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_125) . (cstr (e) number))
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . (cstr (τ) num))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar Γ_127)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_123 #s(bound))
              (name τ_2_109 #s(bound))
              (name Γ_122 #s(bound)))))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114)
            .
            (cstr
             (τ)
             (list (name τ_x_131 #s(bound)) → (name τ_e_133 #s(bound)))))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_x_124) . #s(lvar τ_2_109))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_123 #s(bound)) (name τ_x_124 #s(bound)))
              (name e_125 #s(bound)))))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar τ_e_126) . #s(lvar τ_e_6))
           (#s(lvar τ_141) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_74 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107)
            .
            (cstr
             (e)
             (list + (name e_a_137 #s(bound)) (name e_b_138 #s(bound)))))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar n_135) . #s(lvar e_132))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar Γ_136) . #s(lvar Γ_7))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (cstr (τ) num))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar x_140) . #s(lvar e_a_137))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar Γ_129) . #s(lvar Γ_7))
           (#s(lvar x_123) . variable-not-otherwise-mentioned)
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar e_a_137) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar Γ_139) . #s(lvar Γ_7))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar Γ_134)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_130 #s(bound))
              (name τ_x_131 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar f-results64_142) . #s(lvar τ_141))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_130 #s(bound)) (name τ_x_131 #s(bound)))
              (name e_132 #s(bound)))))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar n_128) . #s(lvar e_125))
           (#s(lvar e_b_69) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_x_131) . (cstr (τ) any))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "tc"
  (gen-trace
   '(1 1 2 0)
   (clause
    '(list
      (name Γ_146 (nt Γ))
      (list
       λ
       (list (name x_147 (nt x)) (name τ_x_148 (nt τ)))
       (name e_149 (nt e)))
      (list (name τ_x_148 any) → (name τ_e_150 any)))
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list
        (list e-cons (name x_147 any) (name τ_x_148 any) (name Γ_146 any))
        (name e_149 any)
        (name τ_e_150 (nt τ)))))
    bogus-lang
    'tc)
   '(list (name Γ_136 any) (name e_b_138 any) num)
   #f
   0
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_e_133) . (cstr (τ) num))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar x_130) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar e_b_138) . (nt e))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_122)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_116 #s(bound))
              (name τ_2_114 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar τ_144) . #s(lvar τ_2_71))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar e_132) . (cstr (e) number))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_125) . (cstr (e) number))
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . #s(lvar τ_141))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar Γ_127)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_123 #s(bound))
              (name τ_2_109 #s(bound))
              (name Γ_122 #s(bound)))))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114)
            .
            (cstr
             (τ)
             (list (name τ_x_131 #s(bound)) → (name τ_e_133 #s(bound)))))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_x_124) . #s(lvar τ_2_109))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_123 #s(bound)) (name τ_x_124 #s(bound)))
              (name e_125 #s(bound)))))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar τ_e_126) . #s(lvar τ_e_6))
           (#s(lvar τ_141) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_69 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107)
            .
            (cstr
             (e)
             (list + (name e_a_137 #s(bound)) (name e_b_138 #s(bound)))))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar n_135) . #s(lvar e_132))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar Γ_136) . #s(lvar Γ_7))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (cstr (τ) num))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar x_140) . #s(lvar e_a_137))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar Γ_145) . #s(lvar Γ_2))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar Γ_129) . #s(lvar Γ_7))
           (#s(lvar x_123) . variable-not-otherwise-mentioned)
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar e_a_137) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar Γ_139) . #s(lvar Γ_7))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar Γ_134)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_130 #s(bound))
              (name τ_x_131 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar f-results64_142) . #s(lvar τ_141))
           (#s(lvar x_143) . #s(lvar e_b_69))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_130 #s(bound)) (name τ_x_131 #s(bound)))
              (name e_132 #s(bound)))))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar n_128) . #s(lvar e_125))
           (#s(lvar e_b_69) . #s(lvar e_a_137))
           (#s(lvar τ_x_131) . (cstr (τ) any))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(1 1 2 0)
   (clause
    '(list
      (name Γ_151 (nt Γ))
      (list + (name e_a_152 (nt e)) (name e_b_153 (nt e)))
      num)
    '()
    (list
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_151 any) (name e_a_152 any) num))
     (prem
      bogus-proc:...udgment-form.rkt:757:79
      '(list (name Γ_151 any) (name e_b_153 any) num)))
    bogus-lang
    'tc)
   '(list (name Γ_136 any) (name e_b_138 any) num)
   #t
   0
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_e_133) . (cstr (τ) num))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar x_130) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar e_b_138) . (nt e))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_122)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_116 #s(bound))
              (name τ_2_114 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar τ_144) . #s(lvar τ_2_71))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar e_132) . (cstr (e) number))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_125) . (cstr (e) number))
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . #s(lvar τ_141))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar Γ_127)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_123 #s(bound))
              (name τ_2_109 #s(bound))
              (name Γ_122 #s(bound)))))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114)
            .
            (cstr
             (τ)
             (list (name τ_x_131 #s(bound)) → (name τ_e_133 #s(bound)))))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_x_124) . #s(lvar τ_2_109))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_123 #s(bound)) (name τ_x_124 #s(bound)))
              (name e_125 #s(bound)))))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar τ_e_126) . #s(lvar τ_e_6))
           (#s(lvar τ_141) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_69 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar e_b_107)
            .
            (cstr
             (e)
             (list + (name e_a_137 #s(bound)) (name e_b_138 #s(bound)))))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar n_135) . #s(lvar e_132))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar Γ_136) . #s(lvar Γ_7))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (cstr (τ) num))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar x_140) . #s(lvar e_a_137))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar Γ_145) . #s(lvar Γ_2))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar Γ_129) . #s(lvar Γ_7))
           (#s(lvar x_123) . variable-not-otherwise-mentioned)
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar e_a_137) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar Γ_139) . #s(lvar Γ_7))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar Γ_134)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_130 #s(bound))
              (name τ_x_131 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar f-results64_142) . #s(lvar τ_141))
           (#s(lvar x_143) . #s(lvar e_b_69))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_130 #s(bound)) (name τ_x_131 #s(bound)))
              (name e_132 #s(bound)))))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar n_128) . #s(lvar e_125))
           (#s(lvar e_b_69) . #s(lvar e_a_137))
           (#s(lvar τ_x_131) . (cstr (τ) any))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(0 1 1 2 0)
   (clause
    '(list (name Γ_154 (nt Γ)) (name n_155 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list (name Γ_151 any) (name e_a_152 any) num)
   #t
   -1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_e_133) . (cstr (τ) num))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar x_130) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar e_b_138)
            .
            (cstr
             (e)
             (list + (name e_a_152 #s(bound)) (name e_b_153 #s(bound)))))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_122)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_116 #s(bound))
              (name τ_2_114 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar e_b_153) . (nt e))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar τ_144) . #s(lvar τ_2_71))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar e_132) . (cstr (e) number))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_125) . (cstr (e) number))
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . #s(lvar τ_141))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar Γ_127)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_123 #s(bound))
              (name τ_2_109 #s(bound))
              (name Γ_122 #s(bound)))))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114)
            .
            (cstr
             (τ)
             (list (name τ_x_131 #s(bound)) → (name τ_e_133 #s(bound)))))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_x_124) . #s(lvar τ_2_109))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar e_a_152) . (nt e))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_123 #s(bound)) (name τ_x_124 #s(bound)))
              (name e_125 #s(bound)))))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar τ_e_126) . #s(lvar τ_e_6))
           (#s(lvar τ_141) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_69 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar Γ_151) . #s(lvar Γ_7))
           (#s(lvar e_b_107)
            .
            (cstr
             (e)
             (list + (name e_a_137 #s(bound)) (name e_b_138 #s(bound)))))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar n_135) . #s(lvar e_132))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar Γ_136) . #s(lvar Γ_7))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (cstr (τ) num))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar x_140) . #s(lvar e_a_137))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar Γ_145) . #s(lvar Γ_2))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar Γ_129) . #s(lvar Γ_7))
           (#s(lvar x_123) . variable-not-otherwise-mentioned)
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar e_a_137) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar Γ_139) . #s(lvar Γ_7))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar Γ_134)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_130 #s(bound))
              (name τ_x_131 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar f-results64_142) . #s(lvar τ_141))
           (#s(lvar x_143) . #s(lvar e_b_69))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_130 #s(bound)) (name τ_x_131 #s(bound)))
              (name e_132 #s(bound)))))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar n_128) . #s(lvar e_125))
           (#s(lvar e_b_69) . #s(lvar e_a_137))
           (#s(lvar τ_x_131) . (cstr (τ) any))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)
 (vector
  'info
  "generation-log: tc"
  (gen-trace
   '(1 1 1 2 0)
   (clause
    '(list (name Γ_156 (nt Γ)) (name n_157 (nt n)) num)
    '()
    '()
    bogus-lang
    'tc)
   '(list (name Γ_151 any) (name e_b_153 any) num)
   #t
   -1
   (env
    '#hash((#s(lvar Γ_56)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_52 #s(bound))
              (name τ_2_48 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_e_133) . (cstr (τ) num))
           (#s(lvar Γ_77) . #s(lvar Γ_7))
           (#s(lvar x_130) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_110) . #s(lvar Γ_7))
           (#s(lvar e_b_138)
            .
            (cstr
             (e)
             (list + (name e_a_152 #s(bound)) (name e_b_153 #s(bound)))))
           (#s(lvar Γ_23) . #s(lvar Γ_7))
           (#s(lvar Γ_122)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_116 #s(bound))
              (name τ_2_114 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar n_155) . #s(lvar e_a_152))
           (#s(lvar Γ_98) . #s(lvar Γ_7))
           (#s(lvar τ_26) . (cstr (τ) num))
           (#s(lvar e_a_45)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_52 #s(bound)) (name τ_x_53 #s(bound)))
              (name e_54 #s(bound)))))
           (#s(lvar e_b_153) . (nt e))
           (#s(lvar x_61) . #s(lvar e_b_14))
           (#s(lvar e_b_14) . #s(lvar e_b_74))
           (#s(lvar Γ_154) . #s(lvar Γ_7))
           (#s(lvar τ_47) . (cstr (τ) num))
           (#s(lvar x_64) . #s(lvar x_3))
           (#s(lvar τ_1)
            .
            (cstr (τ) (list (name τ_x_4 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar τ_100) . #s(lvar τ_2_71))
           (#s(lvar Γ_105) . #s(lvar Γ_7))
           (#s(lvar Γ_91) . #s(lvar Γ_7))
           (#s(lvar τ_144) . #s(lvar τ_2_71))
           (#s(lvar Γ_84)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_78 #s(bound))
              (name τ_2_76 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar Γ_37) . #s(lvar Γ_7))
           (#s(lvar τ_e_34) . #s(lvar τ_26))
           (#s(lvar e_132) . (cstr (e) number))
           (#s(lvar Γ_67) . #s(lvar Γ_7))
           (#s(lvar τ_108) . #s(lvar τ_e_6))
           (#s(lvar τ_e_88) . #s(lvar τ_e_6))
           (#s(lvar Γ_89)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_85 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_84 #s(bound)))))
           (#s(lvar τ_2_27) . (cstr (τ) num))
           (#s(lvar x_52) . variable-not-otherwise-mentioned)
           (#s(lvar e_125) . (cstr (e) number))
           (#s(lvar e_b_74) . #s(lvar e_b_69))
           (#s(lvar Γ_72) . #s(lvar Γ_7))
           (#s(lvar τ_2_71) . #s(lvar τ_141))
           (#s(lvar n_38) . #s(lvar e_b_25))
           (#s(lvar e_a_111)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_116 #s(bound)) (name τ_x_117 #s(bound)))
              (name e_118 #s(bound)))))
           (#s(lvar e_87) . (cstr (e) number))
           (#s(lvar Γ_30) . #s(lvar Γ_7))
           (#s(lvar Γ_66) . #s(lvar Γ_2))
           (#s(lvar e_b_9)
            .
            (cstr (e) (list (name e_a_68 #s(bound)) (name e_b_69 #s(bound)))))
           (#s(lvar τ_113)
            .
            (cstr
             (τ)
             (list (name τ_2_109 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar e_33) . (cstr (e) number))
           (#s(lvar e_54) . (cstr (e) number))
           (#s(lvar Γ_127)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_123 #s(bound))
              (name τ_2_109 #s(bound))
              (name Γ_122 #s(bound)))))
           (#s(lvar e_80)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_85 #s(bound)) (name τ_x_86 #s(bound)))
              (name e_87 #s(bound)))))
           (#s(lvar τ_e_55) . #s(lvar τ_47))
           (#s(lvar Γ_2) . (cstr (Γ) •))
           (#s(lvar e_b_17)
            .
            (cstr (e) (list (name e_a_45 #s(bound)) (name e_b_46 #s(bound)))))
           (#s(lvar x_3) . #s(lvar e_b_14))
           (#s(lvar e_a_68)
            .
            (cstr (e) (list (name e_a_73 #s(bound)) (name e_b_74 #s(bound)))))
           (#s(lvar e_a_16)
            .
            (cstr (e) (list (name e_a_24 #s(bound)) (name e_b_25 #s(bound)))))
           (#s(lvar Γ_115) . #s(lvar Γ_7))
           (#s(lvar n_36) . #s(lvar e_33))
           (#s(lvar τ_2_114)
            .
            (cstr
             (τ)
             (list (name τ_x_131 #s(bound)) → (name τ_e_133 #s(bound)))))
           (#s(lvar f-results64_101) . #s(lvar τ_2_71))
           (#s(lvar τ_x_124) . #s(lvar τ_2_109))
           (#s(lvar τ_e_81) . #s(lvar τ_75))
           (#s(lvar e_a_106)
            .
            (cstr
             (e)
             (list (name e_a_111 #s(bound)) (name e_b_112 #s(bound)))))
           (#s(lvar e_c_10)
            .
            (cstr
             (e)
             (list (name e_a_106 #s(bound)) (name e_b_107 #s(bound)))))
           (#s(lvar f-results64_63) . #s(lvar τ_62))
           (#s(lvar e_a_152) . (cstr (e) number))
           (#s(lvar τ_e_119) . #s(lvar τ_113))
           (#s(lvar e_118)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_123 #s(bound)) (name τ_x_124 #s(bound)))
              (name e_125 #s(bound)))))
           (#s(lvar x_31) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_86) . #s(lvar τ_2_71))
           (#s(lvar x_78) . variable-not-otherwise-mentioned)
           (#s(lvar x_116) . variable-not-otherwise-mentioned)
           (#s(lvar Γ_12) . #s(lvar Γ_7))
           (#s(lvar Γ_35)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_31 #s(bound))
              (name τ_2_27 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_93) . #s(lvar τ_2_76))
           (#s(lvar e_a_8)
            .
            (cstr
             (e)
             (list + (name e_a_13 #s(bound)) (name e_b_14 #s(bound)))))
           (#s(lvar τ_e_6) . (cstr (τ) num))
           (#s(lvar τ_e_126) . #s(lvar τ_e_6))
           (#s(lvar τ_141) . (cstr (τ) num))
           (#s(lvar Γ_7)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name e_b_69 #s(bound))
              (name τ_2_71 #s(bound))
              (name Γ_2 #s(bound)))))
           (#s(lvar e_a_24)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_31 #s(bound)) (name τ_x_32 #s(bound)))
              (name e_33 #s(bound)))))
           (#s(lvar n_57) . #s(lvar e_54))
           (#s(lvar Γ_151) . #s(lvar Γ_7))
           (#s(lvar e_b_107)
            .
            (cstr
             (e)
             (list + (name e_a_137 #s(bound)) (name e_b_138 #s(bound)))))
           (#s(lvar τ_x_79) . #s(lvar τ_2_76))
           (#s(lvar n_135) . #s(lvar e_132))
           (#s(lvar Γ_97) . #s(lvar Γ_2))
           (#s(lvar Γ_136) . #s(lvar Γ_7))
           (#s(lvar e_5)
            .
            (cstr
             (e)
             (list
              if0
              (name e_a_8 #s(bound))
              (name e_b_9 #s(bound))
              (name e_c_10 #s(bound)))))
           (#s(lvar n_90) . #s(lvar e_87))
           (#s(lvar e_b_25) . (cstr (e) number))
           (#s(lvar τ_x_4) . #s(lvar τ_62))
           (#s(lvar Γ_44) . #s(lvar Γ_7))
           (#s(lvar Γ_15) . #s(lvar Γ_7))
           (#s(lvar τ_2_109) . (cstr (τ) num))
           (#s(lvar e_a_13)
            .
            (cstr
             (e)
             (list + (name e_a_16 #s(bound)) (name e_b_17 #s(bound)))))
           (#s(lvar Γ_104) . #s(lvar Γ_2))
           (#s(lvar τ_x_32) . #s(lvar τ_2_27))
           (#s(lvar x_99) . #s(lvar e_b_69))
           (#s(lvar e_0)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_3 #s(bound)) (name τ_x_4 #s(bound)))
              (name e_5 #s(bound)))))
           (#s(lvar n_59) . #s(lvar e_b_46))
           (#s(lvar x_140) . #s(lvar e_a_137))
           (#s(lvar τ_70) . #s(lvar τ_e_6))
           (#s(lvar Γ_145) . #s(lvar Γ_2))
           (#s(lvar τ_62) . #s(lvar τ_2_76))
           (#s(lvar Γ_129) . #s(lvar Γ_7))
           (#s(lvar x_123) . variable-not-otherwise-mentioned)
           (#s(lvar x_85) . variable-not-otherwise-mentioned)
           (#s(lvar τ_x_117) . #s(lvar τ_2_114))
           (#s(lvar e_a_137) . (cstr (e) variable-not-otherwise-mentioned))
           (#s(lvar τ_103) . #s(lvar τ_2_76))
           (#s(lvar Γ_139) . #s(lvar Γ_7))
           (#s(lvar e_a_73)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_78 #s(bound)) (name τ_x_79 #s(bound)))
              (name e_80 #s(bound)))))
           (#s(lvar e_b_46) . (cstr (e) number))
           (#s(lvar Γ_134)
            .
            (cstr
             (Γ)
             (list
              e-cons
              (name x_130 #s(bound))
              (name τ_x_131 #s(bound))
              (name Γ_7 #s(bound)))))
           (#s(lvar τ_75)
            .
            (cstr (τ) (list (name τ_2_71 #s(bound)) → (name τ_e_6 #s(bound)))))
           (#s(lvar Γ_60) . #s(lvar Γ_7))
           (#s(lvar τ_11) . #s(lvar τ_e_6))
           (#s(lvar Γ_58) . #s(lvar Γ_7))
           (#s(lvar x_102) . #s(lvar e_b_74))
           (#s(lvar f-results64_142) . #s(lvar τ_141))
           (#s(lvar x_143) . #s(lvar e_b_69))
           (#s(lvar x_92) . #s(lvar e_b_74))
           (#s(lvar τ_2_48) . (cstr (τ) num))
           (#s(lvar e_b_112)
            .
            (cstr
             (e)
             (list
              λ
              (list (name x_130 #s(bound)) (name τ_x_131 #s(bound)))
              (name e_132 #s(bound)))))
           (#s(lvar f-results64_94) . #s(lvar τ_2_76))
           (#s(lvar n_128) . #s(lvar e_125))
           (#s(lvar e_b_69) . #s(lvar e_a_137))
           (#s(lvar τ_x_131) . (cstr (τ) any))
           (#s(lvar τ_2_76) . #s(lvar τ_2_71))
           (#s(lvar Γ_51) . #s(lvar Γ_7))
           (#s(lvar x_95) . #s(lvar e_b_14))
           (#s(lvar τ_96) . #s(lvar τ_62))
           (#s(lvar τ_x_53) . #s(lvar τ_2_48))
           (#s(lvar τ_65) . #s(lvar τ_x_4)))
    '()))
  'generation-log)))
