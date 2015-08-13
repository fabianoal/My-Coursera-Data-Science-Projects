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
    select(Date, Time, Global_active_power) %>%
    filter(grepl("^0?[1|2].0?2.2007", Date)) %>%
    tbl_df %>%
    mutate(DateTime = dmy_hms(paste0(Date, " ", Time))) %>%
    select(DateTime, Global_active_power)
  
  print("Generating png file...")
  
  png(file="plot2.png", width = 480, height = 480)
  par("mar" = c(3,4.1,1,2))
  with(f, plot(x = DateTime, y = Global_active_power, type = "l",  ylab = "Global Active Power (kilowatts)")) #main = "Global Active Power",
  dev.off()
  
  print("Done!")  
}
  
