## Title: Exploratory Data Analysis Course Project | Coursera.
## Autor: christalf.
## Date : September 2020.
## Summary:
## - This script explores the dataset delivered for this project (the National
##   Emissions Inventory NEI records of PM2.5 emitted, in tons, from different
##   sources over the years 1999, 2002, 2005 and 2008).
## - It address the following question: How emissions from motor vehicle sources
##   changed from 1999-2008 in Baltimore City?
## - Use any R plotting system to make a plot that answers this question.

## Reading in the data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)
str(SCC)
sapply(NEI, function(col) { sum(is.na(col)) })        # No missing values.

## Merging datasets, subsetting Baltimore's motor sources.
library(dplyr)

pm_merged <- left_join(NEI, SCC, by = "SCC")
glimpse(pm_merged)

onRoadPm_Baltimore <- pm_merged %>%
        filter((fips == "24510") &
               (type == "ON-ROAD" | str_detect(Short.Name, "[Mm]otorcycle")))

## Plotting.
library(ggplot2)
qplot(as.factor(year), log2(Emissions), data = onRoadPm_Balt,
      geom = "boxplot",
      main = "Baltimore City PM2.5 Motor Vehicle Emissions",
      xlab = "", ylab = "log2(PM2.5) emission (tn)")

## Sending plot to the PNG file graphic device.
dev.copy(png, file = "plot5.png", width = 480, height = 480)
dev.off()


#------------------------------------------------------------------#
#------------------------------------------------------------------#
# qplot Baltimore on-road data, geom bar.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# qplot(as.factor(year), Emissions, data = onRoadPm_Balt,
#       main = "Baltimore City PM2.5 Motor Vehicle Emissions",
#       xlab = "", ylab = "PM2.5 emission (tn)") +
#         geom_bar(stat = "identity")

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# ggplot Baltimore on-road data, geom bar.
#------------------------------------------------------------------#
#------------------------------------------------------------------#
# ggplot(onRoadPm_Balt, aes(factor(year), Emissions)) +
#   geom_bar(stat = "identity", fill = "grey", width = 0.75) +
#   theme_bw() +  guides(fill = FALSE) +
#   labs(x = "year", y = expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
#   labs(title = expression("PM"[2.5]*" Motor Vehicle Emissions in Baltimore from 1999-2008"))

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# ggplot Baltimore on-road data, geom bar (stat_summary()).
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# ggplot(onRoadPm_Balt, aes(factor(year), Emissions)) +
#     stat_summary(fun.y = "sum", geom = "bar", position = "dodge", fill = "brown") +
#     ggtitle("Vehicle Emissions across Baltimore") +
#     ylab("Total Emissions") + xlab("Year of Emisions")

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# qplot Baltimore on-road data (grouped and summarized by year),
# geom point, path.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# onRoadPm_Balt_perYear <- pm_merged %>% 
#   filter(fips == "24510" & type == "ON-ROAD") %>% 
#   group_by(year) %>% 
#   summarize(total = sum(Emissions))
# str(onRoadPm_Balt_perYear)

# qplot(year, total, data = onRoadPm_Balt_perYear,
#       geom = c("point", "path"),
#       main = "Baltimore City PM2.5 Motor Vehicle Emissions",
#       xlab = "", ylab = "PM2.5 emission (tn)")

