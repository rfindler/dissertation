#lang scribble/base

@(require scribble/manual
          "examples.rkt"
          "code.rkt")

@title[#:tag "sec:ad-hoc"]{Ad-hoc Recursive Generators}

Given a grammar, an obvious method for generating random
terms conforming to some non-terminal is as follows. First,
pick a production at random. If that production does not
include any non-terminals, we are done. If it contains
non-terminals, recur using the same method until reaching
a non-recursive production.

To illustrate this approach, consider the following simple
grammar for prefix-notation arithmetic expressions:
@(centered (arith-pict))
To generate a random expression in this language, we can
start with the non-terminal @ap['e] as our initial goal
and transform it step-by-step into a term, where each step
replaces a non-terminal with one of its productions:
@(centered (arith-gen-example-pict))
Since in our grammar @ap['number] is shorthand for the
entire set of numbers, we just choose some element of
that set for the non-terminal @ap['n].

It is straightforward to write a recursive function
in Redex implementing this method. The only thing we
need to be careful of is the danger of unrestricted
recursion arising from randomly choosing recursive
productions too often. We can deal with this by adding
a ``fuel'' parameter that is decremented on recursive
calls and only allows choosing recursive productions if
it is positive, thus placing a limit on the depth of
the generated term. One way of writing such a function
is as follows:
@(racketblock #,generate-arith-stxobj)