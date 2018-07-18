#	Stacks up all the splines together, then puts a hydrograph in the corner with each event marked.
#	Eric Barefoot
#	Mar 2016

outd = paste0(pd, 'figures/outputs/')

source(paste0(pd,'analysis/dist_basics.r'))

figout = paste0(outd,'stacked_simple.png')

#pdf(file = figout, width = 14, height = 10, useDingbats = F)
png(file = figout, width = 8, height = 6, res = 600, units = 'in')


mQs = tab$event_means$mean_survey_Q
#	allnozero and mdspl comes from the dist_basics file

#pal = c('black','red3','cadetblue4','chartreuse4','royalblue4','orchid4','palevioletred','goldenrod3','darkorange2','dodgerblue','darkolivegreen3','mediumorchid2','navajowhite2')

#	spline estimate plots

par(mar = c(7,6,6,2))

plot(0,0, type = 'n', ann = F, axes = F, xlim = c(0,850), ylim = c(0,70)
,xaxs = "i",yaxs="i")
for(i in 1:length(widths)) {
  lines(spl[[i]], lwd = 2.5, lty = 1, col = pal[i])
}
axis(1, cex.axis = 1);axis(2, cex.axis = 1)
abline(h = 0)
title(main ='', xlab = 'Width (cm)', ylab = 'Frequency', font = 2, cex.lab = 1, line = 4)

dev.off()
