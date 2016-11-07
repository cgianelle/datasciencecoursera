#question 1
#in Chrome open https://api.github.com/users/jtleek/repos
# search for '"name": "datasharing"'
# in the datasharing json section, search for the created_at field

#question 2 and question 3 were answered by previous knowledge of SQL syntax

question4 <- function() {
    con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
    htmlCode = readLines(con)
    close(con)
    print(nchar(htmlCode[10]))
    print(nchar(htmlCode[20]))
    print(nchar(htmlCode[30]))
    print(nchar(htmlCode[100]))
}

question5 <- function() {
    #What is the sum of the 4th of 9 columns
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", 
                  "fixedWithFile.for", method="curl")
    #The -1 in the widths argument says there is a one-character column that 
    #should be ignored,the -5 in the widths argument says there is a 
    #five-character column that should be ignored, likewise...
    #skip says to skip the first 4 lines in the file
    data <- read.fwf("fixedWithFile.for", skip=4, 
                     widths = c(-1,9,-5,4,4,-5,4,4,-5,4,4))
    print(sum(data[4]))
}