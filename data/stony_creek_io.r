# Scanning in existing datasets
# Eric Barefoot
# November 2015

wd = paste0(pd, 'data/digested/outputs/')
tab_names = c('fdata','hydro','event_means','surveyQ','orders')
tab = list()
for(i in 1:length(tab_names)) {
	tab[[i]] = read.csv(paste0(wd, tab_names[i], '.csv'))
}
names(tab) = tab_names


