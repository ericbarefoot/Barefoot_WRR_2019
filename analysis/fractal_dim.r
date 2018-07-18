# 	Calculating the fractal dimension of the stream network based on box-counting algorithm
# 	Eric Barefoot
# 	Feb 2016

wd <- getwd()

pd <- file.path(wd, "..")

dd <- file.path(pd, "data", "derived_data", "digested", "outputs")

source(file.path(, "functions", "box_counting.r"))


# note: dec 2017
# is there supposed to be something else here?? hopefully? or maybe it was never worth it so I let it be.
