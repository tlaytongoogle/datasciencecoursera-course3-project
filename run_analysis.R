## When executed in a working directory containing the UCI HAR Dataset directory, this script
## writes a file called averages.txt to the working directory. This file contains a tidy dataset,
## the average values of the mean and standard-deviation feature measurements from the UCI HAR Dataset,
## aggregated by subject and activity.



## Loads the training and testing subject IDs, mean and std measurements, and activities in a tidy data set.
## Requires that the working directory contain the UCI HAR Dataset, rooted in a subdirectory named "UCI HAR Dataset".

load.data  <- function() {
  
  # read subject IDs from a file
  read.data.subject <- function(file) {
    read.table(file,
      col.names = c("id"),
      colClasses = c("factor"))
  }
  
  # load and merge training and testing data subject IDs
  train.data.subject <- read.data.subject("UCI HAR Dataset/train/subject_train.txt")
  test.data.subject <- read.data.subject("UCI HAR Dataset/test/subject_test.txt")
  data.subject <- rbind(train.data.subject, test.data.subject)
  
  
  # load the feature names
  features <- read.table(
    "UCI HAR Dataset/features.txt",
    col.names = c("id", "name"),
    stringsAsFactors = FALSE) # leave the feature names as character strings
  
  # make sure the features are ordered by id
  features <- features[order(features$id),]
  
  # read mean and std measurements from a file, using the feature names as column names
  read.data.X <- function(file) {
    # logical vector denoting each feature name which contains "mean()" or "std()"
    features.to.use <- grepl("mean()", features$name, fixed = TRUE) | grepl("std()", features$name, fixed = TRUE)
    data.X <- read.table(
      file,
      col.names = features$name,
      colClasses = ifelse(features.to.use, NA, "NULL"), # read only mean and std columns
      check.names = FALSE) # don't mangle the feature names
  }
  
  # load and merge training and testing data measurements
  train.data.X <- read.data.X("UCI HAR Dataset/train/X_train.txt")
  test.data.X <- read.data.X("UCI HAR Dataset/test/X_test.txt")
  data.X <- rbind(train.data.X, test.data.X)
  
  
  # load the activity labels
  activities = read.table(
    "UCI HAR Dataset/activity_labels.txt",
    col.names = c("id", "label"),
    stringsAsFactors = FALSE) # leave the activity labels as character strings
  
  # read activities from a file
  read.data.y <- function(file) {
    data.y <- read.table(file, col.names = c("activity"))
    # replace the activity column's integer values with corresponding activity labels
    data.y$activity <- factor(data.y$activity, levels = activities$id, labels = activities$label)
    data.y
  }
  
  # load and merge training and testing data activities
  train.data.y <- read.data.y("UCI HAR Dataset/train/y_train.txt")
  test.data.y <- read.data.y("UCI HAR Dataset/test/y_test.txt")
  data.y <- rbind(train.data.y, test.data.y)
  
  
  # merge data subject IDs, measurements and activities
  cbind(subject = data.subject$id, data.y, data.X)
}



## Takes a data set in the format produced by load.data() and calculates the average value of each measurement,
## grouped by subject ID and activity.

make.avg.data <- function(data) {
  # average all other columns by subject and activity columns
  aggregate(. ~ subject + activity, data, mean)
}



data <- load.data()
avg.data <- make.avg.data(data)

write.table(avg.data, "averages.txt", quote = FALSE, row.names = FALSE)