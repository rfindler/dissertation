#lang scribble/base

@(require scribble/core
          "common.rkt"
          "util.rkt")

@(element "title" '("Automated Testing for Operational Semantics"))

@(element "maketitle" '())

@abstract{
We present a technique for the random generation of well-typed expressions. The technique
requires only the definition of a type-system in the form of inference rules and auxiliary
functions, and produces random expressions satisfying the type system. In addition, we detail the
implementation of a generator using this approach as part PLT Redex, a lightweight semantics
modeling language and toolbox embedded in Racket. Specifically, we discuss a specialized
constraint solver we have developed to support the generation of random derivations, and how
Redex definitions are compiled into inputs for the solver during the process of generating a
random type derivation.

Since our motivation for developing this generator is to do a better job at random testing, we also
evaluate its random testing performance. To do so, we have developed a random-testing
benchmark of Redex models. We discuss the development of the benchmark and show that our
new approach to  
}

@table-of-contents[]

@include-section{redex-intro/redex.scrbl}
@include-section{semantics/semantics.scrbl}

@generate-bibliography[]

@include-section{appendix/appendix.scrbl}
@include-section{appendix/proof.scrbl}

