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

@table-of-contents[]

@include-section{redex-intro/redex.scrbl}
@include-section{semantics/semantics.scrbl}

@generate-bibliography[]

@include-section{appendix/appendix.scrbl}
@include-section{appendix/proof.scrbl}

