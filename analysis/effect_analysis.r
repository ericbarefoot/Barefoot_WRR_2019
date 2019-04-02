# Examining the relative contributions of new segments to widening points in growing stream surface area.
# Eric Barefoot
# July 2018

# note from later: appears that this script doesn't actually stand alone. must have to call it in interactive mode during something else.

source(here('analysis', 'dist_basics.r'))

load(here('data', 'derived_data','high_low_table.rda'))

colz = grep('w', names(tab$fdata))
coln = names(tab$fdata[colz])

which_effect = function(dat = tab$fdata, n1, n2) {


	ev1 = dat[colz[n1]]
	ev1 = as.numeric(unlist(ev1))
	ev2 = dat[colz[n2]]
	ev2 = as.numeric(unlist(ev2))

	widths = data.frame(ev1,ev2)

	# which ones are NA in either?

	na1 = which(is.na(ev1))
	na2 = which(is.na(ev2))

	na = unique(c(na1,na2))

	if (length(na) > 0) {
		# now exclude them from both

		ev1 = ev1[-na]
		ev2 = ev2[-na]
	} else {

	}



	# which ones are zeros or not for event 1 and 2?

	ev1z = which(ev1 == 0)
	ev1f = which(ev1 != 0)
	ev2z = which(ev2 == 0)
	ev2f = which(ev2 != 0)

	# which zeros in event 1 are full in event 2?

	evz2f = ev1z[which(ev1z %in% ev2f)]

	# which fulls in event 1 are full in event 2?

	evf2f = ev1f[which(ev1f %in% ev2f)]

	# which fulls in event 1 are zero in event 2?

	evf2z = ev1f[which(ev1f %in% ev2z)]

	# which zeros in event 1 are still zero in event 2?

	evz2z = ev1z[which(ev1z %in% ev2z)]

	# what is the total area difference due to full->full segments?

	evf2fdelta = sum(ev2[evf2f] - ev1[evf2f]) * 0.01 * 5

	# what is the total area difference between zero->full segments?

	evz2fdelta = sum(ev2[evz2f] * 0.01) * 5

	# what is the total area difference between full->zero segments?

	evf2zdelta = -sum(ev1[evf2z] * 0.01) * 5


	return(list(z2f = evz2fdelta, f2f = evf2fdelta, f2z = evf2zdelta, ev1 = ev1,
		ev2 = ev2, ev1f = ev1f, ev2f = ev2f, ev1z = ev1z, ev2z = ev2z, evf2z = evf2z, evz2f = evz2f, evf2f = evf2f))
}






spline_curves = function(jkl, spar = 0.3) {

	my_spar = 0.3

	brks = seq(0, max(c(jkl$ev1, jkl$ev2), na.rm = T) + 10, by = 10)

	# event 1
	hev1 = hist(jkl$ev1[jkl$ev1f], plot = F, breaks = brks)

	sev1 = smooth.spline(c(0,hev1$mids), c(0,hev1$counts), spar = my_spar)
	sev1 = spline(c(0,sev1$x), c(0,sev1$y), n = length(range))

	# event 2
	hev2 = hist(jkl$ev2[jkl$ev2f], plot = F, breaks = brks)

	sev2 = smooth.spline(c(0,hev2$mids), c(0,hev2$counts), spar = my_spar)
	sev2 = spline(c(0,sev2$x), c(0,sev2$y), n = length(range))

	# zero to full
	hz2f = hist(jkl$ev2[jkl$evz2f], plot = F, breaks = brks)

	sz2f = smooth.spline(c(0,hz2f$mids), c(0,hz2f$counts), spar = my_spar)
	sz2f = spline(c(0,sz2f$x), c(0,sz2f$y), n = length(range))

	# full to full
	hf2f = hist(jkl$ev2[jkl$evf2f], plot = F, breaks = brks)

	sf2f = smooth.spline(c(0,hf2f$mids), c(0,hf2f$counts), spar = my_spar)
	sf2f = spline(c(0,sf2f$x), c(0,sf2f$y), n = length(range))

	# full to full delta
	hf2fdelta = hev2$counts - hz2f$counts - hev1$counts

	# full to zero
	hf2z = hist(jkl$ev1[jkl$evf2z], plot = F, breaks = brks)

	return(list(sev1 = sev1, sev2 = sev2, sz2f = sz2f, sf2f = sf2f))

}






expandMat = matrix(nrow = 13, ncol = 13)
shrinkMat = matrix(nrow = 13, ncol = 13)
widenMat = matrix(nrow = 13, ncol = 13)
changeMat = matrix(nrow = 13, ncol = 13)
iMat = matrix(nrow = 13, ncol = 13)
jMat = matrix(nrow = 13, ncol = 13)

loop = order(areas)
i = 1
for(ii in loop) {
	j = 1
	for(jj in loop) {
		lkj = which_effect(tab$fdata, ii,jj)
		expandMat[i,j] = lkj$z2f
		widenMat[i,j] = lkj$f2f
		shrinkMat[i,j] = lkj$f2z
		changeMat[i,j] = areas[jj] - areas[ii]
		iMat[i,j] = i
		jMat[i,j] = j
		j = j + 1
	}
	i = i + 1
}

# want the lower triangle of each of these matrices since I ordered them according to area. Upper triangle is small->large areas.

expand_effect = expandMat[upper.tri(expandMat)]

widen_effect = widenMat[upper.tri(widenMat)]

shrink_effect = shrinkMat[upper.tri(shrinkMat)]

total_effect = changeMat[upper.tri(changeMat)]

is = iMat[upper.tri(iMat)]

js = jMat[upper.tri(jMat)]

# what is the relationship between the different effects, that is to say, which has the greater magnitude in any given situation? what kinds of patterns are there?

#n1 = 6; n2 = 10
#
#jkl = which_effect(tab$fdata, n1, n2)
#
#my_spar = 0.3
#
#brks = seq(0, 750, by = 10)
#
## event 1
#hev1 = hist(jkl$ev1[jkl$ev1f], plot = F, breaks = brks)
#
#sev1 = smooth.spline(c(0,hev1$mids), c(0,hev1$counts), spar = my_spar)
#sev1 = spline(c(0,sev1$x), c(0,sev1$y), n = length(range))
#
## event 2
#hev2 = hist(jkl$ev2[jkl$ev2f], plot = F, breaks = brks)
#
#sev2 = smooth.spline(c(0,hev2$mids), c(0,hev2$counts), spar = my_spar)
#sev2 = spline(c(0,sev2$x), c(0,sev2$y), n = length(range))
#
## zero to full
#hz2f = hist(jkl$ev2[jkl$evz2f], plot = F, breaks = brks)
#
#sz2f = smooth.spline(c(0,hz2f$mids), c(0,hz2f$counts), spar = my_spar)
#sz2f = spline(c(0,sz2f$x), c(0,sz2f$y), n = length(range))
#
## full to full
#hf2f = hist(jkl$ev2[jkl$evf2f], plot = F, breaks = brks)
#
#sf2f = smooth.spline(c(0,hf2f$mids), c(0,hf2f$counts), spar = my_spar)
#sf2f = spline(c(0,sf2f$x), c(0,sf2f$y), n = length(range))
#
## full to full delta
#hf2fdelta = hev2$counts - hz2f$counts - hev1$counts
#
## full to zero
#hf2z = hist(jkl$ev1[jkl$evf2z], plot = F, breaks = brks)

# pairs = data.frame(one = c(5,8,9,10,2,3,6,9,6), two = c(4,7,10,11,3,4,5,8,7))

survs2use = 1:13

combos = t(combn(survs2use, 2))

poi = c()
qwe = c()
ewq = c()
mex = c()
mwi = c()
mon = c()
mtw = c()
fwi = c()
mnb = c()
areaT = c()
deltaQ = c()

areaiop  = c()
whichiop = c()
survs = list(p = c(), q = c())

# combos = pairs

for (j in 1:length(combos[,1])) {
	lower = which.min(c(hltab$Q[combos[j,1]], hltab$Q[combos[j,2]]))
	higher = which.max(c(hltab$Q[combos[j,1]], hltab$Q[combos[j,2]]))
	p = combos[j,lower]
	q = combos[j,higher]
	iop = which_effect(tab$fdata, p, q)
	rew = spline_curves(iop)
	qwe[j] = iop$z2f
	ewq[j] = iop$f2f
	mnb[j] = iop$f2z
	mon[j] = rew$sev1$x[which.max(rew$sev1$y)]
	mtw[j] = rew$sev2$x[which.max(rew$sev2$y)]
	mex[j] = rew$sz2f$x[which.max(rew$sz2f$y)]
	mwi[j] = rew$sf2f$x[which.max(rew$sf2f$y)]
	# fwi[p] = rew$sf2f$y[which.max(rew$sf2f$y)]
	poi[j] = qwe[j] / ewq[j]
	# areaiop[j] = min(areas[p], areas[q])
	areaT[j] = (areas[q] - areas[p])
	deltaQ[j] = (hltab$Q[q] - hltab$Q[p])
	areaiop[j] = (areas[q] - areas[p])/mean(areas[q])
	whichiop[j] = which(areas %in% areas[q])
	survs$p[j] = p
	survs$q[j] = q
	# lines(rew$sev1, col = pal[pairs$one[p]], lwd = 2)
	# lines(rew$sev2, col = pal[pairs$two[p]], lwd = 2)
	# lines(rew$sf2f, col = 'grey65', lwd = 2)
	# lines(rew$sz2f, col = 'grey35', lwd = 2)
}

diffData = tibble(combo = paste0(survs$p-1, '/', survs$q-1), z2f = qwe, f2f = ewq, f2z = mnb) %>% mutate(areaT = z2f + f2f + f2z) %>% bind_cols(runoffDelta = deltaQ)

save(diffData, file = here('data', 'derived_data', 'area_differences.rda'))

latlongexp = list()

survs = order(hltab$Q)
survs = survs[-which(survs %in% c(1,3,4))]
pairs = cbind(survs[-length(survs)], survs[-1])

for (j in 1:length(pairs[,1])) {
	lower = which.min(c(hltab$Q[pairs[j,1]], hltab$Q[pairs[j,2]]))
	higher = which.max(c(hltab$Q[pairs[j,1]], hltab$Q[pairs[j,2]]))
	p = pairs[j,lower]
	q = pairs[j,higher]
	iop = which_effect(tab$fdata, p, q)
	longitudinalEx = iop$ev2[iop$evz2f]
	lateralEx = iop$ev2[iop$evf2f]
	widths = c(longitudinalEx, lateralEx)
	label = c(rep('longitudinal', length(longitudinalEx)), rep('lateral', length(lateralEx)))
	latlongcombo = rep(paste0(p-1, '/', q-1), length(widths))
	deltaQ = rep(hltab$Q[q] - hltab$Q[p], length(widths))
	latlongexp[[j]] = tibble(combo = latlongcombo, label, width = widths, deltaQ = deltaQ)
}

diffDataPoints = bind_rows(latlongexp)

save(diffDataPoints, file = here('data', 'derived_data', 'effect_differences.rda'))

forbiddenCombos = c('0/1','1/0','0/2','0/3','0/4','0/5','0/6','0/7','0/8','0/9','0/10','0/11','0/12','/2','/3','3/', '2/9','2/10','2/6')
permittedCombos =
 c('12/6','12/10','12/9')

# diffDataPoints %>%
# # filter(!(grepl(paste(forbiddenCombos, collapse = '|'), combo)) | grepl(paste(permittedCombos, collapse = '|'), combo)) %>%
# mutate(logWidth = log(width)) %>%
# group_by(combo, label) %>%
# summarize(mu = mean(logWidth), delQ = mean(deltaQ))  %>% ggplot() +
# geom_point(aes(x = delQ, y = mu, color = label)) + theme_minimal() +
# geom_smooth(aes(x = delQ, y = mu, color = label), method = 'lm', se = F)

modelMu = diffDataPoints %>%
mutate(logWidth = log(width), combo = as.factor(combo)) %>%
group_by(combo, label) %>%
summarize(mu = mean(logWidth), delQ = mean(deltaQ))

modelMu = diffDataThree %>% select(combo, areaT, areaDelta, label = 'mode') %>% inner_join(modelMu,., by = c('combo', 'label')) %>% mutate(fraction = areaDelta / areaT)

# modelMu %>% filter(label == 'lateral') %>% ggplot() +
# geom_point(aes(x = delQ, y = fraction, color = label)) + theme_minimal() +
# geom_smooth(aes(x = delQ, y = fraction, color = label), method = 'lm', se = F)
#
# modelMu %>% ggplot() +
# geom_point(aes(x = delQ, y = mu, color = label)) + theme_minimal() +
# geom_smooth(aes(x = delQ, y = mu, color = label), method = 'lm', se = F)

# points(mwi, fwi, pch = 20)


#plot(ewq,qwe, pch = 19, cex = areas[pairs$one]/800)
#abline(a = 0, b = 1)
