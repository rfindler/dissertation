#lang racket/base

(require scribble/core 
         scribble/manual
         racket/list
         racket/port
         rackunit
         scribble/decode
         (for-syntax racket/base))

(provide raw-latex a-quote
         texmath
         racketblock/define
         add-commas
         theorem
         proof
         definition
         qed
         assert)

(define-syntax (assert stx)
  (syntax-case stx ()
    [(_ e)
     #`(assert/proc '#,(syntax-source stx) #,(syntax-line stx) (λ () e) 'e)]))
(define (assert/proc source line thunk exp)
  (unless (thunk)
    (error 'assert "assertion ~a:~a failed:\n  ~s" source line exp)))

(define (texmath arg)
  (raw-latex (string-append "$" arg "$")))

(define (raw-latex . args)
  (element (style "relax" '(exact-chars))
           args))

(define (a-quote . args)
  (nested-flow (style 'inset '()) (list (paragraph (style #f '()) args))))

(define-syntax-rule
  (racketblock/define exp)
  (begin (racketblock exp)
         exp))

(define (add-commas n)
  (define s (format "~a" n))
  (define comma-every 3)
  (define cs
    (let loop ([chars (reverse (string->list s))])
      (cond
        [(<= (length chars) comma-every) chars]
        [else 
         (append (take chars comma-every)
                 '(#\,)
                 (loop (drop chars comma-every)))])))
  (apply string (reverse cs)))

(check-equal? (add-commas 1) "1")
(check-equal? (add-commas 12) "12")
(check-equal? (add-commas 123) "123")
(check-equal? (add-commas 1234) "1,234")
(check-equal? (add-commas 12345) "12,345")
(check-equal? (add-commas 123456789) "123,456,789")
(check-equal? (add-commas 1234567890) "1,234,567,890")

(define-syntax (define-environment stx)
  (syntax-case stx ()
    [(_ id)
     (identifier? #'id)
     #'(define-environment id #f)]
    [(_ id neg-space?)
     #`(define (id . args) (environment/proc 'id args neg-space?))]))
(define (environment/proc id args neg-space?)
  (compound-paragraph (style (symbol->string id) '())
                      (list (decode-compound-paragraph
                             (if neg-space?
                                 (cons (element (style "vspace" '(exact-chars)) "-.15in")
                                       args)
                                 args)))))

(define-environment theorem)
(define-environment proof #t)
(define-environment definition)
(define qed (element (style "qed" '()) '()))

