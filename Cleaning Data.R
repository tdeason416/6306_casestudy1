rm( list = ls()); cat("\014")  # Clear environment
install.packages('dplyr')
library(dplyr)
library(stringr)

education <- read.csv('data/EDSTATS_Country.csv')
names(education)[1] <- "country.code"

gdp <- read.csv('data/gdp2012.csv', skip=4, col.names= c('country.code', 'rank', 'NA',  'country.name', 'gdp', 'NA2', 'NA3', 'NA4', "NA5", 'NA6'))
gdp <- gdp[c('country.code', 'rank', 'country.name', 'gdp')]
gdp$country.name <- as.character(gdp$country.name)

# Convert GDP numbers to integers/NA
clean.gdp <-(lapply(gdp['gdp'], gsub, pattern = ',', replacement='')) # remove commas from the gdp numbers. 
gdp$gdp <- clean.gdp$gdp
#gdp <- subset(gdp, subset = country.code !='') # Remove rows without country codes..
gdp <- subset(gdp, subset = (rank !='' & country.code !=''))  # remove rows without contry codes and rank..Edited by LuCheng 10/18 
gdp$gdp <- type.convert(gdp$gdp, na.strings = c('..', '')) # Convert to integer type or NA if data not available.

# Convert GDP rankings to integers
gdp$rank <- as.character(gdp$rank)
gdp$rank <- type.convert(gdp$rank, na.strings = c(''))


all.merged.data <- merge.data.frame(x = gdp, y = education, all = TRUE, by = 'country.code' )
merged.data <- merge.data.frame(x = gdp, y = education, all = FALSE, by = 'country.code' )  # Contains only countries that appeared in both datasets
all.merged.data <- all.merged.data[order(all.merged.data$rank, na.last = TRUE),]
