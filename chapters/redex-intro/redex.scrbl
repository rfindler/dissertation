#lang scribble/base

@(require scriblib/figure
          scribble/eval
          scribble/manual
          scriblib/footnote
          racket/match
          racket/sandbox
          racket/path
          "../../model/stlc.rkt"
          "../common.rkt"
          "code-utils.rkt"
          (for-syntax racket/syntax))

@title[#:tag "sec:semred"]{Operational Semantics and PLT Redex}

This chapter provides background in operational semantics and
how it is modeled in Redex. It is by no means a comprehensive
or systematic summary of either topic, but is intended to explain
just enough to understand the rest of the dissertation and show
how lightweight semantics engineering works. It begins with an
introduction to reduction semantics, the type of operational
semantics used by Redex, in @secref["sec:semantics-intro"],
by working through
the step-by-step development of a semantics for a simple
functional language. Then @secref["sec:redex-modeling"] shows
how the same language can be coded and run as Redex model that
is comparable in size and concision to the pencil
and paper semantics. Finally, @secref["sec:redex-testing"]
demonstrates the application of Redex's property-based testing
tools to the model.

@include-section["redex-intro.scrbl"]

@include-section["using-redex.scrbl"]

@include-section["testing.scrbl"]

