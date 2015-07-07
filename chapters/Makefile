 
TEXFLAGS = --prefix prefix.tex ++extra nuthesis.cls ++extra tocstyle.sty
DOCNAME=main

all: main.scrbl
	scribble --pdf $(TEXFLAGS) $(DOCNAME).scrbl

main.scrbl: common.scrbl
	raco make $(DOCNAME).scrbl

common.scrbl:

latex-only: main.scrbl
	rm -rf tex-business/
	scribble --latex $(TEXFLAGS) --dest ./tex-business $(DOCNAME).scrbl
