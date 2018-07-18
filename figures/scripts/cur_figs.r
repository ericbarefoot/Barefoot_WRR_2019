

##      figures for CUR talk
##      Eric Barefoot
##      Apr 2016

pd= 'C:/Users/geology/Desktop/'

outd = paste0(pd)

#       Power law distribution schematic

figout = paste0(outd, 'plaw_lognorm.pdf')

pdf(figout, width = 8, height = 6, useDingbats = F)

xx = 0:800
dx = dlnorm(xx, 3.93789340, 0.75821715)

plot(xx,dx,type = 'l', ann = F, axes = F, col = 'blue3', lwd = 4, ylim = c(0,max(dx)+0.003))
# abline(v = 0,h = 0)
dev.off()


just_widths = tab$fdata[c(1,grep('w', names(tab$fdata)))]

a = just_widths$w11
b = just_widths$w12

	ztf = which(a == 0 & b != 0)
	ftz = which(b == 0 & a != 0)
	zzz = sort(c(ztf,ftz))

a = as.vector(t(a[-zzz]))
b = as.vector(t(b[-zzz]))
t = a-b






rmserr = function(a,b) {
	ztf = which(a == 0 & b != 0)
	ftz = which(b == 0 & a != 0)
	zzz = sort(c(ztf,ftz))
	
	if (length(zzz) == 0) {
		sqrt(mean((a-b)^2, na.rm = T))
	} else {
		sqrt(mean((a[-zzz]-b[-zzz])^2, na.rm = T))
	}
	
	
}


rmsedat = matrix(nrow = 13, ncol = 13)

for (i in 1:13) {
	for (ii in 1:13) {
		x = as.vector(t(just_widths[i+1]))
		y = as.vector(t(just_widths[ii+1]))
		rmsedat[i,ii] = rmserr(x, y)
	}
}

rmsedat = rmsedat[upper.tri(rmsedat)]


hist(rmsedat, col = 'darkgrey', border = NA, breaks = 20)
abline(v =  c(10.77279), col = 'red3')

hist(t, col = 'darkgrey', border = NA, breaks = 25)
abline(v =  c(- 11.37285, 11.37285), col = 'red3')


hist(a[a!=0], col = 'darkgrey', border = NA, breaks = 25)
hist(b[b!=0], col = 'darkgrey', border = NA, breaks = 25)

plot(density(a[a!=0 & !is.na(a)], bw = 11.67))
lines(density(b[b!=0 & !is.na(b)], bw = 11.67))
