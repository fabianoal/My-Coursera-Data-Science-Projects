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
  #Loading necessary packages
  print("Loading packages...")
  packages <- c("data.table", "dplyr", "lubridate")
  sapply(packages, require, character.only=TRUE, quietly=TRUE)
  
  #Reading, selecting necessary variables, filtering, tbl'ing and mutating the txt.
  print("Reading file...")
  f <- read.table(fileName, na.strings = "?", header = TRUE, sep=";", colClasses = c("character","character", replicate(7, "numeric")), stringsAsFactors = FALSE) %>% 
    select(Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3) %>%
    filter(grepl("^0?[1|2].0?2.2007", Date)) %>%
    tbl_df %>%
    mutate(DateTime = dmy_hms(paste0(Date, " ", Time))) %>%
    select(DateTime, Sub_metering_1, Sub_metering_2, Sub_metering_3)
  
  print("Generating plot3.png...")
  
  png(file="plot3.png", width = 480, height = 480)
  par("mar" = c(3,4.1,1,2))
  
  with(f, plot(x = DateTime, y = Sub_metering_1,  ylab = "Energy sub metering", type = "n"))
  with(f, lines(DateTime, Sub_metering_1, col="black"))
  with(f, lines(DateTime, Sub_metering_2, col="red"))
  with(f, lines(DateTime, Sub_metering_3, col="blue"))
  legend("topright", col = c("black", "red", "blue"), legend = names(f)[2:4], lty=1)
  dev.off()
  
  print("Done!")
}  
