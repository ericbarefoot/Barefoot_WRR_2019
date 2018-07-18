#	attempting quick ordering of streams in network
#	Eric Barefoot
#	Feb 2016

#	read in data as is.

pd = 'C:/Users/geology/Documents/eric/thesiswork/stony_creek/'

wd = paste0(pd,'data/')

source(paste0(wd,'stony_creek_io.r'))

segs = substr(tab$fdata$flag_id,1,4)
uniseg = unique(segs)
present = read.csv(text=paste(tab$event_means$event_id,collapse = ','))

for (i in 1:length(tab$event_means$event_id)) {
	for (j in 1:length(uniseg)) {
		section = which(segs == uniseg[j])
		pres = which(tab$fdata[section,i+4] != 0)
		if (length(pres) == 0) {
			present[j,i] = 1
		} else {
			present[j,i] = 0
		}
	}
}

rownames(present) = uniseg

present



#
#lkj = matrix(rep(0,256),nrow = 16, ncol = 16)
#lkj[c(2,3),1] = 1
#lkj[c(4,5),3] = 1
#lkj[c(9,8),4] = 1
#lkj[c(7,6),5] = 1
#lkj[c(12,16),2] = 1
#lkj[c(15,14),16] = 1
#lkj[c(11,10),12] = 1
#
#jkl = apply(lkj,2,sum)
#
#nex = jkl %*% lkj
#
#first = which(jkl == 0) 
#second = which(jkl != 0 & nex == 0)
#third = which(nex != 0)
#
#ords = c()
#ords[first] = 1; ords[second] = 2; ords[third] = 3
