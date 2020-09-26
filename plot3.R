## Title: Exploratory Data Analysis Course Project | Coursera.
## Autor: christalf.
## Date : September 2020.
## Summary:
## - This script explores the dataset delivered for this project (the National
##   Emissions Inventory NEI records of PM2.5 emitted, in tons, from different
##   sources over the years 1999, 2002, 2005 and 2008).
## - It address the following questions:
##   - Of the four types of sources indicated by the "type" (point, nonpoint,
##     onroad, nonroad) variable, which of these four sources have seen decreases
##     in emissions form 1999-2008 for Baltimore City?
##   - Which have seen increases in emissions from 1999-2008?
## - The ggplot2 plotting system must be used to make a plot that answers these
##   questions.

## Reading in the data.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

str(NEI)
str(SCC)
sapply(NEI, function(col) { sum(is.na(col)) })        # No missing values.

## Subsetting Baltimore data.
library(dplyr)
pmBaltimore <- NEI %>% filter(fips == "24510")
str(pmBaltimore)

## Plotting.
library(ggplot2)
qplot(as.factor(year), log2(Emissions), data = pmBaltimore,
      facets = . ~ type,
      geom = "boxplot",
      main = "Baltimore PM2.5 Sources Evolution",
      xlab = "", ylab = "log2(PM2.5) emission (tn)") +
        theme(axis.text.x = element_text(angle = 45))

## Sending plot to the PNG file graphic device.
dev.copy(png, file = "plot3.png", width = 700, height = 500)
dev.off()


#------------------------------------------------------------------#
#------------------------------------------------------------------#
# qplot Baltimore data, geom bar, facets.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# qplot(as.factor(year), Emissions, data = pmBaltimore,
#       facets = . ~ type,
#       main = "Baltimore City PM2.5 Emissions by Sources",
#       xlab = "", ylab = "PM2.5 emission (tn)") +
#   geom_bar(stat = "identity") +
#   theme(axis.text.x = element_text(angle = 90))

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# ggplot Baltimore data, geom bar, facets.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# ggplot(pmBaltimore, aes(factor(year), Emissions, fill = type)) +
#       geom_bar(stat = "identity") +
#       theme_bw() + guides(fill = FALSE) +
#       facet_grid(. ~ type, scales = "free", space = "free") + 
#       labs(x = "year", y = expression("Total PM"[2.5]*" Emission (Tons)")) + 
#       labs(title = expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# ggplot Baltimore data, geom bar (stat_summary()).
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# ggplot(pmBaltimore, aes(factor(year), Emissions, fill = type)) +
#   stat_summary(fun.y = "sum", geom = "bar", position = "dodge") +
#   ggtitle("Emissions by  types of sources") +
#   ylab("Total Emissions") + xlab("Year of Emisions by type")

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# qplot Baltimore data, geom point, smooth, facets.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# qplot(year, Emissions, data = pmBaltimore,
#       facets = . ~ type,
#       main = "Baltimore PM2.5 Sources Evolution",
#       xlab = "Year", ylab = "PM2.5 emission (tn)") +
#         geom_smooth(method = "lm") +
#         theme(axis.text.x = element_text(angle = 90))
# 
# qplot(year, log2(Emissions), data = pmBaltimore,
#       facets = . ~ type,
#       main = "Baltimore PM2.5 Sources Evolution",
#       xlab = "", ylab = "log2(PM2.5) emission (tn)") +
#         geom_smooth(method = "lm") +
#         theme(axis.text.x = element_text(angle = 90))

# ggplot(pmBaltimore, aes(year, Emissions)) +
#         geom_point() + geom_smooth(method = "lm") +
#         labs(title = "Baltimore PM2.5 Sources Evolution",
#              x = "Year", y = "PM2.5 emission (tn)") +
#         facet_wrap(. ~ type, nrow = 2, ncol = 4)

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# ggplot Baltimore data, geom boxplot, facets.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# ggplot(pmBaltimore, aes(factor(year), log2(Emissions))) +
#   facet_grid(. ~ type) + guides(fill = F) +
#   geom_boxplot(aes(fill = type)) + stat_boxplot(geom = 'errorbar') +
#   ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) + xlab('Year') + 
#   ggtitle('Emissions per Type in Baltimore City, Maryland') +
#   geom_jitter(alpha=0.10)

#------------------------------------------------------------------#
#------------------------------------------------------------------#
# qplot Baltimore data (grouped and summarized by year and type),
# geom point, path.
#------------------------------------------------------------------#
#------------------------------------------------------------------#

# pmBaltimore_perYearType <- NEI %>%
#   filter(fips == "24510") %>%
#   group_by(year, type) %>% 
#   summarize(total = sum(Emissions))
# 
# str(pmBaltimore_perYearType)

# qplot(year, total, data = pmBaltimore_perYearType,
#       color = type,
#       geom = c("point", "path"),
#       main = "Baltimore City PM2.5 Sources Evolution",
#       xlab = "", ylab = "PM2.5 emission (tn)")


