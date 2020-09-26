## Title: Exploratory Data Analysis Course Project | Coursera.
## Autor: christalf.
## Date : September 2020.
## Summary:
## - This script explores the dataset delivered for this project (the National
##   Emissions Inventory NEI records of PM2.5 emitted, in tons, from different
##   sources over the years 1999, 2002, 2005 and 2008).
## - It address the following question: Have total emissions from PM2.5 decreased
##   in the US from 1999 to 2008?.
## - The task must be performed using the base plotting system an making a plot
##   showing the total PM2.5 emission from all sources for each of the years 1999,
##   2002, 2005 and 2008.

## Reading in the data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)
str(SCC)
sapply(NEI, function(col) { sum(is.na(col)) })        # No missing values.

## Calculating and plotting total emissions per year.
emissions_perYear <- tapply(NEI$Emissions, NEI$year, sum)
emissions_perYear

barplot(emissions_perYear / 10^6, col = "tomato",
        main = "U.S. PM2.5 Total Emissions per Year",
        xlab = "", ylab = "PM2.5 emmision (10^6 tn)")

## Sending plot to the PNG file graphic device.
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()

