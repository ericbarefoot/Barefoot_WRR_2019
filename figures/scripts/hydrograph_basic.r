#	plotting the basic hydrograph of the stony creek system
#	Eric Barefoot
#	Feb 2016


start_date = strptime('09/01/2015 00:01', format = '%m/%d/%Y %H:%M')
hydro_window = which(as.POSIXct(tab$hydro$date) > start_date)

Q = tab$hydro[hydro_window,c('date','Q')]

outd = paste0(pd, 'figures/outputs/')

figout = paste0(outd, 'hydrograph_basic.pdf')

pdf(figout, width = 16, height = 10)

par(mfrow = c(2,1))

plot(Q, type = 'n', ann = F)
lines(Q, col = 'navyblue')
title(xlab = 'Date', ylab = 'Discharge (L/s)')
for(j in 1:length(tab$event_means$survey_date)) {
	points(as.POSIXct(mean(tab$surveyQ$survey_times[which(tab$surveyQ$label == j)])), tab$event_means$mean_survey_Q[j], pch = 19, col = 'red')
}

plot(Q[,1], log10(Q[,2]), type = 'n', ann = F)
lines(Q[,1], log10(Q[,2]), col = 'navyblue')
title(xlab = 'Date', ylab = 'Log of Discharge')
for(j in 1:length(tab$event_means$survey_date)) {
	points(as.POSIXct(mean(tab$surveyQ$survey_times[which(tab$surveyQ$label == j)])), log10(tab$event_means$mean_survey_Q[j]), pch = 19, col = 'red')
}

dev.off()







########################################################
# if you want to zoom in on some part of the hydrograph:
########################################################

#	plot(Q[,1], log(Q[,2]), type = 'n', ann = F)
#	lines(Q[,1], log(Q[,2]), col = 'navyblue')
#	title(xlab = 'Date', ylab = 'Log of Discharge')
#	for(j in 1:length(tab$event_means$survey_date)) {
#		points(as.POSIXct(mean(tab$surveyQ$survey_times[which(tab$surveyQ$label == j)])), log(tab$event_means$mean_survey_Q[j]), pch = 19, col = 'red')
#	}
#
#	Y = locator(2)
#
#	plot(Q[,1], log(Q[,2]), type = 'n', ann = F, ylim = Y$y, xlim = Y$x)
#	lines(Q[,1], log(Q[,2]), col = 'navyblue')
#	title(xlab = 'Date', ylab = 'Log of Discharge')
#	for(j in 1:length(tab$event_means$survey_date)) {
#		points(as.POSIXct(mean(tab$surveyQ$survey_times[which(tab$surveyQ$label == j)])), log(tab$event_means$mean_survey_Q[j]), pch = 19, col = 'red')
#	}

########################################################
########################################################