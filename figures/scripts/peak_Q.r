##	plot of mean daily discharge against the peak frequency
##	Eric Barefoot
##	Mar 2016

outd = paste0(pd, 'figures/outputs/')

source(paste0(pd,'analysis/dist_basics.r'))
source(paste0(pd,'analysis/functions/boxaxes.r'))

figout = paste0(outd,'peak_Q.pdf')

pdf(figout, width = 8, height = 8)

sQm = tab$event_means$mean_survey_Q
dQm = tab$event_means$mean_daily_Q
fdo = unlist(fd)

#	which points have no discharge?
noQ = which(is.na(tab$event_means$mean_survey_Q))

pal = rep('grey35', length(fdo)); pal[noQ] = 'lightblue'

plot(fdo, sQm, col = pal, ann = F, axes = F, pch = 19)

abline(v = fdo[noQ], col = pal[noQ], lty = 2)

boxaxes()

title(ylab = 'Mean Daily Discharge (L/s)', xlab = 'Kernal Density Modal Frequency')

dev.off()