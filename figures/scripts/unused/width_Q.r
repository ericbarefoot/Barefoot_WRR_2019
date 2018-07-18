#	Plot of modal width against stream discharge
#	Eric Barefoot
#	Feb 2016

outd = paste0(pd, 'figures/outputs/')

source(paste0(pd,'analysis/dist_basics.r'))
source(paste0(pd,'analysis/functions/boxaxes.r'))

figout = paste0(outd,'width_Q.pdf')
#png(figout, width = 6, height = 6, res = 600, units = 'in')
pdf(figout, width = 8, height = 8)

sQm = tab$event_means$mean_survey_Q

mo = unlist(mdspl)

plot(mo, sQm, type = 'n', ann = F, axes = F)

#	which points have no discharge?
noQ = which(is.na(tab$event_means$mean_survey_Q))

pal = rep('grey35', length(mo)); pal[noQ] = 'lightblue'

#grid()
#abline(a = 0, b = 1, col = 'grey85', lty = 3)

#	points to omit from regression
#om = NULL
#abline(lm(sQm[-om] ~ mo[-om]), col = 'grey85', lty = 1)
#abline(lm(sQm ~ mo), col = 'lightblue', lty = 1)

points(mo, sQm, pch = 19, col = pal)

abline(v = mo[noQ], col = pal[noQ], lty = 2)

boxaxes()

title(ylab = 'Discharge (L/s)', xlab = 'Modal Width (cm)')

dev.off()


#dQm = tab$event_means$mean_daily_Q

#plot(mo, sQm, type = 'n', ann = F, axes = F)

#	points to omit from regression
#om = c(3)
#abline(lm(Qs[-om] ~ mo[-om]), col = 'grey85', lty = 1)

#	which points have no discharge?
#noQ = which(is.na(tab$event_means$mean_survey_Q))
#
#pal = rep('grey35', length(mo)); pal[noQ] = 'lightblue'
#
#points(mo, dQm, pch = 19, col = pal)
#
#abline(v = mo[noQ], col = pal[noQ], lty = 2)
#
#axis(1); axis(2)
#
#title(ylab = 'Discharge (L/s)', xlab = 'Modal Width (cm)', main = 'daily')







#rect(20,-10,45,90, col = 'grey93', density = NA)
