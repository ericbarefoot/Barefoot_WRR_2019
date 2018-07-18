# Figure showing stream network in Stony Creek with associated hydrologic data and the width distribution for a presentation george is doing for a symposium.
# Eric Barefoot
# Feb 2016

#set up working directory and output directory
#wd = paste0(pd,'figures/scripts/')
#outd = paste0(pd, 'figures/outputs/')
#
#source(paste0(pd,'analysis/dist_basics.r'))
#source(paste0(pd,'analysis/flowing_ratio.r'))

wd = paste0(pd, 'figures/scripts/')
outd = paste0(pd, 'figures/outputs/')

source(paste0(pd,'analysis/dist_basics.r'))
source(paste0(pd,'analysis/functions/spread.r'))
source(paste0(pd,'analysis/functions/boxaxes.r'))





require(foreign)

# input parameters:
n = 3 # N vertices overwhich to calculate direction (must be odd numbers >1)
wt = c(5,5,3,1,1)/15 # weights for the weighted mean calculation
wMult = 0.5 # multiplier for the displayed cross section multiplier
fixPlotLims = F

# functions:
insertRow <- function(existingDF, newrow, r) {
	existingDF[seq(r+1,length(existingDF)+1)] = existingDF[seq(r,length(existingDF))]
	existingDF[r] = newrow
	return(existingDF)
}

grouper <- function(x){
	idx = 1 + cumsum(is.na(x))
	nonNa = !is.na(x)
	split(x[nonNa], idx[nonNa])
}


#png(figout, width = 8, height = 8)
#par(mfrow = c(3,5))
#
#mat = matrix(c(
#				1,1,3,3,
#				1,1,3,3,
#				1,1,3,3,
#				1,1,2,2
#), nrow = 4, ncol = 4, byrow = T)
#

inDbfPaths = paste0(pd,'data/GIS/stony_segments/stony_segment_pts.dbf')

# import and process data:
thetab = data.frame(read.dbf(inDbfPaths))

colz = names(tab$fdata[grep('w', names(tab$fdata))])


figout = paste0(outd,'presthings')

mnb = c(9,10)

for (m in mnb ){

	png(paste0(figout,m,'.png'), width = 6, height = 6, units = 'in', res = 600)
	
#	layout(mat)

	
	### Plot out the width maps
	
	# calculate cross sectional direction at each vertex:
	x = thetab$lon
	y = thetab$lat
	s = thetab$Name

	#	make list of widths and interpolate linearly between them

	w = spread(thetab, 'Name', tab$fdata, 'flag_id', colz[m])
	w = w * 0.01 * wMult # convert to meters
	
	l = nrow(thetab)

	# chop start and end of vectors calculate bearing between neighbors: 
	p1x = x[-c((l-n+2):l)]
	p1y = y[-c((l-n+2):l)]
	p2x = x[-c(1:(n-1))]
	p2y = y[-c(1:(n-1))]

	# calculate centerline angle:
	a = atan2(p2y-p1y, p2x-p1x)*180/pi

	# make a original length
	a = c(rep(-999, floor(n/2)), a, rep(-999, floor(n/2))) 

	#### handle start and end of segments (where angles get funky):

	# locate where new segments start:
	j = which(!duplicated(s))

	# insert NAs at start, end, and jump in vector:
	for (i in rev(1:length(j))){
		x = insertRow(x, NA, j[i])
		y = insertRow(y, NA, j[i])
		a = insertRow(a, NA, j[i])
	}

	x = c(x, NA)
	y = c(y, NA)
	a = c(a, NA)

	# get bounds of NA values:
	jNA = which(is.na(a))

	closeL = jNA[-1] - 1
	closeR = jNA[-length(jNA)] + 1
	farL = jNA[-1] - floor(n/2)
	farR = jNA[-length(jNA)] + floor(n/2)


	# use a linearly shrinking window to calculate bearing at ends of vectors:
	for (i in 1:(length(jNA)-1)){

		fL = farL[i]:closeL[i]
		rL = closeR[i]:farR[i]


		for (ii in 1:length(fL)){

			# calculate all points on left sides of jumps:
			L = c((fL[ii]-floor(n/2)), closeL[i])
			a[fL[ii]] = atan2((y[L[2]]-y[L[1]]), (x[L[2]]-x[L[1]]))*180/pi


			# handle all points on right sides of vectors:
			R = c(closeR[i], (rL[ii]+floor(n/2)))
			a[rL[ii]] = atan2((y[R[2]]-y[R[1]]), (x[R[2]]-x[R[1]]))*180/pi

		}
	}

	x = na.omit(x)
	y = na.omit(y)
	a = na.omit(a)

	########################################################################
	# find XY of channel bounds:
	q = 90-a
	q[q < 0] = q[q < 0] + 360

	o1x = x + cos(q*pi/180)*w
	o1y = y - sin(q*pi /180)*w
	o2x = x - cos(q*pi/180)*w
	o2y = y + sin(q*pi/180)*w


	# set XY coordinates with a zero width to NA:
	zW = w == 0

	o1x[zW] = NA
	o1y[zW] = NA
	o2x[zW] = NA
	o2y[zW] = NA


	# add an NA between segments to plot centerline:
	for (i in rev(1:length(j))) {
		x = insertRow(x, NA, j[i])
		y = insertRow(y, NA, j[i])
		o1x = insertRow(o1x, NA, j[i])
		o1y = insertRow(o1y, NA, j[i])
		o2x = insertRow(o2x, NA, j[i])
		o2y = insertRow(o2y, NA, j[i])

	}


	# organize XY for plotting polygons:
	ox = mapply(c, grouper(o1x), lapply(grouper(o2x), rev), NA)
	oy = mapply(c, grouper(o1y), lapply(grouper(o2y), rev), NA)

	ox = unlist(ox, use.names=F)
	oy = unlist(oy, use.names=F)


	#############################
	#PLOT:
	 
#	some coords for a zoom
#	Y = list(x = c(673212.1, 673349.5), y = c(3989700, 3989577))

	 
	 
	# plot all networks at same scale:
	# if (fixPlotLims==T){
	# 	xS = 1000 # meters across in the y direction
	# 	xC = mean(range(ox, na.rm=T))
	# 	xlim = c(xC-xS/2, xC+xS/2)
	# } else {
	# 	xlim=range(x, na.rm=T)
	# 	ylim=range(y, na.rm=T)
	# }

#	par(mgp = c(0,-4,0))
	# plot(x, y, type = 'n', xlim = xlim, ylim = ylim, asp = 1, lwd = 0.1, col = 1, axes = F, ann = F)
	# polygon(ox, oy, col='darkblue', lwd = 0.1, border = NA)
# 
# #	box()
# 	
# #	lines(x, y, col='grey95', lwd = 0.1)
# 
	# Y = locator(2)
	
	Y = list(x = c(673338.8, 673212.8), y = c(3989618, 3989703))
	
	plot(x, y, type = 'n', xlim=sort(Y$x), ylim = sort(Y$y), asp = 1, lwd = 0.1, col = 1, axes = F, ann = F)
	polygon(ox, oy, col='darkblue', lwd = 0.1, border = NA)
#	points(pts, pch = c(15,17), cex = 3, col = 'red3')
#	title(main = paste(m), col.main = pal[m], cex.main = 4)


	
	dev.off()

}






















