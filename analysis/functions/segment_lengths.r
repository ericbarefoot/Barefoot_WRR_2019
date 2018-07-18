## Calculates the length of each unique segment in the network.
## Eric Barefoot
## March 2016

wd = getwd()

pd = file.path(wd, '..', '..')

dd = file.path(pd, 'data', 'derived_data', 'digested', 'outputs')

segs = substr(tab$fdata$flag_id,1,4)

s = unique(segs)

l = integer(length(s))

for(i in 1:length(s)) {
	l[i] = length(which(segs == s[i])) * 5
}

lenss = data.frame(s,l)

write.csv(lenss, file.path(dd,'seg_lengths.csv'), quote = F, row.names = F)

