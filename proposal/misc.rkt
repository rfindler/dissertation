#lang racket

(require slideshow
         "common.rkt")

 (parameterize ([current-font-size (inexact->exact (floor (* (current-font-size) 0.75)))])
(slide 
 (s-frame (t "Directly related")
          (item "Making Random Judgments")
          (subitem "[Fetscher, Claessen, Palka, Hughes, Findler, ESOP 15]")
          (item "fFeat: Fair Functional Enumerations of Algebraic Types")
          (subitem "[New, Fetscher, McCarthy, Findler, ICFP 15]"))
 'next
 (s-frame (t "Indirectly related")
          (item "A Dependtly Type Monad ....")
          (subitem "[McCarthy, Fetscher, New, Findler, in submission")
          (item "Pop-PL")
          (subitem "[Florence, ..., Belknap], OOPSLA 15"))
 'next 
 (s-frame (t "Not really related")
          (item "Seeing the Futures: Profiling Shared-Memory Parallel Racket")
          (subitem "[Swaine, Fetscher, St-Amour, Findler, Flatt, FHPC 12]"))))
