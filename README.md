# "Getting And Cleaning Data" Course Project

Coursera "Getting and Cleaning Data" (John Hopkins) course  
Course Project  
Jon Ide

### Project instructions:
You should create one R script called run_analysis.R that does the following.  
1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.   
3. Uses descriptive activity names to name the activities in the data set  
4. Appropriately labels the data set with descriptive variable names.   
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

### Outline of run_analysis.R:
 
0. Note: It is assumed that the working directory in which run_analysis.R is run contains subfolders "test" and "train"  
1. Read 'features.txt' file into _features_ data frame  
2. Read 'activity_labels.txt' file into _activity_labels_ data frame  
3. Read the training data  
  * Read the training data 'x_train.txt' file into data frame _x_train_   
  * Read the training data activity codes 'y_train.txt' file into data frame _y_train_   
  * Read the training data subject codes 'subject_train.txt' file into data frame _subject_train_  
4. Read the test data
  * Read the test data 'x_test.txt' file into data frame _x_test_   
  * Read the test data activity codes 'y_test.txt' file into data frame _y_test_   
  * Read the test data subject codes 'subject_test.txt' file into data frame _subject_test_  
5. Use rbind to combine the training and testing measurement data into data frame _x_combined_  
6. Find the columns containing "-mean()" or "-std()" and keep just those columns in data frame _x_combined_means_sds_  
7. Use rbind to combine the training and testing activity codes into data frame _y_combined_ with column name "Activity"  
8. Use rbind to combine the training and testing subjects into data frame _subject_combined_ with column name "Subject"  
9. Replace numeric activity codes in _y_combined_ with their text equivalents
10. Add a column "SubjAct" to _combined_data_ that contains subject and activity concatenated with separator "-". This will be used by group_by.  
11. Using dplyr, create data frame _grouped_:
  * Group by the SubjAct column using group_by  
  * Remove the Subject and Activity columns, using select  
  * Calculate the mean of each variable for each group, using summarize_each  
  * Add a Temp column with SubjAct split to retrieve the Subject and Activity  
12. Restore the Subject and Activity columns and remove the SubjAct and Temp columns 
13. Clean up the variable names  
14. Turn Subject into an integer so it sorts correctly and sort the table on Subject using dplyr's arrange
15. Turn Activity into a factor (not really necessary)
16. Save the tidy data set in text file 'tidy.txt'
