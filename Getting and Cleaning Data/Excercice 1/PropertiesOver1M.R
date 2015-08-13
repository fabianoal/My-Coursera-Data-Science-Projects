if (!file.exists("./data")){
  dir.create("data")
}

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

download.file(url, destfile = "./data/housing_for_idaho.csv", method = "curl")

dateDownload = date()

housing <- read.table("./data/housing_for_idaho.csv", sep=",", header = TRUE)

nrow(housing[!is.na(housing$VAL) & housing$VAL == "24",])

remove(housing)
