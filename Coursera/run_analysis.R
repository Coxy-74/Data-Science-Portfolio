# run_analysis.R
# Created by Simon Cox on 15-Sep-2019
#
# This script is for the Coursera "Getting and Cleaning Data" course project
#
# It firstly reads in data sets collected from the accelerometers from the Samsung 
# Galaxy S smartphonedoes and then performs the following tasks as required 
# for the project:
#   1. Merges the training and the test sets to create one data set.
#   2. Extracts only the measurements on the mean and standard deviation for 
#      each measurement. 
#   3. Uses descriptive activity names to name the activities in the data set
#   4. Appropriately labels the data set with descriptive variable names. 
#   5. From the data set in step 4, creates a second, independent tidy data set
#      with the average of each variable for each activity and each subject.
#
# NOTE - in this script the steps above are done in a different order as this 
# just seems the most logical way to do it
# 
# The data comes from the dataset at:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#

# This script will use the following libraries:
#   - dplyr
library(dplyr)

# Check if zip file has been downloaded
# Assumption that if it has been downloaded then it has been unzipped

fileList <- list.files()
fileDownloaded <- length(grep("course3.zip",fileList))
if (fileDownloaded == 0) {
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL,destfile = "course3.zip")
    unzip("course3.zip")
}

# Read test and training data into R

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
feature_names <- read.table("./UCI HAR Dataset/features.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
    
# Merge into single data sets for features (x), activities (y) and subjects 
# using rbind
# This is the first part of item 1 in the project

x_merged <- rbind(x_test,x_train)
y_merged <- rbind(y_test,y_train)
subject_merged <- rbind(subject_test,subject_train)


# Assign feature names to column headings in merged features data set.
# Assign an appropriate column heading for the merged subjects data set.
# Note that the activities column heading will be set at a later point in time.
# This is for item 4 in the project

names(x_merged) <- feature_names[,2]
names(subject_merged) <- c("Subject")


# Find feature names that correspond to mean and standard deviation and cut down
# the dataset to just these columns
# This is for item 2 in the project

names_mean_std <- grep("mean()|std()", feature_names[,2])
x_mean_std <- x_merged[names_mean_std]


# Lookup (match) the data in the merged dataset for activities and assign to a new
# dataset.
# This is for item 3 in the project

y_descriptive <- data.frame("Activity" = activity_labels[match(y_merged[,1],activity_labels[,1]),2]
                            , stringsAsFactors = FALSE)


# Append activities  to create a single dataframe with desired features
# and activity information. This is our "tidy" data set.
# This is the second part for item (1) in the project
# The result is a dataset called "tidy_data".

tidy_data <- cbind(subject_merged, y_descriptive,x_mean_std)


# Now calculate the averages by subject and activity
# This is for item 5 in the project

tidy_data_averages <- tidy_data %>% 
                        group_by(Subject,Activity) %>%
                        summarise_all(mean)

# Clean up environment objects so that we are just left with tidy data
# and tidy data averages

rm("activity_labels", "feature_names")
rm("subject_test", "subject_train", "subject_merged")
rm("x_test", "x_train", "x_merged", "x_mean_std")
rm("y_test", "y_train", "y_merged", "y_descriptive")
rm("fileDownloaded", "fileList", "fileURL", "names_mean_std")