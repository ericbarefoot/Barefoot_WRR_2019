#	calculating measurement error at Stony Creek
#	Eric Barefoot
#	July 2018

#	load data

#	first, scan in the csv file.

err = read.csv(here('data', 'raw_data', 'field_data', 'stony_creek_error_estimation.csv'))

#	now, isolate just the measurements in a matrix

err_matrix = as.matrix(err[,8:12]) * 2.54

std_dev = apply(err_matrix, 1, sd)

std_err = apply(err_matrix, 1, sd) / sqrt(5)

men_width = apply(err_matrix, 1, mean)

avg_std_dev = mean(std_dev)
avg_std_err = mean(std_err)




###	Here's a demonstrative plot

#y = (1:35) * 40
#
#plot(1:5, seq(1, (35*40), length = 5), type = 'n', ann = F, axes = F)
#
#abline(v = 1, col = 'grey')
#
#for (i in 1:35) {
#	errr = err_matrix[i,] - mean(err_matrix[i,]) + y[i]
#	abline(h = y[i], col = 'grey')
#	lines(1:5, errr, type = 'b', pch = 19)
#}
