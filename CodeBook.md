**Code Book**
=======
This code book describes the data presented in the file 'tidyData.txt', which is the output of running the ´run_analysis.R' script with the 'UCI HAR Dataset' folder.
Raw Data
========
The raw data, as obtained from the 'UCI HAR Dataset' folder, presents values of the experiments conducted for measuring with a smartphone the inertial variables values on different subjects performing six different activities. As the original README of the raw data states: "the sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain".
The raw data was originally divided into different files and folders, representing different types of experiments (train and test) and splitting the labels from the values, and the features values from the subject and activity measured. The features values, subject and activity were related each by the row position.
Tidy Data
=======
The tidy data, created with the run_analysis.R script, shows the computed average of the feature values for each combination of subject and activity, instead of all the feature values as in the raw data. Also, the data is presented merged in one file, without discrimination between the train data and the test data. The data is presented in a text file, but is better visualized saving it into a variable using the *read.table* function in R with *header = TRUE* to retrieve the header as the column names.
Rows
--------
The rows represent the data for each combination of subject and activity. There were 30 different subjects and 6 activities, therefore there are 180 rows after the header, wich presents the variable names. The names of the activities were changed to show the descriptive names of the activities (as specified in the 'activity_labels.txt' file of the raw data), instead of the number codes presented in the raw data.
Columns
---------
The columns represent the data for each variable. The first column is for the subject and the second column for the activity. The next columns represent each of the features selected for computing the average of their values for each combination of subject and activity.
Feature variables
----------
The feature variables selected were those from the raw data wich represented the processed mean and standard deviation values for the inertial signals. The labels for the variables were changed from the raw data to show the domain of the signal (time domain or fast fourier transform), the type of velocity, acceleration or jerk measured (linear or angular), the type of statistical meassures (mean or standar deviation), and the direction measured (x, y, z or the magnitude.

**Domain of the signal**
The labels of the features start with a lower case letter showing the domain of the signal, being:

| Domain     | Character |

| :-------   | :---:     |

| Time       | f         |

| FFT        | t         |

**Physical measure type**
The next characters refer to the type of physical measurement, as shown in the next table:

| Type                | Characters |

|          :-----     |      :---: |

| Linear acceleration | LIN        |
| Linear jerk         | LIN_Jerk   |

| Angular velocity    | ANG        |

| Angular jerk        | ANG_Jerk   |

| Gravity             | GRAV       |


**Statistical measure type**
The next characters refer to the type of statistical measurement, as shown in the next table:

| Type               | Characters |

| :-----             |      :---: |

| Mean               | Mean       |

| Standard deviation | STD        |


**Statistical measure type**
The last character shows the direction of the phisical measurement. It relates to the X, Y, Z directions as recorded by the accelerometer and gyroscope of the smartphone. If there is no further character after the statistical measure type, the data shows the magnitude of the vector.

