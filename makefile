all:
	./library_install.r
	./analysis/stony_creek_analysis.r

clean:
	rm -rf data/derived_data/*
	rm -rf figures/outputs/*_draft*

empty_pkgs:
	rm -rf pkgs/*

.PHONY: all clean empty_pkgs
