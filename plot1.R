################################################################################
# JHU Exploratory Data Analysis - Course Project 1 
# Plot 1: Histogram of global active power
################################################################################

# Preliminaries
library(data.table)
library(dplyr)
setwd("/Users/mpannucc/Documents/R/DS291/Course Project 1")
filename <- "project1_data.zip"

# Checking if zip file already exists in the environment
if(!file.exists(filename)) {
    dataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(dataURL, filename, method = "curl")
}

# Unzip
if(!file.exists("UCI HAR Dataset")) {
    unzip(filename)
}

# Read in the data
indata <- read.table("household_power_consumption.txt", sep = ";", header = TRUE,
                     na.strings = "?")

# Filter out only the dates we need, keep only the variables we need, coerce the 
# date variable to a formal date, and coerce our analysis variable to numeric
main <- indata %>% 
    filter(Date %in% c("1/2/2007", "2/2/2007")) %>%
    select(Date, Global_active_power) %>%
    mutate(Date = as.Date(Date, format = "%d/%m/%Y"),
           Global_active_power = as.numeric(Global_active_power))

# Initialize the PNG file creation
png("plot1.png", width = 480, height = 480)

# Generate the histogram
hist(main$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")

# Close the PNG device
dev.off()