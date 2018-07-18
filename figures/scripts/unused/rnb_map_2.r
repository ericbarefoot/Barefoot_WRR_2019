
require(foreign)
require(fields)

wd = paste0(pd, 'figures/scripts/')

inDBFpath = paste0(pd,'data/GIS/stony_segments/stony_segment_pts.dbf')

outd = paste0(pd, 'figures/outputs/')

source(paste0(pd,'analysis/dist_basics.r'))
source(paste0(pd,'analysis/b_calcs.r'))

source(paste0(pd,'analysis/functions/spread.r'))

figout = paste0(outd,'rnb_map.png')

# import and process data:
thetab = data.frame(read.dbf(inDBFpath))

# calculate cross sectional direction at each vertex:
x = thetab$lon
y = thetab$lat
s = thetab$Name

#	make list of b, a, and r2 and interpolate linearly between them (spread function)

b2 = spread(thetab, 'Name', rnb_widds, 'flag_id', 'b', na2zero = F)
r2 = spread(thetab, 'Name', rnb_widds, 'flag_id', 'rsqr', na2zero = F)
a2 = spread(thetab, 'Name', rnb_widds, 'flag_id', 'rsqr', na2zero = F)
#	make a color scale for each

bsig = c(mean(b2, na.rm = T) - 1*sd(b2, na.rm = T), 
				 mean(b2, na.rm = T) + 1*sd(b2, na.rm = T))
rsig = c(mean(r2, na.rm = T) - 1*sd(r2, na.rm = T), 
				 mean(r2, na.rm = T) + 1*sd(r2, na.rm = T))
asig = c(mean(a2, na.rm = T) - 1*sd(a2, na.rm = T), 
				 mean(a2, na.rm = T) + 1*sd(a2, na.rm = T))

bres = 16; rres = 16; ares = 16
bpal = rev(heat.colors(bres), alpha = 0.5); bs = seq(bsig[1], bsig[2], length = bres)
ba = c()
for (i in 1:length(b2)) {
	if (is.na(b2[i])) {
		ba[i] = NA
	} else {
		ba[i] = which.min(abs(bs - b2[i]))
	}
}
rpal = heat.colors(rres); rs = seq(rsig[1], rsig[2], length = rres) 
ra = c()
for (i in 1:length(r2)) {
	if (is.na(r2[i])) {
		ra[i] = NA
	} else {
		ra[i] = which.min(abs(rs - r2[i]))
	}
}
apal = heat.colors(ares); as = seq(asig[1], asig[2], length = ares)
aa = c()
for (i in 1:length(a2)) {
	if (is.na(a2[i])) {
		aa[i] = NA
	} else {
		aa[i] = which.min(abs(as - a2[i]))
	}
}


png(figout, width = 8, height = 8, res = 600, units = 'in')

par(mfrow = c(1,1))

plot(x,y,col = bpal[ba], pch = 20, asp=1, lwd=.1, axes = F, ann = F, frame.plot = T)
usr = par('usr')

colorbar.plot(usr[1]+50, usr[3]+50, strip = bs, col = bpal, adj.x = 0, adj.y = 0, strip.width = 0.05, strip.length = 8*0.05)

bar_wid = (usr[4] - usr[3]) * 8 * 0.05
inter = bar_wid/16
posses = usr[1] + ((1:16) - 0.5)*inter + 50
yval = rep(usr[3]+50 - bar_wid/16, 16)

text(posses, yval, round(bs, 2), srt = 45, cex = 0.75)

title(xlab = 'Longitude', ylab = 'Latitude', main = '')

dev.off()