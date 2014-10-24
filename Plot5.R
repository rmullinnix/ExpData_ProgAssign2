##
library(dplyr)

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
motor_filt <- filter(yr_sum, fips == "24510", SCC %in% scc_id)
by_year <- group_by(motor_filt, year)
total_by_year <- summarise(by_year, arr=sum(Emissions, na.rm=TRUE))

png("plot4.png")

plot(total_by_year$year, total_by_year$arr, type="b",
     main=expression('US Total Motor Vehicle Emissions from PM'[2.5]),
     xlab="Year",
     ylab=expression("PM"[2.5]))

dev.off()