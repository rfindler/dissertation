#lang scribble/base

@(require "../common.rkt"
          "bug-info.rkt"
          scribble/core
          scriblib/figure
          scriblib/footnote
          scribble/manual
          racket/format
          racket/match
          racket/function
          (only-in pict scale))

@title[#:tag "sec:benchmark-models"]{The Benchmark Models}

The programs in the benchmark come from two sources:
synthetic examples based on experience with Redex over
the years and from pre-existing models along with
bugs that were encountered during
the development process.

The benchmark has six different Redex models, each of which
provides a grammar of terms for the model and a soundness
property that is universally quantified over those terms.
Most of the models are of programming languages and most of
the soundness properties are type-soundness, but we also
include red-black trees with the property that insertion
preserves the red-black invariant, as well as one richer
property for one of the programming language models 
(discussed in @secref["sec:b:stlc-sub"]).
@Figure-ref["fig:benchmark-models"] summarizes the models
included, showing whether they are synthesized for the benchmark
or a pre-existing artifact that was included, the non-whitespace,
non-comment lines of code, and the number of bugs added
to each model.  The line
number counts include the model and the specification of the
property.

For each model, bugs are manually introduced into a
number of copies of the model, such that each copy is
identical to the correct one, except for a single bug. The bugs
always manifest as a term that falsifies the soundness
property. 

@(define mod-data
   (map
    (match-lambda
      [`(,name ,a ,b loc ,c)
       `(,name ,a ,b ,(get-line-count (string->symbol name)) ,c)]
      [thing thing])
    '(("Model" "synthesized" "artifact" "loc" "# of bugs")
      ("delim-cont" #f #t loc 3)
      ("let-poly" #t #f loc 7)
      ("list-machine" #f #t loc 3)
      ("poly-stlc" #t #t loc 9)
      ("rbtrees" #t #f loc 3)
      ("rvm" #f #t loc 7)
      ("stlc" #t #f loc 9)
      ("stlc-sub" #t #f loc 9))))

@(define models-list
  (map
   ((curry map)
    (match-lambda
      [(? string? str) str]
      [(? number? n) (number->string n)]
      [#f ""]
      [#t "•"]))
   mod-data))

@figure*["fig:benchmark-models" "Benchmark Models"
  @centered[
     @tabular[#:sep @hspace[10]
              #:column-properties '(left center center center)
              #:row-properties '(bottom-border ())
              models-list]]]

Each bug has been classified by hand according to a qualitative
scheme as @bold{S/M/D/U}, meaning, as follows:
@itemlist[
  @item{@bold{S} (Shallow) Errors in the encoding of the system into Redex,
         due to typos or a misunderstanding of subtleties of Redex.}
  @item{@bold{M} (Medium) Errors in the algorithm behind the
         system, such as using too simple of a data-structure that doesn't
         allow some important distinction, or misunderstanding that some
         rule should have a side-condition that limits its applicability.}
  @item{@bold{D} (Deep) Errors in the developer's understanding of the system, 
         such as when a type system really isn't sound and the author
         doesn't realize it.}
  @item{@bold{U} (Unnatural) Errors that are unlikely to have come up in
         real Redex programs but are included for our own curiosity. There
         are only two bugs in this category.}]

The table in Appendix B @;{@secref["sec:bench-table"]} gives a
more detailed overview, showing the classification, size
of the smallest known counterexample, and a short description
for each bug.
Each bug has a number and, with the exception of the rvm
model, the numbers count from 1 up to the number of bugs.
The rvm model bugs are all from 
@citet[racket-virtual-machine]'s work and we follow their
numbering scheme (see @secref["sec:b:rvm"] for more
information about how we chose the bugs from that paper).

The following subsections each describe one of the
models in the benchmark, along with the errors introduced
into each model. The bugs are described along with short
justifications for how they are categorized.

@section[#:tag "sec:b:stlc"]{stlc} 
A simply-typed λ-calculus with base
types of numbers and lists of numbers, including the
constants @tt{+}, which operates on numbers, and
@tt{cons}, @tt{head}, @tt{tail}, and @tt{nil} (the empty
list), all of which operate only on lists of numbers. The
property checked is type soundness: the combination of
preservation (if a term has a type and takes a step, then
the resulting term has the same type) and progress (that
well-typed non-values always take a reduction step). 

Nine different bugs wre introduced into this system. The
first confuses the range and domain types of the function in
the application rule, and has the small counterexample: 
@racket[(hd 0)]. We consider this to be a shallow bug, since
it is essentially a typo and it is hard to imagine anyone
with any knowledge of type systems making this conceptual
mistake. Bug 2 neglects to specify that a fully applied 
@racket[cons] is a value, thus the list 
@racket[((cons 0) nil)] violates the progress property. We
consider this be be a medium bug, as it is not a typo, but
an oversight in the design of a system that is otherwise
correct in its approach.

We consider the next three bugs to be shallow. Bug 3
reverses the range and the domain of function types in the
type judgment for applications. Bug 4 assigns
@racket[cons] a result type of @racket[int]. The fifth bug
returns the head of a list when @racket[tl] is applied. Bug
6 only applies the @racket[hd] constant to a partially
constructed list (i.e., the term @racket[(cons 0)] instead
of @racket[((cons 0) nil)]).

The seventh bug, also classified as medium, omits a production
from the definition of evaluation contexts and thus doesn't reduce
the right-hand-side of function applications.

Bug 8 always returns the type @racket[int] when looking up
a variable's type in the context. This bug (and the identical one
in the next system) are the only bugs we classify as unnatural. It
is included because it requires a program to have a variable with
a type that is more complex that just @racket[int] and to actually
use that variable somehow.

Bug 9 is simple; the variable lookup function has an error where it
doesn't actually compare its input to variable in the environment,
so it effectively means that each variable has the type of the nearest
enclosing lambda expression.

@section[#:tag "sec:b:poly-stlc"]{poly-stlc} 
This is a polymorphic version of the model in @secref["sec:b:stlc"], with
a single numeric base type, polymorphic lists, and polymorphic 
versions of the list constants. 
No changes were made to the model except those necessary to 
make the list operations polymorphic.
There is no type inference in the model, so all polymorphic
terms are required to be instantiated with the correct
types in order to type check. 
Of course, this makes it much more difficult to automatically 
generate well-typed terms, and thus counterexamples.
As with @bold{stlc}, the property checked is
type soundness.

All of the bugs in this system are identical to those in
@bold{stlc}, aside from any changes that had to be made
to translate them to this model. 

This model is also a subset of the language specified in
@citet[palka-workshop], who used a specialized and optimized
QuickCheck generator for a similar type system to find bugs 
in GHC. This system as adapted (along with its restriction in
@bold{stlc}) because it has already been used successfully
with random testing, which makes it a reasonable target for
an automated testing benchmark.

@section[#:tag "sec:b:stlc-sub"]{stlc-sub} 
This is the same language and type system as @secref["sec:b:stlc"],
except that in this case all of the errors are in the substitution
function. 

Experience with Redex shows it is easy to make subtle
errors when writing substitution functions, and this
set of tests specifically targets them with the benchmark.
There are two soundness checks for this system. Bugs 1-5 are
checked in the following way: given a candidate
counterexample, if it type checks, then all βv-redexes in
the term are reduced (but not any new ones that might
appear) using the buggy substitution function to get a second
term. Then, these two terms are checked to see if they both
still type check and have the same type and that the result
of passing both to the evaluator is the same.

Bugs 4-9 are checked using type soundness for this system as
specified in the discussion of the @secref["sec:b:stlc"] model. We
included two predicates for this system because we believe
the first to be a good test for a substitution function but
not something that a typical Redex user would write, while
the second is something one would see in most Redex models
but is less effective at catching bugs in the substitution
function.

The first substitution bug introduced simply omits the
case that replaces the correct variable with the
term to be substituted. We consider this to be a shallow
error.
Bug 2 permutes the order of arguments when making a
recursive call. This is also categorized as a shallow bug,
although it is a common one, at least based on
experience writing substitutions in Redex.
Bug 3 swaps the function and argument positions of
an application while recurring, again essentially a typo and
a shallow error, although one of the more difficult to
find in this model.

The fourth substitution bug neglects to make the renamed
bound variable fresh enough when recurring past a
lambda. Specifically, it ensures that the new variable is
not one that appears in the body of the function, but it
fails to make sure that the variable is different from the
bound variable or the substituted variable. We categorized
this error as deep because it corresponds to a
misunderstanding of how to generate fresh variables, a
central concern of the substitution function.
Bug 5 carries out the substitution for all variables in the
term, not just the given variable. We categorized it as SM,
since it is essentially a missing side condition, although a
fairly egregious one.
Bugs 6-9 are duplicates of bugs 1-3 and bug 5, except that
they are tested with type soundness instead. (It is
impossible to detect bug 4 with this property.)

@section[#:tag "sec:b:let-poly"]{let-poly}
A language with ML-style @tt{let} polymorphism, included in
the benchmark to explore the difficulty of finding the 
classic let+references unsoundness. With the exception of
the classic bug, all of the bugs were errors made during
the development of this model (and that were caught during
development).

The first bug is simple; it corresponds to a typo, swapping
an @tt{x} for a @tt{y} in a rule such that a type variable
is used as a program variable.
Bug number 2 is the classic let+references bug. It changes the rule
for @tt{let}-bound variables in such a way that generalization
is allowed even when the initial value expression is not a value.
This is a deep bug.
Bug number 3 is an error in the function application case where the
wrong types are used for the function position (swapping two types
in the rule).
Bugs 4, 5, and 6 were errors in the definition of the unification
function that led to various bad behaviors. Bug 4 is a simple typo,
while 5 and 6 are actual errors although not deep ones, and
are classified as medium.

Finally, bug 7 is a bug that was introduced early on, but was only 
caught late in the development process of the model. It used a
rewriting rule for @tt{let} expressions that simply reduced them
to the corresponding @tt{((λ} expressions. This has the correct
semantics for evaluation, but the statement of type-soundness does not
work with this rewriting rule because the let expression has more
polymorphism that the corresponding application expression, a subtle
point that is easy to get wrong, so this was classified as a deep bug.

@section[#:tag "sec:b:list-machine"]{list-machine} An implementation of 
@citet[list-machine]'s list-machine benchmark. This is a
reduction semantics (as a pointer machine operating over an
instruction pointer and a store) and a type system for a
seven-instruction first-order assembly language that
manipulates @tt{cons} and @tt{nil} values. The property
checked is type soundness as specified in 
@citet[list-machine], namely that well-typed programs always
step or halt. Three mutations are included.

The first list-machine bug incorrectly uses the head position
of a cons pair where it should use the tail position in the 
cons typing rule. This bug amounts to a typo and is classified
as simple.

The second bug is a missing side-condition in the rule that updates
the store that has the effect of updating the first position in
the store instead of the proper position in the store for
all of the store update operations. We classify this as a medium bug.

The final list-machine bug is a missing subscript in one rule
that has the effect that the list cons operator does not store
its result. Essentially a typo, and classified as a simple bug.

@section[#:tag "sec:b:rbtrees"]{rbtrees}
A model that implements the red-black
tree insertion function and checks that insertion preserves
the red-black tree invariant (and that the red-black tree is
a binary search tree).

The first bug simply removes the re-balancing operation from
insert. We classified this bug as medium since it seems like
the kind of mistake that a developer might make in staging
the implementation. That is, the re-balancing operation is separate
and so might be put off initially, but then forgotten. 

The second bug misses one situation in the re-balancing
operation, namely when a black node has two red nodes under
it, with the second red node to the right of the first. This
is a medium bug.

The third bug is in the function that counts the black depth in
the red-black tree predicate. It forgets to increment the count
in one situation. As a small oversight, this is a simple bug.

@section[#:tag "sec:b:delim-cont"]{delim-cont}
@citet[delim-cont-cont]'s model of a contract and type system for
delimited control. The language
is Plotkin's PCF extended with operators for delimited continuations,
continuation marks, and contracts for those operations. 
The property checked is type soundness. We added three bugs
to this model.

The first was a bug found by mining the model's
git repository's history. This bug fails to put a list
contract around the result of extracting the marks from a
continuation, which has the effect of checking the contract
that is supposed to be on the elements of a list against the
list itself instead. We classify this as a medium bug.

The second bug was in the rule for handling list contracts. When checking
a contract against a cons pair, the rule didn't specify that it should
apply only when the contract is actually a list contract, meaning
that the cons rule would be used even on non-list contacts, leading
to strange contract checking. We consider this a medium bug because
the bug manifests itself as a missing @racket[list/c] in the rule.

The last bug in this model makes a mistake in the typing
rule for the continuation operator. The mistake is to leave
off one-level of arrows, something that is easy to do with
so many nested arrow types, as continuations tend to have.
We classify this as a simple error.

@section[#:tag "sec:b:rvm"]{rvm} A existing model and test
framework for the Racket virtual machine and bytecode
verifier@~cite[racket-virtual-machine]. The bugs were
discovered during the development of the model and reported
in section 7 of that paper. Unlike the rest of the models,
bugs for this model are not numbered sequentially but instead
use the numbers from @citet[racket-virtual-machine]'s work.
The bugs are described in detail in @citet[racket-virtual-machine]'s
paper.


Only some bugs from the paper were used, excluding bugs for two
reasons:
@itemlist[@item{The paper tests two properties: an internal
  soundness property that relates the verifier to the
  virtual machine model, and an external property that
  relates the verifier model to the verifier implementation.
  Those that require the latter properties were excluded because it
  requires building a complete, buggy version of the Racket
  runtime system to include in the benchmark.}
           
          @item{All of the internal properties were included,
  except those numbered 1 and 7, for practical reasons. The
  first is the only bug in the machine model, as opposed to
  just the verifier, which would have required the
  inclusion of the entire VM model in the benchmark. The second
  would have required modifying the abstract representation
  of the stack in the verifier model in contorted way to
  mimic a more C-like implementation of a global, imperative
  stack. This bug was originally in the C implementation of
  the verifier (not the Redex model) and to replicate it in
  the Redex-based verifier model would require programming
  in a low-level imperative way in the Redex model,
  something not easily done.}]

This model is unique in our benchmark suite because it
includes a function that makes terms more likely to be
useful test cases. In more detail, the machine model does
not have variables, but instead is stack-based; bytecode
expressions also contain internal pointers that must be
valid. Generating a random (or in-order) term is relatively
unlikely to produce one that satisfies these constraints.
For example, of the first 10,000 terms produced by
the in-order enumeration only 1625 satisfy the constraints.
The ad hoc random generator generators produces about 900
good terms in 10,000 attempts and the uniform random
generator produces about 600 in 10,000 attempts.

To make terms more likely to be good test cases, this
model includes a function that looks for out-of-bounds
stack offsets and bogus internal pointers and replaces
them with random good values. This function is applied
to each of the generated terms before using them to test
the model.
