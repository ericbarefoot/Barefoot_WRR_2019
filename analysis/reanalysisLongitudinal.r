#!/usr/bin/env Rscript

# Reanalysis of stony creek data adapting to a longitudinal measures design.
# Eric Barefoot
# Nov 2018

# assumes that data and libraries have been imported by main script: projectroot/analysis/stony_creek_analysis.r

library(tidyverse)

library(boot)

fieldData = as_tibble(tab$fdata)
eventData = as_tibble(tab$event_means) %>% select(contains('event'), contains('survey_date'), contains('mean_survey_Q'))

widths_flags = fieldData %>% select(contains('w')) %>% as.matrix()

widthDiffs = matrix(nrow = 740, ncol = 78)

go_mat = lower.tri(matrix(nrow = 13, ncol = 13))

j = 1

for (i in 1:13){
  for (ii in 1:13) {
    if (go_mat[i,ii]) {
      newcol = abs(widths_flags[,i] - widths_flags[,ii])
      widthDiffs[,j] =  newcol
      j = j + 1
    } else {

    }
  }
}

widthDiffs_ID = as.tibble(widthDiffs) %>% add_column(flag_id = fieldData$flag_id) %>% gather(key = 'diffVar', value = 'width', -flag_id)

widths = fieldData %>% select(contains('flag'), contains('w')) %>% gather(key = 'survey', value = 'width', -flag_id)

widthDates = left_join(eventData, by = c('survey' = 'event_id'))

sample_flags = sample_n(widths, 6)

selected_flags = widthDates %>% filter(flag_id %in% as.character(sample_flags$flag_id))

ggplot() + geom_line(data = widthDates, aes(x = survey_date, y = width, group = flag_id), color = 'grey75') + geom_line(data = selected_flags, aes(x = survey_date, y = width, group = flag_id)) + labs(title = 'Evolution of selected flags over repeated surveys', x = 'Time', y = 'Width (cm)')

widthNoZero = widthDates %>% filter(width != 0)

widthNoGroup = mutate(widthNoZero, surv = survey) %>% select(-survey)

ggplot() + geom_step(data = widthNoGroup, stat = 'bin', binwidth = 15, aes(group = surv, x = width, y = ..count..), color = 'grey70') + geom_step(data = widthNoZero, stat = 'bin', binwidth = 15, aes(x = width, y = ..count..)) + facet_wrap(~ survey)

ggplot() + geom_step(data = widthDiffs_ID, stat = 'bin', binwidth = 10, aes(x = width, y = ..count.., group = diffVar), color = 'grey70')

ggplot() + geom_step(data = widthDiffs_ID, stat = 'density', bw = 10, aes(x = width, y = ..count.., group = diffVar), color = 'black', alpha = 0.2)




#######################################################

widths = fieldData %>% select(flag_id, contains('w')) %>% gather(key = 'event_id', value = 'width', -flag_id) %>% mutate(event_id = as.factor(event_id))

# hltab = as_tibble(hltab) %>% rename(event_id = 'names')

dat = widths %>% inner_join(., hltab, by = 'event_id') %>%
rename(R = Q) %>%
filter(!is.na(width), width != 0)

#######################################################
# now dat is a long table where each observation is a row, and all the variables are columns.
# values of statistics calculated by event are repeated for each width observation.

# let's try and just do a simple linear model for average width on runoff, even though we know this is wrong.

naivelm = lm(width ~ R, data = dat)

# you can see why here

ggplot(dat) + aes(x = R, y = width) + geom_point() + geom_smooth(method = 'lm')

goop_intercept = glmmPQL(width ~ R, ~ 1 | flag_id, data = dat, family = gaussian(link = 'log'), verbose = T)
goop_intercept = glmmPQL(width ~ I(log10(R)), ~ 1 | flag_id, data = dat, family = gaussian(link = 'log'), verbose = T)

goop_slope = glmmPQL(width ~ R, ~ 1 + R | flag_id, data = dat, family = gaussian(link = 'log'), verbose = T)

#######################################################




# Q is in units of runoff

flag_means = widths %>% group_by(flag_id) %>% summarize(mean = mean(width, na.rm = TRUE))

widthsWithMeans = inner_join(widths, flag_means)

widths_scaled = widthsWithMeans %>% transmute(flag_id, event_id, widths_s = width - mean) %>% group_by(event_id)

# widths_scaled %>% ggplot() + geom_density(aes(x = widths_s, color = survey))

mean_wid = widths_scaled %>% group_by(event_id) %>% summarize(surv_mean = mean(widths_s, na.rm = T)) %>% inner_join(., eventData)

mean_wid_exc = mean_wid %>% filter(!(event_id %in% c('w00', 'w02'))) %>% mutate_if(is.character,as.factor)

aov_on_centered = aov(widths_s ~ event_id, data = widths_scaled)
naive_aov_on_uncentered = aov(width ~ event_id, data = widths)

# aov_on_uncentered = aov(width ~ event_id + Error(flag_id/event_id), data = widths)

mean_wid_exc %>% ggplot() + geom_point(aes(x = mean_survey_Q, y = surv_mean))

# also gotta think about the uncertainty. ANOVA does that, but let's do it graphically

centeredMeanFun = function(data, indices) {
  d = data[indices,]
  avg = mean(d)
  return(avg)
}

library(rsample)


boot_means = c()
boot_stdds = c()


bmean = function(x, indices) {
  return(mean(x[indices], na.rm = T))
}

for (i in 1:nrow(eventData)) {
  d = widths_scaled %>% filter(event_id == eventData$event_id[i])
  boot_means[i] = boot(d$widths_s, bmean, R = 25)$t0
  boot_stdds[i] = sd(boot(d$widths_s, bmean, R = 25)$t)
}

boot_means
boot_stdds

boot_stats = tibble(surv_mean_boot = boot_means, boot_std = boot_stdds)

mean_wid = bind_cols(mean_wid, boot_stats)


mean_wid %>% ggplot() + geom_point(aes(x = surv_mean, y = surv_mean_boot)) + geom_abline(slope = 1, intercept = 0)

mean_wid %>% filter(!(event_id %in% c('w00', 'w02'))) %>% ggplot() + geom_point(aes(x = mean_survey_Q, y = surv_mean_boot)) + geom_errorbar(aes(x = mean_survey_Q , ymin = surv_mean_boot - 1.96*boot_std, ymax = surv_mean_boot + 1.96*boot_std))

mean_wid %>% filter(!(event_id %in% c('w00', 'w02'))) %>% ggplot() + geom_point(aes(x = survey_date, y = surv_mean_boot)) + geom_errorbar(aes(x = survey_date , ymin = surv_mean_boot - 1.96*boot_std, ymax = surv_mean_boot + 1.96*boot_std))


#############################################################

source(here('analysis','dist_basics.r'))
source(here('analysis','functions','boxaxes.r'))
source(here('analysis','functions','disch_conv.r'))
source(here('analysis','effect_analysis.r'))

meanDiff = c()

for (i in 1:length(survs$p)) {
  q_avg = mean_wid$mean_survey_Q[survs$q[i]]
  p_avg = mean_wid$mean_survey_Q[survs$p[i]]
  meanDiff[i] = q_avg - p_avg
  # if (survs$p[i] != 2) {
  #   meanDiff[i] = 0
  # }
}

lowflowrat = c()

for (i in 1:length(survs$p)) {
  q_avg = hltab$ratio[survs$q[i]]
  p_avg = hltab$ratio[survs$p[i]]
  lowflowrat[i] = (q_avg - p_avg)
}

var = meanDiff

# ewq ==> lateral
# qwe ==> longitudinal

# padds = padd(ewq, qwe, 0.15, 0.15)
# padds = padd(c(var,var), c(qwe, ewq) , 0.15, 0.15)
# padds = padd(var, ewq / qwe, 0.15, 0.15)
yv = log10(qwe/ewq)
yv[which(is.nan(yv))] = 0
padds = padd(var, yv, 0.15, 0.15)

pal = c('black','red3','cadetblue4','chartreuse4','royalblue4','orchid4','palevioletred','goldenrod3','darkorange2','dodgerblue','darkolivegreen3','mediumorchid2','navajowhite2')


pale = rep('black', length(survs$p))

# plot(c(var,var), c(qwe, ewq) , type = 'n', ann = F, axes = F, xlim = padds$xran, ylim = padds$yran)
# plot(var, ewq / qwe, type = 'n', ann = F, axes = F, xlim = padds$xran, ylim = padds$yran)
plot(var, log10(qwe/ewq), type = 'n', ann = F, axes = F, col = pale, xlim = padds$xran, ylim = padds$yran)
# abline(a = 0, b = 1)
# abline(h = 0, v = 0)
# abline(h = 1)
# points(ewq, qwe, pch = 19, cex = areaiop/800, col = pale)
# points(var, ewq, pch = 19, col = 'grey')
points(var, log10(qwe/ewq), pch = 19, col = pal[survs$p])
# points(var, ewq, pch = 19, col = 'red')
# points(var, ewq / qwe, pch = 19, col = pal[survs$p])
# points(areaiop, ewq / qwe, pch = 19, col = pal[whichiop])
# text(ewq, qwe, labels = as.character(whichiop), col = pal[whichiop])
# points(ewq[p],qwe[p], pch = 1, cex = 2.5, col = pale)
boxaxes()
# title(ylab = expression(frac(Delta~A[lon]~(m^2), Delta~A[lat]~(m^2))), xlab = expression(frac(Delta~A[T]~(m^2), A[max])), line = 2.5, main = '(c)')
# title(ylab = expression(Delta~A[lon]~(m^2)), xlab = expression(Delta~A[lat]~(m^2)), line = 2.5, main = '(c)')

# dev.off()
plot(hhtab$area, hhtab$surv_mean,'n')
abline(lm(hhtab$surv_mean~hhtab$area), col = 'grey')
points(hhtab$area, hhtab$surv_mean, pch = 19)
arrows(hhtab$area, hhtab$surv_mean-hhtab$boot_std, hhtab$area, hhtab$surv_mean+hhtab$boot_std, length=0.05, angle=90, code=3)

plot(hhtab$area, hhtab$means,'n')
abline(lm(hhtab$surv_mean~hhtab$area), col = 'grey')
points(hhtab$area, hhtab$means, pch = 19)
arrows(hhtab$area, hhtab$means-hhtab$boot_std, hhtab$area, hhtab$means+hhtab$boot_std, length=0.05, angle=90, code=3)
