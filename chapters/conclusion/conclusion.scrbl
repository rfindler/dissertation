#lang scribble/base

@(require "../common.rkt"
          "../util.rkt")

@title[#:tag "sec:conclusion"]{Conclusion}

Mechanizing semantics gives programming languages researchers
the ability to build models of real-world programming languages.
A lightweight framework combined with property-based testing
allows a semantics engineer to effectively and quickly develop
their models, gaining confidence in their correctness and
consistency with actual implementations before attempting
a formal proof of correctness.

To support this approach to mechanization, this dissertation
demonstrated  several different approaches to automatically
derive generators for property-based testing from lightweight definitions:
ad-hoc recursive generators and two enumeration based generators
derived from grammars, and derivation generators based on
relation and function definitions.
Evaluation of their bug-finding effectiveness
shows that all of them effectively find counterexamples
for realistic properties of real-world semantics models in
reasonable time frames.
The evidence shows
that automated checking based on lightweight definitions
is a productive avenue toward improved tools for semantics
engineering.

@section[#:tag "sec:future-work"]{Future Work}

The derivation generation approach proves to be the most
effective when it can be applied, but it cannot be used
on all Redex models. 
As already noted, there are a number of different features
of Redex that are commonly used yet are not supported by the
derivation generation approach. Addressing these issues,
either by extending the derivation generation approach or
by developing a new generator better, would be a productive
direction for further research.

Redex's repeat patterns, or ellipses, a pattern language element
analagous to the Kleene star, are problematic for the derivation
generator because of the challenges involved in creating
a constraint solver capable of handling them.
@citet[pattern-unification]'s work 
on sequence unification, which handles patterns similar 
to Redex's, shows how a similar constraint solving
algorithm looks, and should provide a good starting
point for extending the constraint solver of
@secref["sec:solve"] to support repeat patterns.
That would enable the derivation generator to support
all definitions except those involving unquote.

Unquotes, or escapes from Redex to Racket,
are even more problematic for an approach such
as the derivation generator, as they
allows arbitrary computation. There are at least
two approaches to attempt to use definitions that include
unquote as a basis for generators.
One way to would be to move operations that are commonly
used in unquote, such as integer arithmetic, list operations,
or symbolic manipulations, into Redex, and extend the constraint
solver to handle them as well.
Another would be to design a new generator. A possibility
that seems promising would be something along the lines
of @citet[uniform], pruning a search space based on
the behavior of a predicate, which could be an arbitrary
Racket function.
