#!/usr/bin/Rscript

## re-analysis using glmm for interpreting role of runoff on stream width.
## Eric Barefoot
## Feb 2019

## Goals:
## 1: Quantify scaling of width distribution parameters with runoff.
## 2: Quantify sources of additional area with added runoff.

# import packages

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

# remove unneeded variables, change some names

fieldData = fieldData %>% dplyr::select(-notes) %>% rename(channel_order = 'order_chan')
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

allData = allData_two %>% select(flag_id:width, runoff:length, mean, percent_flowing, aspect_ratio, date, nonzero_obs, stream_order, distance_upstream, slope, x:z)

surveyData = eventData %>% mutate(survey = as.factor(survey)) %>%
rename(runoff = 'Q', flow_percentile = 'percs', area = 'areas', length = 'lengs', mean = 'means', percent_flowing = 'ratio', drainage_density = 'drain', nonzero_obs = 'numbs', aspect_ratio = 'aspec')

allDataNoZero = allData %>% filter(width != 0)

## summarize and simple visualizations to show structures of the data

# str(allData)
# str(surveyData)

# plot as distribution of widths

# function for log breaks

base_breaks <- function(n = 10){
    function(x) {
        axisTicks(log10(range(x, na.rm = TRUE)), log = TRUE, n = n)
    }
}

log_distribution_plot = allDataNoZero %>% ggplot() + stat_density(aes(x = width, y = ..density.., color = runoff, group = survey), geom = 'line', position = 'identity') + scale_x_continuous(trans = 'log', breaks = base_breaks(), labels = prettyNum)

# plot information for each survey as scatter

pal = c('black','red3','cadetblue4','chartreuse4','royalblue4','orchid4','palevioletred','goldenrod3','darkorange2','dodgerblue','darkolivegreen3','mediumorchid2','navajowhite2')

shapes = c(1,19,1,1,19,19,19,19,19,19,19,19,19)

runoff_area_plot = surveyData %>% filter(survey != '00') %>% ggplot() +
geom_smooth(aes(x = runoff, y = area), color = 'black', method = 'lm', se = F, size = 0.5) +
geom_point(aes(x = runoff, y = area, color = survey), shape = shapes[-1], size = 3) +
scale_color_manual(values = pal[-1]) +
scale_x_continuous(trans = 'log10', breaks = base_breaks(), labels = prettyNum) +
scale_y_continuous(trans = 'log10', breaks = base_breaks(), labels = prettyNum) + theme_minimal()

## Goal 1
##############################################

# in particular, interested in relationship between calculated parameters
# of the distribution, and the associated error.

# here's how we do it. the mu value for log-transformed width data is defining
# parameter allowing us to do the mode and

logTransformNoZero = allDataNoZero %>% mutate(logWidth = log(width)) %>% select(flag_id:width, logWidth, runoff:z)

dataToModel = logTransformNoZero %>% filter(!(survey %in% c('00','02','03')))

allData_Runoff = allDataNoZero %>% ggplot() +
geom_line(aes(x = runoff, y = width, group = flag_id), color = 'darkgrey', alpha = 0.3, data = filter(allDataNoZero, flag_id %in% base::sample(levels(allData$flag_id), 50))) +
geom_jitter(aes(x = runoff, y = width, color = survey), shape = 20, width = 0.005, alpha = 0.2) +
scale_color_manual(values = pal) + scale_y_continuous(trans = 'log', breaks = base_breaks(), labels = prettyNum)

# linear mixed models with increasing levels of complexity

# one null model with no random effects or fixed effects

nullModel = lm(logWidth ~ 1, data = dataToModel)

# one null model with no random effects and only fixed effects

fixedModel = lm(logWidth ~ I(log(runoff)), data = dataToModel)

# one null model with random effects on intercept and NO fixed effects

randomIntModel = lmer(logWidth ~ (1 | flag_id), data = dataToModel, REML = FALSE, control = lmerControl(optimizer = 'Nelder_Mead'))

# one null model with random effects on slope and intercept with NO fixed effects

randomIntSlopeModel = lmer(logWidth ~ (1 + I(log(runoff)) | flag_id), data = dataToModel, REML = FALSE, control = lmerControl(optimizer = 'Nelder_Mead'))

# one model with fixed effects and random effects on intercept

fixedRandomIntModel = lmer(logWidth ~ I(log(runoff)) + (1 | flag_id), data = dataToModel, REML = FALSE, control = lmerControl(optimizer = 'Nelder_Mead'))

#  one model with fixed effects and random effects on intercept and slope.

fixedRandomIntSlopeModel = lmer(logWidth ~ I(log(runoff)) + (1 + I(log(runoff)) | flag_id), data = dataToModel, REML = FALSE, control = lmerControl(optimizer = 'Nelder_Mead'))

# one model with the log of each for power law fit.

powerMixedModel = lmer(logWidth ~ I(log(runoff)) + (1 + I(log(runoff)) | flag_id), data = dataToModel, REML = FALSE, control = lmerControl(optimizer = 'Nelder_Mead'))

# RunoffDistancerISModel = lmer(logWidth ~ runoff + I(distance_upstream / max(distance_upstream)) + (1 + runoff | flag_id), data = logTransformNoZero, REML = FALSE, control = lmerControl(optimizer = 'Nelder_Mead'))
#
# RunoffChannelOrderrISModel = lmer(logWidth ~ runoff + channel_order + (1 + runoff | flag_id), data = logTransformNoZero, REML = FALSE, control = lmerControl(optimizer = 'Nelder_Mead'))
#
# RunoffStreamOrderrISModel = lmer(logWidth ~ runoff + stream_order + (1 + runoff | flag_id), data = logTransformNoZero, REML = FALSE, control = lmerControl(optimizer = 'Nelder_Mead'))
#
# RunoffDistanceSloperISModel = lmer(logWidth ~ runoff + I(distance_upstream / max(distance_upstream))*slope + (1 + runoff | flag_id), data = logTransformNoZero, REML = FALSE, control = lmerControl(optimizer = 'Nelder_Mead'))
#
# RunoffSloperISModel = lmer(logWidth ~ runoff + slope + (1 + runoff | flag_id), data = logTransformNoZero, REML = FALSE, control = lmerControl(optimizer = 'Nelder_Mead'))
#
# anova(fixedRandomIntSlopeModel, RunoffDistancerISModel, RunoffDistanceSloperISModel, RunoffChannelOrderrISModel)
#
# anova(RunoffDistanceSloperISModel, RunoffChannelOrderrISModel)
#
# anova(RunoffChannelOrderrISModel, RunoffStreamOrderrISModel)
#
# anova(RunoffSloperISModel, RunoffDistanceSloperISModel)

anova(randomIntSlopeModel, fixedRandomIntSlopeModel, nullModel, fixedModel)
anova(randomIntSlopeModel, powerMixedModel)

modelsAIC = as_tibble(AIC(nullModel, fixedModel, randomIntModel, randomIntSlopeModel, fixedRandomIntModel, fixedRandomIntSlopeModel, powerMixedModel), rownames = 'model')

modelsAICdiff = modelsAIC %>% mutate(dAIC = abs(cumsum(c(0,diff(AIC)))))

# add predictions to model.

dataPredictions = dataToModel %>% bind_cols(null = predict(nullModel), fixed = predict(fixedModel), randomInt = predict(randomIntModel), randomIntSlope = predict(randomIntSlopeModel), fixedRandomInt= predict(fixedRandomIntModel), fixedRandomIntSlope = predict(fixedRandomIntSlopeModel), powerMixed = predict(powerMixedModel))

longDataPredictions = dataPredictions %>% gather(key = 'model', value = 'prediction', -(flag_id:z)) %>% mutate(model = as.factor(model))

comparePredictions = longDataPredictions %>% filter(model %in% c('powerMixed')) %>%
ggplot() +
geom_jitter(aes(x = runoff, y = logWidth, color = survey), width = 0.01, alpha = 0.4, data = logTransformNoZero)  +
geom_jitter(aes(x = runoff, y = prediction), width = 0.01,  alpha = 0.2)

avg_residuals = longDataPredictions %>% filter(model %in% c('powerMixed', 'fixedRandomIntSlope')) %>%
mutate(residual = logWidth - prediction) %>% group_by(survey, runoff, model) %>% summarize(mean_resid = mean(residual))

compareResiduals = longDataPredictions %>% filter(model %in% c('powerMixed', 'fixedRandomIntSlope')) %>%
mutate(residual = logWidth - prediction) %>%
ggplot() +
# geom_jitter(aes(x = runoff, y = logWidth, color = survey), width = 0.01, alpha = 0.4, data = logTransformNoZero)  +
# geom_jitter(aes(x = runoff, y = residual, color = model), width = 0.01,  alpha = 0.2) +
geom_hline(yintercept = 0) +
geom_point(aes(x = runoff, y = mean_resid, color = model), data = avg_residuals) +
geom_line(aes(x = runoff, y = mean_resid, color = model), data = avg_residuals)
# compareResiduals

flags = unique(allData$flag_id)
runoffs = seq(from = 0.01, to = 1, by = 0.01)

predictionData = tibble(flag_id = rep(flags, times = length(runoffs)), runoff = rep(runoffs, each = length(flags)))

if (!file.exists(modelPredictionsDataFile) | refresh == TRUE) {
	start_time = Sys.time()
	nullPredictions = predict(nullModel, newdata = predictionData, se.fit = TRUE, interval = 'prediction', level = 0.8)$fit
	fixedPredictions = predict(fixedModel, newdata = predictionData, se.fit = TRUE, interval = 'prediction', level = 0.8)$fit
	randomIntPredictions = predictInterval(randomIntModel, newdata = predictionData)
	randomIntSlopePredictions = predictInterval(randomIntSlopeModel, newdata = predictionData)
	fixedRandomIntPredictions = predictInterval(fixedRandomIntModel, newdata = predictionData)
	fixedRandomIntSlopePredictions = predictInterval(fixedRandomIntSlopeModel, newdata = predictionData)
	end_time = Sys.time()
	time_diff = end_time - start_time

	nullIntervals = bind_cols(predictionData, as_tibble(nullPredictions))
	fixedIntervals = bind_cols(predictionData, as_tibble(fixedPredictions))
	randomIntIntervals = bind_cols(predictionData, as_tibble(randomIntPredictions))
	randomIntSlopeIntervals = bind_cols(predictionData, as_tibble(randomIntSlopePredictions))
	fixedRandomIntIntervals = bind_cols(predictionData, as_tibble(fixedRandomIntPredictions))
	fixedRandomIntSlopeIntervals = bind_cols(predictionData, as_tibble(fixedRandomIntSlopePredictions))

	models = c('null','fixed','rI','rIS','frI','frIS')

	predictionIntervalsFlag = bind_rows(list(null = nullIntervals, fixed = fixedIntervals, rI = randomIntIntervals, rIS = randomIntSlopeIntervals, frI = fixedRandomIntIntervals, frIS = fixedRandomIntSlopeIntervals), .id = 'model')

	save(predictionIntervalsFlag, file = here('data', 'derived_data', 'model_predictions.rda'))
} else {
	load(modelPredictionsDataFile)
}

predictionIntervals = predictionIntervalsFlag %>% mutate(model = as.factor(model)) %>% group_by(model, runoff) %>% summarize(fit = mean(fit), lwr = mean(lwr), upr = mean(upr))

ModelsToPlot = predictionIntervals %>% filter(model %in% c('rIS','frIS'))

modelFitPlot = ggplot() +
geom_jitter(aes(x = runoff, y = logWidth), width = 0.01, data = logTransformNoZero, alpha = 0.7) +
geom_ribbon(data = ModelsToPlot, aes(x = runoff, ymin = lwr, ymax = upr, fill = model), alpha = 0.2)  +
geom_line(data = ModelsToPlot, aes(x = runoff, y = fit, color = model))

# modelFitPlot

mu_runoff = logTransformNoZero %>% group_by(survey)  %>%
summarize(runoff = mean(runoff), mu = mean(logWidth), mu_upr = mu + 1.96*sd(logWidth), mu_lwr = mu - 1.96*sd(logWidth)) %>%
ggplot() +
geom_line(data = ModelsToPlot, aes(x = runoff, y = fit, linetype = model)) +
geom_errorbar(aes(x = runoff, ymin = mu_lwr, ymax = mu_upr), color = 'darkgrey') +
geom_point(aes(x = runoff, y = mu, color = survey, shape = survey)) +
scale_color_manual(values = pal) +
scale_shape_manual(values = shapes)

# mu_runoff

## Goal 2
##############################################

# Interested in quantifying how much surface area is added with a unit
# increase in runoff. And also in whether that additional surface area is
# from longitudinal or lateral expansion.

# need to make a dataset comprised of differenced pairs of surveys.
# and then add a label to show that something went from dry -> wet or vice-versa

# print(str(diffData))

diffDataTwo = diffData %>% mutate(lateral = f2f, longitudinal = f2z + z2f)

# diffDataTwo %>% ggplot() + geom_point(aes(x = runoffDelta, y = (lateral/areaT), color = areaT))

diffDataThree = diffDataTwo %>% select(combo, areaT:longitudinal) %>% gather(key = 'mode', value = 'areaDelta', -c(combo, areaT, runoffDelta)) %>% filter(!grepl('0', combo)) %>%
mutate(fraction = areaDelta / areaT)

# diffDataThree %>% ggplot() + stat_density(aes(x = areaDelta + 150, y = ..density.., color = mode), geom = 'line', bw = 100, position = 'identity')

# diffDataThree %>% ggplot() + stat_density(aes(x = areaDelta + 150, y = ..density.., color = mode), geom = 'line', position = 'identity') + scale_x_continuous(trans = 'log', breaks = base_breaks(), labels = prettyNum)

# diffDataThree %>% ggplot() + stat_density(aes(x = areaT, y = ..density..), geom = 'line', position = 'identity')
# diffDataThree %>% ggplot() + stat_density(aes(x = runoffDelta, y = ..density..), geom = 'line', position = 'identity')

marginal_Q_areachange = diffDataThree %>% ggplot() + geom_point(aes(x = runoffDelta, y = areaDelta, color = mode)) + geom_smooth(aes(x = runoffDelta, y = areaDelta, color = mode), method = 'lm', formula = y ~ x)

marginal_area_latlong = diffDataThree %>% ggplot() +
geom_hline(yintercept = 0.5) +
geom_point(aes(x = runoffDelta, y = areaDelta / areaT, color = mode))

nullRunoffLat = lm(scale(fraction) ~ 1, data = diffDataThree %>% filter(mode == 'lateral'))
nullRunoffLon = lm(scale(fraction) ~ 1, data = diffDataThree %>% filter(mode == 'longitudinal'))
delAreaRunoffLat = lm(scale(areaT) ~ scale(runoffDelta), data = diffDataThree %>% filter(mode == 'lateral'))
delAreaRunoffLon = lm(scale(areaT) ~ scale(runoffDelta), data = diffDataThree %>% filter(mode == 'longitudinal'))
delFractionRunoffLat = lm(scale(fraction) ~ scale(runoffDelta), data = diffDataThree %>% filter(mode == 'lateral'))
delFractionRunoffLon = lm(scale(fraction) ~ scale(runoffDelta), data = diffDataThree %>% filter(mode == 'longitudinal'))

AIC(nullRunoffLat, nullRunoffLon)
AIC(nullRunoffLat, delAreaRunoffLat, delFractionRunoffLat)
AIC(nullRunoffLon, delAreaRunoffLon, delFractionRunoffLon)
