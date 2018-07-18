#	calculating percentiles of flow. Based on data from Bolin Creek.
#	Eric Barefoot
#	May 2016
bd = file.path(pd, 'data', 'raw_data', 'hydro_data', 'bolin')

#	load functions
require(lubridate)
source(file.path(fund,'percentiles.r'))

#	read in bolin creek data

bolin = read.csv(file.path(bd,'bolin_2012_2017.csv'), header = T, skip = 34)

# 	relevant columns names from bolin creek data. daily data.
#	min		X86324_00060_00001
#	mean	X86325_00060_00002
#	max		X86326_00060_00003

survs = parse_date_time(tab$event_means$survey_date, 'ymd')

dates = parse_date_time(bolin$datetime, 'mdy')

ss = which(dates %in% survs)

qq = bolin$X86325_00060_00002

MQS = qq[c(ss,tail(ss,1))]

pers = perc_func(qq, MQS)

#pers = data.frame(survs, pers)

# 	used this to explore whether percentiles from mean, min or max was best. picked mean. 

#	colz = c('X86324_00060_00001','X86325_00060_00002','X86326_00060_00003')
#
#	for(i in 1:3) {
#		qq = bolin[,colz[i]]
#		percs[[i]] = perc_func(qq, MQS)[,2]
#	}
#
#	plot(1:13, 1:13, xlim = c(1,13), ylim = c(30,100))
#	for (i in 1:3) {
#		cc = c('blue','red','black')
#		lines(1:13,percs[[i]], col = cc[i])
#	}

## back when I was calculating percentiles from just our record of discharge.

#	## pull in the original data
#	wd = paste0(pd, 'data/digested/')
#		disch_data = read.csv(paste0(pd, 'data/digested/discharge_data.csv'), header = T)
#
#
#	ratecurve = function(a) { b = 0.000001 * (a ^ 3.0684); return(list(x = a, y = b)) }
#
#	date = strptime(disch_data$datetime, format = '%m/%d/%Y %H:%M')
#	just_day = strptime(disch_data$datetime, format = '%m/%d/%Y')
#	stage = disch_data[,2] + abs(min(disch_data[,2]))
#	Q = ratecurve(stage)$y
#
#	## calculate daily mean Q
#
#	hourlyQ = Q
#
#	split = strsplit(as.character(just_day), ' ')
#	allDates = rep(NA, length(Q))
#	for (j in 1:length(split)){
#		allDates[j] = split[[j]][1]
#	}
#
#	# average daily Q:
#	dates = unique(allDates)
#	q = dates
#	for(j in 1:length(dates)){
#		q[j] = mean(hourlyQ[dates[j] == allDates], na.rm=T)
#	}
#
#	q = as.numeric(q)
#
#	mQs = tab$event_means$mean_survey_Q
#
#	old_pers = perc_func(q,mQs)
#
#
#	comp = cbind(pers[,3], old_pers[,2])