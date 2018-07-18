################################################################
##	This plots each flag point as a time series 
################################################################

wd = paste0(pd, 'figures/')
outd = paste0(pd, 'figures/outputs/')

for (i in 1:19) {
	
	if (i < 10) {
		seg_name = paste0('S0', i)
	} else {
		seg_name = paste0('S', i)
	}

	lkj = grep(seg_name, tab$fdata$flag_id)
	jkl = tab$fdata[lkj,]

	png(file = paste0(outd, 'spiders/', seg_name, 'spiderplot.png'), height = 10, width = 5, units = 'in', res = 600)
	
	plot(0,0, type = 'n', xlim = c(0,6), ylim = c(0,900), axes = F, ann = F)

	abline(v = 1, col = 'lightgrey')
	title(main = paste(seg_name), col.main = 'lightgrey')

	pal = rainbow(61, s = 0.8, v = 0.7)
	# pie(rep(1,length(pal)), col = pal)
	pal = sample(pal, size = length(pal))
	# pie(rep(1,length(pal)), col = pal)

	k = 0
	for(i in 1:length(lkj)) {
		lines(c(1,2,3,4,5), jkl[i,5:9] + k, col = pal[i])
		k = k + 10
	}
	
	dev.off()
	
}
	

for (i in 1:19) {
	
	if (i < 10) {
		seg_name = paste0('S0', i)
	} else {
		seg_name = paste0('S', i)
	}

	lkj = grep(seg_name, tab$fdata$flag_id)
	jkl = tab$fdata[lkj,5:length(tab$fdata[1,])]
	
	pdf(file = paste0(outd, 'downstream_width/', seg_name, 'seg_plot.pdf'), width = 15, height = 6)
	
	# png(file = paste0(wd, 'downstream_width/', seg_name, 'seg_plot.png'), width = 15, height = 6, units = 'in', res = 600)
	
	plot(0,0, type = 'n', xlim = c(0,500), ylim = c(0,850), axes = F, ann = F)

	title(main = paste(seg_name), col.main = 'lightgrey', xlab = 'distance upstream (m)', ylab = 'width (cm)')
	axis(1, lwd = 0, lwd.tick = 1);	axis(2, lwd = 0, lwd.tick = 1)
	pal = rainbow(5, s = 0.8, v = 0.7)
	pal = sample(pal, size = length(pal))

	for(j in 1:length(jkl[1,])) {
		lines((1:length(jkl[,j])) * 5, jkl[,j], col = pal[j])
	}
	
	dev.off()
	
}
	
