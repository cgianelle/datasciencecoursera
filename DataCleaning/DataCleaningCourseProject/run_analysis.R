UCI_HAR_DATASET_PATH <- 'UCI_HAR_Dataset'
UCI_HAR_FEATURES <- paste(UCI_HAR_DATASET_PATH,"/features.txt",sep = "")
UCI_HAR_ACTIVITY_LABELS <- paste(UCI_HAR_DATASET_PATH,"/activity_labels.txt",
                                 sep = "")

TRAIN_DATA_PATH <- 'UCI_HAR_Dataset/train'
XTRAIN_DATA_PATH <- paste(TRAIN_DATA_PATH,"/X_train.txt",sep = "")
YTRAIN_DATA_PATH <- paste(TRAIN_DATA_PATH,"/y_train.txt",sep = "")
SUBJECTTRAIN_DATA_PATH <- paste(TRAIN_DATA_PATH,"/subject_train.txt",sep = "")

TEST_DATA_PATH <- 'UCI_HAR_Dataset/test'
XTEST_DATA_PATH <- paste(TEST_DATA_PATH,"/X_test.txt",sep = "")
YTEST_DATA_PATH <- paste(TEST_DATA_PATH,"/y_test.txt",sep = "")
SUBJECTTEST_DATA_PATH <- paste(TEST_DATA_PATH,"/subject_test.txt",sep = "")

library(dplyr)

message("--Retrieve Feature Data")
features <- read.table(UCI_HAR_FEATURES)
#Get the column indices that we want to keep
message("--Search for Column Names that have Mean or Std in them")
colNum <- grep("mean|std", features$V2)
#Get the names of the columns
colNam <- grep("mean|std", features$V2, value = TRUE)
#clean the column names
#convert to all lower case
colNam <- tolower(colNam)
message("--Removing unneeded Characters from Column Names")
#remove the () from the names
colNam <- gsub('\\(|\\)', '', colNam)


# Reads the features file, locates the column indicies that contain mean and std.
# Then taking that information, subsets the data to contain only those indicies 
# and then renames the columns to the tidied version produced here.
tidyHARData <- function(data) {
    message("----Subsetting Data Frame to Remove Columns that Don't Deal with Mean or Std")
    newData <- data[,colNum]
    message("----Applying New Column Names")
    names(newData) <-colNam
    return(newData)
}

createDataSet <- function(x_data_path, y_data_path, subject_data_path) {
    #this will create a dataframe with 561 columns - this is the actual data
    #defer renaming column names until after the merge
    XData <- read.table(x_data_path)
    XData <- tidyHARData(XData)
    
    #This will create a dataframe of 1 column - this is activity
    #The column name will be V1, needs to be renamed to "Activity"
    YData <- read.table(y_data_path)
    YData <- rename(YData, Activity = V1)
    
    #This will create a dataframe of 1 column - this is the participant
    #The column name will be V1, needs to be renamed to "Participant"
    SubjectData <- read.table(subject_data_path)
    SubjectData <- rename(SubjectData, Participant = V1)
    
    #Combine these as column to generate the test dataset
    har.data.set <- cbind(SubjectData, YData, XData)
    return(har.data.set)
}

#Take the subject_train.txt, X_train.txt, and the y_train.txt and create a 
#single data frame representing the training data
createTrainingDataSet <- function() {
    message("--Creating Data Frame from Training Data")
    return(createDataSet(XTRAIN_DATA_PATH, 
                         YTRAIN_DATA_PATH, 
                         SUBJECTTRAIN_DATA_PATH))
}

#Take the subject_test.txt, X_test.txt, and the y_test.txt and create a 
#single data frame representing the test data
createTestDataSet <- function() {
    message("--Creating Data Frame from Test Data")
    return(createDataSet(XTEST_DATA_PATH, 
                         YTEST_DATA_PATH, 
                         SUBJECTTEST_DATA_PATH))
}

#Bind the test and the training data frames into one
#
createHARDataSet <- function(test, train) {
    message("--Combining test and training data frames into one")
    return(bind_rows(test, train))
}

#from activity_labels.txt,
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING
#This will change the numeric values to their string equivalents
mutateActivityLabels <- function(harDataSet) {
    message("--Applying Activity Labels to Activity Column")
    al <- read.table(UCI_HAR_ACTIVITY_LABELS)
    return(mutate(harDataSet, 
                  Activity = factor(Activity, 
                                    labels = al$V2)))
}

#Take the resulting data set, order it by participant and then write the data 
#frame out to a CSV file.
presentToTheWorld <- function(theDataSet, fileName) {
    message(paste("--Creating CSV file", fileName))
    write.csv(theDataSet, file = fileName, row.names = FALSE)
}

#Processes the HAR data files and produces a single data set that covers both 
#the test and training data as it pertains to anything related to mean or std.
createInitialDataSet <- function() {
    message("-Creating the Initial Data Set")
    testDF <- createTestDataSet()
    trainDF <- createTrainingDataSet()
    
    #Do the column widths of the data frames match?
    if (ncol(testDF) == ncol(trainDF)) {
        harDF <- createHARDataSet(testDF, trainDF)
        harDF <- mutateActivityLabels(harDF)
        harDF <- arrange(harDF,
                              as.numeric(as.character(harDF$Participant)),
                              as.character(harDF$Activity))
        
    } else {
        message("ERROR: The train and test data sets do not have the same number of
                columns.")
    }
}

#Using the initial data set, create a new data set that calculates the mean of 
#each variable per acticity for the user. So instead of 
#Participant   Activity   Variable X .....
#    1         WALKING       #
#    1         WALKING       #
#    1         WALKING       #
#    1         STANDING      #
#    1         STANDING      #
#    1         STANDING      #
#          ....
#    2         LAYING        #
#    2         LAYING        #
#    2         LAYING        #
#    2         STANDING      #
#    2         STANDING      #
#          ....
#Create this
#Participant   Activity   Variable X .....
#    1         WALKING       mean of X
#    1         STANDING      mean of X
#          ....
#    2         LAYING        mean of X
#    2         STANDING      mean of X
#          ....
createParticipantAcitivitySummaryDataSet <- function(initialDataSet) {
    #For each participant
    #   For each Activity
    #       Calculate the mean of every column
    activityColMeans <- function(activity) {
        print(class(activity))
        colMeans(activity)
    }
    
    splitActivity <- function(participant) {
        activities <- split.data.frame(participant, participant$Activity)
        lapply(activities, activityColMeans)
    }
    participants <- split.data.frame(initialDataSet, initialDataSet$Participant)
    lapply(participants, splitActivity)
    
}


run_analysis <- function() {
    cwd <- getwd()
    setwd(cwd)
    
    if (file.exists(UCI_HAR_DATASET_PATH)) {
        message("UCI HAR Analysis v1.1.0")
        harDF <- createInitialDataSet()
        presentToTheWorld(harDF, "initial_data_set.csv")
        
        #Create the train and test data frames so that we can merge them into 1
    } else {
        message("Unable to locate UCI_HAR_Dataset. See README.md for separate 
                instructions for downloading and configuring dataset")
    }
}

#source('run_analysis.R')
#run_analysis()
