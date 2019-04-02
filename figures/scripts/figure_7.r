# figure_7.r
## Figure Demonstrating how del_A_T and del_A_lat and del_A_lon are derived
## Eric Barefoot
## Feb 2019

library(MASS)
library(lme4)
library(here)
library(merTools)
library(tidyverse)
library(gridExtra)

if (interactive()) {
	library(colorout)
}

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

############################################################

# now pick two surveys

exampleSurveys = c('08', '09')

allData %>%
filter(survey %in% exampleSurveys) %>%
select(flag_id:width) %>% spread(survey, width) %>%
rename(surveyA = 2, surveyB = 3) %>%
mutate(diff = surveyB - surveyA,
  z2f = ifelse(surveyA == 0 & surveyB != 0, diff, NA),
  f2z = ifelse(surveyA != 0 & surveyB == 0, diff, NA),
  f2f = ifelse(surveyA != 0 & surveyB != 0, diff, NA)
)

plotData = allData %>%
filter(survey %in% exampleSurveys) %>%
select(flag_id:width) %>% spread(survey, width) %>%
rename(surveyA = 2, surveyB = 3) %>%
mutate(diff = surveyB - surveyA,
  z2f = ifelse(surveyA == 0 & surveyB != 0, diff, NA),
  f2z = ifelse(surveyA != 0 & surveyB == 0, diff, NA),
  f2f = ifelse(surveyA != 0 & surveyB != 0, diff, NA)
) %>%
gather(-flag_id, key = 'distribution', value = 'width') %>%
filter(!is.na(width) & width != 0)

# Plot showing the two surveys that are going to be compared pairwise.

pal = c('red3','cadetblue4','chartreuse4','royalblue4','orchid4','palevioletred','goldenrod3','darkorange2','dodgerblue','darkolivegreen3','mediumorchid2','navajowhite2')

partOne = plotData %>% filter(distribution %in% c('surveyA','surveyB')) %>% ggplot() +
stat_bin(aes(x = width, y = ..count.., color = distribution), geom = 'line', position = 'identity', binwidth = 12, size = 1) +
theme_minimal() +
scale_colour_manual(labels = c('Survey 8','Survey 9'), guide = guide_legend(title = ''), values = pal[c(8,9)]) +
theme(legend.position = c(0.8, 0.8)) +
labs(x = 'Width (cm)', y = 'Frequency')

ggsave(plot = partOne, filename = 'figure_7_part_1.pdf', path = here('figures','outputs'), width = 4, height = 3, units = 'in')

difflabels = c('Total Change in Area','Lateral Expansion','Longitudinal Expansion')

# Plot showing the pair-wise differenced widths from the two surveys

lightblue = c(166,206,227)
darkblue = c(31,120,180)
lightgreen = c(178,223,138)
darkgreen = c(51,160,44)
diffPallet = c('#1f78b4', '#b2df8a', '#33a02c')


partTwo = plotData %>% filter(distribution %in% c('diff','z2f','f2f')) %>% ggplot() +
stat_bin(aes(x = width, y = ..count.., color = distribution), geom = 'line', position = 'identity', binwidth = 12, size = 1.0, alpha = 1) +
scale_color_manual(labels = difflabels, guide = guide_legend(title = ''), values = diffPallet) +
# scale_fill_hue(labels = difflabels, guide = guide_legend(title = '')) +
theme_minimal() +
theme(legend.position = c(0.7, 0.8)) +
labs(x = 'Difference in Width (cm)', y = '')

ggsave(plot = partTwo, filename = 'figure_7_part_2.pdf', path = here('figures','outputs'), width = 4, height = 3, units = 'in')

diffFacets = c(diff = 'Total Change in Area', f2f = 'Lateral Expansion', z2f = 'Longitudinal Expansion')

# Plot showing the deltaAt, deltaAlat, and deltaAlon

partThree = plotData %>% filter(distribution %in% c('diff','z2f','f2f')) %>% ggplot() +
stat_bin(aes(x = width, y = ..count.., fill = distribution, color = distribution), geom = 'area', position = 'identity', binwidth = 12, size = 1.0, alpha = 1) +
scale_color_manual(labels = difflabels, guide = FALSE, values = diffPallet) +
scale_fill_manual(labels = difflabels, guide = FALSE, values = diffPallet) +
theme_minimal() +
theme(legend.position = 'bottom') +
labs(x = 'Difference in Width (cm)', y = 'Frequency') +
facet_wrap(.~distribution, labeller = labeller(distribution = diffFacets))

ggsave(plot = partThree, filename = 'figure_7_part_3.pdf', path = here('figures','outputs'), width = 8, height = 3, units = 'in')

combined = grid.arrange(grobs = list(partOne, partTwo, partThree), widths = c(1,1),
layout_matrix = rbind(c(1,2), c(3,3)))

ggsave(plot = combined, filename = 'figure_7_draft.pdf', path = here('figures','outputs'), width = 8, height = 6, units = 'in')
