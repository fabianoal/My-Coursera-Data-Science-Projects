#Ex 1
file <- "./data/United States communities.csv"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"

if (!file.exists("./data"))
    dir.create("./data")

download.file(url, file, method = "curl")

us_com <- read.csv(file)
us_com$agricultureLogical <- ifelse(us_com$ACR==3 & us_com$AGS == 6, TRUE, FALSE)

which(us_com$agricultureLogical)

# Ex 2
remove(list=ls())
install.packages("jpeg")

file <- "./data/image.jpg"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url, file, method = "curl")

library(jpeg)
img <- readJPEG(file, native = TRUE)

names(img)
head(img)

quantile(img, na.rm=TRUE)
quantile(img, probs=c(0,0.3,0.8,1))

#Ex 3
remove(list=ls())
library(dplyr)

file <- "./data/Gross Domestic Product.csv"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(url,file, method = "curl")

file2 <- "./data/Educational Data.csv"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url,file2, method = "curl")

f1 <- read.csv(file, header=FALSE, sep=",", stringsAsFactors=FALSE)
f2 <- read.csv(file2, stringsAsFactors=FALSE)

f1 <- select(filter(f1, !is.na(V1) & strtrim(V1, width=3) != ""), V1,V2,V4,V5)
names(f1) <- c("CountryCode", "Rank", "Country", "DomesticGross")


f1$Rank <- as.numeric(f1$Rank)
f1<- filter(f1, !is.na(Rank))
unique(f2$CountryCode)
table(unique(f1$CountryCode) %in% unique(f2$CountryCode))
table((f1$CountryCode) %in% (f2$CountryCode))
length(unique(f1$CountryCode))
length(f1$CountryCode)
length(unique(f2$CountryCode))
length(f2$CountryCode)
arrange(f1,desc(Rank))

# Ex 4, same dataset used on 3

remove(f1)
f1 <- read.csv(file, header=FALSE, sep=",", stringsAsFactors=FALSE)


f1 <- select(filter(f1, !is.na(V1) & strtrim(V1, width=3) != ""), V1,V2,V4,V5)
names(f1) <- c("CountryCode", "Rank", "Country", "DomesticGross")


f2.1 <- unique(select(f2, CountryCode, Income.Group))

f3 <- merge(select(f1,CountryCode, Rank),f2.1, by.x="CountryCode", by.y="CountryCode")
names (f3)
head(f3,n=15)
filter(f3, Income.Group == "High income: nonOECD")
filter(f3, Income.Group == "High income: OECD")

head(f3.1,n=15)
f3.1 <- mutate(f3, Rank = as.numeric(gsub("[\\,|\\s]","", Rank)))
filter(f3.1, Income.Group == "High income: nonOECD")
filter(f3.1, Income.Group == "High income: OECD")

f3.1.1 <- group_by(filter(f3.1, !is.na(Rank)), Income.Group)
summarise(f3.1.1, mean(Rank))


# Ex 5

quantile(f3.1$Rank, probs=c(0,0.2,0.4,0.6,0.8,1), na.rm=TRUE)
f3.1$q <- cut(f3.1$Rank, quantile(f3.1$Rank, probs=c(0,0.2,0.4,0.6,0.8,1), na.rm=TRUE))
table(f3.1$q, f3.1$Income.Group)
table(f3.1$Income.Group,f3.1$q)
f3.1 <- group_by(f3.1, Income.Group) 
tail(f3.1)
