################################################################################
# JHU Exploratory Data Analysis - Course Project 1 
# Plot 4: 2x2 grid of plots:
#   (1,1) Line plot of datetime by global active power
#   (1,2) Line plot of datetime by voltage
#   (2,1) Overlaid line plots of datetime by energy sub-meterings
#   (2,2) Line plot of datetime by global reactive power
################################################################################

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
png("plot4.png", width = 480, height = 480)

# Instruct R to grid 4 graphs together in a 2x2 layout
par(mfrow = c(2, 2))

# Generate the line plot for global active power
with(main, plot(datetime, Global_active_power, type = "l", xlab = "", 
                ylab = "Global Active Power"))

# Generate the line plot for voltage
with(main, plot(datetime, Voltage, type = "l", ylab = "Voltage"))

# Generate the overlaid line plots for the sub-meterings and add the corresponding legend
with(main, {
    plot(datetime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
    lines(datetime, Sub_metering_2, col = "red")
    lines(datetime, Sub_metering_3, col = "blue")
    legend("topright", lty = 1, lwd = 2, col = c("black", "red", "blue"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})

# Generate the line plot for global reactive power
with(main, plot(datetime, Global_reactive_power, type = "l"))

# Close the PNG device
dev.off()