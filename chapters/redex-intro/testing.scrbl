#lang scribble/base

@(require scriblib/figure
          scribble/eval
          scribble/manual
          scriblib/footnote
          racket/match
          racket/sandbox
          racket/path
          "../../model/stlc.rkt"
          "../common.rkt"
          "code-utils.rkt"
          (for-syntax racket/syntax))

@(define stlc-eval (make-base-eval))

@(stlc-eval `(require redex/reduction-semantics
                      racket/pretty
                      racket/list
                      ,stlc-rel-path-string))


@title[#:tag "sec:redex-testing"]{Property-based Testing with Redex}

Redex strives to miminize the amount of time between sitting down
to write a Redex model and having an exectuable semantics to work
with. Executability alone already provides a significant return on
investment for the Redex user. Along with the tooling for interactive
and graphical exploration of a model's dynamics, its greatest
benefit is the ability to @italic{test} a semantics.

An executable semantics can be equipped with a suite of tests. Unit tests
alone, which Redex has built-in tooling for, provide a semantics engineer
with the same benefits they are known to confer to software engineers,
such as support for refactoring, the ability to apply test-driven
development, and higher overall confidence in the correctness of a model.
May Redex efforts are intended to model an already existing system
(for example, @citet[racket-virtual-machine], @citet[full-monty],
@citet[s5], and @citet[lambda-js]), and in such cases tests support
confidence that the behaviors of the model and the implementation agree.

Unit tests, although unquestionably important for both software and
semantics engineering, are fundamentally limited by the ingenuity of
the writer of test cases. Another approach that relies
less on human efforts to cover the
space of possible tests is @italic{property-based testing}, where
instead of writing individual test cases a programmer defines a
property that should hold of their program and a domain over which
it should be checked. A @italic{generator} then uses the definition
of the domain to create many test cases in an attempt to falsify the
property. QuickCheck@~cite[QuickCheck] and its many derivatives have
popularized this approach over the past few years.

When developing a semantics we are usually interested in such
general properties of a model, to the extent that a final step in such
a development is to prove a number of them. For this reason,
property-based testing is an especially attractive approach to
semantics engineering. There are many testable properties that come
up, and it is useful to be test them thoroughly during the
development process.

Redex supports property-based testing through the @code{redex-check}
form, which allows users to specify a method of generating terms
and a property to check. It then generates a number of terms,
checking the property with each one until it finds one that
falsifies the property or reaches some maximum number of tries.
As a first example, we can try to verify the (false) property that every
expression in the language of @secref["sec:redex-modeling"] is either
a value or takes one step:
@interaction[#:eval stlc-eval
                    (redex-check STLC e
                                 (or (redex-match STLC v (term e))
                                     (not (empty?
                                           (apply-reduction-relation STLC-red
                                                                            (term e))))))]
The first line tells @code{redex-check} to generate random @code{e}'s from
the @code{STLC} language, and the @code{or} expression is the predicate to check.
In this case, it finds a counterexample on its first try, a free variable.

A property that should hold in this language is slightly more complex.
If a term is well-typed, then it should be the case that it is either a value
or that it can take a single reduction step. Also, if it can take
a step, then the resulting term should have the same type. We can
formulate this property as a Racket predicate:
@racketblock[#,check-pp-stxobj]
Now we can use @code{redex-check} to attempt to falsify it:
@interaction[#:eval stlc-eval
                    (redex-check STLC e
                                 (check-progress/preservation (term e)))]
This seems encouraging at first, but digging a little deeper exposes
a common problem with random testing.

Test case generators can be called directly with the
@code{generate-term} form, which take a language, a pattern, and a
depth limit as parameters. This allows us to see what kind of terms
@code{redex-check} is using to test the property:
@(stlc-eval '(random-seed 13))
@interaction[#:eval stlc-eval
                    (generate-term STLC e 2)]
Clearly this term is not well-typed, it even has a number of free variables.
Looking back at the definition of @code{check-progress/preservation} we
can see that this isn't a very good test case, because it fails the
premise of the implication that we want to test, so it doesn't verify
that a well-typed term takes a step, or that the type is preserved. To
check this part of the property, we need a good portion of the test cases
to be well-typed. Also, we would like to avoid having too many of the well-typed
test cases be values, because they won't take any evaluation steps.
We can generate a number of terms with @code{generate-term}
and check to see how many of them are ``good'':
@(stlc-eval '(random-seed 13))
@interaction[#:eval stlc-eval
                    (length
                     (filter (λ (e) (and (judgment-holds (tc • ,e τ))
                                         (not (redex-match STLC v e))))
                             (for/list ([i 1000])
                               (generate-term STLC e 3))))]
Here we generated 1000 random terms, and less than 2% of them are
good test cases.

To give a better idea of what kind of terms are being generated,
@figure-ref["fig:stlc-stats-table"] shows some
statistics for random terms in this language, and exposes some
of the difficulty inherent in generating ``good'' terms. Although
about 18% of random expresssions are well typed, only 2.45% are
well-typed and not a constant or a constant function (a function
of the form @italic{(λ (x τ) n)}). The terms that are good tests
for the property in question, those that are well-typed and
exercise the reduction, are even rarer, at 1.76% of all terms.

@(define table-labels
   (hash 'typed-and-interesting? "Well-typed, not a constant or constant function"
         'at-least-1-red "Reduces once or more"
         'well-typed? "Well-typed"
         'typed-and-reduces "Well-typed, reduces once or more"
         'uses-β "Uses β rule"
         'uses-μ "Uses μ rule"
         'uses-δ "Uses δ rule"
         'at-least-3-red "Reduces three or more times"
         'uses-if-else "Uses if-else rule"
         'at-least-2-red "Reduces twice or more"
         'uses-if-0 "Uses if-0 rule"))
@(define (table-trials)
   (call-with-input-file (build-path common-path 'up "model" "stlc-stats.rktd")
     (λ (in)
       (read in))))
@(define (table-data)
   (call-with-input-file (build-path common-path 'up "model" "stlc-stats.rktd")
     (λ (in)
       (read in)
       (read in))))

@figure["fig:stlc-stats-table"
        (string-append
         "Statistics for " 
         (number->string (table-trials)) 
         " terms randomly generated from the stlc grammar.")
@tabular[#:sep @hspace[1]
         (cons (list @bold{Term characteristic} @bold{Percentage of Terms})
                 (let ([sorted-data
                        (sort (table-data)
                              >
                              #:key cdr)])
                   (for/list ([dat (in-list sorted-data)])
                     (match dat
                       [(cons term-kind num)
                        (list (hash-ref table-labels term-kind)
                              (string-append
                               (real->decimal-string (* 100 num))
                               "%"))]))))]]

The use of a few basic strategies can  improve
the coverage of terms generated using this method. Redex can
generate terms using the patterns of the left-hand-sides of the
reduction rules as templates, which increases the
chances of generating a term exercising each case. However, it is
still likely that such terms will fail to be well-typed.
Frequently this is due to the presence of free variables in the term. 
Thus the user can write a function to preprocess randomly generated
terms by attempting to bind free variables. Both approaches are
well-supported by @code{redex-check}.

The strategy of using strategically selected source patterns
and preprocessing terms in some way is typical of most serious
testing efforts involving Redex, and has been effective
in many cases. It has been used to successfully find bugs
in a Scheme semantics@~cite[klein-masters], the Racket
Virtual Machine@~cite[racket-virtual-machine], and various
language models drawn from the International Conference on 
Functional Programming@~cite[run-your-research].

Another approach is to use the type system directly to generate
test cases. Adding this capability to Redex is one of the main
contributions outlined in this dissertation. To do so,
we can use the @code{#:satsifying} keyword with @code{generate-term},
which takes a judgment form that Redex will attempt to use to
generate test cases.
@(stlc-eval '(random-seed 13))
@interaction[#:eval stlc-eval
                    (generate-term STLC #:satisfying (tc • e τ) 2)]
We get back a complete type judgment containing a well-typed term
and its type. Inspection of this term confirms that it is well-typed,
and has no free variables.

Similarly, we can ask @code{redex-check} to use the typing judgment
to generate its test cases.
@interaction[#:eval stlc-eval
                    (redex-check STLC #:satisfying (tc • e τ)
                                 (check-progress/preservation (term e))
                                 #:attempts 100)]
Since all of the test cases used in this pass were well-typed,
this is a much better test of the property, and provides higher
confidence it is correct. @Secref["sec:semantics"] discusses how
this type of generation works, and @secref["sec:evaluation"] addresses
how well different approaches to random generation do at testing semantics.
