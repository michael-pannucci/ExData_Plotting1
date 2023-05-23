################################################################################
# JHU Exploratory Data Analysis - Course Project 1 
# Plot 2: Line plot of datetime by global active power
################################################################################

# Preliminaries
library(data.table)
library(dplyr)
setwd("/Users/mpannucc/Documents/R/DS291/Course Project 1")
filename <- "project1_data.zip"

# Checking if zip file alrady exists in the environment
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

# Filter out only the dates we need, keep only the variables we need, create a 
# datetime variable, coerce the date variable to a formal date, and coerce our
# analysis variables to numeric
main <- indata %>% 
    filter(Date %in% c("1/2/2007", "2/2/2007")) %>%
    select(-Global_intensity) %>%
    mutate(datetime = strptime(paste(Date, Time, sep = " "), format = "%d/%m/%Y %H:%M:%S"), 
           Date = as.Date(Date, format = "%d/%m/%Y"),
           Global_active_power = as.numeric(Global_active_power),
           Global_reactive_power = as.numeric(Global_reactive_power),
           Voltage = as.numeric(Voltage),
           Sub_metering_1 = as.numeric(Sub_metering_1),
           Sub_metering_2 = as.numeric(Sub_metering_2),
           Sub_metering_3 = as.numeric(Sub_metering_3))

# Initialize the PNG file creation
png("plot2.png", width = 480, height = 480)

# Generate the line plot
with(main, plot(datetime, Global_active_power, type = "l", xlab = "", 
                ylab = "Global Active Power (kilowatts)"))

# Close the PNG device
dev.off()