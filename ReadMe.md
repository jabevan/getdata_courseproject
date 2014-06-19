==========================================================================

UCI Human Activity Recognition Using Smartphones Dataset

==========================================================================
Joshua A. Bevan
Coursera - Getting and Cleaning Data, Johns Hopkins University
==========================================================================

The run.analysis.R script creates a temp file, downloads the UCI HAR dataset from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The script then extracts the necessary files from the zip, and closes the temp file.

Next the script adds descriptive variable names to the column in the X_test and X_train data sets.  The script applies the names from the second column in the 'features' data set to the column names of both X_test and X_train.
  
Next the script adds row from the 'y_files' to the X_test and X_train data sets.  These are numbers 1-6 that corresond with 'activity_labels'.  It also applies "activity" to the new column name.

Next the script merges X_test and and X_train together into a combined data set.

 
The script adds descriptive activity names to the rows in the combined data set.  In my research for this project I came across the "car" package, which includes a very simple "recode" command that replaces one variable with another; for example, '1 = 'WALKING'.

However, I noticed some issues installing the package if it already existed on the user's R system, and loading the library if it was already installed.  So I found the following function that checks to see if a package is already installed, and if not, installs the package (suppressing any messages).
  
Finally, the function adds a row in the first column of the merged data set from 'subject_files' to the merged data set.  These are the volunteers unique identifiers.  This part had to be done after the "recode" so that functions search did not find and replace the subject identifiers with the descriptive activity labels.  I searched high and low to see if I could apply "recode" to a single column, but in all my searching it appears to only work across an entire dataframe.

The next step extracts the mean and standard deviation for each measurement.  I felt this was easier than dropping rows.  I use the "grepl" command to find column names with the descriptions I want to keep: "subject", "activity", "mean", or "std".
  
Finally the script creates the "tidydata.txt" file.  The script uses the "pgkLoad" function I created to check for the "cars" package to load the "reshape2" package, then us 'melt' to reshape the data set.  Then I set the values column to numeric, and use 'dcast' to calculate the average of each variable for each activity and each subject.
  
Finally, the last step writes the tidydata data set to a tab delimited text file called 'tidydata.txt'.  

==========================================================================
To read the data set, import 'tidydata.txt' into R using this command: 
df <- read.table("tidydata.txt", header=TRUE)
==========================================================================