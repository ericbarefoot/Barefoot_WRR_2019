## More abstract figure depicting our analysis and stufff
## Eric Barefoot
## Mar 2016

figout = here('figures','outputs','explain_fig.pdf')
source(here('analysis','dist_basics.r'))
source(here('analysis','functions','boxaxes.r'))
source(here('analysis','functions','disch_conv.r'))
source(here('analysis','effect_analysis.r'))

sQm = disch_conv(q = tab$event_means$mean_survey_Q, area = 48.4)
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

exc = c(1,3,4)

pdf(figout, width = 9, height = 6, useDingbats = F)

par(pch = 19)

mat = matrix(c(
				1,3,4,
				5,2,2
), nrow = 2, ncol = 3, byrow = T)

layout(mat, widths = c(1,1,1))


## PLOT 1 ##

# comparing discharge to mode width

padds = padd(sQm[-exc],mo[-exc])

plot(sQm[-exc],mo[-exc], type = 'n', ann = F, axes = F, xlim = padds$xran, ylim = padds$yran)

#ylim = c(min(c(mo,wbar,wsig)), max(c(mo,wbar,wsig)))

momod = lm(mo[-exc]~sQm[-exc])
#wbarmod = lm(wbar~sQm)
#wsigmod = lm(wiqr~sQm)

#areamod = lm(log10(areas) ~ log10(sQm))
#areamod = lm(areas ~ sQm)

lines(sort(sQm[-exc]), sort(momod$fitted.values), col = 'black')
#abline(wbarmod, col = 'red3')
#abline(wsigmod, col = 'blue3')

points(sQm[-exc], mo[-exc], col = pal[-exc])
#points(sQm, wbar, col = 'red3')
#points(sQm, wiqr, col = 'blue3')

points(sQm[c(n1,n2)], mo[c(n1,n2)], col = pal[c(n1,n2)], cex = 2, pch = 1)

boxaxes()
title(xlab = 'Discharge (mm/hr)', ylab = 'Mode Width (cm)', line = 2.5, main = '(a)')

#legend('bottomright', c('Mode Width','Mean Width','Standard Deviation'), col = c('black','red3','blue3'), pch = 19, bty = 'n')


## PLOT 2 ##



eff = which_effect(tab$fdata, n1, n2)
spp = spline_curves(eff)


plot(spp$sev1, ylim = c(0,70), type = 'n', ann = F, axes = F, xlim = c(0,650))
abline(h = 0, col = 'black')
lines(spp$sev1, col = pal[pairs$one[p]], lwd = 2)
lines(spp$sev2, col = pal[pairs$two[p]], lwd = 2)

#lines(spp$sz2f$x, spp$sev2$y - spp$sz2f$y - spp$sev1$y, lty = 3, lwd = 2)
lines(spp$sf2f, col = 'grey', lwd = 2)
lines(spp$sz2f, col = 'black', lwd = 2)

axis(2,lwd = 0, lwd.ticks = 1)
axis(1,lwd = 0, lwd.ticks = 1)

title(main = '(d)', ylab = 'Frequency', xlab = 'Width (cm)')




#plot(sev1, ylim = c(-40,70), type = 'n', ann = F, axes = F, xlim = c(0,850))
#abline(h = 0, col = 'lightgrey')
#lines(sev1, col = pal[n1], lwd = 2)
#lines(sev2, col = pal[n2], lwd = 2)
#
#lines(sz2f$x, sev2$y - sz2f$y - sev1$y, lty = 2, lwd = 2)
#lines(sf2f$x, sf2f$y, col = 'grey65', lwd = 2)
#lines(sz2f$x, sz2f$y, col = 'grey35', lwd = 2)
#
#axis(2,lwd = 0, lwd.ticks = 1)
#axis(1,lwd = 0, lwd.ticks = 1)
#
#title(main = '(d)', ylab = 'Frequency', xlab = 'Width (cm)')


## PLOT 3 ##

#showing the spread of effects, when widening is more important and when expansion is more important.

padds = padd(ewq,qwe, 0.15, 0.15)

pale = rep('black', nrow(pairs))
#pale[p] = 'red3'

plot(ewq,qwe, type = 'n', ann = F, axes = F, col = pale, xlim = padds$xran, ylim = padds$yran)
abline(a = 0, b = 1)
points(ewq,qwe, pch = 19, cex = areas[pairs$one]/800, col = pale)
points(ewq[p],qwe[p], pch = 1, cex = 2.5, col = pale)
boxaxes()
title(ylab = expression(Delta~A[lon]~(m^2)), xlab = expression(Delta~A[lat]~(m^2)), line = 2.5, main = '(c)')

# plot(widen_effect, expand_effect, type = 'n', ann = F, axes = F)
# #abline(v = 0, h = 0, col = 'lightgrey')
# abline(a = 0, b = 1, col = 'lightgrey')
# #points(widen_effect, expand_effect, pch = 19, col = 'grey35')
# points(widen_effect, expand_effect, pch = 19, col = pal[loop[is]])
#
# #event comparison is point 42
# nm = 48
# points(widen_effect[nm], expand_effect[nm], col = pal[loop[is][nm]], cex = 2, pch = 1)
#
# boxaxes()
#
# title(ylab = 'Expansion', xlab = 'Widening', line = 2.5, main = '(c)')


## PLOT 4 ##

boxplot(mon,mtw,mex,mwi, horizontal = T, range = 5, boxwex = 0.4, ylab = '', xlab = 'Width (cm)', main = '(e)')
axis(2, at = c(1,2,3,4), labels = c('A','B','Longitudinal','Lateral'), lwd = 0, lwd.ticks = 1, las = 2, cex.axis = 0.6)



#plot(density(mon, bw = bw), ylim = c(0,0.1),xlim = c(20,80), lwd = 2, col = 'blue3')
#lines(density(mtw, bw = bw), col = 'red3', lwd = 2)
#lines(density(mwi, bw = bw), col = 'grey65', lwd = 2)
#lines(density(mex, bw = bw), col = 'grey35', lwd = 2)





## PLOT 5 ##

# comparing area to discharge

# [-1]


n1 = n1-3
n2 = n2-3
exx = log10(sQm[-exc])
why = log10(areas[-exc])
pall = pal[-exc]

padds = padd(exx, why)

plot(exx, why, type = 'n', ann = F, axes = F, xlim = padds$xran, ylim = padds$yran)

modd = lm(why~exx)

lines(sort(exx),sort(modd$fitted.values))
points(exx, why, col = pall,)
points(exx[c(n1,n2)], why[c(n1,n2)], col = pall[c(n1,n2)], cex = 2, pch = 1)
box()

	blah = c(0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0,1,2,3,4,5,6,7,8,9,10,20,30,40,50,60,70,80,90,100,200,300,400,500,600,700,800,900,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000)

for (i in 1:2) {
	axis(i, lwd = 0, lwd.tick = 1, tcl = 0.5, at = log10(blah), labels = blah)
}

for (i in 3:4) {
	axis(i, lwd = 0, lwd.tick = 1, tcl = 0.5, at = log10(blah), labels = NA)
}

title(ylab = expression(Total~Surface~Area~(m^2)), xlab = 'Discharge (mm/hr)', line = 2.5, main = '(b)')

dev.off()



## show one contributing factor (the percentage of the network full at any time)
#
## get rid of some outliers
#
#neg = which(widen_effect < 0)
#
#plot(expand_effect[-neg]/widen_effect[-neg], areas[loop[is]][-neg], type = 'n', ann = F, axes = F, xlim = c(-1,14), ylim = c(450,3100))
#abline(v = 1, col = 'lightgrey')
## abline(a = 0, b = 1, col = 'lightgrey')
#points(expand_effect[-neg]/widen_effect[-neg], rnorm(74, sd = 20) + areas[loop[is]][-neg], pch = 19, col = 'grey35')
#
#boxaxes()
#
#title(ylab = 'Starting Area', xlab = 'Expansion/Widening', line = 2.5, main = '(d)')
#
