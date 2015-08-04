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

@title[#:tag "sec:semantics-intro"]{Semantics Engineering: An Example}

This section works through the development of a semantics for a
simple functional language to illustrate the process of semantics
engineering along with reduction semantics, the approach to modeling
that Redex is designed to most easily take advantage of.

@figure["fig:stlc-exps" 
        "Grammar for expressions."
        @(centered (exp-pict))]

@Figure-ref["fig:stlc-exps"] shows the grammar for the language
we'll be modeling in this section. It is a language of numbers and
functions, with two binary operations on numbers, addition (@et[+])
and subtraction (@et[-]), along with a conditional (@et[if0]) that
dispatches on whether or not its first argument evaluates to @et[0]
or not. Expressions beginning with @et[λ] construct functions of a
single argument, which are applied via parenthesized juxtaposition
as in Racket or other languages in the LISP family. Finally, @et[rec]
expressions support the construction of recursive bindings.

A semantics for a programming language is a function from programs
to answers. The kind of function used and what is meant by answers
varies, depending on what the semantics is to be used for. Here
we will develop an operational semantics in the form of a
syntactic machine that transforms programs until they become
answers.

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

To this end, we develop a set of rules known as notions of
reduction. The rules are directed relations, pairing any
expression in the language that is not a value with another
expression that is in some sense ``closer'' to being a value.
(``Closer'' in this sense is usually fairly intuitive, but
in the end it is necessary to prove that a semantics based on
these rules does the right thing by eventually transforming
all valid programs into values.)
For example, the notion of reduction for our binary operations
looks like:

@(centered (plus-pict))

Meaning that when a binary operation is applied to two numbers
in an expression, we can relate that expression to the number
that is the result of the corresponding operation on numbers. This
allows us to ``reduce'' such a binary operation to a value. A
simple example is:

@(centered (plus-example))

The rule for function application is more interesting. It says
that when a function is applied to a value, the resulting
expression is constructed by substituting the value @et[v] for all
instances of the variable @et[x] bound by the function in the
function's body @et[e]:

@(centered (beta-pict))

Where the notation @(subst-in-e-pict) means to perform
@emph{capture-avoiding} substitution of @et[e] for @et[x] in
@et[v]. 
For example, the application of a function that adds one to its
argument to two reduces as follows:

@(centered (beta-example))

@figure["fig:one-step" 
        "The complete set of reductions for this language."
        @(centered (red-one-pict))]

The complete set of reductions adds rules for @et[if0] and @et[rec]
and is shown in @figure-ref["fig:one-step"].