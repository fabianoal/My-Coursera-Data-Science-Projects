if (!file.exists("./data")){
  dir.create("./data")
}


url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
fileName <- "./data/fixed width file.for"

download.file(url, destfile = fileName, method = "curl")

t <- (read.fwf(fileName, c(27,5,28), header = FALSE,  skip = 4, col.names = c("g","num","r"), n = -1, buffersize = 2000))
t[,2]
library(dplyr)
dp <- tbl_df(t)
dp
summarise(dp, s=sum(num))
