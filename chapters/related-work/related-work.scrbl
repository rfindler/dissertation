#lang scribble/base

@(require scriblib/figure
          scribble/manual
          scriblib/footnote
          slideshow/pict
          "citations.rkt")

@title[#:tag "sec:related"]{Related Work}

Work related to the constraint solver is addressed in
@secref["sec:related-dqs"], and studies on random testing
most closely related to those of this work are discussed
in @secref["sec:benchmark-why"]. This chapter discusses
related work in random and property-based testing and
its application in semantics engineering.

@section[#:tag "sec:related-testing"]{Property-based Testing}

Quickcheck@~cite[QuickCheck] is a widely-used library
for random testing in Haskell. It provides combinators supporting the
definition of testable properties, random generators, and analysis
of results. Although Quickcheck's approach is much more general than
the one taken here, it has been used to implement a random generator
for well-typed terms robust enough to find bugs in GHC@~cite[palka-diss].
This generator provides a good contrast to the approach of this work,
as it was implemented by hand, albeit with the assistance of a powerful
test framework. Significant effort was spent on adjusting the distribution
of terms and optimization, even adjusting the type system in clever
ways. Redex's approach, on the other hand, is to provide a straightforward
way to implement a test generator. The relationship to Pałka's work is discussed
in more detail in @secref["sec:ghc"], including a direct comparison
on a few of the properties tested by @citet[palka-diss].

SmallCheck and Lazy SmallCheck@~cite[small-check] are other Haskell libraries
for property-based testing. They differ from QuickCheck in that they
use exhaustive testing instead of random testing. Lazy SmallCheck is
particularly successful, using partial evaluation to prune the space
from which test cases are drawn based on the property under test.
They also perform a comparative evaluation of SmallCheck, Lazy SmallCheck,
and QuickCheck.

Perhaps the most closely related work is @citet[uniform]'s
typed term generator. Their work addresses specifically the
problem of generating well-formed lambda terms based an
implementation of a type-checker (in Haskell). They measured
their approach against property 1 from @secref["sec:ghc"]
and it performs better than Redex's 'poly' generator, but they are
working from a lower-level specification of the type system.
Also, their approach observes the order of
evaluation of the predicate, and prunes the search space
based on that; it does not use constraint solving.

Efficient random generation of abstract data types has seen some interesting
advances in previous years, much of which focuses on enumerations.
Feat@~cite[feat], or ``Functional Enumeration of Algebraic Types,'' is a 
Haskell library that exhaustively enumerates a datatype's possible values.
The enumeration is made very efficient by memoising cardinality metadata,
which makes it practical to access values that have very large indexes.
The enumeration also weights all terms equally, so a random sample of values
can in some sense be said to have a more uniform distribution. Feat was used 
to test Template Haskell by generating AST values, and compared favorably with
Smallcheck in terms of its ability to generate terms above a certain size.
(QuickCheck was excluded from this particular case study because it was
``very difficult'' to write a QuickCheck generator for ``mutual recursive
datatypes of this size'', the size being around 80 constructors. This provides 
some insight into the effort involved in writing the generator described
in @citet[palka-diss].)

Another, more specialized, approach to enumerations was taken by 
@citet[counting-lambdas]. Their work addresses specifically the problem
of enumerating well-formed lambda terms. (Terms where all variables
are bound.) They present a variety of combinatorial results on
lambda terms, notably some about the extreme scarcity of simply-typable
terms among closed terms. As a by-product they get an efficient generator
for closed lambda terms. To generate typed terms their approach
is simply to filter the closed terms with a typechecker. This approach
is somewhat inefficient (as one would expect due to the rarity of typed
terms) but it does provide a uniform distribution.

Instead of enumerating terms, @citet[every-bit-counts] develop a
bit-coding scheme where every string of bits either corresponds
to a term or is the prefix of some term that does. Their approach
is quite general and can be used to encode many different types.
They are able to encode a lambda calculi with polymorphically-typed
constants and discuss its possible extension to even more challenging
languages such as System-F. This method cannot be used for random generation
because only bit-strings that have a prefix-closure property correspond
to well-formed terms.

SciFe@~cite[scife] is a Scala library providing combinators that enable
the construction of enumerations similar to those of @secref["sec:enum"].
@citet[scife] conduct a study comparing generation speed for 5 data structures
with nontrivial invariants such a red-black trees or sorted lists. They compare
their approach, the CLP approach described by @citet[clp-test], and
Korat@~cite[korat], and find that their approach is the fastest at exhaustively
generating structures up to a given size.

@citet[clp-test] study the application of CLP to the exhaustive generation
of several different data structures, including red-black trees and
sorted lists. They report on a comparison with Korat@~cite[korat], finding
that their approach is faster than Korat at enumerating all inhabitants
of such constrained types below a given size bound. They also include an
in-depth discussion of how to efficiently implement CLP generators, including
the application of several optimization passes.

Korat@~cite[korat] is an approach to exhaustive testing in Java that uses
a form of state-space filtering to generate data types satisfying general
structural invariants in Java. The authors perform a study comparing its
performance at generating all valid types of a certain size with the Allow Analyzer,
an auotmated analysis tool for a relational specification language. The comparison
is performed using red-black trees, binary heaps, and other data structures.
@;{
@section[#:tag "sec:lightweight"]{Lightweight tools for semantics}

K - @citet[k-overview]

Maude - @citet[maude2]

Ott - @citet[ott]

Lem - @citet[lem]

ASF+SDF - @citet[asf+sdf]}

@section[#:tag "sec:other"]{Testing and Checking Semantics}

Random program generation for testing a semantics or programming language
implementation is certainly not a new idea, and goes back as least to
the ``syntax machine'' of @citet[Hanford], a tool for producing random
expressions from a grammar similar to the ad-hoc generation method of
@secref["sec:ad-hoc"]. The tool was intended for compiler fuzzing, a common
use for that type of random generation. Other applications of random testing to
compilers throughout the years are discussed in the 1997 survey of
@citet[compiler-testing].

In the area of random testing for compilers, of special note is Csmith@~cite[csmith]
a highly effective tool at generating C programs for compiler testing.
Csmith generates C programs that avoid undefined or unspecified behavior.
These programs are then used for differential testing, where the output of a
given program is compared across several compilers and levels of optimization,
so that if the results differ, at least one of test targets must contain a bug.
Csmith represents a significant development effort at 40,000+ lines of C++
and the programs it generates are finely tuned to be effective at finding
bugs based on several years of experience. It had
found over 300 bugs in mainstream C compilers as of 2011.

@citet[αProlog-test] design an automated model-checking framework based on
αProlog@~cite[αProlog], a programming language based on nominal logic,
designed for modeling formal systems.
They advocate automating mechanized checking for semantics in a manner
similar to this work, although their approach is different,
performing exhaustive checking up to some bound on model size.
They conduct a study demonstrating their approach's ability to find bugs in
both the substitution function and the typing judgment of a small
lambda calculus modeled in αProlog. For comparison, the bugs they evaluate
in the substitution function are very similar to @bold{stlc-sub} bugs
1 and 2 from the Redex benchmark, and the type judgment bugs are
very similar to @bold{stlc} or
@bold{poly-stlc} bugs 3 and 9, all of which were found by most
generators in this paper in interactive time periods as well.

@;{
Both exhaustive testing and model-checking methods of automated checking
require imposing an arbitrary size or state space bound, justified by the ``small
scope hypothesis''@~cite[jackson-book], which asserts that any fault can be
exposed with a small counterexample. Of course, even random testing
methods require the specification of some bound on counterexample size,
but it can typically be much larger. Does the small scope hypothesis always apply?
It seems that larger test cases have the potential to be more
efficient at finding bugs by testing multiple aspects of a system at the
same time, or exposing bugs that require interactions between subsystems
that would be difficult to trigger with small bugs. Such concerns would seem
to grow with the scale of the program under test. In fact, @citet[csmith]
find that when testing production C compilers, which are quite large compared
to examples such as red-black tree implementations used in many studies of this
type of testing, extremely large tests cases are the most efficient.
(Programs averaging around 81KB, or containing around 8K-16K tokens, maximized
the rate at which they found counterexamples.)}

Other recent work also applies constraint logic programming to test programming
language semantics and implementations.
@citet[clp-language-fuzzing] conduct a study using CLP to generate
Javascript programs with richer constraints than traditional grammar-based
fuzzers, but less complex than full type soundness. They target specific
variants of test cases, such as the use of prototype-based inheritance or
combinations of @tt{with} statements with closures. They perform a comparison
with a baseline stochastic grammar generator, making a convincing case
that CLP is an improvement for this type of language fuzzing.
A related study@~cite[clp-data-structures] demonstrates that CLP can be
competitive with the most efficient known methods for generating
data structures such as red-black trees, skip lists, and B-trees.
The same approach is used in @citet[rusty-fuzz] to find bugs in the Rust
typechecker, by specifying a system that will usually
(but not always)@note{For example, the specification of System F used
                      as an example in the paper uses a definition of
                      substitution that is not capture-avoiding, which
                      simplifies implementation and generation speed at
                      the cost of sometimes producing terms that are
                      not well-typed.}
generate well-typed terms.

Isabelle/HOL@~cite[isabelle] is a proof assistant equipped with a logic
designed to support semantics modeling. Significant work has been done
to equip Isabelle with automatic testing and checking capabilities similar
to those in Redex, although in a proof-assistant as opposed to a
lightweight modeling context. It has support for random testing via
an implementation of QuickCheck@~cite[isabelle-quickcheck-orig] and two
methods of model checking, Nitpick@~cite[nitpick] and Refute@~cite[weber-dissertation].
Property-based testing in Isabelle has recently been extended to try a
number of different strategies by @citet[isabelle-quickcheck-bulwahn], adding
exhaustive testing, symbolic testing, and a narrowing-based strategy.
@citet[isabelle-quickcheck-bulwahn] also conducts a study comparing the
different methods of test-case generation, similar to that of this
dissertation.

The K Framework@~cite[overview-k k-overview] is a lightweight semantics
modeling framework with sophisticated rewriting rules. It provides
testing via executability (as in Redex) as a well as model checking in a linear
temporal logic, symbolic execution, and verification based on reachability
using matching logic. It has been used to model, test, and check/verify
a number of different programming languages, including C@~cite[c-k],
Java@~cite[k-java], and Javascript@~cite[k-js].
