# Getting and Cleaning Data Course Project

## Abstraction
Produces a tidy data set from the [Human Activity Recognition](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) [database](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) that extracts only the measurements related to the mean and standard deviation from the set of 561 variables recorded and then produces a 2nd tidy data set that takes the average for each of those variables according to the participant and the activity that produced those results.

## Technical Specs
Before I jump in and describe the work that I did to produce my results, let me take a minute to tell you about the computer I used and the versions of R and R Studio.
 * MacBook Pro: OS X El Capitan, Version 10.11.6
 * Processor: 2.2 GHz Intel Core i7
 * Memory 16 GB 1600 MHz DDR3
 * RStudio: Version 0.99.903 – © 2009-2016 RStudio, Inc.
 * R version 3.3.1 (2016-06-21) -- "Bug in Your Hair"
   * Platform: x86_64-apple-darwin13.4.0 (64-bit)

## The Data
The data is a database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone (Samsung Galaxy S2) with embedded inertial sensors (accelerometer and gyroscope). These subjects were divided into two classifications: test and training. 30% of participants were selected to participate in the _test_ group and the other 70% were choosen for the _training_ group (so, 9 and 21 respectively). The "activities of daily living" that were performed are as follows:
 1. Walking
 2. Walking Upstairs
 3. Walking Downstairs
 4. Sitting
 5. Standing
 6. Laying
 
The signals from the accelerometer and gyroscope were processed by applying noise filters and sampled over sliding windows of 2.56 sec with 50% overlap (128 readings/window). The sensor acceleration signal was separated using a Butterworth low-pass filter into two components: body acceleration and gravity. The gravitational force was assumed to have only low frequency components, so a filter with 0.3 Hz cutoff frequency was used. From the sampling windows, a vector of features (see the [CodeBook](CodeBook.md)) was obtained by calculating the variables from the time and frequency domain. See 'UCI_HAR_Dataset/features_info.txt' for more details. 
 
For the purposes of this project, of the features calculated, only the mean and standard deviation (std) were of interest.

### Getting the Data
From the Mac terminal I ran the following commands to pull the dataset:
~~~~
$ cd ~/Documents/datasciencecoursera/DataCleaning/DataCleaningCourseProject/
$ wget https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
$ unzip getdata%2Fprojectfiles%2FUCI\ HAR\ Dataset.zip
$ mv UCI\ HAR\ Dataset/ UCI_HAR_Dataset/
~~~~
Finding that the unzipped directory name was _UCI HAR Dataset/_, I renamed it to _UCI_HAR_Dataset/_ just so it was easier to work with in the code and my personal preference that directory names don't have spaces in them.

### Analyzing the Data
Once the data was pulled down, I decided to visually inspect the contents of the _UCI_HAR_Dataset/_:
~~~~
-rw-r--r--  1 xxxxxxx  xxxxx   4453 Nov 18 14:47 README.txt
-rw-r--r--  1 xxxxxxx  xxxxx     80 Nov 18 14:47 activity_labels.txt
-rw-r--r--  1 xxxxxxx  xxxxx  15785 Nov 18 14:47 features.txt
-rw-r--r--  1 xxxxxxx  xxxxx   2809 Nov 18 14:47 features_info.txt
drwxr-xr-x  6 xxxxxxx  xxxxx    204 Nov 18 14:47 test
drwxr-xr-x  6 xxxxxxx  xxxxx    204 Nov 18 14:47 train
~~~~

#### README.txt

- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

### Test Data
During the test phase, there were 2,947 observations made of 561 variables. The participants who took part of the test were:
 * 2
 * 4
 * 9
 * 10
 * 12
 * 13
 * 18
 * 20
 * 24

### Training Data
During the training phase, there were 7,352 observations made of 561 variables. The participants who took part of the training were:
 * 1
 * 3
 * 5
 * 6
 * 7
 * 8
 * 11
 * 14
 * 15
 * 16
 * 17
 * 19
 * 21
 * 22
 * 23
 * 25
 * 26
 * 27
 * 28
 * 29
 * 30

## Creating the Initial Data Set
To start, I mined the features.txt from the UCI_HAR_Dataset/ folder for variables related to mean and standard deviation. Here I determined the column inidicies related to these variables. I also too the oppurtunity to prep the column names by converting them to lower case and removing the () from the names:
~~~~
features <- read.table("features.txt")
colNam <- features$V2
colNam <- tolower(colNam)
colNam <- gsub('\\(|\\)', '', colNam)
colNum <- grep("mean|std", features$V2)
~~~~

To create the initial data set, my approach was to combine the X_, y_, and subject_ files into a single data frame. 
~~~~
X <- read.table(X_, numerals = "no.loss", col.names = colNam)
X <- X[,colNum]
y <- read.table(y_)
y <- rename(y, Activity = V1)
subject <- read.table(subject_)
subject <- rename(subject, Participant = V1)
cbind(subject, y, X)
~~~~

This was done for both test and training data. Once data frames were assembled for both, I then combined the two data frames into one.
~~~~
library(dplyr)
bind_rows(test, train)
~~~~

After I had one data set representing the means and standard deviations, I filtered the activities and applied the factor from activity_labels.txt file so that the activities in the data set were human readable.
~~~~
library(dplyr)
al <- read.table("acitivity_labels.txt)
mutate(harDataSet, Activity = factor(Activity, labels = al$V2))
~~~~

This data set was then written out to a CSV file as the  [initial_data_set](initial_data_set.csv). This data set has 10,299 observations of 81 variables.

## Summarizing the Initial Data Set (the second, independent tidy data set)
The initial data set had every observation of each participant for every ativity that they performed. What I tried to do here was to collapse that initial data of 10,299 observations down into the averages of each activity that each participant performed. So in short, create a new data set that had 180 observations (30 pariticipants * 6 activities) of 81 variables.

To do this I first segmented the pariticipants, and then from each participant, I segmented each activity. And from this, I calculated the means of every column (other than Activity and Participant).
~~~~
splitActivity <- function(participant) {
    activities <- split.data.frame(participant, participant$Activity)
    lapply(activities, activityColMeans)
}
participants <- split.data.frame(initialDataSet, initialDataSet$Participant)
a <- lapply(participants, splitActivity)
~~~~

This produced a list of 30 (the participants) with each containing 6 observations (the activities). So from here I had to take this list and stitch up into a new data frame.
~~~~
newDF <- data.frame()
for (participant in 1:30) {
    for (activity in 1:6) {
        newDF <- bind_rows(newDF, theListof30[[participant]][[activity]])
    }
}
~~~~

This new data frame was then written out to a CSV file as the [summary_data_set](summary_data_set.csv).

## Generating the Data Sets
~~~~
> source('run_analysis.R')
--Retrieve Feature Data
--Removing unneeded Characters from Column Names
--Search for Column Names that have Mean or Std in them
> run_analysis()
UCI HAR Analysis v1.1.0
-Creating the Initial Data Set
--Creating Data Frame from Test Data
----Subsetting Data Frame to Remove Columns that Don't Deal with Mean or Std
--Creating Data Frame from Training Data
----Subsetting Data Frame to Remove Columns that Don't Deal with Mean or Std
--Combining Test and Training Data Frames into One
--Applying Activity Labels to Activity Column
--Creating CSV file initial_data_set.csv
-Collapsing Initial Data Frame by Participant and Activity
--Creating CSV file summary_data_set.csv
~~~~

## About run_analysis.R
The main driver of the script is the function *run_analysis()*. This creates the initial data set (*createInitialDataSet()*) and summary data set (*createParticipantAcitivitySummaryDataSet(initialDataSet)*). 

Other functions of interest:
 * _createTrainingDataSet_ - Creates a data frame from the training data.
 * _createTestDataSet_ - Creates a data frame from the test data.
 * _createDataSet_ - This is the work horse to create the data frames referenced in the two function listed above. Takes the paths to the X_, y_, and subject_ files referenced in the test/ and train/ folders.
 * _tidyHARData_ - This function subsets the columns in the data frame to remove those columns that don't relate to mean and standard deviation.
 * _mutateActivityLabels_ - This applies the activity factor to the Activity column to change the numeric values of activities to their human readable forms.

