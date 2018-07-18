#	Plot of discharge against total stream surface area
#	Eric Barefoot
#	Mar 2016

wd = paste0(pd,'figures/')
setwd(wd)
outd = paste0(pd, 'figures/outputs/')
figout = paste0(outd,'area_Q.pdf')
source(paste0(pd,'analysis/dist_basics.r'))
source(paste0(pd,'analysis/functions/boxaxes.r'))

mQs = tab$event_means$mean_survey_Q
mQd = tab$event_means$mean_daily_Q
noQ = which(is.na(tab$event_means$mean_survey_Q))
pal = rep('grey35', length(mQs)); pal[noQ] = 'lightblue'

##	plot

pdf(figout, width = 8, height = 8)

par(pch = 19)

plot(mQs, areas, col = pal, ann = F, axes = F)

abline(v = areas[noQ], col = pal[noQ], lty = 2)

boxaxes()

title(ylab = expression(Total~Surface~Area~(m^2)), xlab = 'Mean Discharge (L/s)', line = 2)

dev.off()



















################################################################
##	plot of surface area against the peak frequency (height of kernal plot)
#################################################################
#
#plot(areas, maxd, col = pal, ann = F, axes = F)
#
#axis(1, lwd = 0, lwd.tick = 1);	axis(2, lwd = 0, lwd.tick = 1)
#
#mtext('Kernal Density Modal Frequency', 2, line = 3);	mtext('Total Surface Area (m^2)', 1, line = 3)
#
#
#
#stream_length = c()
#
#for(i in 1:5) {
#	stream_length[i] = length(which(wet[,i] != 0)) * 5
#}
#
#
#stuff = cbind(areas, meanQ, stream_length)
#
#write.csv(stuff, file = 'areas_etc.csv')
#

























