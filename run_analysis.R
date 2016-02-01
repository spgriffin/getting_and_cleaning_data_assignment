######################################################################
## This script is used to tidy a specific smartphone 
## activity dataset.  The script performs the following:
## (1) downloads the data from a URL
## (2) merges the data and extracts only the 
##     measurements on the mean and standard deviation for 
##     each measurement
## (3) Uses descriptive activity names to name the activities 
##     in the data set
## (4) Appropriately labels the data set with descriptive 
##     variable names.
## (5) Creates a second, independent tidy data set with the 
##     average of each variable for each activity and each subject
##     from the dataset created in Step 4
#######################################################################
##
##  Running the script: 
##  Set the working directory 
##  Source the Script
##
#######################################################################

## check for data.table library
packages <- c("data.table","dplyr")
new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

## load required libraries
library(data.table) 
library(dplyr)

## prints working directory to console
print(getwd())

## creates a folder in the working directory called "data" if it does not exist
if(!file.exists("./data")){
  dir.create("./data")}

## download data if it does not exist
if(!file.exists("./data/activity_data.zip")) {
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/activity_data.zip",method="auto")
unzip(zipfile="./data/activity_data.zip",exdir="./data") ## files unzip to "UCI HAR Dataset"
}

## recursively list all files
files <- list.files("./data/UCI HAR Dataset", recursive=TRUE)
files

## reads feature list and activity labels
feature.label <- read.table("./data/UCI HAR Dataset/features.txt")
activity.label <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)

## reads training labels, sets, and subjects 
train.label <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
train.set <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
train.subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

## reads test labels, sets, and subjects 
test.set <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
test.label <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
test.subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)

## merge the datasets, labels, and subject into the variables below
subject <- rbind(train.subject, test.subject)
activity <- rbind(train.label, test.label)
feature <- rbind(train.set, test.set)

## add column names to data
colnames(subject) <- "Subject"
colnames(activity) <- "Activity"
feature.column <- data.frame(feature.label) ## covert to dataframe and extract labels
colnames(feature) <- feature.column$V2

## merge all data into one
data.temp <- cbind(subject, activity)
merged.data <- cbind(feature, data.temp)
rm(data.temp)

## extract only mean and standard deviation for each measurement
## use grep to create index of columns with of mean and standard deviaion 
MeanSTDev <- grep("mean\\(\\)|std\\(\\)|Subject|Activity", names(merged.data), ignore.case=TRUE)
merged.data <- merged.data[MeanSTDev]


## loop through Activity and change integer to descriptive name
for (i in 1:6){
  activity.type <- c("Walking","Walking Upstairs","Walking Downstairs","Sitting",
                     "Standing", "Laying")
  merged.data$Activity[merged.data$Activity == i] <- as.character(activity.type[i])
}
merged.data$Activity<- as.factor(merged.data$Activity)

## find number of subjects and sort
subject.number <- sort(unique(merged.data$Subject))

## create empty character vector and loop to create Subject list
subject.list <- paste("Subject", formatC(subject.number, width=2, flag="0"), sep="-")

## loop through Subject and change integer to descriptive name
for (j in subject.number){
  merged.data$Subject[merged.data$Subject == j] <- as.character(subject.list[j])
}
merged.data$Subject <- as.factor(merged.data$Subject)


## create final and tidy data table
final.dt <- data.table(merged.data)

## average of each variable for each activity and each subject using subset of data table (.SD).
tidy.data <- final.dt[, lapply(.SD, mean), by = 'Activity,Subject']

# arrange data according to Subject number
tidy.data <- arrange(tidy.data, tidy.data$Subject)

## write tidy.data to text file
write.table(tidy.data, file = "./data/tidy_data.txt", row.names = FALSE)

## view data table
View(tidy.data)