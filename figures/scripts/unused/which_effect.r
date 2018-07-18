
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


padds = padd(ewq,qwe, 0.15, 0.15)

pale = rep('black', nrow(pairs))
pale[p] = 'red3'


figout = paste0(outd, 'which_effect.png')

png(figout, width = 6, height = 6, res = 600, units = 'in')

plot(ewq,qwe, type = 'n', ann = F, axes = F, col = pale, xlim = padds$xran, ylim = padds$yran)
abline(a = 0, b = 1)
points(ewq,qwe, pch = 19, cex = areas[pairs$one]/800, col = pale)
points(ewq[p],qwe[p], pch = 1, cex = 2.5, col = pale)
boxaxes()
title(ylab = expression(Delta~A[ex]~(m^2)), xlab = expression(Delta~A[wi]~(m^2)), line = 2.5, main = '')

dev.off()