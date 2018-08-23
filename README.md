# Code and data for _"Temporally Variable Stream Width and Surface Area Distributions in a Headwater Catchment"_

[![DOI](https://zenodo.org/badge/141500164.svg)](https://zenodo.org/badge/latestdoi/141500164)

This repository contains code and data to replicate results from Code and data for **"Temporally Variable Stream Width and Surface Area Distributions in a Headwater Catchment"** by Barefoot et al. (_submitted_)

## Install

You will have to have a working `R` installation to use these routines. To get `R` -- which is free -- download and install from [the R website](https://www.r-project.org/)

When you install R, there are a number of choices you can make about where libraries are stored. If you choose the defaults, this software should work out of the box. In the event, however, that something is screwy with your installation, all needed packages and dependencies will be downloaded into a `pkgs` directory, which may take some time. Once this process is complete, recompleting the analysis / adding to the code should be much faster. 

This repository only currently runs on UNIX-like machines (OSX and Linux). Sorry Windows people.

To install, download this repository and put it somewhere in your computer. Then open a terminal with this folder as the working directory and type:
```bash
make
```

This command will replicate all the analysis presented in the paper, and open draft versions of the main figures.

To delete all products of the analysis, simply enter `make clean` in the terminal, and all the draft figures will be deleted.

## Bugs and problems

If you encounter an issue installing or running the analysis, or wish to contribute to this software, [please open an issue](https://github.com/ericbarefoot/Barefoot_WRR_2019/issues) describing your problem with a [reproducible example, or `reprex`](https://reprex.tidyverse.org/). reprexes help us help you with your issue, and we'll do our best to fix the bug. If you wish to suggest a feature or similar, please also submit an issue, and the authors will be happy to discuss the feature.

## Data Availability

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1342865.svg)](https://doi.org/10.5281/zenodo.1342865)

Data is also available as .zip files with the DOI listed above. Each zip file corresponds to one subdirectory of the `raw_data` directory (see file tree below).

You do not need to additionally go fetch these data, as they are contained in this repository too.



## File Structure

If the installation is correct, you should see the following file structure:

```
Barefoot_WRR_2019
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
│   │   ├── field_data.zip
│   │   ├── gis_data
│   │   │   ├── stony_segment_pts.dbf
│   │   │   └── stony_segment_pts_test.xlsx
│   │   ├── gis_data.zip
│   │   ├── hydro_data
│   │   │   ├── bolin_2012_2017.csv
│   │   │   ├── discharge_data.csv
│   │   │   └── drain_dates.csv
│   │   └── hydro_data.zip
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
├── library_install.r
├── LICENSE
├── makefile
├── pkgs
└── README.md

12 directories, 54 files
```
