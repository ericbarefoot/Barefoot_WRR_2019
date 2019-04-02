#!/usr/bin/env Rscript

# Master file for stony creek data analysis
# Eric Barefoot
# July 2018

# Call this script from the command line while in the top directory as follows:
#
# OSX/Linux: "./analysis/stony_creek_analysis.r"

lib = file.path(getwd(), 'pkgs')
.libPaths(c(lib, .libPaths()))

# message(.libPaths())
# stop()


library(here)
########################################################

# Data In/Out

# if you just want to start some analysis and don't need to reprocess the data, use this:

mainDataFile = here('data', 'derived_data','tab_data.rda')
summaryData = here('data', 'derived_data','high_low_table.rda')

if(file.exists(mainDataFile) && file.exists(summaryData)) {
	load(mainDataFile)
	load(summaryData)
} else {
	source(here('data', 'stony_creek_process.r'))
	load(mainDataFile)
	source(here('analysis', 'compile_data_hl.r'))
	load(summaryData)
}

# # if you have new data, use this one:
#
# 	source(here('data','stony_creek_process.r'))
#
# # this is not as easy as the load option, but you can also read in from csv with this script:
#
# 	source(here('data','stony_creek_io.r'))
#
# # raw data outputs (in list called 'tab') -

	# fdata - width surveys through time. Has unique flag ID codes (flag_id), upstream distance from the bottom of the watershed in meters (upstream_dist), channel order (order_chan), lat/lon coordinates in decimal degrees for each flag (easting, northing), elevation (m), stream order for each event (ord00, ord01, ...), and scaled width in cm at each flag for different surveys (w01,w02,w03, ...).

	# hydro - 5 min stage data for WSA gauge (date, stage), with associated discharge in L/s (Q), runoff normalized to drainage area (norm_R), and total runoff in mm/hr (R_mmhr)

	# event_means - mean discharge in L/s (mean_Q) and each survey date and event ID

	# surveyQ - all the discharge and time data for each survey date and a label variable.

	# orders - all the segments respective Strahler ordering, in a hydrologic sense, as opposed to the geomorphologic sense, which is captured in fdata in the column order_chan in fdata

#######################################################

# Figure Generation

# generate data-driven graphics for manuscript. Ignore Figures 1 and 2, which were made by hand or in mapping software.

## maps of the active drainage network

source(here('figures', 'scripts','figure_3.r'))

## maps of width during each event

source(here('figures', 'scripts','figure_4.r'))

## comparing distributions with inset hydrograph

source(here('figures', 'scripts','figure_5.r'))

## trends in area and mu with runoff

source(here('figures', 'scripts', 'figure_6.r'))

## division of width into lateral and longitudinal expansion.

source(here('figures', 'scripts', 'figure_7.r'))

## trends in mu with lateral and longitudinal expansion.

source(here('figures', 'scripts', 'figure_8.r'))

########################################################

# Table Generation - prints table to console

# Table 1 - saves table_1.csv in derived_data

source(here('analysis', 'table_1.r'))

# Table 2 - saves table_1.csv in derived_data

source(here('analysis', 'table_1.r'))

########################################################

# Data Analysis Scripts

## gives the ratio of flowing to non-flowing points in the network for each survey

# source(here('analysis', 'flowing_ratio.r'))

## models and calculates some basic information about the distributions of widths

# source(here('analysis', 'dist_basics.r'))

## calculates the percentile of flow for each survey

# source(here('analysis', 'percentile_calc.r'))

## calculates the annual hydrological statistics

# source(here('analysis', 'hydro_stats.r'))

## calculates relative area effects of widening and expansion

# source(here('analysis', 'effect_analysis.r'))

## calculating b and the corresponding correlation coefficient everywhere. Must run this once before generating the map below.

# source(here('analysis', 'b_calcs.r'))

## get the hltab data

# source(here('analysis', 'compile_data_hl.r'))

#######################################################
