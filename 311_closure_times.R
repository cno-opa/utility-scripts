library(dplyr)

# Read table from OPA shared drive
data.311 <- read.csv("O:/Projects/QualityofLifeSTAT/311 Closure Times/data.311.csv")

# Reformat date closed  from factor to date
data.311$CLOSED.DT <- as.Date(data.311$CLOSED.DT, format = "%m/%d/%Y")

# Reformat age in calendar days from factor to integer
data.311$AGE..CALENDAR. <- as.integer(data.311$AGE..CALENDAR.)

# Discard unused columns, remove open cases, take subset of cases closed after August 2014
data.311.clean <- data.311 %>%
  select(reference = CASE.REFERENCE, type = TYPE, closed = CLOSED.DT, age = AGE..CALENDAR.) %>%
  filter(!is.na(closed) & closed >= "2014-9-1") %>%
  arrange(type, desc(closed), desc(age))

summary_table <- data.311.clean %>%
  group_by(type) %>%
  summarise(mean = round(mean(age), 0), median = round(median(age), 0), eightieth = round(quantile(age, .8), 0))

print(as.data.frame(summary_table))

# Create subset for each type of 311 issue
for (type in levels(data.311.clean$type)) {
  age_by_type <- data.311.clean[data.311.clean$type == type,]
  
  # Identify 311 issues with zero records
  if(length(age_by_type$age) > 0) {
    
    # Define variables to be used in histogram
    percentile <- round(quantile(age_by_type$age, c(.7, .8, .9), 0))
    average <- round(mean(age_by_type$age), 0)
    median <- round(median(age_by_type$age), 0)
    
    # Create histogram of number of days to close for each metric
    hg <- hist(age_by_type$age, main = type, xlab = "Number of days to close", ylab = "Number of cases")
    
    abline(v = percentile[2], col = "red")
    text(x = percentile[2], y = max(hg$counts) * 0.7, pos = 4, labels = paste("80th %\n=", percentile[2]), col = "red", font = 2)
    
    abline(v = average, col = "blue")
    text(x = average, y = max(hg$counts) * 0.9, pos = 4, labels = paste("Avg.\n=", average), col = "blue", font = 2)
    
    # Provide explanation for 311 types with too few cases
  } else {
    print(paste(type, "- Not enough cases"))
  }
}