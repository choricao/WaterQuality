library(tidyverse)
library(lubridate)
library(stringr)

# Read in dataset
water <- read_csv('http://594442.youcanlearnit.net/austinwater.csv')
glimpse(water)