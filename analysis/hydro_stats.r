##	Calculating the basic hydrological stats based on WS1 data
##	Eric Barefoot
# July 2018

##	Total Runoff

# wd = getwd()
#
# pd = file.path(wd, '..')
#
# dd = file.path(pd, 'data', 'derived_data', 'digested')

#	functions

source(here('analysis', 'functions', 'disch_conv.r'))

#	mean daily discharge

#	pull in the original data

disch_data = read.csv(here('data', 'raw_data', 'hydro_data', 'discharge_data.csv'), header = T)

ratecurve = function(a) { b = 0.000001 * (a ^ 3.0684); return(list(x = a, y = b)) }

date = strptime(disch_data$datetime, format = '%m/%d/%Y %H:%M')
just_day = strptime(disch_data$datetime, format = '%m/%d/%Y')
stage = disch_data[,2] + abs(min(disch_data[,2]))
Q = ratecurve(stage)$y

## calculate daily mean Q

hourlyQ = Q

split = strsplit(as.character(just_day), ' ')
allDates = rep(NA, length(Q))
for (j in 1:length(split)){
	allDates[j] = split[[j]][1]
}

# average daily Q:
dates = unique(allDates)
q = dates
for(j in 1:length(dates)){
	q[j] = mean(hourlyQ[dates[j] == allDates], na.rm=T)
}

q = as.numeric(q)

q = disch_conv(q,48.4)

q_m = mean(q)

##	Total Precip

#	read in data

# precip = read.csv(file.path(dd, 'precip_eno.csv'), header = T)

##	Total Evapo
