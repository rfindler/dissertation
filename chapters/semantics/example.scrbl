#lang scribble/base

@(require scriblib/figure
          scribble/core
          scribble/manual
          scriblib/footnote
          racket/pretty
          redex/pict
          "../common.rkt"
          "../util.rkt"
          "../../model/even-model-example.rkt"
          "../../model/clp.rkt")


@title[#:tag "sec:example-red"]{An Example}

To get a better idea of how the model of the derivation
generator works, this section works through the translation
of a Redex metafunction into a program @clpt[P] of the model.
Then, to see how the reduction in @figure-ref["fig:clp-red"] works,
a small but complete reduction graph is generated
based on that program with a given initial goal.

@figure["fig:example-mf"
        "Grammar (left) and metafunction to be compiled and run in the derivation generator."
        (lang-mf-pict)]

Our starting point will be the simple grammar and metafunction
@lt[e/o] shown in @figure-ref["fig:example-mf"].
The language is a encoding of unary numbers @lt[n],
and @lt[e/o] is a function that takes an @lt[n] and
returns @lt[even] or @lt[odd], depending on the number.
It is written somewhat strangely to demonstrate some
interesting aspects of the model.

As we did for the lookup metafunction in @secref["sec:deriv"],
we can translate @lt[e/o] into a judgment form defining
a two-place relation by adding appropriate constraints as
premises. The new judgment had the output of @lt[e/o]
(@lt[even] or @lt[odd]) in the first position and the
corresponding unary number in the second.
The rules for the judgment, which we'll call
@lt[e-or-o], are shown in @figure-ref["fig:example-jdg"].

Since there is no overlap between the left-hand sides of
the first two clauses in @lt[e/o] the first two rules
(reading left to right) have to additional premises.
The third rule, however, has two premises to exclude
both of the previous clauses. The next section discusses in
detail the form of such constraints and the need for
universal quantification.

@figure["fig:example-jdg"
        @list{The metafunction of @figure-ref["fig:example-mf"] as a judgment form.}
        (eo-jdg-pict)]

Finally, we would like to use @lt[e-or-o] as a program for the
derivation generator. We can directly translate the judgment of
@figure-ref["fig:example-jdg"] into a definition @clpt[D] of the
model as defined in @figure-ref["fig:clp-red"]. It is somewhat more
difficult to read but is semantically identical:
@(centered (awk-P-pict))
Note that sequence patterns all now have explicit @clpt[lst]
constructors, corresponding to patterns @clpt[p] of the model,
so that @lt[(s (s z))] becomes @clpt[(lst s (lst s z))]. Also,
the parameters of the judgment have been combined into
an @clpt[lst] sequence as well, since in the model all
judgments are unary, so we just combine the parameters of
any @italic{n}-ary judgment into a tuple.

To generate a reduction graph for this program we need an
appropriate initial goal, for which we can chose
@clpt[(e-or-o (list odd (lst s (lst s (list s z)))))],
asserting that three is odd, or that @lt[odd] should
be the result of calling @lt[e/o] with @lt[3]. We then form a tuple from
the program @clpt[P], the goal, and the empty set of
constraints @clpt[(∧)] (the constraint set is shown as a
single disjunction for simplicity), which we use as an input
for the reduction relation of @figure-ref["fig:clp-red"].
The resulting reduction graph is shown in @figure-ref["fig:red-graph"].

@figure["fig:red-graph"
        @list{Reduction graph for example generator program. The
              program is abbreviated as @code{P}.}
        @raw-latex{\includegraphics[scale=0.7]{graph2.pdf}}]

The first thing to notice about the reduction graph is that
there are two possible reductions using the @rule-name{reduce}
rule from the initial state.
Theses correspond to the middle and right rules from
@figure-ref["fig:example-jdg"], both of which have
conclusions that can be equated with the current goal.
The right hand reduction comes from the rule on the
right (note the form of the added constraints) and is
a stuck state. Because it has a disequation @clpt[δ] on
the top of the goal stack, it could only take a step
using the @rule-name{new constraint} rule. However, inspecting
the current set of constraints (the bottom or last element
of the state tuple) shows that it conflicts with the
disequation at the top of the stack, so it isn't possible
to take another step from this state.

The left hand reduction path takes a @rule-name{reduce} step
corresponding to a use of the middle rule from @figure-ref["fig:example-jdg"].
It then takes another @rule-name{reduce} step, but this
time it can only use the rule on the right of the judgment, because @code{n_2}
in the goal conflicts with both of the other possibilities, as it is defined
by the constraint store to be @code{(lst s z)}. This
step adds two new disequations, however
neither of them conflict with the current constraint,
and they are processed through two @rule-name{new constraint}
steps, resulting in a final state with an empty goal
stack, representing a successful derivation.

No terms could be randomly generated with this reduction graph,
since we started with a fully instantiated goal, and there
is only one possible successful derivation. Starting
with a different goal, such as one specifying @code{odd}
in the first position and @code{n}, the pattern representing
any possible unary number, in the second
position would generate an infinitely branching reduction graph, with
successful branches corresponding to each odd number,
and stuck states in branches that would otherwise
have led to an even number.
The Redex implementation essentially executes a randomized
search over such a reduction graph, looking for the
successful branches.