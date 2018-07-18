#	function to perform box-counting to determine fractal dimension on a set of XY points
#	Eric Barefoot 
#	Feb 2016

#	first, some dummy data

#dat = data.frame(x = runif(20), y = runif(20))
#
#dat = data.frame(x = 1:20, y = (1:20)*0.35) 
#
#dat = data.frame(x = tab$fdata$easting, y = tab$fdata$northing)
#
#subset = which(!is.na(dat))
#ll = length(subset)/2
#dat = dat[subset[1:ll],]
#
#
#plot(1:100,1:100)
#
#dat = data.frame(x = 1:100, y = 100:1)
#
#plot(dat)
#
#daat = locator(225, type = 'p', pch = 20)
#
#dat = daat
#
#its = 8

boxcount = function(dat, its, plot = F) {

	A = matrix(0, nrow = 2^its, ncol = 2^its)

	bounds = c(min(dat$x),max(dat$x),min(dat$y),max(dat$y))
	deltx = max(dat$x)-min(dat$x); delty = max(dat$y)-min(dat$y); diffxy = abs(deltx - delty)

	if (delty > deltx) {
		bounds[1] = bounds[1] - 0.75*diffxy
		bounds[2] = bounds[2] + 0.75*diffxy
		bounds[3] = bounds[3] - 0.25*diffxy
		bounds[4] = bounds[4] + 0.25*diffxy
	} else if (delty < deltx) {
		bounds[1] = bounds[1] - 0.25*diffxy
		bounds[2] = bounds[2] + 0.25*diffxy
		bounds[3] = bounds[3] - 0.75*diffxy
		bounds[4] = bounds[4] + 0.75*diffxy
	} else {}

	dx = (bounds[2]-bounds[1])/dim(A)[1]; dy = dx; ddx = cumsum(c(0,rep(dx,2^its))); ddy = cumsum(c(0,rep(dx,2^its)))

	boxes = data.frame(x = bounds[1] + ddx, y = bounds[4] - ddy)

	for (j in 1:length(boxes$x)) {
		for (i in 1:length(boxes$y)) {
			tx = boxes$x[j+1]
			bx = boxes$x[j]
			ty = boxes$y[i]
			by = boxes$y[i+1]

			haspoints = which(dat$x >= bx & dat$x < tx & dat$y >= by & dat$y < ty)
	#		print(haspoints)
			if (length(haspoints) != 0) { A[i,j] = 1 }
			else {}		
		}
	}


	#par(mfrow = c(3,3))

	nboxes = integer(its)
	scales = numeric(its)
	rrat = numeric(its)

	for(j in 1:its) {

		m = dim(A)[1]
		n = m/2

		B = matrix(0, nrow = n, ncol = m)

		k = 1
		for (i in 1:n) {
			B[i,c(k,k+1)] = 1
			k = k + 2 
		}

		A = B %*% A %*% t(B)

		for(i in 1:length(A)) {
			if (A[i] != 0) {A[i] = 1}
			else {}
		}

	# 	image(A, asp = 1, col = grey(c(1,0)))
	# 	title(main = j+1)

		rrat[j] = length(which(A == 0))/length(A)

		nboxes[j] = length(which(A != 0))

		scales[j] = 1/2^(its - j)
	}

	output = data.frame(s = log(1/scales), n = log(nboxes))
	modd = lm(output$n~output$s)
	dimm = modd$coefficients['output$s']

	if (plot == T) {
		par(mfrow = c(1,1))
		plot(output, type = 'n')
		grid()
		abline(a = 0, b = 1, lty = 3, col = 'grey')
		points(output, type = 'b', pch = 19)
		abline(modd, lty = 2, col = 'red3')
	} else {}
	
	
	return(info = list(nboxes = nboxes, scales = scales, output = output, modd = modd, dimm = dimm))
}




#	testing out the new algorithm

#nboxes
#scale
#
#par(mfrow = c(1,1))
#
#plot(log(1/scale), log(nboxes), type = 'n')
#grid()
#points(log(1/scale), log(nboxes), type = 'b', pch = 19)
#abline(a = 0, b = 1, lty = 3, col = 'red3')
#
#jkl = boxcount2(daat, 6, T)
#
#poi = jkl$output[c(3,4,5,6,7),]
#mod = lm(poi$n~poi$s)
#abline(mod, col = 'blue3', lty = 2)
#
#iop = jkl$output[c(3,4,5,6),]
#mo = lm(iop$n~iop$s)
#abline(mo, col = 'green3', lty = 2)

















# this was the old algorithm that took a lot of time to do.

#boxcount = function(dat,its) {
#	
#	# Here's a function to draw boxes on a plot
#
#	drawbox = function(boxx, color = 'black', lty = 1, tofill = F, fillcol = 'lightgrey') {
#		#	where box is a variable with x1x2y1y2
#		if (tofill == T) {
#			rect(boxx$x1,boxx$y1,boxx$x2,boxx$y2, col = fillcol)		
#			segments(boxx$x1,boxx$y1,boxx$x2,boxx$y1, col = color, lty = lty)
#			segments(boxx$x1,boxx$y2,boxx$x2,boxx$y2, col = color, lty = lty)
#			segments(boxx$x1,boxx$y1,boxx$x1,boxx$y2, col = color, lty = lty)
#			segments(boxx$x2,boxx$y1,boxx$x2,boxx$y2, col = color, lty = lty)
#		} else {
#			segments(boxx$x1,boxx$y1,boxx$x2,boxx$y1, col = color, lty = lty)
#			segments(boxx$x1,boxx$y2,boxx$x2,boxx$y2, col = color, lty = lty)
#			segments(boxx$x1,boxx$y1,boxx$x1,boxx$y2, col = color, lty = lty)
#			segments(boxx$x2,boxx$y1,boxx$x2,boxx$y2, col = color, lty = lty)
#		}
#	}
#	
#
#	#	first, figure out what the boundaries are around the data, and make them into a square
#
#	bounds = c(min(dat$x),max(dat$x),min(dat$y),max(dat$y))
#	deltx = max(dat$x)-min(dat$x); delty = max(dat$y)-min(dat$y); diffxy = abs(deltx - delty)
#
#	if (delty > deltx) {
#		bounds[1] = bounds[1] - 0.75*diffxy
#		bounds[2] = bounds[2] + 0.75*diffxy
#		bounds[3] = bounds[3] - 0.25*diffxy
#		bounds[4] = bounds[4] + 0.25*diffxy
#	} else if (delty < deltx) {
#		bounds[1] = bounds[1] - 0.25*diffxy
#		bounds[2] = bounds[2] + 0.25*diffxy
#		bounds[3] = bounds[3] - 0.75*diffxy
#		bounds[4] = bounds[4] + 0.75*diffxy
#	} else {}
#
##	boxes = data.frame(rbind(bounds)); colnames(boxes) = c('x1','x2','y1','y2')
#
#	s = 1	#initial value
#	
#	nboxes = integer()
#
#	scales = double()
#
#	pb = txtProgressBar(0,4^(its-1))
#	k = 0
#	
#	boxesA = data.frame(x1 = numeric(4^its), x2 = numeric(4^its), y1 = numeric(4^its), y2 = numeric(4^its))
##	boxesB = data.frame(x1 = numeric(4^its), x2 = numeric(4^its), y1 = numeric(4^its), y2 = numeric(4^its))
#
#	boxesA[1,] = bounds
#	
#	for (j in 1:its) {
#
#		haspoints = logical()
#
#		newboxes = list()
#
#		# 	write method for testing presence of data in box. and now write that truth value to a vector for each box in our counting scheme
#
##		plot(dat, pch = 19, asp = 1, xlim = lims$x, ylim = lims$y)
#		
#		p = 1
#
#		for (i in 1:(4^(j-1))) {
#
#			x1 = boxesA$x1[i]; x2 = boxesA$x2[i]; y1 = boxesA$y1[i]; y2 = boxesA$y2[i]
#
#			if (length(which(dat$x >= x1 & dat$x < x2 & dat$y >= y1 & dat$y < y2)) != 0) {
#				haspoints[i] = T
##				drawbox(boxesA[i,], tofill = T)
#			} else {
#				haspoints[i] = F
#			}
#
#		#	now we have to split the boxes into four (starting from lower left and going clockwise)
#
#			dx = abs(x2-x1); dy = abs(y2-y1)
#			x3 = x1+dx/2; y3 = y1+dy/2
#
##			booxes = list(box1 = c(x1,x3,y1,y3), box2 = c(x1,x3,y3,y2), box3 = c(x3,x2,y3,y2), box4 = c(x3,x2,y1,y3))
#			
#			box1 = c(x1,x3,y1,y3)
#			box2 = c(x1,x3,y3,y2)
#			box3 = c(x3,x2,y3,y2)
#			box4 = c(x3,x2,y1,y3)
#			
##			for (l in 1:4) {
##				boxesB[p+l,] = booxes[[l]]
##			}
##			
#
#			newboxes[[i]] = data.frame(rbind(box1, box2, box3, box4)); colnames(newboxes[[i]]) = c('x1','x2','y1','y2')
#			k = k + 1
#			setTxtProgressBar(pb,k)
#			p = p + 4
#		}
#
##		boxslots = seq(1,4^j, by = 4)
##		boxsloti = 1:length(boxslots)
#		
#		nboxes[j] = length(which(haspoints == T))
#
##		l = 1
##		for (i in boxslots) {
##			for(rr in 0:3) {
##				boxes[i+rr,] = newboxes[[l]][rr+1,]
##			}
##		l = l + 1
##		}
#		
#		boxesA = do.call('rbind',newboxes)
#		print(length(boxesA[,1]))
#		
##		boxesA = boxesB
#		
#		row.names(boxesA) = 1:length(boxesA$x1)
#
#		scales[j] = s
#
#		s = s/2
#	}
#	
#	output = data.frame(s = log(1/scales), n = log(nboxes))
#	modd = lm(output$n~output$s)
#	dimm = modd$coefficients['output$s']
#	
#	return(info = list(nboxes = nboxes, scales = scales, output = output, modd = modd, dimm = dimm))
#	
#}







#this was a bunch of tests comparing the two algorithms. 


#
#objobj = boxcount(dat,12)#$output
#
#plot(objobj$output$s, objobj$output$n)
#abline(objobj$modd, col = 'red3')
#abline(0,1, lty = 3)
#
#fractaldim = list()
#for (i in 1:10) {
#	fractaldim[[i]] = boxcount(dat,i)
#	print(system.time(boxcount2(daat,i)))
#}
#
#its
#
#time1 = numeric(its)
#time2 = numeric(its)
#
#for (i in 1:its) {
##	print(i)
#	time1[i] = system.time(boxcount(daat,i))[1]
#	time2[i] = system.time(boxcount2(daat,i))[1]
#}
#
#mnb = numeric(8)
#for (i in 2:8) {
#	mnb[i-1] = boxcount2(daat, i)$dimm
#}
#
#for (its in 1:15) {
#	print(system.time(matrix(0, nrow = 2^its, ncol = 2^its)))
#}
