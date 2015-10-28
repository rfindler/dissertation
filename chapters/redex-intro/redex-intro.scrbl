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
          (for-syntax racket/syntax))

@(define stlc-rel-path-string
   (path->string
    (find-relative-path (current-directory)
                        (simplify-path (build-path common-path 'up "model" "stlc.rkt")))))

@(define stlc-stxobjs
   (parameterize ([port-count-lines-enabled #t])
     (call-with-input-file (build-path common-path 'up "model" "stlc.rkt")
       (λ (in)
         (read-line in)
         (let loop ([ds '()])
           (define next (read-syntax in in))
           (if (eof-object? next)
               ds
               (loop (cons next ds))))))))

@(define stlc-eval (make-base-eval))

@(stlc-eval `(require redex/reduction-semantics
                      racket/pretty
                      ,stlc-rel-path-string))

@(stlc-eval '(pretty-print-columns 60))

@title[#:tag "sec:semantics-intro"]{Operational Semantics by Example}

This section works through the development of a semantics for a
simple functional language to illustrate the process of semantics
engineering along with reduction semantics, the approach to modeling
that Redex is designed for.

@figure["fig:stlc-exps" 
        "Grammar for expressions."
        @(centered (exp-pict))]

@Figure-ref["fig:stlc-exps"] shows the grammar for the language
we'll be modeling in this section. It is a parenthesized,
prefix-notation language of numbers and
functions, with two binary operations on numbers, addition (@et[+])
and subtraction (@et[-]), along with a conditional (@et[if0]) that
dispatches on whether or not its first argument evaluates to @et[0]
or not. Expressions beginning with @et[λ] construct functions of a
single argument, which are applied via parenthesized juxtaposition
as in Racket or other languages in the Lisp family. Finally, @et[rec]
expressions support the construction of recursive bindings. Since
this is a typed langauge, both of the bindings form also refer to
types @et[τ], which are defined later in this section.

A semantics for a programming language is a function from programs
to answers. The way the function is defined 
varies, depending on the intended use of the semantics. Here
we will develop an operational semantics in the form of a
syntactic machine that transforms programs until they become
answers, meaning the domain and range of the function are 
abstract syntax trees defined by the grammar in 
@figure-ref["fig:stlc-exps"], and it is defined in terms of
relations on syntax.

To develop a semantics for this language, we start by identifying the
answers, a subset of expressions that are @emph{values}, the results or
final states of @emph{computations}. For this language the right choices
are numbers and functions, both of which cannot be further evaluated
without being used in another expression. We denote values with the
addition of another nonterminal, @et[v]:
@(centered (v-pict))
We expect that all valid programs (more will be said below about
validity) either are a value, or will eventually evaluate
to a value.

To this end, we develop a set of relations, pairing any
expression in the language that is not a value with another
expression that is in some sense ``closer'' to being a value.
(``Closer'' in this sense is usually fairly intuitive to
a programmer, but in the end it is necessary to prove that
a semantics based on these rules does the right thing by
eventually transforming valid and terminating programs into values.)
For example, the notion of reduction for our binary operations
looks like:
@(centered (plus-pict))
meaning that when a binary operation is applied to two numbers
in an expression, we can relate that expression to the number
that is the result of the corresponding operation on numbers.
(The G@"\u00f6"del brackets @(brackets-pict) lift natural
numbers into the syntax of the language.) This
allows us to ``reduce'' such a binary operation to a value. The
expression on the left is called the reducible expression or redex,
and the expression on the right is called the contractum.
A simple example is:

@(centered (plus-example))

The rule for function application is more interesting. It says
that when a function is applied to a value, the resulting
expression is constructed by substituting the value @et[v] for all
instances of the variable @et[x] bound by the function in the
function's body @et[e]:
@(centered (beta-pict))
where the notation @(subst-in-e-pict) means to perform
capture-avoiding substitution@note{Capture-avoiding substitution@~cite[redex]
 avoids unintentional variable bindings (captures) that can occur
 when substituting underneath binders by renaming variables appropriately.}
of @et[e] for @et[x] in @et[v]. 
For example, the application of a function that adds one to its
argument to two takes a step as follows:

@(centered (beta-example))

@figure["fig:one-step" 
        "Single step reduction, the union
        of all the notions of reduction for this language."
        @(centered (red-one-pict))]

The complete set of reductions adds rules for @et[if0] and @et[rec]
and is shown in @figure-ref["fig:one-step"]. The @et[if0] rule reduces
to the second or third argument, depending on the value of the
first, and the @et[rec] rule unfolds a recursive binding
once, substituting the entire expression in the body.

The set of reductions shown in @figure-ref["fig:one-step"] capture
the notions of computation we intend for our language,
but they aren't enough to build an evaluator for all programs, because
they only apply at the top level of a term. For example, the term
@et[(+ 1 (+ 2 3))] can't be reduced using the @et[δ] rule, because
at the top level, the second expression is not a number.

To create a relation upon which we can base an evaluator, we need to
extend the set of reductions to apply deeper inside of terms. One
way to do this is to take the @emph{compatible closure} of the
reductions over expressions, which constructs a relation that
allows the reductions to be applied anywhere inside a term. This
is useful as the basis for an equational calculus, but it is
not an evaluator because a given term can be reduced many different
ways and evaluators have a fixed strategy.

Instead we can construct a relation that relates each term
that can take a step to exactly one term. To do this we use
an @emph{evaluation context}, an expression that includes
a ``hole'', denoted by @et[[]]. This allows a term to
be decomposed into a context and, in the hole of the context,
a redex. The contractum of the redex can be
plugged back into the hole, expressing a single step of
computation. The evalutation contexts for our language are
denoted by the @et[E] non-terminal:
@(centered (context-pict))
The first two productions allow reductions to apply on the left-hand side
of an application, and on the right right-hand-side of an application if the
left-hand-side is a value. The contexts for binary operations are analagous
to those for applications, the second to last production allows computation
in the condition position of @et[if0] expression, and the last is the
hole, which may contain any term.

To construct a standard reduction relation, which we denote with
@(std-red-arrow), we take the @emph{contextual closure} of the
the one-step reduction over @et[E]:
@(centered (context-closure-pict))
meaning that if a term can take a step according to the one-step
reduction, then a context with that same term in its hole can
take a step to a term where the corresponding contractum is
plugged back into the context at the same position the redex occupied.
The intention of the standard reduction is to allow each program
to take a step of computation in exactly one way. It may not
be immediately obvious from the structure of evaluation contexts
that we have this property, so we might wish to test it
and, later, prove it. (I address how to test it in Redex
in the next section.)

The idea of evaluating a program @et[e] corresponds to the reflexive
transitive closure of the standard reduction, denoted by @(std-refl-trans).
We can define an evaluator in terms of this relation, as follows:
@(centered (eval-pict))
The idea behind @et[Eval] is to reduce a program over and over
according to the standard reduction until it becomes a value.
If the value is a number, we consider that to be an answer. If it is
syntax for an unapplied function, we return @et[function], since
that syntax really represents an internal state of the
evaluator and is not useful.

Note, however, that @et[Eval] is not a total function, for several
reasons. First, not all programs terminate. (Equivalently,
the transitive-reflexive closure of the standard reduction doesn't
relate them to values.) Second, some programs may get ``stuck'',
or terminate in expressions that are not values and cannot
take another step.@note{Another issue sidestepped here
 that comes up in all real programming languages is that some
 primitives, such as division, are partial functions.}
We can't avoid the first issue without seriously handicapping
our language, but we can tackle the second with a type system,
which allows us to separate programs that will get stuck
from those that will not.

The type system accomplishes this by categorizing expressions
according to what sort of values they will evaluate to. To start,
we need a language of types, denoted by @et[τ]:
@(centered (τ-pict))
expressing that we expect two types of values, numbers (@et[num]),
and functions from one type of value to another, represented
by arrows. We can already see that the type system excludes some
programs that may not get stuck, namely functions that may
return more that one type depending on their input. We could
capture functions like this by extending our language of types, but in
general the type system must be conservative, excluding some ``good''
programs in order to exclude all ``bad'' ones.

We construct the type system using a set inference rules called
a typing judgment that defines
a relation between a type environments (@et[Γ], to be defined
shortly), expressions, and types. As an example, the rule for
binary operations is:
@(centered (binop-rule))
expressing that two expressions that evaluate to numbers
can be combined using a binary operation, and the resulting
expression will evaluate to a number. The relation is defined
recursively. To deal with substitutions that occur during
evaluation, the type judgment uses the type environment @et[Γ],
an accumulator to keep track of the types assigned to
variables:

@(centered (Γ-pict))

The rule for function definition says that if the
body of the function has some type with respect to the environment
extended with the type of the parameter, then the
function itself has an arrow type from the type of the parameter
to the type of the body, in the original environment:

@(centered (abstraction-rule))

@figure["fig:type-judgment"
        "The definition of the typing judgment."
        @(centered stlc-type-pict-horiz)]

The corresponding rule for typing a variable just looks
for the type in the environment. The complete definition of
the typing judgment is shown in @figure-ref["fig:type-judgment"].
These particular rules can be easily used to derive a
type checking algorithm. Treating the first two positions of
the relation as inputs and the last as an output leads
directly to the definition of a recursive function for
type-checking. 

Now the type system can be used to restrict the set of valid
programs to those that satisfy the judgment:
@(centered (is-typed-pict))
selecting those expressions that have some type with
respect to the empty type environment, or are ``well-typed''.
By making this restriction, we assert our belief that
if a program is well-typed, then either it evaluates to a value
or it does not terminate. Ideally, we should 
formally prove this property, but first it is helpful to
test it. Modeling in Redex and testing properties
such as this are the subject of the next section.
