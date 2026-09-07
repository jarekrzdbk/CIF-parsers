INP_DIR = tests
OUT_DIR = outputs

TESTS = $(shell find $(INP_DIR)/ -name .svn -prune \
            -o -name \*.result.canon -prune \
            -o -name runtests -prune \
            -o -name \*.tsv -prune \
            -o -name \*.md -prune \
            -o -type f -print \
            -o -type l -print)

OUTPUTS = $(sort $(TESTS:$(INP_DIR)/%=$(OUT_DIR)/%.out))

TABLE_TSV  = $(OUT_DIR)/table.tsv
TABLE_TEX  = $(OUT_DIR)/table.tex
TABLE_HTML = $(OUT_DIR)/table.html
TABLE_MD   = $(OUT_DIR)/table.md

BENCHMARK_OUT = $(OUT_DIR)/benchmark.out

PARSER ?=

.PHONY: all table tables benchmark update-parser cleanAll distclean

all: tables

table tables: $(TABLE_HTML) $(TABLE_MD) $(TABLE_TEX)

benchmark: $(BENCHMARK_OUT)

${OUT_DIR}/%.out: ${INP_DIR}/%
	> $@ # Make sure we start with an empty file
	for PARSER in $$(ls -1 drivers/* | sort); \
    do \
        echo $$(basename $${PARSER}) $$($${PARSER} $<) >> $@; \
    done

# Refresh one parser in the checked-in results without rerunning every parser.
update-parser:
	@test -n "$(PARSER)" || { echo "set PARSER to a driver name" >&2; exit 1; }
	@test -x "drivers/$(PARSER)" || { echo "unknown parser driver: $(PARSER)" >&2; exit 1; }
	@set -e; \
	for INPUT in $(TESTS); \
	do \
		OUTPUT="$(OUT_DIR)/$${INPUT#$(INP_DIR)/}.out"; \
		TEMP_OUTPUT="$${OUTPUT}.tmp"; \
		mkdir -p "$$(dirname "$${OUTPUT}")"; \
		{ \
			if test -f "$${OUTPUT}"; then \
				awk -v parser="$(PARSER)" '$$1 != parser' "$${OUTPUT}"; \
			fi; \
			RESULT="$$(drivers/$(PARSER) "$${INPUT}")"; \
			if test -n "$${RESULT}"; then \
				printf '%s %s\n' "$(PARSER)" "$${RESULT}"; \
			else \
				printf '%s\n' "$(PARSER)"; \
			fi; \
		} | LC_ALL=C sort > "$${TEMP_OUTPUT}"; \
		mv "$${TEMP_OUTPUT}" "$${OUTPUT}"; \
	done
	rm -f $(TABLE_HTML) $(TABLE_MD) $(TABLE_TEX) $(TABLE_TSV)
	$(MAKE) --no-print-directory tables
	@echo "$(PARSER): updated $(words $(TESTS)) cases in $(OUT_DIR)"

$(BENCHMARK_OUT):
	../scripts/benchmark > $@

cleanAll distclean:
	rm -f ${OUTPUTS} ${TABLE_TEX} ${TABLE_HTML} $(TABLE_MD) $(TABLE_TSV)

$(TABLE_TSV): $(OUTPUTS)
	./scripts/tests-to-tsv $+ > $@

${TABLE_TEX}: ${OUTPUTS}
	for OUTPUT in $+; \
	do \
		( \
			echo -n $${OUTPUT} \
			| sed 's/outputs\///; s/_/\\_/g; s/\.out$$/ \& /'; \
			grep -P "^$$(basename $${OUTPUT} .out)\t" \
				tests/$$(echo $${OUTPUT} | cut -d / -f 2)/descriptions.tsv \
				2>/dev/null \
			| cut -f 2 | sed 's/1//; s/0/\$$\\\\times\$$/' | xargs echo -n; \
			perl -lpe 's/WARNING/\//g; s/ERROR/\$$\\times\$$/g;' $${OUTPUT} | \
			perl -ne 'my @a = split /\s/; print " & ", $$a[1]'; \
			echo \\\\\\\\ \
		) \
	done > $@

${TABLE_HTML}: ${OUTPUTS}
	echo '<html><head></head><body><table border="1"><tr><td></td><td>' > $@
	perl -e '$$, = "</td><td>"; print @ARGV' $$(ls -1 drivers/* | xargs -n1 basename | sort) >> $@
	echo '</td></tr>' >> $@
	for OUTPUT in $+; \
	do \
		( \
			echo '<tr><td>' $${OUTPUT}; \
			perl -lpe 's/([WE])\w+/$$1/g; ' $${OUTPUT} | \
			perl -ne 'my @a = split /\s/; print "</td><td>", $$a[1]'; \
			echo '</td></tr>' \
		) \
	done >> $@
	echo '</table></html>' >> $@

$(TABLE_MD): $(TABLE_TSV)
	./scripts/tsv-to-md $< > $@
