#	width_maps_2.R
#	by Eric Barefoot
#	modified from code by George Allen
#	Jun 2016

# runs through each stream centerline, calculates the orthogonal
# direction to the along stream direction at each vertex.
# shapefiles need with UTM coordinates and also joined
# field data for this to work.

# assume imported field data from master file for now

wd = here('figures','scripts')
outd = here('figures','outputs')

source(here('analysis','dist_basics.r'))
source(here('analysis','functions/spread.r'))
source(here('analysis','functions/boxaxes.r'))
source(here('analysis','functions','disch_conv.r'))

figout = file.path(outd,'width_maps_2.pdf')

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

 pdf(figout, width = 20, height = 18)

mQs = disch_conv(q = tab$event_means$mean_survey_Q, area = 48.4)

#inDbfPaths = paste0(pd,'data/GIS/stony_segments/stony_segment_pts.dbf')
inDbfPaths = here('data', 'raw_data', 'gis_data', 'stony_segment_pts.dbf')
# inDbfPaths = '/Users/ericfoot/Dropbox/research/headwater_stream_widths/data/raw_data/gis_data/GIS - sort out when have arcCatalogue/stony_segments/stony_segment_pts.dbf'

# import and process data:
thetab = data.frame(read.dbf(inDbfPaths))

colz = names(tab$fdata[grep('w', names(tab$fdata))])

pal = c('black','red3','cadetblue4','chartreuse4','royalblue4','orchid4','palevioletred','goldenrod3','darkorange2','dodgerblue','darkolivegreen3','mediumorchid2','navajowhite2')

# points for marking the two segments of interest

pts = list(x = c(673287.1, 673253.3), y = c(3989622, 3989647))

op = par(mfrow = c(4,3),
          oma = c(4,4,4,4) + 0.01,
          mar = c(1,1,1,1) + 0.01)

for (m in 2:length(colz)){

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

	for (i in rev(1:length(j))) {
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

	Y = list(x = c(673207, 673343), y = c(3989601, 3989719))

	plot(x, y, type = 'n', xlim=sort(Y$x), ylim = sort(Y$y), asp = 1, lwd = 0.1, col = 1, axes = F, ann = F)
	polygon(ox, oy, col='darkblue', lwd = 0.1, border = NA)
	text(x = 673280, y = 3989700, labels = paste(m-1), col = pal[m], cex = 4)

    text(x = 673339, y = 3989700, labels = paste(round(mQs[m], digits = 2), ' mm/hr'), col = pal[m], cex = 2.8)

	if (m == 13) {text(pts, labels = c('S07A','S14A'), cex = 2.5, col = 'grey50')}

	if (m == 13) {
		segments(673343, 3989670, 673343, 3989720, lwd = 2)
#		text(x = 673350, y = 3989695, labels = 'N', cex = 2)
	}

}

 dev.off()
