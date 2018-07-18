## Generating a plot for the exxon talk on Sep 9 
## This plot shows the difference between power-law and lognormal assumptions about width distributions. 
## and then compares them to real data.
## Eric Barefoot
## Sep 2016

wd = paste0(pd, 'analysis/')
source(paste0(wd, 'dist_basics.r'))

# functions

pareto.MLE <- function(X)
{
   n <- length(X)
   m <- min(X)
   a <- n/sum(log(X)-log(m))
   return( c(m,a) ) 
}

# calculations

w = widths[[13]]

paret_param = pareto.MLE(w[w>38])

xm = paret_param[1]

al = paret_param[2]

xx = 0:550

paret_pdf = (al * xm ^ al)/(xx^(al+1))

# reassignments

the_hist = hists[[13]]

the_pow = paret_pdf * facs[[13]]

the_log = dlnorms[[13]] * facs[[13]]

# plotting

wd = paste0(pd, 'figures/outputs/')

png(paste0(wd, 'compare_power_log.png'), 8, 6, res = 300, units = 'in')

#par(mfrow = c(1,2), pch = 19)

# plot, linear space

plot(the_hist, col = 'grey45', border = NA, xlim = c(0,500), ylim = c(0,150), ann = F)

lines(xx, the_pow, col = 'red3', lwd = 2)

lines(range, the_log, col = 'blue3', lwd = 2)

title(main = '', xlab = 'Width (cm)', ylab = 'Frequency')

legend('topright', legend = c('Power-law Model', 'Lognormal Model') , bty = 'n', lwd = c(2,2), col = c('red3','blue3'))

dev.off()
