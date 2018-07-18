#	Plot of width against stream discharge
#	Eric Barefoot
#	Feb 2016

outd = paste0(pd, 'figures/outputs/')

source(paste0(pd,'analysis/dist_basics.r'))
source(paste0(pd, 'analysis/flowing_ratio.r'))
source(paste0(pd,'analysis/functions/boxaxes.r'))

figout = paste0(outd,'width_flow_rat.pdf')

pdf(figout, width = 8, height = 8)

mo = mdspl

plot(mo, flow_rat, type = 'n', ann = F, axes = F)

pal = rep('grey35', length(mo)); pal[which(is.na(tab$event_means$mean_survey_Q))] = 'lightblue'

points(mo, flow_rat, pch = 19, col = pal)

boxaxes()

title(ylab = 'Ratio of Flowing to Non-Flowing Points', xlab = 'Modal Width (cm)')

#abline(lm(Qs[-3] ~ mo[-3]), col = 'red3', lty = 2)

dev.off()