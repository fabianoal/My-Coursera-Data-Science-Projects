if (!file.exists("./data")){
  dir.create("data")
}

library(xlsx)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"

download.file(url, destfile = "./data/Natural_Gas_Aquisition.xlsx", method = "curl")

dateDownload = date()

dat <- read.xlsx("./data/Natural_Gas_Aquisition.xlsx", sheetIndex=1, colIndex=7:15, rowIndex=18:23)

sum(dat$Zip*dat$Ext,na.rm=T)

remove(dat)
