---
title: "run_analysis"
author: "Fabiano Andrade Lima"
date: "January 14, 2015"
output: html_document
---
# Introduction 

For details about the project, please, see [README](./README.md).

# Initial procedures

Here we are going to create our *data* directory and download the required *.zp* file, and them, load the packages we will use for this project.

First, we need to create a "data" dicrectory for our files. I've set de working directory as the ".". If you want to change it, just put the wanted directory into the `setwd` on the *run_analysis.R* script.


```r
if (!file.exists("./data")){
  dir.create("./data")
}

packages <- c("data.table", "dplyr", "tidyr")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
```

```
## data.table      dplyr      tidyr 
##       TRUE       TRUE       TRUE
```

```r
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "./data/project_dataset.zip"
```


Now, time to download the *.zip* file. If the file aready exists in the right place (./data/project_dataset.zip), we will skip the download for saving time.


```r
if (!file.exists(fileName)){
  download.file(url, destfile = fileName, method = "curl")
}
dateDownload = file.info(fileName)[["mtime"]]
```

# Reading data

Ok. file downloaded with date 2015-01-14 16:42:10. Now it's time to load and merge the needed files. Instead of extracting all files from de zip file, I've used a `unz` connection. I'm not shure if it was a good choice in terms of performance (may be it processes the entire zip file for each file I try to read) but, as the dataset wasn't that big, I made the choice of not landing the files inside de zip into my hard drive.

For merging the training and testing datasets, I used `rbindlist` with a `list` consisting of two `read.table` returned objects.


```r
subjects <- rbindlist(list(
        read.table(unz(fileName, "UCI HAR Dataset/train/subject_train.txt", encoding = getOption("encoding"))),
        read.table(unz(fileName, "UCI HAR Dataset/test/subject_test.txt", encoding = getOption("encoding")))
    )
)

activities <- rbindlist(list(
      read.table(unz(fileName, "UCI HAR Dataset/train/y_train.txt", encoding = getOption("encoding"))),
      read.table(unz(fileName, "UCI HAR Dataset/test/y_test.txt", encoding = getOption("encoding")))
  )
)

measurements_full <- rbindlist(list(
  read.table(unz(fileName, "UCI HAR Dataset/train/X_train.txt", encoding = getOption("encoding"))),
  read.table(unz(fileName, "UCI HAR Dataset/test/X_test.txt", encoding = getOption("encoding")))
  )
)

features <- read.table(unz(fileName, "UCI HAR Dataset/features.txt", encoding = getOption("encoding")))
activity_labels <- read.table(unz(fileName, "UCI HAR Dataset/activity_labels.txt", encoding = getOption("encoding")))
```

# Naming variables

One I have all files I need loaded, and knowing that the files doesn`t have headers,  I'll set the variables names.


```r
setnames(activities,c("activity_code")) 
setnames(subjects,c("subject")) 
setnames(activity_labels, c("activity_code", "activity"))
setnames(features,c("num", "nom"))
activity_labels <- tbl_df(activity_labels)
```

For setting the names of *measurements_full*, we use the *features* data table as a parameter for the `as.vector` with the `setnames` function.


```r
setnames(measurements_full,as.vector(features[[2]]))
```

Until now, the *measurements_full* has all 561 variables. Now, we will select only the *mean* and *std* measures. We will use a vector filtered from the features.txt file as parameter for the `[` function on the measurements_full data.table.


```r
selected_features <- as.vector(features[grepl("mean\\(\\)", features$nom) | grepl("std\\(\\)", features$nom),][[2]])
measurements <- measurements_full[,selected_features, with=FALSE]
```

After applying the filtering, the resulting data frame looks like this:


```r
names(measurements)
```

```
##  [1] "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
##  [3] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"           
##  [5] "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"           
##  [7] "tGravityAcc-mean()-X"        "tGravityAcc-mean()-Y"       
##  [9] "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"        
## [11] "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
## [13] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"      
## [15] "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"       
## [17] "tBodyAccJerk-std()-Y"        "tBodyAccJerk-std()-Z"       
## [19] "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"         
## [21] "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"          
## [23] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"          
## [25] "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"     
## [27] "tBodyGyroJerk-mean()-Z"      "tBodyGyroJerk-std()-X"      
## [29] "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"      
## [31] "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
## [33] "tGravityAccMag-mean()"       "tGravityAccMag-std()"       
## [35] "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"      
## [37] "tBodyGyroMag-mean()"         "tBodyGyroMag-std()"         
## [39] "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"     
## [41] "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
## [43] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"           
## [45] "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"           
## [47] "fBodyAccJerk-mean()-X"       "fBodyAccJerk-mean()-Y"      
## [49] "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"       
## [51] "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
## [53] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"         
## [55] "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"          
## [57] "fBodyGyro-std()-Y"           "fBodyGyro-std()-Z"          
## [59] "fBodyAccMag-mean()"          "fBodyAccMag-std()"          
## [61] "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"  
## [63] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"     
## [65] "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()"
```

# Labeling activities

Time to add the labels of activities and at the same time, removing the *activity_code* field (or variable, if you wish )


```r
activity_labels <- tbl_df(activity_labels)
full_dataset <- tbl_df(data.table(subjects, activities, measurements))
final_dataset <- select(left_join(full_dataset, activity_labels, c("activity_code"), copy=TRUE),-(activity_code))
head(final_dataset)
```

```
## Source: local data frame [6 x 68]
## 
##   subject tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z
## 1       1         0.2885845       -0.02029417        -0.1329051
## 2       1         0.2784188       -0.01641057        -0.1235202
## 3       1         0.2796531       -0.01946716        -0.1134617
## 4       1         0.2791739       -0.02620065        -0.1232826
## 5       1         0.2766288       -0.01656965        -0.1153619
## 6       1         0.2771988       -0.01009785        -0.1051373
## Variables not shown: tBodyAcc-std()-X (dbl), tBodyAcc-std()-Y (dbl),
##   tBodyAcc-std()-Z (dbl), tGravityAcc-mean()-X (dbl), tGravityAcc-mean()-Y
##   (dbl), tGravityAcc-mean()-Z (dbl), tGravityAcc-std()-X (dbl),
##   tGravityAcc-std()-Y (dbl), tGravityAcc-std()-Z (dbl),
##   tBodyAccJerk-mean()-X (dbl), tBodyAccJerk-mean()-Y (dbl),
##   tBodyAccJerk-mean()-Z (dbl), tBodyAccJerk-std()-X (dbl),
##   tBodyAccJerk-std()-Y (dbl), tBodyAccJerk-std()-Z (dbl),
##   tBodyGyro-mean()-X (dbl), tBodyGyro-mean()-Y (dbl), tBodyGyro-mean()-Z
##   (dbl), tBodyGyro-std()-X (dbl), tBodyGyro-std()-Y (dbl),
##   tBodyGyro-std()-Z (dbl), tBodyGyroJerk-mean()-X (dbl),
##   tBodyGyroJerk-mean()-Y (dbl), tBodyGyroJerk-mean()-Z (dbl),
##   tBodyGyroJerk-std()-X (dbl), tBodyGyroJerk-std()-Y (dbl),
##   tBodyGyroJerk-std()-Z (dbl), tBodyAccMag-mean() (dbl), tBodyAccMag-std()
##   (dbl), tGravityAccMag-mean() (dbl), tGravityAccMag-std() (dbl),
##   tBodyAccJerkMag-mean() (dbl), tBodyAccJerkMag-std() (dbl),
##   tBodyGyroMag-mean() (dbl), tBodyGyroMag-std() (dbl),
##   tBodyGyroJerkMag-mean() (dbl), tBodyGyroJerkMag-std() (dbl),
##   fBodyAcc-mean()-X (dbl), fBodyAcc-mean()-Y (dbl), fBodyAcc-mean()-Z
##   (dbl), fBodyAcc-std()-X (dbl), fBodyAcc-std()-Y (dbl), fBodyAcc-std()-Z
##   (dbl), fBodyAccJerk-mean()-X (dbl), fBodyAccJerk-mean()-Y (dbl),
##   fBodyAccJerk-mean()-Z (dbl), fBodyAccJerk-std()-X (dbl),
##   fBodyAccJerk-std()-Y (dbl), fBodyAccJerk-std()-Z (dbl),
##   fBodyGyro-mean()-X (dbl), fBodyGyro-mean()-Y (dbl), fBodyGyro-mean()-Z
##   (dbl), fBodyGyro-std()-X (dbl), fBodyGyro-std()-Y (dbl),
##   fBodyGyro-std()-Z (dbl), fBodyAccMag-mean() (dbl), fBodyAccMag-std()
##   (dbl), fBodyBodyAccJerkMag-mean() (dbl), fBodyBodyAccJerkMag-std()
##   (dbl), fBodyBodyGyroMag-mean() (dbl), fBodyBodyGyroMag-std() (dbl),
##   fBodyBodyGyroJerkMag-mean() (dbl), fBodyBodyGyroJerkMag-std() (dbl),
##   activity (fctr)
```

# Making a tidy dataset

For this task, we piped a series of commands using the dplyr's `%>%` functionality.

First, we group our dataset by "activity" and "subject". Then, summarise all columns. Once it's done, we reshape it with `gather` creating a new column: "measure". Now it's time to breakdown the informations on the recently created "measure" column. For this, we use a `separate` that will give us tree columns: measure, function and axis. "measure" and "axis" are fine, but the function needs to become columns. For this, we use `spread` to transform the "function"" column into the "mean" and "std" columns.


```r
dtidy <- final_dataset %>%
  group_by(activity, subject) %>%
  summarise_each(funs(mean)) %>%
  gather(measure, value, -subject, -activity) %>%
  separate(measure, c("measure", "function", "axis")) %>%
  spread("function","value")

head(dtidy)
```

```
## Source: local data frame [6 x 6]
## 
##   activity subject      measure axis       mean        std
## 1   LAYING       1     fBodyAcc    X -0.9390991 -0.9244374
## 2   LAYING       1     fBodyAcc    Y -0.8670652 -0.8336256
## 3   LAYING       1     fBodyAcc    Z -0.8826669 -0.8128916
## 4   LAYING       1 fBodyAccJerk    X -0.9570739 -0.9641607
## 5   LAYING       1 fBodyAccJerk    Y -0.9224626 -0.9322179
## 6   LAYING       1 fBodyAccJerk    Z -0.9480609 -0.9605870
```

# Writing down the results

At the end of the day, this is what we wanted. The final tidy dataset with four observations and two variables exported to the result.txt file.


```r
write.table(dtidy, file="./data/result.txt", row.name=FALSE)
```


