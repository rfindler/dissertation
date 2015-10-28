#lang racket/base

(require racket/match
         racket/list
         racket/pretty
         racket/bool
         unstable/pretty
         slideshow/pict
         redex/reduction-semantics
         redex/pict
         redex/tut-subst)

(provide (all-defined-out))

(define-language STLC-min
  (e ::= (e e) 
         (λ [x τ] e)
         (rec [x τ] e)
         (if0 e e e) 
         (o e e)
         x n)
  (τ ::= (τ → τ) 
         num)
  (n ::= number)
  (o ::= + -)
  (x ::= variable-not-otherwise-mentioned))

(define-extended-language STLC STLC-min
  (v ::= (λ [x τ] e) n)
  (Γ ::= (x τ Γ) •)
  (E ::= (E e) (v E) (o E e) (o v E) 
         (if0 E e e) hole))

(define STLC-red-one
  (reduction-relation
   STLC
   (--> ((λ [x τ] e) v)
        (subst e x v)
        β)
   (--> (rec [x τ] e)
        (subst e x (rec [x τ] e))
        μ)
   (--> (if0 0 e_1 e_2)
        e_1
        if-0)
   (--> (if0 n e_1 e_2)
        e_2
        (side-condition
         (term (different n 0)))
        if-n)
   (--> (o n_1 n_2)
        (δ n_1 o n_2)
        δ)))

(define STLC-red
  (context-closure STLC-red-one STLC E))

(define-judgment-form STLC
  #:mode (tc I I O)
  [--------------
   (tc Γ n num)]
  
  [(where τ (lookup Γ x))
   ----------------------
   (tc Γ x τ)]
  
  [(tc (x τ_x Γ) e τ_e)
   -----------------------------
   (tc Γ (λ [x τ_x] e) (τ_x → τ_e))]
  
  [(tc (x τ Γ) e τ)
   ----------------------
   (tc Γ (rec [x τ] e) τ)]
  
  [(tc Γ e_1 (τ_2 → τ)) (tc Γ e_2 τ_2)
   ------------------------------
   (tc Γ (e_1 e_2) τ)]
  
  [(tc Γ e_0 num) 
   (tc Γ e_1 τ) (tc Γ e_2 τ)
   -----------------------
   (tc Γ (if0 e_0 e_1 e_2) τ)]
  
  [(tc Γ e_0 num) (tc Γ e_1 num)
   -------------------------
   (tc Γ (o e_0 e_1) num)])

(define-metafunction STLC
  [(lookup (x τ Γ) x)
   τ]
  [(lookup (x_1 τ Γ) x_2)
   (lookup Γ x_2)]
  [(lookup • x)
   #f])

(define-metafunction STLC
  [(δ n_1 + n_2)
   ,(+ (term n_1) (term n_2))]
  [(δ n_1 - n_2)
   ,(- (term n_1) (term n_2))])

(define-metafunction STLC
  [(different v v) #f]
  [(different v_1 v_2) #t])

(define-metafunction STLC
  Eval : e -> n or function
  [(Eval e)
   n
   (judgment-holds (refl-trans e n))]
  [(Eval e)
   function
   (judgment-holds (refl-trans e (λ (x τ) e_3)))])

(define-judgment-form STLC
  #:mode (refl-trans I O)
  [(refl-trans e_1 e_2)
   (where e_2 ,(last (apply-reduction-relation* STLC-red (term e_1)
                                               #:all? #t)))])

;; just for typesetting the contextual closure:
(define-judgment-form STLC
  #:mode (==>b I I)
  [-----------------
   (==>b e_1 e_2)])
  
(define-judgment-form STLC
  #:mode (==>a I I)
  [(==>b e_1 e_2)
   --------------------------------------
   (==>a (in-hole E e_1) (in-hole E e_2))])

(define (x? e)
  (redex-match STLC x e))

(define (tc-rewriter lws)
  (match lws
    [(list _ _ Γ e τ _)
     (list "" Γ " ⊢ " e " : " τ "")]))

(define (==>a-rewriter lws)
  (match lws
    [(list _ _ e1 e2 _)
     (list "" e1 (arrow->pict ':-->) e2)]))

(define (==>b-rewriter lws)
  (match lws
    [(list _ _ e1 e2 _)
     (list "" e1 (arrow->pict '-->) e2)]))

(define (lookup-rewriter lws)
  (match lws
    [(list _ _ Γ x _)
     (list "" Γ "(" x ")" "")]))

(define (subst-rewriter lws)
  (match lws
    [(list _ _ e x v _)
     (list "" e "{" x " ← " v "}" "")]))

(define (different-rewriter lws)
  (match lws
    [(list _ _ a b _)
     (list "" a " ≠ " b "")]))

(define (δ-rewriter lws)
  (match lws
    [(list _ _ a o b _)
     (list "\u2308" a " " o " " b "\u2309")]))

(define refl-trans-arrow
  (hbl-append (arrow->pict ':-->)
              (parameterize ([literal-style (non-terminal-style)])
                (render-term STLC *))))

(define (refl-trans-rewriter lws)
  (match lws
    [(list _ _ e_1 e_2 _)
     (list "" e_1 " " refl-trans-arrow (just-before " " e_2) e_2 "")]))

(define (o-rewriter lws)
  (match lws
    [(list l o n_1 n_2 r)
     (list l "o \u2308" n_1 "\u2309 \u2308" n_2 "\u2309" r)]))



(define-syntax-rule (with-rewriters e)
  (with-compound-rewriters
   (['tc tc-rewriter]
    ;['lookup lookup-rewriter]
    ['subst subst-rewriter]
    ['different different-rewriter]
    ['δ δ-rewriter]
    ['refl-trans refl-trans-rewriter]
    ['==>a ==>a-rewriter]
    ['==>b ==>b-rewriter])
   e))

(define old-style (rule-pict-style))

(rule-pict-style 'horizontal)

(define stlc-lang-pict (render-language STLC #:nts '(e v τ E Γ)))
(define stlc-red-pict (with-rewriters
                       (render-reduction-relation STLC-red)))
(define stlc-typing-pict (with-rewriters
                          (render-judgment-form tc)))
(define stlc-type-pict-horiz
  (with-rewriters
   (hb-append 20
    (parameterize ([judgment-form-cases '(0 4)])
     (render-judgment-form tc))
    (parameterize ([judgment-form-cases '(1 2)])
     (render-judgment-form tc))
    (parameterize ([judgment-form-cases '(3 5)])
     (render-judgment-form tc)))))

(define (stlc-type-by-2s)
  (with-rewriters
   (hb-append 20
              (parameterize ([judgment-form-cases '(0 2)])
                (render-judgment-form tc))
              (parameterize ([judgment-form-cases '(1 4)])
                (render-judgment-form tc)))))

(define (lookup-pict) 
  (with-rewriters
   (render-metafunction lookup)))

(define (eval-pict) 
  (parameterize ([metafunction-style 'script]
                 [metafunction-pict-style
                  'left-right/beside-side-conditions])
    (with-rewriters
     (render-metafunction Eval
                          #:contract? #true))))

(define (big-stlc-pict)
  (vc-append 10
             (hc-append 25
                        (vl-append 10
                                   (text "Grammar" "Menlo, bold")
                                   stlc-lang-pict
                                   (text "Reduction relation" "Menlo, bold")
                                   stlc-red-pict
                                   (text "Metafunctions" "Menlo, bold")
                                   (lookup-pict))
                        (vl-append 10
                                   (text "Type judgment" "Menlo, bold")
                                   stlc-typing-pict))
             (text "Evaluation" "Menlo, bold")
             (eval-pict)))

(define (stlc-min-lang-types)
  (with-rewriters
   (stlc-type-by-2s)))


(define (well-typed? e)
  (judgment-holds (tc • ,e τ)))

(define (number-exp? e)
  (redex-match STLC n e))

(define (constant-func? e)
  (redex-match STLC (λ(x τ) n) e))

(define (typed-and-interesting? e)
  (and (well-typed? e)
       (not (number-exp? e))
       (not (constant-func? e))))

(define (at-least-n-steps? n)
  (λ (exp)
    (let loop ([e exp]
               [i 0])
      (or (>= i n)
          (let ([next (apply-reduction-relation STLC-red e)])
            (and (not (empty? next))
                 (loop (car next) (add1 i))))))))

(define (uses-reduction? name)
  (λ (exp)
    (let loop ([e exp] [n 0])
      (if (> n 5)
          #f
          (match (apply-reduction-relation/tag-with-names STLC-red e)
            ['() #f]
            [`((,red-name ,next))
             (or (equal? red-name name)
                 (loop next (add1 n)))])))))

(define (gather-stats trials [depth 5])
  (define to-check
    (list (cons 'well-typed? well-typed?)
          (cons 'typed-and-interesting? typed-and-interesting?)
          (cons 'at-least-1-red (at-least-n-steps? 1))
          (cons 'at-least-2-red (at-least-n-steps? 2))
          (cons 'at-least-3-red (at-least-n-steps? 3))
          (cons 'uses-μ (uses-reduction? "μ"))
          (cons 'uses-β (uses-reduction? "β"))
          (cons 'uses-δ (uses-reduction? "δ"))
          (cons 'uses-if-0 (uses-reduction? "if-0"))
          (cons 'uses-if-else (uses-reduction? "if-n"))
          (cons 'typed-and-reduces (λ (e)
                                     (and (well-typed? e)
                                          ((at-least-n-steps? 1) e))))))
  (define stats (make-hash))
  (for ([_ trials])
    (define e (generate-term STLC e depth))
    (map (match-lambda
           [(cons stat check)
            (when (check e)
              (hash-set! stats stat
                         (add1 (hash-ref stats stat 0))))])
         to-check))
  (for/list ([(k v) (in-hash stats)])
    (cons k (exact->inexact (/ v trials)))))

(define (fibn n)
    `((rec [fib (num → num)]
        (λ [x num]
             (if0 x
                  1
                  (if0 (- x 1)
                       1
                       (+ (fib (- x 1))
                          (fib (- x 2)))))))
      ,n))

(define (sumto n)
  (term ((rec [sumto (num → num)]
           (λ [x num]
             (if0 x
                  0
                  (+ x (sumto (- x 1))))))
         ,n)))

(define (check-progress/preservation e)
  (define type-or-empty (judgment-holds (tc • ,e τ) τ))
  (define step-or-empty (apply-reduction-relation STLC-red e))
  (implies (not (empty? type-or-empty))
           (or (redex-match? STLC v e)
               (and (equal? 1 (length step-or-empty))
                    (equal? type-or-empty
                            (judgment-holds (tc • ,(car step-or-empty) τ)
                                            τ))))))

(module+ test
  (redex-check STLC #:satisfying
               (tc • e τ)
               (check-progress/preservation (term e))
               #:attempts 50))

(define (make-rec-pp)
  (define step 0)
  (λ (term)
    (begin0
      (pretty-format/write
       (cond
         [(= step 0)
          term]
         [else
          (let rec ([t term])
            (match t
              [(cons 'rec b)
               `(rec <omitted>)]
              [(cons a b)
               (cons (rec a) (rec b))]
              [else t]))]))
      (set! step (add1 step)))))


(define-metafunction STLC
  subst : e x e -> e
  [(subst x x e)
   e]
  [(subst x x_1 e)
   x]
  [(subst n x e)
   n]
  [(subst (e_1 e_2) x e)
   ((subst e_1 x e) (subst e_2 x e))]
  [(subst (o e_1 e_2) x e)
   (o (subst e_1 x e) (subst e_2 x e))]
  [(subst (if0 e_1 e_2 e_3) x e)
   (if0 (subst e_1 x e) (subst e_2 x e) (subst e_3 x e))]
  [(subst (λ [x τ] e_1) x e)
   (λ [x τ] e_1)]
  [(subst (λ [x_1 τ] e_1) x e)
   (λ [x_2 τ] (subst e_2 x e))
   (where x_2 ,(variable-not-in (term e) (term x_1)))
   (where e_2 (replace-free e_1 x_1 x_2))]
  [(subst (rec [x τ] e_1) x e)
   (rec [x τ] e_1)]
  [(subst (rec [x_1 τ] e_1) x e)
   (rec [x_2 τ] (subst e_2 x e))
   (where x_2 ,(variable-not-in (term e) (term x_1)))
   (where e_2 (replace-free e_1 x_1 x_2))])

(define-metafunction STLC
  replace-free : e x x -> e
  [(replace-free x x x_1)
   x_1]
  [(replace-free x x_1 x_2)
   x]
  [(replace-free n x x_1)
   n]
  [(replace-free (e_1 e_2) x x_1)
   ((replace-free e_1 x x_1) (replace-free e_2 x x_1))]
  [(replace-free (o e_1 e_2) x x_1)
   (o (replace-free e_1 x x_1) (replace-free e_2 x x_1))]
  [(replace-free (if0 e_1 e_2 e_3) x x_1)
   (if0 (replace-free e_1 x x_1)
        (replace-free e_2 x x_1)
        (replace-free e_3 x x_1))]
  [(replace-free (λ [x τ] e_1) x x_1)
   (λ [x τ] e_1)]
  [(replace-free (λ [x_0 τ] e_1) x x_1)
   (λ [x_0 τ] (replace-free e_1 x x_1))]
  [(replace-free (rec [x τ] e_1) x e)
   (rec [x τ] e_1)]
  [(replace-free (rec [x_0 τ] e_1) x x_1)
   (rec [x_0 τ] (replace-free e_1 x x_1))])

(define (closed-term? t)
  (let recur ([t t]
              [vars '()])
    (match t
      [`(λ [,x ,t] ,b)
       (recur b (cons x vars))]
      [(? symbol? x)
       (or (member x '(rec if0 + -))
           (member x vars))]
      [(? number?) #t]
      [(list ts ...)
       (for/and ([t ts])
                (recur t vars))])))