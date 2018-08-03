#!/usr/bin/env Rscript

# Master file for stony creek data analysis
# Eric Barefoot
# July 2018

# Call this script from the command line while in the top directory as follows:
#
# OSX/Linux: "./analysis/stony_creek_analysis.r"

########################################################
# install and load  necessary libraries

packages = c("lubridate", "dplyr", "here")

ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg)) 
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}

ipak(packages)

#library(here)

########################################################

# Data In/Out

# if you just want to start some analysis and don't need to reprocess the data, use this one:

mainDataFile = here('data', 'derived_data','tab_data.rda')
summaryData = here('data', 'derived_data','high_low_table.rda')

if(file.exists(mainDataFile) & file.exists(summaryData)) {
	load(here('data', 'derived_data', 'tab_data.rda'))
	load(here('data', 'derived_data','high_low_table.rda'))
} else {
	source(here('data', 'stony_creek_process.r'))
	load(here('data', 'derived_data', 'tab_data.rda'))
	source(here('analysis', 'compile_data_hl.r'))
	load(here('data', 'derived_data','high_low_table.rda'))
}

# # if you have new data, use this one:
#
# 	source(here('data','stony_creek_process.r'))
#
# # this is not as easy as the load option, but you can also read in from csv with this script:
#
# 	source(here('data','stony_creek_io.r'))
#
# # data outputs (in list called 'tab') -

	# fdata - width surveys through time. Has unique flag ID codes (flag_id), upstream distance from the bottom of the watershed in meters (upstream_dist), channel order (order_chan), lat/lon coordinates in decimal degrees for each flag (easting, northing), elevation (m), stream order for each event (ord00, ord01, ...), and scaled width in cm at each flag for different surveys (w01,w02,w03, ...).

	# hydro - 5 min stage data for WSA gauge (date, stage), with associated discharge in L/s (Q), runoff normalized to drainage area (norm_R), and total runoff in mm/hr (R_mmhr)

	# event_means - mean discharge in L/s (mean_Q) and each survey date and event ID

	# surveyQ - all the discharge and time data for each survey date and a label variable.

	# orders - all the segments respective Strahler ordering, in a hydrologic sense, as opposed to the geomorphologic sense, which is captured in fdata in the column order_chan in fdata

########################################################

# Data Analysis

## gives the ratio of flowing to non-flowing points in the network for each survey

source(here('analysis', 'flowing_ratio.r'))

## models and calculates some basic information about the distributions of widths

source(here('analysis', 'dist_basics.r'))

## calculates the percentile of flow for each survey

source(here('analysis', 'percentile_calc.r'))

## calculates the annual hydrological statistics

source(here('analysis', 'hydro_stats.r'))

## calculates relative area effects of widening and expansion

source(here('analysis', 'effect_analysis.r'))

## calculating b and the corresponding correlation coefficient everywhere. Must run this once before generating the map below.

source(here('analysis', 'b_calcs.r'))

## get the hltab data

source(here('analysis', 'compile_data_hl.r'))

#######################################################

# Figure Generation

#  figures used to have this little bit after them to open up the figure immediately, but I don't know why anymore.

## main analytical figure

source(here('figures', 'scripts', 'figure_6.r'))

## comparing distributions with inset hydrograph

source(here('figures', 'scripts','figure_5.r'))

## maps of width during each event

source(here('figures', 'scripts','figure_4.r'))

## maps of the active drainage network

source(here('figures', 'scripts','figure_3.r'))

#######################################################

# Scripts that I don't use anymore.

## calculates the approximate fractal dimension of the network based on a box-counting algorithm

# source(here('analysis', 'fractal_dim.r'))

# ## comparing distributions
#
# source(here('figures', 'scripts','stacked_dists.r'))
#
# ## plots hydrograph for system for whole record that we have, both log and linear scale. also includes points marking survey dates
#
# source(here('figures', 'scripts', 'hydrograph_basic.r'))
#
# ## maps of r^2 and b for w = aQb relationship
#
# source(here('figures', 'scripts','r_n_b_map.r'))
#
# ## comparing distributions simple for ppt
#
# source(here('figures', 'scripts','stacked_simple.r'))
#
# ## distributions broken down by order
#
# source(here('figures', 'scripts','dist_by_order.r'))
#
# ## comparing modal width to discharge
#
# source(here('figures', 'scripts','width_Q.r'))
#
# ## comparing the modal width to the ratio of flowing to non-flowing segments
#
# ### oops
#
# source(here('figures', 'scripts','width_flow_rat.r'))
#
# ## comparing modal width to total surface area
#
# source(here('figures', 'scripts', 'width_area.r'))
#
# ## comparing modal width frequency to discharge
#
# source(here('figures', 'scripts','peak_Q.r'))
#
# ## comparing discharge to total surface area
#
# source(here('figures', 'scripts', 'area_Q.r'))
#
# ## Comparing modal width methods with each other and finally to their respective peak frequencies.
#
# source(here('figures', 'scripts', 'peaks_and_modes.r'))

## forward modeling function to generate a stochastically perturbed hortonian network to compare to our distributions

#wd = paste0(pd, 'analysis/dist_stochastic_model/')
#source(paste0(wd, 'hort_model.r'))

## script for exploring the above parameter space.

# wd = paste0(pd, 'analysis/dist_stochastic_model/')
# source(paste0(wd, 'hort_explore.r'))

## multipanel figure with the network map and the

#wd = paste0(pd, 'figures/scripts/')
#source(paste0(wd,'network_figure.r'))
#i = 2
#cmd = paste('open', fig_names[i]); system(cmd)


## figures generated from varying stochastic model.

#wd = paste0(pd, 'figures/scripts/')
#source(paste0(wd, 'modeled_dists.r'))
#cmd = paste('open', figout); system(cmd)
