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
pointwise_differences = here('data', 'derived_data', 'effect_differences.rda')

if(file.exists(mainDataFile) & file.exists(summaryData) & file.exists(differencesDataFile)) {
	load(mainDataFile)
	load(summaryData)
	load(differencesDataFile)
  load(pointwise_differences)
} else {
	source(here('data', 'stony_creek_process.r'))
	load(mainDataFile)
	source(here('analysis', 'compile_data_hl.r'))
	load(summaryData)
	source(here('analysis', 'effect_analysis.r'))
}

source(here('analysis','runoff_width_modeling.r'))

# make into tibbles from data.frames

fieldData = as_tibble(tab$fdata)
eventData = as_tibble(hltab)
diffData = as_tibble(diffData) %>% mutate(combo = as.factor(combo))


dataToModel = logTransformNoZero %>% filter(!(survey %in% c('00','02','03')))

modelMu = diffDataPoints %>%
mutate(logWidth = log(width), combo = as.factor(combo)) %>%
group_by(combo, label) %>%
summarize(mu = mean(logWidth), delQ = mean(deltaQ))
oR = unique(dataToModel$runoff) %>% order
oR = oR[-10]
combs = diffDataPoints$combo %>% unique
splicee = tibble(combo = combs, R = unique(dataToModel$runoff)[oR])
something = dataToModel %>% group_by(survey) %>% summarize(mu = mean(logWidth), R = mean(runoff))
original_mu = inner_join(something, splicee, by = 'R')
original_mu = original_mu %>% select(-survey, mu_o = mu, Q_o = R)
modelMu_update = inner_join(modelMu, original_mu, by = 'combo')

diffPallet = c('#b2df8a', '#33a02c')

labb = c('Lateral', 'Longitudinal')

muWithLatLon = modelMu_update %>% ggplot(aes(x = Q_o, y = mu, color = label)) + geom_smooth(method = 'lm', se = F) +
geom_point() + theme_minimal() + scale_color_manual(labels = labb, values = diffPallet, guide = guide_legend(title = '')) + labs(x = 'Runoff (mm/hr)', y = expression(paste(mu))) + theme(legend.position = 'bottom')
muWithLatLon

eventData_2 = as_tibble(hltab)

percentilesPlot = eventData_2 %>% filter(!(names %in% c('w00', 'w02', 'w03'))) %>% ggplot(aes(x = percs, y = muuus)) + geom_smooth(method = 'lm', se = F, color = 'black') + geom_point() + theme_minimal() + labs(x = 'Flow Percentile', y = expression(paste(mu)))
percentilesPlot

combined = grid.arrange(grobs = list(muWithLatLon, percentilesPlot), widths = c(1,1),
layout_matrix = rbind(c(1,2)))

ggsave(filename = 'figure_8_draft.pdf', plot = combined, path = here('figures','outputs'), width = 8, height = 4, units = 'in')
