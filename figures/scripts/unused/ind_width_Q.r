##	plot of discharge at the outlet against the width at individual points
##	Eric Barefoot
##	Mar 2016


outd = paste0(pd, 'figures/outputs/')
source(paste0(pd,'analysis/functions/boxaxes.r'))

figout = paste0(outd,'ind_width_Q.pdf')

require(dplyr)

sQm = tab$event_means$mean_survey_Q

#	get rid of the data that isn't widths
just_widths = select(tab$fdata, flag_id, starts_with('w'))

#	which one is the gauge?
gauge_pt = as.numeric(filter(just_widths, flag_id == 'S01A_005'))[-1]

pdf(figout, width = 8, height = 8)

for (j in 1:nrow(tab$fdata)) {

	flags = tab$fdata$flag_id[j]

	wid_pt = as.numeric(filter(just_widths, flag_id == flags))[-1]

	noQ = which(is.na(tab$event_means$mean_survey_Q))

	gz = c(which(gauge_pt == 0 | is.na(gauge_pt)), 1)

	wz = c(which(wid_pt == 0 | is.na(wid_pt)), 1)

	#pal = rep('grey35', length(gauge_pt)); pal[noQ] = 'lightblue'
	#
	#ally = c(gauge_pt,wid_pt); allx = sQm
	#
	#xlim = c(min(allx), max(allx)); ylim = c(min(ally), max(ally))
	#
	#plot(sQm[-gz], gauge_pt[-gz], col = pal, ann = F, axes = F, pch = 19, xlim = xlim, ylim = ylim)
	#axis(1, lwd = 0, lwd.tick = 1);	axis(2, lwd = 0, lwd.tick = 1)
	#
	#title(xlab = 'Mean Daily Discharge (L/s)', ylab = 'Width at the Gauge')

	#par(new = T)

	#word = order(sQm)
	exx = sQm[-wz]
	why = wid_pt[-wz]

	#lines(exx, why, col = 'red3', pch = 19)


	lgex = log10(sQm[-gz])
	lgwy = log10(gauge_pt[-gz])
	lexx = log10(exx)
	lwhy = log10(why)


	xlim = c(min(c(lgex,lexx)), max(c(lgex,lexx)))
	ylim = c(min(c(lgwy,lwhy)), max(c(lgwy,lwhy)))


	plot(lgex, lgwy, col = pal, ann = F, axes = F, pch = 19, xlim = xlim, ylim = ylim)

	abline(lm(lgwy~lgex), col = 'grey35')

	if (length(lexx) < 3) {} else { abline(lm(lwhy~lexx), col = 'red3') } 

	points(lexx, lwhy, col = 'red3', pch = 19)

	boxaxes()

	title(xlab = 'Mean Daily Discharge (L/s)', ylab = 'Width at the Gauge', main = flags)

}

dev.off()




