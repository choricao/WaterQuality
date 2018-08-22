library(tidyverse)
library(lubridate)
library(stringr)

# Read in dataset
water <- read_csv('http://594442.youcanlearnit.net/austinwater.csv')
glimpse(water)

# Filter dataset
water <- tibble('siteName' = water$SITE_NAME,
                'siteType'= water$SITE_TYPE,
                'sampleTime' = water$SAMPLE_DATE,
                'parameterType' = water$PARAM_TYPE,
                'parameter' = water$PARAMETER,
                'result' = water$RESULT,
                'unit' = water$UNIT)
glimpse(water)

unique(water$parameter)

unique(water[which(str_detect(water$parameter, 'PH')), ]$parameter)

unique(water$parameterType)

filtered_water <- subset(water, (parameterType == "Alkalinity/Hardness/pH") | (parameterType == "Conventionals"))
glimpse(filtered_water)  

unique(filtered_water$parameter)

filtered_water <- subset(filtered_water, (parameter == "PH") | (parameter == "WATER TEMPERATURE"))
glimpse(filtered_water)

