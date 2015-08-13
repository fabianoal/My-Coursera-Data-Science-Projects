#For this to work, just put the file household_power_consumption.txt on
#the same directory as this script, and hit "source"...

#Setting the work directory for the directory where the script was open from.
setwd(dirname(sys.frame(1)$ofile))

#Loading necessary packages
packages <- c("data.table", "dplyr", "tidyr", "lubridate")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

#Defining a method for coergincg de date and time fields.
#setClass("m_Date")
#setAs("m_Date", "character", function(from) dmy(from))
#setClass("m_Hour")
#setAs("m_Hour", "character", function(from) hms(from))

#Reading the txt. As we read the file, whe also will filter it.
fileName <- "household_power_consumption.txt"

f <- read.table(fileName, na.strings = "?", header = TRUE, sep=";", colClasses = c("character","character", replicate(7, "numeric")), stringsAsFactors = FALSE) %>% 
  filter(grepl("^0?[1|2].0?2.2007", Date)) %>%
  tbl_df %>%
  mutate(Date = dmy(Date), Time = hms(Time))

head(f)
png(file="plot1.png", width = 480, height = 480)
hist(f$Global_active_power, col="red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()

