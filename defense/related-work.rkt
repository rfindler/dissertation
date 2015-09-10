#lang racket

(require slideshow
         pict
         "common.rkt"
         "settings.rkt")

(provide do-related-work)

(define show-maybes (make-parameter #f))
(define lightweight-only (make-parameter #f))

(define (maybe-text)
  ((if (show-maybes) values ghost)
   (parameterize ([current-main-font font:base-font])
     (colorize (t " with automated checking")
               colors:emph-dull))))

(define (tool name maybe-automated-tests lightweight)
  (define name-p (t name))
  (item (refocus
         (hbl-append
         (cc-superimpose name-p
                         (if (or (and (not maybe-automated-tests) (show-maybes))
                                 (and (not lightweight) (lightweight-only)))
                              (colorize (linewidth 3 (hline (pict-width name-p) 0))
                                        colors:emph-dull)
                              (blank 0 0)))
         (if (and maybe-automated-tests (show-maybes))
             (parameterize ([current-main-font font:base-font])
               (colorize (t maybe-automated-tests)
                         colors:emph-dull))
             (blank 0 0)))
         name-p)))


(define (rw-slide area . cites)
  (slide #:title "Related work"
         (scale-to-fit
          (s-frame
           (vc-append 20 (colorize
                          (parameterize ([current-main-font font:base-font])
                            (t area))
                          colors:emph-dull)
                      (apply vl-append (cons 10 cites))))
          titleless-page)))

(define (tools-slide)
  (slide #:title "Related work"
         (s-frame (vc-append 20 (vc-append (hbl-append 
                                            ((if (lightweight-only) values ghost)
                                             (colorize
                                              (parameterize ([current-main-font font:base-font])
                                                (t "Lightweight"))
                                              colors:emph-dull))
                                            (t " Semantics Frameworks"))
                                           (maybe-text))
                             (vl-append 10
                                        (tool "αML" #f #t)
                                        (tool "αProlog" " model checking" #t)
                                        (tool "Coq" #f #f)
                                        (tool "Isabelle/HOL" #f #f)
                                        (tool "K" " model checking" #t)
                                        (tool "Ott/Lem" #f #t)
                                        (tool "Ruler" #f #t))))))


(define (do-related-work)
  
  
  (slide #:title "Related work"
         (s-frame (vc-append 20 (colorize
                                 (parameterize ([current-main-font font:base-font])
                                   (t "Most closely related, by category"))
                                 colors:emph-dull)
                             (vl-append 10
                              (item "Semantics frameworks")
                              (item "Well-typed term generation")
                              (item "CLP for random generation")
                              (item "Comparative automated testing studies")))))
  
  (tools-slide)
  
  (parameterize ([lightweight-only #t])
    (tools-slide)
    (parameterize ([show-maybes #t])
      (tools-slide)))
         
  (rw-slide "Well-typed term generation"
            (cite "Testing an optimising compiler by generating random lambda terms"
                  "[Pałka, Claessen, Russo, Hughes, AST 2011]")
            (cite "Generating Constrained Random Data with Uniform Distribution"
                  "[Claessen, Duregård, Pałka, FLOPS 2014]")
            (cite "Mechanized Metatheory Model Checking"
                  "[Cheney, Momigliano, PPDP 2006]"))
  
  (rw-slide "CLP for random generation"
            (cite "Language Fuzzing Using Constraint Logic Programming"
                  "[Dewy, Roesch, Hardekopf, ASE 2014]")
            (cite "Automated Data Structure Generation: Refuting Common Wisdom"
                  "[Dewey, Nichols, Hardekopf, ICSE 2014]"))
  (rw-slide "Automated testing, comparative studies"
            (cite "SmallCheck and Lazy SmallCheck: automatic exhaustive testing for small values"
                  "[Runciman, Naylor, Lindblad, Haskell 2008]")
            (cite "The New Quickcheck for Isabelle: Random, Exhaustive and Symbolic Testing under One Roof"
                  "[Bulwahn, CPP 2012]")
            #;(cite "An Empirical Comparison of Automated Generation and Classification Techniques for Object-Oriented Unit Testing"
                  "[d'Amorim, Pacheco, Xie, Marinov, Ernst, ASE 2006]")))