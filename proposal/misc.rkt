#lang racket

(require slideshow
         "common.rkt"
         "settings.rkt")

(provide do-my-work)

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

  
