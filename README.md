# Code and data for "Temporally variable stream width distributions in a headwater catchment"

This repository contains code and data to replicate results from Barefoot et al. (in prep)

## Install

You will have to have a working `R` installation to use these routines. To get `R` -- which is free -- download and install from [the R website](https://www.r-project.org/)

To install, download this repository and put it somewhere in your computer. Then open a terminal with this folder as the working directory and type:
```bash
./analysis/stony_creek_analysis.r
```

This command will replicate all the analysis presented in the paper, and open draft versions of the main figures.

## File Structure

If the installation is correct, you should see the following file structure:

```
.
├── LICENSE
├── README.md
├── analysis
│   ├── b_calcs.r
│   ├── compile_data_hl.r
│   ├── dist_basics.r
│   ├── effect_analysis.r
│   ├── effect_analysis_hl.r
│   ├── error_analysis.r
│   ├── flowing_ratio.r
│   ├── fractal_dim.r
│   ├── functions
│   │   ├── bootstrap.r
│   │   ├── box_counting.r
│   │   ├── boxaxes.r
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
│   ├── README.txt
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
│   ├── stony_creek_io.r
│   └── stony_creek_process.r
└── figures
    ├── outputs
    │   ├── figure_1.pdf
    │   ├── figure_2.pdf
    │   ├── figure_3.pdf
    │   ├── figure_4.pdf
    │   ├── figure_5.pdf
    │   └── figure_6.pdf
    └── scripts
        ├── figure_1.ai
        ├── figure_2.ai
        ├── figure_3.r
        ├── figure_4.r
        ├── figure_5.r
        └── figure_6.r
```
