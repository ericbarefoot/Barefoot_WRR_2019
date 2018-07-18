#	Function for calculating percentiles for a given set of data points compared to a reference dataset. Takes both data and x as numeric vectors. Returns a matrix with data in column one and percentiles in column two.
#	Eric Barefoot
#	May 2016

perc_func = function(data, x) {
	sorted = sort(data)
	n = length(sorted)
	perc = 100 * (((1:n) - 0.5)/n)
	percs = c()
	xmatch = c()
	for(i in 1:length(x)) {
		xmatch[i] = sorted[which.min(abs(sorted - x[i]))]
		percind = which(sorted %in% xmatch[i])
		percs[i] = round(mean(perc[percind]))
	}	
	percx = cbind(x,percs)
	colnames(percx) = c('data','percentiles')
	return(percalc = percx)
}


#	Function for calculating percentiles for a given set of data points compared to a reference dataset. Takes both data and x as numeric vectors. Returns a matrix with data in column one and percentiles in column two.
#	Eric Barefoot
#	May 2016
#
#	perc_func = function(data, x) {
#		sorted = data[order(data)]
#		n = length(sorted)
#		p = 1:100 / 100
#		pp = floor(p * n)
#		sp = sorted[pp]
#		percs = c()
#		xmatch = c()
#		for(i in 1:length(x)) {
#			percs[i] = which.min(abs(sp - x[i]))
#		}	
#		percx = cbind(x,percs)
#		colnames(percx) = c('data','percentiles')
#		return(percalc = percx)
#	}
