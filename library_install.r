#!/usr/bin/env Rscript

# correcting dependency install issues for linux use where library path isn't specified, and a local path is requested
# Eric Barefoot
# Aug 2018

# message(getwd())

########################################################
# install and load  necessary libraries

packages = c('here', 'foreign', 'lubridate', 'dplyr', 'MASS')

lib = file.path(getwd(), 'pkgs')

ipak = function(pkg, lib){

  new_pkg = pkg[!(pkg %in% installed.packages()[, "Package"])]

  if (!file.exists(lib)) {
    suppressWarnings(dir.create(lib))
  }

  .libPaths(c(lib, .libPaths()))

  if (length(new_pkg)) {

    message(paste('You need a few packages, installing... \nThis may take a few minutes depending on how many are missing, \nso you might want to go get coffee.'))

    Sys.sleep(6)

    install.packages(new_pkg, dependencies = TRUE, lib = lib, repo = 'https://cloud.r-project.org/')
  }

}

ipak(packages, lib)
