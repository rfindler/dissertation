#lang scribble/base

@(require scribble/core
          "../util.rkt"
          "../../model/typesetting.rkt")

@title{Proof of Gremlin Threat}

@theorem{For any @ct[e] and @ct[C] in canonical form, @ct[solve] terminates
         with @ct[⊥] if there is no unifier of @ct[e] and the equations in
         @ct[C]. Otherwise, it terminates with @ct[C_Ω] in canonical form,
         such that the equations in @ct[C_Ω] are an mgu of @ct[e] and the
         equations in @ct[C], and @ct[C_Ω] is consistent.}

@proof{Obvious.}