---
title: "CodeBook"
author: "Fabiano Andrade Lima"
date: "January 14, 2015"
output: html_document
---

# Introduction

The details about the concepts behinde these measures can be found on the *features_info.txt*.

As stated in the above mentioned file, there some important information on the features names.

Thus, we decided to break it down in two variables: measure and axis, and put the aggregation function on columns. Here is some exemples of this break.  For the tridimensional magnitude signals, the contents of the "axis" column is NA.

field                   |measure       | axis                 | destination variable
----------------------- |-----------   | -------------------  | --------------------
tBodyGyro-mean()-X      |tBodyGyro     |  X                   |     mean
tBodyGyroJerkMag-mean() |tBodyGyroJerk |  NA                  |     mean
tGravityAccMag-mean()   |tGravityAccMag|  NA                  |     mean
tBodyGyroJerk-std()-Z   |tBodyGyroJerk |  Z                   |     std
fBodyGyro-mean()-Y      |fBodyGyro     |  Y                   |     mean

The values for the original mean and std variables reflects the mean and std of samples that forms the so called "windows". Each window had 128 samples. In our dataset, we show the average of these variables in a per activity/subject/measure/axis basis. So, our aggregation reflects all windows that where already calculated.

Hence, our final dataset has four keys for two variables

# Variables in the dataset:

Name     |Description
-----    |----------
activity| One of the following activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
subject| Identifies the subject used for collecting the measures
measure| one of the tBodyGyro|tGravityAccMag|etc... See comments above.
mean| this is the average of the means 
std| this the acctually the average of the original std's

