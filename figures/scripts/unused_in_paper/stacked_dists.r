#	Stacks up all the density and lognormal density estimates and highlights 
#	Eric Barefoot
#	Feb 2016

################################################################
#	Quick overlay plot with bigger events shaded darker and NA discharges in light blue
################################################################

outd = paste0(pd, 'figures/outputs/')

source(paste0(pd,'analysis/dist_basics.r'))

figout = paste0(outd,'stacked_distributions.pdf')

pdf(file = figout, width = 8, height = 16)

mQs = tab$event_means$mean_survey_Q

#	setting the color pallette to reflect discharge magnitude
pal = (grey((1:length(widths))/(length(widths)+3)))
color_ord = order(mQs, decreasing = T)

k = 1
c_ord = c()
for (i in color_ord) {
	c_ord[i] = k
	k=k+1
}

pal = pal[c_ord]
pal[which(is.na(mQs))] = 'lightblue'

# par(mfrow = c(2,2))
# pie(rep(1,length(widths)), col = pal)
# barplot(mQs, names.arg = 1:13, col = pal)

par(mfrow = c(3,1))

#	density estimate plots
plot(0,0, type = 'n', ann = F, axes = F, xlim = c(0,600), ylim = c(0,80),xaxs = "i",yaxs="i")
for(i in 1:length(widths)) {
  lines(dens[[i]]$x, dens[[i]]$y * facs[[i]], lwd = 1, lty = 1, col = pal[i])
}
axis(1);axis(2)
title(main ='Probability Density Estimate', xlab = 'Width (cm)', ylab = 'Frequency')

#	spline estimate plots
plot(0,0, type = 'n', ann = F, axes = F, xlim = c(0,600), ylim = c(0,80),xaxs = "i",yaxs="i")
for(i in 1:length(widths)) {
  lines(spl[[i]], lwd = 1, lty = 1, col = pal[i])
}
axis(1);axis(2)
title(main ='Fitted Splines', xlab = 'Width (cm)', ylab = 'Frequency')

#	lognormal fits
plot(0,0, type = 'n', ann = F, axes = F, xlim = c(0,600), ylim = c(0,80),xaxs = "i",yaxs="i")
for(i in 1:length(widths)) {
  lines(range, dlnorms[[i]]*facs[[i]], lwd = 1, lty = 1, col = pal[i])
}
axis(1);axis(2)
title(main ='Fitted Lognormal Distributions', xlab = 'Width (cm)', ylab = 'Frequency')

dev.off()




##	this was the way I made it before to compare all the distributions 
#	and the different estimation methods. Now I just do it 
##########################################################################

