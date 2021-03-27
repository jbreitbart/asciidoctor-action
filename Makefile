ACSCSS = ./stylesheet-factory/stylesheets/foundation.css
ACSSRC = ./stylesheet-factory/sass/settings/_foundation.scss ./stylesheet-factory/sass/foundation.scss
NOW = $(shell date +"%Y-%m-%d")
OPT = --trace -r asciidoctor-bibtex -a stylesheet=$(ACSCSS) -a revdate=$(NOW)

PDFOPT = -a pdf-stylesdir=./pdf-resources -a pdf-style=acs -a pdf-fontsdir=./pdf-resources/fonts
PDFSRC = ./pdf-resources/acs-theme.yml

#ADDCPL = -r ./EmbedCompilerPreprocessor.rb
#EXTN   = ./EmbedCompilerPreprocessor.rb
#BLKEXT = ./CompilerBlock.rb
#CPLBLK = -r $(BLKEXT)

RBYCSS = ./stylesheet-factory/stylesheets/rubygems.css
RBYSRC = ./stylesheet-factory/sass/settings/_rubygems.scss ./stylesheet-factory/sass/rubygems.scss
RBY = -a stylesheet=$(RBYCSS)
ASRC = index.adoc a1.adoc a2.adoc

default: index.html

rby: $(ASRC) $(RBYCSS)
	asciidoctor $(RBY) index.adoc

index.html: $(ASRC) $(ACSCSS) $(BLKEXT)
	asciidoctor -b html5 $(OPT) $(CPLBLK) index.adoc

index.pdf: $(ASRC) $(PDFSRC)
	asciidoctor-pdf $(PDFOPT) index.adoc

%.html: %.adoc header.adoc $(ACSCSS)
	asciidoctor $(OPT) $<

%.pdf: %.adoc header.adoc $(PDFSRC)
	asciidoctor-pdf $(PDFOPT) $<

$(RBYCSS): $(RBYSRC)
	./stylesheet-factory/build-stylesheet.sh

$(ACSCSS): $(ACSSRC)
	./stylesheet-factory/build-stylesheet.sh

all: index.html

pdf: index.pdf

%.pdf: %.adoc
	asciidoctor-pdf $<

tar:
	tar czvf osbyexample.tar.gz index.html ace images

clean:
	rm -rf *.html
