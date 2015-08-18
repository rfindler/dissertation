#lang scribble/base

@(require scriblib/figure
          scribble/core
          scribble/manual
          scriblib/footnote
          racket/pretty
          (only-in pict vl-append blank)
          "typesetting.rkt"
          "../../model/clp.rkt"
          (except-in "../../model/typesetting.rkt" lang-pict)
          "pat-grammar.rkt"
          "../common.rkt"
          "../util.rkt"
          (only-in pict hbl-append))


@title[#:tag "sec:mf-semantics"]{Compiling Metafunctions}

The examples of @secref["sec:deriv"] and @secref["sec:example-red"]
informally demonstrated how metafunctions can be converted into
judgment forms. This section discusses how to generalize this process.

The primary difference between a metafunction, as written in Redex,
and a set of @pt[((d p) ← a ...)] clauses from @figure-ref["fig:clp-grammar"]
is sensitivity to the ordering of clauses. 
Specifically, when the second clause in a metafunction fires,
then the pattern in the first clause must not match, in contrast to
the rules in the model, which fire regardless of their relative order. Accordingly,
the compilation process that translates metafunctions into the model must
insert disequational constraints to capture the ordering of the cases.

As an example, consider the
metafunction definition of @pt[g] on the left and some example applications on the right:
@centered{@(f-ex-pict)}
The first clause matches any two-element list, and the second clause matches
any pattern at all. Since the clauses apply in order, an application where the
argument is a two-element list will reduce to @pt[2] and an argument of any
other form will reduce to @pt[1]. To generate conclusions of the judgment
corresponding to the second clause, we have to be careful not to generate
anything that matches the first.

Applying the same idea as @pt[lookup] in @secref["sec:deriv"], 
we reach this incorrect translation:
@centered{@(incorrect-g-jdg-pict)}
This is wrong because it would let us derive
@(hbl-append 2 @g-of-12 @pt[=] @pt[1]), 
using @pt[3] for @pt[p_1] and
@pt[4] for @pt[p_2] in the premise of the right-hand rule.
The problem is that we need to disallow all possible instantiations
of @pt[p_1] and @pt[p_2], but the variables 
can be filled in with just specific values to satisfy the premise.

The correct translation, then, universally quantifies the variables
@pt[p_1] and @pt[p_2]:
@centered{@(g-jdg-pict)}
Thus, when we choose the second rule,
we know that the argument will never be able to match the first clause.

In general, when compiling a metafunction clause, we add a disequational
constraint for each previous clause in the metafunction definition.
Each disequality is between the left-hand side patterns of one of the previous
clauses and the left-hand side of the current clause, and it is quantified 
over all variables in the previous clause's left-hand side.

@figure["fig:mf-lang"
        @list{Extensions to the language of @figure-ref["fig:clp-grammar"] to add metafunctions}
        (pmf-lang-pict)]

To formalize this process as part of the model, we can first add (object-language)
metafunctions to the language and then write (Redex) metafunctions to
eliminate then. To ease confusion between the two language levels, I'll
refer to object-language metafunctions as simply ``functions,'' and the
Redex equivalent as ``metafunctions.'' The extensions adding functions
to the language of the model are shown in @figure-ref["fig:mf-lang"].
Programs become a list of either @pt[D]'s or @pt[M]'s, where @pt[M]
is a function definition as a list of clauses @pt[c]. The name of the
function @pt[f] appears on the left-hand side of each clause, as
in Redex. The other wrinkle is that patterns @pt[p] are now allowed to
include function applications @pt[(f p)], reflecting that in Redex
such applications are allowed inside @code{term}.

@figure["fig:mf-compile"
        @list{Metafunctions for compiling metafunctions @pt[M] into definitions @pt[D].}
        (two-compile-pict)]

The metafunctions for function compilation are shown in @figure-ref["fig:mf-compile"].
The top-level metafunction, @pt[compile], first calls @pt[compile-M] with
every function in the program until there are none, and then calls
@pt[extract-apps] with every definition @pt[D] on the program.
The metafunction for compiling an individual function, @pt[compile-M],
essentially maps prefixes of the list of clauses to rules @pt[r], doing nothing
with the prefix containing only one clause, and in every other case
creating a rule based on the last clause in the prefix, adding in
constraints excluding every other clause in the prefix.

@figure["fig:extraction-pict"
        "Metafunctions for extracting function applications from within patterns."
        (extraction-pict)]

Finally, the metafunctions shown in @figure-ref["fig:extraction-pict"] lift out
function applications embedded in patterns. An application of the form
@pt[(f p)] is replaced with some fresh variable @pt[x] representing
its result. The application itself is transformed into a premise of
the form @pt[(f p x)], since the function itself has been compiled into
a relation of that form. The pattern @pt[p] is in the input position
and the variable @pt[x] is in the output position. The premise is then lifted
to the top level of the surrounding rule @pt[r].
The extraction of all applications from within patterns and transformation
to premises is performed by @pt[extract-apps-p], while the
other metafunctions shown in @figure-ref["fig:extraction-pict"] lift the
premises to the rule level along with the appropriate bookkeeping.

@italic{TODO flattening discussion, references}