# datasciencecoursera-course3-project

This repository contains two files (other than this README): CodeBook.md and run_analysis.R

## CodeBook.md

A code book describing the structure of the tidy dataset produced by run_analysis.R. It defines each column in the dataset and explains how it relates to the contents of the UCI HAR Dataset.

## run_analysis.R

An R script which, when executed in a working directory containing the UCI HAR Dataset directory, writes a file called averages.txt to the working directory. This file contains a tidy dataset of average feature values.

* This dataset stores one variable in each column: the subject ID, the activity label, and a series of mean and standard-deviation features.
* This dataset's column names are descriptive: "subject" for the subject ID, "activity" for the activity label, and the feature names from the UCI HAR Dataset for each feature. I considered modifying these column names to incorporate the fact that the columns contain _average_ values, i.e. "avg-tBodyAcc-mean()-X", but decided against it because of the additional difficulty doing so would introduce should someone want to programmatically associate the original UCI HAR Dataset feature columns with these columns.
* This dataset stores one observation in each row: the average measurement of those features for a given subject and activity.

The produced file can be read back into the R environment using the command:

    read.table("averages.txt", header = TRUE, colClasses = "factor", check.names = FALSE)

The `colClasses` argument ensures that the subject IDs are read as a factor column instead of an integer one. The `check.names` argument prevents the feature names from being mangled when they are made into column names.