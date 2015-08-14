#lang scribble/base

@(require scriblib/figure
          scribble/eval
          scribble/manual
          scriblib/footnote
          racket/match
          racket/sandbox
          racket/path
          "intro-typesetting.rkt"
          "../common.rkt"
          "code-utils.rkt")

@(define stlc-eval (make-base-eval))

@(stlc-eval `(require redex/reduction-semantics
                      racket/pretty
                      ,stlc-rel-path-string))

@(stlc-eval '(pretty-print-columns 60))

@title{Modeling and testing semantics in Redex}

The entire development of the previous section can be translated
almost directly into Redex. In fact, all of the typesetting for
the semantics of that section is generated automatically from
a Redex model. In this section I present Redex's approach to semantics
engineering by showing how it can be used to implement, inspect, and
test such models.

Redex is an embedded domain-specific language. A domain-specific
language (DSL) is one intended for a specific application, in this case
semantics modeling. An embedded DSL is implemented as an extension
to a general-purpose language (in Redex's case, Racket) instead of as a
stand-alone tool. That enables the power of the general-purpose language
to be used in combination with the targeted abstractions that the
DSL provides. For Redex, this means that it is possible to ``escape''
to Racket when necessary, and all of tools and libraries already
associated with Racket can be used in combination with Redex.

One of the core principles of Redex is to use already existing informal
metalanguage found in programming language publications to guide its design.
All of its core abstractions are chosen to model those programming
language researchers have found to be commonly useful, such as grammars
and reduction relations. Following this guideline makes designing useful
abstractions simpler, as the choices have already been made by the
community of intended users. It also has the potential to ease the
learning curve and make adoption easier.

A similar principle is applied to the design of Redex's syntax, which
attempts to be as close as possible to what a semantics engineer
would write down on the page or whiteboard. (Modulo some parentheses,
the price of the embedding in Racket.) At the same time, automatic
typesetting is provided that mimics what users see in the source
as closely as possible, even preserving whitespace so that editing
source code will directly affect typeset layouts.

@figure["fig:side-by-side"
        "Definition of a grammar in Redex (left) and the automatically generated typesetting."
        (grammar-side-by-side-pict)]

A concrete example of Redex's approach is shown in @figure-ref["fig:side-by-side"],
which compares the implementation of the core grammar from the
previous section in Redex with the typeset version. The Redex form
for defining a grammar is @code{define-language}, whose first argument
is the name of the language, followed by a sequence of non-terminal
definitions. Generating the typeset version on the right requires
only a single line of code: @code{(language->pict STLC-min)}. Note
how the linebreaks and arrangement of productions on the right
follow those in the source code very closely. Finally, both the
typeset version and the Redex source conform closely to commonly
accepted ways of writing down a grammar. What is shown here is
the raw automatic typesetting; Redex also provides hooks
for customization, such as replacing @et[variable-not-otherwise-mentioned]
with something more familiar. Similar correspondence between
Redex source, Redex typesetting, and commonly accepted usage exists
for all the Redex forms defining semantic elements.

After defining a language in Redex, it is easy to parse concrete
syntax (in the form of s-expressions) according to that grammar.
For example, the following interaction uses the @code{redex-match}
form to parse the term @et[((λ (x num) x) 5)] as an application
of one expression in this language to another, returning a
representation of the bindings from the
two expressions to the relevant subterms:
@interaction[#:eval stlc-eval
             (redex-match STLC-min (e_1 e_2)
                          (term ((λ (x num) x) 5)))]
Trying to parse @et[((λ 4) 2)], however, fails, since the first
expression no longer conforms to the grammar:
@interaction[#:eval stlc-eval
             (redex-match STLC-min (e_1 e_2)
                          (term ((λ 4) 2)))]
