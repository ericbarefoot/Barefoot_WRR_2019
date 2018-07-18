#	Plot of modal width against total stream surface area
#	Eric Barefoot
#	Mar 2016

wd = paste0(pd,'figures/')
setwd(wd)
outd = paste0(pd, 'figures/outputs/')
figout = paste0(outd,'width_area.pdf')
source(paste0(pd,'analysis/dist_basics.r'))
source(paste0(pd,'analysis/functions/boxaxes.r'))

mo = mdspl
noQ = which(is.na(tab$event_means$mean_survey_Q))
pal = rep('grey35', length(mo)); pal[noQ] = 'lightblue'

##	plot

pdf(figout, width = 8, height = 8)

par(pch = 19)

plot(mo, areas, col = pal, ann = F, axes = F)

boxaxes()

title(ylab = expression(Total~Surface~Area~(m^2)), xlab = 'Modal Width (cm)', line = 2)

dev.off()


