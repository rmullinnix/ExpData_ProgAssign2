##
library(dplyr)
library(shape2)
library(ggplot2)

# check to see if files exist in the working directory, exit if not
if (!file.exists("summarySCC_PM25.rds"))
    stop("Summary PM25 file not found")

# read in the two dataframes from the source files
summary.df <- readRDS("summarySCC_PM25.rds")

yr_sum <- tbl_df(summary.df)
balt_filt <- filter(yr_sum, fips == "24510")
balt_melt <- melt(balt_filt, id=c("year", "fips", "SCC", "Pollutant", "type"), 
                  measure.vars=c("Emissions"), na.rm=TRUE)

year_type <- dcast(balt_melt, year + type ~ variable, sum)

png("plot3.png")

qplot(year, Emissions, data=year_type, facets = type ~ ., 
      geom = c("point", "smooth"), method =	"lm")

dev.off()