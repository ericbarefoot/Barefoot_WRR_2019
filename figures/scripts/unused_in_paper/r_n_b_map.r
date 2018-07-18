#	width_map.R
#	by Eric Barefoot
#	modified from code by George Allen
#	Feb 2016

# runs through each stream centerline, calculates the b and R^2 for
# each flag, then plots it as a map of the network. 
# shapefiles need with UTM coordinates and also joined 
# field data for this to work.

# assume imported fdata from master file for now

require(foreign)

wd = paste0(pd, 'figures/scripts/')

inDBFpath = paste0(pd,'data/GIS/stony_segments/stony_segment_pts.dbf')

outd = paste0(pd, 'figures/outputs/')

#source(paste0(pd,'analysis/dist_basics.r'))
#source(paste0(pd,'analysis/b_calcs.r'))

source(paste0(pd,'analysis/functions/spread.r'))

figout = paste0(outd,'rnb_map.pdf')

# import and process data:
thetab = data.frame(read.dbf(inDBFpath))

# calculate cross sectional direction at each vertex:
x = thetab$lon
y = thetab$lat
s = thetab$Name

#	make list of b, a, and r2 and interpolate linearly between them (spread function)

b2 = spread(thetab, 'Name', rnb_widds, 'flag_id', 'b', na2zero = F)
r2 = spread(thetab, 'Name', rnb_widds, 'flag_id', 'rsqr', na2zero = F)
a2 = spread(thetab, 'Name', rnb_widds, 'flag_id', 'rsqr', na2zero = F)
#	make a color scale for each

bsig = c(mean(b2, na.rm = T) - 1*sd(b2, na.rm = T), 
				 mean(b2, na.rm = T) + 1*sd(b2, na.rm = T))
rsig = c(mean(r2, na.rm = T) - 1*sd(r2, na.rm = T), 
				 mean(r2, na.rm = T) + 1*sd(r2, na.rm = T))
asig = c(mean(a2, na.rm = T) - 1*sd(a2, na.rm = T), 
				 mean(a2, na.rm = T) + 1*sd(a2, na.rm = T))

bres = 16; rres = 16; ares = 16
bpal = heat.colors(bres); bs = seq(bsig[1], bsig[2], length = bres)
ba = c()
for (i in 1:length(b2)) {
	if (is.na(b2[i])) {
		ba[i] = NA
	} else {
		ba[i] = which.min(abs(bs - b2[i]))
	}
}
rpal = heat.colors(rres); rs = seq(rsig[1], rsig[2], length = rres) 
ra = c()
for (i in 1:length(r2)) {
	if (is.na(r2[i])) {
		ra[i] = NA
	} else {
		ra[i] = which.min(abs(rs - r2[i]))
	}
}
apal = heat.colors(ares); as = seq(asig[1], asig[2], length = ares)
aa = c()
for (i in 1:length(a2)) {
	if (is.na(a2[i])) {
		aa[i] = NA
	} else {
		aa[i] = which.min(abs(as - a2[i]))
	}
}



#plot(density(b2))
#abline(v = c(max(b2),min(b2),mean(b2)), col = 'red3', lty = 3)
#abline(v = c(bsig[1], bsig[2]), col = 'blue3', lty = 3)
#
#plot(density(r2))
#abline(v = c(max(r2), min(r2), mean(b2)), col = 'red3', lty = 3)
#abline(v = c(rsig[1], rsig[2]), col = 'blue3', lty = 3)

pdf(figout, width=20, height=20)

#put the labels for lat long on the inside of the plot
par(mgp = c(0,-4.5,0))

## and here are the plots, interpolated

plot(x,y,col = bpal[ba], pch = 20, asp=1, lwd=.1, axes = F, ann = F, frame.plot = T)
axis(1, las = 2, tcl = 0.5); axis(2, las = 2, tcl = 0.5)
axis(3, las = 2, tcl = 0.5); axis(4, las = 2, tcl = 0.5)
title(xlab = 'Longitude', ylab = 'Latitude', main = 'b values')

#Y = locator(2)
#plot(x,y,col = bpal[ba], pch = 20, xlim=sort(Y$x), ylim = sort(Y$y), asp = 1)



plot(x,y,col = rpal[ra], pch = 20, asp = 1, lwd=.1, axes = F, ann = F, frame.plot = T)
axis(1, las = 2, tcl = 0.5); axis(2, las = 2, tcl = 0.5)
axis(3, las = 2, tcl = 0.5); axis(4, las = 2, tcl = 0.5)
title(xlab = 'Longitude', ylab = 'Latitude', main = 'R squared')


#Y = locator(2)
#plot(x,y,col = rpal[ra], pch = 20, xlim=sort(Y$x), ylim = sort(Y$y), asp = 1)


plot(x,y,col = apal[aa], pch = 20, asp=1, lwd=.1, axes = F, ann = F, frame.plot = T)
axis(1, las = 2, tcl = 0.5); axis(2, las = 2, tcl = 0.5)
axis(3, las = 2, tcl = 0.5); axis(4, las = 2, tcl = 0.5)
title(xlab = 'Longitude', ylab = 'Latitude', main = 'a values')


dev.off()

