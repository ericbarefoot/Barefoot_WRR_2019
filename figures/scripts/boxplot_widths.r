
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


figout = paste0(outd,'boxplots.png')
png(figout, width = 6, height = 6, res = 600, units = 'in')
#pdf(figout, width = 8, height = 8)
par(pch = 19)
boxplot(mex,mwi,mtw,mon, horizontal = T, range = 5, boxwex = 0.4, ylab = '', xlab = 'Width (cm)', main = '')
axis(2, at = c(1,2,3,4), labels = c(NA,NA,NA,NA), lwd = 0, lwd.ticks = 1, las = 2, cex.axis = 0.6)


dev.off()
