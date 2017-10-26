# DS6306 (DoingDataScience) Midterm Case Study #1
### October 25th 2017

### Submitted by:
* Lu Chent
* Eric Balke
* Anthony Schams
* Travis Deason

## Project Contents
* 6306_case_study.Rmd - Contains code needed to generate files
* 6306_case_study_rmd.md - Contains output, analysis and code
* data:
>* EDSTATS_Country.csv - contains relative statistics on all countries 
>* gdp2012.csv - contains the GDP of all countries in 2012
* source:
>* clean_data.R - code needed to tidy and convert the data from data folder into usable dataframes
* images:
*> gdp.png - contains gdp data for all countries ordered by rank and color grouped by income group
*> loggdp.png - contains log_10 transformed gdp data for all countries ordered by rank and colored by income group

## Project Contents
>* complete project with code is in 6306_case_study.RMD

#### Introduction:
We are living in an increasingly global world. With the rapid development of technology in the past century, we have gone from countless small, mostly isolated populations to one large, connected population on the global scale. With technological and scientific development came economic and population growth on a global scale. Still, countries underwent different levels of growth. We will be comparing the GDP's of several countries and examine some factors that are related to GDP. 

```{r, echo=FALSE, message=FALSE}
# generates clean data frames merged.data from R.
source('source/clean_data.R')
merged.data.sub <- merged.data[,c("country.code","country.name","rank","gdp","Income.Group")]
```

```{r, echo=TRUE, message=FALSE}
nrow(merged.data)
```
We have complete GDP data (Raw GDP and Income Group) for 189 different countries in the world. 

```{r, echo=TRUE, message=FALSE}
order.data<-merged.data.sub[order(merged.data.sub$gdp),]
order.data[13,]$country.name
```
We can see that the country with the 13th lowest GDP is St. Kitts and Nevis. 


The Organisation for Economic Co-operation and Development (OECD) is an international economic organization involving the governments of 35 countries across the world. Member countries commit themselves to democracy and a market economy and cooperate with one another to identify and implement practices and policies with the ultimate goal of economic growth and security for their citizens.
The members of OECD are in general stronger economically than non-OECD countries. 

```{r, echo=TRUE, message=FALSE}
hiOECD <- mean(merged.data.sub$rank[which(merged.data.sub$Income.Group=="High income: OECD")])
print(hiOECD)
hiNonOECD <- mean(merged.data.sub$rank[which(merged.data.sub$Income.Group=="High income: nonOECD")])
print(hiNonOECD)
```
We can see that members of the OECD are generally higher ranked than non-members, with the average rank of members being 32.9667 and non-members having average rank of 91.91394.

* Scatter-plot of GDP for all countries, colors grouped by Income.Group
```{r, echo=TRUE, message=FALSE, fig.align='center'}
## GDP converted to log10 scale for better data visualization
merged.data.sub$loggdp <- log10(merged.data.sub$gdp * 1000000)
ggplot(merged.data.sub, aes(x=rank, y=gdp)) + 
  # ?Draw lines in same group. colour, group both depend on Income.Group
  # Set points. colour depends on Income.Group
  geom_point(aes(colour=Income.Group),size=1)+ 
  # # Added axises title and hide x-axis text
  labs(x = "Country GDP rank (left is highest)",y="GDP (USD)",title="GDP by Income Group") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        plot.title = element_text(hjust = 0.5))
ggsave('images/gdp.png')
```

<img src="images/gdp.png" style="display: block; margin: auto;" />

This scatter-plot confirms the previous observation, OECD members generally have higher GDPs than non members. Not only that, it illustrates that high income non-OECD members have lower GDP than some countries with lower incomes. At this scale however, it is difficult to discern the differences in income between most countries because of extremely large outliers. We will therefore examine log-transformed data. 
```{r, echo=TRUE, message=FALSE, fig.align='center'}
ggplot(merged.data.sub, aes(x=rank, y=log10(gdp))) + 
  # Draw lines in same group. colour, group both depend on Income.Group
  # Set points. colour depends on Income.Group
  geom_point(aes(colour=Income.Group),size=1)+ 
  # # Added axises title and hide x-axis text
  labs(x = "Country GDP rank (left is highest)",y=expression('log'[10]*'(GDP (USD) )'),title="GDP by Income Group") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(), 
        plot.title = element_text(hjust = 0.5))
ggsave('images/loggdp.png')
```
<img src="images/loggdp.png" style="display: block; margin: auto;" />

Looking at the log_10(GDP), it becomes more clear that some high income non-OECD members have lower GDPs than lower income countries. Another interesting observation is that many of the lowest GDP countries are lower middle income or upper middle income, while many low income countries are in the median of income. We even see some lower middle income countries with very high GDPs.

```{r, echo=TRUE, message=FALSE}
merged.data.sub$rankgroups <- cut(merged.data.sub$rank, breaks=5, labels = c("High GDP", 'Medium-High GDP', 'Medium GDP', 'Medium-Low GDP', 'Low GDP'))
table(merged.data.sub$rankgroups,merged.data.sub$Income.Group)

Lower.middle.income <- merged.data.sub[merged.data.sub$Income.Group =='Lower middle income',]
LMI.highGDP <- Lower.middle.income[Lower.middle.income$rankgroups =='High GDP',1:4]
LMI.highGDP

```

|                   | High income: nonOECD | High income: OECD | Low income  | Lower middle income | Upper middle income
|-------------------|----------------------|-------------------|-------------|---------------------|--------------------|                 
|   High GDP        |                   4  |              18   |       0     |         5           |       11           |
|   Medium-High GDP |                   5  |              10   |      1      |        13           |        9           |
|   Medium GDP      |                   8  |               1   |       9     |        12           |        8           |
|   Medium-Low GDP  |                   4  |               1   |      16     |         8           |        8           |
|   Low GDP         |                   2  |               0   |      11     |        16           |        9           |
                  

|      country.code  |   country.name    | rank  |   gdp    |
|--------------------|-------------------|-------|----------|
|34           CHN    |         China     |     2 |  8227103 |
|51           EGY    |  Egypt, Arab Rep. |    38 | 262832   | 
|77           IDN    |    Indonesia      |   16  | 878043   |
|78           IND    |     India         |  10   | 1841710  |
|165          THA    |     Thailand      |  31   | 365966   |


And indeed there are 5 Lower middle income countries in the top fifth quantile: China, Egypt, Indonesia, India, and Thailand.


## Conslusion

* Based on our review of how incomes are classified, it appears that many lower income countries are rated as middle income, and some upper income countries are classified as middle income.  Based on the chart above.  This is probably because groupings are based on per-capita GDP, and not overall GDP; this shows it is possible for a country to be very high GDP, but still be categorized as low income, but only if the country has a very large population.