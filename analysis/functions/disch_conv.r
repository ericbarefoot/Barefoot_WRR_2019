#	function to convert L/s to mm/day area in hectares
#	Eric Barefoot
#	Feb 2017

disch_conv = function(q,area) {
	div = area
	mul = 60 * 60 * 1e-4
	Q = (q * mul) / div
	return(Q)
}
