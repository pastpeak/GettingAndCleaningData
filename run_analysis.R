# You should create one R script called run_analysis.R that does the following.
# 1 - Merges the training and the test sets to create one data set.
# 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
# 3 - Uses descriptive activity names to name the activities in the data set
# 4 - Appropriately labels the data set with descriptive variable names.
# 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)

## Modify the following if needed to match your project folder.
## It is assumed that this folder contains subfolders "test" and "train"
# setwd("C:/Courses/Coursera/Data Science (Hopkins)/DS3 Getting and Cleaning Data/Course Project/UCI HAR Dataset")

## From now on, we use only relative folders, so further modifications shouldn't be needed

## Load the feature names
features <- read.table('features.txt')
dim(features)  ## 561  2

activity_labels <- read.table('activity_labels.txt')

## Load the training data
setwd('train')
x_train <- read.table('x_train.txt', sep="")
dim(x_train)  ## 7352  561
y_train <- read.table('y_train.txt', sep="")
dim(y_train)  ## 7352  1
subject_train <- read.table('subject_train.txt', sep="")
dim(subject_train)  ## 7352  1

## Load the test data
setwd('../test')
x_test <- read.table('x_test.txt', sep="")
dim(x_test)  ## 2497  561
y_test <- read.table('y_test.txt', sep="")
dim(y_test)  ## 2497  1
subject_test <- read.table('subject_test.txt', sep="")
dim(subject_test)  ## 2497  1

## Combine training and testing measurement data into one table and provide alphabetic column names
x_combined <- rbind(x_train, x_test)
names(x_combined) <- features$V2
dim(x_combined)  ## 10299  561

## Extract only the columns that are means or standard deviations
keep_columns <- grepl('-mean\\(\\)|-std\\(\\)', colnames(x_combined))
x_combined_means_sds <- subset(x_combined, select=keep_columns)
dim(x_combined_means_sds)  ## 10299  66

## Combine training and testing activity codes
y_combined <- rbind(y_train, y_test)
dim(y_combined)  ## 10299 1
names(y_combined) <- "Activity"

## Combine training and testing subjects
subject_combined <- rbind(subject_train, subject_test)
dim(subject_combined)  ## 10299 1
names(subject_combined) <- "Subject"

## Replace numeric activity codes with their text equivalents
lookup_label <- function(x) as.character(activity_labels[x, "V2"])
y_combined$Activity <- lapply(y_combined$Activity, lookup_label)

## Prepend subject and activity columns to measurements data frame
combined_data <- cbind(subject_combined, y_combined, x_combined_means_sds)
dim(combined_data)  ## 10299 68

# From the above data set, create a second, independent tidy data set 
#  with the average of each variable for each activity and each subject.

# Create a column combining Subject and Activity so we can use it for group_by
combined_data <- combined_data %>% mutate(SubjAct = paste(combined_data$Subject, combined_data$Activity, sep='-'))
# Group by the combination of Subject and Activity and take means
grouped <- group_by(combined_data, SubjAct) %>%   # Group by the combination of Subject and Activity
            select(-(Subject:Activity)) %>%       # Remove Subject and Activity columns since we're not averaging them
            summarize_each(funs(mean)) %>%        # Get the means
            mutate(Temp = strsplit(SubjAct, '-')) # Prepare to restore the Subject and Activity columns by splitting the combination
                                                  #  of Subject and Activity
# Restore the Subject and Activity columns
Activity <- sapply(grouped$Temp, '[[', 2)
grouped <- cbind(Activity, grouped)
Subject <- sapply(grouped$Temp, '[[', 1)
grouped <- cbind(Subject, grouped)

# Get rid of the temporary columns
grouped <- select(grouped, -SubjAct)
grouped <- select(grouped, -Temp)

# We've got the tidy data set
tidy <- grouped

# Clean up the variable names
toClean <- names(tidy)[3:68]
names(tidy)[3:68] <- gsub('^t', 'time', toClean)
names(tidy)[3:68] <- gsub('^f', 'freq', toClean)
names(tidy)[3:68] <- sub('Acc', 'Accel', toClean)
names(tidy)[3:68] <- gsub('[\\(\\)]', '', toClean)
names(tidy)[3:68] <- paste0(names(tidy)[3:68], '.mean')

# Sort it on Subject and turn Activity into a factor
tidy$Subject <- as.integer(tidy$Subject)
tidy <- arrange(tidy, Subject)
tidy$Activity <- as.factor(tidy$Activity)

# Save it as a text file
setwd('..')
write.table(tidy, 'tidy.txt', row.names=FALSE)
