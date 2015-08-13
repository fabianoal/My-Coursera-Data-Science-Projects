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
  
  labelIt <- function(number){
    intervals = c(1000, 1000000, 1000000000)
    sig = c('', 'M', 'MM', 'MMM')
    div = c(1,intervals)
    paste(floor(number / div[findInterval(number,intervals)+1]),  sig[findInterval(number,intervals)+1])
  }
  
  print("Loading packages...")
  #Loading necessary packages
  packages <- c("data.table", "dplyr", "reshape2")
  sapply(packages, require, character.only=TRUE, quietly=TRUE)
  
  print("Reading files...")
  #Reading, selecting necessary variables, filtering, tbl'ing and mutating the txt.
  pm25 <- readRDS(fileName)
  scc <- readRDS(fileName2)
  head(pm25)
  #Sinse there is only one pollutant in the file, it's ok to sum them all...
  df <- pm25 %>%
        mutate(year = as.factor(year)) %>%
        group_by(type,year) %>%
        summarise(TotEmissions = sum(Emissions))
              
  
  print('Generating the plot...')
  
  brks <- pretty(c(0,max(as.vector(df$TotEmissions))), n = 5)
  lbls <- labelIt(brks)
  g <- qplot(x=year, y=TotEmissions, fill=type, 
             data=df, geom="bar", stat="identity",
             position="dodge", main="Total pm25 Emissions per Type of Source", ylab="Total Emissions (tons)", xlab="Year")
  g <- g + scale_y_continuous(breaks = brks, labels = lbls)

  g
  
  ggsave("plot3.png", g, width = 5, height = 3, dpi = 120)
  print("Done!")
}
