# For this to work, just put the file household_power_consumption.txt on
# the same directory as this script, and hit "source"...
#
# For this exercise, We'll just sum the emissions for the Baltimore City and plot a bar chart.
#

print("Starting script. Cleaning the environment...")
remove(list = ls())

#Setting the work directory for the directory where the script was open from.
setwd(dirname(sys.frame(1)$ofile))

fileName <- "summarySCC_PM25.rds"
fileName2 <- "Source_Classification_Code.rds"

if(!file.exists(fileName) | !file.exists(fileName2)){
  print(paste0("Please, put the files [", fileName, "] and [", fileName2 ,"] on the [", getwd() ,"] directory"))
}else{
  print("Loading packages...")
  #Loading necessary packages
  packages <- c("data.table", "dplyr", "XML")
  sapply(packages, require, character.only=TRUE, quietly=TRUE)
  
  print("Reading files...")
  #Reading, selecting necessary variables, filtering, tbl'ing and mutating the txt.
  pm25 <- readRDS(fileName)
  scc <- readRDS(fileName2)
  
  #Reading the wikipedia list of counties and states with fips codes...
  print('Reading the wikipedia list of counties and states with fips codes...')
  
  fips.df <- data.frame(cbind(fips = c("24510","06037"), County = c("Los Angeles", "Baltimore")))
  
  print("Filtering only SCC's relatad with coal...")
  pm25.Mobile <- pm25 %>%
                filter(fips %in% fips.df$fips & SCC %in% scc[grepl(x=scc$SCC.Level.One, pattern="Mobile*"),"SCC"]) %>% 
                group_by(fips, year) %>%
                summarise(Emissions = sum(Emissions)) %>%
                mutate(year = as.character(year)) %>%
                inner_join(fips.df) %>%
                select(County,year, Emissions)
                


  library(ggplot2)  
  g <- qplot(x=year, y=Emissions, fill=County,
             data= pm25.Mobile, geom="bar", stat="identity",
             position="dodge", main="Total pm25 Emissions for Vehicle Sources - Comparsion Baltimore 'n Los Angeles", 
             ylab="Total Emissions (tons)", xlab="Year") 

  ggsave("plot6.png", g, width=7.2, height = 4.8, dpi=100)

  print("Done!")
}
