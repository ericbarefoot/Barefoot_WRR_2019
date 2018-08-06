all:
	./analysis/stony_creek_analysis.r

clean:
	rm data/derived_data/*
	rm figures/outputs/*_draft.pdf

.PHONY: all clean
