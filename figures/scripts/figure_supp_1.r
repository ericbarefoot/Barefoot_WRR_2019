# figure_supp_1.r
## figure showing area contributions for lateral and logitudinal expansions.
## Eric Barefoot
# Feb 2019

library(MASS)
library(lme4)
library(here)
library(merTools)
library(tidyverse)

if (interactive()) {
	library(colorout)
}

# should the file be refreshed from the beginning (run from the top)?

refresh = FALSE

# read in data

mainDataFile = here('data', 'derived_data','tab_data.rda')
summaryData = here('data', 'derived_data','high_low_table.rda')
differencesDataFile = here('data', 'derived_data', 'area_differences.rda')
modelPredictionsDataFile = here('data', 'derived_data', 'model_predictions.rda')

if(file.exists(mainDataFile) & file.exists(summaryData) & file.exists(differencesDataFile) & refresh == FALSE) {
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

diffDataTwo = diffData %>% mutate(lateral = f2f, longitudinal = f2z + z2f)

diffDataTwo %>% ggplot() + geom_point(aes(x = runoffDelta, y = (lateral/areaT), color = areaT))

forbiddenCombos = c('1/0','0/2','0/3','0/4','0/5','0/6','0/7','0/8','0/9','0/10','0/11','0/12','/2','/3','3/', '2/9','2/10','2/6')
permittedCombos =
 c('12/6','12/10','12/9')

# !(grepl(paste(forbiddenCombos, collapse = '|'), combo)) | grepl(paste(permittedCombos, collapse = '|'), combo)

diffDataThree = diffDataTwo %>%
select(combo, areaT:longitudinal) %>%
gather(key = 'mode', value = 'areaDelta', -c(combo, areaT, runoffDelta)) %>%
filter(!(grepl(paste(forbiddenCombos, collapse = '|'), combo)) | grepl(paste(permittedCombos, collapse = '|'), combo)) %>%
mutate(fraction = areaDelta / areaT)

# %>% filter(mode == 'lateral')

diffPallet = c('#bdbdbd', '#b2df8a', '#33a02c')

delAreaHist = ggplot(diffDataThree) +
geom_histogram(aes(x = fraction, y = ..count.., fill = mode), binwidth = 0.2, position = 'dodge') +
labs(y = 'Frequency', x = expression(paste(Delta,'A'[lat/lon],'/',Delta,'A'[T]))) + geom_vline(aes(xintercept = 0.5)) +
theme_bw() + scale_fill_manual(guide = FALSE, values = diffPallet[-1]) + theme(strip.background = element_blank(), strip.text.y = element_blank()) +
facet_grid(mode~.)
delAreaHist
#
# pred_data = tibble(r = diffDataThree$runoffDelta, n = predict(nulldiff), s = predict(slopediff), s2 = predict(slopediff_p2)) %>% gather('model', 'pred', -r)

# delAreaPlot + geom_line(aes(x = r, y = pred, color = model), data = pred_data)

# delAreaPlot

data8 = logTransformNoZero %>% filter(stream_order == 1) %>% group_by(survey) %>% summarize(mu = mean(logWidth)) %>% mutate(label = rep('first_order', 13))

fig_8_data = bind_rows(modelMu, data8)

longMus = filter(fig_8_data, label == 'longitudinal')$mu
latMus = filter(fig_8_data, label == 'lateral')$mu
firstMus = filter(fig_8_data, label == 'first_order')$mu

# t.test(longMus, firstMus)
# t.test(latMus, firstMus)

muHist = ggplot() + geom_histogram(aes(x = mu, y = ..count.., fill = label), data = fig_8_data, binwidth = 0.2, position = 'dodge') + theme_bw() +
scale_fill_manual(values = diffPallet, labels = c('First Order Channels','Lateral Expansion','Longitudinal Expansion'), guide = guide_legend(title = '')) +
labs(y = 'Frequency', x = expression(paste(mu))) + theme( strip.background = element_blank(), strip.text.y = element_blank()) +
facet_grid(label~.)
muHist

combined = grid.arrange(grobs = list(delAreaHist, muHist), widths = c(1,1.75), layout_matrix = rbind(c(1,2)))

ggsave(filename = 'figure_supp_1.pdf', plot = combined, path = here('figures','outputs'), width = 7, height = 4, units = 'in')
