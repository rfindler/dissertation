#lang racket

(require slideshow
         pict
         pict/flash
         unstable/gui/pict
         "common.rkt"
         "settings.rkt")

(provide do-automated-testing)

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
                    

(define (do-automated-testing)
  (slide
   (scale-to (pb-pict-emph)
             (pict-width (inset titleless-page -50))
             (pict-height (inset titleless-page -50))))
  
  (slide
   (scale-to (pb-pict-emph #t)
             (pict-width (inset titleless-page -50))
             (pict-height (inset titleless-page -50)))))


