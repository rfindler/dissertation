#lang scribble/base

@(require scribble/core
          "../util.rkt"
          "../../model/typesetting.rkt")

@title{Proof of Gremlin Threat}

A conjunction of equations @ct[(∧ e ...)] is satisfiable if there is a
substitution that makes all of the equations identical.

A disequational constraint @ct[δ] = @ct[(∀ (x ...) (∨ (p_l ≠ p_r) ...))] is satisfiable
if there is a substitution @tx["\\alpha"], with @tx["Vars(\\alpha)"] ∩ @ct[{x ...}] = ∅, such that
for some @ct[p_l], @ct[p_r], there does not exist a substitution @tx["\\beta"] where
@tx["\\beta\\alpha"]@ct[p_l] is identical to @tx["\\beta\\alpha"]@ct[p_r].

For some @ct[C] = @ct[(∧ (∧ e ...) (∧ δ ...))], @ct[C] is consistent if there is
a substitution @tx["\\alpha"] that makes both sides of all equations @ct[e] identical,
and for all disequational constraints @ct[δ], the result @tx["\\alpha"]@ct[δ] of applying
@tx["\\alpha"] to @ct[δ] remains satisfiable.

A conjunction of equations @ct[(∧ e ...)] is in canonical form if
@ct[(∧ e ...)] = @ct[(∧ (x = p) ...)], where if @ct[x_l] ∈ @ct[{x ...}], then
@ct[x_l] ∩ @tx["Vars("]@ct[(p ...)]@tx[")"] = ∅. Note that the equations
themselves express an idempotent substitution that makes the equations identically true,
i.e. @ct[{(x := p) ...}], so the equations are immediately satisfiable.

Finally, @ct[C] = @ct[(∧ (∧ (x = p) ...) (∧ δ ...))] is in canonical form if
the equations are in canonical form, and if @tx["\\alpha"] is the substitution
expressed by the equations (as above), @tx["\\alpha"]@ct[(δ ...)] = @ct[(δ ...)],
and for each @ct[δ] = @ct[(∀ (x_δ ...) (∨ (p_l ≠ p_r) ...))],
there exists @ct[p_l] = @ct[x_p], and
@ct[x_p] ∩ @ct[{x_δ ...}] = ∅, and @ct[p_r] ∩ @ct[{x_δ ...}] = ∅, i.e.
at least one of the inequations in the disjunction has a left hand side
that is a variable which is not in the domain of the mgu expressed by the
equations and is not universally quantified, and a right hand side that
is not a universally quantified variable. As above, we have
@tx["\\alpha"]@ct[x_p] = @ct[x_p], and we can choose @tx["\\beta"] such that there
is no substitution @tx["\\gamma"] where @tx["\\gamma\\beta\\alpha"]@ct[x_p] and
@tx["\\gamma\\beta\\alpha"]@ct[p_r] are identical.
(If @ct[p_r] is a variable, it is unconstrained, otherwise it is a constructor,
and in either case we can choose to make @tx["\\beta\\alpha"]@ct[x_p] and
@tx["\\beta\\alpha"]@ct[p_r] conflict.)
This gives us:

@lemma{If @ct[C] is in canonical form, @ct[C] is consistent.}


@theorem{For any @ct[e] and @ct[C] in canonical form, @ct[solve] terminates
         with @ct[⊥] if there is no unifier of @ct[e] and the equations in
         @ct[C]. Otherwise, it terminates with @ct[C_Ω] in canonical form,
         such that the equations in @ct[C_Ω] are an mgu of @ct[e] and the
         equations in @ct[C], and @ct[C_Ω] is consistent.}

@proof{Obvious.}