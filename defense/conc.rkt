#lang racket

(require (except-in slideshow freeze)
         (only-in "cmp-eval.rkt" make-eval-pict)
         (only-in "plot-lines.rkt" line-plot-pict)
         (only-in "redex-typeset.rkt" my-freeze)
         "common.rkt"
         "settings.rkt"
         "fades.rkt"
         "four-plot.rkt"
         "models.rkt"
         "related-work.rkt")

(provide do-conc-slides)

(define ep (make-eval-pict (t "Much better")
                           (t "Worse")
                           #:with-title? #f))

(define f-ep (my-freeze ep 0 0 0 0))

(define (with-vline p)
  (hc-append
   (colorize (linewidth 3 (vline 30 (- (pict-height p) 10)))
             "lightgray")
             p))


(define (do-conc-slides)
  (slide #:title "Derivation Generator Performance"
         (scale-to-fit ep titleless-page))

  (do-quadrants)
  
  (frameworks-table)
  
  (rw-slide "Well-typed term generation"
            (cite "Testing an optimising compiler by generating random lambda terms"
                  "[Pałka, Claessen, Russo, Hughes, AST 2011]")
            (cite "Generating Constrained Random Data with Uniform Distribution"
                  "[Claessen, Duregård, Pałka, FLOPS 2014]")
            (cite "Mechanized Metatheory Model Checking"
                  "[Cheney, Momigliano, PPDP 2006]")
            (cite "Fuzzing the Rust Typechecker Using CLP"
                  "[Dewey, Rosch, Hardekpof 2015"))
  
  (rw-slide "Automated Testing Evaluations"
            (cite "\"Notoriously difficult\" issue, anecdotal evidence"
                  "[Claessen & Hughes 2000]" #f)
            (cite "handful of bugs, simply-typed λ-calculus"
                  "[Cheney, Momigliano, PPDP 2006]" #f)
            (cite "functional data structures, exhausting bounded spaces, 2 counterexamples,"
                  "[Runciman, Naylor, Lindblad, Haskell 2008]" #f)
            (cite "200 Random mutations, typos in data structures, limit to 30 sec."
                  "[Bulwahn, CPP 2012]" #f))
  
  (slide (scale-to-fit
          (vc-append 20
           (cc-superimpose
            line-plot-pict
            (ghost (faded-fade (scale (t "Thanks!") 1.5)
                        #:color "white"
                        #:init 0.125
                        #:delta 2
                        #:grads 75)))
           (vc-append (t "Automated testing for")
                      (t "semantics works")))
          titleless-page))

  (slide (scale-to-fit
          (vc-append 20
           (cc-superimpose
            line-plot-pict
            (faded-fade (scale (t "Thanks!") 1.5)
                        #:color "white"
                        #:init 0.125
                        #:delta 2
                        #:grads 75))
           (vc-append (t "Automated testing for")
                      (t "semantics works")))
          titleless-page)))