#lang scribble/base

@(require scribble/core
          "../common.rkt"
          "../util.rkt"
          "../../model/typesetting.rkt")

@title[#:tag "sec:proof"]{Correctness of the Constraint Solver}

A conjunction of equations @ct[(∧ e ...)] is satisfiable if there is a
substitution that makes all of the equations identical.

A disequational constraint @ct[δ] = @ct[(∀ (x ...) (∨ (p_l ≠ p_r) ...))] is satisfiable
if there is a substitution @tx["\\alpha"], with @tx["Vars(\\alpha)"] ∩ @ct[{x ...}] = ∅, such that
for some @ct[p_l], @ct[p_r], there does not exist a substitution @tx["\\beta"] where
@tx["\\beta\\alpha"]@ct[p_l] is identical to @tx["\\beta\\alpha"]@ct[p_r].
(In this section substitutions are applied by prepending them to the term.)

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
that is a variable which is not in the domain of the substitution expressed by the
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

This justifies the use of @ct[check] in @ct[solve], which simply
verifies that the disequational part of @ct[C] is in canonical form.
That the equational portion of @ct[C] is in canonical form is a
property of @ct[unify].

We also need a few definitions regarding substitutions.
Two substitutions @tx{\alpha} and @tx{\beta} are equal @tx{\alpha = \beta}
if for any any variable @tx{x}, @tx{\alpha x = \beta x}.
A substitution @tx{\alpha} is more general than @tx{\beta}, written
@tx{\alpha \leq \beta}, if there exists some substitution @tx{\gamma} such that
@tx{\beta = \gamma \alpha}. A substitution @tx{\alpha} unifies two terms
@tx{s} and @tx{t} if @tx{\alpha s = \alpha t} (where @tx{=} means they
are syntactically identical). Finally, if @tx{\alpha} is a unifier of @tx{s}
and @tx{t}, and for every unifier @tx{\beta} of @tx{s} and @tx{t},
@tx{\alpha \leq \beta}, then @tx{\alpha} is a most general unifier (mgu)
of @tx{s} and @tx{t}. The notions of unifier and mgu are extended naturally
to sets of equations.

A standard result regarding syntactic unification adapted to this setting
(see, for example, @citet[baader-snyder]) is:

@theorem{For any equations @ct[(e_0 ...)] and @ct[(∧ e ...)] in canonical form,
         @ct[(unify ((e_0 ...)) (∧ e ...))] terminates
         with @ct[⊥] if there is no unifier of @ct[(e_0 ...)] and the equations 
         @ct[(∧ e ...)]. Otherwise, it terminates with
         @ct[(∧ e_Ω ...)] in canonical form, such that the substitution
         expressed by @ct[(∧ e_Ω ...)] 
         is an mgu of @ct[e] and @ct[(∧ e ...)]}

We now prove some lemmas that justify the use of
@ct[unify] to simplify disequational constraints @ct[δ] in
@ct[disunify].

@lemma{If a substitution @tx{\alpha} is idempotent then
       @tx{\beta = \beta\alpha \Leftrightarrow \alpha \leq \beta}.}

@proof{The forward direction holds by definition. For the
       reverse direction, by definition there must be some @tx{\gamma}
       such that @tx{\gamma\alpha = \beta}, so, for any @tx{x},
@tx-wide{\beta\alpha x = \gamma\alpha\alpha x = \gamma\alpha x = \beta x}
       where the middle equality depends on the idempotency of
       @tx{\alpha}.}

@lemma{If @ct[(unify (e ...) (∧))] @tx{=} @ct[((x = p) ...)], then
       for any unifier @tx{\theta} of @ct[(e ...)],
       for any @ct[x_i] and @ct[p_i] paired in @ct[((x = p) ...)],
       @tx{\theta}@ct[x_i] @tx{=} @tx{\theta}@ct[p_i].}

@proof{If @tx{\gamma} is the mgu expressed by @ct[((x = p) ...)],
       then since @tx{\gamma \leq \theta} and @tx{\gamma} is
       idempotent, @tx{\theta = \theta\gamma} (Lemma 1), so
       @tx{\theta}@ct[x_i] @tx{=} @tx{\theta\gamma}@ct[x_i]
       @tx{=} @tx{\theta}@ct[p_i].}

@lemma{If @ct[(unify (e ...) (∧))] @tx{=} @ct[((x = p) ...)],
       then for any substitution @ct[ω],
       @centered{
       @ct[(unify (ωe_ ...) (∧))] @tx{=} @ct[⊥]
       @tx{\Leftrightarrow} @ct[(unify ((ωx_ = ωp_) ...) (∧))]
       @tx{=} @ct[⊥].}}

@proof{For the forward direction, we know there cannot be a
       unifier for the equations @ct[(ωe_ ...)]].
       Now suppose there were some
       unifier @tx{\rho} for @ct[(ω(x = p) ...)].
       Then @tx{\rho}@ct[(ωx_ ..)] @tx{=} @tx{\rho}@ct[(ωp_ ..)],
       and if @tx{\gamma} is the mgu for @ct[(e ...)],
       then @tx{\rho}@ct[ω]@tx{\gamma}@ct[(x ...)] @tx{=}
       @tx{\rho}@ct[ω]@ct[(p ...)] @tx{=}
       @tx{\rho}@ct[ω]@ct[(x ...)].
       That implies that @tx{\gamma \leq \rho}@ct[ω], so
       @tx{\rho}@ct[ω] unifies @ct[(e ...)], a contradiction.
       So there can be no such @tx{\rho}.

       For the reverse direction, by Lemma 2 any unifier
       @tx{\rho} of @ct[(e ...)] must make all the equations
       @tx{\rho}@ct[((x = p) ...)] identical, so if there is no
       unifier of @ct[((x = p) ...)], there can be none for
       @ct[(e ...)].}

That means that if some set of disequations @ct[(∨ (p_1 ≠ p_2) ...)]
is satisfiable using substitution @ct[ω], then if
@ct[(unify ((p_1 = p_2) ...) (∧))]
@tx{=} @ct[((x = p) ...)], the disequations @ct[(∨ (x ≠ p) ...)]
are satisfiable by the exact same substituion @ct[ω].
That justifies the use @ct[unify] as a simplification in
@ct[disunify].

After simplifying the disequations, @ct[param-elim] is applied
to restrict the satisfying substitution with respect to
the quantifier. In the following, for a disequational constraint
of the form @ct[(∀ (x ...) ((p_1 ≠ p_2) ...))], we will refer
to the set of parameters @tx{\{x ...\}} as @tx{X}. We refer
to a substitution @tx{\alpha} that makes the equations
@ct[(e ...)] @tx{=} @ct[((p_1 = p_2) ...)] impossible to
satisfy (and thus satisfies the disequation) as an
@italic{excluding} substitution. The excluding substitution
must also satisfy the constraint that
@tx{Variables(\alpha) \cap X = \emptyset}.
The following lemmas justify the steps used by
@ct[param-elim].

@lemma{If @ct[(e ...)] @tx{=} @ct[(e_1 ... (x = p) e_2 ...)], and
       @ct[x] @tx{\in X}, then @tx{\alpha} excludes @ct[(e ...)] iff
       @tx{\alpha} excludes @ct[(e_1 ... e_2 ...)].}

@proof{We assume @ct[(e ...)] has the property that @ct[x] does not
       occur in @ct[(e_1 ... e_2 ...)], since it is the result of
       unification and corresponds to an idempotent substitution.
       Since @tx{\alpha}@ct[x] @tx{=} @ct[x], we know that
       @ct[(unify (x = αp_) (∧))] @tx{\neq \bot}. Thus if
       @tx{\alpha} excludes @ct[(e ...)], it must exclude
       @ct[(e_1 ... e_2 ...)]. Clearly if @tx{\alpha} excludes
       @ct[(e_1 ... e_2 ...)], it excludes @ct[(e ...)].}
@;{
@lemma{If @ct[(e ...)] @tx{=} @ct[(e_1 ... (x_l = x_r) e_2 ...)],
       and @tx{x_l \not\in X} and and @tx{x_r \in X} and @tx{x}
       does not occur in @ct[(e_1 ... e_2 ...)], when @tx{\alpha}
       excludes @ct[(e ...)] iff @tx{\alpha} excludes @ct[(e_1 ... e_2 ...)]}.

@proof{Same as the previous lemma.}}

In the following lemma, for convenience we refer to a list of
equations in canonical form @ct[((x = p) ...)] as a set
@tx{\{x_1 = p_1\}\{x_2 = p_x\}...\{x_n = p_n\}}, where
juxtaposition means union.

@lemma{If @tx{\gamma = \{x_1 = x\}...\{x_n = x\}\gamma'}, where
       @tx{y_i \not\in X} and @tx{x \in X}, then @tx{\alpha}
       excludes @tx{\gamma} iff @tx{\alpha} excludes
       @tx{\{y_i = y_j|1 \leq i, j \leq n\} \cup \gamma'}.}

@proof{It must be the case that @tx{\alpha} excludes at least one
      equation @tx{x_i = x_j} for some @tx{i,j}.
      But if @ct[(unify ((αx_i = αx_j)) (∧))] @tx{=} @ct[⊥], then 
      @tx{\alpha} excludes @tx{\{x_1 = x\}...\{x_n = x\}},
      because there is no value for @ct[αx_] that can satisfy
      the equations. Thus if @tx{\alpha} excludes
      @tx{\{y_i = y_j|1 \leq i, j \leq n\} \cup \gamma'}, it
      excludes @tx{\gamma}.
      If @ct[(unify ((αx_i = αx_) (αx_j = αx_)) (∧))] @tx{=} @ct[⊥],
      and @tx{\alpha x = x}, since the right-hand sides will be
      identical, it must be the case that
      @ct[(unify ((αx_i = αx_j)) (∧))] @tx{=} @ct[⊥],
      and @tx{\alpha} excludes @tx{x_i = x_j}.}

The above lemma refers to the step in @ct[param-elim] that makes
use of @ct[elim-x]. The above two lemmas show that @ct[param-elim]
preserves the satisfiability criteria for a disequational
constraint @ct[δ].

@lemma{@ct[param-elim] terminates.}

@proof{Every recursive call decreases the number of equations that
       have a left or right hand side that is a single parameter.
       (Parameters are the list of variables in @ct[param-elim]'s
       second argument.)}

The termination of all other functions in the constraint solver
is obvious.

@lemma{Given a disequation @ct[δ], @ct[(disunify δ)] terminates
       with @ct[⊥] if @ct[δ] is unsatisfiable or @ct[⊤] if
       @ct[δ] is always satisfiable; otherwise it terminates
       with a disequation in canonical form that is
       equivalent (satisfiable by the same substitutions) to @ct[δ].}
 
@proof{Follows directly Lemmas 4, 5, 6, and 7.} 

The correctness of the constraint solver follows directly from the
correctness of @ct[unify], @ct[disunify], and @ct[check]:

@theorem{For any @ct[e] and @ct[C] in canonical form, @ct[solve] terminates
         with @ct[⊥] if there is no unifier of @ct[e] and the equations in
         @ct[C] that preserves the consistency of @ct[C].
         Otherwise, it terminates with @ct[C_Ω] in canonical form,
         such that the equations in @ct[C_Ω] are an mgu of @ct[e] and the
         equations in @ct[C], and @ct[C_Ω] is consistent.}

@theorem{For any @ct[δ] and @ct[C] in canonical form, @ct[dissolve] terminates
         with @ct[⊥] if @ct[δ] and @ct[C] are inconsistent.
         Otherwise, it terminates with @ct[C_Ω] in canonical form,
         such that the disequations in @ct[C_Ω] are satisfiable iff the
         union of those in @ct[C] and @ct[δ] is,
         and @ct[C_Ω] is consistent.}
