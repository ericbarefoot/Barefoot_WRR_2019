# repeating many aspects of the stony creek analysis without survey #1 and separating things into high and low flows.
# Eric Barefoot
# July 2018

########################################################

# Data In/Out

# if you just want to start some analysis and don't need to reprocess the data, use this one:

wd = getwd()

pd = file.path(wd, '..', '..')

ad = file.path(pd, 'analysis')

dd = file.path(pd, 'data')

dddo = file.path(pd, 'data', 'derived_data', 'digested', 'outputs')

fd = file.path(ad, 'functions')

hld = file.path(ad, 'high_low')

load(file.path(dddo, 'tab_data.rda'))
load(file.path(dddo, 'high_low_table.rda'))

# data outputs (in list called 'tab') -

	# fdata - width surveys through time. Has unique flag ID codes (flag_id), upstream distance from the bottom of the watershed in meters (upstream_dist), channel order (order_chan), lat/lon coordinates in decimal degrees for each flag (easting, northing), elevation (m), stream order for each event (ord00, ord01, ...), and scaled width in cm at each flag for different surveys (w01,w02,w03, ...).

	# hydro - 5 min stage data for WSA gauge (date, stage), with associated discharge in L/s (Q), runoff normalized to drainage area (norm_R), and total runoff in mm/hr (R_mmhr)

	# event_means - mean discharge in L/s (mean_Q) and each survey date and event ID

	# surveyQ - all the discharge and time data for each survey date and a label variable.

	# orders - all the segments respective Strahler ordering, in a hydrologic sense, as opposed to the geomorphologic sense, which is captured in fdata in the column order_chan in fdata


########################################################

# Load functions

source(file.path(fd, 'percentiles.r'))

########################################################

# Data Analysis

## gives the ratio of flowing to non-flowing points in the network for each survey

source(file.path(ad, 'flowing_ratio.r'))

## models and calculates some basic information about the distributions of widths

source(file.path(ad, 'dist_basics.r'))

## Calculating percentiles of flow

source(file.path(ad, 'percentile_calc.r'))

## excludes surv1 from the analysis and compiles a bunch of stats from each survey into a single table. tags 'high' and 'low' flows.

source(file.path(hld, 'compile_data_hl.r'))

## calculates relative area effects of widening and expansion in light of

source(file.path(hld, 'effect_analysis_hl.r'))

#######################################################

# Figure Generation

#  figure script directory
fsd = file.path(pd, 'figures', 'scripts')

source(file.path(fsd, 'hydrograph_basic.r'))
