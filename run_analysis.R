## Creates a temp file, downloads the dataset, and extracts necessary files.

  temp <- tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)

  X_test <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))

  y_test <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
  
  subject_test <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))

  X_train <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))

  y_train <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))
  
  subject_train <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))

  activity_labels <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"))

  features <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
  
  unlink(temp)

## Adds descriptive variable names to the columns in the X_test and X_train
## data sets.  The following applies the names in 'features' to the column names of
## both Test and Train.

  colnames(X_test) <- features[ ,2]

  colnames(X_train) <- features[, 2]
  
## Adds row from 'y_files' to Test and Train data sets.
## These are numbers 1-6 that corresond with 'activity_labels'.

  colnames(y_test) <- "activity"

  X_test <- cbind(y_test, X_test)

  colnames(y_train) <- "activity"

  X_train <- cbind(y_train, X_train)

## Merges Test and Train data sets together.

  data <- rbind(X_test,X_train)

## Adds descriptive activity names to the rows in the combined data set.
## The following function checks to see if the "car" package is installed.
## The "car" package offers any easy find and replace command: recode.

  pkgLoad <- function(x)
  {
    if (!require(x,character.only = TRUE))
    {
      install.packages(x,dep=TRUE, repos='http://star-www.st-andrews.ac.uk/cran/')
      if(!require(x,character.only = TRUE)) stop("Package not found")
    }
      suppressPackageStartupMessages(library(x,character.only=TRUE))
  }
  
  pkgLoad("car")
  
  data <- lapply(data, FUN = function(x) recode(x,"     
                                          1 = 'WALKING'; 
                                          2 = 'WALKING_UPSTAIRS'; 
                                          3 = 'WALKING_DOWNSTAIRS'; 
                                          4 = 'SITTING'; 
                                          5 = 'STANDING';
                                          6 = 'LAYING'
                "))

  data <- data.frame(data)
  
## Adds row from 'subject_files' to the merged data set.
## These are the volunteers unique identifiers.
  
  colnames(subject_test) <- "subject"
  
  colnames(subject_train) <- "subject"
  
  subject <- rbind(subject_test,subject_train)
  
  data <- cbind(subject, data)

## Extracts the mean and standard deviation for each measurement.
## The following subsets the data and only keeps the columns that contain
## "subject", activity", "mean", or "std".
  
  data <- subset(data, select=c(
                          grepl("subject", names(data)) |
                          grepl("activity", names(data)) | 
                          grepl("mean", names(data)) | 
                          grepl("std", names(data)))
                  )
  
## The following loads the "reshape2" package, then use 'melt' to reshape
## the data set, sets the values column to numeric, and uses 'dcast' to 
## calculate the average of each variable for each activity and each subject. 
  
  pkgLoad("reshape2")
  
  tidydata <- melt(data, id=c("subject", "activity"))
  
  tidydata$value <- as.numeric(tidydata$value)
  
  tidydata <- dcast(tidydata, subject+activity~variable, mean)
  
## Finally, the following writes the tidydata data set to a tab delimited
## text file called 'tidydata.txt'.  To read the data set, import
## 'tidydata.txt' into R using this command: df <- read.table("tidydata.txt", header=TRUE)
  
  write.table(tidydata, "tidydata.txt", sep="\t", row.names=FALSE) 
