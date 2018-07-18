#	Calculating K-S statistics for the distributions in the stony creek study. 
#	Eric Barefoot
#	May 2016
wd = paste0(pd, 'figures/scripts/')
outd = paste0(pd, 'figures/outputs/')

source(paste0(pd,'analysis/dist_basics.r'))
source(paste0(pd,'analysis/functions/boxaxes.r'))

figout = paste0(outd,'ks_plots.pdf')

ksstats = c()
kspvals = c()
pdf(figout, 12, 16)
par(mfrow = c(3,4))
surv_names = names(tab$fdata)[grep('w', names(tab$fdata))][-1]

# loop through starting with the second one because we're ignoring the first survey now. 

k = 1
for (i in 2:length(widths)) {
	
	# get the mlog and sdlog values for this lognormal distribution fit. 
	
	this_meanlog = lognorms[[i]]$estimate[1]
	this_sdlog = lognorms[[i]]$estimate[2]
	
	# prep variables for ECDF plot
	
	sort.widds = sort(widths[[i]])
	n = length(widths[[i]])
	probs=  (1:n)/n
	
	# construct CDF for corresponding lognormal distribution
	
	rrr = seq(min(widths[[i]]), max(widths[[i]]), by = 0.05)
	theor = plnorm(rrr, this_meanlog, this_sdlog)
		
	# do KS test and export statistics.
	
	ksstats[k] = ks.test(widths[[i]], 'plnorm', this_meanlog, this_sdlog)$statistic
	kspvals[k] = ks.test(widths[[i]], 'plnorm', this_meanlog, this_sdlog)$p.value
	
	# plot the thing
	
	plot(sort.widds, probs, type = 's', xlab = "Width (cm)", ylab = 'Probability', main = paste('ECDF and CDF for survey', surv_names[k])) ; lines(rrr,theor, col = 'red3')
	
	# xxx = quantile(widths[[i]], probs = 0.99)
	# yyy = 0.2
	legend('bottomright', legend = c(paste('K-S stat', round(ksstats[k], 3)), paste('p-value', round(kspvals[k], 3))), bty = 'n')
	k = k + 1 
}
