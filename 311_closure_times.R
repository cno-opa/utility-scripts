library(dplyr)

# Read table from working directory
data.311 <- read.csv("data.311.csv")

# Reformat date closed  from factor to date
data.311$CLOSED.DT <- as.Date(data.311$CLOSED.DT, format = "%m/%d/%Y")

# Reformat age in calendar days from factor to integer
data.311$AGE..CALENDAR. <- as.integer(data.311$AGE..CALENDAR.)

# Discard unused columns, remove open cases, take subset of cases closed after August 2014
data.311.clean <- data.311 %>%
  select(reference = CASE.REFERENCE, type = TYPE, closed = CLOSED.DT, age = AGE..CALENDAR.) %>%
  filter(!is.na(closed) & closed >= "2014-9-1") %>%
  arrange(type, desc(closed), desc(age)) %>%
  group_by(type) %>%
  summarise(mean = mean(age), median = median(age), eightieth = quantile(age, .8))

for (type in levels(data.311.clean$type)) {
  age_by_type <- data.311.clean[data.311.clean$type == type,]
  
  if(length(age_by_type$age) > 0) {
    
    # Display summary statistics for each metric
    print(type)
    print(round(summary(age_by_type$age)), 0)
    
    # Define variables to be used in histogram
    percentile <- round(quantile(age_by_type$age, c(.7, .8, .9), 0))
    average <- round(mean(age_by_type$age), 0)
    median <- round(median(age_by_type$age), 0)
    
    # Create histogram of number of days to close for each metric
    hist(age_by_type$age, breaks = 10, main = type, xlab = "Number of days to close", ylab = "Number of cases")
    abline(v = average, col = "red")
    legend("topright", c(paste("Average = ", average),
                         paste("Median = ", median),
                         paste("70th percentile = ", percentile[1]),
                         paste("80th percentile = ", percentile[2]),
                         paste("90th percentile = ", percentile[3])))
    
    # Provide explanation for 311 types with too few cases
  } else {
    print(paste(type, " - Not enough cases"))
  }
}