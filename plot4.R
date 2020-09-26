## Title: Exploratory Data Analysis Course Project | Coursera.
## Autor: christalf.
## Date : September 2020.
## Summary:
## - This script explores the dataset delivered for this project (the National
##   Emissions Inventory NEI records of PM2.5 emitted, in tons, from different
##   sources over the years 1999, 2002, 2005 and 2008).
## - It address the following question: Across the US, how have emissions from
##   coal combustion-related sources changed from 1999-2008?
## - Use any R plotting system to make a plot that answers this question.

## Reading in the data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)
str(SCC)
sapply(NEI, function(col) { sum(is.na(col)) })        # No missing values.

## Merging datasets and subsetting coal obs.
library(dplyr)
library(stringr)

pm_merged <- left_join(NEI, SCC, by = "SCC")
glimpse(pm_merged)

coalEmissions <- pm_merged %>% 
        filter(str_detect(Short.Name, "[Cc]oal"))

str(coalEmissions)

## Plotting.
library(ggplot2)
qplot(as.factor(year), log2(Emissions), data = coalEmissions,
      geom = "boxplot",
      main = "U.S. PM2.5 Coal Emissions Evolution",
      xlab = "", ylab = "log2(PM2.5) emission (tn)")

## Sending plot to the PNG file graphic device.
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# qplot Coal data, geom bar.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# qplot(as.factor(year), Emissions / 10^5, data = coalEmissions,
#       main = "U.S. PM2.5 Coal Emissions Evolution",
#       xlab = "", ylab = "PM2.5 emission (10^5 tn)") +
#         geom_bar(stat = "identity")

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# ggplot Coal data, geom bar.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# ggplot(coalEmissions, aes(factor(year), Emissions / 10^5)) +
#   geom_bar(stat = "identity", fill = "grey", width = 0.75) +
#   theme_bw() +  guides(fill = FALSE) +
#   labs(x = "year", y = expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
#   labs(title = expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# ggplot Coal data, geom bar (stat_summary()).
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# ggplot(coalEmissions, aes(factor(year), Emissions, fill = type)) +
#   stat_summary(fun.y = "sum", geom = "bar", position = "dodge") +
#   ggtitle("Coal Emissions across USA") +
#   ylab("Total Emissions") + xlab("Year of Emisions by type")

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# qplot Coal data, geom boxplot.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# qplot(as.factor(year), log2(Emissions), data = coal_emissions,
#       geom = "boxplot",
#       main = "U.S. PM2.5 Coal Emissions Evolution",
#       xlab = "", ylab = "log2(PM2.5) coal emission (tn)")

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# qplot Coal data (grouped and summarized by year), geom point, path
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# coalEmissions_perYear <- pm_merged %>% 
#         filter(str_detect(Short.Name, "[Cc]oal")) %>% 
#         group_by(year) %>% 
#         summarize(total = sum(Emissions))
# str(coalEmissions_perYear)

# qplot(year, total, data = coalEmissions_perYear,
#       geom = c("point", "path"),
#       main = "U.S. PM2.5 Coal Emissions Evolution",
#       xlab = "", ylab = "PM2.5 emission (tn)")

