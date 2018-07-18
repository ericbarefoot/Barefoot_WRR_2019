# 	Calculating K-S statistics for the distributions in the stony creek study.
# 	Eric Barefoot
# 	May 2016

ksstats <- c()
kspvals <- c()
surv_names <- names(tab$fdata)[grep("w", names(tab$fdata))]

# loop through starting with the second one because we're ignoring the first survey now.

k <- 1
for (i in 1:length(widths)) {

  # get the mlog and sdlog values for this lognormal distribution fit.

  this_meanlog <- lognorms[[i]]$estimate[1]
  this_sdlog <- lognorms[[i]]$estimate[2]

  # prep variables for ECDF plot

  sort.widds <- sort(widths[[i]])
  n <- length(widths[[i]])
  probs <- (1:n) / n

  # construct CDF for corresponding lognormal distribution

  rrr <- seq(min(widths[[i]]), max(widths[[i]]), by = 0.05)
  theor <- plnorm(rrr, this_meanlog, this_sdlog)

  # do KS test and export statistics.

  ksstats[k] <- ks.test(widths[[i]], "plnorm", this_meanlog, this_sdlog)$statistic
  kspvals[k] <- ks.test(widths[[i]], "plnorm", this_meanlog, this_sdlog)$p.value

  k <- k + 1
}
