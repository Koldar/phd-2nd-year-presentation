
ifeq ($(OUTPUT_DIR),)
OUTPUT_DIR := build
endif
ifeq ($(MAIN),)
MAIN := main
endif
ifeq ($(LATEX_CC),)
LATEX_CC := pdflatex
endif
ifeq ($(LATEX_FLAGS),)
LATEX_FLAGS := -synctex=1 -halt-on-error -file-line-error
endif
ifeq ($(BIBTEX_CC),)
BIBTEX_CC := bibtex
endif
ifeq ($(BIBTEX_FLAGS),)
BIBTEX_FLAGS :=
endif

.PHONY: all clean

all: 
	mkdir -pv $(OUTPUT_DIR)
	$(LATEX_CC) $(LATEX_FLAGS) -output-directory=$(OUTPUT_DIR) $(MAIN).tex
	#if we have cite something in the document, call bibtex. Otherwise do nothing
	$(eval X=`cat $(OUTPUT_DIR)/$(MAIN).aux | grep 'citation' | wc -l`)
	@echo $(X)
	if test $(X) != 0 ;\
	then \
		$(BIBTEX_CC) $(BIBTEX_FLAGS) $(OUTPUT_DIR)/$(MAIN).aux ;\
		$(LATEX_CC) $(LATEX_FLAGS) -output-directory=$(OUTPUT_DIR) $(MAIN).tex ;\
		$(LATEX_CC) $(LATEX_FLAGS) -output-directory=$(OUTPUT_DIR) $(MAIN).tex ;\
	fi
	@echo "Done compiling."

clean:
	rm -rfv $(OUTPUT_DIR)
	@echo "Done cleaning."
