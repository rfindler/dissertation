#lang scribble/base

@(require racket/port
          scribble/core
          "common.rkt"
          "util.rkt")

@(element "title" '("Automated Testing for Operational Semantics"))

@(element "maketitle" '())

@(define abstract-text
   (call-with-input-file "../abstract.txt"
     (λ (in) (read-line in) ;; drop title
       (port->string in))))

@(abstract abstract-text)
@acknowledgements{Thanks to everyone!
                  
                  To be completed.}

@table-of-contents[]

@include-section{introduction/introduction.scrbl}
@include-section{redex-intro/redex.scrbl}
@include-section{grammar/grammar.scrbl}
@include-section{derivation/deriv.scrbl}
@include-section{semantics/semantics.scrbl}
@include-section{benchmark/benchmark.scrbl}
@include-section{evaluation/evaluation.scrbl}
@include-section{related-work/related-work.scrbl}
@include-section{conclusion/conclusion.scrbl}

@generate-bibliography[]

@include-section{appendix/appendix.scrbl}
@include-section{appendix/proof.scrbl}
@include-section{appendix/bugs.scrbl}

