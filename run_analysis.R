setwd("c:/Users/rowland1/Desktop/Coursera_DataScience/Course3Project2")
getwd()

## Pre-steps##
#Load relevant packages#
library("dplyr")
library("stringr")
packages <- c("dplyr", "data.table", "reshape2","stringr")
sapply(packages, require, character.only=TRUE, quietly = TRUE)

#download files#

fileUrl <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
d <-"Dataset.zip"
if (!file.exists("./data")) {dir.create("./data")}
download.file(fileUrl,file.path("./data",d))

#Unzip files#
unzip("./data/Dataset.zip")

#set reusable input path#
pathmain <- file.path("./UCI HAR Dataset")
list.files(pathmain,recursive = TRUE)

#read files#
dtsubject_train <- data.table(read.table(file.path(pathmain, "train", "subject_train.txt")))
dtx_train <- data.table(read.table(file.path(pathmain, "train", "X_train.txt")))
dty_train <- data.table(read.table(file.path(pathmain, "train", "y_train.txt")))
dtsubject_test <- data.table(read.table(file.path(pathmain, "test", "subject_test.txt")))
dtx_test <- data.table(read.table(file.path(pathmain, "test", "X_test.txt")))
dty_test <- data.table(read.table(file.path(pathmain, "test", "Y_test.txt")))
dtfeatures <- data.table(read.table(file.path(pathmain, "features.txt")))
dtactivities <- data.table(read.table(file.path(pathmain, "activity_labels.txt")))

##1. Merges the training and the test sets to create one data set.##
dtsub_all <- rbind(dtsubject_test, dtsubject_train)
dtact_all <- rbind(dty_test, dty_train)
dtsub_act_all <- cbind(dtsub_all, dtact_all)
names(dtsub_act_all) <- c('Subject', 'ActivityNumber')
dt <- rbind(dtx_test, dtx_train)
dt_all <- cbind(dtsub_act_all, dt)
setkey(dt_all,Subject,ActivityNumber)

##2. Extracts only the measurements on the mean and standard deviation for each measurement.##
names(dtfeatures) <- c('FeatureNumber', 'FeatureName')
table(grepl("mean|std", dtfeatures$FeatureName,ignore.case = TRUE))
dtfeatures2 <- dtfeatures[grepl("mean|std", FeatureName, ignore.case = TRUE)]
dtfeatures2$FeatureLable <- paste('V', dtfeatures2$FeatureNumber, sep = "")

dt_allfiltered <- dt_all[,c(key(dt_all), dtfeatures2$FeatureLable), with=F]

##3. Uses descriptive activity names to name the activities in the data set##
setnames(dt_allfiltered, old = dtfeatures2$FeatureLable, new = as.character(dtfeatures2$FeatureName))
names(dtactivities) <- c('ActivityNumber', 'ActivityName')
dt_allfiltered_activity <- merge(dtactivities, dt_allfiltered, by='ActivityNumber')
setkey(dt_allfiltered_activity, ActivityName, ActivityNumber, Subject)

##4. Appropriately labels the data set with descriptive variable names.##

dt_allfiltered_activity_melt <- data.table(melt(dt_allfiltered_activity, key(dt_allfiltered_activity), variable.name = "featurecode"))
dt_allfiltered_activity_melt$Activity < - factor(dt_allfiltered_activity_melt$ActivityName)
dt_allfiltered_activity_melt$Feature <- factor(dt_allfiltered_activity_melt$featurecode)

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.##

dt_tidy <- dt_allfiltered_activity_melt %>% group_by(ActivityName, Subject, featurecode) %>% summarise_all(mean)
dt_tidy$Feature <- NULL
dt_tidy$FeatureDomain <- NULL
dt_tidy$ActivityNumber <- NULL
dt_tidy <- dcast(dt_tidy, dt_tidy$ActivityName+dt_tidy$Subject ~ dt_tidy$featurecode, mean)

write.table(dt_tidy, file.path(pathmain, 'tidy.txt'), row.names = FALSE)

