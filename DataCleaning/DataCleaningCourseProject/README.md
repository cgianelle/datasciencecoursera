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
The "data" is a database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone (Samsung Galaxy S2) with embedded inertial sensors (accelerometer and gyroscope). These subjects were divided into two classifications: test and training. 30% of participants were selected to participate in the _test_ group and the other 70% were choosen for the _training_ group (so, 9 and 21   respectively).

### Getting the Data
~~~~
$ cd ~/Documents/datasciencecoursera/DataCleaning/DataCleaningCourseProject/
$ wget https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
$ unzip getdata%2Fprojectfiles%2FUCI\ HAR\ Dataset.zip
$ mv UCI\ HAR\ Dataset/ UCI_HAR_Dataset/
~~~~



