
wd = paste0(pd,'figures/')
setwd(wd)
outd = paste0(pd, 'figures/outputs/')
figout = paste0(outd,'explain_fig.pdf')
source(paste0(pd,'analysis/dist_basics.r'))
source(paste0(pd,'analysis/functions/boxaxes.r'))
source(paste0(pd,'analysis/effect_analysis_2.r'))



sQm = tab$event_means$mean_survey_Q
mo = mdspl
wbar = wbar
wsig = wsig
wiqr = wiqr

pairs = data.frame(one = c(5,8,9,10,2,3,6,9,6), two = c(4,7,10,11,3,4,5,8,7))

p = 3

n1 = pairs$one[p]
n2 = pairs$two[p]

pal = c('black','red3','cadetblue4','chartreuse4','royalblue4','orchid4','palevioletred','goldenrod3','darkorange2','dodgerblue','darkolivegreen3','mediumorchid2','navajowhite2')


#	function to pad space on plots by some factor in the x and y directions.

padd = function(x,y,xpad = 0.1, ypad = 0.1) {
	xran = range(x)
	xran = c(xran[1] - xpad * diff(xran), xran[2] + xpad * diff(xran))
	yran = range(y)
	yran = c(yran[1] - ypad * diff(yran), yran[2] + ypad * diff(yran))
	return(list(xran = xran, yran = yran))
}



eff = which_effect(tab$fdata, n1, n2)
spp = spline_curves(eff)


figout = paste0(outd, 'presentation_curves.png')

png(figout, width = 8, height = 6, res = 600, units = 'in')

plot(spp$sev1, ylim = c(0,70), type = 'n', ann = F, axes = F, xlim = c(0,500))
abline(h = 0, col = 'black')
lines(spp$sev1, col = pal[pairs$one[p]], lwd = 2)
lines(spp$sev2, col = pal[pairs$two[p]], lwd = 2)

#lines(spp$sz2f$x, spp$sev2$y - spp$sz2f$y - spp$sev1$y, lty = 3, lwd = 2)
lines(spp$sf2f, col = 'grey', lwd = 2)
lines(spp$sz2f, col = 'black', lwd = 2)

axis(2,lwd = 0, lwd.ticks = 1)
axis(1,lwd = 0, lwd.ticks = 1)

title(main = '', ylab = 'Frequency', xlab = 'Width (cm)')

dev.off()