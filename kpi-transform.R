# Transforms KPI matrix into format for FME/Open Performance upload
# Conor Gaffney and Vic Spencer, 2015
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
library(gdata)
library(reshape2)
library(dplyr)

## Read KPI matrix sheets
kpi <- read.xls("O:/Projects/ResultsNOLA/2015/2015 KPI Matrix MASTER.xlsx", header = TRUE, sheet = "Measures", na.strings = c("", "#N/A", "NA", "N/A", "-", " -", "- ", " - ", "#DIV/0!", "REF!"), strip.white = TRUE, perl = "C:/Strawberry/perl/bin/perl.exe")
historic <- read.xls("O:/Projects/ResultsNOLA/2015/2015 KPI Matrix MASTER.xlsx", header = TRUE, sheet = "Seasonality-Historic\ Data", na.strings = c("", "#N/A", "NA", "N/A", "-", " -", "- ", " - ", "#DIV/0!", "REF!"), strip.white = TRUE, perl = "C:/Strawberry/perl/bin/perl.exe")

## This handles the 2015 sheet

current <- data.frame(IndicatorID  = gsub("-", "0", kpi$Index),
                     StrategyID   = gsub(".", "0", kpi$X2015.Strategic.Alignment, fixed = TRUE),
                     Organization = kpi$Org,
                     Name         = kpi$Measure.1,
                     Type         = kpi$Variable.Type,
                     Q1           = kpi$Q1.Total,
                     Q2           = kpi$Q2.Total,
                     Q3           = kpi$Q3.Total,
                     Q4           = kpi$Q4.Total,
                     YTD          = kpi$Q2.YTD,
                     Target       = kpi$X2015.Target,
                     Seasonality  = kpi$Seasonality,
                     Direction    = kpi$Direction)

current <-melt(current, id.vars = c("IndicatorID", "StrategyID", "Organization", "Name", "Type","YTD","Target","Seasonality","Direction"))

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


# clear
# current$variable <- NULL
# current$value <- NULL

## This handles the historic data sheet

past <- data.frame(IndicatorID  = gsub("-", "0", historic$Index),
                   StrategyID   = gsub(".", "0", historic$X2015.Strategic.Alignment, fixed = TRUE),
                   Organization = historic$Org,
                   Name         = historic$Measure.1,
                   Type         = historic$Variable.Type,
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
                   X2014_Q4     = historic$X2014.Q4.Actual,
                   Target       = historic$X2015.Target,
                   YTD          = historic$Q2.YTD,
                   Seasonality  = historic$Seasonality,
                   Direction    = historic$Direction)

past <-melt(past, id.vars = c("IndicatorID", "StrategyID", "Organization", "Name", "Type","YTD","Target","Seasonality","Direction"))

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

# combine current year and historical years into one data frame
output <- rbind(current, past)
##output<-merge(current,past,by="IndicatorID",all.x="TRUE")
##output<-inner_join(current,past,by="IndicatorID")

# Multiply Percent column by 100 to make it readable on OpenGov site, then incorporate new percent values into value column
class(output$Percent)<-"numeric"
class(output$value)<-"numeric"
output$Percent<-round(output$Percent*100,1)
output$value<-ifelse(!is.na(output$Percent),output$Percent,output$value)

# Concatenate Name and Date columns to replace RowID column
output$RowID<-paste(output$Name,output$Date,sep="_")

# Remove variable column
output<-select(output,-variable)

# Create "Action-Aggregation" variable to categorize measures into the appropriate "action" and "aggregation" needed for formatting data for Socrata dashboard
output$Action_Aggregation<-ifelse(output$Type=="Average" & output$Direction=="Under"|output$Type=="Average Percent" & output$Direction=="Under"|output$Type=="Count" & output$Direction=="Under"|output$Type=="Last" & output$Direction=="Under","Maintain Below",
                                  ifelse(output$Type=="Count" & output$Direction=="Over"|output$Type=="Last" & output$Direction=="Over","Increase to",
                                         ifelse(output$Type=="Average" & output$Direction=="Over"|output$Type=="Average Percent" & output$Direction=="Over","Maintain Above","Measure")))
output$Action_Aggregation<-ifelse(is.na(output$Action_Aggregation),"Measure",output$Action_Aggregation)  ## This codes "Establishing Baseline" or "Management Statistic" measures as "Measure," which the above ifelse does not.

# save
write.csv(output, file = "O:/Projects/ResultsNOLA/2015/kpi-matrix-transformed.csv", row.names = FALSE)

