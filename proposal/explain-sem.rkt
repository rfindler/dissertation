#lang racket

(require slideshow
         pict
         "common.rkt"
         "settings.rkt")

(struct node (text children))

(define the-tree
  (node "Semantics"
        (list (node "Denotational" #f)
              (node "Operational"
                    (list (node "Mechanized"
                                (list (node "Heavyweight" #f)
                                      (node "Lightweight"
                                            (list (node "Semantics Engineering" #f))))))))))

(define layout-t
  (match-lambda
    [(node txt #f)
     (define t-p (t txt))
     (cc-superimpose (colorize (filled-rounded-rectangle (+ 20 (pict-width t-p))
                                                         (+ 20 (pict-height t-p))
                                                         -0.1)
                               colors:emph-bright)
                     t-p)]
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

(define layout-tree (compose panorama layout-t))