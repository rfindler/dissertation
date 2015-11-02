#lang scribble/base

@(require scriblib/figure
          scribble/manual
          scriblib/footnote
          slideshow/pict
          racket/math
          "../common.rkt"
          "../util.rkt"
          "../../results/plot-points.rkt"
          "../../results/plot-lines.rkt"
          "../../results/ghc-data.rkt")

@title[#:tag "sec:evaluation"]{Evaluation}

This chapter reports on two studies.
In the first, all of the generators described in this
dissertation are evaluated using the Redex benchmark.
The second study compares the derivation generator of
@secref["sec:semantics"] to a similar generator that is
the best-known hand-tuned typed term generator.

@section[#:tag "sec:benchmark-eval"]{The Redex Benchmark}

This section details a comparison of all of Redex's
approaches to generation on the Redex benchmark.
This includes the the three grammar-based
generators of @secref["sec:grammar"] (the ad-hoc recursive
generator, in-order enumeration, and random selection
from an enumeration) and the derivation generator of
@secref["sec:semantics"].

The generators were compared using the Redex 
Benchmark of chapter 6.
For a single test run, we pair a generator with a model
and its soundness 
property, and then repeatedly generate test cases using the
generator, testing them with the soundness property.
We track the intervals between instances where the
test case causes the soundness property to fail.
For this study, each run continued for either
24 hours or until the uncertainty in the average interval
between such counterexamples became acceptably small.

The enumerations
described in @secref["sec:enum"] were used to build two
generators, one that just chooses
terms in the order induced by the natural numbers (referred to
below as in-order),
and one that selects a random natural and uses that
to index into the enumeration (referred to as random
idnexing).

To pick a random natural number to index into the enumeration,
first  an exponent @raw-latex{$i$} in base 2 is chosen from the
geometric distribution and then an
integer that is between @raw-latex{$2^{i-1}$} and 
@raw-latex{$2^i$} is picked uniformly at random.
This process is repeated three times
and then the largest is chosen, which helps make
sure that the numbers are not always small.
This distribution is used because it does not have a fixed
mean. That is, if you take the mean of some number of
samples and then add more samples and take the mean again,
the mean of the new numbers is likely to be larger than from
the mean of the old. This is a good
property to have when indexing into our enumerations to
avoid biasing indices towards a small size.

The random indexing results are sensitive to the
probability of picking the zero exponent from the geometric
distribution. Because this method is the
worst performing method, 
benchmark-specific numbers were empirically chosen
in an attempt to maximize the
success of the random enumeration method. Even with
this artificial help, this method was still worse, overall,
than the other three.

All of the other generators except in-order enumeration have some
parameter controlling the maximum size of generated terms.

The ad-hoc random generator, which is based on the method of
recursively unfolding non-terminals, is parameterized over
the depth at which it attempts to stop unfolding
non-terminals. A value of 5 was chosen for this depth since
that seemed to be the most successful. This produces terms
of a similar size to those of the random enumeration method,
although the distribution is different.

The derivation generator is similarly parameterized
over the depth at which it attempts to begin finishing
off the derivation, or where it begins to prefer less-recursive
premises. Values that produced terms of a similar size to 
the ad-hoc generator were chosen, except in cases where this caused
too many search failures, in which case a smaller depth
was used. The depths used range from 3 to 5.

Each generator was applied to all of the bugs in the
benchmark, with the exception of the derivation generator,
which isn't able to handle the @bold{let-poly} model. For
reasons that have to do with the way Redex handles variable
freshness, the typing judgment for this model is written
using an explicit continuation and all recursive judgments
have only one premise. Because of this, the heuristics
that the derivation generator uses fail when applied to
this model. This causes a runaway search process that
is eventually terminated by constraints Redex
imposes and deemed a failure.
Thus there are 7 bugs that the derivation generator
could not be tested on.

There are 50 bugs total in the benchmark, for a total
of 193 bug/generator pairs in this study.
For each of the bug and generator combinations, a
script is run that repeatedly asks for terms and checks to see if
they falsify the model's correctness property. As soon as it finds a
counterexample to the property, it reports the amount of
time it has been running. The script was run in two rounds.
The first round ran all 193 bug and generator combinations
until either 24 hours elapsed or the standard error in the
average became less than 10% of the average. Then
all of the bugs where the 95% confidence interval
was greater than 50% of the average and where at least one
counterexample was found were run for an
additional 8 days. All of the final averages have
an 95% confidence interval that is less than 50% of
the average.

Two identical 64 core AMD machines with Opteron
6274s running at 2,200 MHz with a 2 MB L2 were used cache to run the
benchmarks. Each machine has 64 gigabytes of memory. The
script typically runs each model/bug combination
sequentially, although multiple different
combinations are run in parallel and, for the bugs
that ran for more than 24 hours, tests are in parallel. We
used version 6.2.900.4 (from git on August 15, 2015) of Racket,
of which Redex is a part. 

@figure["fig:points"
        @list{Benchmark results for all generators on
              all bugs. Error bars show 95% confidence intervals.}
        @(rotate (plot-points 24hr-all) (- (/ pi 2)))]


@Figure-ref["fig:points"] summarizes the results of the
comparison on a per-bug basis. The y-axis is time
in seconds, and for each bug the average
time it took each generator to find a counterexample
is plotted. The bugs are arranged
along the x-axis, sorted by the average time over all
generators to find the bug. The error bars represent
95% confidence intervals in the average, and in all
cases where the averages differ significantly
the errors are small enough
to clearly differentiate the averages.
The three blank columns on the right are bugs that no
generator was able to find. 
The vertical scale is logarithmic,
and the average time ranges from a tenth of a second
to several hours, an extremely wide range in the
rarity of counterexamples.

@figure["fig:lines"
        @list{Random testing performance of all four
              generators, on models where all generators apply.}
        @(line-plot/directory 24hr)]

To depict more clearly the relative testing effectiveness
of the generation methods, the same data is plotted slightly
differently in @figure-ref["fig:lines"]. Here the
time in seconds is shown on the x-axis (the y-axis from 
@figure-ref["fig:points"], again on a log scale), 
and the total number of bugs found
for each point in time on the y-axis.
This plot only includes bugs to which all generators can
be applied, to avoid having this aspect of the
benchmark's composition unduly affect the comparison.
(Therefore, @bold{let-poly} is excluded since the
derivation generator cannot handle it.)
This plot makes it clear that the derivation generator
is much more effective when it applies, finding more bugs more 
quickly at almost every time scale.
In fact, an order of magnitude or more on the
time scale separates it and the next-best generator
for almost the entire plot.

While the derivation generator is more effective when it is
used, it cannot be used with every Redex model, unlike the
other generators. There are three broad categories of models
to which it may not apply.
First, the language may not
have a type system, or the type system's implementation
might use constructs that the generator fundamentally cannot
handle (like escaping to Racket code to run arbitrary
computation). Second, the generator currently cannot handle
ellipses (aka repetition or Kleene star). And finally,
some judgment forms thwart
its termination heuristics. Specifically, the heuristics
make the assumptions that the cost of completing the
derivation is proportional to the size of the goal stack,
and that terminal nodes in the search space are uniformly
distributed. Typically these are safe assumptions, but not
always; as noted already, the @bold{let-poly} model breaks them.

@figure["fig:lines-enum"
        @list{Random testing performance of ad-hoc and
              enumeration generators on all models.}
        @(line-plot/directory 24hr-enum)]

@Figure-ref["fig:lines-enum"] shows the testing performance
on all bugs in the benchmark for the generators that are able
to attempt all of them. This reveals that the ad hoc generator
is better than the best enumeration strategy after 22 minutes.
Before that time, the in-order enumeration strategy is the best
approach, and often by a significant margin. Random indexing
into an enumeration is never the best strategy.

@section[#:tag "sec:ghc"]{Testing GHC: A Comparison With a Specialized Generator}

In this section, the derivation generator developed in this work for
Redex is compared to a specialized generator of typed terms.
The specialized generator was designed to be used for differential
testing of GHC, and generates terms for a specific variant of the 
lambda calculus with polymorphic constants, chosen to be
close to the compiler's intermediate language.
The generator is implemented using QuickCheck@~cite[QuickCheck],
and is able to leverage its extensive support for
writing random test case generators.
Writing a generator for well-typed terms in this
context required significant effort, essentially
implementing a function from types to terms in QuickCheck.
The effort yielded significant benefit, however,
as implementing the entire generator from
the ground up provided many opportunities for specialized
optimizations, such as variations of type rules that
are more likely to succeed, or varying the frequency with
which different constants are chosen. @citet[palka-diss] discusses
the details.

@(define table-head
   (list @bold{Generator}
                    @bold{Terms/Ctrex.}
                    @bold{Gen. Time (s)}
                    @bold{Check Time (s)}
                    @bold{Time/Ctrex. (s)}))






Implementing this language in Redex was easy:
the formal description in @citet[palka-diss] was ported
directly into Redex with little difficulty.
Once a type system is defined in Redex, the derivation generator
can be immediately used to generate well-typed terms.
Such an automatically derived generator is likely to make some 
performance tradeoffs versus a specialized one, and this comparison 
provided an excellent opportunity to investigate those.

The generators were compared by testing two of the properties used in @citet[palka-diss],
and using same baseline version of the GHC (7.3.20111013) that was used there.
@bold{Property 1} checks whether turning on optimization influences the strictness of the
compiled Haskell code. The property fails if the compiled 
function is less strict with optimization turned on.
@bold{Property 2} observes the order of evaluation, and fails if optimized code has a
different order of evaluation compared to unoptimized code.

Counterexamples from the first property demonstrate erroneous behavior of the compiler,
as the strictness of Haskell expressions should not be influenced by optimization. In contrast,
changing the order of evaluation is allowed for a Haskell compiler to some extent, so
counterexamples from the second property usually demonstrate interesting cases of
the compiler behavior, rather than bugs.

@figure["fig:table" 
        @list{Comparison of the derivation
              generator and a hand-written typed term
              generator. ∞ indicates runs where no
              counterexamples were found. Runs marked with *
              found only one counterexample, which gives
              low confidence to their figures. }]{
  @centered{
    @tabular[#:sep @hspace[1]
             (cons
              table-head
              (append
               (cons (cons @bold{Property 1} (build-list 4 (λ (_) "")))
                     (make-table table-prop1-data))
               (cons (cons @bold{Property 2} (build-list 4 (λ (_) "")))
                     (make-table table-prop2-data))))]
     }}

@Figure-ref["fig:table"] summarizes the results of the comparison 
of the two generators. Each row represents a run of one of the 
generators, with a few varying parameters.
@citet[palka-diss]'s generator as is referred to as ``hand-written.'' It takes
a size parameter, which was varied over 50, 70, and 90 for each property.
``Redex poly'' is the initial implementation of this system in the Redex,
the direct translation of the language from @citet[palka-diss].
The Redex generator takes a depth
parameter, which we vary over 6, 7, 8, and, in one case, 10.
The depths are chosen so that both generators target
terms of similar size.@note{Although it is possible to generate terms
                           of larger depth, the runtime increases quickly
                           with the depth. One possible explanation is that
                           well-typed terms become very sparse as term size
                           increases. @citet[counting-lambdas]
                           show how scarce well-typed terms are even for
                           simple types. Polymorphism seems to
                           exacerbate this problem.}
(@Figure-ref["fig:size-hists"] compares generated terms at
targets of size 90 and depth 8).
``Redex non-poly'' is a modified version of the initial implementation,
the details of which are discussed below. The columns show
approximately how many tries it took to find a counterexample,
the average time to generate a term, the average time to check
a term, and finally the average time per counterexample over the
entire run. Note that the goal type of terms used to test
the two properties differs, which may affect generation time
for otherwise identical generators.


A generator based on the initial Redex implementation was
able to find counterexamples for only one of the properties,
and did so and at significantly slower rate than the hand-written
generator. The hand-written generator performed best when
targeting a size of 90, the largest, on both properties.
Likewise, Redex was only able to find counterexamples when targeting
the largest depth on property one. There, the hand-written
generator was able to find a counterexample every 12K terms,
about once every 260 seconds. The Redex generator
both found counterexamples much less frequently, at one in 4000K, and
generated terms several orders of magnitude more slowly.
Property two was more difficult for the hand-written 
generator, and the first try in Redex was unable to 
find any counterexamples there.

@figure["fig:size-hists"
        @list{Histograms of the sizes (number of internal nodes)
              of terms produced by the different runs.
              The vertical scale of each plot is one twentieth
              of the total number of terms in that run.}]{
         @centered[(hists-pict 260 530)]}

Comparing the test cases from both generators,
we found that Redex was producing
significantly smaller terms than the hand-written generator.
The left two histograms in @figure-ref["fig:size-hists"]
compare the size distributions, which show that
most of the terms made by the hand-written generator
are larger than almost all of the terms that Redex produced
(most of which are clumped below a size of 25).
The majority of counterexamples produced
with the hand-written generator fell in this larger range.
                 
Digging deeper, it seemed that Redex's generator was backtracking
an excessive amount.
This directly affects the speed at which terms are generated, 
and it also causes the generator to fail more often because 
the search limits discussed in @secref["sec:search"] are
exceeded. Finally, it skews the distribution toward smaller
terms because these failures become more likely as the
size of the search space expands.
A reasonable hypothesis is that the backtracking was caused by
making doomed choices when instantiating polymorphic types
and only discovering that much later in the search,
causing it to get stuck in expensive backtracking cycles.
The hand-written generator avoids such problems by
encoding model-specific knowledge in heuristics.

A variant Redex model was created to test this hypothesis,
identical to the first except with a pre-instantiated
set of constants, and removing all other polymorphism.
The 40 most common instantiations of constants were selected
from a set of counterexamples to both models generated by
the hand-written generator.
Runs based on this model are referred to as ``Redex non-poly'' 
in both @figure-ref["fig:table"] and @figure-ref["fig:size-hists"].

As @figure-ref["fig:size-hists"] shows, we get a much
better size distribution with the non-polymorphic model, 
comparable to the hand-written generator's distribution.
A look at the second column of @figure-ref["fig:table"]
shows that this model produces terms much faster than
the first try in Redex, though still slower than the hand-written
generator. 
This model's counterexample rate is especially interesting.
For property one, it ranges from one in 500K terms at depth
6 to, astonishingly, one in 320 at depth 8, providing more evidence
that larger terms
make better test cases.
This success rate is also much better than that of the hand-written
generator, and in fact, it was this model that was most
effective on property 1, finding a counterexample
approximately every 30 seconds,
significantly faster than the hand-written generator.
Thus, it is interesting that it did much worse on
property 2, only finding a counterexample once
every 4000K terms, and at very large time intervals.
The reason for this discrepancy remains unknown.

Overall, the derivation generator is not
competitive with the hand-tuned generator when it has
to cope with polymorphism. Polymorphism is
problematic because it requires the generator to make
parallel choices that must match up, but where the generator
does not discover that those choices must match until 
much later in the derivation. Because the choice point
is far from the place where the constraint is discovered,
the generator spends much of its time backtracking.
The improvement in generation speed for the
Redex generator when removing polymorphism provides 
evidence for the explanation of what makes generating
these terms difficult.
The ease with which 
this language could be implemented in Redex, and
as a result, conduct this experiment,
speaks to the value of a general-purpose generator,
and of lightweight semantics tools.

