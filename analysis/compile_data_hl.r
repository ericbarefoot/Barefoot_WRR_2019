#	recalculating all the major statistics without survey one and compiling everything into one table. also tagging events as high or low depending on a dynamic threshold
#	Eric Barefoot
# July 2018

# wd = getwd()
#
# #pd = file.path(wd, '..', '..')
# pd = "/Users/ericfoot/Dropbox/research/headwater_stream_widths"
#
# ad = file.path(pd, 'analysis')
#
# dd = file.path(pd, 'data')
#
# ddd = file.path(pd, 'data', 'derived_data', 'digested')
#
# fund = file.path(ad, 'functions')

# Load functions

source(here::here('analysis', 'functions', 'percentiles.r'))

# Load previous calcuations

load(here::here('data', 'derived_data', 'tab_data.rda'))

source(here::here('analysis', 'dist_basics.r'))

source(here::here('analysis', 'flowing_ratio.r'))

source(here::here('analysis', 'functions', 'disch_conv.r'))

source(here::here('analysis', 'percentile_calc.r'))

source(here::here('analysis', 'ks_stats.r'))

#	and some previous data

drain_dens = read.csv(here::here('data', 'derived_data', 'drain_dates.csv'))[,1]

# function for labeling events as high or low

hl_cut_perce = 80	# this is the cutoff percentile

hl_cut_ratio = 90	# this is the cutoff zero/notz ratio

hl_cutoff = function(stat, flavor = c('percentile','flowing ratio'), pers, flow_rat) {
	tags = c()

	flavors = c('percentile','flowing ratio')
	flav = flavors[grep(flavor, flavors)]

	if (flav == 'percentile') {
		for (i in 1:nrow(pers)) {
			if (pers[,2][i] >= stat) {
				tags[i] = 2
			} else {
				tags[i] = 1
			}
		}
	}

	if (flav == 'flowing ratio') {
		for (i in 1:length(flow_rat)) {
			if (flow_rat[i] >= stat) {
				tags[i] = 2
			} else {
				tags[i] = 1
			}
		}
	}
	return(tags)
}

# hl_cutoff(0.8, flavor = 'flow', flow_rat = flow_rat)

# compile all the different stats into a database. !!this is different than the way I did it this way before!! we have surveys as rows and variables as columns. so w01 is a row and spline mode is a col.

mQs = disch_conv(q = tab$event_means$mean_survey_Q, area = 48.4)

length(flow_rat)

hltab = data.frame(
	names = names(tab$fdata)[grep('w', names(tab$fdata))],
	date = survs,
	Q = mQs,
	percs = pers[,2],
	areas = areas,
	lengs = lengs,
	ratio = flow_rat,
	modes = mdspl,
	means = wbar,
	siggs = wsig,
	inter = wiqr,
	peaks = fdspl,
	kdmod = md,
	lgmod = mdl,
	kdpek = fd,
	lgpek = fdl,
	kstat = ksstats,
	kspvl = kspvals,
	hltag = hl_cutoff(hl_cut_perce, flavor = 'perc', pers = pers),
	seeps = mQs/areas,
	numbs = lengs/5,
	drain = c(0,drain_dens),
	aspec = lengs/(wbar/100)
)

#hltab = hltab[-1,]

# things I want to add: (16 things)
#	Q - discharge during event
#	percs - percentile of flow
#	areas - total area
#	lengs - flowing ratio
#	ratio - total length
#	modes - mode - spline fit
#	means - mean width
#	siggs - standard deviation of width
#	inter - IQR of width
#	peaks - peak - spline fit
#	kdmod - mode - kernal density
#	lgmod - mode - lognormal density
#	kdpek - peak - kernal density
#	lgpek - peak - lognormal density
#	kstat - k-s statistics
#	kspvl - k-s pvalues
#	hltag - high or low tag

surv_names = names(tab$fdata)[grep('w', names(tab$fdata))]#[-1]

row.names(hltab) = surv_names

	# save it to the data bank.

save(hltab, file = here::here('data', 'derived_data', 'high_low_table.rda'))
write.csv(hltab, file = here::here('data', 'derived_data', 'high_low_table.csv'))
