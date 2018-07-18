## More abstract figure depicting our analysis and stufff
## Eric Barefoot
## Mar 2016

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


figout = paste0(outd,'width_Q.png')
png(figout, width = 6, height = 6, res = 600, units = 'in')
#pdf(figout, width = 8, height = 8)


# comparing discharge to mode width

padds = padd(sQm,mo)

plot(sQm, mo, type = 'n', ann = F, axes = F, xlim = padds$xran, ylim = padds$yran)

#ylim = c(min(c(mo,wbar,wsig)), max(c(mo,wbar,wsig)))

momod = lm(mo~sQm)
#wbarmod = lm(wbar~sQm)
#wsigmod = lm(wiqr~sQm)

#areamod = lm(log10(areas) ~ log10(sQm))
#areamod = lm(areas ~ sQm)

lines(sort(sQm), sort(momod$fitted.values), col = 'black')
#abline(wbarmod, col = 'red3')
#abline(wsigmod, col = 'blue3')

points(sQm, mo, col = pal, pch = 19)
#points(sQm, wbar, col = 'red3')
#points(sQm, wiqr, col = 'blue3')

#points(sQm[c(n1,n2)], mo[c(n1,n2)], col = pal[c(n1,n2)], cex = 2, pch = 1)

boxaxes()
title(xlab = 'Discharge (L/s)', ylab = 'Mode Width (cm)', line = 2.5)

#legend('bottomright', c('Mode Width','Mean Width','Standard Deviation'), col = c('black','red3','blue3'), pch = 19, bty

dev.off()