---
title: "311 Request Closure Times"
author: "Office of Performance and Accountability"
date: "September 24, 2015"
output: pdf_document
---

```{r, include = FALSE, message = FALSE}
library(dplyr)
library(ggplot2)
library(grDevices)

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
```

```{r, echo = FALSE, results = "asis"}
# Create subset for each type of 311 issue
for (type in levels(data.311.clean$type)) {
  age_by_type <- data.311.clean[data.311.clean$type == type,]
  
  # Identify 311 issues with zero records
  if(length(age_by_type$age) > 0) {
    
    # Define variables to be used in histogram
    percentile <- round(quantile(age_by_type$age, .8), 0)
    average <- round(mean(age_by_type$age), 0)
    median <- round(median(age_by_type$age), 0)
    
    hg <- ggplot(data = age_by_type, aes(x = age)) +
      geom_histogram(binwidth = 30, fill = "white", colour = "black")
            
    hgplot <- hg +
      geom_vline(xintercept = average, linetype = "dashed", colour = "blue") +
      geom_vline(xintercept = percentile, linetype = "dashed", colour = "red") +
      
      annotate("text", x = average, y = max(ggplot_build(hg)$panel$ranges[[1]]$y.range) * 0.9, label = paste("Avg. =", average), colour = "blue", fontface = "bold") +
      annotate("text", x = percentile, y = max(ggplot_build(hg)$panel$ranges[[1]]$y.range) * 0.7, label = paste("80th =", percentile), colour = "red", fontface = "bold") +
            
      ggtitle(type) +
      xlab("Number of days to close") +
      ylab("Number of cases")
    
    cat("\n\n\\pagebreak\n")
    print(hgplot)
    cat("\n\n\\pagebreak\n")

  } else {
    
    cat("\n\n\\pagebreak\n")
    paste(type, "Not enough cases")
    cat("\n\n\\pagebreak\n")
    
  }

}
```