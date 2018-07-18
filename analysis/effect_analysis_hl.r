#	Analysis of different effects and phenomena as it relates to high and low-moderate flows.
#	Eric Barefoot
#	May 2016

wd = getwd()

pd = file.path(wd, '..', '..')

ad = file.path(pd, 'analysis')

dd = file.path(pd, 'data')

dddo = file.path(pd, 'data', 'derived_data', 'digested', 'outputs')

fd = file.path(ad, 'functions')

#	load packages

require(dplyr)
require(rgl)

#	function to pad space on plots by some factor in the x and y directions.

padd = function(x,y,xpad = 0.1, ypad = 0.1) {
	xran = range(x)
	xran = c(xran[1] - xpad * diff(xran), xran[2] + xpad * diff(xran))
	yran = range(y)
	yran = c(yran[1] - ypad * diff(yran), yran[2] + ypad * diff(yran))
	return(list(xran = xran, yran = yran))
}

#	load the data

load(file.path(dddo, 'high_low_table.rda'))

# filter the data into high and low flows

htab = filter(hltab, hltag == 2)
ltab = filter(hltab, hltag == 1)

#	set up some constants

percs_cutoff = 80
par(pch = 19)

pal1 = character(13)
pal1[which(hltab$percs >= percs_cutoff)] = 'tomato3'
pal1[which(hltab$percs <  percs_cutoff)] = 'deepskyblue3'
pal1[3] = 'grey85'

ratio_cutoff = 0.80

pal2 = character(13)
pal2[which(hltab$ratio >= ratio_cutoff)] = 'tomato3'
pal2[which(hltab$ratio <  ratio_cutoff)] = 'deepskyblue3'
pal2[3] = 'grey85'

pal3 = c('black','red3','cadetblue4','chartreuse4','royalblue4','orchid4','palevioletred','goldenrod3','darkorange2','dodgerblue','darkolivegreen3','mediumorchid2','navajowhite2')

#	plot and save some figures

#	this one colors the points red for high flows and blue for low flows. divided by a flowing ratio cutoff value

outd = paste0(pd,'figures/outputs/')
figout = paste0(outd, 'tagged_plots_ratio.pdf')
pdf(figout, 16, 8)
pal = pal2
pchset = 19 # hltab$hltag + 14
par(pch = 19, mfrow = c(2,4))

ylabs = c('Mean Width (cm)','Peak Freqency','Discharge (l/s)','Total Area (m^2)','ADN Length (m)','KS p-value','Flowing Network Ratio','Flow Percentile')

vars = list(hltab$means, hltab$peaks, hltab$Q, hltab$areas, hltab$lengs, hltab$kspvl, hltab$ratio, hltab$percs)

for (i in 1:length(vars)) {
	padds = padd(hltab$modes, vars[[i]])
	plot(hltab$modes, vars[[i]], type = 'n', xlim = padds$xran, ylim = padds$yran, ann = F)
	points(hltab$modes, vars[[i]], col = pal, pch = pchset)
	title(xlab = 'Mode Width (cm)', ylab = ylabs[i])
}

dev.off()
cmd = paste('open', figout); system(cmd)



#	plot and save some figures

#	this one colors the points red for high flows and blue for low flows. divided by a percentile cutoff value

outd = paste0(pd,'figures/outputs/')
figout = paste0(outd,'tagged_plots_percentiles.pdf')
pdf(figout, 16, 8)
pal = pal1
pchset = 19 # hltab$hltag + 14
par(pch = 19, mfrow = c(2,4))

ylabs = c('Mean Width (cm)','Peak Freqency','Discharge (l/s)','Total Area (m^2)','ADN Length (m)','KS p-value','Flowing Network Ratio','Flow Percentile')

vars = list(hltab$means, hltab$peaks, hltab$Q, hltab$areas, hltab$lengs, hltab$kspvl, hltab$ratio, hltab$percs)

for (i in 1:length(vars)) {
	padds = padd(hltab$modes, vars[[i]])
	plot(hltab$modes, vars[[i]], type = 'n', xlim = padds$xran, ylim = padds$yran, ann = F)
	points(hltab$modes, vars[[i]], col = pal, pch = pchset)
	title(xlab = 'Mode Width (cm)', ylab = ylabs[i])
}

dev.off()
cmd = paste('open', figout); system(cmd)


#	this one only plots the low flow values, divided by a percentile value cutoff

ltab = filter(hltab, hltag == 1)

outd = paste0(pd,'figures/outputs/')
figout = paste0(outd,'low_flow_plots.pdf')
pdf(figout, 16, 8)
pal = rep('deepskyblue3', nrow(ltab)) ; pal[which(ltab$names == 'w02')] = 'grey85'
pchset = 19 # hltab$hltag + 14
par(pch = 19, mfrow = c(2,4))

ylabs = c('Mean Width (cm)','Peak Freqency','Discharge (l/s)','Total Area (m^2)','ADN Length (m)','KS p-value','Flowing Network Ratio','Flow Percentile')

vars = list(ltab$means, ltab$peaks, ltab$Q, ltab$areas, ltab$lengs, ltab$kspvl, ltab$ratio, ltab$percs)

for (i in 1:length(vars)) {
	padds = padd(ltab$modes, vars[[i]])
	plot(ltab$modes, vars[[i]], type = 'n', xlim = padds$xran, ylim = padds$yran, ann = F)
	points(ltab$modes, vars[[i]], col = pal, pch = pchset)
	title(xlab = 'Mode Width (cm)', ylab = ylabs[i])
}

dev.off()
cmd = paste('open', figout); system(cmd)




#	this one only plots the high flow values, divided by a percentile value cutoff

htab = filter(hltab, hltag == 2)

outd = paste0(pd,'figures/outputs/')
figout = paste0(outd,'high_flow_plots.pdf')
pdf(figout, 16, 8)
pal = rep('tomato3', nrow(htab)) ; pal[which(htab$names == 'w02')] = 'grey85'
pchset = 19 # hhtab$hltag + 14
par(pch = 19, mfrow = c(2,4))

ylabs = c('Mean Width (cm)','Peak Freqency','Discharge (l/s)','Total Area (m^2)','ADN Length (m)','KS p-value','Flowing Network Ratio','Flow Percentile')

vars = list(htab$means, htab$peaks, htab$Q, htab$areas, htab$lengs, htab$kspvl, htab$ratio, htab$percs)

for (i in 1:length(vars)) {
	padds = padd(htab$modes, vars[[i]])
	plot(htab$modes, vars[[i]], type = 'n', xlim = padds$xran, ylim = padds$yran, ann = F)
	points(htab$modes, vars[[i]], col = pal, pch = pchset)
	title(xlab = 'Mode Width (cm)', ylab = ylabs[i])
}


dev.off()
cmd = paste('open', figout); system(cmd)



## Now for some more exploratory plotting....

hltab_plot = function(xvar, yvar, pal = c('red3', 'cadetblue4', 'chartreuse4', 'royalblue4', 'orchid4', 'palevioletred', 'goldenrod3', 'darkorange2', 'dodgerblue', 'darkolivegreen3', 'mediumorchid2', 'navajowhite2'), lev = 'both') {
	vars = names(hltab)
	nams = c('Name','Discharge','Percentile','Area','Length','Flowing Ratio','Mode Width','Mean Width','Standard Deviation','Interquartile Range','Peak Frequency','Mode Width (density est.)','Mode Width (lognormal est.)','Peak Freqency (density est.)','Peak Frequency (lognormal est.)','K-S statistic','K-S p-value','High/Low Q tag','Average Seepage')
	xnam = nams[which(vars %in% xvar)]
	ynam = nams[which(vars %in% yvar)]
	pchset = 19
	levelz = c('high','low','both')
	lev = levelz[grep(lev, levelz)]
	a = (ltab[,xvar])
	b = (ltab[,yvar])
	aa = (hltab[,xvar])
	bb = (hltab[,yvar])	
	aaa = (htab[,xvar])
	bbb = (htab[,yvar])
	if (lev == 'high') {
		xx = aaa
		yy = bbb
		pal = pal[which(hltab$hltag == 2)]
	}
	else if (lev == 'low') {
		xx = a
		yy = b
		pal = pal[which(hltab$hltag == 1)]
	}
	else if (lev == 'both') {
		xx = aa
		yy = bb
	}
	else {
		stop('pick either high, low, or both')
	}
	padds = padd(xx, yy)
	plot(xx, yy, type = 'n', xlim = padds$xran, ylim = padds$yran, ann = F)
	points(xx, yy, col = pal, pch = pchset)
	title(xlab = xnam, ylab = ynam)
	
	return(list(x = xx, y = yy))
}

pal4 = rep(1,12)

lkj = hltab_plot('Q','means',pal = pal4, lev = 'both')

k = identify(lkj$x,lkj$y)

# abline(lm(yy~xx), col = 'grey45')
abline(lm(lkj$y[k]~lkj$x[k]), col = 'deepskyblue3')
abline(lm(yyy~xxx), col = 'tomato3')
abline(a = 0, b = 1)


xx = hltab$areas ; xnam = 'area'
yy = hltab$lengs / (hltab$means*0.01) ; ynam = 'aspect ratio'

	padds = padd(xx, yy)
	plot(xx, yy, type = 'n', xlim = padds$xran, ylim = padds$yran, ann = F)
	points(xx, yy, col = pal4, pch = pchset)
	title(xlab = xnam, ylab = ynam)

poi = lm(yy~xx)
lkj = lm(y~x)
jkl = lm(yyy~xxx)


zz = hltab[,zvar]
zran = range(zz)
zpad = 0.1
zran = c(zran[1] - zpad * diff(zran), zran[2] + zpad * diff(zran))

bg3d('grey24')
plot3d(xx,yy,zz, col = pal, xlim = padds$xran, ylim = padds$yran, zlim = zran, size = 4, xlab = '', ylab = '', zlab = '')
axes3d(col = 'lightgrey')
title3d(xlab = xnam, ylab = ynam, zlab = znam, col = 'lightgrey')




