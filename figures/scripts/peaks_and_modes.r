#	Comparing modal width methods with each other and finally to their respective peak frequencies.
#	Eric Barefoot
#	Mar 2016

wd = paste0(pd,'figures/')
setwd(wd)
outd = paste0(pd, 'figures/outputs/')
figout = paste0(outd,'peaks_and_modes.pdf')
source(paste0(pd,'analysis/dist_basics.r'))

pdf(figout, 12, 12)

par(mfrow = c(2,2))
plot(md,mdspl, pch = 19, asp = 1);abline(0,1)
plot(md,mdl, pch = 19, asp = 1);abline(0,1)
plot(mdspl,mdl, pch = 19, asp = 1);abline(0,1)
plot(0,0, type = 'n', axes = F, ann = F)
title(main = 'comparing different modal widths to each other')

par(mfrow = c(2,2))
plot(fd,fdspl, pch = 19, asp = 1);abline(0,1)
plot(fd,fdl, pch = 19, asp = 1);abline(0,1)
plot(fdspl,fdl, pch = 19, asp = 1);abline(0,1)
plot(0,0, type = 'n', axes = F, ann = F)
title(main = 'comparing different peak frequencies to each other')

par(mfrow = c(2,2))
plot(md,fd, pch = 19, asp = 1)
plot(mdl,fdl, pch = 19, asp = 1)
plot(mdspl,fdspl, pch = 19, asp = 1)
plot(0,0, type = 'n', axes = F, ann = F)
title(main = 'comparing each modal width to its peak frequencies')

dev.off()


