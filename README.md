# Code and data for _"Temporally Variable Stream Width and Surface Area Distributions in a Headwater Catchment"_

[![DOI](https://zenodo.org/badge/141500164.svg)](https://zenodo.org/badge/latestdoi/141500164)

This repository contains code and data to replicate results from Code and data for **"Temporally Variable Stream Width and Surface Area Distributions in a Headwater Catchment"** by Barefoot et al. (_submitted_)

## Install

You will have to have a working `R` installation to use these routines. To get `R` -- which is free -- download and install from [the R website](https://www.r-project.org/)

This repository only currently runs on UNIX-like OS machines. Sorry Windows people.

To install, download this repository and put it somewhere in your computer. Then open a terminal with this folder as the working directory and type:
```bash
make
```

This command will replicate all the analysis presented in the paper, and open draft versions of the main figures.

To delete all products of the analysis, simply enter `make clean` in the terminal, and all the draft figures will be deleted.

## Data Availability

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1342865.svg)](https://doi.org/10.5281/zenodo.1342865)

Data is also available as .zip files with the DOI listed above. Each zip file corresponds to one subdirectory of the `raw_data` directory (see file tree below).

You do not need to additionally go fetch these data, as they are contained in this repository too. 

## File Structure

If the installation is correct, you should see the following file structure:

```
.
├── analysis
│   ├── b_calcs.r
│   ├── compile_data_hl.r
│   ├── dist_basics.r
│   ├── effect_analysis_hl.r
│   ├── effect_analysis.r
│   ├── error_analysis.r
│   ├── flowing_ratio.r
│   ├── fractal_dim.r
│   ├── functions
│   │   ├── bootstrap.r
│   │   ├── boxaxes.r
│   │   ├── box_counting.r
│   │   ├── disch_conv.r
│   │   ├── find_mode.r
│   │   ├── graph_padding.r
│   │   ├── nearest_xy_points.r
│   │   ├── percentiles.r
│   │   ├── segment_lengths.r
│   │   └── spread.r
│   ├── high_low_analysis.r
│   ├── hydro_stats.r
│   ├── ks_stats.r
│   ├── percentile_calc.r
│   └── stony_creek_analysis.r
├── data
│   ├── derived_data
│   ├── raw_data
│   │   ├── field_data
│   │   │   ├── stony_creek_error_estimation.csv
│   │   │   ├── stony_creek_event_data.csv
│   │   │   ├── stony_creek_field_data.csv
│   │   │   └── stony_creek_strm_order.csv
│   │   ├── gis_data
│   │   │   └── stony_segment_pts.dbf
│   │   └── hydro_data
│   │       ├── bolin_2012_2017.csv
│   │       ├── discharge_data.csv
│   │       └── drain_dates.csv
│   ├── README.txt
│   ├── stony_creek_io.r
│   └── stony_creek_process.r
├── figures
│   ├── outputs
│   │   ├── figure_1.pdf
│   │   ├── figure_2.pdf
│   │   ├── figure_3.pdf
│   │   ├── figure_4.pdf
│   │   ├── figure_5.pdf
│   │   └── figure_6.pdf
│   └── scripts
│       ├── figure_1.ai
│       ├── figure_2.ai
│       ├── figure_3.r
│       ├── figure_4.r
│       ├── figure_5.r
│       └── figure_6.r
├── LICENSE
├── makefile
└── README.md

```
