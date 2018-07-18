#	This runs through the parameter space of my hortonion network distribution generator, picking a broader-than-typical range for each of the critical ratios.
#	Eric Barefoot
#	Feb 2016

source(paste0(pd,'analysis/dist_stochastic_model/dist_modeling.r'))
wd = paste0(pd,'figures/')
setwd(wd)
outd = paste0(pd, 'figures/outputs/')


## Here is a middle-of-the-road-parameter space

space_o = list(
	order = 3, 
	Rb = 5,		
	Rl = 2,		
	Ra = 5,		
	b = 0.50,
	f = 0.40,	
	m = 0.10,	
	a = 1.00,
	c = 0.10,	
	k = 0.75,	
	N = 200,
	L = 10,
	A = 50,
	variance = c(45,90,150)
)

#test = hort_generator(p_space, plot = T)

## This series of plots systematically varies the bifurcation ratio

figout = paste0(outd,'model_runs_Rb.pdf')

pdf(figout, width = 30, height = 15)

par(mfrow = c(2,6))

stored_vals = c()

Rb = seq(3, 5, length = 10)

l = 1
for (i in 1:10) {
	space_o$Rb = Rb[i]
	stored_vals[l] = hort_generator(space_o, plot = T)$all_mds
	l = l + 1
}

plot(Rb, stored_vals, pch = 19, main = 'Modal widths by Rb', xlab = 'Rb values', ylab = 'Modal Width')

dev.off()

cmd = paste('open', figout); system(cmd)

#######

## This series of plots systematically varies the length ratio

figout = paste0(outd,'model_runs_Rl.pdf')

pdf(figout, width = 30, height = 15)

par(mfrow = c(2,6))

stored_vals = c()

Rl = seq(1.5, 3.5, length = 10)

l = 1
for (i in 1:10) {
	space_o$Rl = Rl[i]
	stored_vals[l] = hort_generator(space_o, plot = T)$all_mds
	l = l + 1
}

plot(Rl, stored_vals, pch = 19, main = 'Modal widths by Rl', xlab = 'Rl values', ylab = 'Modal Width')

dev.off()

cmd = paste('open', figout); system(cmd)


## This series of plots systematically varies the area ratio

figout = paste0(outd,'model_runs_Ra.pdf')

pdf(figout, width = 30, height = 15)

par(mfrow = c(2,6))

stored_vals = c()

Ra = seq(4,6, length = 10)

l = 1
for (i in 1:10) {
	space_o$Ra = Ra[i]
	stored_vals[l] = hort_generator(space_o, plot = T)$all_mds
	l = l + 1
}

plot(Ra, stored_vals, pch = 19, main = 'Modal widths by Ra', xlab = 'Ra values', ylab = 'Modal Width')

dev.off()

cmd = paste('open', figout); system(cmd)







