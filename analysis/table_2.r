#	table_2.R
#	by Eric Barefoot
#	Apr 2019

# compiles Table 2 from submitted manuscript using the relevant data.

# library(tidyverse)
# library(here)

source(here('analysis', 'runoff_width_modeling.r'))

write_csv(table2, here('data', 'derived_data', 'table_2.csv'))
