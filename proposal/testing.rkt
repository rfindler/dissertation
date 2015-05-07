#lang racket

(require slideshow
         pict
         pict/flash
         unstable/gui/pict
         "common.rkt"
         "settings.rkt")

(provide do-automated-testing
         explain-methods)

(define pb-pict-base
  (hc-append 100
             (bubble "Test Cases")
             (bubble "Property")
             (vc-append
              (bubble "Pass")
              (blank 0 100)
              (bubble "Fail"))))

(define pb-pict
  (for/fold ([p pb-pict-base])
            ([arrow (in-list `((|Test Cases| ,rc-find ,0 Property ,lc-find ,0)
                               (Property ,rc-find ,0 Pass ,lc-find ,0)
                               (Property ,rc-find ,0 Fail ,lc-find ,0)))])
    (match-define (list from from-find from-ang to to-find to-ang) arrow)
    (pin-arrow-line 25 p
                    (car (find-tag p from)) from-find
                    (car (find-tag p to)) to-find
                    #:start-angle from-ang
                    #:end-angle to-ang
                    #:line-width 6
                    #:color colors:emph-bright
                    #:under? #t)))

(define (pb-pict-emph [show-flash? #f])
  (let* ([tc-bub (car (find-tag pb-pict '|Test Cases|))]
         [tcw (* 1.5 (pict-width tc-bub))]
         [tch (* 1.5 (pict-height tc-bub))]
         [flash-p (colorize (filled-flash tcw tch)
                       colors:emph-bright)]
         [anchor (blank 0 0)])
  (pin-under pb-pict
             tc-bub
             cc-find
             ((if show-flash? values ghost)
              (refocus
               (cc-superimpose flash-p anchor)
               anchor)))))

(define grammar-pict 
  (s-frame 
   (code-snip-pict "examples/lambda.rkt" "LANG")))

(require redex/reduction-semantics
         redex/pict
         "examples/lambda.rkt")

(random-seed 17)

(define exps-pict 
  (s-frame
    (apply vl-append
           (parameterize ([pretty-print-columns 30])
             (for/list ([n (in-range 6)])
               (sexp->pict (generate-term Λ e 4)))))))

(define def-to-tests-pict
  (hc-append grammar-pict
             (arrow 100 0)
             exps-pict))                    

(define (sscale p)
  (scale-to p
            (pict-width (inset titleless-page -50))
            (pict-height (inset titleless-page -50))))

(define ad-hoc-pict
  (vl-append
   (hc-append 30 
              (s-frame lambda-lang-pict)
              (s-frame
               (apply vc-append
                      (add-between
                       (for/list ([t (in-list '(e (e e) (1 e) (1 x)))])
                         (term->pict/pretty-write Λ t))
                       (arrow 20 (- (/ pi 2)))))))
   (t "[Hanford 1970]")))

(define enum-pict
  (vc-append
   (hc-append
    (s-frame
     (vl-append
     (emph-line "enumerations:")
     (hbl-append (t "enum α : (α → ") nats-p
                 (t ") ") prod-p (t " (") nats-p (t " → α)"))
     (blank 0 15)
     (emph-line "combinators:")
     (t "enum → enum → enum")))
   (s-frame
    (vl-append 5
     (hbl-append (t "enum ") (parameterize ([default-font-size (current-font-size)])
                              (term->pict/pretty-write Λ 'e)))
     e-pict)))
   (item-frame "choose a random index" 
               "enumerate in order")))
   
      


(define (do-automated-testing)
  (slide (sscale (pb-pict-emph)))
  
  (slide (sscale (pb-pict-emph #t)))
  
  (slide (sscale def-to-tests-pict)))

(define (explain-methods)
  (slide (sscale ad-hoc-pict))

  (slide (sscale enum-pict)))


   


