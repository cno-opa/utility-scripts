# Transforms KPI matrix into format for FME/Open Performance upload
# Conor Gaffney, 2015
#
#
# Desired output format:
#
# | IndicatorID | StrategyID | Organization     | Name                  | Type  | RowID | Date       | Year | Quarter | DateLabel | Total | Percent |
# | ----------- | ---------- | ---------------- | --------------------- | ----- | ----- | ---------- | ---- | ------- | --------- | ----- | ------- |
# | 602         | 40201      | Code Enforcement | Number of Inspections | Count | 1     | mm/dd/yyyy | 2011 | 1       | 2011, Q1  | 7030  | 0.85    |
#
#

.libPaths("C:\\Rpackages")
require(gdata)
require(reshape2)

kpi <- read.xls("kpi-matrix.xlsx", header = TRUE, sheet = "Measures", na.strings = c("", "#N/A", "NA", "N/A", "-", " -", "- ", " - ", "#DIV/0!", "REF!"), strip.white = TRUE, perl = "C:/Strawberry/perl/bin/perl.exe")
historic <- read.xls("kpi-matrix.xlsx", header = TRUE, sheet = "Seasonality-Historic\ Data", na.strings = c("", "#N/A", "NA", "N/A", "-", " -", "- ", " - ", "#DIV/0!", "REF!"), strip.white = TRUE, perl = "C:/Strawberry/perl/bin/perl.exe")

## This handles the 2015 sheet

current <- data.frame(IndicatorID  = gsub("-", "0", kpi$Index),
                     StrategyID   = gsub(".", "0", kpi$Strategic.Alignment..adjust.for.2015., fixed = TRUE),
                     Organization = kpi$Org,
                     Name         = kpi$Measure.1,
                     Type         = kpi$Variable.Type,
                     Q1           = kpi$Q1.Actual,
                     Q2           = kpi$Q2.Actual,
                     Q3           = kpi$Q3.Actual,
                     Q4           = kpi$Q4.Actual)

current <-melt(current, id.vars = c("IndicatorID", "StrategyID", "Organization", "Name", "Type"))

current$RowID <- row.names(current)
current$Date <- NA
current$Year <- NA
current$Quarter <- NA
current$DateLabel <- NA
current$Total <- NA
current$Percent <- NA

for(i in 1:nrow(current)) {
  q <- current$variable[i]
  y <- 2015
  if(q == "Q1") {
    current$Date[i] <- paste(y, "03-31", sep = "-")
  } else if (q == "Q2") {
    current$Date[i] <- paste(y, "06-30", sep = "-")
  } else if (q == "Q3") {
    current$Date[i] <- paste(y, "09-30", sep = "-")
  } else if (q == "Q4") {
    current$Date[i] <- paste(y, "12-31", sep = "-")
  } else {
    NA
  }
  current$Year[i] <- y
  current$Quarter[i] <- gsub("Q", "", q)
  current$DateLabel[i] <- paste(y, q, sep = ", ")

  if( grepl("percent", tolower(current$Type[i])) ) {
    current$Percent[i] <- current$value[i]
  } else {
    current$Total[i] <- current$value[i]
  }
}


# current$variable <- NULL
# current$value <- NULL

## This handles the historic data sheet

past <- data.frame(IndicatorID  = gsub("-", "0", historic$Index),
                   StrategyID   = NA,
                   Organization = historic$Org,
                   Name         = historic$Measure.1,
                   Type         = NA,
                   X2011_Q1     = historic$X2011.Q1.Actual,
                   X2011_Q2     = historic$X2011.Q2.Actual,
                   X2011_Q3     = historic$X2011.Q3.Actual,
                   X2011_Q4     = historic$X2011.Q4.Actual,
                   X2012_Q1     = historic$X2012.Q1.Actual,
                   X2012_Q2     = historic$X2012.Q2.Actual,
                   X2012_Q3     = historic$X2012.Q3.Actual,
                   X2012_Q4     = historic$X2012.Q4.Actual,
                   X2013_Q1     = historic$X2013.Q1.Actual,
                   X2013_Q2     = historic$X2013.Q2.Actual,
                   X2013_Q3     = historic$X2013.Q3.Actual,
                   X2013_Q4     = historic$X2013.Q4.Actual,
                   X2014_Q1     = historic$X2014.Q1.Actual,
                   X2014_Q2     = historic$X2014.Q2.Actual,
                   X2014_Q3     = historic$X2014.Q3.Actual,
                   X2014_Q4     = historic$X2014.Q4.Actual)

past <-melt(past, id.vars = c("IndicatorID", "StrategyID", "Organization", "Name", "Type"))

past$RowID <- row.names(past)
past$variable <- as.character(past$variable)
past$Date <- NA
past$Year <- NA
past$Quarter <- NA
past$DateLabel <- NA
past$Total <- NA
past$Percent <- NA

for(i in 1:nrow(past)) {
  q <- strsplit(past$variable[i], "_")[[1]][2]
  y <- gsub("X", "", strsplit(past$variable[i], "_")[[1]][1])

  if(q == "Q1") {
    past$Date[i] <- paste(y, "03-31", sep = "-")
  } else if (q == "Q2") {
    past$Date[i] <- paste(y, "06-30", sep = "-")
  } else if (q == "Q3") {
    past$Date[i] <- paste(y, "09-30", sep = "-")
  } else if (q == "Q4") {
    past$Date[i] <- paste(y, "12-31", sep = "-")
  } else {
    NA
  }

  past$Year[i] <- y
  past$Quarter[i] <- gsub("Q", "", q)
  past$DateLabel[i] <- paste(y, q, sep = ", ")

  if( grepl("percent", tolower(past$Name[i])) | grepl("rate", tolower(past$Name[i])) ) {
    past$Percent[i] <- past$value[i]
  } else {
    past$Total[i] <- past$value[i]
  }
}

# past$variable <- NULL
# past$value <- NULL

# save
output <- rbind(current, past)
write.csv(output, file = "kpi-matrix-transformed.csv", row.names = FALSE)
