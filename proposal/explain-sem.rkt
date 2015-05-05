#lang racket

(require slideshow
         pict
         unstable/gui/pict
         unstable/gui/pict/align
         "common.rkt"
         "settings.rkt")

(provide do-lse-tree)

(struct node (text children))

(define the-tree
  (node "Semantics"
        (list (node "Denotational" #f)
              (node "Operational"
                    (list (node "Mechanized"
                                (list (node "Heavyweight" #f)
                                      (node "Lightweight"
                                            (list (node "Semantics\nEngineering" #f))))))))))

(define layout-t
  (match-lambda
    [(node txt #f)
     (define t-p (t/n txt))
     (tag-pict (cc-superimpose (colorize (filled-rounded-rectangle (+ 20 (pict-width t-p))
                                                                   (+ 20 (pict-height t-p))
                                                                   -0.1)
                                         colors:emph-bright)
                               t-p)
               (string->symbol txt))]
    [(node txt (list cs ...))
     (define c-ts (map layout-t cs))
     (define this-node (layout-t (node txt #f)))
     (refocus
      (for/fold ([base-pict
                  (vc-append 100 this-node
                             (apply hc-append (cons 100 c-ts)))])
                ([c-t (in-list c-ts)])
        (pin-arrow-line 30 base-pict
                        this-node cb-find
                        c-t ct-find
                        #:line-width 4
                        #:color colors:emph-dull))
      this-node)]))

(define (layout-tree p) (tag-pict ((compose panorama layout-t) p) 'base))

(define (zoom-to base internal-tag n closeness)
  (define to-p  (car (find-tag base (string->symbol internal-tag))))
  (define-values (x1 y1) (lt-find base to-p))
  (define-values (x2 y2) (rb-find base to-p))
  (define box (blank (- (pict-width base) (* n (- (pict-width base) (* closeness (- x2 x1)))))
                     (- (pict-height base) (* n (- (pict-height base) (* closeness (- y2 y1)))))))
  (define x-center (/ (+ x2 x1) 2))
  (define y-center (/ (+ y2 y1) 2))
  (define x-l (- x-center (/ (pict-width box) 2)))
  (define y-t (- y-center (/ (pict-height box) 2)))
  (scale-to
   (refocus (pin-over base
                      (* x-l n)
                      (* y-t n)
                      box)
            box)
   (pict-width titleless-page)
   (pict-height titleless-page)))

(require racket/draw)

(define freeze
  (case-lambda
    [(p l t r b)
     (define insetted (inset p l t r b))
     (define bmp (make-bitmap (inexact->exact (ceiling (pict-width insetted)))
                              (inexact->exact (ceiling (pict-height insetted)))))
     (define bdc (make-object bitmap-dc% bmp))
     (send bdc set-smoothing 'aligned)
     (draw-pict insetted bdc 0 0)
     (send bdc set-bitmap #f)
     (inset (bitmap bmp) (- l) (- t) (- r) (- b))]
    [(p) (freeze p 0 0 0 0)]))

(define (decorate-node base node-tag text combine)
  (define node-p (car (find-tag base (string->symbol node-tag))))
  (define anchor (blank (pict-width node-p) (pict-height node-p)))
  (pin-over base
            node-p
            cc-find
            (refocus (combine anchor (freeze (s-frame (t/n text))))
                     anchor)))
            

(require slideshow/play)

(define slides-title "Lightweight Semantics Engineering")

(define (do-lse-tree)
  (define last-p
    (for/fold ([p (layout-tree the-tree)])
              ([zoom/add (in-list `(("Semantics" "f : programs -> answers" ,vc-append)
                                    ("Denotational" "f : syntax ->\nmathematical object" ,vc-append)
                                    ("Operational" "f : syntax -> syntax" ,hc-append)
                                    ("Mechanized" "a programming\nlanguage" ,hc-append)
                                    ("Heavyweight" "for proving theorems" ,vc-append)
                                    ("Lightweight" "for developing\nmodels" ,hc-append)
                                    ("Semantics\nEngineering"
                                     "engineered as\nsoftware"
                                     ,hc-append)))])
      (match-define (list zoom-tag decorator comb) zoom/add)
      (play-n ;#:title slides-title
              (λ (n)
                (zoom-to p zoom-tag n 3)))
      ((if decorator
          (λ (p)
            (decorate-node p zoom-tag decorator comb))
          values)
       (zoom-to p zoom-tag 1 3))))
  
  (play-n  #:title slides-title
           (λ (n)
             (zoom-to last-p "base" n 1))))
