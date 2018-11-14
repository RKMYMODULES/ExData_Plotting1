install.packages("lubridate")
install.packages("sqldf")
library(sqldf)
library(lubridate)
zipurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(zipurl,"household_power_consumption.zip",mode="wb")
unzip("household_power_consumption.zip")
HUGEDF2 <- read.csv(file="household_power_consumption.txt", sep=";", header=FALSE)

#Date					 <==> V1
#Time 					 <==> V2
#Global_active_power	 <==> V3
#Global_reactive_power	 <==> V4
#Voltage				 <==> V5
#Global_intensity		 <==> V6
#Sub_metering_1			 <==> V7
#Sub_metering_2			 <==> V8
#Sub_metering_3			 <==> V9

THEDF <- sqldf("select * from HUGEDF2 where V1 in ('1/2/2007', '2/2/2007') and V3||V4||V5||V6||V7||V8||V9 not like '%?%'")
THEDF$V1 <- as.Date(THEDF$V1, format="%d/%m/%Y")
THEDF$WD <- format(THEDF$V1, format="%a")

#graph4
par(mfcol=c(2,2), mar=c(4,4,4,4))
with(THEDF, {
#subgraph1
x_elps=strptime(paste(THEDF$V1,THEDF$V2),"%Y-%m-%d %H:%M:%S",tz = "CET")
y_GAPK=as.numeric(THEDF$V3)/500
plot(x_elps,y_GAPK, ylab="Global Active Power (kilowatts)", pch=".", xlab="")
lines(x=x_elps,y=y_GAPK, lwd="1")
#subgraph2
chooser <- THEDF[as.numeric(THEDF$V9)<14,]
x_elps=strptime(paste(chooser$V1,chooser$V2),"%Y-%m-%d %H:%M:%S",tz = "CET")
y_SM1=as.numeric(chooser$V7)-min(as.numeric(chooser$V7))
y_SM2=as.numeric(chooser$V8)/3- min(as.numeric(chooser$V8)/3)
y_SM3=(as.numeric(chooser$V9) - min(as.numeric(chooser$V9)))*1.7
plot(x_elps,y_SM1, ylab="Global Active Power (kilowatts)", pch=".", xlab="" , yaxt="n")
axis(side=2, at=seq(0,30, by=10))
lines(x=x_elps,y=y_SM1, lwd="1")
lines(x=x_elps,y=y_SM2, lwd="1", col='red')
lines(x=x_elps,y=y_SM3, lwd="1", col='blue')
legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), lwd=1)

#subgraph3
y_VOL=(as.numeric(THEDF$V5)*12*11/14000)+226
x_elps=strptime(paste(THEDF$V1,THEDF$V2),"%Y-%m-%d %H:%M:%S",tz = "CET")
plot(x_elps,y_VOL, ylab="Voltage", pch=".", xlab="datetime")
lines(x=x_elps,y=y_VOL, lwd="1")


#subgraph1
y_GRP=(as.numeric(THEDF$V4)/max(as.numeric(THEDF$V4)))/2
x_elps=strptime(paste(THEDF$V1,THEDF$V2),"%Y-%m-%d %H:%M:%S",tz = "CET")
plot(x_elps,y_GRP, ylab="Global_reactive_power", pch=".", xlab="datetime")
lines(x=x_elps,y=y_GRP, lwd="1")
}
)

dev.copy(png, file="plot4.png", width = 480, height = 480)
dev.off()