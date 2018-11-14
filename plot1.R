install.packages("lubridate")
install.packages("sqldf")
library(sqldf)
library(lubridate)
zipurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(zipurl,"household_power_consumption.zip",mode="wb")
unzip("household_power_consumption.zip")
HUGEDF <- read.csv(file="household_power_consumption.txt", sep=";", header=TRUE)

#Date
#Time
#Global_active_power
#Global_reactive_power
#Voltage
#Global_intensity
#Sub_metering_1
#Sub_metering_2
#Sub_metering_3

THEDF <- sqldf("select * from HUGEDF where HUGEDF.Date in ('1/2/2007', '2/2/2007') and Global_active_power||Global_reactive_power||Voltage||Global_intensity||Sub_metering_1||Sub_metering_2||Sub_metering_3 not like '%?%'")
THEDF$Date <- as.Date(THEDF$Date, format="%d/%m/%Y")
THEDF$WD <- format(THEDF$Date, format="%a")

#graph1
hist(as.numeric(THEDF$Global_active_power)/500, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")

dev.copy(png, file="plot1.png", width = 480, height = 480)
dev.off()