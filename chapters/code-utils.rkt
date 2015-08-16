#lang racket/base

(require racket/match)

(provide read-stxobjs
         extract-def)

(define (read-stxobjs path)
  (parameterize ([port-count-lines-enabled #t])
     (call-with-input-file path
       (λ (in)
         (read-line in)
         (let loop ([ds '()])
           (define next (read-syntax in in))
           (if (eof-object? next)
               ds
               (loop (cons next ds))))))))

(define-syntax-rule (extract-def objs the-match)
  (findf (λ (stx)
           (match (syntax->datum stx)
             [the-match #t]
             [_ #f]))
         objs))
