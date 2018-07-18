# widthMap.R
# by George Allen, Feb 2016

# runs through each stream centerline, calculates the orthogonal
# direction to the along stream direction at each vertex. 
# shapefiles need with UTM coordinates and also joined 
# field data for this to work.

widthMap <- function(inTabPaths, tabNames, pdfOut, run){

require(foreign)


# input parameters:
n = 3 # N vertices overwhich to calculate direction (must be odd numbers >1)
wt = c(5,5,3,1,1)/15 # weights for the weighted mean calculation
wMult = 1 # multiplier for the displayed cross section multiplier
fixPlotLims = T

# functions:
insertRow <- function(existingDF, newrow, r) {
  existingDF[seq(r+1,length(existingDF)+1)] = existingDF[seq(r,length(existingDF))]
  existingDF[r] = newrow
  return(existingDF)
}

grouper <- function(x){
  idx = 1 + cumsum(is.na(x))
  nonNa = !is.na(x)
  split(x[nonNa], idx[nonNa])
}


 


inDbfPaths = sub('field/', 'field/shapefiles/', inTabPaths)
inDbfPaths = sub('field_dat.csv', 'segments_pts.dbf', inDbfPaths)


pdf(pdfOut, width=100, height=100)


for (m in 1:length(inDbfPaths)){
  
  # import and process data:
  tab = data.frame(read.dbf(inDbfPaths[m]))
  
  
  # calculate cross sectional direction at each vertex:
  x = tab$lon
  y = tab$lat
  w = tab$width_cm*.01*wMult # convert to meters
  s = tab$Name
  l = nrow(tab)
  
  # chop start and end of vectors calculate bearing between neighbors: 
  p1x = x[-c((l-n+2):l)]
  p1y = y[-c((l-n+2):l)]
  p2x = x[-c(1:(n-1))]
  p2y = y[-c(1:(n-1))]
  
  # calculate centerline angle:
  a = atan2(p2y-p1y, p2x-p1x)*180/pi
  
  # make a original length
  a = c(rep(-999, floor(n/2)), a, rep(-999, floor(n/2))) 
  
  
  #### handle start and end of segments (where angles get funky):
  
  # locate where new segments start:
  j = which(!duplicated(s))

  # insert NAs at start, end, and jump in vector:
  for (i in rev(1:length(j))){
    x = insertRow(x, NA, j[i])
    y = insertRow(y, NA, j[i])
    a = insertRow(a, NA, j[i])
  }
  
  x = c(x, NA)
  y = c(y, NA)
  a = c(a, NA)
  
  # get bounds of NA values:
  jNA = which(is.na(a))
  
  closeL = jNA[-1] - 1
  closeR = jNA[-length(jNA)] + 1
  farL = jNA[-1] - floor(n/2)
  farR = jNA[-length(jNA)] + floor(n/2)
  

  # use a linearly shrinking window to calculate bearing at ends of vectors:
  for (i in 1:(length(jNA)-1)){
    
    fL = farL[i]:closeL[i]
    rL = closeR[i]:farR[i]
  
    
    for (ii in 1:length(fL)){
      
      # calculate all points on left sides of jumps:
      L = c((fL[ii]-floor(n/2)), closeL[i])
      a[fL[ii]] = atan2((y[L[2]]-y[L[1]]), (x[L[2]]-x[L[1]]))*180/pi
      
      
      # handle all points on right sides of vectors:
      R = c(closeR[i], (rL[ii]+floor(n/2)))
      a[rL[ii]] = atan2((y[R[2]]-y[R[1]]), (x[R[2]]-x[R[1]]))*180/pi
  
    }
  }
  
  
  #dev.off()
  x = na.omit(x)
  y = na.omit(y)
  a = na.omit(a)
  
  
  ########################################################################
  # find XY of channel bounds:
  q = 90-a
  q[q < 0] = q[q < 0] + 360
  
  o1x = x + cos(q*pi/180)*w
  o1y = y - sin(q*pi /180)*w
  o2x = x - cos(q*pi/180)*w
  o2y = y + sin(q*pi/180)*w
  
  
  # set XY coordinates with a zero width to NA:
  zW = tab$width_cm==0
  
  o1x[zW] = NA
  o1y[zW] = NA
  o2x[zW] = NA
  o2y[zW] = NA
  
  
  # add an NA between segments to plot centerline:
  for (i in rev(1:length(j))){
    x = insertRow(x, NA, j[i])
    y = insertRow(y, NA, j[i])
    o1x = insertRow(o1x, NA, j[i])
    o1y = insertRow(o1y, NA, j[i])
    o2x = insertRow(o2x, NA, j[i])
    o2y = insertRow(o2y, NA, j[i])

  }
  
   
  # organize XY for plotting polygons:
  ox = mapply(c, grouper(o1x), lapply(grouper(o2x), rev), NA)
  oy = mapply(c, grouper(o1y), lapply(grouper(o2y), rev), NA)
  
  ox = unlist(ox, use.names=F)
  oy = unlist(oy, use.names=F)
  
  
  #############################
  #PLOT:
  
  # plot all networks at same scale:
  if (fixPlotLims==T){
    xS = 2000 # meters across in the y direction
    xC = mean(range(ox, na.rm=T))
    xlim = c(xC-xS/2, xC+xS/2)
  }else{
    xlim=range(ox, na.rm=T)
  }
  
  plot(x, y, type='n', xlim=xlim,
       xlab="lon", ylab='lat', asp=1, lwd=.1, col=1)
  
  polygon(ox, oy, col=4, lwd=0.1)

  lines(x, y, col=2, lwd=0.1)
  segments(o1x, o1y, o2x, o2y, col=2, lwd=0.1)
  
  #lines(o1x, o1y, col='orange')
  #lines(o2x, o2y, col='yellow')
  
}
  

dev.off()
cmd = paste('open', pdfOut)
system(cmd)


}

