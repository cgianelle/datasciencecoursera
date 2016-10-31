question1 <- function() {
    idaho <- read.csv("idahoHousing.csv", stringsAsFactors = FALSE)
    value1 <- idaho[!is.na(idaho$VAL), ]
    val <- value1[value1$VAL > 23, ]
    print(nrow(val))
}

question3 <- function() {
    library(openxlsx)
    colIndex <- 7:15
    rowIndex <- 18:23
    dat <- read.xlsx("nga.xlsx", rows = rowIndex, cols = colIndex)
    print(sum(dat$Zip*dat$Ext,na.rm=T))
}

question4 <- function() {
    library(XML)
    doc <- xmlTreeParse("restaurants.xml",useInternal=TRUE)
    root <- xmlRoot(doc)
    zipCodes <- xpathSApply(root, "//zipcode", xmlValue)
    print(length(zipCodes[zipCodes == "21231"]))
}
