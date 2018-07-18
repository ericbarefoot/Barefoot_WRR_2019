#	Stacks up all the splines together, then puts a hydrograph in the corner with each event marked.
#	Eric Barefoot
#	Mar 2016

outd = file.path(pd, 'figures','outputs')

source(file.path(pd,'analysis','dist_basics.r'))
source(file.path(pd,'analysis', 'functions', 'disch_conv.r'))

figout = file.path(outd,'stacked_w_hydro.pdf')

pdf(file = figout, width = 14, height = 10, useDingbats = F)

#	allnozero and md comes from the dist_basics file

pal = c('black','red3','cadetblue4','chartreuse4','royalblue4','orchid4','palevioletred','goldenrod3','darkorange2','dodgerblue','darkolivegreen3','mediumorchid2','navajowhite2')

mat = matrix(c(2,1),nrow = 2, ncol = 1, byrow = T)

layout(mat, heights = c(4,1))

par(mar = c(0,4,0,2) + 0.1)

#rzero = seq(0,850)
#
#hnozero = hist(allnozero, plot = F, breaks = brks)
#splnozero = smooth.spline(c(0,hnozero$mids), c(0,hnozero$counts), spar = my_spar)
#splnozero = spline(c(0,splnozero$x), c(0,splnozero$y), n = length(rzero))
#
#hmdspl = hist(mdspl, plot = F, breaks = brks)
#splmdspl = smooth.spline(c(0,hmdspl$mids), c(0,hmdspl$counts), spar = my_spar)
#splmdspl = spline(c(0,splmdspl$x), c(0,splmdspl$y), n = length(rzero))
#
#plot(splnozero, type = 'l', lwd = 2, col = 'red3')
#lines(splmdspl$x, splmdspl$y, lwd = 3, col = 'blue3')
#
#plot(density(mdspl), xlim = c(0,850))
#lines(density(allnozero, na.rm = T))

boxplot(md[-1], unlist(allnozero), horizontal = T, axes = F, boxwex = 0.4, ann = F, pch = 20, ylim = c(0,850),yaxs="i", range = 6)
axis(2, at = c(1,2), labels = c('Mode Widths','All Widths'), lwd = 0, lwd.ticks = 1, las = 2, cex.axis = 0.6)

par(mar = c(5,4,4,2) + 0.1)

start_date = strptime('10/01/2015 00:01', format = '%m/%d/%Y %H:%M')
end_date = strptime('03/30/2016 00:01', format = '%m/%d/%Y %H:%M')

hydro_window = which(as.POSIXct(tab$hydro$date) > start_date & as.POSIXct(tab$hydro$date) < end_date)
Q = tab$hydro[hydro_window,c('date','Q')]
Q[,1] = as.numeric(Q[,1])
Q[,2] = disch_conv(q = Q[,2], area = 48.4)

#	spline estimate plots
# par(fig = c(0,1,0,1))
plot(0,0, type = 'n', ann = F, axes = F, xlim = c(0,850), ylim = c(0,70), xaxs = "i", yaxs="i")
for(i in 2:length(widths)) {
  lines(spl[[i]], lwd = 2, lty = 1, col = pal[i])
}
axis(1);axis(2)
abline(h = 0)
title(main ='', xlab = 'Width (cm)', ylab = 'Frequency')

# inset of hydrograph in upper right corner
par(new = T, fig = c(0.2,0.95,0.5,1))

lQ = ceiling(seq(1,length(Q[,1]), length = 4))


plot(Q[,1], log10(Q[,2]), type = 'n', ann = F, axes = F)

lines(Q[lQ[1]:lQ[2],1], log10(Q[lQ[1]:lQ[2],2]), col = 'grey35')
lines(Q[lQ[2]:lQ[3],1], log10(Q[lQ[2]:lQ[3],2]), col = 'grey35')
lines(Q[lQ[3]:lQ[4],1], log10(Q[lQ[3]:lQ[4],2]), col = 'grey35')

hydro_ticks_text = c('11/01/2015', '12/01/2015', '01/01/2016', '02/01/2016', '03/01/2016')

hydro_ticks_strp = strptime(hydro_ticks_text, format = '%m/%d/%Y')
hydro_ticks_pos = as.POSIXct(hydro_ticks_strp)


# which(tab$surveyQ$label == jj)

jj = 0:nrow(tab$event_means)
tt = which(!duplicated(tab$surveyQ$label))
Qtime = as.numeric(tab$surveyQ$survey_times[tt])
QQ = log10(disch_conv(q = tab$event_means$mean_survey_Q[jj], area = 48.4))
points(Qtime, QQ, pch = 19, cex = 1, col = pal[jj])
poss = c(4,1,2,2,4,1,1,1,1,2,4,3,4)
text(Qtime, QQ, labels = jj, pos = poss, col = pal[jj], cex = 1.5)

# for(j in 1:length(tab$event_means$survey_date)) {
# 
# }

axis(1, lwd = 0, lwd.ticks = 1, at = hydro_ticks_pos, labels = c('Nov','Dec','Jan','Feb','Mar'))

axis(4,lwd = 0, lwd.ticks = 1, at = c(-2,-1,0,1,2,3), labels = as.character(c(0.01,0.1,1,10,100,1000)))
mtext('Discharge (mm/hr)', 4, 3)
usrcoord = par('usr')
exmin = usrcoord[1]
exmax = usrcoord[2]
yymin = usrcoord[3]
yymax = usrcoord[4]
segments(x0 = c(exmin, exmax), y0 = c(yymin, yymin), x1 = c(exmax, exmax), y1 = c(yymin, yymax))


dev.off()
