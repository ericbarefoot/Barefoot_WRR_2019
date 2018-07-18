# Figure showing stream network in Stony Creek with associated hydrologic data and the width distribution.
# Eric Barefoot
# Nov 2015

# pd is from master file

wd = paste0(pd,'figures/scripts/')
outd = paste0(pd, 'figures/outputs/')

source(paste0(pd,'analysis/dist_basics.r'))

mat = matrix(c(
	
	rep(1,18), rep(4,9), rep(5,9),
	rep(1,18), rep(4,9), rep(5,9),
	rep(1,18), rep(4,9), rep(5,9),
	rep(1,18), rep(4,9), rep(5,9),
	rep(1,18), rep(4,9), rep(5,9),
	rep(1,18), rep(4,9), rep(5,9),
	rep(1,18), rep(6,9), rep(7,9),
	rep(1,18), rep(6,9), rep(7,9),
	rep(1,18), rep(6,9), rep(7,9),
	rep(3,18), rep(6,9), rep(7,9),
	rep(3,18), rep(6,9), rep(7,9),
	rep(3,18), rep(6,9), rep(7,9),
	rep(3,18), rep(2,9), rep(2,9),
	rep(3,18), rep(2,9), rep(2,9),
	rep(3,18), rep(2,9), rep(2,9),
	rep(3,18), rep(2,9), rep(2,9),
	rep(3,18), rep(2,9), rep(2,9),
	rep(3,18), rep(2,9), rep(2,9)
	
), nrow = 18, byrow = T)

start_date = strptime('09/01/2015 00:01', format = '%m/%d/%Y %H:%M')
hydro_window = which(as.POSIXct(tab$hydro$date) > start_date)

fig_names = character()

i = 8

for (j in 1:length(widths)) {
	
	k = j - 1
	
	thehist = hists[[j]]
	thedens = dens[[j]]
	thefac = facs[[j]]
	thedlnorm = dlnorms[[j]]
	histspline = spline(thehist$mids,thehist$counts)

	themd = md[[j]]; themdl = mdl[[j]] 
	
	figout = paste0(outd,'networkfigs/network_fig',k,'.png')
	
	fig_names[j] = figout
	
	png(figout, width = 18, height = 9, units = 'in', res = 400)
	par(bg = 'grey90', mar = c(1,1,4,1) + 0.1)
	
	layout(mat)

#		map of the field area with width measurements
	
	plot(tab$fdata$easting, tab$fdata$northing, pch = 20, asp = 1, cex = 0.75*(tab$fdata[,i]/ovmean),col = 'dodgerblue4', ann = F, axes = F)
	
	par(mar = c(5,4,4,4) + 0.1)
	
#		hydrograph with points highlighted
	
	plot(as.POSIXct(tab$hydro$date[hydro_window]), log(tab$hydro$Q[hydro_window]), type = 'l', col = 'dodgerblue4', axes = F, ann = F)
	points(as.POSIXct(mean(tab$surveyQ$survey_times[which(tab$surveyQ$label == j)])), log(tab$event_means$mean_survey_Q[j]), pch = 19, col = 'red')
	axis.POSIXct(1,tab$hydro$date, lwd = 0, lwd.ticks = 1)
	axis(4, lwd = 0, lwd.ticks = 1)
	mtext('log Discharge (log(L/s))', side = 4, line = 3, cex = 0.75)

	par(mar = c(5,4,1,2) + 0.1)
	
#		histogram and distributions plotted
	
	plot(thehist, col = 'white', ann = F, axes = F, xlim = c(0,1100), ylim = c(0,80))
	# lines(histspline, col = 'dodgerblue4')
	lines(range, thedlnorm * thefac, lwd = 1, lty = 1, col = 'dodgerblue4')
	lines(thedens$x, thedens$y * thefac, lwd = 1, lty = 1, col = 'red3')
	axis(1, tck = 0.01);axis(2, tck = 0.01)
	title(xlab = 'Width (cm)', ylab = 'Frequency')
	
	dev.off()
	
	i = i + 2
	
}




# layout.show(4)

#	plot(tab$fdata$easting, tab$fdata$northing, pch = 20, asp = 1, cex = 0.75 * (tab$fdata[,i]/ovmean),col = 'dodgerblue4', ann = F, axes = F)
#
#	plot(as.POSIXct(tab$hydro$date), tab$hydro$Q, type = 'l', col = 'dodgerblue4', axes = F, ann = F)
#
#	points(as.POSIXct(tab$event_means$survey_date[i]), tab$event_means$mean_Q[i], pch = 19, col = 'red')
#
#	axis.POSIXct(1,tab$hydro$date, lwd = 0, lwd.ticks = 1)
#
#	hist(tab$fdata[,i][which(tab$fdata[,i] != 0)], breaks = brks, plot = F)
#
#	dev.off()

