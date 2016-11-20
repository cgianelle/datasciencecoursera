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
 
For the purposes of this project, only the mean and standard deviation (std) were of interest.

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


## Generating the Initial Data Set
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

