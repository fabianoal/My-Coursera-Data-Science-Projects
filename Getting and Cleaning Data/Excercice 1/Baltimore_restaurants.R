if (!file.exists("./data")){
  dir.create("data")
}

library(XML)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
fileName <- "./data/Baltimore_Restaurants.xml"
download.file(url, destfile = fileName, method = "curl")

dateDownload = date()

dat <- xmlTreeParse(fileName, useInternal=TRUE)

rootNode <- xmlRoot(dat)

xpathSApply(rootNode[[1]],"//row[zipcode='21231']")

remove(dat)
