#Ex 1
file <- "./data/United States communities.csv"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

if (!file.exists("./data"))
  dir.create("./data")

download.file(url, file, method = "curl")

us_com <- read.csv(file)
strsplit(names(us_com),"wgtp")

# Ex 2
library(dplyr)

file <- "./data/Gross Domestic Product.csv"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(url,file, method = "curl")


f1 <- read.csv(file, header=FALSE, sep=",", stringsAsFactors=FALSE)
library(dplyr)
f1 <- select(filter(f1, !is.na(V1)), V1,V2,V4,V5)
names(f1) <- c("CountryCode", "Rank", "Country", "DomesticGross")
f1$DomesticGross <- gsub("[\\,|\\s]","",f1$DomesticGross)
f1$DomesticGross <- as.numeric(f1$DomesticGross)
f1$Rank <- as.numeric(gsub("[\\,|\\s]","", f1$Rank))
f1 <- filter(f1,!is.na(DomesticGross)&!is.na(Rank))
mean(f1$DomesticGross)


# Ex 3

grep(pattern="^United.*", x=f1$Country)

#Ex 4

file2 <- "./data/Educational Data.csv"

f2 <- read.csv(file2, stringsAsFactors=FALSE)
head(select(f2, Special.Notes))
f2.1 <- unique(select(f2, CountryCode, Special.Notes))
head(f2.1)
f3 <- merge(select(f1,CountryCode, Rank),f2.1, by.x="CountryCode", by.y="CountryCode")

head(f3)
f3$FiscalYearEndingJuly <- grepl(pattern="Fiscal\\syear\\send\\:", x=f3$Special.Notes)
f3$FiscalYearEnd <- gsub("Fiscal\\syear\\send\\:\\s(.*?)\\s.*","\\1", f3$Special.Notes, perl=TRUE)
filter(select(f3, FiscalYearEnd, FiscalYearEndingJuly),FiscalYearEndingJuly)
filter(f3, FiscalYearEnd=="June")
head(select(f3, FiscalYearEnd), n=15)
f3[10,"Special.Notes"]

filter (f3, gsub("Fiscal\\syear\\send\\:\\s[J|j]une\\s.*","\\1", Special.Notes, perl=TRUE) != Special.Notes)



# Ex 5

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 
names(sampleTimes)
sampleTimes
library(lubridate)
sampleTimes$dt <- ymd(sampleTimes$V1)
is(sampleTimes)
NROW(sampleTimes[wday(sampleTimes)==2])
NROW(sampleTimes[year(sampleTimes)==2012 & wday(sampleTimes)==2])