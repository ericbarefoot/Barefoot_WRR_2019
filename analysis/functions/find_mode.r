
## This is a function that takes a list of numbers, and calculates the mode based on an iterative method that requires no binning or smoothing procedures.
# Eric Barefoot
# June 2016

find_mode = function(x) {
	
	tol = .Machine$double.eps
	top = max(x, na.rm = T)
	btm = min(x, na.rm = T)
	haf = mean(c(top,btm), na.rm = T)
	bhaf = length(which(x < haf))
	thaf = length(which(x > haf))
	
	while (abs(bhaf - thaf) > tol) {
		
		bhaf = length(which(x < haf))
		thaf = length(which(x > haf))
		
		if (thaf > bhaf) {
			btm = haf
			haf = mean(c(top,btm))
			x = x[x > btm]
		}
		
		if (thaf < bhaf) {
			top = haf
			haf = mean(c(top,btm))
			x = x[x < top]
		}
	}
	
	return(haf)
	
}

find_mode_boot = function(x, ind) {
	
	x = x[ind]
	tol = .Machine$double.eps
	top = max(x, na.rm = T)
	btm = min(x, na.rm = T)
	haf = mean(c(top,btm), na.rm = T)
	bhaf = length(which(x < haf))
	thaf = length(which(x > haf))
	
	while (abs(bhaf - thaf) > tol) {
		
		bhaf = length(which(x < haf))
		thaf = length(which(x > haf))
		
		if (thaf > bhaf) {
			btm = haf
			haf = mean(c(top,btm))
			x = x[x > btm]
		}
		
		if (thaf < bhaf) {
			top = haf
			haf = mean(c(top,btm))
			x = x[x < top]
		}
	}
	
	return(haf)
	
}