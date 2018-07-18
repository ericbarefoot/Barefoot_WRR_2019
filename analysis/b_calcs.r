##	calculating b (as in w = aQ^b) and the r^2 for each point in the network
##	Eric Barefoot
##	Mar 2016

wd = getwd()

pd = file.path(wd, '..')

require(dplyr)

source(file.path(wd,'dist_basics.r'))

sQm = tab$event_means$mean_survey_Q

#	get rid of the data that isn't widths

# colz = names(tab$fdata[c(1,grep('w', names(tab$fdata)))])

just_widths = tab$fdata[c(1,grep('w', names(tab$fdata)))]

#	pick out the point at the gauge
gauge_pt = as.numeric(filter(just_widths, flag_id == 'S01A_005'))[-1]

#	which ones don't have discharge?

noQ = which(is.na(tab$event_means$mean_survey_Q))

gz = which(gauge_pt == 0)

#	now, loop through the points in the network and calculate b and Rsqr
#options(warn=2)

b = c()
rsqr = c()
a = c()
for (i in 1:nrow(just_widths)) {
	#	pick out the point of interest
	wid_pt = as.numeric(just_widths[i,2:ncol(just_widths)])
	wz = wid_pt == 0
	logwid = log10(wid_pt[!wz])
	logQ = log10(sQm[!wz])
	if (length(which(wz == F)) > 3) {	
		mod = lm(logwid~logQ)
		b[i] = mod$coefficients[2]
		a[i] = mod$coefficients[1]
		rsqr[i] = summary(mod)$adj.r.squared
	} else {
		b[i] = NA
		rsqr[i] = NA
		a[i] = NA
	}
}

rnb_widds = cbind(just_widths, b, rsqr, a)



#par(mfrow = c(2,2))
#
#brks = seq(-1,1,by = 0.05)
#
#hist(rnb_widds$rsqr, col = 'grey35', border = NA, breaks = brks)
#abline(v = rnb_widds$rsqr[5], col = 'red3')
#
#hist(rnb_widds$a, col = 'grey35', border = NA, breaks = 30)
#abline(v = rnb_widds$a[5], col = 'red3')
#hist(rnb_widds$b, col = 'grey35', border = NA, breaks = 30)
#abline(v = rnb_widds$b[5], col = 'red3')

#plot(log10(sQm[-wz]),log10(wid_pt[-wz]))
#abline(lm(log10(wid_pt[-wz])~log10(sQm[-wz])))
