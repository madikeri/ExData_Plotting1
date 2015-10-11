plot1 <- function() {
     
     # to set working dir
     setwd("C:/Users/Gayathri Kulathumani/Desktop/1Gayathri/Data Science/course4")
     
     # to load packages
     library(data.table)
     library(lubridate)
     library(graphics)
     
     # to check if the data folder exist or else create one
     if (!file.exists("data")) {
          dir.create("data")
     } # end if
     
     # to check if the data exists or else create one
     if (!file.exists("data/pconsumption.txt")) {
          
          # to download and uzip files
          url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
          destination <- "data/pconsumption.zip"
          download.file(url, destfile = destination)
          unzip("data/pconsumption.zip", exdir = "data", overwrite = TRUE)
          
          # to read file and get only 2 days
          var <- c(rep("character", 2), rep("numeric", 7))
          pconsumption <- read.table("data/household_power_consumption.txt",
                                     header = TRUE, sep = ";", na.strings="?", colClasses=var)
          pconsumption <- pconsumption[pconsumption$Date == "1/2/2007" | 
                                            pconsumption$Date == "2/2/2007",]
          
          # to clean up headings and change date and time 
          col <-c ("Date", "Time", "GlobalActivePower", "GlobalReactivePower", 
                   "Voltage", "GlobalIntensity","SubMetering1", "SubMetering2", 
                   "SubMetering3")
          colnames(pconsumption) <- col
          
          pconsumption$DateTime <- dmy(pconsumption$Date) + hms(pconsumption$Time)
          pconsumption<-pconsumption[,c(10,3:9)]
          
          # to write clean data
          write.table(pconsumption, file="data/power_consumption.txt", sep="|", 
                      row.names=FALSE)
     }  # end if
     
     else {
          
          pconsumption<-read.table("data/power_consumption.txt", header=TRUE, sep="|")
          pconsumption$DateTime<-as.POSIXlt(pconsumption$DateTime)
          
     } # end else
     
     # to remove orig data 
     if (file.exists("data/household_power_consumption.txt")) {
          x <- file.remove("data/household_power_consumption.txt")
     } #end if
     
     #plot graph
     png(filename = "plots/plot1.png", width = 480, height = 480, units="px")
     hist(pconsumption$GlobalActivePower, main ="Global Active Power",
          xlab = "Global Active Power (kilowatts)", col="red")
     
     x<-dev.off()
     
} #end plot1()

