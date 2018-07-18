# distances between points with nearest neighbor approximation
# accepts two matrices as inputs, with columns x and y
# Eric Barefoot
# May 2016

#####################

nearest_xy = function(A, X, to = 1, plot = F) {

	allx = c(A[,1][!is.na(A[,1])], X[,1][!is.na(X[,1])])
	ally = c(A[,2][!is.na(A[,2])], X[,2][!is.na(X[,2])])
	
	# no NAs
	
	X = X[!is.na(X[,1]),]
	A = A[!is.na(A[,1]),]
	
	Z = as.matrix(dist(rbind(X,A)))

	aseq = ((length(X[,1])+1):length(c(X[,1],A[,1]))); xseq = (1:(length(X[,1])))

	Z = Z [ aseq , xseq ]

	# so now have distances between every point in each xy dataset. now pick which set to choose the nearest neighbor 

	# if the A dataset is the one to match to...
	if (to == 1) {
		v = apply(Z, 1, 'min')

		j = 1
		m = c()
		for (i in aseq) {
			jkl = Z[j,]
			lkj = which(jkl %in% v[j])[1]
			m[j] = lkj
			j = j + 1
		}

		S = cbind(A,X[m,])
	}

	# if the X dataset is the one to match to...

	else if (to == 2) {
		v = apply(Z, 2, 'min')

		j = 1
		m = c()
		for (i in xseq) {
			jkl = Z[,j]
			lkj = which(jkl %in% v[j])[1]
			m[j] = lkj
			j = j + 1
		}

		S = cbind(X,A[m,])
	}

	else {stop('pick a variable to match to.')}
	
	if (plot == T) {
		par(bg = 'grey90')
		plot(S[,1], S[,2], type = 'n', ylim = c(min(ally), max(ally)), xlim = c(min(allx), max(allx)), asp = 1)

		points(X[,1], X[,2], col = 'black', pch = 20)
		points(A[,1], A[,2], col = 'blue3', pch = 20)

		points(S[,3], S[,4], col = 'red3', pch = 1, cex = 1.5)

		segments(S[,1], S[,2], S[,3], S[,4], col = 'red3', lty = 3)
	} else { }
	
	return(list(A = A, X = X, S = S))
	
}



