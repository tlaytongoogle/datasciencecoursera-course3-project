# Data Dictionary - run_analysis.R Output

## subject

A positive integer uniquely identifying the subject, the individual to whom the measurements apply.

Equivalent to the values in train/subject\_train.txt and test/subject\_test.txt of the UCI HAR Dataset.

## activity

A label denoting the activity which the measurements were determined to represent.

Derived from the values in train/y\_train.txt and test/y\_test.txt of the UCI HAR Dataset, but presented using the values from activity_labels.txt of that dataset, which are:

* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING
* LAYING

## tBodyAcc-mean()-X ... fBodyBodyGyroJerkMag-std()

A series of numeric values, each describing the average value of a feature over all measurements for a given subject+activity pair. Only mean and standard-deviation features are included in these average values.

Those measurements are in train/X\_train.txt and test/X\_test.txt of the UCI HAR Dataset. The column names are feature names from features.txt of that dataset. Those features are described in features_info.txt of that dataset.

Note that these average values are expressed in floating-point format, not fixed exponential format like the original measurements.