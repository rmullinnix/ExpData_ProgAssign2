##
library(dplyr)
library(shape2)
library(ggplot2)

# check to see if files exist in the working directory, exit if not
if (!file.exists("Source_Classification_code.rds"))
    stop("Source Classification file not found")

if (!file.exists("summarySCC_PM25.rds"))
    stop("Summary PM25 file not found")

# read in the two dataframes from the source files
class.df <- readRDS("Source_Classification_code.rds")

summary.df <- readRDS("summarySCC_PM25.rds")

# find coal related codes
scc_id <- class.df[grep("motor", class.df$Short.Name, ignore.case=TRUE), "SCC"]

yr_sum <- tbl_df(summary.df)
balt_filt <- filter(yr_sum, fips == "24510", SCC %in% scc_id)
la_filt <- filter(yr_sum, fips == "06037", SCC %in% scc_id)
comb_filt <- rbind(balt_filt, la_filt)
comb_melt <- melt(comb_filt, id=c("year", "fips", "SCC", "Pollutant", "type"), 
                  measure.vars=c("Emissions"), na.rm=TRUE)

year_type <- dcast(comb_melt, year + fips ~ variable, sum)

png("plot4.png")

ggplot(data=year_type, aes(x=year, y=Emissions, colour = fips), group=fips) +
    geom_line()

dev.off()