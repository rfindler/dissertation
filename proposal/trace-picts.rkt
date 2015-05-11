#lang racket

(require redex/pict
         pict
         slideshow
         "examples/stlc.rkt"
         "the-trace.rkt"
         "redex-typeset.rkt"
         "fades.rkt"
         "settings.rkt"
         "common.rkt"
         redex/private/pat-unify
         redex/private/search)

(provide do-trace-slides
         do-trace
         trace-picts)

(struct ptree (pict conc-pict children success?) #:transparent)
; children is (vectorof (or pict ptree))


(define (pat->syntax-datum pat)
  (let loop ([pat pat])
    (match pat
      [`(cstr ,nts ,p)
       (loop p)]
      [`(list ,a ...)
       `(,@(map loop a))]
      [`(name ,nm ,sp)
       (format-name nm)]
      [_ pat])))

(define (format-name sym)
  (string->symbol
   (regexp-replace 
    #rx"^([^_])\\^(.*)$"
    (regexp-replace 
     #rx"^(.*)_([0-9]+)$"
     (regexp-replace
      #rx"^f-results([0-9]+)_([0-9]+)$"
      (symbol->string sym)
      "τ_f^\\2")
     "\\1^\\2")
    "\\1_^\\2")))

(define (make-env-formatter env-list)
  (define eqpicts
    (map (λ (p)
           (scale p 2.5))
         (for/list ([eq (in-list env-list)])
           (match-define (cons l r) eq)
           (define lsd (match l
                         [(lvar nm) (format-name nm)]))
           (define rsd (match r
                         [(lvar nm) (format-name nm)]
                         [_ (pat->syntax-datum r)]))
           (with-rewriters
            (hbl-append
             (term->pict/pretty-write STLC-2 lsd)
             (term->pict/pretty-write STLC '=)
             (term->pict/pretty-write STLC-2 rsd))))))
  (define max-w (apply max (cons 1 (map pict-width eqpicts))))
  (define max-h (apply max (cons 1 (map pict-height eqpicts))))
  (λ (width height)
    ; new col if
    ; - all cols full
    ; - enough width
    ; first fill new column
    ; then add & shrink, spilling across leftwards, 
    ; until enough width for new column
    ; (closed formula for this??)
    (define-values
      (ncols percolumn)
      (let loop ([ncols 1]
                 [percolumn (ceiling (/ height max-h))]
                 [inlastcol 0]
                 [toplace (length eqpicts)])
        ;(printf "~a ~a ~a ~a\n" ncols percolumn inlastcol toplace)
        (define hscale (/ height (* percolumn max-h)))
        (define wscale (min 1 (/ width (* max-w ncols))))
        (define scaling (min hscale wscale))
        (cond
          [(toplace . <= . (- percolumn inlastcol))
           ;; can put all in last column
           (values (inexact->exact ncols) 
                   (inexact->exact percolumn))]
          [(inlastcol . < . percolumn)
           ;; add one to last col
           (loop ncols percolumn
                 (add1 inlastcol)
                 (sub1 toplace))]
          [(and (inlastcol . >= . percolumn)
                ((/ width (add1 ncols)) . > . (* max-w scaling)))
           ;; new column
           (loop (add1 ncols)
                 percolumn
                 1
                 (sub1 toplace))]
          [else
           ;; spill across columns, shrinking
           (loop ncols 
                 (add1 percolumn)
                 (sub1 inlastcol)
                 ;(add1 inlastcol)
                 toplace)])))
    (maybe-stf
     (apply 
      ht-append
      (let loop ([eqps eqpicts]
                 [cols '()])
        (cond
          [(empty? eqps)
           (reverse cols)]
          [((length eqps) . < . percolumn)
           (loop '() (cons (apply vl-append eqps) cols))]
          [else
           (loop (drop eqps percolumn)
                 (cons (apply vl-append (take eqps percolumn))
                       cols))])))
     width height)))

(define (filter-env env)
  (for/hash ([(l r) (in-hash env)]
             #:when (or (and (list? (pat->syntax-datum r))
                             (not
                              (member 'nt (pat->syntax-datum r))))
                        (lvar? r)
                        (eq? (pat->syntax-datum r) '•)
                        (eq? (pat->syntax-datum r) 'number)))
    (values l r)))

(define (hash->cons h)
  (for/list ([(k v) (in-hash h)])
    (cons k v)))

(define (disp-width datum)
  (string-length
   (format "~a" datum)))

(define (order-envs envs)
  (define-values
    (new-es _)
    (for/fold ([es '()]
               [seen-past '()])
              ([e (in-list envs)])
      (define seen
        (filter (λ (eq)
                  (member eq e)) 
                seen-past))
      (define-values (have-seen new)
        (partition (λ (eq)
                     (member eq seen))
                   e))
      (define eqs (append seen
                          (sort new >
                                #:key disp-width)))
      (values (cons eqs
                    es)
              eqs)))
  (reverse new-es))

(define (get-env trace-el)
  (env-eqs (gen-trace-env (vector-ref trace-el 2))))

(define (typeset-envs the-trace)
  (map make-env-formatter
       (order-envs
        (map (λ (trace-el)
               (hash->cons 
                (filter-env
                 (get-env trace-el))))
             (duplicate-some-elems
              the-trace)))))

(define (duplicate-some-elems trace)
  (let loop ([new-tr '()]
             [trace trace])
    (cond
      [(empty? trace)
       new-tr]
      [else
       (define tr-el (car trace))
       (define gt (vector-ref tr-el 2))
       (loop
        (append new-tr
                (if (gen-trace-state gt)
                    (let ([t1 (vector-copy tr-el)]
                          [t2 (vector-copy tr-el)]
                          [second-env (if (empty? (cdr trace))
                                          (gen-trace-env gt)
                                          (gen-trace-env (vector-ref (cadr trace) 2)))])
                      (vector-set! t1 2
                                   (struct-copy gen-trace gt
                                                [state 1]))
                      (vector-set! t2 2 ;; next env here
                                   (struct-copy gen-trace gt
                                                [state 2]
                                                [env second-env]))
                      (list t1 t2))
                    (list tr-el)))
        (cdr trace))])))

(define (rule-head-pict trace-el)
  (define gt (vector-ref trace-el 2))
  (define clause (gen-trace-clause gt))
  (typeset-rule-head clause))

(define (rule-prem-picts trace-el)
  (define gt (vector-ref trace-el 2))
  (define clause (gen-trace-clause gt))
  (map (compose typeset-prem prem-pat)
       (clause-prems clause)))

(define (typeset-goal trace-el)
  (define gt (vector-ref trace-el 2))
  (define clause (gen-trace-clause gt))
  (typeset-rule (gen-trace-input gt)
                (clause-name clause)))


(define (typeset-rule-head clause)
  (typeset-rule (clause-head-pat clause)
                (clause-name clause)))

(define (typeset-rule pat kind)
  (match kind
    ['tc
     (rewrite-as-tc pat)]
    ['lookup
     (rewrite-as-lookup pat)]))

(define (typeset-prem prem)
  (cond
    [(for/or ([t (in-list (flatten prem))])
       (and (symbol? t)
            (regexp-match #rx"f-results"
                          (symbol->string t))))
     ;; it's a lookup
     (rewrite-as-lookup prem)]
    [else
     (rewrite-as-tc prem)]))

(define (rewrite-as-tc p)
  (with-rewriters
   (term->pict/pretty-write 
    STLC-2
    (cons 'tc (pat->syntax-datum p)))))

(define (rewrite-as-lookup p)
  (define psd (pat->syntax-datum p))
  (with-rewriters 
   (hbl-append 5
               (term->pict/pretty-write STLC-2 (append '(lookup) (first psd)))
               (term->pict/pretty-write STLC-2 '=)
               (term->pict/pretty-write STLC-2 (second psd)))))

(define goal-mark (colorize (parameterize ([current-main-font font:base-font])
                              (bt "?"))
                            colors:emph-bright))

(define attempt-mark (cc-superimpose
                      (colorize
                       (scale (arrow 24 (- (/ pi 2)))
                              2
                              1.5)
                       colors:note-color)
                      goal-mark))

(define under-attempt? (make-parameter #f))

(define (render-ptree pt)
  (define clist (vector->list (ptree-children pt)))
  (define is-attempt? (and (= 1 (length clist))
                           (ptree? (car clist))
                           (not (ormap ptree? 
                                       (vector->list
                                        (ptree-children (car clist)))))
                           (or (not (ptree-success? (car clist)))
                               (= 1 (ptree-success? (car clist))))))
  (define (render-child c)
    (cond
      [(pict? c)
       (if (under-attempt?)
           c
           (vc-append
            goal-mark
            (hline (pict-width c) 3)
            c))]
      [else (render-ptree c)]))
  (define ctpicts 
    (parameterize ([under-attempt? (or (under-attempt?)
                                       is-attempt?)])
      (map render-child clist)))
  (define chpicts (map (λ (c) (if (ptree? c)
                                  (ptree-pict c)
                                  c))
                       clist))
  (define cpict (apply hbl-append
                       20
                       ctpicts))
  (define cwidth
    (apply +
           (* 20 (length clist))
           (map pict-width ctpicts)))
  (define lwidth (max (pict-width (ptree-pict pt)) 
                      cwidth))
  (vc-append cpict
             (if is-attempt? 
                 attempt-mark
                 (hline lwidth 3))
             (ptree-pict pt)))

(define (add-rule-to-ptree pt trace-el)
  (define gt (vector-ref trace-el 2))
  (define loc (reverse (gen-trace-tr-loc gt)))
  (define success? (gen-trace-state gt))
  (define (add-loop loc pt)
    (cond
      [(and (empty? loc)
            (or (not success?)
                (= 1 success?))
            (ptree? pt))
       (struct-copy 
        ptree pt
        [children (vector
                   (ptree (rule-head-pict trace-el)
                          #f
                          (list->vector (rule-prem-picts trace-el))
                          success?))])]
      [(and (empty? loc)
            (or (not success?)
                (= 1 success?))
            (pict? pt))
       (ptree pt
              #f
              (vector
               (ptree (rule-head-pict trace-el)
                      #f
                      (list->vector (rule-prem-picts trace-el))
                      success?))
              2)]
      [(empty? loc)
       (ptree (rule-head-pict trace-el)
              #f
              (list->vector (rule-prem-picts trace-el))
              success?)]
      [else
       (define new-child (add-loop (cdr loc)
                                   (vector-ref (ptree-children pt)
                                               (car loc))))
       (define cnew (vector-copy (ptree-children pt)))
       (vector-set! cnew (car loc) new-child)
       (ptree (ptree-pict pt)
              #f
              cnew
              #f)]))
  (add-loop loc pt))



(define (trace->ptrees trace)
  (define init-goal
    (typeset-goal (first trace)))
  (define-values (_ pts)
    (for/fold ([pt (ptree init-goal #f (vector) #f)]
               [pts '()])
              ([trace-el (in-list (duplicate-some-elems trace))]
               [i (in-naturals)])
      (define new-pt (add-rule-to-ptree pt trace-el))
      (values new-pt
              (cons new-pt pts))))
  (reverse pts))

(define (trace->picts the-trace)
  (define gp (typeset-goal (first the-trace)))
  (define jpicts
    (map (λ (p) (scale p 2))
         (cons (vc-append
                goal-mark
                (hline (pict-width gp) 3)
                gp)
               (map render-ptree (trace->ptrees the-trace)))))
  (define ep-makers 
    (cons (λ (_ _2) (blank))
          (typeset-envs the-trace)))
  (define rnames
    (cons 'lookup
          (map trace-el->rule-name (duplicate-some-elems the-trace))))
  (map list
       jpicts
       ep-makers
       rnames))

(define maybe-stf 
  (case-lambda
    [(pict scale-pict)
     (if (or ((pict-width pict) . > . (pict-width scale-pict))
             ((pict-height pict) . > . (pict-height scale-pict)))
         (scale-to-fit pict scale-pict)
         pict)]
    [(pict w h)
     (if (or ((pict-width pict) . > . w)
             ((pict-height pict) . > . h))
         (scale-to-fit pict w h)
         pict)]))

(define tc-cases-picts
  (for/hash ([n (in-range 6)]
             [name (in-list '(num var λ app if0 plus))])
    (values name
            (with-rewriters
             (parameterize ([judgment-form-cases (list n)])
               (judgment-form->pict tc))))))

(define tc-gaps 10)

(define (make-tc-pict [to-highlight #f])
  (define (get-pict n)
    (define p (hash-ref tc-cases-picts n))
    (if (and to-highlight
             (eq? to-highlight n))
        (refocus 
         (cc-superimpose
          (colorize
           (filled-rounded-rectangle (+ 5 (pict-width p))
                                     (+ 5 (pict-height p)))
           colors:emph-bright)
          p)
         p)
        p))
  (apply vc-append tc-gaps
         (apply hc-append tc-gaps
                (for/list ([n (in-list '(num
                                         var))])
                  (get-pict n)))
         (for/list ([n (in-list '(λ
                                     plus
                                   app
                                   if0))])
           (get-pict n))))

(define tc-pict (make-tc-pict))

(define tc-picts-highlighted
  (for/hash ([n (in-list '(num
                           var
                           λ
                           plus
                           app
                           if0))])
    (values n (make-tc-pict n))))

(define (trace-el->rule-name te)
  (clause->rule-name
   (gen-trace-clause (vector-ref te 2))))

(define (clause->rule-name cls)
  (match (clause-head-pat cls)
    [`(list ,_ (name ,_ (nt n)) ,_) 'num]
    [`(list ,_ (name ,_ (nt x)) ,_) 'var]
    [`(list ,_ (list λ ,_ ,_) ,_) 'λ]
    [`(list ,_ (list + ,_ ,_) ,_) 'plus]
    [`(list ,_ (list ,_ ,_) ,_) 'app]
    [`(list ,_ (list if0 ,_ ,_ ,_) ,_) 'if0]
    [`(list ,_ ,(or #f `(name ,_ any))) 'lookup]))

(define space (ghost (text "X" '(bold) 20)))
(define eq-text0 (text "Equations" '(bold) 20))
(define eq-text (hbl-append space eq-text0))
(define r-text0 (text "Rules" '(bold) 20))
(define r-text (hbl-append space r-text0))
(define d-text0 (text "Derivation" '(bold) 20))
(define d-text (hbl-append space d-text0))

(define (make-arranger step-picts)
  (define highlight-rule? #f)
  (match-lambda
    ['highlight (set! highlight-rule? #t)]
    [(? pict? tc-pict)
     (match-define (list jp make-ep rname) step-picts)
     (define half-w (round (/ client-w 2)))
     (define v-fract (round (/ client-h 5)))
     (define top (ghost (rectangle half-w (* 3 v-fract))))
     (define bot (ghost (rectangle client-w (* 2 v-fract))))
     (define tbox (make-box top))
     (define bbox (make-box bot))
     (define bot-margin 20)
     (define lr-marg 10)
     (define lr-marg-box (ghost (rectangle lr-marg 0)))
     (define inner-box-t 
       (ghost (rectangle (- (pict-width top)
                            (* 2 lr-marg))
                         (- (pict-height top) 
                            (pict-height eq-text)
                            bot-margin))))
     (define inner-box-b
       (ghost (rectangle (- (pict-width bot)
                            (* 2 lr-marg))
                         (- (pict-height bot)
                            (pict-height d-text)
                            bot-margin))))
     (define tl (vl-append
                 eq-text
                 inner-box-t))
     (define bl (scale-to-fit (vl-append
                               d-text
                               inner-box-t)
                              bot))
     (vc-append
      (hc-append
       (lt-superimpose tbox
                       (vl-append r-text
                                  (hc-append
                                   lr-marg-box
                                   (maybe-stf 
                                    (scale (if (and highlight-rule?
                                                    (not (eq? rname 'lookup)))
                                               (hash-ref tc-picts-highlighted rname)
                                               tc-pict)
                                           2)
                                    inner-box-t)
                                   lr-marg-box)))
       (lt-superimpose tbox
                       (vl-append eq-text
                                  (hc-append
                                   lr-marg-box
                                   (make-ep (pict-width inner-box-t)
                                            (pict-height inner-box-t))
                                   lr-marg-box))))
      (lt-superimpose
       bbox
       (vl-append d-text
                  (cb-superimpose
                   (hc-append
                    lr-marg-box
                    (maybe-stf jp inner-box-b)
                    lr-marg-box)
                   inner-box-b))))]))

(define (make-box p)
  (define w (pict-width p))
  (define h (pict-height p))
  (linewidth 4
             (rounded-rectangle w h
                                (/ (min w h)
                                   20))))

(define rules (hash-keys tc-picts-highlighted))

(define (random-seq len final)
  (define-values
    (_ seq)
    (for/fold ([last 0]
               [l '()])
              ([n (in-range len)])
      (define (next)
        (define try (random (length rules)))
        (if (= try last)
            (next)
            try))
      (define this (next))
      (values
       this
       (cons (list-ref rules this) l))))
  (reverse
   (cons final seq)))

(define a-seq (random-seq 20 'λ))

(define trace-picts (trace->picts the-trace))

(define first-arranger (make-arranger 
                        (first trace-picts)))

(require slideshow/play)

(define (render-trace trace)
  (map (λ (p)
         ((make-arranger p) tc-pict))
       (trace->picts trace)))

(define trace-slide-picts
  (for/list ([p (in-list (rest trace-picts))]
             [n (in-naturals)])
    (define arr (make-arranger p))
    (when (n . < . 7) (arr 'highlight))
    (arr tc-pict)))


(define (do-trace-slides)
  (play-n
   (λ (n)
     (first-arranger 
      (if (= n 0)
          tc-pict
          (hash-ref tc-picts-highlighted
                    (list-ref a-seq
                              (inexact->exact
                               (round
                                (* (expt n 0.75) 
                                   (sub1 (length a-seq))))))))))
   #:delay 0.02
   #:steps 100)
  (void
   (map slide
        trace-slide-picts)))

(define (circle-that base p)
  (define gp (ghost p))
  (pin-under base
             p
             lt-find
             (linewidth 5
                        (refocus
                         (cc-superimpose
                          gp
                          (colorize (ellipse (* 1.3 (pict-width p))
                                             (* 1.3 (pict-height p)))
                                    colors:emph-bright))
                         gp))))

(define (do-trace)
  
  (do-trace-slides)
  
  
  (slide (circle-that (last trace-slide-picts)
                      d-text0))
  
  (slide (circle-that
          (circle-that (last trace-slide-picts)
                       eq-text0)
          d-text0))
  
  (slide (cc-superimpose
          (circle-that
           (circle-that (last trace-slide-picts)
                        eq-text0)
           d-text0)
          (faded-fade
           (scale-to-fit
            (parameterize ([default-style '(bold . modern)]
                           [non-terminal-style '(bold . modern)])
              (term->pict/pretty-write STLC-2 the-term))
            (last trace-slide-picts))
           #:color colors:shadow
           #:init 0.125
           #:delta 4
           #:grads 100))))
#;
(module+ main
  (do-trace))
