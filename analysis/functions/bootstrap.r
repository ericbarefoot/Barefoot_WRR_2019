#	This is a routine to bootstrap a statistic from a sample, given a function to find it's value
#	Eric Barefoot
#	June 2016

my_boot = function(x, func, n) {
	
	lx = length(x)
	set = numeric(n)
	
	for (i in 1:n) {
		set[i] = func(x, sample.int(lx, floor(lx/3), replace = T))
	}
	
	return(list(t0 = func(x), t = set, sd = sd(set)))
	
}




