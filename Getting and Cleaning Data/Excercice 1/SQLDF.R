if (!file.exists("./data")){
  dir.create("./data")
}


url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
fileName <- "./data/American Community Survey.csv"

download.file(url, destfile = fileName, method = "curl")

dateDownload = date()

acs = read.table(fileName, sep=",", header = TRUE)
names(acs)
library(sqldf)
sqldf ("select pwgtp1 from acs where AGEP < 50")

unique(acs$AGEP)

sqldf ("select distinct AGEP from acs")
