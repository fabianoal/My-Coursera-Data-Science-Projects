#For this to work, just put the file household_power_consumption.txt on
#the same directory as this script, and hit "source"...

print("Starting script. Cleaning the environment...")
remove(list = ls())

#Setting the work directory for the directory where the script was open from.
setwd(dirname(sys.frame(1)$ofile))
fileName <- "household_power_consumption.txt"

if(!file.exists(fileName)){
  print(paste0("Please, put the household_power_consumption.txt file on the [", getwd() ,"] directory"))
}else{
  print("Loading packages...")
  #Loading necessary packages
  packages <- c("data.table", "dplyr", "lubridate")
  sapply(packages, require, character.only=TRUE, quietly=TRUE)
  
  print("Reading file...")
  #Reading, selecting necessary variables, filtering, tbl'ing and mutating the txt.
  f <- read.table(fileName, na.strings = "?", header = TRUE, sep=";", colClasses = c("character","character", replicate(7, "numeric")), stringsAsFactors = FALSE) %>% 
    filter(grepl("^0?[1|2].0?2.2007", Date)) %>%
    tbl_df %>%
    mutate(DateTime = dmy_hms(paste0(Date, " ", Time)))
  
  head(f, n = 30)
  
  print("Generating plot4.png...")
  png(file="plot4.png", width = 480, height = 480)
  
  par("mar" = c(4,4.1,2,2), mfrow = c(2,2))
  
  with(f, plot(x = DateTime, y = Global_active_power, type = "l",  ylab = "Global Active Power", xlab = ""))
  
  with(f, plot(x = DateTime, y = Voltage, type = "l",  ylab = "Voltage", xlab = "datetime"))
            
  with(f, plot(x = DateTime, y = Sub_metering_1,  ylab = "Energy sub metering", type = "n", xlab = ""))
  with(f, lines(DateTime, Sub_metering_1, col="black"))
  with(f, lines(DateTime, Sub_metering_2, col="red"))
  with(f, lines(DateTime, Sub_metering_3, col="blue"))
  legend("topright", col = c("black", "red", "blue"), legend = names(f)[7:9], lty=1, bty = "n", pt.cex=0.7, cex=0.7)
  
  with(f, plot(x = DateTime, y = Global_reactive_power, type = "l",  ylab = "Global_reactive_power", xlab = "datetime"))
  
  dev.off()
  print("Done!")
}
