##
library(dplyr)

# check to see if files exist in the working directory, exit if not
if (!file.exists("summarySCC_PM25.rds"))
    stop("Summary PM25 file not found")

# read in the two dataframes from the source files
summary.df <- readRDS("summarySCC_PM25.rds")

yr_sum <- tbl_df(summary.df)
by_year <- group_by(yr_sum, year)
total_by_year <- summarise(by_year, arr=sum(Emissions, na.rm=TRUE))

png("plot1.png")

plot(total_by_year$year, total_by_year$arr/1000, type="b",
     main=expression('US Total Emissions from PM'[2.5]),
     xlab="Year",
     ylab=expression("PM"[2.5]))
mtext("(in thousands)", side=2, cex=.8)

dev.off()