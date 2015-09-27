
### Coursera: Getting & Cleaning Data -- Course Project, 9/27/15

# run_analysis.R -- This script handles the following tasks:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set 
          # with the average of each variable for each activity and each subject.

# Source Data can be found at:
     # http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Citation:
     # [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


# Set Working Directory:
setwd("C:/Users/aschultz/Documents/CourseraDataScienceSpecialty/GettingCleaningData")


# Load all packages required to complete this script:
library(dplyr)



# Download and unzip the source accelerometer data from the Samsung Galaxy S study:
dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataset_url, "Dataset.zip")
unzip("Dataset.zip")


# Read in 'features' file, containing variable names for the 561 variables in 'train' and 'test':
features <- read.table("UCI HAR Dataset/features.txt")[,2]


###
# PROJECT REQUIREMENT # 4: Appropriately labels the data set with descriptive variable names:
# Adjust feature names to make them more descriptive & readable:
clean.labels <- gsub("\\(\\)", "", features)
clean.labels <- gsub("Acc", "-Acceleration", clean.labels)
clean.labels <- gsub("Mag", "-Magnitude", clean.labels)
clean.labels <- gsub("^t(.*)$", "\\1-Time", clean.labels)
clean.labels <- gsub("^f(.*)$", "\\1-Frequency", clean.labels)
clean.labels <- gsub("(Jerk|Gyro)", "-\\1", clean.labels)
clean.labels <- gsub("BodyBody", "Body", clean.labels)


# Read in 'train' and 'test' files separately and apply variable names from 'features' with col.names argument:
train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE, 
                    sep = "", col.names = clean.labels)

test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE, 
                   sep = "", col.names = clean.labels)


# Read in 'subject_train' and 'subject_test' files and create variable name "personID" for each:
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE,
                            col.names = "personID")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE,
                            col.names = "personID")

# Apply "personID" column from 'subject_train' and 'subject_test' to 'train' and 'test', respectively:
train <- cbind(train, subject_train)
test <- cbind(test, subject_test)

# Read in 'activity_labels' data:
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE,
                              sep = "", col.names = c("activityID", "activity"))

# Read in 'y_train' and 'y_test' files and create variable name "activityID" for each:
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE, 
                      col.names = "activityID")

y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE,
                     col.names = "activityID")

# Merge "activity" labels to 'y_train' and 'y_test' based on common key "activityID":
y_train <- join(y_train, activity_labels)
y_test <- join(y_test, activity_labels)


###
# PROJECT REQUIREMENT # 3: Use descriptive activity names to name the activities in the data set:
# Apply "activity" column from 'y_train' and 'y_test' to 'train' and 'test, respectively:
train <- cbind(train, y_train)
test <- cbind(test, y_test)


###
# PROJECT REQUIREMENT # 1: Merge 'train' and 'test' to form one data set:
full <- rbind(train, test)
dim(full)
head(full)


###
# PROJECT REQUIREMENT # 2: Extract only the measurements on the mean & std. dev. for each measurement:
# 'extract_full' also includes "personID" and "activity" for identification purposes:
extract_full <- select(full, contains("mean"), contains("std"), personID, activity)


###
# PROJECT REQUIREMENT # 5: Create independent tidy data set with
# Average of each variable for each activity and each subject:
tidy <- extract_full %>%
     group_by(personID, activity) %>%
     summarise_each(funs(mean)) %>%

# Write output txt file:
write.table("tidy.txt", row.names = FALSE)
