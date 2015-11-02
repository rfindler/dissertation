#lang scribble/base

@(require "../common.rkt"
          "bug-info.rkt"
          scribble/core
          scriblib/figure
          scriblib/footnote
          scribble/manual
          racket/format
          racket/match
          racket/function
          (only-in pict scale))

@title[#:tag "sec:benchmark"]{The Redex Benchmark}

This chapter introduces the Redex Benchmark, a suite of Redex
models and bugs. The benchmark is intended to
support the comparative evaluation of different methods of
automated property-based testing. @Secref["sec:benchmark-why"]
discusses the problem of evaluating test-case generators and
the approach used in this research, and @secref["sec:benchmark-models"]
describes the models and bugs used in the benchmark in detail.
In @secref["sec:benchmark-eval"] the benchmark is applied to compare
the different methods of random generation used by Redex.

@include-section["bench-why.scrbl"]

@include-section["bench-models.scrbl"]