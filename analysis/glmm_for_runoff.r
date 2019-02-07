#

## re-analysis using glmm for interpreting role of runoff on stream width.
## Eric Barefoot
## Feb 2019

## Goals:
## 1: Quantify scaling of width distribution parameters with runoff.
## 2: Quantify sources of additional area with added runoff.

# import packages

library(MASS)
library(here)
library(tidyverse)
library(colorout)
library(lme4)

# read in data

mainDataFile = here('data', 'derived_data','tab_data.rda')
summaryData = here('data', 'derived_data','high_low_table.rda')
differencesDataFile = here('data', 'derived_data', 'area_differences.rda')

if(file.exists(mainDataFile) & file.exists(summaryData) & file.exists(differencesDataFile)) {
	load(mainDataFile)
	load(summaryData)
	load(differencesDataFile)
} else {
	source(here('data', 'stony_creek_process.r'))
	load(mainDataFile)
	source(here('analysis', 'compile_data_hl.r'))
	load(summaryData)
	source(here('analysis', 'effect_analysis.r'))
}

# make into tibbles from data.frames

fieldData = as_tibble(tab$fdata)
eventData = as_tibble(hltab)
diffData = as_tibble(diffData) %>% mutate(combo = as.factor(combo))

# remove unneeded variables, change some names

fieldData = fieldData %>% select(-notes) %>% rename(channel_order = 'order_chan')
eventData = eventData %>%
select(-c(lgmod, kdmod, modes, muuus, siggs, inter, peaks, kdmod, lgmod, kdpek, lgpek, kstat, kspvl, hltag, seeps)) %>%
rename(survey = 'names') %>%
mutate(survey = substr(survey, 2, 3))

# gather up variables

width_data = fieldData %>%
select(flag_id, starts_with('w')) %>%
gather('survey', 'width', -flag_id) %>%
mutate(survey = substr(survey, 2, 3))

order_data = fieldData %>%
select(flag_id, starts_with('ord')) %>%
gather('survey', 'stream_order', -flag_id) %>%
mutate(survey = substr(survey, 4, 5))

# join data together

long_data = inner_join(width_data, order_data, by = c('flag_id', 'survey'))

fieldData_no_widths_orders = fieldData %>% select(-starts_with('ord'), -starts_with('w'))

fieldData_long = inner_join(long_data, fieldData_no_widths_orders, by = 'flag_id')

allData_one = inner_join(fieldData_long, eventData, by = 'survey')

# clean up and rename some columns

allData_two = allData_one %>% mutate(survey = as.factor(survey)) %>%
rename(runoff = 'Q', distance_upstream = 'upstream_dist', x = 'easting', y = 'northing', z = 'elevation', flow_percentile = 'percs', area = 'areas', length = 'lengs', percent_flowing = 'ratio', drainage_density = 'drain', nonzero_obs = 'numbs', aspect_ratio = 'aspec', mean = 'means')

allData = allData_two %>% select(flag_id:width, runoff:length, mean, percent_flowing, aspect_ratio, date, nonzero_obs, stream_order, channel_order, distance_upstream, slope, x:z)

surveyData = eventData %>% mutate(survey = as.factor(survey)) %>%
rename(runoff = 'Q', flow_percentile = 'percs', area = 'areas', length = 'lengs', mean = 'means', percent_flowing = 'ratio', drainage_density = 'drain', nonzero_obs = 'numbs', aspect_ratio = 'aspec')

allDataNoZero = allData %>% filter(width != 0)

## summarize and simple visualizations to show structures of the data

print(str(allData))
print(str(surveyData))

# plot as distribution of widths

# function for log breaks

base_breaks <- function(n = 10){
    function(x) {
        axisTicks(log10(range(x, na.rm = TRUE)), log = TRUE, n = n)
    }
}

allPlot = allData %>% filter(width != 0) %>% ggplot()
allPlot + stat_density(aes(x = width, y = ..density.., color = mean, group = survey), geom = 'line', position = 'identity') + scale_x_continuous(trans = 'log', breaks = base_breaks(), labels = prettyNum)

# plot information for each survey as scatter

pal = c('black','red3','cadetblue4','chartreuse4','royalblue4','orchid4','palevioletred','goldenrod3','darkorange2','dodgerblue','darkolivegreen3','mediumorchid2','navajowhite2')

shapes = c(1,19,1,1,19,19,19,19,19,19,19,19,19)

surveyData %>% ggplot() +
geom_point(aes(x = length, y = mean, color = survey), shape = shapes, size = 3) +
scale_color_manual(values = pal)

## Goal 1
##############################################

# in particular, interested in relationship between calculated parameters
# of the distribution, and the associated error.

# here's how we do it. the mu value for log-transformed width data is defining
# parameter allowing us to do the mode and

allPlot +
geom_jitter(aes(x = runoff, y = width, color = survey), shape = 20, width = 0.005, alpha = 0.2) +
geom_smooth(aes(x = runoff, y = width), method = 'lm') +
scale_color_manual(values = pal) + scale_y_continuous(trans = 'log', breaks = base_breaks(), labels = prettyNum)

# model_glmm_intercept = glmmPQL(width ~ runoff, ~ 1 | flag_id, data = allDataNoZero, family = gaussian(link = 'log'), verbose = T)
#
# model_glmm_logWidth_intercept = glmmPQL(I(log10(width)) ~ runoff, ~ 1 | flag_id, data = allDataNoZero, family = gaussian(link = 'log'), verbose = T)
#
# model_glmm_slope = glmmPQL(width ~ runoff, ~ 1 + runoff | flag_id, data = allDataNoZero, family = gaussian(link = 'log'), verbose = T)

# but how to model the distribution parameters instead of just the mean??

## Goal 2
##############################################

# Interested in quantifying how much surface area is added with a unit
# increase in runoff. And also in whether that additional surface area is
# from longitudinal or lateral expansion.

# need to make a dataset comprised of differenced pairs of surveys.
# and then add a label to show that something went from dry -> wet or vice-versa

print(str(diffData))

diffDataTwo = diffData %>% mutate(lateral = f2f, longitudinal = f2z + z2f)

diffDataTwo %>% ggplot() + geom_point(aes(x = runoffDelta, y = (lateral/areaT), color = areaT))

diffDataThree = diffDataTwo %>% select(combo, areaT:longitudinal) %>% gather(key = 'mode', value = 'areaDelta', -c(combo, areaT, runoffDelta))

diffDataThree %>% ggplot() + geom_point(aes(x = runoffDelta, y = areaDelta, color = mode))
# diffDataThree %>% ggplot() + geom_point(aes(x = runoffDelta, y = areaDelta / areaT, color = mode)) + geom_hline(yintercept = 0.5)
