#	Set of figures breaking each stream survey down into a total distribution and then width distributions by order
#	Eric Barefoot
#	Feb 2016

source(paste0(pd,'analysis/dist_basics.r'))

wd = paste0(pd,'figures/')
setwd(wd)
outd = paste0(pd, 'figures/outputs/')
figout = paste0(outd,'dist_by_order.pdf')

pdf(figout, width = 10, height = 16)

for(i in 1:length(tab$event_means[,1])) {

	par(mfrow = c(2,1))
	
#	setting the color pallette
	pal = c('green4', 'blue3', 'red3', 'yellow3')

#		density plots by order
	plot(0,0, type = 'n', ann = F, axes = F, xlim = c(0,600), ylim = c(0,80))
	for (j in 1:length(widths_by_ord[[i]])) {
		lines(dens_by_ord[[i]][[j]]$x, dens_by_ord[[i]][[j]]$y * facs_by_ord[[i]][[j]], col = pal[j], lwd = 2)
	}	
	lines(dens[[i]]$x, dens[[i]]$y * facs[[i]], lwd = 3)

	legend('topright', legend = c('Overall', paste('Order', 1:length(widths_by_ord[[i]]))) , col = c('black', pal), lwd = 2)
	title(main = paste(i, 'Probability Density Estimate'), ylab = 'Frequency', xlab = 'Width (cm)')
	axis(1); axis(2)
	
#		spline plots by order
	plot(0,0, type = 'n', ann = F, axes = F, xlim = c(0,600), ylim = c(0,80))
	for (j in 1:length(widths_by_ord[[i]])) {
		lines(spline_by_ord[[i]][[j]], col = pal[j], lwd = 2)
	}
	lines(spl[[i]], lwd = 3)

	legend('topright', legend = c('Overall', paste('Order', 1:length(widths_by_ord[[i]]))) , col = c('black', pal), lwd = 2)
	title(main = paste(i, 'Fitted Spline'), ylab = 'Frequency', xlab = 'Width (cm)')
	axis(1); axis(2)

}

dev.off()

