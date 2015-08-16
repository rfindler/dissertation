 
TEXFLAGS= --prefix prefix.tex ++style racket-ss.sty ++extra nuthesis.cls ++extra tocstyle.sty \
	++extra semantics/graph.pdf ++extra redex-intro/sumto.pdf
DOCNAME=main

all: main.scrbl
	scribble --pdf $(TEXFLAGS) $(DOCNAME).scrbl

main.scrbl: common.scrbl
	raco make -v $(DOCNAME).scrbl

common.scrbl:

latex-only: main.scrbl
	rm -rf tex-business/
	scribble --latex $(TEXFLAGS) --dest ./tex-business $(DOCNAME).scrbl
