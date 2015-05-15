## When executed in a working directory containing the UCI HAR Dataset directory, this script
## writes a file called averages.txt to the working directory. This file contains a tidy dataset,
## the average values of the mean and standard-deviation feature measurements from the UCI HAR Dataser,
## aggregated by subject and activity.

# Requires the data.table package
library(data.table)



## Loads the training and testing subject IDs, mean and std measurements, and activities in a tidy data set.
## Requires that the working directory contain the UCI HAR Dataset.

load.data  <- function() {
  
  # read subject IDs from a file
  read.data.subject <- function(file) {
    read.table(file, col.names = c("subject"), colClasses = c("factor"))
  }
  
  # load and merge training and testing data subject IDs
  train.data.subject <- read.data.subject("UCI HAR Dataset/train/subject_train.txt")
  test.data.subject <- read.data.subject("UCI HAR Dataset/test/subject_test.txt")
  data.subject <- rbind(train.data.subject, test.data.subject)
  
  
  
  # load the feature names
  feature.names <- read.table(
    "UCI HAR Dataset/features.txt",
    col.names = c("row.number", "feature.name"),
    row.names = 1, # interpret first column as row numbers
    stringsAsFactors = FALSE
    )$feature.name
  
  # read mean and std measurements from a file, using the feature names as column names
  read.data.X <- function(file) {
    features.to.use <- grepl("mean()", feature.names, fixed = TRUE) | grepl("std()", feature.names, fixed = TRUE)
    data.X <- read.table(
      file,
      col.names = feature.names,
      colClasses = ifelse(features.to.use, NA, "NULL"), # reads only mean and std columns
      check.names = FALSE)
  }
  
  # load and merge training and testing data measurements
  train.data.X <- read.data.X("UCI HAR Dataset/train/X_train.txt")
  test.data.X <- read.data.X("UCI HAR Dataset/test/X_test.txt")
  data.X <- rbind(train.data.X, test.data.X)
  
  
  
  # load the activity labels
  activity.labels = read.table(
    "UCI HAR Dataset/activity_labels.txt",
    col.names = c("row.number", "activity.label"),
    row.names = 1, # interpret first column as row numbers
    stringsAsFactors = FALSE
  )$activity.label
  
  # read activities from a file
  read.data.y <- function(file) {
    data.y <- read.table(file, col.names = c("activity"))
    # replace the activity column's integer values with corresponding activity labels
    data.y$activity <- factor(data.y$activity, levels = 1:length(activity.labels), labels = activity.labels)
    data.y
  }
  
  # load and merge training and testing data activities
  train.data.y <- read.data.y("UCI HAR Dataset/train/y_train.txt")
  test.data.y <- read.data.y("UCI HAR Dataset/test/y_test.txt")
  data.y <- rbind(train.data.y, test.data.y)
  
  
  
  # merge data subject IDs, measurements and activities
  cbind(data.subject, data.y, data.X)
}



## Takes a data set in the format produced by load.data() and calculates the average value of each measurement,
## grouped by subject ID and activity.

make.avg.data <- function(data) {
  # Note that, although this function makes use of data.table, the input and output are both data frames
  data <- data.table(data)
  avg.data <- data[, lapply(.SD, mean), by = list(subject, activity)]
  as.data.frame(avg.data)
}



data <- load.data()
avg.data <- make.avg.data(data)

write.table(avg.data, "averages.txt", quote = FALSE, row.names = FALSE)