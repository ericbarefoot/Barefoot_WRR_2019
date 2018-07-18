##	function to take one vector from a dataframe, then spread it evenly to fit another dataframe, 
##	interpolating between values
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
			ww[sec] = approx(vsp, widds[vsc], xout = sec)$y
		} else {
			ww[sec] = rep(NA, length(sec))
		}
	}
	return(ww)
}