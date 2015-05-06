#lang racket

(require slideshow
         unstable/gui/pict
         "common.rkt"
         "settings.rkt")

(provide do-my-work
         do-redex-comp)

(define (make-dual-pict f-title ta-list)
  (define titles (map (lambda (t) 
                        (item (it t)))
                      (map first ta-list)))
  (define authors (map (lambda (txt)
                         (hbl-append (ghost (t "XXX"))
                                     (t txt)))
                       (map second ta-list)))
  (define ftp (colorize (parameterize ([current-main-font font:base-font])
                          (hc-append (let ([sp (ghost (t "XXXXXX"))])
                                       (cc-superimpose (linewidth 5 (hline (* (pict-width sp) 0.75) 0))
                                                       sp))
                                     (t f-title)))
                        colors:emph-dull))
  (match-lambda
   ['both (vl-append 10 ftp
                     (apply vl-append 5 (let loop ([ts titles]
                                                   [as authors])
                                          (cond
                                           [(empty? ts) ts]
                                           [else (cons (car ts)
                                                       (cons (car as)
                                                             (loop (cdr ts) (cdr as))))]))))]
   ['titles  (vl-append 10 ftp (apply vl-append (cons 5 titles)))]))

(define d-rel (make-dual-pict "Directly related"
                              (list
                               (list "Making Random Judgments"
                                     "[Fetscher, Claessen, Palka, Hughes, Findler, ESOP 15]")
                               (list "fFeat: Fair Functional Enumerations of Algebraic Types"
                                     "[New, Fetscher, McCarthy, Findler, ICFP 15]"))))

(define ind-rel (make-dual-pict "Indirectly related"
                                 (list
                                  (list "A Coq Library For Internal Verification of Running-Times"
                                        "[McCarthy, Fetscher, New, Findler, in preparation]")
                                  (list "POP-PL: A Patient-Oriented Prescription Language"
                                        "[Florence et al.], in submission"))))

(define n-rel (make-dual-pict "Not really related"
                               (list
                                (list "Seeing the Futures: Profiling Shared-Memory Parallel Racket"
                                      "[Swaine, Fetscher, St-Amour, Findler, Flatt, FHPC 12]"))))
                                      
(define (do-my-work)
  (slide #:title "Publications" (s-frame (d-rel 'both)
                                         (ind-rel 'both)
                                         (n-rel 'both))))


(define (redex-comp-pict)
  (define (bubble str)
    (define txt-p (t str))
    (tag-pict
     (cc-superimpose
      (colorize
       (filled-ellipse (* (pict-width txt-p) 1.25)
                       (/ (+ (pict-width txt-p)
                             (pict-height txt-p))
                          2))
       colors:emph-dull)
      txt-p)
     (string->symbol str)))
  (define mid-bub
    (bubble "Redex"))
  (define base-p
    (table 3 (list (blank 0 0) (bubble "Definition") (blank 0 0)
                   (bubble "Execution") (blank 0 0) (bubble "Exploration")
                   (blank 0 0) (tag-pict (bubble "Redex") 'redex-middle) (blank 0 0)
                   (bubble "Typesetting") (blank 0 0) (bubble "Testing"))
           cc-superimpose cc-superimpose
           20 20))
  (define 4-arrs
   (for/fold ([p base-p])
             ([arrow (in-list `(("Execution" ,cb-find ,(/ (* 3 pi) 2) ,lc-find 0)
                                ("Typesetting" ,ct-find ,(/ pi 2) ,lc-find 0)
                                ("Exploration" ,cb-find ,(/ (* 3 pi) 2) ,rc-find ,pi)
                                ("Testing" ,ct-find ,(/ pi 2) ,rc-find ,pi)))])
     (match-define (list tagstr to to-ang from from-ang) arrow)
     (pin-arrow-line 20 p
                     (car (find-tag p 'redex-middle)) from
                     (car (find-tag p (string->symbol tagstr))) to
                     #:start-angle (- from-ang)
                     #:end-angle (- to-ang)
                     #:line-width 6
                     #:color colors:emph-bright
                     #:under? #t)))
  (pin-arrow-line 20 4-arrs
                  (car (find-tag 4-arrs 'Definition)) cb-find
                  (car (find-tag 4-arrs 'redex-middle)) ct-find
                  #:start-angle (- (/ pi 2))
                  #:end-angle (- (/ pi 2))
                  #:line-width 6
                  #:color colors:emph-bright
                  #:under? #t))
  
(define (do-redex-comp)
  (slide (scale-to
          (redex-comp-pict)
          (pict-width (inset titleless-page -25))
          (pict-height (inset titleless-page -25)))))
  
