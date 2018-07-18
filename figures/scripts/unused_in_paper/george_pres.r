# Figure showing stream network in Stony Creek with associated hydrologic data and the width distribution for a presentation george is doing for a symposium.
# Eric Barefoot
# Feb 2016

#set up working directory and output directory
wd = paste0(pd,'figures/scripts/')
outd = paste0(pd, 'figures/outputs/')

source(paste0(pd,'analysis/dist_basics.r'))
source(paste0(pd,'analysis/flowing_ratio.r'))

fig_names = character()

col1 = which(names(tab$fdata) == 'w00')

#	calculating area 

widds = seq(col1, ncol(tab$fdata), by = 2)

wet = tab$fdata[,widds]

#for (i in 1:nrow(wet)) {
#	for (j in 1:length(wet[1,])) {
#		if (is.na(wet[i,j])) {wet[i,j] = 0}
#		else {wet[i,j] = wet[i,j]}
#	}
#}

areas = as.vector(apply(wet, 2, sum, na.rm = T) * 5 / 100)

 

# oo = order(tab$event_means$mean_Q)
# oo = order(flow_rat)
oo = order(areas)
i = col1

for (j in oo) {
	
	k = j - 1
	
	thehist = hists[[j]]
	thespl = spl[[j]]
	thefac = facs[[j]]
	thedlnorm = dlnorms[[j]]

#	themd = md[[j]]; themdl = mdl[[j]] 
	
#	set up figure names and specify directory
	figout = paste0(outd,'pres_george/pres_fig',k,'.png')
	
	fig_names[j] = figout
	
	png(figout, width = 18, height = 9, units = 'in', res = 400)
	
#	set up two panels
	par(mfrow = c(1,2))

#	plot network map with scaled dots
	plot(tab$fdata$easting, tab$fdata$northing, pch = 20, asp = 1, cex = 0.75*(tab$fdata[,i]/ovmean),col = 'dodgerblue4', ann = F, axes = F)
	
#	plot histogram and lines
	plot(thehist, col = 'grey88', ann = F, axes = F, xlim = c(0,1100), ylim = c(0,80))
	# lines(histspline, col = 'dodgerblue4')
	lines(range, thedlnorm * thefac, lwd = 2, lty = 1, col = 'dodgerblue4')
#	lines(thespl, lwd = 2, lty = 1, col = 'red3')
	axis(1, tck = 0.01);axis(2, tck = 0.01)
	title(xlab = 'Width (cm)', ylab = 'Frequency')
	
	dev.off()
	
	i = i + 2
	
}


