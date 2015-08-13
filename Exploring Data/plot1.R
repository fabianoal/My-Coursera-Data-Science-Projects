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
  packages <- c("data.table", "dplyr", "tidyr", "lubridate")
  sapply(packages, require, character.only=TRUE, quietly=TRUE)
  
  #Defining a method for coergincg de date and time fields.
  #setClass("m_Date")
  #setAs("m_Date", "character", function(from) dmy(from))
  #setClass("m_Hour")
  #setAs("m_Hour", "character", function(from) hms(from))
  
  print("Reading file...")
  #Reading the txt. As we read the file, whe also will filter it.
  f <- read.table(fileName, na.strings = "?", header = TRUE, sep=";", colClasses = c("character","character", replicate(7, "numeric")), stringsAsFactors = FALSE) %>% 
      filter(grepl("^0?[1|2].0?2.2007", Date)) %>%
      tbl_df %>%
      mutate(Date = dmy(Date), Time = hms(Time))
  
  print("Generating plot1.png...")
  png(file="plot1.png", width = 480, height = 480)
  with(f, hist(Global_active_power, col="red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)"))
  dev.off()
  print("Done!")
}  
