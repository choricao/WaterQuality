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

# Convert data types
summary(filtered_water)

filtered_water$siteType <- as.factor(filtered_water$siteType)
filtered_water$parameterType <- as.factor(filtered_water$parameterType)
filtered_water$parameter <- as.factor(filtered_water$parameter)
filtered_water$unit <- as.factor(filtered_water$unit)
filtered_water$sampleTime <- mdy_hms(filtered_water$sampleTime)

summary(filtered_water)

# Correct data entry errors
subset(filtered_water, unit == 'Feet')

convert <- which(filtered_water$unit == 'Feet')
filtered_water$unit[convert] <- 'Deg. Fahrenheit'

summary(filtered_water)

glimpse(subset(filtered_water, unit == 'MG/L'))

glimpse(subset(filtered_water, unit == 'MG/L' & parameter == "PH"))

convert <- which(filtered_water$unit == 'MG/L' & filtered_water$parameter == "PH")
filtered_water$unit[convert] <- 'Standard units'

glimpse(subset(filtered_water, unit == 'MG/L'))

glimpse(subset(filtered_water, unit == 'MG/L' & result > 70))

convert <- which(filtered_water$unit == 'MG/L' & filtered_water$result > 70)
filtered_water$unit[convert] <- 'Deg. Fahrenheit'

glimpse(subset(filtered_water, unit == 'MG/L'))

convert <- which(filtered_water$unit == 'MG/L')
filtered_water$unit[convert] <- 'Deg. Celsius'

summary(filtered_water)

# Identify and remove outliers
ggplot(filtered_water, mapping = aes(x = sampleTime, y = result)) +
  geom_point()

subset(filtered_water, result > 1000000) %>%
  glimpse()

remove <- which(filtered_water$result > 1000000 | is.na(filtered_water$result))
filtered_water <- filtered_water[-remove, ]

summary(filtered_water)

subset(filtered_water, result > 1000) %>%
  glimpse()

remove <- which(filtered_water$result > 1000)
filtered_water <- filtered_water[-remove, ]

summary(filtered_water)

ggplot(data = filtered_water, mapping = aes(x = unit, y = result)) +
  geom_boxplot()

convert <- which(filtered_water$result > 60 &
                   filtered_water$unit == "Deg. Celsius")
filtered_water$unit[convert] <- 'Deg. Fahrenheit'

ggplot(data = filtered_water, mapping = aes(x = unit, y = result)) +
  geom_boxplot()

# 
fahrenheit <- which(filtered_water$unit == "Deg. Fahrenheit")

filtered_water$result[fahrenheit] <- (filtered_water$result[fahrenheit] - 32) * (5.0 / 9.0)
ggplot(data = filtered_water, mapping = aes(x = unit, y = result)) +
  geom_boxplot()

filtered_water$unit[fahrenheit] <- 'Deg. Celsius'
ggplot(data = filtered_water, mapping = aes(x = unit, y = result)) +
  geom_boxplot()

summary(filtered_water)

filtered_water$unit <- droplevels(filtered_water$unit)
summary(filtered_water)

