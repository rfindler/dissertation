#lang scribble/base

@title[#:tag "sec:grammar"]{Grammar-based Generators}

A specification of abstract syntax is a fundamental part
of any operational semantics. These specifications usually
take the form of recursively defined data types or, as
in Redex, regular tree grammars. These recursive structures
are simple in the sense they don't accumulate any information
as they recur and have no contextual constraints, unlike richer
specifications such as type systems. Because of this they
can be easily leveraged for a number of different approaches
to random generation.

In this section I discuss two grammar-based approaches to random
expression generation. First, I explain the ``obvious'' approach
based on recursively unfolding non-terminals. Following that I
address a newer method based on forming enumerations
of the set of terms conforming to the grammar. Both approaches
can be applied in general to any specification using abstract
data types or regular grammars, although the discussion here
is based on their implementation as part of Redex's random
testing framework. The comparative effectiveness of the
different approaches is discussed in @secref["sec:evaluation"].

@include-section["ad-hoc.scrbl"]

@include-section["redex-enumeration.scrbl"]