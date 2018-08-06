# Code and data for _"Temporally variable stream width and area distributions in a headwater catchment"_

This repository contains code and data to replicate results from Code and data for **"Temporally variable stream width and area distributions in a headwater catchment"** by Barefoot et al. (_in prep_)

## Install

You will have to have a working `R` installation to use these routines. To get `R` -- which is free -- download and install from [the R website](https://www.r-project.org/)

This repository only currently runs on UNIX-like OS machines. Sorry Windows people.

To install, download this repository and put it somewhere in your computer. Then open a terminal with this folder as the working directory and type:
```bash
make
```

This command will replicate all the analysis presented in the paper, and open draft versions of the main figures.

To delete all products of the analysis, simply enter `make clean` in the terminal, and all the draft figures will be deleted.

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
│   │   │   ├── stony_segment_pts.dbf
│   │   │   └── stony_segment_pts_test.xlsx
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
