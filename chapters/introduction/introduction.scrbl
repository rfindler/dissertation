#lang scribble/base

@(require "../common.rkt"
          "../util.rkt")

@title[#:tag "sec:intro"]{Introduction}

Computer scientists have many tools for understanding programming
languages, developed over years of research. Typically those tools
were developed along with and applied to small language models,
calculi that could fit on a few pages of paper or a whiteboard.
Complete models of real programming languages, or even fragments
of them, are frequently much larger. For this reason, tools for
mechanizing language semantics, allowing researchers to develop
models for real languages, have been a long-standing subject of research.
This dissertation investigates the combination of lightweight
support for such mechanization with property-based testing, an
approach to testing that proves to be particularly effective
for semantics engineering.

Lightweight mechanization is distinguished by providing support
for executable definitions, and perhaps associated tools, but
requiring little effort further than defining a model. More
powerful tools, in contrast, enable machine-checked proofs of
soundness properties, but developing such proofs requires
more work; writing down definitions is only the beginning of
the process. (Although finding the right definitions may take
more time.) Lightweight mechanization is not an end-to-end
solution, and complete efforts at verification will usually
require a proof assistant or equivalent tool in the end.
However, a lightweight tool can be very useful for many phases
of a semantics engineering process.

Lightweight mechanization allows a semantics to be engineered
as software, providing the benefits of executability and
testing with low investment. Low investment also means changes
are low cost, so development can be incremental and iterative.

...

In the end, testing and other forms of automated but
non-exhaustive checking may not be enough to provide full confidence
that a model is correct, at which point definitions can be ported into
a more powerful tool for verification

...

The thesis of this dissertation is:
@centered[@bold[(list thesis)]]
To support this thesis, I show how lightweight definitions for a
semantics can be leveraged to automatically derive test-case
generators that effectively expose counterexamples when
applied to representative Redex models.

...

Chapter 2 introduces operational semantics and Redex
in brief by working through the development of a semantics for
a small functional language, followed by a discussion of how
to mechanize and test the model in Redex.
Following that, I discuss the approaches to test-case generation
used by Redex. Chapter 3 introduces two approaches to generation
based on regular-tree grammars: ad-hoc recursive generators
and enumerations. An alternative approach that searches for
random derivations satisfying relation and function definitions
is introduced in Chapter 4 with an example, and is formally specified
and discussed in depth in Chapter 5. Chapter 6 discusses the
development of a benchmark intended for comparative evaluation
of automated testing methods. The different test generation methods used by
Redex are compared using the benchmark in the first section of Chapter 7, and
the second section compares the derivation generator to a
similar but more specialized generator. Finally, Chapter 8
discusses related work and Chapter 9 concludes.
@;{

II. Mechanization
a. heavyweight
b. lightweight

testing

checking

property-based testing

random testing

exhaustive checking

semantics

lightweight semantics

gap between core calculus and real languages

mechanization to the rescue

approaches to mechanization

CompCert

C in K

Lambda JS

Lambda Pi (Full Monty)}