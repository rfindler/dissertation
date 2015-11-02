#lang scribble/base

@(require scribble/manual
          scribble/eval
          "../common.rkt"
          "examples.rkt"
          "code.rkt")

@(define adhoc-eval (make-base-eval))

@(adhoc-eval `(require redex/reduction-semantics
                      racket/pretty
                      ,examples-rel-path-string))

@(adhoc-eval '(pretty-print-columns 60))


@title[#:tag "sec:ad-hoc"]{Ad-hoc Recursive Generators}

Given a grammar, a straightforward method for generating random
terms conforming to some non-terminal is as follows. First,
pick a production at random. If that production does not
include any non-terminals, we are done. If it contains
non-terminals, we recur on them using the same method
until reaching a non-recursive production.

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
in Racket implementing this method. The only thing we
need to be careful of is the danger of nontermination
arising from randomly choosing recursive
productions too often. We can deal with this by adding
a ``fuel'' parameter that is decremented on recursive
calls and only allows choosing recursive productions if
it is positive, thus placing a limit on the depth of
the generated term. Here is one implementation, as a
function that takes a symbol indicating a non-terminal,
a natural number indicating ``fuel'', and returns an
appropriate random term:
@(racketblock #,generate-arith-stxobj)
(The predicate @code{arith?} appearing in the contract
on the second line checks that the result does
indeed conform to a non-terminal of the grammar above.)
So, to generate a random expression, we can call
@code{generate-arith} with @code{'e} and a depth limit
of @code{3}, for a medium-sized term:
@(adhoc-eval '(random-seed 9))
@interaction[#:eval adhoc-eval
                     (generate-arith 'e 3)]
            
The transformation from a grammar into such a function
is easily automated. Redex's ad-hoc grammar
generator performs just such a transformation, and
although the grammars and patterns used in Redex
can be significantly richer than those in this
example, the method used is fundamentally the same.

Even in our simple example, however, we have made
choices that can significantly affect the quality of
our generator in testing. Most significantly, we
have chosen to sample our numbers for the @code{n}
non-terminal uniformly from
integers in the interval between 0 and 100. This
was done here for the sake of simplicity, and a
little thought reveals it to be a very poor choice in general.
A good test case generator should generate all types
of numbers, which for Racket includes integers of
unbounded magnitude, the usual floating point types,
and even complex numbers. Further, a good generator
should favor corner cases such as @code{0} and @code{1},
and, in Racket's case, @code{+inf.0}, a number larger than
all other numbers. Similar issues arise when generating
strings or symbols. Neglecting this point is common in
naive critiques of random test-case generators.
Redex's grammar generator contains many such heuristics
that have been tuned over years to make it more
effective for random testing, which is why I refer
to it as ``ad-hoc.'' (See @citet[sfp2009-kf] for a
discussion of some of these heuristics.)

Another concern about the testing effectiveness of
generators of this type is that many properties that
are desirable to test require preconditions that are
much stronger than conformance to a grammar. For
example, they may require closed terms, or even
well-typed terms. In such cases the fraction of
valid expressions conforming to a grammar that meet
the stronger condition is usually very small.
Even the ratio of closed lambda terms to lambda
terms becomes vanishingly small as the size of terms
increases, as shown by @citet[counting-lambdas]. To compensate,
random generation from a grammar can still be leveraged
by post-processing the term to fix these deficiencies.
It is straightforward, for example, to write a function
to eliminate free variables by adding new bindings or
replacing them with closed subterms.

In spite of the issues with recursive grammar generation,
it has been used many times over the years to great
effect, starting with the landmark study of
@citet[Hanford]. In fact, it is referred to as ``the
predominant generation strategy for language fuzzing''
as recently as @citet[clp-language-fuzzing].
It has been the default strategy in Redex since
@citet[sfp2009-kf] and has been shown to be effective
(when combined with a good post-processing function)
in both a study testing the Racket virtual machine in
@citet[Racket-VM] and a case-study of models from
ICFP 2009 conducted by @citet[run-your-research].
Another recent tool based on this approach (although
using sophisticated ad-hoc additions) is Csmith@~cite[csmith].