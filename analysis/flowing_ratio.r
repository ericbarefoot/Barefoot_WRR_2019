#	Computing the ratio of flowing to non-flowing segments in Stony Creek
#	Eric Barefoot
#	Feb 2016

#	assumes you have already imported the data per the master file

flow_rat = c()

# find the first data column
loop = grep('w', names(tab$fdata))
k = 1
for (i in loop) {
	wid = tab$fdata[,i]
	zero = length(which(wid == 0))
	notz = length(which(wid != 0))
	flow_rat[k] = notz / (zero + notz)
	k = k + 1
}
