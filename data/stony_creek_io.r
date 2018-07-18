# Scanning in existing datasets
# Eric Barefoot
# November 2015

dd = here('data','derived_data')
tab_names = c('fdata','hydro','event_means','surveyQ','orders')
tab = list()
for(i in 1:length(tab_names)) {
	tab[[i]] = read.csv(paste0(dd, '/', tab_names[i], '.csv'))
}
names(tab) = tab_names
