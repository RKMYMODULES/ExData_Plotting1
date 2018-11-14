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

#graph2
x_elps=strptime(paste(THEDF$Date,THEDF$Time),"%Y-%m-%d %H:%M:%S",tz = "CET")
y_GAPK=as.numeric(THEDF$Global_active_power)/500
plot(x_elps,y_GAPK, ylab="Global Active Power (kilowatts)", pch=".", xlab="")
lines(x=x_elps,y=y_GAPK, lwd="1")

dev.copy(png, file="plot2.png", width = 480, height = 480)
dev.off()