# Getting and Cleaning Data Project
## This project serves as the final class assignment for the Johns Hopkins Coursera class, Getting and Cleaning Data

## Purpose
### The purpose of this project is to create a script that downloads a "raw" dataset from a predetermined URL and automatically "tidy" the data for further analysis.  The script developed to tidy the data(run_analysis.R) does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.  The output is called tidy_data.txt.

## Running the Script
### Set your working directory in R and source run_analysis.R

## Process
### The process is also documented in the script itself.

1. Automatically load required libraries.  The script will install the library if it does not exist.
2. Create data directory for data storage.
3. Download file from URL and unzip into data directory.
4. Read the test and train datasets and merge into an interim dataset.
5. Put each variable (Activity, Subject, and Feature) into it's own column and add column names
6. Identify and extract features with the mean and standard deviation.
7. Label each Activity
8. Label each Subject
9. Add column names to data.
10.Rejoin the entire table, keying on subject/acitivity pairs, applying the mean function to each vector of values in each subject/activity pair and write "tidy" dataset to disk.