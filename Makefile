CONTAINER = ./container.sif
VERSIONS  = versions.tab

ADA_CIF_PARSER ?=
ADA_RESULTS_DIR ?= $(CURDIR)/results/ada-cif-parser

.PHONY: all build container test tests compare-ada

all: tests $(VERSIONS)

build container: $(CONTAINER)

test tests: $(CONTAINER)
	LC_ALL=C $(CONTAINER) $(MAKE) -C 1.1
	LC_ALL=C $(CONTAINER) $(MAKE) -C 2.0

$(CONTAINER): $(CONTAINER:%.sif=%.def)
	apptainer build $@ $<

$(VERSIONS): $(CONTAINER)
	LC_ALL=C $(CONTAINER) scripts/versions --no-debian-version > $@

# Compare one locally built Ada parser with the checked-in reference results.
# This deliberately does not require the all-parser Apptainer image.
compare-ada:
	@test -n "$(ADA_CIF_PARSER)" || { \
		echo "set ADA_CIF_PARSER to the parser executable" >&2; \
		exit 1; \
	}
	scripts/compare-reference \
		drivers/ada-cif-parser "$(ADA_CIF_PARSER)" "$(ADA_RESULTS_DIR)"

.PHONY: clean

clean:
	$(MAKE) -C 1.1 distclean
	$(MAKE) -C 2.0 distclean
