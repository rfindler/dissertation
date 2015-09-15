#lang racket

(require slideshow
         pict
         pict/flash
         unstable/gui/pict
         "common.rkt"
         "settings.rkt"
         "examples/stlc.rkt"
         "pb-pict.rkt"
         (only-in "redex-typeset.rkt" with-rewriters))

(provide do-automated-testing
         explain-methods
         pb-pict-emph
         sscale)

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
           (cons 20
                 (parameterize ([pretty-print-columns 30])
                   (for/list ([n (in-range 6)])
                             (sexp->pict (generate-term Λ e 4))))))))

(define def-to-tests-pict
  (hc-append grammar-pict
             (arrow 100 0)
             exps-pict))

(define dewey-quote
  (vl-append 5
   (para (string-append "\"Current State of the Art. The predominant program generation strategy "
                        "for language fuzzing is based on stochastic context-free grammars.\""))
   (t "[Dewey, Roesch, Hardekpof, ASE 2014]")))

(define hanford-cite (t "[Hanford 1970]"))

(define (ad-hoc-pict [seq-num 0])
  (define pict-seq (list hanford-cite dewey-quote))
  (vc-append
   (hc-append 30 
              (s-frame lambda-lang-pict)
              (s-frame
               (apply vc-append
                      (add-between
                       (for/list ([t (in-list '(e (e e) (1 e) (1 w)))])
                         (term->pict/pretty-write Λ t))
                       (arrow 20 (- (/ pi 2)))))))
   (lt-superimpose
    (list-ref pict-seq seq-num)
    (apply lt-superimpose (map ghost pict-seq)))))

(define first-enums-pict
  (s-frame
   (apply vl-append
          (for/list ([i (in-range 7)])
            (hbl-append (t (string-append (number->string i) "\t"))
                        (sexp->pict (generate-term Λ e #:i-th i)))))))

(define big-enum-pict
  (s-frame
   (hc-append (t "10^8 + 3\t")
              (parameterize ([pretty-print-columns 30])
                (sexp->pict (generate-term Λ e #:i-th (+ 3 (expt 10 8))))))))

(define enum-methods-pict
  (item-frame #:title "Two methods:"
              "choose a random index" 
              "enumerate in order"))


(define (enum-pict seq-num)
  (define seq-picts (list first-enums-pict big-enum-pict enum-methods-pict))
  (vc-append
   (hc-append
    (s-frame
     (vl-append
     (emph-line "enumerations:")
     (hbl-append (t "enum α : (α → ") nats-p
                 (t ") ") prod-p (t " (") nats-p (t " → α)"))))
    (s-frame
     (hc-append 
      10
      e-pict
      (arrow 50 0)
      (hbl-append (t "enum ") (parameterize ([default-font-size (current-font-size)])
                                (term->pict/pretty-write Λ 'e))))))
   (cc-superimpose
    (list-ref seq-picts seq-num)
    (apply cc-superimpose (map ghost seq-picts)))))



(define dewey-quote2
  (vl-append (para (string-append "\"...declarative specifications to generate programs..."
                                  "no existing language fuzzers use this approach, but there are "
                                  "[related] techniques for automatic data structure generation"))
             (t "[Dewey et al, ASE 2014]")))

(define tc-jdg-pict (with-rewriters (term->pict STLC (tc • e τ))))
(define e-pict (with-rewriters (term->pict STLC e)))
(define t-pict (with-rewriters (term->pict STLC τ)))

(define example-frame
  (s-frame (vc-append 5 
                       (t "Example:")
                       (hbl-append (t "Make a random ") e-pict (t " and ") t-pict)
                       (t "such that:")
                       tc-jdg-pict)))

(define (clp-frame show-c?)
  (s-frame (vc-append 5
                      (t "How it's done:")
                      (t "randomized")
                      (if show-c? 
                          (colorize 
                           (parameterize ([current-main-font font:base-font])
                             (t "constraint"))
                           colors:emph-dull)
                          (blank 0 0))
                      (t "logic programming engine")
                      (if show-c? 
                          (blank 0 0)
                          (ghost (t "constraint"))))))

(define (deriv-pict [seq-num 0])
  (define seq-picts (list example-frame (clp-frame #f) (clp-frame #t)))
  (vc-append
   (hc-append
    (item-frame "grammar"
                "judgment forms"
                "functions")
    (vc-append (arrow 50 0) (blank 0 25))
    (s-frame (t/n "terms satisfying those\ndefintions")))
   (cc-superimpose (list-ref seq-picts seq-num)
                   (apply cc-superimpose (map ghost seq-picts)))))


(define prop-title "Property-based testing")

(define (do-automated-testing)

  (slide #:title prop-title (sscale (pb-pict-emph #f)))
  
  (slide #:title prop-title (sscale (pb-pict-emph 1)))
  
  (slide #:title "Redex: \"push-button\" testing" (sscale def-to-tests-pict)))

(define (explain-methods)
  
  (slide #:title "Generation: ad-hoc" (sscale (ad-hoc-pict 0)))
  
  (slide #:title "Generation: ad-hoc" (sscale (ad-hoc-pict 1)))

  (slide #:title "Generation: enumeration" (sscale (enum-pict 0)))

  (slide #:title "Generation: enumeration" (sscale (enum-pict 1)))
  
  (slide #:title "Generation: enumeration" (sscale (enum-pict 2)))
  
  (slide #:title "Generation: derivation" (sscale (deriv-pict 0)))
  
  (slide #:title "Generation: derivation" (sscale (deriv-pict 1)))
  
  (slide #:title "Generation: derivation" (sscale (deriv-pict 2))))
         
         


   


