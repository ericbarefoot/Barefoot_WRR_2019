#	table_1.R
#	by Eric Barefoot
#	Apr 2019

# compiles Table 1 from submitted manuscript using the relevant data.

library(tidyverse)
library(here)

write_csv(table1, here('data', 'derived_data', 'table_1.csv'))
