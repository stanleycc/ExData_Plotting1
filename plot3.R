# Check input file. Automatic download it for running
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filename <- "exdata-data-household_power_consumption.zip"
if ( !file.exists(filename) ) {
    download.file( url, filename, mode = "wb", method="curl")
    unzip(filename)
}

# Read test data set
dt <- read.table("./household_power_consumption.txt",header=TRUE,sep=";")

# Convert date and time into a single Date class column
dt$Date <- paste(dt$Date,dt$Time)
colnames(dt)[1] <- "Date_Time"
dt <- subset(dt, ,-c(Time))
dt$Date_Time <- as.POSIXct(strptime(dt$Date_Time,"%d/%m/%Y %H:%M:%S"))

# Convert columns to numeric
dt$Global_active_power <- as.numeric(as.character(dt$Global_active_power))
dt$Global_reactive_power <- as.numeric(as.character(dt$Global_reactive_power))
dt$Voltage <- as.numeric(as.character(dt$Voltage))
dt$Global_intensity <- as.numeric(as.character(dt$Global_intensity))
dt$Sub_metering_1 <- as.numeric(as.character(dt$Sub_metering_1))
dt$Sub_metering_2 <- as.numeric(as.character(dt$Sub_metering_2))
dt$Sub_metering_3 <- as.numeric(as.character(dt$Sub_metering_3))

# Subset the table by Date (2007-02-01 ~ 2007-02-02)
dt <- dt[ (dt$Date_Time >= as.POSIXct("2007-02-01 00:00:00")) & (dt$Date_Time < as.POSIXct("2007-02-03 00:00:00")),]

# Plot by using the base plotting system
with(dt,plot(Date_Time,Sub_metering_1,type="l",ylab="Energy sub metering",xlab=""))
with(dt,lines(Date_Time,Sub_metering_2,col="red"))
with(dt,lines(Date_Time,Sub_metering_3,col="blue"))
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"), pch="", lty=1)

# Save to png
dev.copy(png,file="plot3.png",width = 480, height = 480)
dev.off()
