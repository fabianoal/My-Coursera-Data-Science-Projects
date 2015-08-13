if (!file.exists("./data")){
  dir.create("data")
}

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
fileName <- "./data/2006_survey_housing.csv"

download.file(url, destfile = fileName, method = "curl")

dateDownload = date()

DT <- fread(fileName, sep="auto", sep2="auto", header = "auto")

started.1=proc.time()
mean(DT$pwgtp15,by=DT$SEX)
cat("Op 1 finalizou com ", timetaken(started.1),"\n")

started.1=proc.time()
tapply(DT$pwgtp15,DT$SEX,mean)
cat("Op 2 finalizou com ", timetaken(started.1),"\n")

started.1=proc.time()
sapply(split(DT$pwgtp15,DT$SEX),mean)
cat("Op 3 finalizou com ", timetaken(started.1),"\n")

started.1=proc.time()
DT[,mean(pwgtp15),by=SEX]
cat("Op 4 finalizou com ", timetaken(started.1),"\n")

started.1=proc.time()
mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
cat("Op 5 finalizou com ", timetaken(started.1),"\n")

started.1=proc.time()
rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
cat("Op 6 finalizou com ", timetaken(started.1),"\n")

remove(started.1, DT)
