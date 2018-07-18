# draws a box around a plot and makes tick marks on the insides of the box
# Eric Barefoot
# Mar 2016

boxaxes = function() {
	box()

	for (i in 1:2) {
		axis(i, lwd = 0, lwd.tick = 1, tcl = 0.5)
	}
	
	for (i in 3:4) {
		axis(i, lwd = 0, lwd.tick = 1, tcl = 0.5, labels = NA)	
	}	
}
