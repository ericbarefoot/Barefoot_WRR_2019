# These are the calculations used for making any of the figures, namely calculating lognormal distributions etc.
# Eric Barefoot
# July 2018

# find the first data column and find the overall mean of all non-zero measurements
col1 <- which(names(tab$fdata) == "w00")
widds <- seq(col1, length(tab$fdata), by = 2)
allwidths <- as.numeric(unlist(tab$fdata[, widds]))
allnozero <- allwidths[!(allwidths == 0)]
ovmean <- mean(allnozero, na.rm = T)

# need this for fitting lognormal distributions
require(MASS)

# make a list where each element is a vector of widths with zeros removed. Also find the total surface area and total length

widths <- list()
areas <- c()
lengs <- c()
k <- col1
for (i in 1:nrow(tab$event_means)) {
  widths[[i]] <- tab$fdata[, k][which(tab$fdata[, k] != 0)]
  areas[i] <- sum(widths[[i]]) * 5 / 100
  lengs[i] <- length(widths[[i]]) * 5
  k <- k + 2
}

Q <- tab$event_means$mean_survey_Q

# 	set histogram and density plot ranges and break points
brks <- seq(0, 1100, by = 10)
range <- seq(0, 1100, by = 1)

# 	here are all the lists that we will fill with data
dens <- list()
hists <- list()
facs <- list()
lognorms <- list()
dlnorms <- list()
spl <- list()
md <- c()
mdl <- c()
mdspl <- c()
fd <- c()
fdl <- c()
fdspl <- c()
wbar <- c()
wsig <- c()
wiqr <- c()

# 	one problem is that density picks it's own bandwidths. so we need to adjust for that by computing all of them then picking a mean.

bws <- c()

for (i in 1:length(widths)) {
  bws[i] <- density(widths[[i]], bw = "SJ")$bw
}

my_bw <- mean(bws)

# my_bw = "nrd0"

# smoothing for spline
my_spar <- 0.3

# 	now we fill them with data!
for (i in 1:length(widths)) {
  dens[[i]] <- density(widths[[i]], bw = my_bw)
  hists[[i]] <- hist(widths[[i]], plot = F, breaks = brks)
  facs[[i]] <- hists[[i]]$counts / hists[[i]]$density
  facs[[i]] <- mean(facs[[i]], na.rm = T)
  lognorms[[i]] <- fitdistr(widths[[i]], "lognormal")
  dlnorms[[i]] <- dlnorm(range, meanlog = lognorms[[i]]$estimate[1], sdlog = lognorms[[i]]$estimate[2])
  spl[[i]] <- smooth.spline(c(0, hists[[i]]$mids), c(0, hists[[i]]$counts), spar = my_spar)
  spl[[i]] <- spline(c(0, spl[[i]]$x), c(0, spl[[i]]$y), n = length(range))
  mdl[i] <- range[which.max(dlnorms[[i]])]
  md[i] <- dens[[i]]$x[which.max(dens[[i]]$y)]
  mdspl[i] <- spl[[i]]$x[which.max(spl[[i]]$y)]
  fd[i] <- max(dens[[i]]$y * facs[[i]])
  fdl[i] <- max(dlnorms[[i]] * facs[[i]])
  fdspl[i] <- max(spl[[i]]$y)
  wbar[i] <- mean(widths[[i]], na.rm = T)
  wsig[i] <- sd(widths[[i]], na.rm = T)
  wiqr[i] <- IQR(widths[[i]], na.rm = T)
}

names(widths) <- names(tab$fdata)[grep("w", names(tab$fdata))]

## 	now need to do the whole thing except by order

widths_by_ord <- list()

k <- col1

# 	split each event into orders and store in a list
for (i in 1:nrow(tab$event_means)) {
  ord_step <- list()
  for (j in 1:max(tab$fdata[, k + 1], na.rm = T)) {
    ord_step[[j]] <- tab$fdata[, k][which(tab$fdata[, k] != 0 & tab$fdata[, k + 1] == j)]
  }
  widths_by_ord[[i]] <- ord_step
  k <- k + 2
}

# 	set the same breaks and ranges as before
brks <- seq(0, 1100, by = 10)
range <- seq(0, 1100, by = 1)

# 	again, this is our list of lists to fill with data. each one will have an additional level, breaking it down into orders
dens_by_ord <- list()
hists_by_ord <- list()
facs_by_ord <- list()
lognorms_by_ord <- list()
dlnorms_by_ord <- list()
md_by_ord <- list()
mdl_by_ord <- list()
spline_by_ord <- list()
mdspl_by_ord <- list()
fd_by_ord <- list()
fdl_by_ord <- list()
fspl_by_ord <- list()

# 	the outer loop takes the inner loop products and puts em into a list
for (i in 1:length(widths_by_ord)) {
  ord_step_dens <- list()
  ord_step_hist <- list()
  ord_step_facs <- list()
  ord_step_lognorms <- list()
  ord_step_dlnorms <- list()
  ord_step_md <- c()
  ord_step_mdl <- c()
  ord_step_mdspl <- c()
  ord_step_spline <- list()
  ord_step_fd <- c()
  ord_step_fdl <- c()
  ord_step_fspl <- c()

  # 		this loop goes through each order, calculates the stats and stores em in a list, which is then put into the bigger lists.

  for (j in 1:length(widths_by_ord[[i]])) {
    ord_step_dens[[j]] <- density(widths_by_ord[[i]][[j]], bw = my_bw)
    ord_step_hist[[j]] <- hist(widths_by_ord[[i]][[j]], plot = F, breaks = brks)
    ord_step_facs[[j]] <- ord_step_hist[[j]]$counts / ord_step_hist[[j]]$density
    ord_step_facs[[j]] <- mean(ord_step_facs[[j]], na.rm = T)
    ord_step_lognorms[[j]] <- fitdistr(widths_by_ord[[i]][[j]], "lognormal")
    ord_step_dlnorms[[j]] <- dlnorm(range, meanlog = ord_step_lognorms[[j]]$estimate[1], sdlog = ord_step_lognorms[[j]]$estimate[2])
    ord_step_md[j] <- ord_step_dens[[j]]$x[which.max(ord_step_dens[[j]]$y)]
    ord_step_mdl[j] <- range[which.max(ord_step_dlnorms[[j]])]
    ord_step_spline[[j]] <- smooth.spline(c(0, ord_step_hist[[j]]$mids), c(0, ord_step_hist[[j]]$counts), spar = my_spar)
    ord_step_spline[[j]] <- spline(c(0, ord_step_spline[[j]]$x), c(0, ord_step_spline[[j]]$y), n = length(range))
    ord_step_mdspl[j] <- ord_step_spline[[j]]$x[which.max(ord_step_spline[[j]]$y)]
    ord_step_fd <- which.max(ord_step_dens[[j]]$y * ord_step_facs[[j]])
    ord_step_fdl <- which.max(ord_step_dlnorms[[j]] * ord_step_facs[[j]])
    ord_step_fspl <- which.max(ord_step_spline[[j]]$y)
  }

  dens_by_ord[[i]] <- ord_step_dens
  hists_by_ord[[i]] <- ord_step_hist
  facs_by_ord[[i]] <- ord_step_facs
  lognorms_by_ord[[i]] <- ord_step_lognorms
  dlnorms_by_ord[[i]] <- ord_step_dlnorms
  md_by_ord[[i]] <- ord_step_mdl
  mdl_by_ord[[i]] <- ord_step_mdl
  spline_by_ord[[i]] <- ord_step_spline
  mdspl_by_ord[[i]] <- ord_step_mdspl
  fd_by_ord[[i]] <- ord_step_fd
  fdl_by_ord[[i]] <- ord_step_fdl
  fspl_by_ord[[i]] <- ord_step_fspl
}
