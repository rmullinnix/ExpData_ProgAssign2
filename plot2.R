##
library(dplyr)

# check to see if files exist in the working directory, exit if not
if (!file.exists("summarySCC_PM25.rds"))
    stop("Summary PM25 file not found")

# read in the two dataframes from the source files
summary.df <- readRDS("summarySCC_PM25.rds")

yr_sum <- tbl_df(summary.df)
balt_filt <- filter(yr_sum, fips == "24510")
by_year <- group_by(balt_filt, year)
total_by_year <- summarise(by_year, arr=sum(Emissions, na.rm=TRUE))

png("plot2.png")

plot(total_by_year$year, total_by_year$arr, type="b",
     main=expression('Baltimore City Total Emissions from PM'[2.5]),
     xlab="Year",
     ylab=expression("PM"[2.5]))

dev.off()