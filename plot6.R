## Title: Exploratory Data Analysis Course Project | Coursera.
## Autor: christalf.
## Date : September 2020.
## Summary:
## - This script explores the dataset delivered for this project (the National
##   Emissions Inventory NEI records of PM2.5 emitted, in tons, from different
##   sources over the years 1999, 2002, 2005 and 2008).
## - It address the following task:
##   - Compare emissions from motor vehicle sources in Baltimore City with
##     emissions form motor vehicle sources in Los Angeles County, California
##     (fips == "06037").
##   - Which has seen greater changes over time in motor vehicle emissions?
## - Use any R plotting system to make a plot that answers this question.

## Reading in the data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)
str(SCC)
sapply(NEI, function(col) { sum(is.na(col)) })        # No missing values.

## Merging datasets and subsetting on-road sources from Baltimore and
## Los Angeles.
library(dplyr)
library(stringr)

pm_merged <- left_join(NEI, SCC, by = "SCC")
glimpse(pm_merged)

onRoadPm_Balt_LA <- pm_merged %>%
  filter((fips %in% c("24510", "06037")) &
         (type == "ON-ROAD" | str_detect(Short.Name, "[Mm]otorcycle"))) %>%
  mutate(city = ifelse(fips == "24510", "Baltimore", "Los Angeles"))

## Plotting.
library(ggplot2)
ggplot(onRoadPm_Balt_LA, aes(factor(year), log2(Emissions))) +
  geom_jitter(alpha = 0.3) +
  geom_boxplot() +
  facet_grid(. ~ city) +
  labs(title = "PM2.5 Motor Vehicle Emissions",
       x = "", y = "log2(PM2.5) emission (tn)")

## Sending plot to the PNG file graphic device.
dev.copy(png, file = "plot6.png", width = 480, height = 480)
dev.off()


#------------------------------------------------------------------#
#------------------------------------------------------------------#
# qplot Baltimore and LA on-road data, geom bar.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# qplot(as.factor(year), Emissions, data = onRoadPm_BaltLA,
#       facets = . ~ city,
#       main = "PM2.5 Motor Vehicle Emissions",
#       xlab = "", ylab = "PM2.5 emission (tn)") +
#   geom_bar(stat = "identity")


#------------------------------------------------------------------#
#------------------------------------------------------------------#
# ggplot Baltimore and LA on-road data, geom bar.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# ggplot(onRoadPm_BaltLA, aes(x = factor(year), y = Emissions, fill = city)) +
#   geom_bar(aes(fill = year), stat = "identity") +
#   facet_grid(scales = "free", space = "free", . ~ city) +
#   guides(fill = FALSE) + theme_bw() +
#   labs(x = "year", y = expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
#   labs(title = expression("PM"[2.5]*" Motor Vehicle Emissions in Baltimore & LA, 1999-2008"))

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# ggplot Baltimore and LA on-road data, geom bar (stat_summary()).
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# ggplot(onRoadPm_BaltLA, aes(year, Emissions, fill = factor(fips))) +
#     stat_summary(fun.y = "sum", geom = "bar", position = "dodge") +
#     ggtitle("Vehicle Emissions across Baltimore and LA, California") +
#     ylab("Total Emissions") + xlab("Year of Emisions by city") +
#     guide_legend(title = "Cities")

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# qplot Baltimore and LA on-road data (grouped and summarized by
# year), geom point, path.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# onRoadPm_BaltLA_perYear <- pm_merged %>% 
#   filter(fips %in% c("24510", "06037") & type == "ON-ROAD") %>%
#   group_by(year, fips) %>%
#   summarize(total = sum(Emissions)) %>% 
#   rename(city = fips)

# qplot(year, total, data = onRoadPm_BaltLA_perYear,
#       color = city,
#       geom = c("point", "path"),
#       main = "PM2.5 Motor Vehicle Emissions",
#       xlab = "", ylab = "PM2.5 emission (tn)") +
#         scale_color_manual(labels = c("Los Angeles", "Baltimore"),
#                            values = c("tomato", "turquoise"))

