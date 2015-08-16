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
          "../util.rkt"
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
for customization, such as replacing @et[variable-not-otherwise-mentioned],
 a special Redex pattern
that matches anything that is not a literal in the language,
with something more familiar.
Similar correspondence between
Redex source, Redex typesetting, and commonly accepted usage exists
for all the Redex forms defining semantic elements.

After defining a language in Redex, it is straightforward to parse concrete
syntax (in the form of s-expressions) according to the grammar.
For example, the following interaction@note{Inlined interactions
 that appear in this section are actual transcripts of the Racket
 REPL with the Redex module describing the language in the previous
 section loaded.} uses the @code{redex-match} form 
to parse the term @et[((λ (x num) x) 5)] as an application
of one expression, @code{e_1}, in this language to another, @code{e_2},
where the @code{e}'s refer to the nonterminal of the language
@code{STLC-min} from @figure-ref["fig:side-by-side"]. The result is
a representation of bindings from the patterns' two expressions to
the relevant subterms for the one possible match in this case:
@interaction[#:eval stlc-eval
             (redex-match STLC-min (e_1 e_2)
                          (term ((λ (x num) x) 5)))]
Trying to parse @et[((λ 4) 2)], however, fails, since the first
subterm no longer conforms to the @et[e] nonterminal, and is
not a valid expression in this langauge:
@interaction[#:eval stlc-eval
             (redex-match STLC-min (e_1 e_2)
                          (term ((λ 4) 2)))]

@italic{TODO}
stuff
Need to talk about reduction-relations vs. metafunctions
AND judgment-holds argh
stuff

Finally, we can define an @code{Eval} metafunction in Redex that
corresponds exactly to the code from the previous section:
@racketblock[#,eval-stxobj]
The first line specifies that this definition is relative to
the @code{STLC} language and the second specifies @code{Eval}'s
contract. Two clauses follow, which are made up of, in order,
a pattern, a result term, and side-conditions, which is where
all the work of reducing the term is happening in this case.
Clauses are tried in order, returning the result from the
first clause with a pattern matching the argument and
side-conditions that succeed.
As before, @code{Eval} applies the reflexive-transitive closure
of the standard reduction (here called @code{refl-trans}) to
its argument and dispatches on the result. (Note that the
side-conditions of the clauses differ in whether the
result is an @code{n} or a @code{v}.) Metafunctions
like @code{Eval} are applied as if they were functions in the
object language, from within @code{term}. We can now evaluate
programs using Redex, for example, applying the function
that adds @code{1} to @code{1}:
@interaction[#:eval stlc-eval
                    (term (Eval ((λ [x num] (+ x 1)) 1)))]

A more interesting example is:
@racketblock[#,sumto-stxobj]
which defines a whole class of programs that calculate
arithmetic series, sums of @code{1} through @code{n}. This
definition takes advantage of Redex's status as an embedded
language, defining a Racket function that returns a Redex
@code{term}. The comma in the last line escapes to Racket,
allowing the appropriate number to be inserted in the term.

Now we can try a slightly more interesting calculation,
the value of the arithmetic series of @code{100}.
@interaction[#:eval stlc-eval
                    (term (Eval ,(sumto 100)))]
which returns the answer we would expect.

Redex also allows us to observe the steps of a calculation
with a reduction graph, where each two terms related by
the reduction relation are nodes in the graph, and the
edges are labeled with the rule that connects them. The
above calculation actually has hundreds of steps, making
its reduction graph too large for visual inspection.
@Figure-ref["fig:sumto-red"], however, shows the reduction
graph of an analagous program for the
arithmetic series of @code{2}, showing each step from the
initial program generated by @code{(sumto 2)} to the final
value of @code{3}. The fact that there is a single path
in this graph is a feature of this reduction relation;
other reduction relations may give rise to many possible paths.

@figure["fig:sumto-red"
        @list{An example reduction graph. Since @et[μ] reductions
              substitute the entire @et[rec] expression in the body, the
              bodies of duplicate such expressions are omitted, but are
              all the same as the initial @et[rec].}
        @raw-latex{\includegraphics[scale=0.85]{sumto.pdf}}]

@italic{TODO}