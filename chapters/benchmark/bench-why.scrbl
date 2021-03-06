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


@title[#:tag "sec:benchmark-why"]{Benchmark Rationale and Related Work}

As @citet[QuickCheck] point out in the original paper on QuickCheck,
it is ``notoriously difficult'' to evaluate the effectiveness
of an approach to testing.
Their paper provided strong anecdotal evidence that
QuickCheck was effective for a variety of users with a variety
of different applications, but didn't attempt a systematic study of its
effectiveness. (A comparative study wasn't as easy
to attempt at the time since their own tool was the first to popularize
property-based testing for functional programmers.)
In their case, the success of QuickCheck over the
years has become the strongest evidence of its usefulness.

Subsequent efforts have made the attempt to be more
systematic. In a study introducing SmallCheck, a property-based testing
library for Haskell using exhaustive generation (as opposed to random
generation in QuickCheck's case), @citet[small-check] compare SmallCheck,
Lazy SmallCheck, and QuickCheck on a few different programs:
implementations of red-black trees, Huffman coding/decoding, a
compiler from lambda calculus to combinators, and a chess problem
solver. Since they are doing exhaustive testing, they give results
for generation times of all inputs up to a certain depth, which
one can argue should be correlated to testing effectiveness.
In terms of finding actual faults, they report
that two counterexamples were exposed during their study, both
by Lazy SmallCheck, and give a cursory
a description of one, for red black trees, where ``a fault was
fabricated in the rebalancing function by swapping two subtrees.''
The small number of counterexamples makes it difficult to draw
solid conclusions about testing effectiveness.

A more recent comparative study was conducted by
@citet[isabelle-quickcheck-bulwahn] to evaluate a derivative of QuickCheck
for the Isabelle@~cite[isabelle] proof assistant. In this
study, a number of different testing strategies were
evaluated on a database of theorem mutations, faulty implementations
of functional data structures, and an implementation of a hotel
key-card system. The mutation database includes 400 mutated theorems
from the areas of arithmetic, set theory, list data types, and examples
drawn from the Isabelle Archive of Formal Proofs. The mutations were
introduced by replacing constants and swapping arguments, and each
testing method was given 30 seconds to find a counterexample to a
given mutation. For the functional data structures, typos in the
delete operation were introduced to create faulty versions of AVL,
red-black, and 2-3 trees, and the property that delete preserved
balance and ordering was tested, again with a time limit of 30 seconds.
The hotel key-card system allowed a possible man-in-the-middle
attack, which one method was able to find in ten minutes.

The Redex benchmark attempts as much as possible to measure
how effective different automated testing methods are at finding
counterexamples to real-world bugs on real-world models. Models
come from two sources: pre-existing Redex models and those
synthesized for the benchmark. In both cases an effort has been made
to use models that are ``typical'' of those that Redex users write.
Bugs are inserted by hand into the models, and are either actual
bugs introduced and found during the development of the model,
or inserted because they are judged to be representative of bugs
that could be introduced in a typical development.
A short description of each model and each bug is given in
@secref["sec:benchmark-models"]. 

The models themselves represent a wider variety and a deeper
complexity than those used in previous studies. As in both studies
mentioned above, we include an implementation of a functional data
structure, namely red-black trees. The rest of the models, however,
are programming languages or virtual machines that typically have much
richer properties to test, such as type-soundness. This provides a broader
range of models and properties to test and targets
the domain (PL semantics) for which Redex's automated testing support
is intended.

We also test the models for much longer time periods, up to 24 hours
(or more, if uncertainty remains large) for each generator/bug pair. This is intended to coincide
more closely with actual use cases, where a test run may frequently
extend over lunch, overnight, or a weekend. It also exposes
differences at larger time scales that can be exploited
through optimization of the testing method or parallelism.
(Since test runs are independent, it is easy to take
advantage of parallelism in this setting.)

Finally, as a metric we choose the (average) time to find a counterexample.
This measures exactly the property we desire in a test generator. Other possibilities, such
as the time to exhaust a finite space of possible test cases, or the
ratio of attempts to counterexample, are also interesting, but are not as
general. A smaller number of attempts per counterexample, for example, may be
desirable, but not if the cost per attempt becomes too large. We regard
such more specific properties as useful in diagnosing or improving the
performance of a specific generator, but not for making
the type of general comparisons we are interested in examining
with the benchmark.