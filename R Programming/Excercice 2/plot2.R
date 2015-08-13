#For this to work, just put the file household_power_consumption.txt on
#the same directory as this script, and hit "source"...

print("Starting script. Cleaning the environment...")
remove(list = ls())

#Setting the work directory for the directory where the script was open from.
setwd("/Users/fabianoal/Documents/Coursera/Material/Exploratory Data Analysis/Project2")
fileName <- "summarySCC_PM25.rds"
fileName2 <- "Source_Classification_Code.rds"

if(!file.exists(fileName) | !file.exists(fileName2)){
  print(paste0("Please, put the files [", fileName, "] and [", fileName2 ,"] on the [", getwd() ,"] directory"))
}else{
  print("Loading packages...")
  #Loading necessary packages
  labelIt <- function(number){
    intervals = c(1000, 1000000, 1000000000)
    sig = c('', 'M', 'MM', 'MMM')
    div = c(1,intervals)
    paste(floor(number / div[findInterval(number,intervals)+1]),  sig[findInterval(number,intervals)+1])
  }
  
  packages <- c("data.table", "dplyr", "reshape2")
  sapply(packages, require, character.only=TRUE, quietly=TRUE)
  
  print("Reading files...")
  #Reading, selecting necessary variables, filtering, tbl'ing and mutating the txt.
  df <- pm25 %>%
    group_by(type,year) %>%
    summarise(TotEmissions = sum(Emissions))
  
  scc <- readRDS(fileName2)
  
  #Sinse there is only one pollutant in the file, it's ok to sum them all...
  tot_by_year <- tapply(pm25$Emissions, pm25$year, sum)

  print('Generating the plot...')
  png(file="plot2.png", width = 480, height = 480)
  
  par("mar" = c(4,4,3,2))
  
  pts <- pretty(c(0,max(as.vector(tot_by_year))), n = 3)

  barplot(tot_by_year, main="Total Baltimore City pm25 Emissions", ylim = c(0,max(pts)), axes = FALSE, col="aquamarine4")
  
  axis(2, at=pts, labels=labelIt(pts), las=1)
  
  title(ylab = "Emissions (tons)")
  title(xlab = "Year", line = 2)
  
  dev.off()
  print("Done!")
}
