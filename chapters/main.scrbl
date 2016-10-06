#lang scribble/base 

@(require racket/port
          scribble/core
          "common.rkt"
          "util.rkt")

@(element "title" '("Automated Testing for Operational Semantics"))

@(element "maketitle" '())

@(define abstract-text
   (call-with-input-file "../abstract.txt"
     (λ (in) (read-line in) ;; drop title
       (port->string in))))

@(abstract abstract-text)
@acknowledgements{It was quite a stroke of luck for me to walk into Robby Findler's office
                  one day five years ago. Undoubtedly, without his encouragement I would not
                  have begun this process, and without his advice and guidance I certainly would
                  not have finished. 

                  Throughout my time at Northwestern, it has been a pleasure to work alongside many
                  many knowledgeable and enjoyable people. Casey Klein was very
                  helpful in introducing me to Redex, and providing the initial prototype that led to
                  this dissertation. James Swaine, Spencer Florence, Vincent St-Amour, Dan Feltey,
                  and Jesse Tov have all been great colleagues from whom I have learned a lot.

                  Finally, thanks to my family for their support and patience. My parents, for
                  believing in me in spite of it all throughout the years. Most importantly,
                  to my wife Maureen and son Nevin, for being the ones I believe in.
                  
                  Thanks to the National Science Foundation for supporting this research.}

@table-of-contents[]

@include-section{introduction/introduction.scrbl}
@include-section{redex-intro/redex.scrbl}
@include-section{grammar/grammar.scrbl}
@include-section{derivation/deriv.scrbl}
@include-section{semantics/semantics.scrbl}
@include-section{benchmark/benchmark.scrbl}
@include-section{evaluation/evaluation.scrbl}
@include-section{related-work/related-work.scrbl}
@include-section{conclusion/conclusion.scrbl}

@generate-bibliography[]

@include-section{appendix/appendix.scrbl}
@include-section{appendix/proof.scrbl}
@include-section{appendix/bugs.scrbl}

