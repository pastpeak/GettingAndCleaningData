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
 
### Outline of run_analysis.R
1. Read 'features.txt' file into features data frame  
2. Read 'activity_labels.txt' file into activity_labels data frame  
3. Read the training data  
  * Read the training data 'x_train.txt' file into data frame x_train   
  * Read the training data activity codes 'y_train.txt' file into data frame y_train   
  * Read the training data subject codes 'subject_train.txt' file into data frame subject_train  
4. Read the test data
  * Read the test data 'x_test.txt' file into data frame x_test   
  * Read the test data activity codes 'y_test.txt' file into data frame y_test   
  * Read the test data subject codes 'subject_test.txt' file into data frame subject_test  
5. Use rbind to combine the training and testing measurement data into data frame x_combined  
6. Find the columns containing "-mean()" or "-std()" and keep just those columns in data frame x_combined_means_sds  
7. Use rbind to combine the training and testing activity codes into data frame y_combined with column name "Activity"  
8. Use rbind to combine the training and testing subjects into data frame subject_combined with column name "Subject"  
9. Replace numeric activity codes in y_combined with their text equivalents
10. Add a column "SubjAct" to combined_data that contains subject and activity concatenated with separator "-". This will be used by group_by.  
11. Using dplyr, create data frame grouped:
  * Group by the SubjAct column using group_by  
  * Remove the Subject and Activity columns, using select  
  * Calculate the mean of each variable for each group, using summarize_each  
  * Add a Temp column with SubjAct split to retrieve the Subject and Activity  
12. Restore the Subject and Activity columns and remove the SubjAct and Temp columns  
13. Turn Subject into an integer so it sorts correctly and sort the table on Subject using dplyr's arrange
14. Turn Activity into a factor (not really necessary)
15. Save the tidy data set in text file 'tidy.txt'
