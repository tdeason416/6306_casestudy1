## Questions:
#### 1  Merge the data based on the country shortcode. See how many of the IDs match; ####
# use only columns country.code, country.name, rank, gdp and Income.Group for data analysis.
merged.data.sub<-merged.data[,c("country.code","country.name","rank","gdp","Income.Group")]

nrow(merged.data)
# 189 match

#### 2  Sort the data frame in ascending order by GDP (so United States is last). What is the 13th country in the resulting data frame? ####
# Sort the data by GDP
order.data<-merged.data.sub[order(merged.data.sub$gdp),]
# Find out the 13th country in the orded data
order.data[13,]$country.name

# 13th country is St. Kitts and Nevis

#### 3	What are the average GDP rankings for the "High income: OECD" and "High income: nonOECD" groups? ####
# High income: OECD
hiOECD<-mean(merged.data.sub$rank[which(merged.data.sub$Income.Group=="High income: OECD")])
hiOECD

# High income: non OECD
hiNonOECD<-mean(merged.data.sub$rank[which(merged.data.sub$Income.Group=="High income: nonOECD")])
hiNonOECD

# Average GDP rankings for High income: OECD is 32.9667
# Average GDP rankings for High income: non OECD is 91.91304

#*******************************************************************************************
#### 4	Plot the GDP for all of the countries. Use ggplot2 to color your plot by Income Group. ####
#install ggplot2 package
#install.packages("ggplot2")
library("ggplot2")

#Histogram of GDP for all countries, colors grouped by Income.Group
ggplot(merged.data.sub, aes(x=country.code, y=log(gdp))) + 
  # fill depends on Income.Group
  geom_bar(aes(fill=Income.Group),  
           stat="identity"
 #          colour="black",    # ? Black outline for all?
  )+
  # Added axises title and hide x-axis text
  labs(x = "Country",y="GDP(million)",title="GDP by Income Group") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank())
ggplot(merged.data.sub, aes(x=country.code, y=gdp)) + 
  # ?Draw lines in same group. colour, group both depend on Income.Group
  # geom_line(aes(colour=Income.Group, group=Income.Group)) + 
  # Set points. colour depends on Income.Group
  geom_point(aes(colour=Income.Group),size=2)+ 
  # # Added axises title and hide x-axis text
  labs(x = "Country Code",y="GDP (USD)",title="GDP by Income Group") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

#Scatterplot of GDP for all countries, colors grouped by Income.Group
ggplot(merged.data.sub, aes(x=country.code, y=log(gdp))) + 
  # ?Draw lines in same group. colour, group both depend on Income.Group
  # geom_line(aes(colour=Income.Group, group=Income.Group)) + 
  # Set points. colour depends on Income.Group
  geom_point(aes(colour=Income.Group),size=3)+ 
  # # Added axises title and hide x-axis text
  labs(x = "Country",y="log (GDP)",title="GDP by Income Group") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

#### 5	Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries are Lower middle income but among the 38 nations with highest GDP? ####

merged.data.sub$rankgroups <- cut(merged.data.sub$rank, breaks=5, labels = c("High GDP", 'Medium-High GDP', 'Medium GDP', 'Medium-Low GDP', 'Low GDP'))
table(merged.data.sub$rankgroups,merged.data.sub$Income.Group)

Lower.middle.income <- merged.data.sub[merged.data.sub$Income.Group =='Lower middle income',]
LMI.highGDP <- Lower.middle.income[Lower.middle.income$rankgroups =='High GDP',]

# 5 countries are Lower middle income but among the 38 nations with highest GDP
