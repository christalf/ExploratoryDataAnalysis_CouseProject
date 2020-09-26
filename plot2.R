## Title: Exploratory Data Analysis Course Project | Coursera.
## Autor: christalf.
## Date : September 2020.
## Summary:
## - This script explores the dataset delivered for this project (the National
##   Emissions Inventory NEI records of PM2.5 emitted, in tons, from different
##   sources over the years 1999, 2002, 2005 and 2008).
## - It address the following question: Have total emissions from PM2.5 decreased
##   in Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
## - The base plotting system must be used to make a plot that answers this
##   question.

## Reading in the data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)
str(SCC)
sapply(NEI, function(col) { sum(is.na(col)) })        # No missing values.

## Subsetting and summarizing data for Baltimore, per year.
library(dplyr)
pmBaltimore_perYear <- NEI %>% 
        filter(fips == "24510") %>% 
        group_by(year) %>% 
        summarize(total = sum(Emissions))

pmBaltimore_perYear

## Plotting result.
with(pmBaltimore_perYear,
     barplot(total ~ year, col = "tomato",
             main = "Baltimore PM2.5 Total Emissions per Year",
             xlab = "", ylab = "PM2.5 emission (tn)"))

## Sending plot to the PNG file graphic device.
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()
