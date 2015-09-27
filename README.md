GettingCleaningData: Course Project

This repository contains R code that downloads and tidies up the Human Activity Recognition data set available at the UCI machine learning repository (source data available here:  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Tidying

The script run_analysis.R produces a tidy data set from the Human Activity Recognition raw data set.

The script does the following:

    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement.
    Uses descriptive activity names to name the activities in the data set
    Appropriately labels the data set with descriptive variable names.
    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


The R script run_analyis.R requires the package dplyr.

To run the script, just type in R:

    source("run_analysis.R")

Script Output

The script outputs the following:

    A tidy data set called "tidy.txt" in the current directory containing the tidy data.
    The tidy data set contains the averages of each variable for each activity and each subject.
