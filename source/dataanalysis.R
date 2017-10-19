## 1  Merge the data based on the country shortcode. See how many of the IDs match;
## 2  Sort the data frame in ascending order by GDP (so United States is last). What is the 13th country in the resulting data frame?
## 3	What are the average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups? 
## 4	Plot the GDP for all of the countries. Use ggplot2 to color your plot by Income Group.
## 5	Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries are Lower middle income but among the 38 nations with highest GDP?

# use only columns country.code, counry.name, rank, gdp and Income.Group
merged.data.sub<-merged.data[,c("country.code","country.name","rank","gdp","Income.Group")]

## 1  Merge the data based on the country shortcode. See how many of the IDs match;
merged.data <- merge.data.frame(x = gdp, y = education, all = FALSE, by = 'country.code' )  # Contains only countries that appeared in both datasets
nrow(merged.data)
#[1] 189

## 2  Sort the data frame in ascending order by GDP (so United States is last). What is the 13th country in the resulting data frame?
# Sort the data by GDP
order.data<-merged.data.sub[order(merged.data.sub$gdp),]
# Find out the 13th country in the orded data
order.data[13,]$country.name
#[1] "St. Kitts and Nevis"

## 3	What are the average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups?
# High income: OECD
hiOECD<-mean(merged.data.sub$gdp[which(merged.data.sub$Income.Group=="High income: OECD")])
hiOECD
#[1] 1483917
hiNonOECD<-mean(merged.data.sub$gdp[which(merged.data.sub$Income.Group=="High income: nonOECD")])
hiNonOECD
#[1] 104349.8

## 4	Plot the GDP for all of the countries. Use ggplot2 to color your plot by Income Group.
install.packages("ggplot2")

