#lang scribble/base

@(require scriblib/figure
          scribble/eval
          scribble/manual
          scriblib/footnote
          racket/match
          racket/sandbox
          racket/path
          redex/pict
          "../../model/stlc.rkt"
          "intro-typesetting.rkt"
          "../common.rkt"
          "../util.rkt"
          "code-utils.rkt")

@(define stlc-eval (make-base-eval))

@(stlc-eval `(require redex/reduction-semantics
                      racket/pretty
                      ,stlc-rel-path-string))

@(stlc-eval '(pretty-print-columns 60))

@title[#:tag "sec:redex-modeling"]{Modeling Semantics in Redex}

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
The @code{redex-match} syntactic form takes to a language defined
as in @figure-ref["fig:side-by-side"], a patterned defined
in reference to that language (in the above, for example
the @code{e}'s refer to the non-terminal of the language),
and a concrete term. It then attempts to parse to term
according to the patter.
Trying to parse @et[((λ 4) 2)], however, fails, since the first
subterm no longer conforms to the @et[e] nonterminal, and is
not a valid expression in this langauge:
@interaction[#:eval stlc-eval
             (redex-match STLC-min (e_1 e_2)
                                   (term ((λ 4) 2)))]

Contexts, as introduced in @secref["sec:semantics-intro"],
are a native feature of patterns in Redex, and allow
terms to be decomposed into a context with a hole and
the content of the hole. For example:
@interaction[#:eval stlc-eval
             (redex-match STLC (in-hole E n)
                               (term ((λ [x num] x) 5)))]
Here @code{in-hole} is Redex's notation for the application
of a context, so @code{(in-hole E n)} is equivalent to
@(term->pict STLC (in-hole E n)) in the notation from
@secref["sec:semantics-intro"]. (@code{STLC} is an
extension of @code{STLC-min} that adds contexts.)
The result tells us that
there is exactly one way to decompose the term such
that a number is in the hole, @(term->pict STLC ((λ [x num] x) hole))
and @(term->pict STLC 5).

Redex patterns also feature ellipses, which are analagous to
the Kleene star and allow matching repetitions. A simple
use case allows us to match a list of numbers of any length:
@interaction[#:eval stlc-eval
             (redex-match STLC (n ...)
                               (term (1 2 3 4 5)))]
A slightly more interesting example is to match a list
of pairs of variables and numbers, a possible representation
for an environment:
@interaction[#:eval stlc-eval
             (redex-match STLC ((x n) ...)
                               (term ((a 1) (b 2) (c 3) (d 4) (e 5))))]
As a result we get back bindings for the variables @code{x},
a list of variables, and @code{n}, a list of numbers.
Ellipses are a powerful feature of Redex's pattern matcher
but cause problems for some types of random generation,
an issue I will return to later on.

Reduction relations are define using the @code{reduction-relation}
form as a union of rules, the syntax of which is very close
to that of @figure-ref["fig:one-step"]. The definition of
the reduction is shown on the left of @figure-ref["fig:red-types"].
Each rule is parenthesized, and defined with the @code{-->} operator,
which takes a left-hand-side pattern, and resulting term, a
sequence of side conditions, and a rule name as its arguments.

@figure["fig:red-types"
        "Reduction-relation (left) and typing judgment definitions in Redex."
        (reduction-types-pict)]

To seen a reduction relation at work, we can use the
@code{apply-reduction-relation} form, which takes a relation and
a term to reduce one step:
@interaction[#:eval stlc-eval
             (apply-reduction-relation STLC-red-one
                                       (term ((λ [x num] (+ x 2)) 1)))]
A list containing one term is returned, since in this case there
is only one possible reduction step, but depending on how
the relation is defined, there could be more.

The typing judgment, shown on the right on @figure-ref["fig:red-types"],
is also defined in a manner designed to follow the common
syntax of @figure-ref["fig:type-judgment"]. Instead of the
designating the typing relation with the infix syntax @et[(tc Γ e τ)],
judgments in Redex code use parenthesized prefix-notation, in
this case @code{(tc Γ e τ)}. Each rule is bracketed, and
the conclusion appears below a horizontal line of dashes,
the premises (and side-conditions) above. The only other
significant addition is the mode annotation in the second
line, which designates which positions of the relation are
considered inputs and which are considered outputs.
Redex requires this to ensure the judgment is executable
without search, although it constrains the relations
that can be expressed with @code{define-judgment-form}.

Judgments can be applied through the @code{judgment-holds}
form. For example, we can verify that the type of
@code{(+ 1 (- 2 3))} is a @code{num} as follows:
@interaction[#:eval stlc-eval
             (judgment-holds (tc • (+ 1 (- 2 3)) num))]
(Recall that @code{•} indicates the empty type environment.)
Or, we can ask Redex to compute the type of a slightly
more complicated term:
@interaction[#:eval stlc-eval
             (judgment-holds (tc • (λ [x num] (λ [y num] x)) τ) τ)]
@;{TODO - lightweightness...discuss, should this model
   be an appendix?}

Finally, to complete the Redex model of this language,
we can define an @code{Eval} metafunction in Redex that
corresponds exactly to @et[Eval] from @secref["sec:semantics-intro"].
@racketblock[#,eval-stxobj]
The first line specifies that this definition is relative to
the @code{STLC} language and the second specifies @code{Eval}'s
contract. Two clauses follow, which are made up of, in order,
a pattern, a result term, and side-conditions, which is where
all the work of reducing the term is happening in this case.
Clauses are tried in order, and the result is the right-hand side
of the first clause that has both s pattern matching the argument and
side-conditions that succeed.
As before, the @code{judgment-holds} side-conditions in
@code{Eval} apply the reflexive-transitive closure
of the standard reduction (the judgment form @code{refl-trans}) to
its argument and dispatch on the result. (Note that the
side-conditions of the clauses differ in whether the
result is an @code{n} or a @code{λ}-espression.) Metafunctions
like @code{Eval} are applied as if they were functions in the
object language, from within @code{term}. We can now evaluate
programs using Redex. For example, to evaluate the application
of the function that adds @code{1} to @code{1}:
@interaction[#:eval stlc-eval
                    (term (Eval ((λ [x num] (+ x 1)) 1)))]
The unsurprising result is @code{2}.

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

@figure["fig:sumto-red"
        @list{An example reduction graph. Since @et[μ] reductions
              substitute the entire @et[rec] expression in the body, the
              bodies of duplicate such expressions are omitted, but are
              all the same as the initial @et[rec].}
        @raw-latex{\includegraphics[scale=0.85]{sumto.pdf}}]

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
value of @code{3}. Generating this reduction graph with
Redex is again a one-liner given the appropriate definitions:
@code{(traces STLC-red (sumto 2))}. The fact that there is a
single path in the graph is a feature of this reduction relation;
other reduction relations may give rise to many possible paths.

@italic{TODO}