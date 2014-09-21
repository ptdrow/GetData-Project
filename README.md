**GetData-Project**
---------------
This project consist of one script named **run_analysis.R** that runs code to read and process the data of the 'UCI HAR Dataset' folder and write a file of tidy data showing the mean values of each feature variable subsetted for each combination of subject and activity performed in the experiments.

The code executes the function *run_analysis*, wich calls all other functions in the script avoiding saving all the data and temporal variables into the *Global Environment* and prints messages to show at what stage of the processing the run is. At the ends it writes the desired tidy data set into the file 'tidyData.txt'.

Function: *run_analysis*
----
**Input**: None
**Output**: 'tidyData.txt' file.
The function *run_analysis* creates two different tidy data sets, but writes only the second. The first data set is created with the function ***first_data***, which main objective is to read and process the raw data. The second data set is created using the output of the *first_data* function as input to the ***second_data*** function. This second data is written in a text file called **'tidyData.txt'** using the function ***write.table***.

Function: *first_data*
---
**Input:** None
**Output:** list with 3 objects.
**Description:** The function *first_data* starts by reading the raw data in the 'UCI HAR Dataset' with the function ***read_data***. The loaded data is processed for merging the Test and Train data with the ***merge_Test_Train*** function. This merged data is processed for retrieving the descriptive names of the activities (function ***get_Activity***), locating the desired data with the mean and standar deviation values (function ***locate_mean_and_std***) and changing the names of the features for other descriptive names (function ***change_names***). Finally the located desired data is extracted from the raw data and formated with the function ***extract_mean_and_std*** .

Function: *read_data*
---
**Input:** None
**Output:** list with 8 objects.
**Description:** Reads all the required files in the 'UCI HAR Dataset' folder and loads them into variables of the same name as the files. The variables are returned to the function **first_data** environment as a list.
Function: *merge_Test_Train*
---
**Input:** 3 data.frame objects for each experiment. 6 in total.
**Output:** list with 3 objects.
**Description:** merges the different data sets of the Train and Test experiments, using the ***rbind*** function.
Function: *get_Activity*
---
**Input:** 2 data.frame objects.
**Output:** 1 character vector.
**Description:** It takes the merged data that is asociated with the activity type of the observation and substitutes its values for the descriptive names of the activities using the function ***sub*** inside a *for* loop for changing each activity type at each step. It returns a *character* vector after completing the substitutions.
Function: *locate_mean_and_std*
---
**Input:** 1 data.frame.
**Output:** 1 data.frame.
**Description:** It takes the *data.frame* that labels the features and locates the positions where the labels match the desired criteria (mean and standar deviation data) and subsets the matches. It uses the function ***grepl***. Returns the features labels subsetted with the desired criteria.
Function: *change_names*
---
**Input:** 1 data.frame object.
**Output:** 1 character vector.
**Description:** creates a *character* vector from the located features *data.frame* and substitutes (function ***sub*** ) the default descriptive names for new descriptive names. The new descriptive names are described in the ***CodeBook.md*** file.
Function: *extract_mean_and_std*
---
**Input:** 3 data.frame objects and 2 character vectors.
**Output:** 1 data.frame object.
**Description:** creates a *data.frame* with the firsts columns equal to the subjects and activities of the observations. The next columns representing the feature values are then asignen one by one in a for loop. The new descriptive names of the features are assigned at last as attributes with the ***names*** function.
Function: *second_data*
---
**Input:** 1 data.frame object.
**Output:** 1 data.frame object.
**Description:** reads the *data.frame* created with the ***first_data*** function for computing the averages of the features values, subsetting the data by the combinations of subjects and activities. This is done with the ***average_subsets*** function. Afterwards it calls the function ***order_tidy*** ordering the data format it into the proposed tidy data.

Function: *average_subsets*
---
**Input:** 1 data.frame object, 1 character vector.
**Output:** 1 data.frame object.
**Description:** takes the data created with the ***first_data*** function and subsets it by the combinations of subjects and activities using the ***split*** function. Then it creates a preliminar data set by using ***lapply*** to calculate the mean of each column of the subsets by passing a function constructed with ***colMeans*** (of the *datasets* package) as an argument to *lapply*. Returns the preliminar data as a data.frame.

Function: *order_tidy*
---
**Input:** 2 data.frame objects, 1 character vector.
**Output:** 1 data.frame object.
**Description:** takes the data created with the ***average_subsets*** function to use pass it to a new data set, according to the format selected for the tidy data. It uses a two level nested *for* loops to move around the data in relation to the subjects and activities. At each step of this nested loop the new data set gets a new row with the appropiate data for the combination of subjects and activities. The data frame gets the appropiate variable names and re-assign the descriptive names of the activities because they get lost in the previous steps of the function. Afterwards the  data is returned.




