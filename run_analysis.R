# These script reads the UCI Har Dataset and creates a new file of tidy data called 'tidyData.txt'
# The script should be run with the working directory setted at the folder where the 'UCI Har Dataset' folder is located, NOT INSIDE THE 'UCI Har Dataset'
# For runing the analysis just source this script

#DEPENDENCIES
library(datasets)

# Run all functions to read, process and write the data
# Function for reading the files
read_all <- function(){
      
      print("Loading labels...")
      activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
      
      features <- read.table("./UCI HAR Dataset/features.txt") 
      print("... done")      
      
      print("Loading Test data...")
      
      subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
      X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
      y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
      print("... done")
      
      print("Loading Train data...")
      
      subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
      X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
      y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
      print("... done")
      
      list(activity_labels,
           features,
           subject_test,
           X_test,
           y_test,
           subject_train,
           X_train,
           y_train)
      
}

# Function for merging the data from Test with the data from Train
merge_Test_Train <- function(X_test, X_train, y_test, y_train, subject_test, subject_train){
      
      X_Both <- rbind(X_test, X_train)
      y_Both <- rbind(y_test, y_train)
      Subject <- rbind(subject_test, subject_train)
      
      list(X_Both, y_Both, Subject)
      
}

# Function for asigning descriptive names to the activities
get_Activity <- function(y_Both, activity_labels){
      
      Activity <- as.character(y_Both[,1])
      for(i in 1:6){
            current_id <- activity_labels[[i,1]]
            current_name <- activity_labels[[i,2]]
            Activity <- sub(as.character(current_id),current_name, Activity)
      }
      Activity
}

# Function for locating the desired data of means and std
locate_mean_and_std <- function(features){
      
      located <- features[as.logical(grepl("mean()",features[[2]]) + grepl("std()",features[[2]])),]
      located <- located[!grepl("meanFreq()",located[[2]]),]#quiting fron 'located' the weighted averages labeled 'meanFreq()'
      located
      
}

#Function for creatin new descriptive variable names for the tidy data
change_names <- function(located){
      
      variable_names <- as.character(located[,2]) 
      variable_names <- sub("-mean()","Mean", variable_names, fixed=TRUE)
      variable_names <- sub("-std()","STD", variable_names, fixed=TRUE)
      variable_names <- sub("f","f_", variable_names)
      variable_names <- sub("t","t_", variable_names)
      variable_names <- sub("BodyAcc","LIN_", variable_names)
      variable_names <- sub("Acc","_", variable_names)
      variable_names <- sub("BodyGyro","ANG_", variable_names)
      variable_names <- sub("Body","", variable_names)
      variable_names <- sub("Jerk","Jerk_", variable_names)
      variable_names <- sub("Mag","", variable_names)
      variable_names <- sub("Gravity","GRAV", variable_names)
      variable_names <- c("Subject","Activity", variable_names)
      variable_names
      
}

# Function for extracting the desired data, previously located, from the raw data
extract_mean_and_std <- function(Subject, Activity, located, X_Both, variable_names){
      
      dataRelevant <- data.frame(as.factor(Subject[[1]]), Activity)
      
      j <- 2
      for(i in located[[1]]){
            j <- j+1
            dataRelevant[j] <- X_Both[i]
      }
      names(dataRelevant) <- variable_names
      dataRelevant
      
}

# Function for creating subsets of Subject-Activity from the desired data and calculating the mean value for the features values
average_subsets <- function(dataRelevant, variable_names){
      
      #Subsetting
      subsets <- split(dataRelevant, list(dataRelevant$Subject, dataRelevant$Activity))
      # Compute mean on each subset feature column
      preliminar_set <- lapply(subsets, function(x) colMeans(x[, variable_names[3:68]]))
      
      preliminar_set

}

# Function to order the second tiyd data set into the desired tidy data format
order_tidy <- function(activity_labels, preliminar_set, variable_names){
      activities <- sort(activity_labels$V2)
      dataFinal <- data.frame()
      
      for(i in 1:6){
            for(j in 1:30){
                  dataFinal <- rbind(dataFinal, c(j,activities[[i]], preliminar_set[[(i-1)*30+j]]))
            }
            
      }
      names(dataFinal) <- variable_names
      dataFinal$Activity <- gl(6, 30, labels = activities)
      
      dataFinal
}

# Function to create a first tidy data 
first_data <- function(){
      
      print("READING DATA")
      data_Raw <- read_all()
      # data_Raw indexes
      # 1-activity_labels
      # 2-features
      # 3-subject_test
      # 4-X_test,
      # 5-y_test,
      # 6-subject_train,
      # 7-X_train,
      # 8-y_train)
      
      print("READING: Done") 
      
      print("PROCESSING DATA")
      print("Preparing first tidy data set")
      data_Merged <- merge_Test_Train(subject_test = data_Raw[[3]],
                                      X_test = data_Raw[[4]],
                                      y_test = data_Raw[[5]],
                                      subject_train = data_Raw[[6]],
                                      X_train = data_Raw[[7]],
                                      y_train = data_Raw[[8]])
      
      # data_Merged
      # 1-X_Both
      # 2-y_Both
      # 3-Subject
      Activity <- get_Activity(y_Both = data_Merged[[2]], activity_labels = data_Raw[[1]])
      
      located <- locate_mean_and_std(features = data_Raw[[2]])
      
      variable_names <- change_names(located = located)
      
      dataRelevant <- extract_mean_and_std(Subject = data_Merged[[3]],
                                           Activity = Activity,
                                           located = located,
                                           X_Both = data_Merged[[1]],
                                           variable_names = variable_names)
      
      print("...done")
      list(dataRelevant, variable_names, data_Raw[[1]])

}

second_data <- function(firstData){
      
      print("Preparing second tidy data set")
      preliminar_set <- average_subsets(dataRelevant = firstData[[1]],
                                        variable_names = firstData[[2]])
      tidyData <- order_tidy(activity_labels = firstData [[3]],
                             preliminar_set = preliminar_set,
                             variable_names = firstData[[2]])
      print("...done")
      tidyData

}

run_analysis <- function(){
      
      tidyData <- second_data(first_data())
      print("PROCESSING: Done")
      print("WRITING DATA")
      write.table(tidyData, "tidyData.txt", row.names=FALSE, quote=FALSE)
      print("WRITING: Done")

}

run_analysis()

# Optional for checking the data in the file:
# tidyData <- read.table(tidyData.txt, header=TRUE)
# head(tidyData)