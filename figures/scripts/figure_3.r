#	figure_3.R
#	by Eric Barefoot
#	modified from code by George Allen
#	July 2018

# runs through each stream centerline, calculates the orthogonal
# direction to the along stream direction at each vertex.
# shapefiles need with UTM coordinates and also joined
# field data for this to work.

# produces a draft figure that is touched up in adobe illustrator

# assume imported field data from master file for now

outd = here('figures','outputs')

source(here('analysis','dist_basics.r'))
source(here('analysis','functions','boxaxes.r'))
source(here('analysis','functions','disch_conv.r'))

figout = here('figures', 'outputs', 'figure_3_draft.pdf')

require(foreign, warn.conflicts = FALSE, quietly = TRUE)

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

##	function to take one vector from a dataframe, then spread it evenly to fit another dataframe,
##	without interpolating between values
## 	Eric Barefoot
##	Mar 2016

spread = function(dat, field, vdat, vfield, wfield, na2zero = T) {
	segs = dat[,field]
	usegs = unique(segs)
	vsegs = substr(vdat[,vfield], 1 ,4)
	segpts = c(which(!duplicated(segs)), length(segs))
	widds = vdat[,wfield]
	if (na2zero == T) {
		widds[is.na(widds)] = 0
	} else {}
	ww = numeric(length(segs))
	for(i in 1:length(usegs)) {
		sec = which(segs %in% usegs[i])
		vsc = which(vsegs %in% usegs[i])
		vsp = floor(seq(sec[1], sec[length(sec)], length = length(vsc)))
		if (length(which(!is.na(widds[vsc]))) >= 2) {
			ww[sec] = approx(vsp, widds[vsc], xout = sec, method = 'constant')$y
		} else {
			ww[sec] = rep(NA, length(sec))
		}
	}
	return(ww)
}

inDbfPaths = here('data', 'raw_data', 'gis_data', 'stony_segment_pts.dbf')

# import and process data:

thetab = data.frame(read.dbf(inDbfPaths))

colz = names(tab$fdata[grep('w', names(tab$fdata))])

mQs = disch_conv(q = tab$event_means$mean_survey_Q, area = 48.4)

pal = c('black','red3','cadetblue4','chartreuse4','royalblue4','orchid4','palevioletred','goldenrod3','darkorange2','dodgerblue','darkolivegreen3','mediumorchid2','navajowhite2')

# points for marking the two segments of interest

pts = list(x = c(673287.1, 673253.3), y = c(3989622, 3989647))


  pdf(figout, width = 20, height = 18)

op <- par(mfrow = c(4,3),
          oma = c(1,1,1,1) + 0.01,
          mar = c(0,0,0,0) + 0.01)

for (m in 2:length(colz)){

	# calculate cross sectional direction at each vertex:
	x = thetab$lon
	y = thetab$lat
	s = thetab$Name

	#	make list of widths and interpolate linearly between them

	w = spread(thetab, 'Name', tab$fdata, 'flag_id', colz[m])
	w = w * 0.01 * wMult # convert to meters

	zw = w == 0

	lx = x
	ly = y

	lx[zw] = NA
	ly[zw] = NA

	j = which(!duplicated(s))

	# add an NA between segments to plot centerline:
	for (i in rev(1:length(j))) {
		x = insertRow(x, NA, j[i])
		y = insertRow(y, NA, j[i])
		lx = insertRow(lx, NA, j[i])
		ly = insertRow(ly, NA, j[i])
	}

	plot(x, y, type = 'n', asp = 1, axes = F, ann = F)
	lines(lx, ly, col='darkblue', lwd = 2)
	text(x = 673148.8, y = 3989969, labels = paste(m-1), col = pal[m], cex = 4)

	text(x = 673650, y = 3989670, labels = paste(round(mQs[m], digits = 2), ' mm/hr'), col = pal[m], cex = 2.8)

	bx = c(673207.8,  673343.8, 3989601.6, 3989719.4)

	if (m == length(colz)) {
		rect(bx[1], bx[3], bx[2], bx[4], border = 'red3', lwd = 2)
		segments(673700,3989670,673700,3989720,lwd = 2)
#		text(x = 673700, y = 3989740, labels = 'N', cex = 2)
	}

}

  dev.off()
