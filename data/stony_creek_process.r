# Data In/Out for Stony Creek width and hydrologic data
# Eric Barefoot
# Dec 2017

#	set directories

# reading in the raw data

disch_data = read.csv(here('data', 'derived_data', 'discharge_data.csv'), header = T)
field_data = read.csv(here('data', 'raw_data', 'field_data', 'stony_creek_field_data.csv'), header = T)
event_data = read.csv(here('data', 'raw_data', 'field_data', 'stony_creek_event_data.csv'), header = T)
strm_order = read.csv(here('data', 'raw_data', 'field_data', 'stony_creek_strm_order.csv'), header = T)

# first thing is to extract the survey dates

surveys_start = strptime(event_data$start, format = '%m/%d/%Y %H:%M')
surveys_end = strptime(event_data$end, format = '%m/%d/%Y %H:%M')

date_start = strptime(event_data$start, format = '%m/%d/%Y')
date_start$min = 0
date_start$hour = 0
date_end = strptime(event_data$start, format = '%m/%d/%Y')

for (i in 1:length(date_start)) {
	date_start[i]$min = 0
	date_start[i]$hour = 0
	date_end[i]$min = 59
	date_end[i]$hour = 11
}


# reading in stage and discharge
# rating curve function may need to change over time as Maggie's equations get better

ratecurve = function(a) { b = 0.000001 * (a ^ 3.0684); return(list(x = a, y = b)) }

date = strptime(disch_data$datetime, format = '%m/%d/%Y %H:%M')
just_day = strptime(disch_data$datetime, format = '%m/%d/%Y')
stage = disch_data[,2] + abs(min(disch_data[,2]))
Q = ratecurve(stage)$y
norm_R = Q / 484000
R_mmhr = norm_R * 3600

start_date = strptime('09/01/2015 00:01', format = '%m/%d/%Y %H:%M')
hydro_window = which(as.POSIXct(date) > start_date)

# make a dataframe with the hydrologic information

hydro = data.frame(date,stage,Q,norm_R,R_mmhr)[hydro_window,]

# finding daily mean discharge and discharge during the survey

survey_window = list()			# temporary list holding the indices of each survey.
mean_daily_Q = numeric(0)		# mean daily discharge
label = numeric(0)				# dummy label for each survey in the full list.
mean_survey_Q = numeric(0)		# mean discharge during measurement
rang_survey_Q = numeric(0)		# mean discharge during measurement
ser_survey_Q = numeric(0)		# time series of discharge during event
survey_times = character(0)		# time variable for each event.

low_survey_Q = numeric(0)
hii_survey_Q = numeric(0)

for(i in 1:length(surveys_start)) {
	survey_window[[i]] = which(hydro$date >= surveys_start[i] & hydro$date <= surveys_end[i])
	survey_times = c(survey_times, as.character(hydro$date[survey_window[[i]]]))
	daily_wind = which(hydro$date >= date_start[i] & hydro$date <= date_end[i])
	mean_daily_Q[i] = mean(hydro$Q[daily_wind])
	mean_survey_Q[i] = mean(hydro$Q[survey_window[[i]]])
	rang_survey_Q[i] = diff(range(hydro$Q[survey_window[[i]]]))
	low_survey_Q[i] = range(hydro$Q[survey_window[[i]]])[1]
	hii_survey_Q[i] = range(hydro$Q[survey_window[[i]]])[2]
	ser_survey_Q = c(ser_survey_Q, hydro$Q[survey_window[[i]]])
	label = c(label, rep(i, length(hydro$Q[survey_window[[i]]])))
}

survey_times = strptime(survey_times, format = '%F %T')

survey_date = as.Date(surveys_start)

# tabulating daily mean discharge and dates

event_means = data.frame(survey_date, mean_daily_Q, mean_survey_Q, rang_survey_Q, event_id = event_data$event_id, low_survey_Q,
hii_survey_Q)

# tabulating discharge record separated out by survey day.

surveyQ = data.frame(survey_times, ser_survey_Q, label)

###########################################
## cleaning field data
###########################################

# making a sequence to capture every other column
startcol = which(names(field_data) == 'w00')
lastcol = startcol - 1
widd = startcol
loop = 1:((ncol(field_data) - lastcol)/2)

# makes an empty vector to fill with the orders for each event and makes a list of segment names
orders = strm_order
segs = substr(field_data$flag_id,1,4)
ordered_streams = numeric(nrow(field_data))

#	create a new dataframe and populate the first columns and rename the columns
fdata = data.frame(matrix(ncol = ncol(field_data), nrow = nrow(field_data)))
fdata[,1:lastcol] = field_data[,1:lastcol]
colnames(fdata) = colnames(field_data)

#	for every event::

for (i in loop) {

#	these are the columns we're working on: 'widd' and 'ordd'
	ordd = widd + 1
#	note that ordd is the same as the the percentage column but i keep it this way for clarity
	dryperc = widd + 1
#	change NAs to zero in dry percent column
	field_data[,dryperc][is.na(field_data[,dryperc])] = 0
#	convert widths in inches to centimeters and subtract of dryness percentage
#	then splice it into the fdata frame
	fdata[,widd] = field_data[,widd] * (100-field_data[,dryperc]) * 1/100 * 2.54
#	make a vector of the orders and splice it into the fdata frame
	for (k in 1:nrow(orders)) {
		spots = which(segs %in% orders[k,1])
		ordered_streams[spots] = orders[k,(i+1)]
	}
	fdata[,ordd] = ordered_streams
#	name the columns appropriately
	if ((i-1) < 10) {
		colnames(fdata)[widd] = paste0('w0',(i-1))
		colnames(fdata)[ordd] = paste0('ord0',(i-1))
	} else if ((i-1) >= 10) {
		colnames(fdata)[widd] = paste0('w',(i-1))
		colnames(fdata)[ordd] = paste0('ord',(i-1))
	}

#	move to next width column in field_data
	widd = widd + 2
}

#move slope column to the end just in case there's a conflict later
sidx = grep('slope', names(fdata))

fdata = fdata[, c((1:ncol(fdata))[-sidx], sidx)]
names(fdata)

#	make a list of the names for each general data structure. then list all the data together under 'tab'
tab_names = c('fdata','hydro','event_means','surveyQ','orders')
tab = list(fdata,hydro,event_means,surveyQ,orders)
names(tab) = tab_names

#	export em all as .csv files for sharing
for(i in 1:length(tab)) {
	write.csv(tab[[i]], file = here('data', 'derived_data', paste0(tab_names[i], '.csv')), row.names = F)
}

#	also save as an RDATA file for easy and fast retrieval
save(tab,tab_names, file = here('data', 'derived_data', 'tab_data.rda'))
























#######################################################
### George's date manipulation code
#######################################################

#
# if (usgsFlag[i] == 'stony'){ # stony 5 min interval records:
#
#           # converted original xls file to csv in excel and renamed as "daily.csv"
#           qTab = read.csv(paste0(qTabPaths[i], '.csv'), header=T)
#           hourlyQ = qTab$ Water.Level..mm
#
#           split = strsplit(as.vector(qTab$TIMESTAMP), ' ')
#           allDates = rep(NA, nrow(qTab))
#           for (j in 1:length(split)){
#             allDates[j] = split[[j]][1]
#           }
#
#           # average daily Q:
#           dates = unique(allDates)
#           q = dates
#           for(j in 1:length(dates)){
#             q[j] = mean(hourlyQ[dates[j] == allDates], na.rm=T)
#           }
#
#           q = as.numeric(q)
#
#           fieldQ = q[match(fieldDates[i,], dates)]
#
#           cdf = ecdf(q)
#           cdfRange = range(100*cdf(fieldQ), na.rm=T)
#           cdfMean = mean(cdfRange)
#           oTab$Q[i] = paste0(round(cdfMean, 2), '+/-', round(cdfMean-cdfRange[1], 2))
#           oTab$QRecLength_yrs[i] =  round(length(q)/365, 2)
#
#         }
#
#####################################################
