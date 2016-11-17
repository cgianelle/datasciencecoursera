#Quiz 3
question1 <- function() {
    # The American Community Survey distributes downloadable data about United 
    # States communities. Download the 2006 microdata survey about housing for 
    # the state of Idaho using download.file() from here:
    #     
    #     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
    # 
    # and load the data into R. The code book, describing the variable names is 
    # here:
    #     
    #     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
    # 
    # Create a logical vector that identifies the households on greater than 10 
    # acres who sold more than $10,000 worth of agriculture products. Assign that 
    # logical vector to the variable agricultureLogical. Apply the which() 
    # function like this to identify the rows of the data frame where the logical 
    # vector is TRUE.
    
    amCommData <- read.csv("amCommSurvey2.csv", stringsAsFactors = FALSE)
    #Create the logical vector that identifies the rows where these conditions
    # are true
    agricultureLogical <- amCommData$ACR == 3 & amCommData$AGS == 6
    print(which(agricultureLogical))
}

question2 <- function() {
    # Using the jpeg package read in the following picture of your instructor into 
    # R
    # 
    # https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
    # 
    # Use the parameter native=TRUE. What are the 30th and 80th quantiles of the 
    # resulting data? (some Linux systems may produce an answer 638 different for 
    #                  the 30th quantile)
    library(jpeg)
    jeff <- readJPEG("jeff.jpg", native = TRUE)
    print(quantile(jeff, probs = c(0.3, 0.8)))
}

question3 <- function() {
    # Load the Gross Domestic Product data for the 190 ranked countries in this 
    # data set:
    #     
    #     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
    # 
    # Load the educational data from this data set:
    #     
    #     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
    # 
    # Match the data based on the country shortcode. How many of the IDs match? 
    # Sort the data frame in descending order by GDP rank (so United States is 
    # last). What is the 13th country in the resulting data frame?
    # 
    # Original data sources:
    #     
    #     http://data.worldbank.org/data-catalog/GDP-ranking-table
    # 
    # http://data.worldbank.org/data-catalog/ed-stats 
    # Answers:
    # 190 matches, 13th country is St. Kitts and Nevis
    # 
    # 234 matches, 13th country is Spain
    # 
    # 189 matches, 13th country is St. Kitts and Nevis
    # 
    # 234 matches, 13th country is St. Kitts and Nevis
    # 
    # 190 matches, 13th country is Spain
    # 
    # 189 matches, 13th country is Spain
    
    #I removed the countries that had no GDP values from the gdp file
    #as I could not get the results that lined up with the choices above
    library(dplyr)
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv", method="curl")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "educational.csv", method="curl")
    gdp <- read.csv("gdp.csv", stringsAsFactors = FALSE)
    gdp <- gdp[-c(1:4, 195:330),]
    educational <- read.csv("educational.csv", stringsAsFactors = FALSE)
    newGdp <- rename(gdp, CountryCode = X, Economy = X.2, GDP = X.3, 
                     RANKING = Gross.domestic.product.2012)
    mergedData <- inner_join(newGdp, educational, by = "CountryCode")
    sortedData <- arrange(mergedData,
                          desc(as.numeric(as.character(mergedData$RANKING))))
    print(nrow(sortedData))
    print(sortedData[13, "Economy"])
}

question4 <- function() {
    # What is the average GDP ranking for the "High income: OECD" and "High 
    # income: nonOECD" group?
    # 
    # 133.72973, 32.96667
    # 
    # 23.966667, 30.91304
    # 
    # 23, 45
    # 
    # 30, 37
    # 
    # 23, 30
    # 
    # 32.96667, 91.91304    
}

question5 <- function() {
    # Cut the GDP ranking into 5 separate quantile groups. Make a table 
    # versus Income.Group. How many countries
    # 
    # are Lower middle income but among the 38 nations with highest GDP?
    # 
    # 18
    # 
    # 5
    # 
    # 3
    # 
    # 0
    library(Hmisc)
    library(dplyr)
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "gdp.csv", method="curl")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "educational.csv", method="curl")
    gdp <- read.csv("gdp.csv", stringsAsFactors = FALSE)
    gdp <- gdp[-c(1:4, 195:330),]
    educational <- read.csv("educational.csv", stringsAsFactors = FALSE)
    newGdp <- rename(gdp, CountryCode = X, Economy = X.2, GDP = X.3, 
                     RANKING = Gross.domestic.product.2012)
    mergedData <- inner_join(newGdp, educational, by = "CountryCode")
    
    mergedData$RankingGroups = cut2(as.numeric(as.character(mergedData$RANKING)), g=5)
    table(mergedData$RankingGroups, mergedData$Income.Group)
}